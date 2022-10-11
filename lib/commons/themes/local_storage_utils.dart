import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageService {
  static void writeItem(String key, String value) {
    try {
      FlutterSecureStorage().write(key: key, value: value);
    } catch (ex) {
      debugPrint(ex.toString());
    }
  }

  static Future<String> readItem(String key) async {
    try {
      String? value = await FlutterSecureStorage().read(key: key);
      return value ?? '';
    } catch (e) {
      debugPrint('LocalStorageService.readItem Exception: ${e.toString()}');
    }
    return '';
  }

  static Future<void> deleteItem({required String key}) async {
    try {
      await FlutterSecureStorage().delete(key: key);
    } catch (ex) {
      debugPrint('LocalStorageService.deleteItem Exception: ${ex.toString()}');
    }
  }

  static Future<void> clearAllItem() async {
    try {
      await FlutterSecureStorage().deleteAll();
    } catch (ex) {
      debugPrint('LocalStorageService.clearAllItem Exception: ${ex.toString()}');
    }
  }
}
