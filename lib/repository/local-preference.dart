import 'package:shared_preferences/shared_preferences.dart';

class LocalPreference {

  SharedPreferences? _pref;

  _ensureInitialized() async {
    try {
      if(_pref == null) {
        _pref = await SharedPreferences.getInstance();
      }
      return true;
    } catch (e) {
      // this will throw exception on integration testing
      return false;
    }
  }

  setString(String key, String value) async {
    if(!await _ensureInitialized()) return;

    _pref!.setString(key, value);
  }

  Future<String?> getString(String key) async {
    if(!await _ensureInitialized()) return null;

    return _pref!.getString(key);
  }
}