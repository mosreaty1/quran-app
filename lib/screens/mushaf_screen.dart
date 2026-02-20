import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/quran_provider.dart';
import '../widgets/mushaf_page_widget.dart';
import '../themes/app_theme.dart';

class MushafScreen extends StatefulWidget {
  const MushafScreen({super.key});

  @override
  State<MushafScreen> createState() => _MushafScreenState();
}

class _MushafScreenState extends State<MushafScreen> {
  late PageController _pageController;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    final p = context.read<QuranProvider>();
    _pageController = PageController(initialPage: p.currentPage - 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    final p = context.read<QuranProvider>();
    p.navigateToPage(page);
    _pageController.jumpToPage(page - 1);
  }

  void _showGoToPageDialog() {
    final p = context.read<QuranProvider>();
    final controller = TextEditingController(text: '${p.currentPage}');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor:
            p.nightMode ? MushafColors.nightSurface : MushafColors.parchment,
        title: Text(
          'انتقل إلى صفحة',
          textDirection: TextDirection.rtl,
          style: GoogleFonts.amiri(
            fontWeight: FontWeight.bold,
            color: p.nightMode ? MushafColors.nightText : MushafColors.inkDark,
          ),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '1 – ${p.totalPages}',
            border: OutlineInputBorder(
                borderSide: BorderSide(color: MushafColors.gold)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MushafColors.gold, width: 2)),
          ),
          style: TextStyle(
            color:
                p.nightMode ? MushafColors.nightText : MushafColors.inkDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: MushafColors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final page = int.tryParse(controller.text);
              if (page != null && page >= 1 && page <= p.totalPages) {
                _goToPage(page);
                Navigator.pop(context);
              }
            },
            child: const Text('انتقل'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<QuranProvider>();
    final isDark = p.nightMode;
    final appBarBg = isDark ? MushafColors.nightSurface : MushafColors.green;

    return Scaffold(
      backgroundColor:
          isDark ? MushafColors.nightBg : MushafColors.parchment,
      appBar: AppBar(
        backgroundColor: appBarBg,
        foregroundColor: Colors.white,
        title: GestureDetector(
          onTap: _showGoToPageDialog,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'القرآن الكريم',
                style: GoogleFonts.amiri(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                'صفحة ${p.currentPage} / ${p.totalPages}   •   اضغط للانتقال',
                style: const TextStyle(fontSize: 11, color: Colors.white60),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          // Translation toggle
          IconButton(
            icon: Icon(
              p.showTranslation
                  ? Icons.translate
                  : Icons.translate_outlined,
              color: p.showTranslation
                  ? const Color(0xFFDAA643)
                  : Colors.white70,
            ),
            tooltip: 'ترجمة',
            onPressed: p.toggleTranslation,
          ),
          // Night mode
          IconButton(
            icon: Icon(
              isDark ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
              color: Colors.white70,
            ),
            tooltip: 'الوضع الليلي',
            onPressed: p.toggleNightMode,
          ),
          // Font size
          PopupMenuButton<double>(
            icon: const Icon(Icons.text_fields, color: Colors.white70),
            tooltip: 'حجم الخط',
            onSelected: p.setFontSize,
            itemBuilder: (_) => [
              _menuItem(20, 'صغير'),
              _menuItem(26, 'متوسط'),
              _menuItem(32, 'كبير'),
              _menuItem(38, 'كبير جداً'),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Main Mushaf page viewer
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showControls = !_showControls),
              child: PageView.builder(
                controller: _pageController,
                itemCount: p.totalPages,
                onPageChanged: (i) => p.navigateToPage(i + 1),
                itemBuilder: (_, i) =>
                    MushafPageWidget(pageNumber: i + 1),
              ),
            ),
          ),
          // Bottom navigator
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: _showControls ? null : 0,
            child: _showControls
                ? _BottomNavigator(
                    currentPage: p.currentPage,
                    totalPages: p.totalPages,
                    isDark: isDark,
                    onPageChanged: _goToPage,
                    onGoTo: _showGoToPageDialog,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<double> _menuItem(double val, String label) =>
      PopupMenuItem(value: val, child: Text(label));
}

// ─── Bottom Page Navigator ────────────────────────────────────────────────────
class _BottomNavigator extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final bool isDark;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onGoTo;

  const _BottomNavigator({
    required this.currentPage,
    required this.totalPages,
    required this.isDark,
    required this.onPageChanged,
    required this.onGoTo,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? MushafColors.nightSurface : MushafColors.green;
    final accent = MushafColors.gold;

    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Prev page
          _navBtn(
            icon: Icons.chevron_right,
            color: accent,
            onTap: currentPage < totalPages
                ? () => onPageChanged(currentPage + 1)
                : null,
          ),
          // Page slider
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                activeTrackColor: accent,
                inactiveTrackColor: Colors.white24,
                thumbColor: accent,
                overlayColor: accent.withOpacity(0.2),
              ),
              child: Slider(
                value: currentPage.toDouble(),
                min: 1,
                max: totalPages.toDouble(),
                onChanged: (v) => onPageChanged(v.round()),
              ),
            ),
          ),
          // Next page
          _navBtn(
            icon: Icons.chevron_left,
            color: accent,
            onTap: currentPage > 1
                ? () => onPageChanged(currentPage - 1)
                : null,
          ),
          // Go to page
          GestureDetector(
            onTap: onGoTo,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: accent, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$currentPage',
                style: TextStyle(
                    color: accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navBtn(
      {required IconData icon,
      required Color color,
      required VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Icon(icon,
            color: onTap != null ? color : Colors.white24, size: 28),
      ),
    );
  }
}
