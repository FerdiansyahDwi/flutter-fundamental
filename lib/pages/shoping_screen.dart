import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pml/data/barang.dart';
import 'package:pml/domain/barang.dart';
import 'package:pml/utils/formatters.dart';
import 'package:pml/widgets/marketplace_footer.dart';

class ShopingScreen extends StatefulWidget {
  const ShopingScreen({super.key});

  @override
  State<ShopingScreen> createState() => _ShopingScreenState();
}

class _ShopingScreenState extends State<ShopingScreen> {
  String _selectedCategory = 'Semua';
  String _selectedSort = 'Rekomendasi';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final PageController _bannerController = PageController();
  int _activeBannerIndex = 0;
  int _cartItemCount = 3;
  final Set<int> _favoriteProductIds = {1, 3};

  final List<String> _categories = [
    'Semua',
    'Sembako',
    'Minyak',
    'Minuman',
    'Bumbu & Tepung',
  ];

  final List<String> _sortOptions = [
    'Rekomendasi',
    'Paling Laris',
    'Harga Termurah',
    'Rating Tertinggi',
  ];

  final List<Map<String, dynamic>> _promoBanners = [
    {
      'tag': 'SEGARPEDIA GAJIAN',
      'title': 'Diskon Sembako s/d 35%',
      'subtitle': 'Beras, Minyak & Gula Murah Berkualitas',
      'code': 'SEGARHEMAT',
      'gradient': const [Color(0xFF0284C7), Color(0xFF38BDF8)],
      'icon': Icons.local_offer_rounded,
    },
    {
      'tag': 'GRATIS ONGKIR XTRA',
      'title': 'Bebas Ongkir Seluruh Malang',
      'subtitle': 'Tanpa minimum belanja untuk semua pelanggan',
      'code': 'ONGKIRNOL',
      'gradient': const [Color(0xFF0369A1), Color(0xFF0EA5E9)],
      'icon': Icons.electric_bolt_rounded,
    },
    {
      'tag': 'CASHBACK SEGARPAY',
      'title': 'Cashback 20% Bayar Pakai QRIS',
      'subtitle': 'Belanja hemat kebutuhan dapur setiap hari',
      'code': 'SEGAR20',
      'gradient': const [Color(0xFF0284C7), Color(0xFF60A5FA)],
      'icon': Icons.savings_rounded,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  List<Barang> get _filteredAndSortedList {
    List<Barang> list = List.from(list_barang);

    // Filter Kategori
    if (_selectedCategory != 'Semua') {
      list = list.where((b) => b.kategori == _selectedCategory).toList();
    }

    // Filter Pencarian
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.toLowerCase().trim();
      list = list.where((b) {
        return b.nama_barang.toLowerCase().contains(query) ||
            b.kategori.toLowerCase().contains(query) ||
            b.deskripsi.toLowerCase().contains(query);
      }).toList();
    }

    // Pengurutan / Sort
    if (_selectedSort == 'Paling Laris') {
      list.sort((a, b) => b.terjual.compareTo(a.terjual));
    } else if (_selectedSort == 'Harga Termurah') {
      list.sort((a, b) => a.harga.compareTo(b.harga));
    } else if (_selectedSort == 'Rating Tertinggi') {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return list;
  }

  void _toggleFavorite(int id) {
    setState(() {
      if (_favoriteProductIds.contains(id)) {
        _favoriteProductIds.remove(id);
      } else {
        _favoriteProductIds.add(id);
      }
    });
  }

  void _addToCart(Barang barang) {
    setState(() {
      _cartItemCount++;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFF0284C7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Berhasil ditambahkan!',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    barang.nama_barang,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFCBD5E1),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredAndSortedList;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // APP BAR RAPI DENGAN JARAK AMAN & TIDAK MENUMPUK
            _buildAppBar(),

            // Delivery Location Bar
            SliverToBoxAdapter(
              child: _buildLocationBar(),
            ),

            // Dompet Digital & Koin SegarPay Bar
            SliverToBoxAdapter(
              child: _buildWalletBalanceBar(),
            ),

            // Promo Banner Carousel
            SliverToBoxAdapter(
              child: _buildBannerCarousel(),
            ),

            // Quick Service Shortcuts (Fitur Pilihan)
            SliverToBoxAdapter(
              child: _buildQuickServicesGrid(),
            ),

            // Flash Sale Highlight Section
            SliverToBoxAdapter(
              child: _buildFlashSaleSection(),
            ),

            // Horizontal Categories
            SliverToBoxAdapter(
              child: _buildCategoryChips(),
            ),

            // Sort & Filter Toolbar
            SliverToBoxAdapter(
              child: _buildSortAndSummaryBar(filteredList.length),
            ),

            // GRID VIEW PRODUK DENGAN HERO WIDGET
            if (filteredList.isEmpty)
              SliverToBoxAdapter(
                child: _buildEmptyState(),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.58,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final barang = filteredList[index];
                      final isFav = _favoriteProductIds.contains(barang.id);
                      return _buildProductCard(barang, isFav);
                    },
                    childCount: filteredList.length,
                  ),
                ),
              ),

            // FOOTER APLIKASI DENGAN IDENTITAS PENGEMBANG
            const SliverToBoxAdapter(
              child: MarketplaceFooter(),
            ),
          ],
        ),
      ),
    );
  }

  // APP BAR BARU DENGAN TATA LETAK TERPISAH, LEGA, DAN TIDAK BERTABRAKAN
  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      floating: false,
      toolbarHeight: 68,
      backgroundColor: const Color(0xFF0284C7),
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      titleSpacing: 16,
      // HEADER BRAND BARU: SegarPedia
      title: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.shopping_bag_rounded,
              color: Color(0xFF0284C7),
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'SegarPedia',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'Belanja Segar & Hemat',
                style: TextStyle(
                  color: Color(0xFFE0F2FE),
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border_rounded, color: Colors.white),
          tooltip: 'Favorit',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${_favoriteProductIds.length} produk di favorit Anda'),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
        Stack(
          alignment: Alignment.topRight,
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
              tooltip: 'Keranjang Belanja',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$_cartItemCount barang siap di-checkout'),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
            if (_cartItemCount > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    '$_cartItemCount',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 6),
      ],
      // KOLOM PENCARIAN DILETAKKAN PADA BOTTOM DENGAN PADDING AMAN TANPA OVERFLOW
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(58),
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
              decoration: InputDecoration(
                hintText: 'Cari beras, minyak, telur, sembako...',
                hintStyle: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 13,
                ),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF0284C7)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF94A3B8)),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFFE0F2FE),
      child: Row(
        children: const [
          Icon(Icons.location_on_rounded, size: 16, color: Color(0xFF0284C7)),
          SizedBox(width: 6),
          Text(
            'Dikirim ke: ',
            style: TextStyle(fontSize: 12, color: Color(0xFF475569)),
          ),
          Text(
            'STMIK STIMATA - Kota Malang',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0284C7),
            ),
          ),
          Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Color(0xFF0284C7)),
          Spacer(),
          Icon(Icons.verified_rounded, size: 14, color: Color(0xFF10B981)),
          SizedBox(width: 3),
          Text(
            'Bebas Ongkir',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF059669),
            ),
          ),
        ],
      ),
    );
  }

  // FITUR KREASI TAMBAHAN: SegarPay & Koin Mini Bar
  Widget _buildWalletBalanceBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // SegarPay
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 18,
                  color: Color(0xFF0284C7),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'SegarPay',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  Text(
                    'Rp 150.000',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(width: 1, height: 26, color: const Color(0xFFE2E8F0)),
          // Koin
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.monetization_on_rounded,
                  size: 18,
                  color: Color(0xFFD97706),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Koin Segar',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  Text(
                    '4.500 Koin',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(width: 1, height: 26, color: const Color(0xFFE2E8F0)),
          // Voucher Kupon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.confirmation_number_rounded,
                  size: 18,
                  color: Color(0xFF16A34A),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Voucher Saya',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  Text(
                    '3 Kupon Aktif',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF16A34A),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCarousel() {
    return Column(
      children: [
        Container(
          height: 140,
          margin: const EdgeInsets.only(top: 14),
          child: PageView.builder(
            controller: _bannerController,
            itemCount: _promoBanners.length,
            onPageChanged: (index) {
              setState(() {
                _activeBannerIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final banner = _promoBanners[index];
              final gradientList = banner['gradient'] as List<Color>;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientList,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: gradientList[0].withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -15,
                      bottom: -15,
                      child: Icon(
                        banner['icon'] as IconData,
                        size: 130,
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              banner['tag'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 10,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            banner['title'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            banner['subtitle'] as String,
                            style: const TextStyle(
                              color: Color(0xFFF0F9FF),
                              fontSize: 11.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.confirmation_number_rounded,
                                        size: 13, color: Color(0xFF0284C7)),
                                    const SizedBox(width: 4),
                                    Text(
                                      banner['code'] as String,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF0284C7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Klaim Sekarang >',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _promoBanners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _activeBannerIndex == index ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _activeBannerIndex == index
                    ? const Color(0xFF0284C7)
                    : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // FITUR KREASI TAMBAHAN: Quick Service Shortcuts Menu
  Widget _buildQuickServicesGrid() {
    final services = [
      {'icon': Icons.bolt_rounded, 'label': 'Flash Sale', 'color': const Color(0xFFEF4444)},
      {'icon': Icons.rice_bowl_rounded, 'label': 'Sembako', 'color': const Color(0xFF0284C7)},
      {'icon': Icons.card_giftcard_rounded, 'label': 'Kupon', 'color': const Color(0xFFF59E0B)},
      {'icon': Icons.local_shipping_rounded, 'label': 'Free Ongkir', 'color': const Color(0xFF10B981)},
      {'icon': Icons.percent_rounded, 'label': 'Diskon 50%', 'color': const Color(0xFF8B5CF6)},
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: services.map((s) {
          final color = s['color'] as Color;
          return GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Membuka menu ${s['label']}'),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(milliseconds: 900),
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(s['icon'] as IconData, color: color, size: 22),
                ),
                const SizedBox(height: 6),
                Text(
                  s['label'] as String,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF334155),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // FITUR KREASI TAMBAHAN: Section Flash Sale dengan Countdown Timer
  Widget _buildFlashSaleSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFEF2F2), Color(0xFFFFF7ED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0xFFEF4444),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.flash_on_rounded, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'FLASH SALE HARI INI',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  color: Color(0xFF991B1B),
                  letterSpacing: 0.3,
                ),
              ),
              Text(
                'Kebutuhan pokok harga termurah',
                style: TextStyle(fontSize: 10.5, color: Color(0xFF7F1D1D)),
              ),
            ],
          ),
          const Spacer(),
          // Countdown Boxes
          Row(
            children: [
              _buildTimerBox('02'),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Text(':', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF991B1B))),
              ),
              _buildTimerBox('45'),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Text(':', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF991B1B))),
              ),
              _buildTimerBox('18'),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildTimerBox(String num) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        num,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = cat == _selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = cat;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0284C7) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? const Color(0xFF0284C7) : const Color(0xFFE2E8F0),
                  width: 1.2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF0284C7).withValues(alpha: 0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                cat,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF475569),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSortAndSummaryBar(int totalItems) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'Katalog Produk Pilihan',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$totalItems',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0284C7),
                  ),
                ),
              ),
            ],
          ),
          PopupMenuButton<String>(
            initialValue: _selectedSort,
            onSelected: (val) {
              setState(() {
                _selectedSort = val;
              });
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.sort_rounded, size: 14, color: Color(0xFF0284C7)),
                  const SizedBox(width: 4),
                  Text(
                    _selectedSort,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.arrow_drop_down, size: 16, color: Color(0xFF64748B)),
                ],
              ),
            ),
            itemBuilder: (context) {
              return _sortOptions.map((s) {
                return PopupMenuItem(
                  value: s,
                  child: Text(s, style: const TextStyle(fontSize: 13)),
                );
              }).toList();
            },
          ),
        ],
      ),
    );
  }

  // WIDGET CARD GRIDVIEW MODERN DENGAN HERO WIDGET
  Widget _buildProductCard(Barang barang, bool isFav) {
    final discountPercent = barang.hargaCoret != null
        ? (((barang.hargaCoret! - barang.harga) / barang.hargaCoret!) * 100).round()
        : null;

    final isLowStock = barang.stok <= 20;

    return GestureDetector(
      onTap: () {
        context.push('/detail/${barang.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FOTO PRODUK DENGAN HERO WIDGET
              Stack(
                children: [
                  Hero(
                    tag: 'product-image-${barang.id}',
                    child: SizedBox(
                      height: 135,
                      width: double.infinity,
                      child: Image.network(
                        barang.foto,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFFE0F2FE),
                          child: const Center(
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              size: 40,
                              color: Color(0xFF0284C7),
                            ),
                          ),
                        ),
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: const Color(0xFFF0F9FF),
                            child: const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF0284C7),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Diskon Badge
                  if (discountPercent != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          '-$discountPercent%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),

                  // Favorite Button
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () => _toggleFavorite(barang.id),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          size: 16,
                          color: isFav ? const Color(0xFFEF4444) : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),

                  // Kategori Tag
                  Positioned(
                    bottom: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        barang.kategori,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // DETAIL ATRIBUT PRODUK
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Nama Barang
                      Text(
                        barang.nama_barang,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                          color: Color(0xFF0F172A),
                        ),
                      ),

                      // Harga & Harga Coret
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatRupiah(barang.harga),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0284C7),
                            ),
                          ),
                          if (barang.hargaCoret != null)
                            Text(
                              formatRupiah(barang.hargaCoret!),
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: Color(0xFF94A3B8),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),

                      // Rating & Terjual
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                          const SizedBox(width: 2),
                          Text(
                            barang.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '• ${barang.terjual} terjual',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),

                      // Atribut Stok & Tombol Add to Cart
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Badge Stok
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: isLowStock ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isLowStock ? const Color(0xFFFCA5A5) : const Color(0xFF86EFAC),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 10,
                                  color: isLowStock ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  'Stok: ${barang.stok}',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w700,
                                    color: isLowStock ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Tombol Tambah Keranjang Cepat
                          GestureDetector(
                            onTap: () => _addToCart(barang),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0284C7),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0284C7).withValues(alpha: 0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.add_shopping_cart_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFE0F2FE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 48,
              color: Color(0xFF0284C7),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Produk Tidak Ditemukan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Coba ubah kata kunci pencarian atau pilih kategori yang lain.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _searchQuery = '';
                _selectedCategory = 'Semua';
              });
            },
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Reset Filter'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}
