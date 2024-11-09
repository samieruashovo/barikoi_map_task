// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/constants/constants.dart';
import '../../domain/bloc/location_bloc.dart';
import '../../domain/bloc/location_event.dart';
import '../../domain/bloc/location_state.dart';
import 'address_panel.dart';

class MapView extends StatelessWidget {
  final double latitude;
  final double longitude;

  const MapView({super.key, required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(latitude, longitude),
            onTap: (tapPosition, point) {
              context.read<LocationBloc>().add(MapClickedEvent(
                    latitude: point.latitude,
                    longitude: point.longitude,
                  ));
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
            ),
            BlocBuilder<LocationBloc, LocationState>(
              builder: (context, state) {
                if (state is RouteLoaded) {
                  print("state.routeCoords: ${state.routeCoordinates}");
                  return PolylineLayer(
                    polylines: [
                      Polyline(
                        points: state.routeCoordinates,
                        strokeWidth: 4.0,
                        color: bgColor,
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            BlocBuilder<LocationBloc, LocationState>(
              builder: (context, state) {
                if (state is AddressLoaded) {
                  return MarkerLayer(
                    markers: [
                      Marker(
                        child: const Icon(
                          Icons.location_pin,
                          color: pinColor,
                          size: 40,
                        ),
                        point: LatLng(state.latitude, state.longitude),
                      ),
                    ],
                  );
                }
                return MarkerLayer(
                  markers: [
                    Marker(
                      child: const Icon(Icons.location_pin,
                          color: Colors.green, size: 40),
                      point: LatLng(latitude, longitude),
                    ),
                  ],
                );
              },
            ),
            BlocBuilder<LocationBloc, LocationState>(
              builder: (context, state) {
                if (state is RouteLoaded) {
                  return PolylineLayer(
                    polylines: [
                      Polyline(
                        points: state.routeCoordinates,
                        strokeWidth: 4.0,
                        color: bgColor,
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        BlocBuilder<LocationBloc, LocationState>(
          builder: (context, state) {
            if (state is AddressLoaded) {
              return AddressPanel(
                address: state.address.toString(),
                onShowRoute: () {
                  print("x");
                  print("${state.prevLongitude}, ${state.prevLatitude}}");
                  print("x");

                  print("${state.longitude}, ${state.latitude}");
                  print("x");

                  context.read<LocationBloc>().add(ShowRouteEvent(
                        end: LatLng(state.latitude, state.longitude),
                      ));
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
