import 'package:flutter/material.dart';

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
        child: Column(
          children: [
            ElevatedButton(
                onPressed: onShowRoute, child: const Text("Show Route")),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(9)),
                color: Color(0xff00b369),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Text(
                address,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
