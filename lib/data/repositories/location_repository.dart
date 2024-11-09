import 'package:barikoi_map_task/core/constants/constants.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:latlong2/latlong.dart';

class LocationRepository {
  Future<Address> getAddress(double latitude, double longitude) async {
    final url =
        'https://barikoi.xyz/v2/api/search/reverse/geocode?api_key=$BARIKOI_API_KEY&longitude=$longitude&latitude=$latitude&district=true&post_code=true&country=true&sub_district=true&union=true&pauroshova=true&location_type=true&division=true&address=true&area=true&bangla=true';

    final response = await http.get(Uri.parse(url));

    final data = json.decode(response.body);
    if (data['status'] == 200 && data['place'] != null) {
      return Address.fromJson(data['place']);
    } else {
      throw Exception('Invalid response from API');
    }
  }

  Future<List<LatLng>> getRoute({
    required double startLat,
    required double startLng,
    required double destLat,
    required double destLng,
  }) async {
    final url =
        'https://barikoi.xyz/v2/api/route/$startLng,$startLat;$destLng,$destLat?api_key=$BARIKOI_API_KEY&geometries=polyline';

    final headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final encodedPolyline = data['routes'][0]['geometry'];

      return _decodePolyline(encodedPolyline);
    } else {
      throw Exception('Failed to load route: ${response.statusCode}');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> result = polylinePoints.decodePolyline(encoded);
    return result
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }
}

class Address {
  final String address;
  final String area;
  final String city;
  final String country;

  Address({
    required this.address,
    required this.area,
    required this.city,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json['address'] ?? 'Unknown address',
      area: json['area'] ?? 'Unknown area',
      city: json['city'] ?? 'Unknown city',
      country: json['country'] ?? 'Unknown country',
    );
  }

  @override
  String toString() {
    return "$address, $area, $city, $country";
  }
}
