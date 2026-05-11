import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/main_screen.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
final ValueNotifier<String> userNameNotifier = ValueNotifier("Ica");
final ValueNotifier<String> userImageNotifier = ValueNotifier("https://picsum.photos/200/300");

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  bool isDark = prefs.getBool('isDark') ?? false;
  themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  
  userNameNotifier.value = prefs.getString('userName') ?? "Ica";
  userImageNotifier.value = prefs.getString('userImage') ?? "https://picsum.photos/200/300";
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'smart library',
          themeMode: currentMode,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.light,
              surface: const Color(0xFFF8F9FD),
            ),
            scaffoldBackgroundColor: const Color(0xFFF8F9FD),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black87),
              titleTextStyle: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: const Color(0xFFF8F9FD),
              surfaceTintColor: Colors.transparent,
              titleTextStyle: const TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
              contentTextStyle: const TextStyle(color: Colors.black87),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
              surface: const Color(0xFF1A1C1E),
              onSurface: const Color(0xFFE2E2E6),
              onSurfaceVariant: const Color(0xFFC2C7CF),
            ),
            scaffoldBackgroundColor: const Color(0xFF111315),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Color(0xFFE2E2E6)),
              titleTextStyle: TextStyle(color: Color(0xFFE2E2E6), fontSize: 20, fontWeight: FontWeight.bold),
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Color(0xFF1A1C1E),
              surfaceTintColor: Colors.transparent,
              titleTextStyle: TextStyle(color: Color(0xFFE2E2E6), fontSize: 20, fontWeight: FontWeight.bold),
              contentTextStyle: TextStyle(color: Color(0xFFE2E2E6)),
            ),
          ),
          home: const MainScreen(),
        );
      },
    );
  }
}



