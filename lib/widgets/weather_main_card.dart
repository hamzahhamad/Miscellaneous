import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/weather_models.dart';
import '../theme/app_theme.dart';

class WeatherMainCard extends StatelessWidget {
  const WeatherMainCard({
    super.key,
    required this.weatherData,
    required this.location,
  });

  final WeatherData weatherData;
  final Location location;

  @override
  Widget build(BuildContext context) {
    final current = weatherData.current;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 60), // Account for app bar
          
          // Location
          Text(
            location.name ?? 'Current Location',
            style: AppTheme.locationStyle.copyWith(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          // Current time
          Text(
            DateFormat('EEEE, MMM d').format(DateTime.now()),
            style: AppTheme.locationStyle.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 40),
          
          // Weather icon (placeholder)
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Icon(
              _getWeatherIcon(current.condition.icon),
              size: 60,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Temperature
          Text(
            '${current.temperature.round()}°',
            style: AppTheme.temperatureStyle,
          ),
          
          const SizedBox(height: 8),
          
          // Condition
          Text(
            current.condition.description,
            style: AppTheme.conditionStyle,
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // Feels like and high/low
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Feels like ${current.feelsLike.round()}°',
                style: AppTheme.locationStyle,
              ),
            ],
          ),
          
          const Spacer(),
          
          // Quick stats
          _buildQuickStats(current),
        ],
      ),
    );
  }

  Widget _buildQuickStats(CurrentWeather weather) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Icons.water_drop_outlined,
            '${weather.humidity.round()}%',
            'Humidity',
          ),
          _buildStatItem(
            Icons.air,
            '${weather.windSpeed.round()} km/h',
            'Wind',
          ),
          _buildStatItem(
            Icons.visibility_outlined,
            '${(weather.visibility / 1000).round()} km',
            'Visibility',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.white70,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTheme.detailValueStyle.copyWith(fontSize: 14),
        ),
        Text(
          label,
          style: AppTheme.detailLabelStyle.copyWith(fontSize: 12),
        ),
      ],
    );
  }

  IconData _getWeatherIcon(String iconCode) {
    switch (iconCode.toLowerCase()) {
      case 'clear_day':
        return Icons.wb_sunny;
      case 'clear_night':
        return Icons.nightlight_round;
      case 'partly_cloudy':
        return Icons.wb_cloudy;
      case 'cloudy':
        return Icons.cloud;
      case 'fog':
        return Icons.foggy;
      case 'drizzle':
        return Icons.grain;
      case 'rain':
        return Icons.rainy;
      case 'snow':
        return Icons.ac_unit;
      case 'thunderstorm':
        return Icons.thunderstorm;
      default:
        return Icons.wb_sunny;
    }
  }
}