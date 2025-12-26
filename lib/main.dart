import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:knuckle_bones/core/infra/user_model.dart';
import 'package:knuckle_bones/my_app.dart';
//emulator -avd Pixel4 -accel on -gpu host

void _setupDependencies() {
  final getIt = GetIt.I;
  getIt.registerLazySingleton<UserModel>(() => UserModel.mock());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  _setupDependencies();
  runApp(const MyApp());
}
