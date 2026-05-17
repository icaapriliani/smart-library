import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyUsername = 'username';
  static const String _keyEmail = 'auth_email';
  static const String _keyPassword = 'auth_password';
  static const String _keyIsLoggedIn = 'auth_is_logged_in';

  // Register a new user
  static Future<bool> register(String username, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Save user data
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyPassword, password);
    
    // Set login status to true
    await prefs.setBool(_keyIsLoggedIn, true);
    
    return true;
  }

  // Login an existing user
  static Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Retrieve stored data
    final storedEmail = prefs.getString(_keyEmail);
    final storedPassword = prefs.getString(_keyPassword);
    
    // Verify credentials
    if (storedEmail == email && storedPassword == password) {
      await prefs.setBool(_keyIsLoggedIn, true);
      return true;
    }
    
    return false;
  }

  // Logout the user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Get current username
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }
  
  // Get current email
  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  // Delete the user account
  static Future<void> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyPassword);
    await prefs.remove(_keyIsLoggedIn);
    // Remove profile data as well
    await prefs.remove('userName');
    await prefs.remove('userImage');
  }
}
