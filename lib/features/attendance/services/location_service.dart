import 'dart:math';
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Request GPS permissions and return current Position
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Layanan GPS/Lokasi perangkat Anda belum aktif.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Izin akses lokasi ditolak oleh pengguna.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Izin akses lokasi ditolak secara permanen di Pengaturan HP.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Calculate distance in meters between user position and office coordinates
  static double calculateDistanceInMeters(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    const double earthRadiusMs = 6371000; // Earth radius in meters
    double dLat = _degreesToRadians(endLat - startLat);
    double dLng = _degreesToRadians(endLng - startLng);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(startLat)) *
            cos(_degreesToRadians(endLat)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusMs * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  /// Helper to check if within Geofence radius
  static bool isWithinRadius(
    double userLat,
    double userLng,
    double officeLat,
    double officeLng,
    double allowedRadiusMeters,
  ) {
    double distance = calculateDistanceInMeters(userLat, userLng, officeLat, officeLng);
    return distance <= allowedRadiusMeters;
  }
}
