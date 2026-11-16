// ============================================================================
// File: lib/main.dart
// Deskripsi: Aplikasi Toko Online Pizza "PizzaHub" yang mengintegrasikan:
//            - Model Pizza dengan Safe Parsing (tryParse & ??)
//            - SharedPreferences (saveAppCounter, getAppCounter)
//            - File I/O via path_provider + dart:io (writePizzaFile, readPizzaFile)
//            - FlutterSecureStorage (saveUserToken, getUserToken)
//            - Uji Edge Case Broken JSON (pizzalist_broken.json)
// ============================================================================

import 'package:flutter/material.dart';
import 'model/pizza.dart';
import 'services/local_storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PizzaApp());
}

/// Root Widget Aplikasi PizzaHub
class PizzaApp extends StatelessWidget {
  const PizzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PizzaHub Store & Persistence',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD32F2F), // Nuansa merah hangat pizza
          brightness: Brightness.light,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const PizzaHomeScreen(),
    );
  }
}

/// Layar Utama: Menampilkan Katalog Pizza, Panel Persistensi, dan Uji Verifikasi
class PizzaHomeScreen extends StatefulWidget {
  const PizzaHomeScreen({super.key});

  @override
  State<PizzaHomeScreen> createState() => _PizzaHomeScreenState();
}

class _PizzaHomeScreenState extends State<PizzaHomeScreen> {
  // Akses ke LocalStorageService tersendiri (Checklist 3)
  final LocalStorageService _storageService = LocalStorageService();

  // State data
  List<Pizza> _pizzas = [];
  bool _isLoading = false;
  String _currentSource = 'Belum dimuat';

  // State SharedPreferences
  int _appCounter = 0;

  // State FlutterSecureStorage
  String? _currentUserToken;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  /// Inisialisasi awal: Menambah counter aplikasi & mengecek token tersimpan
  /// Checklist 4: Menggunakan async/await dan try-catch
  Future<void> _initializeData() async {
    setState(() => _isLoading = true);
    try {
      // 1. SharedPreferences: Mengambil dan menambah hitungan buka aplikasi
      final int counter = await _storageService.incrementAppCounter();

      // 2. Secure Storage: Mengambil token pengguna yang tersimpan secara aman
      final String? token = await _storageService.getUserToken();

      // 3. File I/O: Coba baca dari file lokal jika ada, jika belum muat dari asset normal
      List<Pizza> loadedPizzas = await _storageService.readPizzaFile();
      String source = 'Penyimpanan File Lokal (dart:io)';

      if (loadedPizzas.isEmpty) {
        // Jika file lokal belum ada, muat dari asset default
        loadedPizzas = await _storageService.loadPizzasFromAsset(broken: false);
        source = 'Aset Default (pizzalist.json)';
        // Tulis pertama kali ke file lokal
        if (loadedPizzas.isNotEmpty) {
          await _storageService.writePizzaFile(loadedPizzas);
        }
      }

      if (!mounted) return;
      setState(() {
        _appCounter = counter;
        _currentUserToken = token;
        _pizzas = loadedPizzas;
        _currentSource = source;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnackbar('Gagal melakukan inisialisasi: $e', isError: true);
    }
  }

  // ==========================================================================
  // OPERASI PENYIMPANAN: File I/O (writePizzaFile, readPizzaFile)
  // ==========================================================================

  /// Membaca data pizza dari file penyimpanan lokal (readPizzaFile)
  Future<void> _handleReadFromFile() async {
    setState(() => _isLoading = true);
    final List<Pizza> result = await _storageService.readPizzaFile();
    if (!mounted) return;

    setState(() {
      _pizzas = result;
      _currentSource = 'File Lokal (readPizzaFile)';
      _isLoading = false;
    });

    if (result.isNotEmpty) {
      _showSnackbar('Berhasil memuat ${result.length} pizza dari file lokal!');
    } else {
      _showSnackbar('File lokal kosong atau belum ada data!', isError: true);
    }
  }

  /// Menyimpan daftar pizza saat ini ke dalam file lokal (writePizzaFile)
  Future<void> _handleWriteToFile() async {
    setState(() => _isLoading = true);
    final bool success = await _storageService.writePizzaFile(_pizzas);
    if (!mounted) return;

    setState(() => _isLoading = false);
    if (success) {
      _showSnackbar('Berhasil menyimpan ${_pizzas.length} pizza ke file lokal!');
    } else {
      _showSnackbar('Gagal menyimpan ke file lokal!', isError: true);
    }
  }

  // ==========================================================================
  // OPERASI PENGUJIAN: Normal vs Broken JSON (Checklist 1 & 5)
  // ==========================================================================

  /// Memuat data normal dari asset
  Future<void> _loadNormalAsset() async {
    setState(() => _isLoading = true);
    final List<Pizza> list =
        await _storageService.loadPizzasFromAsset(broken: false);
    if (!mounted) return;

    setState(() {
      _pizzas = list;
      _currentSource = 'Asset Normal (pizzalist.json)';
      _isLoading = false;
    });
    _showSnackbar('Data normal berhasil dimuat (${list.length} pizza).');
  }

  /// Memuat data broken/korup dari asset untuk menguji safe parsing (Checklist 5)
  Future<void> _loadBrokenAsset() async {
    setState(() => _isLoading = true);
    final List<Pizza> list =
        await _storageService.loadPizzasFromAsset(broken: true);
    if (!mounted) return;

    setState(() {
      _pizzas = list;
      _currentSource = 'Uji Broken JSON (pizzalist_broken.json)';
      _isLoading = false;
    });

    _showSnackbar(
      'Uji Berhasil! Data korup di-parse tanpa crash dan digantikan nilai ramah.',
    );
  }

  // ==========================================================================
  // OPERASI SharedPreferences: saveAppCounter & getAppCounter
  // ==========================================================================

  /// Dialog untuk mengubah nilai App Counter secara manual
  Future<void> _showUpdateCounterDialog() async {
    final TextEditingController controller =
        TextEditingController(text: _appCounter.toString());

    final int? newCounter = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Update SharedPreferences Counter'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Uji fungsi saveAppCounter & getAppCounter pada SharedPreferences:',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nilai Counter Baru',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final int parsed = int.tryParse(controller.text) ?? _appCounter;
              Navigator.pop(ctx, parsed);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (newCounter != null) {
      await _storageService.saveAppCounter(newCounter);
      final int updated = await _storageService.getAppCounter();
      if (!mounted) return;
      setState(() => _appCounter = updated);
      _showSnackbar('Counter SharedPreferences diperbarui ke: $updated');
    }
  }

  // ==========================================================================
  // OPERASI FlutterSecureStorage: saveUserToken & getUserToken
  // ==========================================================================

  /// Dialog untuk mengatur token pengguna / data rahasia
  Future<void> _showSecureTokenDialog() async {
    final TextEditingController tokenController =
        TextEditingController(text: _currentUserToken ?? '');

    final String? action = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.security, color: Colors.indigo),
            SizedBox(width: 8),
            Text('Flutter Secure Storage'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Menyimpan data sensitif (User Token / Password) terenkripsi secara aman:',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tokenController,
              decoration: const InputDecoration(
                labelText: 'User Token / Password Rahasia',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.vpn_key),
              ),
            ),
          ],
        ),
        actions: [
          if (_currentUserToken != null && _currentUserToken!.isNotEmpty)
            TextButton(
              onPressed: () => Navigator.pop(ctx, 'DELETE'),
              child: const Text('Hapus Token', style: TextStyle(color: Colors.red)),
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, tokenController.text.trim()),
            child: const Text('Simpan Enkripsi'),
          ),
        ],
      ),
    );

    if (action == 'DELETE') {
      await _storageService.deleteUserToken();
      final String? token = await _storageService.getUserToken();
      if (!mounted) return;
      setState(() => _currentUserToken = token);
      _showSnackbar('Token berhasil dihapus dari Secure Storage.');
    } else if (action != null) {
      await _storageService.saveUserToken(action);
      final String? token = await _storageService.getUserToken();
      if (!mounted) return;
      setState(() => _currentUserToken = token);
      _showSnackbar('Token berhasil dienkripsi & disimpan ke Secure Storage!');
    }
  }

  // ==========================================================================
  // OPERASI TAMBAH PIZZA BARU
  // ==========================================================================

  /// Menampilkan dialog form penambahan menu pizza baru
  Future<void> _showAddPizzaDialog() async {
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController descCtrl = TextEditingController();
    final TextEditingController priceCtrl = TextEditingController();

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Menu Pizza'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nama Pizza',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Pizza',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: priceCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Harga (\$) (contoh: 12.50)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Tambah & Simpan'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final int newId = (_pizzas.isEmpty)
          ? 1
          : (_pizzas.map((p) => p.id).reduce((a, b) => a > b ? a : b) + 1);

      final Pizza newPizza = Pizza(
        id: newId,
        pizzaName: nameCtrl.text.trim().isEmpty
            ? 'Pizza Custom #$newId'
            : nameCtrl.text.trim(),
        description: descCtrl.text.trim().isEmpty
            ? 'Pizza kustom lezat dengan resep pilihan.'
            : descCtrl.text.trim(),
        price: double.tryParse(priceCtrl.text) ?? 10.0,
        imageUrl: 'assets/pizza.jpg',
      );

      final updatedList = List<Pizza>.from(_pizzas)..add(newPizza);
      setState(() => _pizzas = updatedList);

      // Otomatis simpan ke file lokal agar persist
      await _storageService.writePizzaFile(updatedList);
      _showSnackbar('Pizza baru berhasil ditambahkan dan disimpan ke file lokal!');
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade800 : Colors.green.shade800,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ==========================================================================
  // WIDGET BUILDER
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.local_pizza, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'PizzaHub Pizzeria',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: theme.colorScheme.primary,
        elevation: 2,
        actions: [
          IconButton(
            tooltip: 'Tambah Pizza Baru',
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: _showAddPizzaDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _initializeData,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // 1. Panel Header Persistensi (SharedPreferences & SecureStorage)
                  _buildPersistenceSummaryCard(),
                  const SizedBox(height: 16),

                  // 2. Panel Toolbar Kontrol & Lab Pengujian AI
                  _buildControlPanelCard(),
                  const SizedBox(height: 16),

                  // 3. Status Bar Sumber Data Aktif
                  _buildSourceStatusBanner(),
                  const SizedBox(height: 12),

                  // 4. Daftar Pizza Card
                  if (_pizzas.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      alignment: Alignment.center,
                      child: const Text(
                        'Tidak ada data pizza. Muat data atau tambahkan baru!',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  else
                    ..._pizzas.map((pizza) => _buildPizzaCard(pizza)),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddPizzaDialog,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Pizza'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  /// Widget Card untuk Ringkasan SharedPreferences & SecureStorage
  Widget _buildPersistenceSummaryCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.storage, color: Colors.deepOrange),
                SizedBox(width: 8),
                Text(
                  'Status Persistensi Sistem',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 20),
            // Item SharedPreferences
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFFFECB3),
                child: Icon(Icons.touch_app, color: Colors.amber, size: 20),
              ),
              title: const Text(
                'SharedPreferences (saveAppCounter)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Counter Kunjungan / Buka Aplikasi: $_appCounter kali',
                style: const TextStyle(fontSize: 13),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit, size: 20, color: Colors.deepOrange),
                tooltip: 'Edit Counter',
                onPressed: _showUpdateCounterDialog,
              ),
            ),
            const SizedBox(height: 6),
            // Item FlutterSecureStorage
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFC8E6C9),
                child: Icon(Icons.lock, color: Colors.green, size: 20),
              ),
              title: const Text(
                'FlutterSecureStorage (saveUserToken)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                _currentUserToken != null && _currentUserToken!.isNotEmpty
                    ? 'Token Terenkripsi: ${_maskToken(_currentUserToken!)}'
                    : 'Belum ada token pengguna (Klik tombol kunci untuk set)',
                style: const TextStyle(fontSize: 13),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.key, size: 20, color: Colors.indigo),
                tooltip: 'Kelola Token Sensitif',
                onPressed: _showSecureTokenDialog,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget Card untuk Panel Kontrol File I/O & Pengujian Edge Case Broken JSON
  Widget _buildControlPanelCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.science, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  'Lab Verifikasi Kode & I/O Helper',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Gunakan tombol di bawah untuk menguji checklist persistensi & penanganan error:',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Tombol File I/O: Simpan
                ElevatedButton.icon(
                  onPressed: _handleWriteToFile,
                  icon: const Icon(Icons.save, size: 18),
                  label: const Text('writePizzaFile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                  ),
                ),
                // Tombol File I/O: Baca
                OutlinedButton.icon(
                  onPressed: _handleReadFromFile,
                  icon: const Icon(Icons.file_open, size: 18),
                  label: const Text('readPizzaFile'),
                ),
                // Tombol Pengujian 1: Muat Normal
                ActionChip(
                  avatar: const Icon(Icons.check_circle, size: 16, color: Colors.green),
                  label: const Text('Muat pizzalist.json'),
                  onPressed: _loadNormalAsset,
                ),
                // Tombol Pengujian 2: Broken JSON (Checklist 5)
                ActionChip(
                  avatar: const Icon(Icons.warning, size: 16, color: Colors.deepOrange),
                  label: const Text('Uji Broken JSON (Checklist 5)'),
                  backgroundColor: Colors.orange.shade50,
                  onPressed: _loadBrokenAsset,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Banner informasi sumber data aktif yang sedang ditampilkan
  Widget _buildSourceStatusBanner() {
    final bool isBrokenTest = _currentSource.contains('Broken');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isBrokenTest ? Colors.amber.shade100 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isBrokenTest ? Colors.amber.shade700 : Colors.grey.shade400,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isBrokenTest ? Icons.warning_amber_rounded : Icons.info_outline,
            size: 18,
            color: isBrokenTest ? Colors.amber.shade900 : Colors.black87,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Sumber Data: $_currentSource (${_pizzas.length} item)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isBrokenTest ? Colors.amber.shade900 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Widget Card untuk masing-masing Item Pizza
  Widget _buildPizzaCard(Pizza pizza) {
    // Mengecek apakah data pizza ini merupakan hasil fallback ramah
    final bool isFallbackItem = pizza.id == defaultPizzaId ||
        pizza.pizzaName == defaultPizzaName ||
        pizza.price == defaultPrice;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Pizza
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 80,
                height: 80,
                child: Image.asset(
                  pizza.imageUrl.isNotEmpty ? pizza.imageUrl : 'assets/pizza.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.local_pizza, size: 40, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Detail Pizza
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pizza.pizzaName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '\$${pizza.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD32F2F),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pizza.description,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'ID: ${pizza.id}',
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (isFallbackItem)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Fallback Ramah',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper untuk menyamarkan token sensitif saat ditampilkan
  String _maskToken(String token) {
    if (token.length <= 6) {
      return '*' * token.length;
    }
    return '${token.substring(0, 3)}${'*' * (token.length - 6)}${token.substring(token.length - 3)}';
  }
}
