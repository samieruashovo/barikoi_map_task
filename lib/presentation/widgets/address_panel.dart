import 'package:flutter/material.dart';

import '../../core/constants/constants.dart';

class AddressPanel extends StatelessWidget {
  final String address;
  final VoidCallback onShowRoute;

  const AddressPanel(
      {super.key, required this.address, required this.onShowRoute});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: 10,
      right: 10,
      child: Card(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(9)),
            color: bgColor,
          ),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                address,
                style: const TextStyle(color: Colors.white),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0, backgroundColor: btnBgColor),
                  onPressed: onShowRoute,
                  child: const Text(
                    "Show Route",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
