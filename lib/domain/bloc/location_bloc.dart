import 'package:flutter_bloc/flutter_bloc.dart';
import 'location_event.dart';
import 'location_state.dart';
import '../../data/repositories/location_repository.dart';
import '../../core/utils/location_permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository repository = LocationRepository();

  LocationBloc() : super(LocationInitial()) {
    on<LocationPermissionCheckEvent>(_checkLocationPermission);
    on<MapClickedEvent>(_fetchAddress);
    on<ShowRouteEvent>(_fetchRoute);
  }

  Future<void> _fetchRoute(
      ShowRouteEvent event, Emitter<LocationState> emit) async {
    print("Fetching route from ${event.start} to ${event.end}");

    emit(LocationLoading());
    try {
      final routeCoordinates = await repository.getRoute(
        startLat: event.start.latitude,
        startLng: event.start.longitude,
        destLat: event.end.latitude,
        destLng: event.end.longitude,
      );
      print("Route fetched successfully: $routeCoordinates");

      emit(RouteLoaded(routeCoordinates));
    } catch (e) {
      print("Error fetching route: $e");
      emit(LocationLoadFailed());
    }
  }

  Future<void> _checkLocationPermission(
      LocationPermissionCheckEvent event, Emitter<LocationState> emit) async {
    print("Checking location permission...");

    emit(LocationLoading());
    try {
      final hasPermission =
          await LocationPermissionHandler.requestLocationPermission();
      if (hasPermission) {
        final position = await Geolocator.getCurrentPosition();
        print(
            "Location permission granted. Current position: ${position.latitude}, ${position.longitude}");

        emit(LocationLoaded(
            latitude: position.latitude, longitude: position.longitude));
      } else {
        print("Location permission denied.");
        emit(LocationPermissionDenied());
      }
    } catch (e) {
      print("Error checking location permission: $e");
      emit(LocationLoadFailed());
    }
  }

  Future<void> _fetchAddress(
      MapClickedEvent event, Emitter<LocationState> emit) async {
    print(
        "Fetching address for coordinates: ${event.latitude}, ${event.longitude}");

    try {
      final address =
          await repository.getAddress(event.latitude, event.longitude);
      print("Address fetched successfully: $address");

      emit(AddressLoaded(
          address: address,
          latitude: event.latitude,
          longitude: event.longitude,
          prevLatitude: event.prevLatitude,
          prevLongitude: event.prevLongitude));
    } catch (e) {
      print("Error fetching address: $e");
      emit(AddressLoadFailed());
    }
  }
}
