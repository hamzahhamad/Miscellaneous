import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/weather_models.dart';
import '../theme/app_theme.dart';

class WeatherDetailCard extends StatelessWidget {
  const WeatherDetailCard({
    super.key,
    required this.currentWeather,
    this.airQuality,
  });

  final CurrentWeather currentWeather;
  final AirQuality? airQuality;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Weather details grid
          _buildWeatherDetailsGrid(),
          
          const SizedBox(height: 16),
          
          // Air quality card (if available)
          if (airQuality != null) _buildAirQualityCard(),
          
          const SizedBox(height: 16),
          
          // Sun times card
          _buildSunTimesCard(),
        ],
      ),
    );
  }

  Widget _buildWeatherDetailsGrid() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Weather Details',
                style: AppTheme.sectionHeaderStyle,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  'Feels Like',
                  '${currentWeather.feelsLike.round()}°',
                  Icons.thermostat,
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  'Humidity',
                  '${currentWeather.humidity.round()}%',
                  Icons.water_drop,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  'Wind Speed',
                  '${currentWeather.windSpeed.round()} km/h',
                  Icons.air,
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  'Pressure',
                  '${currentWeather.pressure.round()} hPa',
                  Icons.speed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  'UV Index',
                  currentWeather.uvIndex.round().toString(),
                  Icons.wb_sunny,
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  'Cloud Cover',
                  '${currentWeather.cloudCover.round()}%',
                  Icons.cloud,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  'Dew Point',
                  '${currentWeather.dewPoint.round()}°',
                  Icons.water,
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  'Visibility',
                  '${(currentWeather.visibility / 1000).round()} km',
                  Icons.visibility,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.white70,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTheme.detailLabelStyle.copyWith(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTheme.detailValueStyle.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildAirQualityCard() {
    if (airQuality == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.air,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Air Quality',
                style: AppTheme.sectionHeaderStyle,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'AQI: ${airQuality!.aqi}',
                style: AppTheme.detailValueStyle.copyWith(fontSize: 18),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getAirQualityColor(airQuality!.aqi),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  airQuality!.qualityDescription,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'PM2.5: ${airQuality!.pm25.round()} μg/m³',
            style: AppTheme.detailLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildSunTimesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.wb_twilight,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Sun & Moon',
                style: AppTheme.sectionHeaderStyle,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSunTimeItem(
                  'Sunrise',
                  DateFormat('HH:mm').format(currentWeather.sunrise),
                  Icons.wb_sunny,
                ),
              ),
              Expanded(
                child: _buildSunTimeItem(
                  'Sunset',
                  DateFormat('HH:mm').format(currentWeather.sunset),
                  Icons.brightness_3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildDaylightProgress(),
        ],
      ),
    );
  }

  Widget _buildSunTimeItem(String label, String time, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.orange,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTheme.detailLabelStyle.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: AppTheme.detailValueStyle.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDaylightProgress() {
    final now = DateTime.now();
    final sunrise = currentWeather.sunrise;
    final sunset = currentWeather.sunset;
    
    double progress = 0.5; // Default to middle
    if (now.isAfter(sunrise) && now.isBefore(sunset)) {
      final totalDaylight = sunset.difference(sunrise).inMinutes;
      final elapsed = now.difference(sunrise).inMinutes;
      progress = elapsed / totalDaylight;
    } else if (now.isAfter(sunset)) {
      progress = 1.0;
    } else {
      progress = 0.0;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daylight',
              style: AppTheme.detailLabelStyle,
            ),
            Text(
              _getDaylightDuration(),
              style: AppTheme.detailValueStyle.copyWith(fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white.withOpacity(0.3),
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
          minHeight: 4,
        ),
      ],
    );
  }

  String _getDaylightDuration() {
    final duration = currentWeather.sunset.difference(currentWeather.sunrise);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  Color _getAirQualityColor(int aqi) {
    switch (aqi) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.red;
      case 5:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}