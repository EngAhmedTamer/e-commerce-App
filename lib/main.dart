import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/view/splash_screen.dart';
import 'di.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://lveprsmocrkywpkphwbf.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx2ZXByc21vY3JreXdwa3Bod2JmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMxOTY4MTMsImV4cCI6MjA2ODc3MjgxM30.AXA_lsZpANRK9Cy_lChnbOqbsuZoiOOKOHG_eXNg4mQ',
  );

  await di.initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Elegant Login UI',
      theme: ThemeData(
        fontFamily: 'Roboto',
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
      ),
      home: const SplashScreen(),
    );
  }
}
