import 'package:flutter/material.dart';
import 'package:youtube/screens/signUp.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: "https://qhmueqttmimqsuexgbit.supabase.co",
      anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFobXVlcXR0bWltcXN1ZXhnYml0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTkyOTU0ODksImV4cCI6MjAzNDg3MTQ4OX0.bFvtCUG-NTeYeB0R6Ilm46D6Axe7HOsCmlPUN2GcY2c"
  );
  runApp(const MyApp());
}
final supabase = Supabase.instance.client;
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: signUpPage(),
    );
  }
}

