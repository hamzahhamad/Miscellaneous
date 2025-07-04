import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../providers/location_provider.dart';
import '../providers/weather_provider.dart';
import '../theme/app_theme.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final hasPermission = await ref.read(locationProvider.notifier).getCurrentLocation();
    setState(() {
      _isPermissionGranted = hasPermission != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF74B9FF),
              Color(0xFF0984E3),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => _finishOnboarding(),
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              // Page view
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    _buildWelcomePage(),
                    _buildMultiSourcePage(),
                    _buildLocationPage(),
                    _buildFeaturesPage(),
                  ],
                ),
              ),
              // Page indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
              // Bottom buttons
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage < 3) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _finishOnboarding();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0984E3),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _currentPage < 3 ? 'Next' : 'Get Started',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wb_sunny_outlined,
            size: 120,
            color: Colors.white,
          ),
          const SizedBox(height: 32),
          const Text(
            'Welcome to\nWeather Forecast',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Get the most accurate weather forecasts by combining multiple data sources',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMultiSourcePage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.layers_outlined,
            size: 120,
            color: Colors.white,
          ),
          const SizedBox(height: 32),
          const Text(
            'Multi-Source\nIntelligence',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'We combine data from Open-Meteo, NOAA, MET Norway, and other sources to give you the most reliable forecast',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSourceIcon('Open-Meteo'),
              _buildSourceIcon('NOAA'),
              _buildSourceIcon('MET Norway'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSourceIcon(String name) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          child: const Icon(
            Icons.cloud_outlined,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationPage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.location_on_outlined,
            size: 120,
            color: Colors.white,
          ),
          const SizedBox(height: 32),
          const Text(
            'Location\nPermission',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'We need your location to provide accurate weather forecasts for your area',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          if (!_isPermissionGranted)
            ElevatedButton(
              onPressed: _requestLocationPermission,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0984E3),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Allow Location',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Location Permission Granted',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeaturesPage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.star_outline,
            size: 120,
            color: Colors.white,
          ),
          const SizedBox(height: 32),
          const Text(
            'Ready to\nExplore!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Enjoy beautiful weather visualizations, confidence indicators, and offline functionality',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Column(
            children: [
              _buildFeatureItem(
                Icons.palette_outlined,
                'Beautiful UI',
                'Apple Weather inspired design',
              ),
              const SizedBox(height: 16),
              _buildFeatureItem(
                Icons.verified_outlined,
                'Confidence Indicators',
                'See how reliable each forecast is',
              ),
              const SizedBox(height: 16),
              _buildFeatureItem(
                Icons.offline_bolt_outlined,
                'Offline Ready',
                'Works without internet connection',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _requestLocationPermission() async {
    try {
      final permission = await Permission.location.request();
      if (permission.isGranted) {
        await ref.read(locationProvider.notifier).getCurrentLocation();
        setState(() {
          _isPermissionGranted = true;
        });
      }
    } catch (e) {
      // Handle permission error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to request location permission: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _finishOnboarding() async {
    // Initialize location and weather data if permission is granted
    if (_isPermissionGranted) {
      final location = await ref.read(locationProvider.notifier).getCurrentLocation();
      if (location != null) {
        await ref.read(weatherProvider.notifier).fetchWeatherData(location);
      }
    }

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}