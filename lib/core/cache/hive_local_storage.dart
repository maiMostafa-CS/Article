import 'package:hive/hive.dart';

import 'local_storage.dart';

class HiveLocalStorage implements LocalStorage {
  final Map<String, Box> _openBoxes = {};

  Future<Box> _getBox(String boxName) async {
    if (_openBoxes.containsKey(boxName) && _openBoxes[boxName]!.isOpen) {
      return _openBoxes[boxName]!;
    }
    
    try {
      final box = await Hive.openBox(boxName);
      _openBoxes[boxName] = box;
      return box;
    } catch (e) {
      // If box is already open, get it
      if (Hive.isBoxOpen(boxName)) {
        final box = Hive.box(boxName);
        _openBoxes[boxName] = box;
        return box;
      }
      rethrow;
    }
  }

  @override
  Future<dynamic> load({required String key, String? boxName}) async {
    try {
      final box = await _getBox(boxName!);
      return box.get(key);
    } catch (e) {
      throw Exception('Failed to load data from Hive: $e');
    }
  }

  @override
  Future<void> save({
    required String key,
    required dynamic value,
    String? boxName,
  }) async {
    try {
      final box = await _getBox(boxName!);
      await box.put(key, value);
    } catch (e) {
      throw Exception('Failed to save data to Hive: $e');
    }
  }

  @override
  Future<void> delete({required String key, String? boxName}) async {
    try {
      final box = await _getBox(boxName!);
      await box.delete(key);
    } catch (e) {
      throw Exception('Failed to delete data from Hive: $e');
    }
  }

  /// Close all open boxes
  Future<void> closeAllBoxes() async {
    for (final box in _openBoxes.values) {
      if (box.isOpen) {
        await box.close();
      }
    }
    _openBoxes.clear();
  }

  /// Close a specific box
  Future<void> closeBox(String boxName) async {
    if (_openBoxes.containsKey(boxName)) {
      final box = _openBoxes[boxName]!;
      if (box.isOpen) {
        await box.close();
      }
      _openBoxes.remove(boxName);
    }
  }
}
