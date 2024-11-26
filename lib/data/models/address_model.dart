

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


// class AddressModel {
//   final String address;

//   AddressModel({required this.address});

//   factory AddressModel.fromJson(Map<String, dynamic> json) {
//     return AddressModel(address: json['address']);
//   }
// }