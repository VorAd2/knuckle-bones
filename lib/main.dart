import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:knuckle_bones/core/data/firebase_auth_repository.dart';
import 'package:knuckle_bones/core/data/user_repository.dart';
import 'package:knuckle_bones/core/domain/i_auth_repository.dart';
import 'package:knuckle_bones/core/presentation/controllers/auth_controller.dart';
import 'package:knuckle_bones/firebase_options.dart';
import 'package:knuckle_bones/my_app.dart';

//emulator -avd Pixel4 -accel on -gpu host

void _setupDependencies() {
  final getIt = GetIt.I;
  getIt.registerLazySingleton<IAuthRepository>(() => FirebaseAuthRepository());
  getIt.registerSingleton<AuthController>(
    AuthController(getIt<IAuthRepository>()),
  );
  getIt.registerSingleton<UserRepository>(UserRepository());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  _setupDependencies();
  runApp(const MyApp());
}
