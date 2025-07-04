// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocationAdapter extends TypeAdapter<Location> {
  @override
  final int typeId = 0;

  @override
  Location read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Location(
      latitude: fields[0] as double,
      longitude: fields[1] as double,
      name: fields[2] as String?,
      country: fields[3] as String?,
      state: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Location obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.country)
      ..writeByte(4)
      ..write(obj.state);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WeatherConditionAdapter extends TypeAdapter<WeatherCondition> {
  @override
  final int typeId = 1;

  @override
  WeatherCondition read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeatherCondition(
      main: fields[0] as String,
      description: fields[1] as String,
      icon: fields[2] as String,
      code: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WeatherCondition obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.main)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.code);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherConditionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CurrentWeatherAdapter extends TypeAdapter<CurrentWeather> {
  @override
  final int typeId = 2;

  @override
  CurrentWeather read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrentWeather(
      temperature: fields[0] as double,
      feelsLike: fields[1] as double,
      humidity: fields[2] as double,
      pressure: fields[3] as double,
      windSpeed: fields[4] as double,
      windDirection: fields[5] as double,
      windGust: fields[6] as double,
      visibility: fields[7] as double,
      uvIndex: fields[8] as double,
      cloudCover: fields[9] as double,
      dewPoint: fields[10] as double,
      condition: fields[11] as WeatherCondition,
      timestamp: fields[12] as DateTime,
      sunrise: fields[13] as DateTime,
      sunset: fields[14] as DateTime,
      location: fields[15] as Location,
      confidence: fields[16] as double,
      sources: (fields[17] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, CurrentWeather obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.temperature)
      ..writeByte(1)
      ..write(obj.feelsLike)
      ..writeByte(2)
      ..write(obj.humidity)
      ..writeByte(3)
      ..write(obj.pressure)
      ..writeByte(4)
      ..write(obj.windSpeed)
      ..writeByte(5)
      ..write(obj.windDirection)
      ..writeByte(6)
      ..write(obj.windGust)
      ..writeByte(7)
      ..write(obj.visibility)
      ..writeByte(8)
      ..write(obj.uvIndex)
      ..writeByte(9)
      ..write(obj.cloudCover)
      ..writeByte(10)
      ..write(obj.dewPoint)
      ..writeByte(11)
      ..write(obj.condition)
      ..writeByte(12)
      ..write(obj.timestamp)
      ..writeByte(13)
      ..write(obj.sunrise)
      ..writeByte(14)
      ..write(obj.sunset)
      ..writeByte(15)
      ..write(obj.location)
      ..writeByte(16)
      ..write(obj.confidence)
      ..writeByte(17)
      ..write(obj.sources);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentWeatherAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HourlyForecastAdapter extends TypeAdapter<HourlyForecast> {
  @override
  final int typeId = 3;

  @override
  HourlyForecast read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HourlyForecast(
      time: fields[0] as DateTime,
      temperature: fields[1] as double,
      feelsLike: fields[2] as double,
      humidity: fields[3] as double,
      precipitationProbability: fields[4] as double,
      precipitationAmount: fields[5] as double,
      windSpeed: fields[6] as double,
      windDirection: fields[7] as double,
      condition: fields[8] as WeatherCondition,
      cloudCover: fields[9] as double,
      uvIndex: fields[10] as double,
      confidence: fields[11] as double,
      sources: (fields[12] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, HourlyForecast obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.temperature)
      ..writeByte(2)
      ..write(obj.feelsLike)
      ..writeByte(3)
      ..write(obj.humidity)
      ..writeByte(4)
      ..write(obj.precipitationProbability)
      ..writeByte(5)
      ..write(obj.precipitationAmount)
      ..writeByte(6)
      ..write(obj.windSpeed)
      ..writeByte(7)
      ..write(obj.windDirection)
      ..writeByte(8)
      ..write(obj.condition)
      ..writeByte(9)
      ..write(obj.cloudCover)
      ..writeByte(10)
      ..write(obj.uvIndex)
      ..writeByte(11)
      ..write(obj.confidence)
      ..writeByte(12)
      ..write(obj.sources);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HourlyForecastAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DailyForecastAdapter extends TypeAdapter<DailyForecast> {
  @override
  final int typeId = 4;

  @override
  DailyForecast read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyForecast(
      date: fields[0] as DateTime,
      temperatureMax: fields[1] as double,
      temperatureMin: fields[2] as double,
      temperatureMorning: fields[3] as double,
      temperatureDay: fields[4] as double,
      temperatureEvening: fields[5] as double,
      temperatureNight: fields[6] as double,
      feelsLikeDay: fields[7] as double,
      feelsLikeNight: fields[8] as double,
      humidity: fields[9] as double,
      precipitationProbability: fields[10] as double,
      precipitationAmount: fields[11] as double,
      windSpeed: fields[12] as double,
      windDirection: fields[13] as double,
      condition: fields[14] as WeatherCondition,
      uvIndex: fields[15] as double,
      sunrise: fields[16] as DateTime,
      sunset: fields[17] as DateTime,
      confidence: fields[18] as double,
      sources: (fields[19] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, DailyForecast obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.temperatureMax)
      ..writeByte(2)
      ..write(obj.temperatureMin)
      ..writeByte(3)
      ..write(obj.temperatureMorning)
      ..writeByte(4)
      ..write(obj.temperatureDay)
      ..writeByte(5)
      ..write(obj.temperatureEvening)
      ..writeByte(6)
      ..write(obj.temperatureNight)
      ..writeByte(7)
      ..write(obj.feelsLikeDay)
      ..writeByte(8)
      ..write(obj.feelsLikeNight)
      ..writeByte(9)
      ..write(obj.humidity)
      ..writeByte(10)
      ..write(obj.precipitationProbability)
      ..writeByte(11)
      ..write(obj.precipitationAmount)
      ..writeByte(12)
      ..write(obj.windSpeed)
      ..writeByte(13)
      ..write(obj.windDirection)
      ..writeByte(14)
      ..write(obj.condition)
      ..writeByte(15)
      ..write(obj.uvIndex)
      ..writeByte(16)
      ..write(obj.sunrise)
      ..writeByte(17)
      ..write(obj.sunset)
      ..writeByte(18)
      ..write(obj.confidence)
      ..writeByte(19)
      ..write(obj.sources);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyForecastAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WeatherAlertAdapter extends TypeAdapter<WeatherAlert> {
  @override
  final int typeId = 5;

  @override
  WeatherAlert read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeatherAlert(
      title: fields[0] as String,
      description: fields[1] as String,
      severity: fields[2] as String,
      startTime: fields[3] as DateTime,
      endTime: fields[4] as DateTime,
      source: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WeatherAlert obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.severity)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.endTime)
      ..writeByte(5)
      ..write(obj.source);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherAlertAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AirQualityAdapter extends TypeAdapter<AirQuality> {
  @override
  final int typeId = 6;

  @override
  AirQuality read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AirQuality(
      aqi: fields[0] as int,
      pm25: fields[1] as double,
      pm10: fields[2] as double,
      o3: fields[3] as double,
      no2: fields[4] as double,
      so2: fields[5] as double,
      co: fields[6] as double,
    );
  }

  @override
  void write(BinaryWriter writer, AirQuality obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.aqi)
      ..writeByte(1)
      ..write(obj.pm25)
      ..writeByte(2)
      ..write(obj.pm10)
      ..writeByte(3)
      ..write(obj.o3)
      ..writeByte(4)
      ..write(obj.no2)
      ..writeByte(5)
      ..write(obj.so2)
      ..writeByte(6)
      ..write(obj.co);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AirQualityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WeatherDataAdapter extends TypeAdapter<WeatherData> {
  @override
  final int typeId = 7;

  @override
  WeatherData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeatherData(
      current: fields[0] as CurrentWeather,
      hourly: (fields[1] as List).cast<HourlyForecast>(),
      daily: (fields[2] as List).cast<DailyForecast>(),
      alerts: (fields[3] as List).cast<WeatherAlert>(),
      airQuality: fields[4] as AirQuality?,
      lastUpdated: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WeatherData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.current)
      ..writeByte(1)
      ..write(obj.hourly)
      ..writeByte(2)
      ..write(obj.daily)
      ..writeByte(3)
      ..write(obj.alerts)
      ..writeByte(4)
      ..write(obj.airQuality)
      ..writeByte(5)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      name: json['name'] as String?,
      country: json['country'] as String?,
      state: json['state'] as String?,
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'name': instance.name,
      'country': instance.country,
      'state': instance.state,
    };

WeatherCondition _$WeatherConditionFromJson(Map<String, dynamic> json) =>
    WeatherCondition(
      main: json['main'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      code: json['code'] as int,
    );

Map<String, dynamic> _$WeatherConditionToJson(WeatherCondition instance) =>
    <String, dynamic>{
      'main': instance.main,
      'description': instance.description,
      'icon': instance.icon,
      'code': instance.code,
    };

CurrentWeather _$CurrentWeatherFromJson(Map<String, dynamic> json) =>
    CurrentWeather(
      temperature: (json['temperature'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      pressure: (json['pressure'] as num).toDouble(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      windDirection: (json['windDirection'] as num).toDouble(),
      windGust: (json['windGust'] as num).toDouble(),
      visibility: (json['visibility'] as num).toDouble(),
      uvIndex: (json['uvIndex'] as num).toDouble(),
      cloudCover: (json['cloudCover'] as num).toDouble(),
      dewPoint: (json['dewPoint'] as num).toDouble(),
      condition: WeatherCondition.fromJson(
          json['condition'] as Map<String, dynamic>),
      timestamp: DateTime.parse(json['timestamp'] as String),
      sunrise: DateTime.parse(json['sunrise'] as String),
      sunset: DateTime.parse(json['sunset'] as String),
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      confidence: (json['confidence'] as num).toDouble(),
      sources:
          (json['sources'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$CurrentWeatherToJson(CurrentWeather instance) =>
    <String, dynamic>{
      'temperature': instance.temperature,
      'feelsLike': instance.feelsLike,
      'humidity': instance.humidity,
      'pressure': instance.pressure,
      'windSpeed': instance.windSpeed,
      'windDirection': instance.windDirection,
      'windGust': instance.windGust,
      'visibility': instance.visibility,
      'uvIndex': instance.uvIndex,
      'cloudCover': instance.cloudCover,
      'dewPoint': instance.dewPoint,
      'condition': instance.condition,
      'timestamp': instance.timestamp.toIso8601String(),
      'sunrise': instance.sunrise.toIso8601String(),
      'sunset': instance.sunset.toIso8601String(),
      'location': instance.location,
      'confidence': instance.confidence,
      'sources': instance.sources,
    };

HourlyForecast _$HourlyForecastFromJson(Map<String, dynamic> json) =>
    HourlyForecast(
      time: DateTime.parse(json['time'] as String),
      temperature: (json['temperature'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      precipitationProbability:
          (json['precipitationProbability'] as num).toDouble(),
      precipitationAmount: (json['precipitationAmount'] as num).toDouble(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      windDirection: (json['windDirection'] as num).toDouble(),
      condition: WeatherCondition.fromJson(
          json['condition'] as Map<String, dynamic>),
      cloudCover: (json['cloudCover'] as num).toDouble(),
      uvIndex: (json['uvIndex'] as num).toDouble(),
      confidence: (json['confidence'] as num).toDouble(),
      sources:
          (json['sources'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$HourlyForecastToJson(HourlyForecast instance) =>
    <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'temperature': instance.temperature,
      'feelsLike': instance.feelsLike,
      'humidity': instance.humidity,
      'precipitationProbability': instance.precipitationProbability,
      'precipitationAmount': instance.precipitationAmount,
      'windSpeed': instance.windSpeed,
      'windDirection': instance.windDirection,
      'condition': instance.condition,
      'cloudCover': instance.cloudCover,
      'uvIndex': instance.uvIndex,
      'confidence': instance.confidence,
      'sources': instance.sources,
    };

DailyForecast _$DailyForecastFromJson(Map<String, dynamic> json) =>
    DailyForecast(
      date: DateTime.parse(json['date'] as String),
      temperatureMax: (json['temperatureMax'] as num).toDouble(),
      temperatureMin: (json['temperatureMin'] as num).toDouble(),
      temperatureMorning: (json['temperatureMorning'] as num).toDouble(),
      temperatureDay: (json['temperatureDay'] as num).toDouble(),
      temperatureEvening: (json['temperatureEvening'] as num).toDouble(),
      temperatureNight: (json['temperatureNight'] as num).toDouble(),
      feelsLikeDay: (json['feelsLikeDay'] as num).toDouble(),
      feelsLikeNight: (json['feelsLikeNight'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      precipitationProbability:
          (json['precipitationProbability'] as num).toDouble(),
      precipitationAmount: (json['precipitationAmount'] as num).toDouble(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      windDirection: (json['windDirection'] as num).toDouble(),
      condition: WeatherCondition.fromJson(
          json['condition'] as Map<String, dynamic>),
      uvIndex: (json['uvIndex'] as num).toDouble(),
      sunrise: DateTime.parse(json['sunrise'] as String),
      sunset: DateTime.parse(json['sunset'] as String),
      confidence: (json['confidence'] as num).toDouble(),
      sources:
          (json['sources'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$DailyForecastToJson(DailyForecast instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'temperatureMax': instance.temperatureMax,
      'temperatureMin': instance.temperatureMin,
      'temperatureMorning': instance.temperatureMorning,
      'temperatureDay': instance.temperatureDay,
      'temperatureEvening': instance.temperatureEvening,
      'temperatureNight': instance.temperatureNight,
      'feelsLikeDay': instance.feelsLikeDay,
      'feelsLikeNight': instance.feelsLikeNight,
      'humidity': instance.humidity,
      'precipitationProbability': instance.precipitationProbability,
      'precipitationAmount': instance.precipitationAmount,
      'windSpeed': instance.windSpeed,
      'windDirection': instance.windDirection,
      'condition': instance.condition,
      'uvIndex': instance.uvIndex,
      'sunrise': instance.sunrise.toIso8601String(),
      'sunset': instance.sunset.toIso8601String(),
      'confidence': instance.confidence,
      'sources': instance.sources,
    };

WeatherAlert _$WeatherAlertFromJson(Map<String, dynamic> json) => WeatherAlert(
      title: json['title'] as String,
      description: json['description'] as String,
      severity: json['severity'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      source: json['source'] as String,
    );

Map<String, dynamic> _$WeatherAlertToJson(WeatherAlert instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'severity': instance.severity,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'source': instance.source,
    };

AirQuality _$AirQualityFromJson(Map<String, dynamic> json) => AirQuality(
      aqi: json['aqi'] as int,
      pm25: (json['pm25'] as num).toDouble(),
      pm10: (json['pm10'] as num).toDouble(),
      o3: (json['o3'] as num).toDouble(),
      no2: (json['no2'] as num).toDouble(),
      so2: (json['so2'] as num).toDouble(),
      co: (json['co'] as num).toDouble(),
    );

Map<String, dynamic> _$AirQualityToJson(AirQuality instance) =>
    <String, dynamic>{
      'aqi': instance.aqi,
      'pm25': instance.pm25,
      'pm10': instance.pm10,
      'o3': instance.o3,
      'no2': instance.no2,
      'so2': instance.so2,
      'co': instance.co,
    };

WeatherData _$WeatherDataFromJson(Map<String, dynamic> json) => WeatherData(
      current:
          CurrentWeather.fromJson(json['current'] as Map<String, dynamic>),
      hourly: (json['hourly'] as List<dynamic>)
          .map((e) => HourlyForecast.fromJson(e as Map<String, dynamic>))
          .toList(),
      daily: (json['daily'] as List<dynamic>)
          .map((e) => DailyForecast.fromJson(e as Map<String, dynamic>))
          .toList(),
      alerts: (json['alerts'] as List<dynamic>)
          .map((e) => WeatherAlert.fromJson(e as Map<String, dynamic>))
          .toList(),
      airQuality: json['airQuality'] == null
          ? null
          : AirQuality.fromJson(json['airQuality'] as Map<String, dynamic>),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$WeatherDataToJson(WeatherData instance) =>
    <String, dynamic>{
      'current': instance.current,
      'hourly': instance.hourly,
      'daily': instance.daily,
      'alerts': instance.alerts,
      'airQuality': instance.airQuality,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };