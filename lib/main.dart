import 'package:egy_park/screens/booked.dart';
import 'package:egy_park/screens/login.dart';
import 'package:egy_park/screens/map_screen.dart';
import 'package:egy_park/screens/park_details.dart';
import 'package:egy_park/screens/signup.dart';
import 'package:egy_park/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<void> initializeDefault() async {
    FirebaseApp app = await Firebase.initializeApp();
    assert(app != null);
    print('Initialized default app $app');
  }

  @override
  Widget build(BuildContext context) {
    initializeDefault();
    return MaterialApp(
      showSemanticsDebugger: false,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      title: 'Egy Park',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/maps': (context) => MapScreen(),
        '/details': (context) => ParkScreen(),
      },
    );
  }
}
