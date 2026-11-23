import 'package:flutter/material.dart';
import 'package:pml/api/pizza.dart';
import 'package:pml/model/pizza.dart';

/// Halaman Detail Pizza: Digunakan untuk menambah pizza baru (POST) atau memperbarui pizza (PUT)
class PizzaDetailScreen extends StatefulWidget {
  final Pizza pizza;
  final bool isNew; // Flag penanda: true untuk data baru (POST), false untuk edit (PUT)

  const PizzaDetailScreen({
    super.key,
    required this.pizza,
    required this.isNew,
  });

  @override
  State<PizzaDetailScreen> createState() => _PizzaDetailScreenState();
}

class _PizzaDetailScreenState extends State<PizzaDetailScreen> {
  // Controller untuk setiap field formulir
  final TextEditingController txtId = TextEditingController();
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtDescription = TextEditingController();
  final TextEditingController txtPrice = TextEditingController();
  final TextEditingController txtImageUrl = TextEditingController();
  final TextEditingController txtCategory = TextEditingController();

  // Global key untuk validasi form
  final _formKey = GlobalKey<FormState>();

  // State untuk menyimpan hasil operasi dari WireMock dan status loading
  String operationResult = '';
  bool isSaving = false;
  bool isSuccess = false;

  @override
  void initState() {
    super.initState();
    // Mengisi form jika dalam mode edit (isNew == false)
    if (!widget.isNew) {
      txtId.text = widget.pizza.id.toString();
      txtName.text = widget.pizza.pizzaName;
      txtDescription.text = widget.pizza.description;
      txtPrice.text = widget.pizza.price.toString();
      txtImageUrl.text = widget.pizza.imageUrl;
      txtCategory.text = widget.pizza.category;
    } else {
      // Nilai awal default untuk memudahkan penambahan data baru
      txtImageUrl.text = 'assets/pizza.jpg';
      txtCategory.text = 'classic';
    }
  }

  @override
  void dispose() {
    // Membebaskan controller dari memory
    txtId.dispose();
    txtName.dispose();
    txtDescription.dispose();
    txtPrice.dispose();
    txtImageUrl.dispose();
    txtCategory.dispose();
    super.dispose();
  }

  /// Fungsi untuk menyimpan data pizza ke Mock API WireMock
  /// Memanggil POST jika data baru (isNew == true) atau PUT jika data diedit (isNew == false)
  Future<void> savePizza() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSaving = true;
      operationResult = '';
    });

    // Parsing aman menggunakan int.tryParse dan double.tryParse sesuai checklist
    final int parsedId = int.tryParse(txtId.text.trim()) ?? 0;
    final double parsedPrice = double.tryParse(txtPrice.text.trim()) ?? 0.0;

    // Membuat objek model Pizza dari input controller
    final Pizza pizza = Pizza(
      id: parsedId,
      pizzaName: txtName.text.trim(),
      description: txtDescription.text.trim(),
      price: parsedPrice,
      imageUrl: txtImageUrl.text.trim().isNotEmpty
          ? txtImageUrl.text.trim()
          : 'assets/pizza.jpg',
      category: txtCategory.text.trim(),
    );

    // Menggunakan HttpHelper (Pola Singleton) untuk komunikasi ke API
    final HttpHelper helper = HttpHelper();

    // Menjalankan POST jika isNew == true, atau PUT jika isNew == false
    final String result = await (widget.isNew
        ? helper.postPizza(pizza)
        : helper.putPizza(pizza));

    if (!mounted) return;

    setState(() {
      operationResult = result;
      isSaving = false;
      // Periksa apakah hasil mengandung indikasi sukses
      isSuccess = result.toLowerCase().contains('posted') ||
          result.toLowerCase().contains('updated') ||
          result.toLowerCase().contains('berhasil') ||
          result.contains('200') ||
          result.contains('201');
    });

    // Tampilkan notifikasi snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isSuccess ? Colors.green.shade700 : Colors.red.shade700,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F5),
      appBar: AppBar(
        title: Text(widget.isNew ? 'Tambah Pizza Baru' : 'Edit Data Pizza'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Banner Kartu Informasi
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: widget.isNew
                            ? [const Color(0xFFC62828), const Color(0xFFE53935)]
                            : [const Color(0xFFE65100), const Color(0xFFF57C00)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: const Color(0x33FFFFFF),
                          child: Icon(
                            widget.isNew
                                ? Icons.add_circle_outline
                                : Icons.edit_note,
                            size: 34,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.isNew
                                    ? 'Request POST (Create)'
                                    : 'Request PUT (Update)',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.isNew
                                    ? 'Kirim data pizza baru ke Mock WireMock'
                                    : 'Perbarui entri pizza id: #${widget.pizza.id}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Banner Hasil Respon dari WireMock (Jika Ada)
                if (operationResult.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSuccess
                          ? const Color(0xFFE8F5E9)
                          : const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSuccess
                            ? Colors.green.shade400
                            : Colors.red.shade400,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          isSuccess
                              ? Icons.check_circle_outline
                              : Icons.error_outline,
                          color: isSuccess
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isSuccess
                                    ? 'Status: Berhasil (Response WireMock)'
                                    : 'Status: Peringatan / Error',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSuccess
                                      ? Colors.green.shade900
                                      : Colors.red.shade900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                operationResult,
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                  color: isSuccess
                                      ? Colors.green.shade900
                                      : Colors.red.shade900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                ],

                // Form Input Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informasi Menu Pizza',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Input ID (int.tryParse)
                        TextFormField(
                          controller: txtId,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'ID Pizza',
                            hintText: 'Masukkan ID angka (contoh: 1)',
                            prefixIcon: const Icon(Icons.tag_rounded),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'ID tidak boleh kosong';
                            }
                            if (int.tryParse(value.trim()) == null) {
                              return 'ID harus berupa angka integer valid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Input Nama Pizza
                        TextFormField(
                          controller: txtName,
                          decoration: InputDecoration(
                            labelText: 'Nama Pizza',
                            hintText: 'Contoh: Margherita Special',
                            prefixIcon: const Icon(Icons.local_pizza_rounded),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Nama Pizza tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Input Kategori Pizza
                        TextFormField(
                          controller: txtCategory,
                          decoration: InputDecoration(
                            labelText: 'Kategori (Opsional)',
                            hintText: 'Contoh: classic, premium, vegetarian',
                            prefixIcon: const Icon(Icons.category_rounded),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Input Harga (double.tryParse)
                        TextFormField(
                          controller: txtPrice,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: InputDecoration(
                            labelText: 'Harga (€ Euro)',
                            hintText: 'Contoh: 10.50',
                            prefixIcon: const Icon(Icons.euro_rounded),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Harga tidak boleh kosong';
                            }
                            if (double.tryParse(value.trim()) == null) {
                              return 'Harga harus berupa angka desimal valid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Input URL Gambar
                        TextFormField(
                          controller: txtImageUrl,
                          decoration: InputDecoration(
                            labelText: 'Image URL / Asset Path',
                            hintText: 'Contoh: assets/pizza.jpg atau URL online',
                            prefixIcon: const Icon(Icons.image_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Input Deskripsi
                        TextFormField(
                          controller: txtDescription,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Deskripsi Pizza',
                            hintText: 'Tuliskan deskripsi rasa dan topping pizza...',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(bottom: 40),
                              child: Icon(Icons.description_outlined),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Tombol Simpan (POST/PUT)
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: isSaving ? null : savePizza,
                    child: isSaving
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Mengirim data ke WireMock...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(widget.isNew
                                  ? Icons.cloud_upload_outlined
                                  : Icons.save_outlined),
                              const SizedBox(width: 8),
                              Text(
                                widget.isNew
                                    ? 'Kirim POST (Tambah Pizza)'
                                    : 'Simpan PUT (Update Pizza)',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: BorderSide(color: Colors.grey.shade400),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Kembali ke Daftar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
