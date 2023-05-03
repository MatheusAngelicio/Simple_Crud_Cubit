import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:simple_firebase_crud_cubit/src/navigation/routes.dart';
import 'package:simple_firebase_crud_cubit/src/ui/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: Routes.routes,
    );
  }
}
