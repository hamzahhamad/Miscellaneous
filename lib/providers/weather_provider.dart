import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/weather_models.dart';
import '../services/weather_api_service.dart';

// Weather service provider
final weatherServiceProvider = Provider<WeatherApiService>((ref) {
  return MultiSourceWeatherService();
});

// Weather state
class WeatherState {
  final WeatherData? currentWeather;
  final bool isLoading;
  final String? error;
  final DateTime? lastUpdated;
  final List<Location> favoriteLocations;
  final Location? selectedLocation;

  const WeatherState({
    this.currentWeather,
    this.isLoading = false,
    this.error,
    this.lastUpdated,
    this.favoriteLocations = const [],
    this.selectedLocation,
  });

  WeatherState copyWith({
    WeatherData? currentWeather,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
    List<Location>? favoriteLocations,
    Location? selectedLocation,
  }) {
    return WeatherState(
      currentWeather: currentWeather ?? this.currentWeather,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      favoriteLocations: favoriteLocations ?? this.favoriteLocations,
      selectedLocation: selectedLocation ?? this.selectedLocation,
    );
  }
}

// Weather provider
class WeatherNotifier extends StateNotifier<WeatherState> {
  WeatherNotifier(this._weatherService, this._ref) : super(const WeatherState()) {
    _initializeProvider();
  }

  final WeatherApiService _weatherService;
  final Ref _ref;
  final Box<WeatherData> _weatherCache = Hive.box<WeatherData>('weather_cache');
  final Box<Location> _locationsBox = Hive.box<Location>('locations');
  final Box _settingsBox = Hive.box('settings');

  void _initializeProvider() {
    _loadFavoriteLocations();
    _loadCachedWeather();
  }

  Future<void> _loadFavoriteLocations() async {
    try {
      final locations = _locationsBox.values.toList();
      state = state.copyWith(favoriteLocations: locations);
    } catch (e) {
      debugPrint('Error loading favorite locations: $e');
    }
  }

  Future<void> _loadCachedWeather() async {
    try {
      final cachedWeather = _weatherCache.get('current');
      if (cachedWeather != null) {
        state = state.copyWith(
          currentWeather: cachedWeather,
          lastUpdated: cachedWeather.lastUpdated,
        );
      }
    } catch (e) {
      debugPrint('Error loading cached weather: $e');
    }
  }

  Future<void> fetchWeatherData(Location location) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Check if we have cached data that's still fresh
      final cachedData = _weatherCache.get(location.toString());
      if (cachedData != null && _isCacheValid(cachedData.lastUpdated)) {
        state = state.copyWith(
          currentWeather: cachedData,
          isLoading: false,
          lastUpdated: cachedData.lastUpdated,
          selectedLocation: location,
        );
        return;
      }

      // Check internet connectivity
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.none) {
        if (cachedData != null) {
          state = state.copyWith(
            currentWeather: cachedData,
            isLoading: false,
            lastUpdated: cachedData.lastUpdated,
            selectedLocation: location,
            error: 'Using cached data - no internet connection',
          );
          return;
        } else {
          state = state.copyWith(
            isLoading: false,
            error: 'No internet connection and no cached data available',
          );
          return;
        }
      }

      // Fetch fresh data
      final weatherData = await _weatherService.getWeatherData(location);
      
      // Cache the data
      await _cacheWeatherData(location, weatherData);
      
      state = state.copyWith(
        currentWeather: weatherData,
        isLoading: false,
        lastUpdated: weatherData.lastUpdated,
        selectedLocation: location,
        error: null,
      );
    } catch (e) {
      debugPrint('Error fetching weather data: $e');
      
      // Try to use cached data if available
      final cachedData = _weatherCache.get(location.toString());
      if (cachedData != null) {
        state = state.copyWith(
          currentWeather: cachedData,
          isLoading: false,
          lastUpdated: cachedData.lastUpdated,
          selectedLocation: location,
          error: 'Using cached data - ${e.toString()}',
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
    }
  }

  bool _isCacheValid(DateTime cacheTime) {
    final now = DateTime.now();
    final difference = now.difference(cacheTime);
    return difference.inMinutes < 30; // Cache valid for 30 minutes
  }

  Future<void> _cacheWeatherData(Location location, WeatherData weatherData) async {
    try {
      await _weatherCache.put(location.toString(), weatherData);
      await _weatherCache.put('current', weatherData); // Also cache as current
    } catch (e) {
      debugPrint('Error caching weather data: $e');
    }
  }

  Future<void> refreshWeather() async {
    if (state.selectedLocation != null) {
      await fetchWeatherData(state.selectedLocation!);
    }
  }

  Future<void> addFavoriteLocation(Location location) async {
    try {
      final key = '${location.latitude}_${location.longitude}';
      await _locationsBox.put(key, location);
      
      final updatedLocations = [...state.favoriteLocations, location];
      state = state.copyWith(favoriteLocations: updatedLocations);
    } catch (e) {
      debugPrint('Error adding favorite location: $e');
    }
  }

  Future<void> removeFavoriteLocation(Location location) async {
    try {
      final key = '${location.latitude}_${location.longitude}';
      await _locationsBox.delete(key);
      
      final updatedLocations = state.favoriteLocations
          .where((loc) => loc.latitude != location.latitude || 
                         loc.longitude != location.longitude)
          .toList();
      state = state.copyWith(favoriteLocations: updatedLocations);
    } catch (e) {
      debugPrint('Error removing favorite location: $e');
    }
  }

  bool isLocationFavorite(Location location) {
    return state.favoriteLocations.any((loc) => 
        loc.latitude == location.latitude && 
        loc.longitude == location.longitude);
  }

  Future<void> selectLocation(Location location) async {
    if (state.selectedLocation?.latitude != location.latitude ||
        state.selectedLocation?.longitude != location.longitude) {
      await fetchWeatherData(location);
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<void> clearCache() async {
    try {
      await _weatherCache.clear();
      state = state.copyWith(
        currentWeather: null,
        lastUpdated: null,
        error: null,
      );
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }

  // Get weather data for a specific location without changing state
  Future<WeatherData?> getWeatherDataForLocation(Location location) async {
    try {
      return await _weatherService.getWeatherData(location);
    } catch (e) {
      debugPrint('Error getting weather data for location: $e');
      return null;
    }
  }
}

final weatherProvider = StateNotifierProvider<WeatherNotifier, WeatherState>((ref) {
  return WeatherNotifier(ref.read(weatherServiceProvider), ref);
});

// Derived providers
final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(weatherProvider).isLoading;
});

final weatherErrorProvider = Provider<String?>((ref) {
  return ref.watch(weatherProvider).error;
});

final currentWeatherProvider = Provider<WeatherData?>((ref) {
  return ref.watch(weatherProvider).currentWeather;
});

final favoriteLocationsProvider = Provider<List<Location>>((ref) {
  return ref.watch(weatherProvider).favoriteLocations;
});

final selectedLocationProvider = Provider<Location?>((ref) {
  return ref.watch(weatherProvider).selectedLocation;
});

// Auto-refresh provider
final autoRefreshProvider = Provider<bool>((ref) {
  final settingsBox = Hive.box('settings');
  return settingsBox.get('auto_refresh', defaultValue: true);
});