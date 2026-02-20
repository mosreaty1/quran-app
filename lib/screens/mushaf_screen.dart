import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quran_provider.dart';
import '../widgets/mushaf_page_widget.dart';
import '../widgets/page_navigator.dart';

class MushafScreen extends StatefulWidget {
  const MushafScreen({super.key});

  @override
  State<MushafScreen> createState() => _MushafScreenState();
}

class _MushafScreenState extends State<MushafScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<QuranProvider>();
    _pageController = PageController(initialPage: provider.currentPage - 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuranProvider>();
    final isDark = provider.nightMode;
    final bgColor = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFFDF6E3);
    final pageTextColor = isDark ? Colors.white70 : const Color(0xFF5C3317);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF2D2D2D) : const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'القرآن الكريم',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Page ${provider.currentPage} of ${provider.totalPages}',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(provider.showTranslation
                ? Icons.translate
                : Icons.translate_outlined),
            tooltip: 'Toggle Translation',
            onPressed: () => provider.toggleTranslation(),
          ),
          IconButton(
            icon: Icon(provider.nightMode
                ? Icons.wb_sunny_outlined
                : Icons.nightlight_outlined),
            tooltip: 'Toggle Night Mode',
            onPressed: () => provider.toggleNightMode(),
          ),
          PopupMenuButton<double>(
            icon: const Icon(Icons.text_fields),
            tooltip: 'Font Size',
            onSelected: (size) => provider.setFontSize(size),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 18.0, child: Text('Small')),
              const PopupMenuItem(value: 24.0, child: Text('Medium')),
              const PopupMenuItem(value: 30.0, child: Text('Large')),
              const PopupMenuItem(value: 36.0, child: Text('Extra Large')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: provider.totalPages,
              onPageChanged: (index) {
                provider.navigateToPage(index + 1);
              },
              itemBuilder: (context, index) {
                return MushafPageWidget(
                  pageNumber: index + 1,
                  bgColor: bgColor,
                  textColor: pageTextColor,
                );
              },
            ),
          ),
          PageNavigator(
            currentPage: provider.currentPage,
            totalPages: provider.totalPages,
            bgColor: isDark ? const Color(0xFF2D2D2D) : const Color(0xFF1B5E20),
            onPageChanged: (page) {
              provider.navigateToPage(page);
              _pageController.jumpToPage(page - 1);
            },
          ),
        ],
      ),
    );
  }
}
