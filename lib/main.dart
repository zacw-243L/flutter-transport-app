import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import '../screens/login_screen.dart';
import '../screens/bus_screen.dart';
import '../screens/train_screen.dart';
import '../screens/taxi_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/bus': (context) => const BusScreen(),
        '/train': (context) => const TrainScreen(),
        '/taxi': (context) => const TaxiScreen(),
      },
    );
  }
}
