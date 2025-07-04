import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/weather_models.dart';

abstract class WeatherApiService {
  Future<WeatherData> getWeatherData(Location location);
  Future<CurrentWeather> getCurrentWeather(Location location);
  Future<List<HourlyForecast>> getHourlyForecast(Location location);
  Future<List<DailyForecast>> getDailyForecast(Location location);
  Future<List<WeatherAlert>> getWeatherAlerts(Location location);
  Future<AirQuality?> getAirQuality(Location location);
}

class MultiSourceWeatherService implements WeatherApiService {
  final Dio _dio;
  final List<WeatherApiSource> _enabledSources;
  
  MultiSourceWeatherService({
    Dio? dio,
    List<WeatherApiSource>? enabledSources,
  }) : _dio = dio ?? Dio(),
        _enabledSources = enabledSources ?? [
          WeatherApiSource.openMeteo,
          WeatherApiSource.noaaService,
          WeatherApiSource.metNorway,
          WeatherApiSource.openWeatherMap,
        ] {
    _configureDio();
  }

  void _configureDio() {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'User-Agent': 'WeatherForecastApp/1.0 (contact@weatherapp.com)',
        'Accept': 'application/json',
      },
    );

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: false,
        responseBody: false,
        logPrint: (object) => debugPrint(object.toString()),
      ));
    }
  }

  @override
  Future<WeatherData> getWeatherData(Location location) async {
    try {
      // Fetch data from all available sources
      final futures = <Future<Map<String, dynamic>?>>[];
      
      for (final source in _enabledSources) {
        futures.add(_fetchFromSource(source, location));
      }
      
      final results = await Future.wait(futures);
      final validResults = results.where((result) => result != null).toList();
      
      if (validResults.isEmpty) {
        throw WeatherException('No weather data available from any source');
      }

      // Blend the results
      final blendedData = _blendWeatherData(validResults.cast<Map<String, dynamic>>());
      
      return WeatherData(
        current: blendedData['current'] as CurrentWeather,
        hourly: (blendedData['hourly'] as List).cast<HourlyForecast>(),
        daily: (blendedData['daily'] as List).cast<DailyForecast>(),
        alerts: (blendedData['alerts'] as List).cast<WeatherAlert>(),
        airQuality: blendedData['airQuality'] as AirQuality?,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      throw WeatherException('Failed to fetch weather data: $e');
    }
  }

  Future<Map<String, dynamic>?> _fetchFromSource(
    WeatherApiSource source,
    Location location,
  ) async {
    try {
      switch (source) {
        case WeatherApiSource.openMeteo:
          return await _fetchOpenMeteoData(location);
        case WeatherApiSource.noaaService:
          return await _fetchNoaaData(location);
        case WeatherApiSource.metNorway:
          return await _fetchMetNorwayData(location);
        case WeatherApiSource.openWeatherMap:
          return await _fetchOpenWeatherMapData(location);
        case WeatherApiSource.weatherbit:
          return await _fetchWeatherbitData(location);
      }
    } catch (e) {
      debugPrint('Error fetching from ${source.name}: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> _fetchOpenMeteoData(Location location) async {
    final response = await _dio.get(
      '${WeatherApiSource.openMeteo.baseUrl}/forecast',
      queryParameters: {
        'latitude': location.latitude,
        'longitude': location.longitude,
        'current': 'temperature_2m,relative_humidity_2m,apparent_temperature,'
                  'is_day,precipitation,rain,showers,snowfall,weather_code,'
                  'cloud_cover,pressure_msl,surface_pressure,wind_speed_10m,'
                  'wind_direction_10m,wind_gusts_10m',
        'hourly': 'temperature_2m,relative_humidity_2m,apparent_temperature,'
                 'precipitation_probability,precipitation,rain,showers,snowfall,'
                 'weather_code,pressure_msl,surface_pressure,cloud_cover,'
                 'visibility,evapotranspiration,et0_fao_evapotranspiration,'
                 'vapour_pressure_deficit,wind_speed_10m,wind_direction_10m,'
                 'wind_gusts_10m,temperature_80m,soil_temperature_0cm,'
                 'soil_temperature_6cm,soil_moisture_0_1cm,soil_moisture_1_3cm',
        'daily': 'weather_code,temperature_2m_max,temperature_2m_min,'
                'apparent_temperature_max,apparent_temperature_min,'
                'sunrise,sunset,daylight_duration,sunshine_duration,'
                'uv_index_max,uv_index_clear_sky_max,precipitation_sum,'
                'rain_sum,showers_sum,snowfall_sum,precipitation_hours,'
                'precipitation_probability_max,wind_speed_10m_max,'
                'wind_gusts_10m_max,wind_direction_10m_dominant,'
                'shortwave_radiation_sum,et0_fao_evapotranspiration',
        'timezone': 'auto',
        'forecast_days': 10,
      },
    );

    return _parseOpenMeteoResponse(response.data, location);
  }

  Future<Map<String, dynamic>?> _fetchNoaaData(Location location) async {
    // NOAA/NWS only works for US locations
    if (!_isUSLocation(location)) return null;

    try {
      // First, get the grid point
      final pointResponse = await _dio.get(
        '${WeatherApiSource.noaaService.baseUrl}/points/${location.latitude},${location.longitude}',
      );

      final gridData = pointResponse.data['properties'];
      final gridX = gridData['gridX'];
      final gridY = gridData['gridY'];
      final office = gridData['gridId'];

      // Get forecast data
      final forecastResponse = await _dio.get(
        '${WeatherApiSource.noaaService.baseUrl}/gridpoints/$office/$gridX,$gridY/forecast',
      );

      final hourlyResponse = await _dio.get(
        '${WeatherApiSource.noaaService.baseUrl}/gridpoints/$office/$gridX,$gridY/forecast/hourly',
      );

      return _parseNoaaResponse(forecastResponse.data, hourlyResponse.data, location);
    } catch (e) {
      debugPrint('NOAA API error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> _fetchMetNorwayData(Location location) async {
    try {
      final response = await _dio.get(
        '${WeatherApiSource.metNorway.baseUrl}/locationforecast/2.0/complete',
        queryParameters: {
          'lat': location.latitude,
          'lon': location.longitude,
        },
      );

      return _parseMetNorwayResponse(response.data, location);
    } catch (e) {
      debugPrint('MET Norway API error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> _fetchOpenWeatherMapData(Location location) async {
    // Note: This requires an API key for production use
    // For demo purposes, we'll skip this or use a demo key
    try {
      const apiKey = 'YOUR_OPENWEATHERMAP_API_KEY'; // Replace with actual key
      if (apiKey == 'YOUR_OPENWEATHERMAP_API_KEY') return null;

      final response = await _dio.get(
        '${WeatherApiSource.openWeatherMap.baseUrl}/onecall',
        queryParameters: {
          'lat': location.latitude,
          'lon': location.longitude,
          'appid': apiKey,
          'units': 'metric',
          'exclude': 'minutely',
        },
      );

      return _parseOpenWeatherMapResponse(response.data, location);
    } catch (e) {
      debugPrint('OpenWeatherMap API error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> _fetchWeatherbitData(Location location) async {
    // Note: This requires an API key for production use
    try {
      const apiKey = 'YOUR_WEATHERBIT_API_KEY'; // Replace with actual key
      if (apiKey == 'YOUR_WEATHERBIT_API_KEY') return null;

      final currentResponse = await _dio.get(
        '${WeatherApiSource.weatherbit.baseUrl}/current',
        queryParameters: {
          'lat': location.latitude,
          'lon': location.longitude,
          'key': apiKey,
        },
      );

      final forecastResponse = await _dio.get(
        '${WeatherApiSource.weatherbit.baseUrl}/forecast/daily',
        queryParameters: {
          'lat': location.latitude,
          'lon': location.longitude,
          'key': apiKey,
          'days': 10,
        },
      );

      return _parseWeatherbitResponse(currentResponse.data, forecastResponse.data, location);
    } catch (e) {
      debugPrint('Weatherbit API error: $e');
      return null;
    }
  }

  bool _isUSLocation(Location location) {
    // Rough check for US coordinates
    return location.latitude >= 24.0 && location.latitude <= 49.0 &&
           location.longitude >= -125.0 && location.longitude <= -66.0;
  }

  Map<String, dynamic> _parseOpenMeteoResponse(Map<String, dynamic> data, Location location) {
    final current = data['current'];
    final hourly = data['hourly'];
    final daily = data['daily'];

    return {
      'source': WeatherApiSource.openMeteo,
      'current': CurrentWeather(
        temperature: current['temperature_2m']?.toDouble() ?? 0.0,
        feelsLike: current['apparent_temperature']?.toDouble() ?? 0.0,
        humidity: current['relative_humidity_2m']?.toDouble() ?? 0.0,
        pressure: current['pressure_msl']?.toDouble() ?? 0.0,
        windSpeed: current['wind_speed_10m']?.toDouble() ?? 0.0,
        windDirection: current['wind_direction_10m']?.toDouble() ?? 0.0,
        windGust: current['wind_gusts_10m']?.toDouble() ?? 0.0,
        visibility: 10000.0, // Default visibility
        uvIndex: 0.0, // Not available in current
        cloudCover: current['cloud_cover']?.toDouble() ?? 0.0,
        dewPoint: _calculateDewPoint(
          current['temperature_2m']?.toDouble() ?? 0.0,
          current['relative_humidity_2m']?.toDouble() ?? 0.0,
        ),
        condition: WeatherCondition(
          main: _getWeatherConditionFromCode(current['weather_code'] ?? 0),
          description: _getWeatherDescriptionFromCode(current['weather_code'] ?? 0),
          icon: _getWeatherIconFromCode(current['weather_code'] ?? 0),
          code: current['weather_code'] ?? 0,
        ),
        timestamp: DateTime.parse(current['time']),
        sunrise: DateTime.parse(daily['sunrise'][0]),
        sunset: DateTime.parse(daily['sunset'][0]),
        location: location,
        confidence: 0.95, // High confidence for Open-Meteo
        sources: [WeatherApiSource.openMeteo.name],
      ),
      'hourly': _parseOpenMeteoHourly(hourly, location),
      'daily': _parseOpenMeteoDaily(daily, location),
      'alerts': <WeatherAlert>[],
      'airQuality': null,
    };
  }

  List<HourlyForecast> _parseOpenMeteoHourly(Map<String, dynamic> hourly, Location location) {
    final times = (hourly['time'] as List).cast<String>();
    final temperatures = (hourly['temperature_2m'] as List).cast<double?>();
    final feelsLike = (hourly['apparent_temperature'] as List).cast<double?>();
    final humidity = (hourly['relative_humidity_2m'] as List).cast<double?>();
    final precipitationProb = (hourly['precipitation_probability'] as List?)?.cast<double?>() ?? [];
    final precipitation = (hourly['precipitation'] as List).cast<double?>();
    final windSpeed = (hourly['wind_speed_10m'] as List).cast<double?>();
    final windDirection = (hourly['wind_direction_10m'] as List).cast<double?>();
    final weatherCodes = (hourly['weather_code'] as List).cast<int?>();
    final cloudCover = (hourly['cloud_cover'] as List).cast<double?>();

    final forecasts = <HourlyForecast>[];
    final maxHours = 24; // Limit to next 24 hours

    for (int i = 0; i < times.length && i < maxHours; i++) {
      forecasts.add(HourlyForecast(
        time: DateTime.parse(times[i]),
        temperature: temperatures[i] ?? 0.0,
        feelsLike: feelsLike[i] ?? 0.0,
        humidity: humidity[i] ?? 0.0,
        precipitationProbability: (precipitationProb.isNotEmpty && i < precipitationProb.length) 
            ? precipitationProb[i] ?? 0.0 : 0.0,
        precipitationAmount: precipitation[i] ?? 0.0,
        windSpeed: windSpeed[i] ?? 0.0,
        windDirection: windDirection[i] ?? 0.0,
        condition: WeatherCondition(
          main: _getWeatherConditionFromCode(weatherCodes[i] ?? 0),
          description: _getWeatherDescriptionFromCode(weatherCodes[i] ?? 0),
          icon: _getWeatherIconFromCode(weatherCodes[i] ?? 0),
          code: weatherCodes[i] ?? 0,
        ),
        cloudCover: cloudCover[i] ?? 0.0,
        uvIndex: 0.0, // Not available in hourly
        confidence: 0.95,
        sources: [WeatherApiSource.openMeteo.name],
      ));
    }

    return forecasts;
  }

  List<DailyForecast> _parseOpenMeteoDaily(Map<String, dynamic> daily, Location location) {
    final times = (daily['time'] as List).cast<String>();
    final tempMax = (daily['temperature_2m_max'] as List).cast<double?>();
    final tempMin = (daily['temperature_2m_min'] as List).cast<double?>();
    final weatherCodes = (daily['weather_code'] as List).cast<int?>();
    final uvIndex = (daily['uv_index_max'] as List).cast<double?>();
    final precipitation = (daily['precipitation_sum'] as List).cast<double?>();
    final precipitationProb = (daily['precipitation_probability_max'] as List?)?.cast<double?>() ?? [];
    final sunrise = (daily['sunrise'] as List).cast<String>();
    final sunset = (daily['sunset'] as List).cast<String>();

    final forecasts = <DailyForecast>[];

    for (int i = 0; i < times.length && i < 10; i++) {
      forecasts.add(DailyForecast(
        date: DateTime.parse(times[i]),
        temperatureMax: tempMax[i] ?? 0.0,
        temperatureMin: tempMin[i] ?? 0.0,
        temperatureMorning: tempMin[i] ?? 0.0, // Approximation
        temperatureDay: tempMax[i] ?? 0.0,
        temperatureEvening: (tempMax[i] ?? 0.0 + tempMin[i] ?? 0.0) / 2,
        temperatureNight: tempMin[i] ?? 0.0,
        feelsLikeDay: tempMax[i] ?? 0.0,
        feelsLikeNight: tempMin[i] ?? 0.0,
        humidity: 0.0, // Not available in daily
        precipitationProbability: (precipitationProb.isNotEmpty && i < precipitationProb.length) 
            ? precipitationProb[i] ?? 0.0 : 0.0,
        precipitationAmount: precipitation[i] ?? 0.0,
        windSpeed: 0.0, // Not available in basic daily
        windDirection: 0.0,
        condition: WeatherCondition(
          main: _getWeatherConditionFromCode(weatherCodes[i] ?? 0),
          description: _getWeatherDescriptionFromCode(weatherCodes[i] ?? 0),
          icon: _getWeatherIconFromCode(weatherCodes[i] ?? 0),
          code: weatherCodes[i] ?? 0,
        ),
        uvIndex: uvIndex[i] ?? 0.0,
        sunrise: DateTime.parse(sunrise[i]),
        sunset: DateTime.parse(sunset[i]),
        confidence: 0.95,
        sources: [WeatherApiSource.openMeteo.name],
      ));
    }

    return forecasts;
  }

  Map<String, dynamic>? _parseNoaaResponse(
    Map<String, dynamic> forecastData,
    Map<String, dynamic> hourlyData,
    Location location,
  ) {
    // Implementation for NOAA data parsing
    // This would be quite complex due to NOAA's unique format
    return null; // Simplified for now
  }

  Map<String, dynamic>? _parseMetNorwayResponse(Map<String, dynamic> data, Location location) {
    // Implementation for MET Norway data parsing
    return null; // Simplified for now
  }

  Map<String, dynamic>? _parseOpenWeatherMapResponse(Map<String, dynamic> data, Location location) {
    // Implementation for OpenWeatherMap data parsing
    return null; // Simplified for now
  }

  Map<String, dynamic>? _parseWeatherbitResponse(
    Map<String, dynamic> currentData,
    Map<String, dynamic> forecastData,
    Location location,
  ) {
    // Implementation for Weatherbit data parsing
    return null; // Simplified for now
  }

  Map<String, dynamic> _blendWeatherData(List<Map<String, dynamic>> sourceData) {
    if (sourceData.isEmpty) {
      throw WeatherException('No valid data sources available');
    }

    if (sourceData.length == 1) {
      return sourceData.first;
    }

    // Use the first available source as the base
    final baseData = sourceData.first;
    
    // For now, return the base data
    // In production, implement sophisticated blending algorithms
    return baseData;
  }

  // Helper methods for weather code conversion
  String _getWeatherConditionFromCode(int code) {
    switch (code) {
      case 0: return 'Clear';
      case 1:
      case 2:
      case 3: return 'Cloudy';
      case 45:
      case 48: return 'Fog';
      case 51:
      case 53:
      case 55: return 'Drizzle';
      case 56:
      case 57: return 'Freezing Drizzle';
      case 61:
      case 63:
      case 65: return 'Rain';
      case 66:
      case 67: return 'Freezing Rain';
      case 71:
      case 73:
      case 75: return 'Snow';
      case 77: return 'Snow Grains';
      case 80:
      case 81:
      case 82: return 'Rain Showers';
      case 85:
      case 86: return 'Snow Showers';
      case 95: return 'Thunderstorm';
      case 96:
      case 99: return 'Thunderstorm with Hail';
      default: return 'Unknown';
    }
  }

  String _getWeatherDescriptionFromCode(int code) {
    switch (code) {
      case 0: return 'Clear sky';
      case 1: return 'Mainly clear';
      case 2: return 'Partly cloudy';
      case 3: return 'Overcast';
      default: return _getWeatherConditionFromCode(code);
    }
  }

  String _getWeatherIconFromCode(int code) {
    switch (code) {
      case 0: return 'clear_day';
      case 1:
      case 2: return 'partly_cloudy';
      case 3: return 'cloudy';
      case 45:
      case 48: return 'fog';
      case 51:
      case 53:
      case 55:
      case 56:
      case 57: return 'drizzle';
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82: return 'rain';
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86: return 'snow';
      case 95:
      case 96:
      case 99: return 'thunderstorm';
      default: return 'clear_day';
    }
  }

  double _calculateDewPoint(double temperature, double humidity) {
    final a = 17.27;
    final b = 237.7;
    final alpha = ((a * temperature) / (b + temperature)) + math.log(humidity / 100.0);
    return (b * alpha) / (a - alpha);
  }

  @override
  Future<CurrentWeather> getCurrentWeather(Location location) async {
    final data = await getWeatherData(location);
    return data.current;
  }

  @override
  Future<List<HourlyForecast>> getHourlyForecast(Location location) async {
    final data = await getWeatherData(location);
    return data.hourly;
  }

  @override
  Future<List<DailyForecast>> getDailyForecast(Location location) async {
    final data = await getWeatherData(location);
    return data.daily;
  }

  @override
  Future<List<WeatherAlert>> getWeatherAlerts(Location location) async {
    final data = await getWeatherData(location);
    return data.alerts;
  }

  @override
  Future<AirQuality?> getAirQuality(Location location) async {
    final data = await getWeatherData(location);
    return data.airQuality;
  }
}

class WeatherException implements Exception {
  final String message;
  const WeatherException(this.message);
  
  @override
  String toString() => 'WeatherException: $message';
}