import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knuckle_bones/my_app.dart';
//emulator -avd Pixel4 -accel on -gpu host

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}
