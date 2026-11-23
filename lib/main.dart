import 'package:flutter/material.dart';
import 'package:pml/api/pizza.dart';
import 'package:pml/model/pizza.dart';
import 'package:pml/pages/detail.dart';

void main() {
  runApp(const MyApp());
}

/// Root widget aplikasi Pizza REST API
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizzeria REST API - Ferdi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD32F2F), // Tema merah pizzeria
          primary: const Color(0xFFC62828),
          secondary: const Color(0xFFFF8F00),
          surface: const Color(0xFFFFFDF9),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
          backgroundColor: Color(0xFFC62828),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFC62828),
          foregroundColor: Colors.white,
          elevation: 4,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

/// Halaman Utama: Menampilkan daftar pizza dari Mock API WireMock
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Instance HttpHelper untuk memanggil data API
  final HttpHelper _helper = HttpHelper();

  // Future untuk menampung pemanggilan data pizza
  late Future<List<Pizza>> _pizzasFuture;

  @override
  void initState() {
    super.initState();
    _refreshPizzas();
  }

  // Fungsi untuk memuat ulang daftar pizza lewat HttpHelper (Bukan http langsung)
  void _refreshPizzas() {
    setState(() {
      _pizzasFuture = _helper.getPizzaList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F5),
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_pizza, color: Colors.amberAccent, size: 24),
            SizedBox(width: 8),
            Text('Pizza Haven REST API - Ferdi'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Segarkan Menu',
            onPressed: _refreshPizzas,
          ),
        ],
      ),
      // FutureBuilder sesuai persyaratan untuk menangani status loading, error, dan data
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshPizzas();
        },
        child: FutureBuilder<List<Pizza>>(
          future: _pizzasFuture,
          builder: (BuildContext context, AsyncSnapshot<List<Pizza>> snapshot) {
            // 1. Kondisi Loading: Menampilkan indikator loading yang menarik
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: Color(0xFFC62828),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Menghubungkan ke WireMock API...',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            // 2. Kondisi Error: Menampilkan pesan error dan tombol coba lagi
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_off_rounded,
                        size: 72,
                        color: Colors.red.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Gagal Memuat Data',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC62828),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                        onPressed: _refreshPizzas,
                      ),
                    ],
                  ),
                ),
              );
            }

            // 3. Kondisi Data Kosong
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_pizza_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Belum ada menu pizza yang tersedia.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Gunakan tombol + untuk menambah pizza baru.',
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                  ],
                ),
              );
            }

            final List<Pizza> pizzaList = snapshot.data!;

            // 4. Kondisi Sukses: Menampilkan daftar pizza dalam bentuk Card modern
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Ringkasan Menu
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: const Color(0xFFFFF3E0),
                  child: Row(
                    children: [
                      const Icon(Icons.restaurant_menu,
                          size: 20, color: Color(0xFFE65100)),
                      const SizedBox(width: 8),
                      Text(
                        'Daftar Menu Spesial (${pizzaList.length} Pilihan)',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE65100),
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'Geser untuk hapus',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),

                // ListView Builder dengan Dismissible
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    itemCount: pizzaList.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (BuildContext context, int position) {
                      final currentPizza = pizzaList[position];

                      // Dismissible untuk menghapus item dengan swipe (DELETE)
                      return Dismissible(
                        key: Key('pizza_${currentPizza.id}_$position'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          decoration: BoxDecoration(
                            color: Colors.red.shade700,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 24),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Hapus Menu',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.delete_forever,
                                  color: Colors.white, size: 28),
                            ],
                          ),
                        ),
                        onDismissed: (direction) {
                          // Hapus item dari UI secara lokal
                          setState(() {
                            pizzaList.removeAt(position);
                          });

                          // Panggil deletePizza melalui HttpHelper (Bukan http.delete langsung)
                          _helper.deletePizza(currentPizza.id).then((res) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: Colors.white),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(res)),
                                  ],
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          });
                        },
                        child: Card(
                          margin: EdgeInsets.zero,
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            // Ketuk item untuk membuka halaman EDIT (PUT)
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PizzaDetailScreen(
                                    pizza: currentPizza,
                                    isNew: false, // Flag isNew: false untuk mode EDIT
                                  ),
                                ),
                              ).then((_) {
                                // Segarkan daftar saat kembali dari halaman detail
                                _refreshPizzas();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Gambar Thumbnail Pizza
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey.shade200,
                                      child: _buildPizzaThumbnail(
                                          currentPizza.imageUrl),
                                    ),
                                  ),
                                  const SizedBox(width: 14),

                                  // Informasi Detail Pizza
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                currentPizza.pizzaName,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            // Badge Harga
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFE8F5E9),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: Colors.green.shade400,
                                                ),
                                              ),
                                              child: Text(
                                                '€ ${currentPizza.price.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green.shade800,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          currentPizza.description.isNotEmpty
                                              ? currentPizza.description
                                              : 'Tidak ada deskripsi tersedia.',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 13,
                                            height: 1.25,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            if (currentPizza
                                                .category.isNotEmpty)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 2,
                                                ),
                                                margin: const EdgeInsets.only(
                                                    right: 8),
                                                decoration: BoxDecoration(
                                                  color: Colors.orange.shade50,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color:
                                                        Colors.orange.shade300,
                                                  ),
                                                ),
                                                child: Text(
                                                  currentPizza.category
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Colors.orange.shade900,
                                                  ),
                                                ),
                                              ),
                                            Text(
                                              'ID: #${currentPizza.id}',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey[500],
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const Spacer(),
                                            Icon(
                                              Icons.edit_note_rounded,
                                              size: 20,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      // Tombol Tambah Pizza Baru (POST) dengan flag isNew: true
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Pizza'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PizzaDetailScreen(
                pizza: Pizza(),
                isNew: true, // Flag isNew: true untuk mode INSERT / POST
              ),
            ),
          ).then((_) {
            // Segarkan data setelah kembali
            _refreshPizzas();
          });
        },
      ),
    );
  }

  /// Helper untuk membangun widget gambar thumbnail secara aman (fallback jika gagal)
  Widget _buildPizzaThumbnail(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset('assets/pizza.jpg', fit: BoxFit.cover),
      );
    } else if (imageUrl.isNotEmpty && imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.local_pizza, size: 40, color: Colors.orange),
      );
    }
    return Image.asset(
      'assets/pizza.jpg',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.local_pizza, size: 40, color: Colors.orange),
    );
  }
}
