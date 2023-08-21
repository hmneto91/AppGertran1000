import 'package:shared_preferences/shared_preferences.dart';

class DataKeeped {
  Future<void> saveToken(String chave, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(chave, token);
  }

  Future<String> getToken(String chave) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token_global = prefs.getString(chave) ?? "";
    return token_global;
  }
}
