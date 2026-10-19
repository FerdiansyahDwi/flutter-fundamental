import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pml/data/barang.dart';
import 'package:pml/domain/barang.dart';
import 'package:pml/utils/formatters.dart';

class DetailShopingScreen extends StatefulWidget {
  final String id;
  const DetailShopingScreen({super.key, required this.id});

  @override
  State<DetailShopingScreen> createState() => _DetailShopingScreenState();
}

class _DetailShopingScreenState extends State<DetailShopingScreen> {
  int _quantity = 1;
  bool _isFavorite = false;

  Barang get _barang {
    return list_barang.firstWhere(
      (b) => b.id.toString() == widget.id,
      orElse: () => list_barang.first,
    );
  }

  void _showCheckoutSheet(Barang barang) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Konfirmasi Pembelian',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      barang.foto,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 60,
                        height: 60,
                        color: const Color(0xFFE0F2FE),
                        child: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF0284C7)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          barang.nama_barang,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatRupiah(barang.harga),
                          style: const TextStyle(
                            color: Color(0xFF0284C7),
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'Jumlah: $_quantity item',
                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFE2E8F0)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Metode Pengiriman', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                  Text('Reguler Instant (Gratis)', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF10B981), fontSize: 13)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Pembayaran', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  Text(
                    formatRupiah(barang.harga * _quantity),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: const Color(0xFF0284C7),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        content: Text(
                          'Pesanan "$_quantity x ${barang.nama_barang}" berhasil diproses!',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Bayar Sekarang',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final barang = _barang;
    final discountPercent = barang.hargaCoret != null
        ? (((barang.hargaCoret! - barang.harga) / barang.hargaCoret!) * 100).round()
        : null;

    final isLowStock = barang.stok <= 20;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // SLIVER APP BAR DENGAN FOTO HERO WIDGET
          SliverAppBar(
            expandedHeight: 330,
            pinned: true,
            backgroundColor: const Color(0xFF0284C7),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.9),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A), size: 20),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/');
                    }
                  },
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  child: IconButton(
                    icon: const Icon(Icons.share_outlined, color: Color(0xFF0F172A), size: 20),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text('Tautan ${barang.nama_barang} disalin!'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  child: IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: _isFavorite ? const Color(0xFFEF4444) : const Color(0xFF0F172A),
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // IMPLEMENTASI HERO WIDGET PADA DETAIL SCREEN
                  Hero(
                    tag: 'product-image-${barang.id}',
                    child: Image.network(
                      barang.foto,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFE0F2FE),
                        child: const Center(
                          child: Icon(
                            Icons.shopping_bag_outlined,
                            size: 80,
                            color: Color(0xFF0284C7),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Gradient scrim at bottom of image
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 80,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.4),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Pill Kategori & Terjual
                  Positioned(
                    bottom: 14,
                    left: 16,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0284C7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            barang.kategori,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${barang.terjual} Terjual',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // BODY DETAIL PRODUK
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HARGA & DISKON
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              formatRupiah(barang.harga),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0284C7),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (barang.hargaCoret != null) ...[
                              Text(
                                formatRupiah(barang.hargaCoret!),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF94A3B8),
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF2F2),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: const Color(0xFFFCA5A5)),
                                ),
                                child: Text(
                                  '-$discountPercent%',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFDC2626),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 10),
                        // NAMA PRODUK
                        Text(
                          barang.nama_barang,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // RATING & ULASAN
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF59E0B)),
                                  const SizedBox(width: 4),
                                  Text(
                                    barang.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12.5,
                                      color: Color(0xFF92400E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${barang.reviewCount} Penilaian Pembeli',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF475569),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F2FE),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.verified_rounded, size: 14, color: Color(0xFF0284C7)),
                                  SizedBox(width: 4),
                                  Text(
                                    'Original 100%',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0284C7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // KARTU ESTIMASI PENGIRIMAN & BEBAS ONGKIR
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFBBF7D0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_shipping_rounded, color: Color(0xFF16A34A), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Gratis Ongkir Xtra (Se-Malang)',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12.5,
                                  color: Color(0xFF166534),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Estimasi Tiba: Besok • Kurir Instan Tersedia',
                                style: TextStyle(fontSize: 11, color: Color(0xFF15803D)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF16A34A),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Bebas Ongkir',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // STATUS STOK & GARANSI
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.inventory_2_rounded,
                                  color: isLowStock ? const Color(0xFFDC2626) : const Color(0xFF0284C7),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Ketersediaan Stok',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isLowStock ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isLowStock ? const Color(0xFFFCA5A5) : const Color(0xFF86EFAC),
                                ),
                              ),
                              child: Text(
                                isLowStock
                                    ? 'Sisa ${barang.stok} pcs (Segera Habis!)'
                                    : 'Stok Melimpah: ${barang.stok} pcs',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  color: isLowStock ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (barang.stok / 80).clamp(0.05, 1.0),
                            backgroundColor: const Color(0xFFE2E8F0),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isLowStock ? const Color(0xFFEF4444) : const Color(0xFF0284C7),
                            ),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '✓ Pengiriman hari ini untuk pesanan sebelum pukul 16:00 WIB',
                          style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // KARTU TOKO / PENJUAL
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2FE),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFBAE6FD)),
                          ),
                          child: const Center(
                            child: Icon(Icons.storefront_rounded, color: Color(0xFF0284C7), size: 26),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    barang.toko,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.verified, size: 14, color: Color(0xFF0284C7)),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${barang.kota} • Online 5 menit lalu',
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Halaman profil ${barang.toko}'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF0284C7)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          ),
                          child: const Text(
                            'Kunjungi',
                            style: TextStyle(
                              color: Color(0xFF0284C7),
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // SPESIFIKASI PRODUK
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Spesifikasi Produk',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildSpecRow('Kategori', barang.kategori),
                        _buildSpecRow('Berat / Ukuran', barang.berat),
                        _buildSpecRow('Asal Pengiriman', barang.kota),
                        _buildSpecRow('Kondisi', 'Baru & Segar'),
                        _buildSpecRow('Sertifikasi', 'Halal MUI No. ID0012345'),
                        _buildSpecRow('Masa Simpan', '12 Bulan'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // DESKRIPSI LENGKAP
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Deskripsi Produk',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          barang.deskripsi,
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: Color(0xFF334155),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // REVIEW / ULASAN SINGKAT PEMBELI
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Ulasan Pembeli',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'Lihat Semua (${barang.reviewCount}) >',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0284C7),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildReviewItem(
                          buyerName: 'Ahmad Faisal',
                          date: '2 hari lalu',
                          comment: 'Kualitas mantap, sesuai deskripsi. Pengiriman se-Malang cepat sekali dan kurir ramah.',
                        ),
                        const Divider(color: Color(0xFFE2E8F0), height: 16),
                        _buildReviewItem(
                          buyerName: 'Siti Rahmawati',
                          date: 'Seminggu lalu',
                          comment: 'Beras pulen harum, packing rapi aman tidak ada kebocoran. Langganan di sini terus!',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // FOOTER IDENTITAS PENGEMBANG (Ferdiansyah Dwi Nugroho - 23.52.0008)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F9FF),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFBAE6FD)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFF0284C7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.school_rounded, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'SegarPedia Marketplace - PML',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12.5,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Ferdiansyah Dwi Nugroho • NIM: 23.52.0008',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11.5,
                                  color: Color(0xFF0284C7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 80), // Ruang untuk sticky bottom bar
                ],
              ),
            ),
          ),
        ],
      ),

      // STICKY BOTTOM CHECKOUT ACTION BAR
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Chat Seller Button
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.chat_outlined, color: Color(0xFF0284C7)),
                  tooltip: 'Chat Penjual',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text('Membuka obrolan dengan ${barang.toko}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 10),

              // Quantity Selector
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 16),
                      onPressed: () {
                        if (_quantity > 1) {
                          setState(() {
                            _quantity--;
                          });
                        }
                      },
                    ),
                    Text(
                      '$_quantity',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 16),
                      onPressed: () {
                        if (_quantity < barang.stok) {
                          setState(() {
                            _quantity++;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Tambah Ke Keranjang (+)
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: const Color(0xFF0F172A),
                        content: Text(
                          '$_quantity x ${barang.nama_barang} ditambahkan ke keranjang!',
                          style: const TextStyle(color: Colors.white),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0284C7), width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Icon(Icons.add_shopping_cart_rounded, color: Color(0xFF0284C7)),
                ),
              ),

              const SizedBox(width: 8),

              // Beli Langsung
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => _showCheckoutSheet(barang),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    foregroundColor: Colors.white,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Beli Sekarang',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem({
    required String buyerName,
    required String date,
    required String comment,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: const Color(0xFFE0F2FE),
              child: Text(
                buyerName[0],
                style: const TextStyle(
                  color: Color(0xFF0284C7),
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              buyerName,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
                color: Color(0xFF0F172A),
              ),
            ),
            const Spacer(),
            Text(
              date,
              style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: List.generate(
            5,
            (_) => const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          comment,
          style: const TextStyle(fontSize: 12, color: Color(0xFF475569), height: 1.4),
        ),
      ],
    );
  }
}