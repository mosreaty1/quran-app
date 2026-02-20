import 'package:flutter/material.dart';
import '../models/ayah.dart';

class AyahCard extends StatelessWidget {
  final Ayah ayah;
  final bool showTranslation;
  final bool isBookmarked;
  final bool isDark;
  final double fontSize;
  final VoidCallback onBookmark;
  final VoidCallback onCopy;

  const AyahCard({
    super.key,
    required this.ayah,
    required this.showTranslation,
    required this.isBookmarked,
    required this.isDark,
    required this.fontSize,
    required this.onBookmark,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = isDark ? const Color(0xFF4CAF50) : const Color(0xFF1B5E20);
    final cardBg = isDark ? const Color(0xFF252525) : Colors.white;
    final dividerColor = isDark
        ? Colors.white.withOpacity(0.06)
        : Colors.black.withOpacity(0.06);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onLongPress: onBookmark,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Ayah number badge + actions row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onBookmark,
                        child: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                          color: isBookmarked ? accentColor : (isDark ? Colors.white38 : Colors.black38),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: onCopy,
                        child: Icon(
                          Icons.copy_outlined,
                          color: isDark ? Colors.white38 : Colors.black38,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  // Ayah number in decorative circle
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${ayah.ayahNumber}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Arabic text
              Text(
                ayah.text,
                style: TextStyle(
                  fontSize: fontSize,
                  height: 2.0,
                  color: isDark ? Colors.white : Colors.black87,
                  fontFamily: 'serif',
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
              // Translation
              if (showTranslation) ...[
                Divider(color: dividerColor, height: 24),
                Text(
                  ayah.translation,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
