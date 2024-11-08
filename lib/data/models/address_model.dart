class AddressModel {
  final String address;

  AddressModel({required this.address});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(address: json['address']);
  }
}
