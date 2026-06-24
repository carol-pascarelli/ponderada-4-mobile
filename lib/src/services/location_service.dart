import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationData {
  const LocationData({
    required this.latitude,
    required this.longitude,
    this.label,
  });

  final double latitude;
  final double longitude;
  final String? label;
}

class LocationService {
  Future<bool> isServiceEnabled() => Geolocator.isLocationServiceEnabled();

  Future<LocationPermission> checkPermission() =>
      Geolocator.checkPermission();

  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();

  Future<LocationData> getCurrentLocation() async {
    final serviceEnabled = await isServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Ative o GPS do dispositivo para capturar a localização.');
    }

    var permission = await checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Permissão de localização negada.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Permissão de localização bloqueada. Ative nas configurações do app.',
      );
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );

    // O método agora possui proteção contra travamentos
    final label = await _resolveAddress(position.latitude, position.longitude);

    return LocationData(
      latitude: position.latitude,
      longitude: position.longitude,
      label: label,
    );
  }

  Future<String?> _resolveAddress(double latitude, double longitude) async {
    try {
      // Adicionado um timeout de 3 segundos para evitar que o emulador trave a aplicação
      final places = await placemarkFromCoordinates(latitude, longitude)
          .timeout(const Duration(seconds: 3));

      if (places.isEmpty) return null;

      final place = places.first;
      final parts = [
        place.street,
        place.subLocality,
        place.locality,
      ].where((part) => part != null && part.isNotEmpty).cast<String>();

      if (parts.isEmpty) return null;
      return parts.join(', ');
    } catch (_) {
      // Se houver timeout ou falha de rede do emulador, ignora o texto e não congela o app
      return null;
    }
  }
}