import 'package:latlong2/latlong.dart';

abstract class LocationEvent {}

class LocationPermissionCheckEvent extends LocationEvent {}

class MapClickedEvent extends LocationEvent {
  final double latitude;
  final double longitude;
  double? prevLatitude = 0.0;
  double? prevLongitude = 0.0;

  MapClickedEvent(
      {required this.latitude,
      required this.longitude,
      this.prevLatitude,
      this.prevLongitude});
}

class ShowRouteEvent extends LocationEvent {
  final LatLng start;
  final LatLng end;

  ShowRouteEvent({required this.start, required this.end});
}
