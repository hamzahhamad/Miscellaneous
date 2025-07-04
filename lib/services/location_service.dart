import 'dart:async';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../models/weather_models.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  StreamSubscription<Position>? _positionStreamSubscription;
  Position? _currentPosition;
  Location? _currentLocation;
  
  final Box<Location> _locationsBox = Hive.box<Location>('locations');
  final Box _settingsBox = Hive.box('settings');

  Future<bool> checkLocationPermission() async {
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

  Future<Location?> getCurrentLocation() async {
    try {
      final hasPermission = await checkLocationPermission();
      if (!hasPermission) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      _currentPosition = position;
      _currentLocation = await _getLocationFromPosition(position);

      // Cache current location
      if (_currentLocation != null) {
        await _settingsBox.put('current_location', _currentLocation!.toJson());
      }

      return _currentLocation;
    } catch (e) {
      debugPrint('Error getting current location: $e');
      return _getCachedLocation();
    }
  }

  Future<Location?> _getLocationFromPosition(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        return Location(
          latitude: position.latitude,
          longitude: position.longitude,
          name: placemark.locality ?? placemark.subAdministrativeArea ?? 'Unknown',
          country: placemark.country ?? 'Unknown',
          state: placemark.administrativeArea ?? placemark.subAdministrativeArea,
        );
      }
    } catch (e) {
      debugPrint('Error getting location from position: $e');
    }

    return Location(
      latitude: position.latitude,
      longitude: position.longitude,
      name: 'Current Location',
    );
  }

  Location? _getCachedLocation() {
    try {
      final cachedLocationJson = _settingsBox.get('current_location');
      if (cachedLocationJson != null) {
        return Location.fromJson(Map<String, dynamic>.from(cachedLocationJson));
      }
    } catch (e) {
      debugPrint('Error getting cached location: $e');
    }
    return null;
  }

  Future<List<Location>> searchLocations(String query) async {
    if (query.isEmpty) return [];

    try {
      final locations = await locationFromAddress(query);
      final List<Location> searchResults = [];

      for (final location in locations.take(5)) {
        final placemarks = await placemarkFromCoordinates(
          location.latitude,
          location.longitude,
        );

        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          searchResults.add(Location(
            latitude: location.latitude,
            longitude: location.longitude,
            name: placemark.locality ?? placemark.subAdministrativeArea ?? query,
            country: placemark.country ?? 'Unknown',
            state: placemark.administrativeArea ?? placemark.subAdministrativeArea,
          ));
        }
      }

      return searchResults;
    } catch (e) {
      debugPrint('Error searching locations: $e');
      return [];
    }
  }

  Future<void> saveLocation(Location location) async {
    try {
      final key = '${location.latitude}_${location.longitude}';
      await _locationsBox.put(key, location);
    } catch (e) {
      debugPrint('Error saving location: $e');
    }
  }

  Future<List<Location>> getSavedLocations() async {
    try {
      return _locationsBox.values.toList();
    } catch (e) {
      debugPrint('Error getting saved locations: $e');
      return [];
    }
  }

  Future<void> removeLocation(Location location) async {
    try {
      final key = '${location.latitude}_${location.longitude}';
      await _locationsBox.delete(key);
    } catch (e) {
      debugPrint('Error removing location: $e');
    }
  }

  void startLocationUpdates() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.balanced,
      distanceFilter: 100, // Update every 100 meters
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      _currentPosition = position;
      _updateCurrentLocation(position);
    });
  }

  void _updateCurrentLocation(Position position) async {
    try {
      _currentLocation = await _getLocationFromPosition(position);
      if (_currentLocation != null) {
        await _settingsBox.put('current_location', _currentLocation!.toJson());
      }
    } catch (e) {
      debugPrint('Error updating current location: $e');
    }
  }

  void stopLocationUpdates() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }

  double? getDistanceFromCurrent(Location location) {
    if (_currentPosition == null) return null;
    
    return Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      location.latitude,
      location.longitude,
    );
  }

  Future<void> openLocationSettings() async {
    if (Platform.isAndroid) {
      await Geolocator.openLocationSettings();
    } else if (Platform.isIOS) {
      await openAppSettings();
    }
  }

  void dispose() {
    stopLocationUpdates();
  }
}