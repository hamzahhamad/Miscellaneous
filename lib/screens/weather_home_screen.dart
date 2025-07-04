import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/weather_models.dart';
import '../providers/weather_provider.dart';
import '../providers/location_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/weather_main_card.dart';
import '../widgets/hourly_forecast_card.dart';
import '../widgets/daily_forecast_card.dart';
import '../widgets/weather_detail_card.dart';
import 'location_search_screen.dart';

class WeatherHomeScreen extends ConsumerStatefulWidget {
  const WeatherHomeScreen({super.key});

  @override
  ConsumerState<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends ConsumerState<WeatherHomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarVisible = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final isVisible = _scrollController.hasClients && _scrollController.offset > 100;
    if (isVisible != _isAppBarVisible) {
      setState(() {
        _isAppBarVisible = isVisible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherProvider);
    final currentLocation = ref.watch(currentLocationProvider);
    final appTheme = ref.watch(appThemeProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: _isAppBarVisible 
            ? Colors.black.withOpacity(0.3)
            : Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showLocationSearch(context),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showOptionsMenu(context),
          ),
        ],
        title: _isAppBarVisible && currentLocation != null
            ? Text(
                currentLocation.name ?? 'Current Location',
                style: AppTheme.locationStyle,
              )
            : null,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: _getWeatherGradient(weatherState.currentWeather),
        ),
        child: weatherState.isLoading && weatherState.currentWeather == null
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : weatherState.error != null && weatherState.currentWeather == null
                ? _buildErrorState(weatherState.error!)
                : _buildWeatherContent(weatherState.currentWeather),
      ),
    );
  }

  LinearGradient _getWeatherGradient(WeatherData? weatherData) {
    if (weatherData == null) return AppTheme.rainyGradient;
    
    final condition = weatherData.current.condition.main;
    final isDay = _isCurrentlyDay(weatherData.current);
    
    return ref.read(appThemeProvider).getWeatherGradient(condition, isDay);
  }

  bool _isCurrentlyDay(CurrentWeather weather) {
    final now = DateTime.now();
    return now.isAfter(weather.sunrise) && now.isBefore(weather.sunset);
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to load weather data',
              style: AppTheme.conditionStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: AppTheme.locationStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _refreshWeather(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0984E3),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherContent(WeatherData? weatherData) {
    if (weatherData == null) return const SizedBox.shrink();

    return RefreshIndicator(
      onRefresh: _refreshWeather,
      color: Colors.white,
      backgroundColor: Colors.black.withOpacity(0.3),
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Main weather display
          SliverToBoxAdapter(
            child: WeatherMainCard(
              weatherData: weatherData,
              location: weatherData.current.location,
            ),
          ),
          
          // Hourly forecast
          SliverToBoxAdapter(
            child: HourlyForecastCard(
              hourlyData: weatherData.hourly,
            ),
          ),
          
          // Daily forecast
          SliverToBoxAdapter(
            child: DailyForecastCard(
              dailyData: weatherData.daily,
            ),
          ),
          
          // Weather details
          SliverToBoxAdapter(
            child: WeatherDetailCard(
              currentWeather: weatherData.current,
              airQuality: weatherData.airQuality,
            ),
          ),
          
          // Confidence and sources
          SliverToBoxAdapter(
            child: _buildConfidenceCard(weatherData.current),
          ),
          
          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceCard(CurrentWeather weather) {
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
                Icons.verified_outlined,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Forecast Confidence',
                style: AppTheme.sectionHeaderStyle,
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: weather.confidence,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              weather.confidence > 0.8
                  ? Colors.green
                  : weather.confidence > 0.6
                      ? Colors.orange
                      : Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(weather.confidence * 100).round()}% confidence',
            style: AppTheme.detailValueStyle,
          ),
          const SizedBox(height: 12),
          Text(
            'Sources: ${weather.sources.join(', ')}',
            style: AppTheme.detailLabelStyle,
          ),
          const SizedBox(height: 8),
          Text(
            'Last updated: ${_formatLastUpdated(weather.timestamp)}',
            style: AppTheme.detailLabelStyle,
          ),
        ],
      ),
    );
  }

  String _formatLastUpdated(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return DateFormat('MMM d, h:mm a').format(timestamp);
    }
  }

  Future<void> _refreshWeather() async {
    final currentLocation = ref.read(currentLocationProvider);
    if (currentLocation != null) {
      await ref.read(weatherProvider.notifier).fetchWeatherData(currentLocation);
    } else {
      // Try to get current location
      await ref.read(locationProvider.notifier).getCurrentLocation();
      final newLocation = ref.read(currentLocationProvider);
      if (newLocation != null) {
        await ref.read(weatherProvider.notifier).fetchWeatherData(newLocation);
      }
    }
  }

  void _showLocationSearch(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LocationSearchScreen(),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.refresh, color: Colors.white),
                title: const Text(
                  'Refresh',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _refreshWeather();
                },
              ),
              ListTile(
                leading: const Icon(Icons.brightness_6, color: Colors.white),
                title: const Text(
                  'Toggle Theme',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  ref.read(themeModeProvider.notifier).toggleTheme();
                },
              ),
              ListTile(
                leading: const Icon(Icons.location_on, color: Colors.white),
                title: const Text(
                  'Manage Locations',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _showLocationSearch(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.white),
                title: const Text(
                  'About',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _showAboutDialog(context);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text(
          'Weather Forecast',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'A beautiful weather app that combines multiple data sources for the most accurate forecasts.\n\n'
          'Data sources:\n'
          '• Open-Meteo\n'
          '• NOAA/NWS\n'
          '• MET Norway\n'
          '• OpenWeatherMap\n'
          '• Weatherbit',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}