import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _lastDeviceKey = 'lastDeviceId';

  Future<void> saveLastDeviceId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastDeviceKey, id);
  }

  Future<String?> getLastDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastDeviceKey);
  }

  Future<void> clearLastDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastDeviceKey);
  }
}
