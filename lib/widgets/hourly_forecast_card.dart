import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/weather_models.dart';
import '../theme/app_theme.dart';

class HourlyForecastCard extends StatelessWidget {
  const HourlyForecastCard({
    super.key,
    required this.hourlyData,
  });

  final List<HourlyForecast> hourlyData;

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
                Icons.schedule,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Hourly Forecast',
                style: AppTheme.sectionHeaderStyle,
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: hourlyData.length > 24 ? 24 : hourlyData.length,
              itemBuilder: (context, index) {
                final forecast = hourlyData[index];
                return _buildHourlyItem(forecast, index == 0);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyItem(HourlyForecast forecast, bool isFirst) {
    return Container(
      width: 60,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Time
          Text(
            isFirst ? 'Now' : DateFormat('HH:mm').format(forecast.time),
            style: AppTheme.detailLabelStyle.copyWith(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          
          // Weather icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              _getWeatherIcon(forecast.condition.icon),
              size: 20,
              color: Colors.white,
            ),
          ),
          
          // Precipitation probability
          if (forecast.precipitationProbability > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.water_drop,
                  size: 10,
                  color: Colors.lightBlue,
                ),
                const SizedBox(width: 2),
                Text(
                  '${forecast.precipitationProbability.round()}%',
                  style: AppTheme.detailLabelStyle.copyWith(
                    fontSize: 10,
                    color: Colors.lightBlue,
                  ),
                ),
              ],
            )
          else
            const SizedBox(height: 14),
          
          // Temperature
          Text(
            '${forecast.temperature.round()}°',
            style: AppTheme.hourlyTemperatureStyle.copyWith(fontSize: 14),
            textAlign: TextAlign.center,
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