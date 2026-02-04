import 'package:flutter/material.dart';
import 'package:pwl_calc/ui/plate_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Powerlifting Calculator',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.red[700]!, // Vermelho escuro
          onPrimary: Colors.white,
          secondary: Colors.amber[700]!, // Âmbar para destaques
          onSecondary: Colors.white,
          surface: const Color(0xFF383838), // Superfícies escuras
          onSurface: Colors.white,
          error: Colors.red[400]!,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF1A1A1A),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      home: const MyHomePage(title: 'Montador de barras'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const PlateWidget(),
    );
  }
}
