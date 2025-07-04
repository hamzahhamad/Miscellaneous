import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../models/weather_models.dart';
import '../services/location_service.dart';

// Location service provider
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

// Location state
class LocationState {
  final Location? currentLocation;
  final List<Location> searchResults;
  final bool isLoading;
  final String? error;
  final bool hasLocationPermission;
  final bool isLocationServiceEnabled;

  const LocationState({
    this.currentLocation,
    this.searchResults = const [],
    this.isLoading = false,
    this.error,
    this.hasLocationPermission = false,
    this.isLocationServiceEnabled = false,
  });

  LocationState copyWith({
    Location? currentLocation,
    List<Location>? searchResults,
    bool? isLoading,
    String? error,
    bool? hasLocationPermission,
    bool? isLocationServiceEnabled,
  }) {
    return LocationState(
      currentLocation: currentLocation ?? this.currentLocation,
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasLocationPermission: hasLocationPermission ?? this.hasLocationPermission,
      isLocationServiceEnabled: isLocationServiceEnabled ?? this.isLocationServiceEnabled,
    );
  }
}

// Location provider
class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier(this._locationService) : super(const LocationState()) {
    _initializeLocation();
  }

  final LocationService _locationService;

  Future<void> _initializeLocation() async {
    await _checkLocationPermission();
    await getCurrentLocation();
  }

  Future<void> _checkLocationPermission() async {
    try {
      final hasPermission = await _locationService.checkLocationPermission();
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      
      state = state.copyWith(
        hasLocationPermission: hasPermission,
        isLocationServiceEnabled: isServiceEnabled,
      );
    } catch (e) {
      debugPrint('Error checking location permission: $e');
      state = state.copyWith(
        error: 'Failed to check location permission',
        hasLocationPermission: false,
        isLocationServiceEnabled: false,
      );
    }
  }

  Future<void> initializeLocation() async {
    await _initializeLocation();
  }

  Future<void> getCurrentLocation() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final location = await _locationService.getCurrentLocation();
      
      if (location != null) {
        state = state.copyWith(
          currentLocation: location,
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Could not get current location',
        );
      }
    } catch (e) {
      debugPrint('Error getting current location: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> searchLocations(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(searchResults: []);
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final results = await _locationService.searchLocations(query);
      state = state.copyWith(
        searchResults: results,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      debugPrint('Error searching locations: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to search locations',
        searchResults: [],
      );
    }
  }

  Future<void> saveLocation(Location location) async {
    try {
      await _locationService.saveLocation(location);
    } catch (e) {
      debugPrint('Error saving location: $e');
      state = state.copyWith(error: 'Failed to save location');
    }
  }

  Future<List<Location>> getSavedLocations() async {
    try {
      return await _locationService.getSavedLocations();
    } catch (e) {
      debugPrint('Error getting saved locations: $e');
      return [];
    }
  }

  Future<void> removeLocation(Location location) async {
    try {
      await _locationService.removeLocation(location);
    } catch (e) {
      debugPrint('Error removing location: $e');
      state = state.copyWith(error: 'Failed to remove location');
    }
  }

  void startLocationUpdates() {
    _locationService.startLocationUpdates();
  }

  void stopLocationUpdates() {
    _locationService.stopLocationUpdates();
  }

  double? getDistanceFromCurrent(Location location) {
    return _locationService.getDistanceFromCurrent(location);
  }

  Future<void> openLocationSettings() async {
    await _locationService.openLocationSettings();
  }

  void clearSearchResults() {
    state = state.copyWith(searchResults: []);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<void> requestLocationPermission() async {
    await _checkLocationPermission();
    if (state.hasLocationPermission) {
      await getCurrentLocation();
    }
  }

  @override
  void dispose() {
    _locationService.dispose();
    super.dispose();
  }
}

final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier(ref.read(locationServiceProvider));
});

// Derived providers
final currentLocationProvider = Provider<Location?>((ref) {
  return ref.watch(locationProvider).currentLocation;
});

final locationSearchResultsProvider = Provider<List<Location>>((ref) {
  return ref.watch(locationProvider).searchResults;
});

final isLocationLoadingProvider = Provider<bool>((ref) {
  return ref.watch(locationProvider).isLoading;
});

final locationErrorProvider = Provider<String?>((ref) {
  return ref.watch(locationProvider).error;
});

final hasLocationPermissionProvider = Provider<bool>((ref) {
  return ref.watch(locationProvider).hasLocationPermission;
});