import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/weather_models.dart';
import '../providers/location_provider.dart';
import '../providers/weather_provider.dart';
import '../theme/app_theme.dart';

class LocationSearchScreen extends ConsumerStatefulWidget {
  const LocationSearchScreen({super.key});

  @override
  ConsumerState<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends ConsumerState<LocationSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationProvider);
    final weatherState = ref.watch(weatherProvider);
    final favoriteLocations = ref.watch(favoriteLocationsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Locations',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for a city...',
                hintStyle: const TextStyle(color: Colors.white60),
                prefixIcon: const Icon(Icons.search, color: Colors.white60),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white60),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(locationProvider.notifier).clearSearchResults();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() {});
                if (value.isNotEmpty) {
                  ref.read(locationProvider.notifier).searchLocations(value);
                } else {
                  ref.read(locationProvider.notifier).clearSearchResults();
                }
              },
            ),
          ),
          
          // Current location button
          if (locationState.currentLocation != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildLocationTile(
                location: locationState.currentLocation!,
                isCurrentLocation: true,
                onTap: () => _selectLocation(locationState.currentLocation!),
              ),
            ),
          
          // Search results or favorite locations
          Expanded(
            child: locationState.searchResults.isNotEmpty
                ? _buildSearchResults(locationState.searchResults)
                : _buildFavoriteLocations(favoriteLocations),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<Location> searchResults) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final location = searchResults[index];
        return _buildLocationTile(
          location: location,
          onTap: () => _selectLocation(location),
          onFavorite: () => _toggleFavorite(location),
        );
      },
    );
  }

  Widget _buildFavoriteLocations(List<Location> favoriteLocations) {
    if (favoriteLocations.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: Colors.white30,
            ),
            SizedBox(height: 16),
            Text(
              'No saved locations',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Search for cities to add them to your favorites',
              style: TextStyle(
                color: Colors.white30,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favoriteLocations.length,
      itemBuilder: (context, index) {
        final location = favoriteLocations[index];
        return _buildLocationTile(
          location: location,
          isFavorite: true,
          onTap: () => _selectLocation(location),
          onFavorite: () => _toggleFavorite(location),
        );
      },
    );
  }

  Widget _buildLocationTile({
    required Location location,
    bool isCurrentLocation = false,
    bool isFavorite = false,
    required VoidCallback onTap,
    VoidCallback? onFavorite,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        leading: Icon(
          isCurrentLocation ? Icons.my_location : Icons.location_on,
          color: isCurrentLocation ? Colors.blue : Colors.white60,
        ),
        title: Text(
          location.name ?? 'Unknown Location',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          _formatLocationSubtitle(location),
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 14,
          ),
        ),
        trailing: onFavorite != null
            ? IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white60,
                ),
                onPressed: onFavorite,
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  String _formatLocationSubtitle(Location location) {
    final parts = <String>[];
    if (location.state != null) parts.add(location.state!);
    if (location.country != null) parts.add(location.country!);
    return parts.join(', ');
  }

  Future<void> _selectLocation(Location location) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );

    try {
      await ref.read(weatherProvider.notifier).fetchWeatherData(location);
      
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        Navigator.of(context).pop(); // Close search screen
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load weather data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _toggleFavorite(Location location) async {
    final weatherNotifier = ref.read(weatherProvider.notifier);
    final isFavorite = weatherNotifier.isLocationFavorite(location);

    if (isFavorite) {
      await weatherNotifier.removeFavoriteLocation(location);
    } else {
      await weatherNotifier.addFavoriteLocation(location);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}