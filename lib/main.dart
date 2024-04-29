import 'package:flutter/material.dart';
import 'package:monarch/router_generator.dart';
import 'package:monarch/shared_prefs.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MySharedPreferences.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monarch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 90, 20, 200)),
        useMaterial3: true,
      ),
      initialRoute: 'home',
      onGenerateRoute: RouterGenerator.generateRoute,
    );
  }
}
