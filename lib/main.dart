import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zaptask/screens/splashscreen.dart';
import 'model/remainder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(RemainderAdapter());
  await Hive.openBox<Remainder>('remainders');

  runApp(const ZapTask());
}

class ZapTask extends StatefulWidget {
  const ZapTask({super.key});

  @override
  State<ZapTask> createState() => _ZapTaskState();
}

class _ZapTaskState extends State<ZapTask> {
  bool _isDarkMode = false;

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ZapTask",
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
      ),
      // 🔹 Start with SplashScreen instead of HomeScreen
      home: SplashScreen(
        isDarkMode: _isDarkMode,
        onThemeToggle: toggleTheme,
      ),
    );
  }
}
