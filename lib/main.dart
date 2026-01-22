import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:knuckle_bones/features/auth/data/firebase_auth_repository.dart';
import 'package:knuckle_bones/features/auth/domain/i_auth_repository.dart';
import 'package:knuckle_bones/features/auth/presentation/views/auth_controller.dart';
import 'package:knuckle_bones/firebase_options.dart';
import 'package:knuckle_bones/my_app.dart';

//emulator -avd Pixel4 -accel on -gpu host

void _setupDependencies() {
  final getIt = GetIt.I;
  getIt.registerLazySingleton<IAuthRepository>(() => FirebaseAuthRepository());
  getIt.registerSingleton<AuthController>(
    AuthController(getIt<IAuthRepository>()),
  );
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
