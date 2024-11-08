import 'package:barikoi_map_task/core/constants/api_keys.dart';
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

// final url =
//         'https://barikoi.xyz/v2/api/routing?key=$BARIKOI_API_KEY&type=vh';
  Future<List<LatLng>> getRoute({
    required double startLat,
    required double startLng,
    required double destLat,
    required double destLng,
  }) async {
    final url =
        'https://barikoi.xyz/v2/api/routing?key=$BARIKOI_API_KEY&type=vh';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "data": {
        "start": {
          "latitude": startLat,
          "longitude": startLng,
        },
        "destination": {
          "latitude": destLat,
          "longitude": destLng,
        }
      }
    });

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      print('API Response: ${response.body}');

      final polyline = data['trip']['legs'][0]['shape'] ??
          ''; 
      if (polyline.isNotEmpty) {
        return _decodePolyline(polyline);
      } else {
        throw Exception('Polyline not found in API response');
      }
    } else {
      throw Exception('Failed to load route: ${response.statusCode}');
    }
  }

  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> coordinates = [];
    int index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      coordinates.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return coordinates;
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
