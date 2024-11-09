import 'package:latlong2/latlong.dart';

import '../../data/repositories/location_repository.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final double latitude;
  final double longitude;
  double? prevLatitude;
  double? prevLongitude;

  LocationLoaded(
      {required this.latitude,
      required this.longitude,
      this.prevLatitude,
      this.prevLongitude});
}

class LocationPermissionDenied extends LocationState {}

class AddressLoaded extends LocationState {
  final Address address;
  final double latitude;
  final double longitude;
  double? prevLatitude;
  double? prevLongitude;

  AddressLoaded(
      {required this.address,
      required this.latitude,
      required this.longitude,
      this.prevLatitude,
      this.prevLongitude});
}

class LocationLoadFailed extends LocationState {}

class AddressLoadFailed extends LocationState {}

class RouteLoaded extends LocationState {
  final List<LatLng> routeCoordinates;

  RouteLoaded(this.routeCoordinates);
}
