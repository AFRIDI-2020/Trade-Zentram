import 'package:get_storage/get_storage.dart';

class StorageService {
  final GetStorage _store = GetStorage();

  // Write data to GetStorage
  Future<void> writeData(String key, dynamic value) async {
    await _store.write(key, value);
  }

  // Read data from GetStorage
  dynamic readData(String key) {
    return _store.read(key);
  }
}
