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
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'smart library',
          themeMode: currentMode,
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.deepPurple,
            useMaterial3: true,
            brightness: Brightness.dark,
          ),
          home: const MainScreen(),
        );
      },
    );
  }
}



