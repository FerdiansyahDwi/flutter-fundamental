// ============================================================================
// File: lib/services/local_storage_service.dart
// Deskripsi: Service tersendiri untuk mengelola persistensi data:
//            1. SharedPreferences (saveAppCounter, getAppCounter)
//            2. File I/O via path_provider + dart:io (writePizzaFile, readPizzaFile)
//            3. FlutterSecureStorage (saveUserToken, getUserToken)
// Sesuai Checklist 3: Pemisahan logika storage di service tersendiri.
// Sesuai Checklist 4: Penggunaan async/await dan try-catch pada setiap operasi I/O.
// ============================================================================

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/pizza.dart';

class LocalStorageService {
  // Singleton pattern agar instance service seragam di seluruh aplikasi
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  // --------------------------------------------------------------------------
  // KONSTANTA KUNCI PENYIMPANAN (Mencegah typo string literal)
  // --------------------------------------------------------------------------
  static const String keyAppCounter = 'app_open_counter';
  static const String keyUserAuthToken = 'user_auth_token';
  static const String pizzaFileName = 'pizzas_storage.json';

  // Inisialisasi secure storage dengan opsi enkripsi Android
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      resetOnError: true,
    ),
  );

  // ==========================================================================
  // BAGIAN 1: SharedPreferences (saveAppCounter, getAppCounter)
  // Digunakan untuk menyimpan preferensi ringan seperti penghitung pembukaan app
  // ==========================================================================

  /// Menyimpan nilai counter aplikasi ke SharedPreferences
  /// Checklist 4: Menggunakan async/await dan try-catch
  Future<bool> saveAppCounter(int counter) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool success = await prefs.setInt(keyAppCounter, counter);
      debugPrint('[SharedPreferences] Berhasil menyimpan counter: $counter');
      return success;
    } catch (e, stackTrace) {
      debugPrint('[SharedPreferences] Error saat saveAppCounter: $e');
      debugPrint(stackTrace.toString());
      return false;
    }
  }

  /// Mengambil nilai counter aplikasi dari SharedPreferences
  /// Mengembalikan 0 jika belum ada data atau terjadi error
  Future<int> getAppCounter() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int counter = prefs.getInt(keyAppCounter) ?? 0;
      debugPrint('[SharedPreferences] Berhasil membaca counter: $counter');
      return counter;
    } catch (e, stackTrace) {
      debugPrint('[SharedPreferences] Error saat getAppCounter: $e');
      debugPrint(stackTrace.toString());
      return 0;
    }
  }

  /// Helper untuk menambahkan counter secara otomatis (misal saat app dibuka)
  Future<int> incrementAppCounter() async {
    try {
      final int current = await getAppCounter();
      final int next = current + 1;
      await saveAppCounter(next);
      return next;
    } catch (e) {
      debugPrint('[SharedPreferences] Error incrementAppCounter: $e');
      return 0;
    }
  }

  // ==========================================================================
  // BAGIAN 2: File I/O dengan path_provider & dart:io (writePizzaFile, readPizzaFile)
  // Digunakan untuk menyimpan struktur data JSON yang lebih besar ke sistem file lokal
  // ==========================================================================

  /// Mendapatkan path file penyimpanan lokal di direktori dokumen aplikasi
  Future<File> _getLocalPizzaFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$pizzaFileName');
  }

  /// Menulis daftar Pizza ke dalam file lokal (writePizzaFile)
  /// Mengubah `List<Pizza>` menjadi format JSON string dan menyimpannya ke disk
  /// Checklist 4: Menggunakan async/await dan try-catch
  Future<bool> writePizzaFile(List<Pizza> pizzas) async {
    try {
      final File file = await _getLocalPizzaFile();

      // Serialisasi List<Pizza> ke List<Map> kemudian encode ke JSON String
      final List<Map<String, dynamic>> jsonList =
          pizzas.map((pizza) => pizza.toJson()).toList();
      final String jsonString = jsonEncode(jsonList);

      // Menulis string ke file secara asinkron
      await file.writeAsString(jsonString, flush: true);
      debugPrint('[File I/O] Berhasil menulis ${pizzas.length} pizza ke ${file.path}');
      return true;
    } catch (e, stackTrace) {
      debugPrint('[File I/O] Error saat writePizzaFile: $e');
      debugPrint(stackTrace.toString());
      return false;
    }
  }

  /// Membaca daftar Pizza dari file lokal (readPizzaFile)
  /// Membaca isi file, decode JSON, dan mem-parsing ke objek `List<Pizza>`
  /// Checklist 4: Menggunakan async/await dan try-catch
  /// Checklist 1: Parsing aman dengan Pizza.fromJson
  Future<List<Pizza>> readPizzaFile() async {
    try {
      final File file = await _getLocalPizzaFile();

      // Periksa apakah file sudah ada
      if (!await file.exists()) {
        debugPrint('[File I/O] File belum ada di ${file.path}');
        return [];
      }

      // Membaca teks dari file
      final String contents = await file.readAsString();
      if (contents.trim().isEmpty) {
        return [];
      }

      // Decode JSON string menjadi objek dinamis
      final dynamic decoded = jsonDecode(contents);
      if (decoded is List) {
        // Safe mapping menggunakan factory constructor Pizza.fromJson
        final List<Pizza> pizzas = decoded
            .map((item) => Pizza.fromJson(item as Map<String, dynamic>))
            .toList();
        debugPrint('[File I/O] Berhasil membaca ${pizzas.length} pizza dari file lokal');
        return pizzas;
      }
      return [];
    } catch (e, stackTrace) {
      debugPrint('[File I/O] Error saat readPizzaFile: $e');
      debugPrint(stackTrace.toString());
      return [];
    }
  }

  /// Helper untuk mengecek keberadaan file lokal
  Future<bool> isPizzaFileExists() async {
    try {
      final File file = await _getLocalPizzaFile();
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Helper untuk menghapus file lokal (misal untuk reset pengujian)
  Future<bool> deletePizzaFile() async {
    try {
      final File file = await _getLocalPizzaFile();
      if (await file.exists()) {
        await file.delete();
        debugPrint('[File I/O] File lokal berhasil dihapus');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('[File I/O] Gagal menghapus file: $e');
      return false;
    }
  }

  // ==========================================================================
  // BAGIAN 3: FlutterSecureStorage (saveUserToken, getUserToken)
  // Digunakan untuk menyimpan kredensial atau token sensitif dengan enkripsi hardware/OS
  // ==========================================================================

  /// Menyimpan token autentikasi pengguna ke penyimpanan aman (saveUserToken)
  /// Checklist 4: Menggunakan async/await dan try-catch
  Future<bool> saveUserToken(String token) async {
    try {
      await _secureStorage.write(key: keyUserAuthToken, value: token);
      debugPrint('[SecureStorage] Token pengguna berhasil disimpan secara aman');
      return true;
    } catch (e, stackTrace) {
      debugPrint('[SecureStorage] Error saat saveUserToken: $e');
      debugPrint(stackTrace.toString());
      return false;
    }
  }

  /// Mengambil token autentikasi pengguna dari penyimpanan aman (getUserToken)
  /// Mengembalikan null jika token belum pernah disimpan atau terjadi error
  /// Checklist 4: Menggunakan async/await dan try-catch
  Future<String?> getUserToken() async {
    try {
      final String? token = await _secureStorage.read(key: keyUserAuthToken);
      debugPrint('[SecureStorage] Berhasil membaca token: ${token != null ? "TERISI" : "KOSONG"}');
      return token;
    } catch (e, stackTrace) {
      debugPrint('[SecureStorage] Error saat getUserToken: $e');
      debugPrint(stackTrace.toString());
      return null;
    }
  }

  /// Menghapus token dari secure storage (misal saat logout pengguna)
  Future<bool> deleteUserToken() async {
    try {
      await _secureStorage.delete(key: keyUserAuthToken);
      debugPrint('[SecureStorage] Token pengguna berhasil dihapus');
      return true;
    } catch (e) {
      debugPrint('[SecureStorage] Error saat deleteUserToken: $e');
      return false;
    }
  }

  // ==========================================================================
  // BAGIAN 4: Pengujian Edge Case Broken JSON & Data Assets
  // Memenuhi Checklist 5: Menguji data korup (pizzalist_broken.json) tanpa crash
  // ==========================================================================

  /// Memuat data pizza dari assets:
  /// - `assets/pizzalist.json` untuk data normal
  /// - `assets/pizzalist_broken.json` untuk menguji skenario edge case data rusak/korup
  Future<List<Pizza>> loadPizzasFromAsset({bool broken = false}) async {
    final String assetPath =
        broken ? 'assets/pizzalist_broken.json' : 'assets/pizzalist.json';
    try {
      final String jsonString = await rootBundle.loadString(assetPath);
      final dynamic decoded = jsonDecode(jsonString);

      if (decoded is List) {
        final List<Pizza> pizzas = decoded.map((item) {
          if (item is Map<String, dynamic>) {
            return Pizza.fromJson(item);
          } else if (item is Map) {
            // Mengatasi kasus jika tipe generic berupa Map dinamis
            return Pizza.fromJson(Map<String, dynamic>.from(item));
          } else {
            // Jika item dalam list bukan berupa Map (misal string/integer liar)
            return Pizza.fromJson(const {});
          }
        }).toList();

        debugPrint(
            '[Asset Loader] Sukses membaca $assetPath (${pizzas.length} item, broken=$broken)');
        return pizzas;
      }
      return [];
    } catch (e, stackTrace) {
      debugPrint('[Asset Loader] Terjadi exception saat membaca $assetPath: $e');
      debugPrint(stackTrace.toString());
      return [];
    }
  }
}
