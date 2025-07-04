import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/weather_models.dart';
import '../theme/app_theme.dart';

class DailyForecastCard extends StatelessWidget {
  const DailyForecastCard({
    super.key,
    required this.dailyData,
  });

  final List<DailyForecast> dailyData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
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
                Icons.calendar_today,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '10-Day Forecast',
                style: AppTheme.sectionHeaderStyle,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...dailyData.take(10).map((forecast) => _buildDailyItem(forecast)),
        ],
      ),
    );
  }

  Widget _buildDailyItem(DailyForecast forecast) {
    final isToday = forecast.date.day == DateTime.now().day;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Day
          SizedBox(
            width: 60,
            child: Text(
              isToday ? 'Today' : DateFormat('EEE').format(forecast.date),
              style: AppTheme.detailValueStyle.copyWith(fontSize: 14),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Weather icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _getWeatherIcon(forecast.condition.icon),
              size: 18,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Precipitation
          if (forecast.precipitationProbability > 0)
            SizedBox(
              width: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.water_drop,
                    size: 12,
                    color: Colors.lightBlue,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${forecast.precipitationProbability.round()}%',
                    style: AppTheme.detailLabelStyle.copyWith(
                      fontSize: 12,
                      color: Colors.lightBlue,
                    ),
                  ),
                ],
              ),
            )
          else
            const SizedBox(width: 40),
          
          const Spacer(),
          
          // Temperature range
          Row(
            children: [
              Text(
                '${forecast.temperatureMin.round()}°',
                style: AppTheme.detailLabelStyle.copyWith(fontSize: 14),
              ),
              const SizedBox(width: 8),
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.5),
                      Colors.orange.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${forecast.temperatureMax.round()}°',
                style: AppTheme.detailValueStyle.copyWith(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
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