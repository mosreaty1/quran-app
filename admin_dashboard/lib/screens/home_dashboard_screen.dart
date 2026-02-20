import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/admin_firebase_service.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  Map<String, dynamic>? _stats;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _loading = true);
    final stats = await AdminFirebaseService().getStats();
    if (mounted) setState(() { _stats = stats; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مرحباً بك في لوحة التحكم',
                          style: GoogleFonts.amiri(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'القرآن الكريم — Admin Dashboard v2.0',
                          style: TextStyle(
                              color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC4922A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text('تحديث الإحصاءات'),
                          onPressed: _loadStats,
                        ),
                      ],
                    ),
                  ),
                  // Quran icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: const Color(0xFFC4922A), width: 2),
                      color: Colors.white10,
                    ),
                    child: Center(
                      child: Text('ق',
                          style: GoogleFonts.amiri(
                              fontSize: 36,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Stats cards
            Text(
              'إحصاءات عامة',
              style: GoogleFonts.amiri(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B5E20)),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 12),
            _loading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : LayoutBuilder(builder: (context, constraints) {
                    final cols =
                        constraints.maxWidth > 700 ? 4 : 2;
                    return GridView.count(
                      crossAxisCount: cols,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.6,
                      children: [
                        _StatCard(
                          title: 'المستخدمون',
                          value: '${_stats?['totalUsers'] ?? 0}',
                          icon: Icons.people,
                          color: const Color(0xFF1B5E20),
                        ),
                        _StatCard(
                          title: 'المحفوظات',
                          value: '${_stats?['totalBookmarks'] ?? 0}',
                          icon: Icons.bookmark,
                          color: const Color(0xFFC4922A),
                        ),
                        _StatCard(
                          title: 'السور',
                          value: '114',
                          icon: Icons.menu_book,
                          color: const Color(0xFF1565C0),
                        ),
                        _StatCard(
                          title: 'الآيات',
                          value: '6,236',
                          icon: Icons.format_list_numbered,
                          color: const Color(0xFF6A1B9A),
                        ),
                      ],
                    );
                  }),
            const SizedBox(height: 24),

            // Quick info
            Text(
              'معلومات التطبيق',
              style: GoogleFonts.amiri(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B5E20)),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _infoRow('الإصدار', _stats?['appVersion'] ?? '2.0.0'),
                  _divider(),
                  _infoRow('وضع الصيانة',
                      _stats?['maintenance'] == true ? 'مفعّل' : 'مُعطَّل'),
                  _divider(),
                  _infoRow('إجمالي الصفحات', '604 صفحة'),
                  _divider(),
                  _infoRow('إجمالي الأجزاء', '30 جزء'),
                  _divider(),
                  _infoRow('قاعدة البيانات', 'Firebase Firestore'),
                  _divider(),
                  _infoRow('المصادقة', 'Firebase Auth'),
                ],
              ),
            ),

            const SizedBox(height: 24),
            // Firebase setup guide
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFC4922A).withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: Color(0xFFC4922A), size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'إعداد Firebase',
                        style: GoogleFonts.amiri(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF8B6914)),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '١. أنشئ مشروعاً في Firebase Console\n'
                    '٢. أضف تطبيق Android بـ Package ID: com.quranapp.quran_app\n'
                    '٣. أضف تطبيق Web للوحة التحكم\n'
                    '٤. عدّل firebase_options.dart في كلا المشروعين\n'
                    '٥. أنشئ Firestore Database في وضع Production\n'
                    '٦. أنشئ مستخدماً في Firebase Auth وأضفه لمجموعة admins',
                    style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF5D4037),
                        height: 1.7),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600,
                  color: Color(0xFF1B5E20))),
          Text(label,
              style: const TextStyle(
                  fontSize: 14, color: Color(0xFF666666)),
              textDirection: TextDirection.rtl),
        ],
      ),
    );
  }

  Widget _divider() => Divider(color: Colors.grey.shade100, height: 1);
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color),
                ),
                Text(title,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF888888))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
