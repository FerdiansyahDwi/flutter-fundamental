import 'package:flutter/material.dart';

class MarketplaceFooter extends StatelessWidget {
  const MarketplaceFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.blue.shade100, width: 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.04),
            offset: const Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Keunggulan Layanan Banner
          Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            color: const Color(0xFFF0F9FF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildServiceFeature(
                  icon: Icons.verified_user_rounded,
                  title: '100% Original',
                  subtitle: 'Produk Terjamin',
                  iconColor: const Color(0xFF0284C7),
                ),
                _buildDivider(),
                _buildServiceFeature(
                  icon: Icons.local_shipping_rounded,
                  title: 'Kirim Cepat',
                  subtitle: 'Gratis Ongkir',
                  iconColor: const Color(0xFF0EA5E9),
                ),
                _buildDivider(),
                _buildServiceFeature(
                  icon: Icons.support_agent_rounded,
                  title: 'Layanan 24/7',
                  subtitle: 'Siap Membantu',
                  iconColor: const Color(0xFF38BDF8),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: Column(
              children: [
                // Identitas Mahasiswa / Pengembang (Ferdiansyah Dwi Nugroho - NIM: 23.52.0008)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE0F2FE), Color(0xFFF0F9FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFBAE6FD), width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Badge Foto Profil / Icon Avatar Mahasiswa
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0284C7).withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.person_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          // Detail Mahasiswa
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0284C7),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'DEVELOPER IDENTITAS',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.verified_rounded, color: Color(0xFF0284C7), size: 16),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Ferdiansyah Dwi Nugroho',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: Color(0xFF0F172A),
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: const [
                                    Text(
                                      'NIM: ',
                                      style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
                                    ),
                                    Text(
                                      '23.52.0008',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF0284C7),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: Color(0xFFBAE6FD), height: 1),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Row(
                            children: [
                              Icon(Icons.school_rounded, size: 15, color: Color(0xFF0369A1)),
                              SizedBox(width: 5),
                              Text(
                                'STIMATA Malang',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0369A1),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.code_rounded, size: 15, color: Color(0xFF0369A1)),
                              SizedBox(width: 5),
                              Text(
                                'Praktikum Mobile Lanjut (PML)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0369A1),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Metode Pembayaran Yang Didukung
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Metode Pembayaran Terverifikasi',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildPaymentPill('QRIS'),
                    _buildPaymentPill('BCA Virtual'),
                    _buildPaymentPill('Mandiri'),
                    _buildPaymentPill('BRI'),
                    _buildPaymentPill('GoPay'),
                    _buildPaymentPill('ShopeePay'),
                    _buildPaymentPill('COD (Bayar di Tempat)'),
                  ],
                ),

                const SizedBox(height: 20),
                const Divider(color: Color(0xFFE2E8F0)),
                const SizedBox(height: 14),

                // Copyright & App info dengan nama SegarPedia
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE0F2FE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_bag_rounded,
                        size: 14,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'SegarPedia • Versi 1.0.0',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  '© 2026 SegarPedia by Ferdiansyah Dwi Nugroho (NIM: 23.52.0008). All Rights Reserved.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildServiceFeature({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: iconColor.withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  static Widget _buildDivider() {
    return Container(
      width: 1,
      height: 32,
      color: const Color(0xFFBAE6FD),
    );
  }

  static Widget _buildPaymentPill(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: Color(0xFF475569),
        ),
      ),
    );
  }
}