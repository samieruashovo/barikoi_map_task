import 'package:latlong2/latlong.dart';

import '../../data/repositories/location_repository.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final double latitude;
  final double longitude;

  LocationLoaded({required this.latitude, required this.longitude});
}

class LocationPermissionDenied extends LocationState {}

class AddressLoaded extends LocationState {
  final Address address;
  final double latitude;
  final double longitude;

  AddressLoaded(
      {required this.address, required this.latitude, required this.longitude});
}

class LocationLoadFailed extends LocationState {}

class AddressLoadFailed extends LocationState {}

class RouteLoaded extends LocationState {
  final List<LatLng> routeCoordinates;

  RouteLoaded(this.routeCoordinates);
}
