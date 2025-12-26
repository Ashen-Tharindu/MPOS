import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase
  await Supabase.initialize(
    url: 'https://klqbyarwfzqydppdnddt.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtscWJ5YXJ3ZnpxeWRwcGRuZGR0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY2NzY1NjIsImV4cCI6MjA4MjI1MjU2Mn0.V2z8dh5msuACUgwgVQUFWXBb-P7yywSZSaxIzu4BoFk',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy POS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
