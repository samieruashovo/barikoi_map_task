import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'domain/bloc/location_bloc.dart';
import 'domain/bloc/location_event.dart';
import 'presentation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barikoi Map Task',
      theme: ThemeData(primarySwatch: Colors.green),
      home: BlocProvider(
        create: (_) => LocationBloc()..add(LocationPermissionCheckEvent()),
        child: const HomePage(),
      ),
    );
  }
}
