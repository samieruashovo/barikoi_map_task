import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/constants.dart';
import '../../domain/bloc/location_bloc.dart';
import '../../domain/bloc/location_state.dart';
import '../widgets/map_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: bgColor,
          title: const Text(
            'Barikoi Map Task',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )),
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state is LocationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LocationLoaded) {
            return MapView(
              latitude: state.latitude,
              longitude: state.longitude,
            );
          } else if (state is AddressLoaded) {
            return MapView(
              latitude: state.latitude,
              longitude: state.longitude,
            );
          } else if (state is RouteLoaded) {
            return MapView(
              latitude: state
                  .routeCoordinates[state.routeCoordinates.length - 1].latitude,
              longitude: state
                  .routeCoordinates[state.routeCoordinates.length - 1]
                  .longitude,
            );
          } else if (state is LocationPermissionDenied) {
            return const Center(
                child: Text(
                    'Location permission denied. Please enable it in settings.'));
          } else if (state is LocationLoadFailed ||
              state is AddressLoadFailed) {
            return const Center(
                child: Text('Failed to load location. Please try again.'));
          }
          return const Center(child: Text('Initializing...'));
        },
      ),
    );
  }
}
