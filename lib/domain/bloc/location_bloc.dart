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
    emit(LocationLoading());
    try {
      final hasPermission =
          await LocationPermissionHandler.requestLocationPermission();
      dynamic position;
      if (hasPermission) {
        position = await Geolocator.getCurrentPosition();
      } else {
        emit(LocationPermissionDenied());
      }
      final routeCoordinates = await repository.getRoute(
        startLat: position.latitude,
        startLng: position.longitude,
        destLat: event.end.latitude,
        destLng: event.end.longitude,
      );

      emit(RouteLoaded(routeCoordinates));
    } catch (e) {
      emit(LocationLoadFailed());
    }
  }

  Future<void> _checkLocationPermission(
      LocationPermissionCheckEvent event, Emitter<LocationState> emit) async {
    emit(LocationLoading());
    try {
      final hasPermission =
          await LocationPermissionHandler.requestLocationPermission();
      if (hasPermission) {
        final position = await Geolocator.getCurrentPosition();

        emit(LocationLoaded(
            latitude: position.latitude, longitude: position.longitude));
      } else {
        emit(LocationPermissionDenied());
      }
    } catch (e) {
      emit(LocationLoadFailed());
    }
  }

  Future<void> _fetchAddress(
      MapClickedEvent event, Emitter<LocationState> emit) async {
    try {
      final address =
          await repository.getAddress(event.latitude, event.longitude);

      emit(AddressLoaded(
        address: address,
        latitude: event.latitude,
        longitude: event.longitude,
      ));
    } catch (e) {
      emit(AddressLoadFailed());
    }
  }
}
