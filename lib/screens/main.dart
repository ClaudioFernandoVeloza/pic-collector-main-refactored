import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pic_collector/firebase_options.dart';
import 'package:pic_collector/screens/auth/login_screen.dart';
import 'package:pic_collector/screens/main-features/menu_orchestrator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pic Collector',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/menu': (_) => const MenuOrchestrator(),
      },
      home: const LoginScreen(),
    );
  }
}
