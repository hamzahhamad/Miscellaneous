import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'models/weather_models.dart';
import 'screens/weather_home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'providers/weather_provider.dart';
import 'providers/location_provider.dart';
import 'providers/theme_provider.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // Register Hive type adapters
  Hive.registerAdapter(LocationAdapter());
  Hive.registerAdapter(WeatherConditionAdapter());
  Hive.registerAdapter(CurrentWeatherAdapter());
  Hive.registerAdapter(HourlyForecastAdapter());
  Hive.registerAdapter(DailyForecastAdapter());
  Hive.registerAdapter(WeatherAlertAdapter());
  Hive.registerAdapter(AirQualityAdapter());
  Hive.registerAdapter(WeatherDataAdapter());
  
  // Open Hive boxes
  await Hive.openBox<WeatherData>('weather_cache');
  await Hive.openBox<Location>('locations');
  await Hive.openBox('settings');
  
  // Set system UI overlay style (only for mobile)
  if (!kIsWeb) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }
  
  runApp(
    const ProviderScope(
      child: WeatherApp(),
    ),
  );
}

class WeatherApp extends ConsumerWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final appTheme = ref.watch(appThemeProvider);
    
    return MaterialApp(
      title: 'Weather Forecast',
      debugShowCheckedModeBanner: false,
      theme: appTheme.lightTheme,
      darkTheme: appTheme.darkTheme,
      themeMode: themeMode,
      home: kIsWeb ? const WebAppInitializer() : const AppInitializer(),
      routes: {
        '/home': (context) => const WeatherHomeScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
      },
    );
  }
}

class WebAppInitializer extends ConsumerStatefulWidget {
  const WebAppInitializer({super.key});

  @override
  ConsumerState<WebAppInitializer> createState() => _WebAppInitializerState();
}

class _WebAppInitializerState extends ConsumerState<WebAppInitializer> {
  @override
  void initState() {
    super.initState();
    _initializeWebApp();
  }

  Future<void> _initializeWebApp() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate loading
    
    // Create demo location (San Francisco)
    final demoLocation = const Location(
      latitude: 37.7749,
      longitude: -122.4194,
      name: 'San Francisco',
      country: 'United States',
      state: 'California',
    );
    
    // Load demo weather data
    await ref.read(weatherProvider.notifier).fetchWeatherData(demoLocation);
    
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
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
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wb_sunny_outlined,
                size: 80,
                color: Colors.white,
              ),
              SizedBox(height: 24),
              Text(
                'Weather Forecast',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Apple-inspired weather app',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 48),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppInitializer extends ConsumerStatefulWidget {
  const AppInitializer({super.key});

  @override
  ConsumerState<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends ConsumerState<AppInitializer> {
  bool _isInitialized = false;
  bool _hasLocationPermission = false;
  String _initializationError = '';

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Check if first time launch
      final settingsBox = Hive.box('settings');
      final isFirstLaunch = settingsBox.get('first_launch', defaultValue: true);
      
      if (isFirstLaunch) {
        // Show onboarding
        await settingsBox.put('first_launch', false);
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/onboarding');
        }
        return;
      }
      
      // Check location permission
      final locationPermission = await _checkLocationPermission();
      
      if (locationPermission) {
        // Initialize location and weather data
        await ref.read(locationProvider.notifier).initializeLocation();
        final location = ref.read(locationProvider);
        
        if (location != null) {
          await ref.read(weatherProvider.notifier).fetchWeatherData(location.currentLocation!);
        }
      }
      
      setState(() {
        _hasLocationPermission = locationPermission;
        _isInitialized = true;
      });
      
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (error) {
      setState(() {
        _initializationError = error.toString();
        _isInitialized = true;
      });
    }
  }

  Future<bool> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isInitialized) ...[
                const Icon(
                  Icons.wb_sunny_outlined,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Weather Forecast',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Intelligent multi-source forecasting',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 48),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ] else if (_initializationError.isNotEmpty) ...[
                const Icon(
                  Icons.error_outline,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Initialization Error',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _initializationError,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isInitialized = false;
                      _initializationError = '';
                    });
                    _initializeApp();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}