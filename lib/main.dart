import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'admin/screens/screens.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  get future => null;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FiveStick',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FutureBuilder(
        future: future,
        builder: (context, dataSnapShot){
          return const LoginScreen();
        },
      ),
    );
  }
}
