import 'package:latlong2/latlong.dart';

abstract class LocationEvent {}

class LocationPermissionCheckEvent extends LocationEvent {}

class MapClickedEvent extends LocationEvent {
  final double latitude;
  final double longitude;

  MapClickedEvent({
    required this.latitude,
    required this.longitude,
  });
}

class ShowRouteEvent extends LocationEvent {
  final LatLng end;

  ShowRouteEvent(
      {
      required this.end});
}
