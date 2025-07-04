import 'dart:math' as math;
import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'weather_models.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class Location {
  @HiveField(0)
  final double latitude;
  
  @HiveField(1)
  final double longitude;
  
  @HiveField(2)
  final String? name;
  
  @HiveField(3)
  final String? country;
  
  @HiveField(4)
  final String? state;

  const Location({
    required this.latitude,
    required this.longitude,
    this.name,
    this.country,
    this.state,
  });

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);

  @override
  String toString() => name ?? '$latitude, $longitude';
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}

@JsonSerializable()
@HiveType(typeId: 1)
class WeatherCondition {
  @HiveField(0)
  final String main;
  
  @HiveField(1)
  final String description;
  
  @HiveField(2)
  final String icon;
  
  @HiveField(3)
  final int code;

  const WeatherCondition({
    required this.main,
    required this.description,
    required this.icon,
    required this.code,
  });

  factory WeatherCondition.fromJson(Map<String, dynamic> json) => 
      _$WeatherConditionFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherConditionToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 2)
class CurrentWeather {
  @HiveField(0)
  final double temperature;
  
  @HiveField(1)
  final double feelsLike;
  
  @HiveField(2)
  final double humidity;
  
  @HiveField(3)
  final double pressure;
  
  @HiveField(4)
  final double windSpeed;
  
  @HiveField(5)
  final double windDirection;
  
  @HiveField(6)
  final double windGust;
  
  @HiveField(7)
  final double visibility;
  
  @HiveField(8)
  final double uvIndex;
  
  @HiveField(9)
  final double cloudCover;
  
  @HiveField(10)
  final double dewPoint;
  
  @HiveField(11)
  final WeatherCondition condition;
  
  @HiveField(12)
  final DateTime timestamp;
  
  @HiveField(13)
  final DateTime sunrise;
  
  @HiveField(14)
  final DateTime sunset;
  
  @HiveField(15)
  final Location location;
  
  @HiveField(16)
  final double confidence;
  
  @HiveField(17)
  final List<String> sources;

  const CurrentWeather({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windDirection,
    required this.windGust,
    required this.visibility,
    required this.uvIndex,
    required this.cloudCover,
    required this.dewPoint,
    required this.condition,
    required this.timestamp,
    required this.sunrise,
    required this.sunset,
    required this.location,
    required this.confidence,
    required this.sources,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) => 
      _$CurrentWeatherFromJson(json);
  Map<String, dynamic> toJson() => _$CurrentWeatherToJson(this);

  CurrentWeather copyWith({
    double? temperature,
    double? feelsLike,
    double? humidity,
    double? pressure,
    double? windSpeed,
    double? windDirection,
    double? windGust,
    double? visibility,
    double? uvIndex,
    double? cloudCover,
    double? dewPoint,
    WeatherCondition? condition,
    DateTime? timestamp,
    DateTime? sunrise,
    DateTime? sunset,
    Location? location,
    double? confidence,
    List<String>? sources,
  }) {
    return CurrentWeather(
      temperature: temperature ?? this.temperature,
      feelsLike: feelsLike ?? this.feelsLike,
      humidity: humidity ?? this.humidity,
      pressure: pressure ?? this.pressure,
      windSpeed: windSpeed ?? this.windSpeed,
      windDirection: windDirection ?? this.windDirection,
      windGust: windGust ?? this.windGust,
      visibility: visibility ?? this.visibility,
      uvIndex: uvIndex ?? this.uvIndex,
      cloudCover: cloudCover ?? this.cloudCover,
      dewPoint: dewPoint ?? this.dewPoint,
      condition: condition ?? this.condition,
      timestamp: timestamp ?? this.timestamp,
      sunrise: sunrise ?? this.sunrise,
      sunset: sunset ?? this.sunset,
      location: location ?? this.location,
      confidence: confidence ?? this.confidence,
      sources: sources ?? this.sources,
    );
  }
}

@JsonSerializable()
@HiveType(typeId: 3)
class HourlyForecast {
  @HiveField(0)
  final DateTime time;
  
  @HiveField(1)
  final double temperature;
  
  @HiveField(2)
  final double feelsLike;
  
  @HiveField(3)
  final double humidity;
  
  @HiveField(4)
  final double precipitationProbability;
  
  @HiveField(5)
  final double precipitationAmount;
  
  @HiveField(6)
  final double windSpeed;
  
  @HiveField(7)
  final double windDirection;
  
  @HiveField(8)
  final WeatherCondition condition;
  
  @HiveField(9)
  final double cloudCover;
  
  @HiveField(10)
  final double uvIndex;
  
  @HiveField(11)
  final double confidence;
  
  @HiveField(12)
  final List<String> sources;

  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.precipitationProbability,
    required this.precipitationAmount,
    required this.windSpeed,
    required this.windDirection,
    required this.condition,
    required this.cloudCover,
    required this.uvIndex,
    required this.confidence,
    required this.sources,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) => 
      _$HourlyForecastFromJson(json);
  Map<String, dynamic> toJson() => _$HourlyForecastToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 4)
class DailyForecast {
  @HiveField(0)
  final DateTime date;
  
  @HiveField(1)
  final double temperatureMax;
  
  @HiveField(2)
  final double temperatureMin;
  
  @HiveField(3)
  final double temperatureMorning;
  
  @HiveField(4)
  final double temperatureDay;
  
  @HiveField(5)
  final double temperatureEvening;
  
  @HiveField(6)
  final double temperatureNight;
  
  @HiveField(7)
  final double feelsLikeDay;
  
  @HiveField(8)
  final double feelsLikeNight;
  
  @HiveField(9)
  final double humidity;
  
  @HiveField(10)
  final double precipitationProbability;
  
  @HiveField(11)
  final double precipitationAmount;
  
  @HiveField(12)
  final double windSpeed;
  
  @HiveField(13)
  final double windDirection;
  
  @HiveField(14)
  final WeatherCondition condition;
  
  @HiveField(15)
  final double uvIndex;
  
  @HiveField(16)
  final DateTime sunrise;
  
  @HiveField(17)
  final DateTime sunset;
  
  @HiveField(18)
  final double confidence;
  
  @HiveField(19)
  final List<String> sources;

  const DailyForecast({
    required this.date,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.temperatureMorning,
    required this.temperatureDay,
    required this.temperatureEvening,
    required this.temperatureNight,
    required this.feelsLikeDay,
    required this.feelsLikeNight,
    required this.humidity,
    required this.precipitationProbability,
    required this.precipitationAmount,
    required this.windSpeed,
    required this.windDirection,
    required this.condition,
    required this.uvIndex,
    required this.sunrise,
    required this.sunset,
    required this.confidence,
    required this.sources,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) => 
      _$DailyForecastFromJson(json);
  Map<String, dynamic> toJson() => _$DailyForecastToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 5)
class WeatherAlert {
  @HiveField(0)
  final String title;
  
  @HiveField(1)
  final String description;
  
  @HiveField(2)
  final String severity;
  
  @HiveField(3)
  final DateTime startTime;
  
  @HiveField(4)
  final DateTime endTime;
  
  @HiveField(5)
  final String source;

  const WeatherAlert({
    required this.title,
    required this.description,
    required this.severity,
    required this.startTime,
    required this.endTime,
    required this.source,
  });

  factory WeatherAlert.fromJson(Map<String, dynamic> json) => 
      _$WeatherAlertFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherAlertToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 6)
class AirQuality {
  @HiveField(0)
  final int aqi;
  
  @HiveField(1)
  final double pm25;
  
  @HiveField(2)
  final double pm10;
  
  @HiveField(3)
  final double o3;
  
  @HiveField(4)
  final double no2;
  
  @HiveField(5)
  final double so2;
  
  @HiveField(6)
  final double co;

  const AirQuality({
    required this.aqi,
    required this.pm25,
    required this.pm10,
    required this.o3,
    required this.no2,
    required this.so2,
    required this.co,
  });

  factory AirQuality.fromJson(Map<String, dynamic> json) => 
      _$AirQualityFromJson(json);
  Map<String, dynamic> toJson() => _$AirQualityToJson(this);

  String get qualityDescription {
    switch (aqi) {
      case 1:
        return 'Good';
      case 2:
        return 'Fair';
      case 3:
        return 'Moderate';
      case 4:
        return 'Poor';
      case 5:
        return 'Very Poor';
      default:
        return 'Unknown';
    }
  }
}

@JsonSerializable()
@HiveType(typeId: 7)
class WeatherData {
  @HiveField(0)
  final CurrentWeather current;
  
  @HiveField(1)
  final List<HourlyForecast> hourly;
  
  @HiveField(2)
  final List<DailyForecast> daily;
  
  @HiveField(3)
  final List<WeatherAlert> alerts;
  
  @HiveField(4)
  final AirQuality? airQuality;
  
  @HiveField(5)
  final DateTime lastUpdated;

  const WeatherData({
    required this.current,
    required this.hourly,
    required this.daily,
    required this.alerts,
    this.airQuality,
    required this.lastUpdated,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) => 
      _$WeatherDataFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherDataToJson(this);

  WeatherData copyWith({
    CurrentWeather? current,
    List<HourlyForecast>? hourly,
    List<DailyForecast>? daily,
    List<WeatherAlert>? alerts,
    AirQuality? airQuality,
    DateTime? lastUpdated,
  }) {
    return WeatherData(
      current: current ?? this.current,
      hourly: hourly ?? this.hourly,
      daily: daily ?? this.daily,
      alerts: alerts ?? this.alerts,
      airQuality: airQuality ?? this.airQuality,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

enum WeatherApiSource {
  openMeteo,
  noaaService,
  metNorway,
  openWeatherMap,
  weatherbit,
}

extension WeatherApiSourceExtension on WeatherApiSource {
  String get name {
    switch (this) {
      case WeatherApiSource.openMeteo:
        return 'Open-Meteo';
      case WeatherApiSource.noaaService:
        return 'NOAA/NWS';
      case WeatherApiSource.metNorway:
        return 'MET Norway';
      case WeatherApiSource.openWeatherMap:
        return 'OpenWeatherMap';
      case WeatherApiSource.weatherbit:
        return 'Weatherbit';
    }
  }

  String get baseUrl {
    switch (this) {
      case WeatherApiSource.openMeteo:
        return 'https://api.open-meteo.com/v1';
      case WeatherApiSource.noaaService:
        return 'https://api.weather.gov';
      case WeatherApiSource.metNorway:
        return 'https://api.met.no/weatherapi';
      case WeatherApiSource.openWeatherMap:
        return 'https://api.openweathermap.org/data/2.5';
      case WeatherApiSource.weatherbit:
        return 'https://api.weatherbit.io/v2.0';
    }
  }
}

// Confidence calculation utilities
class ConfidenceCalculator {
  static double calculateForecastConfidence(List<Map<String, dynamic>> forecasts) {
    if (forecasts.length <= 1) return 0.5;
    
    // Calculate temperature variance
    final temperatures = forecasts
        .map((f) => f['temperature'] as double)
        .toList();
    
    final mean = temperatures.reduce((a, b) => a + b) / temperatures.length;
    final variance = temperatures
        .map((temp) => (temp - mean) * (temp - mean))
        .reduce((a, b) => a + b) / temperatures.length;
    
    // Lower variance = higher confidence
    final standardDeviation = variance > 0 ? math.sqrt(variance) : 0;
    
    // Normalize confidence (0.0 to 1.0)
    // Assuming 5°C standard deviation = 0% confidence, 0°C = 100% confidence
    final confidence = math.max(0.0, 1.0 - (standardDeviation / 5.0));
    
    return confidence;
  }
  
  static double blendTemperatures(List<Map<String, dynamic>> forecasts) {
    if (forecasts.isEmpty) return 0.0;
    
    // Weighted average based on source reliability
    double totalWeight = 0.0;
    double weightedSum = 0.0;
    
    for (final forecast in forecasts) {
      final source = forecast['source'] as WeatherApiSource;
      final temperature = forecast['temperature'] as double;
      final weight = _getSourceWeight(source);
      
      weightedSum += temperature * weight;
      totalWeight += weight;
    }
    
    return totalWeight > 0 ? weightedSum / totalWeight : 0.0;
  }
  
  static double _getSourceWeight(WeatherApiSource source) {
    switch (source) {
      case WeatherApiSource.openMeteo:
        return 1.0; // Highest weight - free and accurate
      case WeatherApiSource.noaaService:
        return 0.95; // Very high for US locations
      case WeatherApiSource.metNorway:
        return 0.9; // High for European locations
      case WeatherApiSource.openWeatherMap:
        return 0.8; // Good baseline
      case WeatherApiSource.weatherbit:
        return 0.7; // Lower weight
    }
  }
}