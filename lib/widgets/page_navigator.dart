import 'package:flutter/material.dart';

class PageNavigator extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Color bgColor;
  final ValueChanged<int> onPageChanged;

  const PageNavigator({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.bgColor,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Previous page
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.white),
            tooltip: 'Previous Page',
            onPressed: currentPage > 1
                ? () => onPageChanged(currentPage - 1)
                : null,
          ),
          // Page slider
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.white38,
                thumbColor: Colors.white,
                overlayColor: Colors.white24,
              ),
              child: Slider(
                value: currentPage.toDouble(),
                min: 1,
                max: totalPages.toDouble(),
                onChanged: (value) => onPageChanged(value.round()),
              ),
            ),
          ),
          // Next page
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white),
            tooltip: 'Next Page',
            onPressed: currentPage < totalPages
                ? () => onPageChanged(currentPage + 1)
                : null,
          ),
          // Go to page button
          GestureDetector(
            onTap: () => _showGoToPageDialog(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '$currentPage',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showGoToPageDialog(BuildContext context) {
    final controller = TextEditingController(text: '$currentPage');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Go to Page'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Page number (1–$totalPages)',
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final page = int.tryParse(controller.text);
              if (page != null && page >= 1 && page <= totalPages) {
                onPageChanged(page);
                Navigator.pop(context);
              }
            },
            child: const Text('Go'),
          ),
        ],
      ),
    );
  }
}
