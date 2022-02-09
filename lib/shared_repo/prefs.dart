import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedRepo {
  
  Future<void> clearPrefs() async{
    var prefs = await SharedPreferences.getInstance();
    prefs
        ..clear()
        ..remove('token')
        ..remove('userName');
      final cacheDir = await getTemporaryDirectory();
      if (cacheDir.existsSync()) {
        cacheDir.deleteSync(recursive: true);
      }
  }
  Future<void> insertToken({String? token, String? username}) async{
    var prefs = await SharedPreferences.getInstance();
    prefs
          ..setString('token', token.toString())
          ..setString('userName', username.toString());
  }

  Future<String> getValue(String key) async{
    var prefs = await SharedPreferences.getInstance();
    var value = prefs.getString(key);
    return value!;
  }
}