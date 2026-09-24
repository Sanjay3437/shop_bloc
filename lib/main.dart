import 'package:flutter/material.dart';
import 'package:shop_bloc/core/dependency_injection/injector.dart';
import 'package:shop_bloc/main/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const App());
}