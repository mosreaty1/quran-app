import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/admin_firebase_service.dart';

// Surah metadata for the selector
const _surahNames = [
  'الفاتحة','البقرة','آل عمران','النساء','المائدة','الأنعام','الأعراف','الأنفال',
  'التوبة','يونس','هود','يوسف','الرعد','إبراهيم','الحجر','النحل','الإسراء',
  'الكهف','مريم','طه','الأنبياء','الحج','المؤمنون','النور','الفرقان','الشعراء',
  'النمل','القصص','العنكبوت','الروم','لقمان','السجدة','الأحزاب','سبأ','فاطر',
  'يس','الصافات','ص','الزمر','غافر','فصلت','الشورى','الزخرف','الدخان','الجاثية',
  'الأحقاف','محمد','الفتح','الحجرات','ق','الذاريات','الطور','النجم','القمر',
  'الرحمن','الواقعة','الحديد','المجادلة','الحشر','الممتحنة','الصف','الجمعة',
  'المنافقون','التغابن','الطلاق','التحريم','الملك','القلم','الحاقة','المعارج',
  'نوح','الجن','المزمل','المدثر','القيامة','الإنسان','المرسلات','النبأ','النازعات',
  'عبس','التكوير','الانفطار','المطففين','الانشقاق','البروج','الطارق','الأعلى',
  'الغاشية','الفجر','البلد','الشمس','الليل','الضحى','الشرح','التين','العلق',
  'القدر','البينة','الزلزلة','العاديات','القارعة','التكاثر','العصر','الهمزة',
  'الفيل','قريش','الماعون','الكوثر','الكافرون','النصر','المسد','الإخلاص',
  'الفلق','الناس',
];

const _ayahCounts = [
  7,286,200,176,120,165,206,75,129,109,123,111,43,52,99,128,111,110,98,135,
  112,78,118,64,77,227,93,88,69,60,34,30,73,54,45,83,182,88,75,85,54,53,89,
  59,37,35,38,29,18,45,60,49,62,55,78,96,29,22,24,13,14,11,11,18,12,12,30,
  52,52,44,28,28,20,56,40,31,50,45,78,27,33,30,26,25,25,17,22,30,19,17,11,
  16,16,13,11,11,8,3,6,3,5,4,5,7,3,6,6,8,8,6,6,5,4,5,5,3,4,5,5,2,4,1,7,6,
];

class TranslationsScreen extends StatefulWidget {
  const TranslationsScreen({super.key});

  @override
  State<TranslationsScreen> createState() => _TranslationsScreenState();
}

class _TranslationsScreenState extends State<TranslationsScreen> {
  int _selectedSurah = 1;
  List<Map<String, dynamic>> _translations = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadTranslations();
  }

  Future<void> _loadTranslations() async {
    setState(() => _loading = true);
    final data = await AdminFirebaseService()
        .getTranslationsForSurah(_selectedSurah);
    if (mounted) setState(() { _translations = data; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Row(
        children: [
          // ── Surah selector sidebar ────────────────────────────────────────
          Container(
            width: 220,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  color: const Color(0xFF1B5E20),
                  child: Text(
                    'اختر السورة',
                    style: GoogleFonts.amiri(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 114,
                    itemBuilder: (_, i) {
                      final selected = _selectedSurah == i + 1;
                      return ListTile(
                        dense: true,
                        selected: selected,
                        selectedColor: const Color(0xFF1B5E20),
                        selectedTileColor: const Color(0xFF1B5E20).withOpacity(0.1),
                        leading: CircleAvatar(
                          radius: 12,
                          backgroundColor: selected
                              ? const Color(0xFF1B5E20)
                              : Colors.grey.shade200,
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(
                                fontSize: 9,
                                color:
                                    selected ? Colors.white : Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          _surahNames[i],
                          style: GoogleFonts.amiri(
                              fontSize: 14,
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                          textDirection: TextDirection.rtl,
                        ),
                        subtitle: Text('${_ayahCounts[i]} آية',
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey),
                            textDirection: TextDirection.rtl),
                        onTap: () {
                          setState(() => _selectedSurah = i + 1);
                          _loadTranslations();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),

          // ── Translation editor ────────────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                // Toolbar
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC4922A),
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('إضافة ترجمة'),
                        onPressed: () => _showEditDialog(context, null),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B5E20),
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('تحديث'),
                        onPressed: _loadTranslations,
                      ),
                      const Spacer(),
                      Text(
                        '${_translations.length} / ${_ayahCounts[_selectedSurah - 1]} آية مترجمة',
                        style: const TextStyle(
                            fontSize: 13, color: Colors.grey),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // List
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _translations.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.translate_outlined,
                                      size: 64, color: Colors.grey),
                                  const SizedBox(height: 12),
                                  Text(
                                    'لا توجد ترجمات لهذه السورة',
                                    style: GoogleFonts.amiri(
                                        fontSize: 16,
                                        color: Colors.grey.shade400),
                                    textDirection: TextDirection.rtl,
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: _translations.length,
                              itemBuilder: (context, i) {
                                final t = _translations[i];
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 4),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Colors.grey.shade200),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Ayah number
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color:
                                                  const Color(0xFFC4922A),
                                              width: 1.5),
                                          color: const Color(0xFFC4922A)
                                              .withOpacity(0.08),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${t['ayahNumber']}',
                                            style: const TextStyle(
                                                fontSize: 11,
                                                color: Color(0xFFC4922A),
                                                fontWeight:
                                                    FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Translation text
                                      Expanded(
                                        child: Text(
                                          t['text'] ?? '',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              height: 1.5),
                                        ),
                                      ),
                                      // Actions
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                                Icons.edit_outlined,
                                                size: 18,
                                                color: Color(0xFF1B5E20)),
                                            onPressed: () =>
                                                _showEditDialog(
                                                    context, t),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                                Icons.delete_outline,
                                                size: 18,
                                                color: Colors.red),
                                            onPressed: () =>
                                                _deleteTranslation(
                                                    t['ayahNumber'] as int),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
      BuildContext context, Map<String, dynamic>? existing) {
    final isEdit = existing != null;
    final ayahCtrl = TextEditingController(
        text: isEdit ? '${existing['ayahNumber']}' : '');
    final textCtrl =
        TextEditingController(text: isEdit ? existing['text'] ?? '' : '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? 'تعديل الترجمة' : 'إضافة ترجمة',
            textDirection: TextDirection.rtl),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: ayahCtrl,
                keyboardType: TextInputType.number,
                enabled: !isEdit,
                decoration: InputDecoration(
                  labelText: 'رقم الآية',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  prefixText: '${_surahNames[_selectedSurah - 1]}: ',
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: textCtrl,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'نص الترجمة (إنجليزي)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                        color: Color(0xFF1B5E20), width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B5E20),
                foregroundColor: Colors.white),
            onPressed: () async {
              final ayahNum = int.tryParse(ayahCtrl.text);
              if (ayahNum == null || textCtrl.text.trim().isEmpty) {
                return;
              }
              await AdminFirebaseService().saveTranslation(
                _selectedSurah,
                ayahNum,
                textCtrl.text.trim(),
              );
              if (context.mounted) Navigator.pop(context);
              _loadTranslations();
            },
            child: Text(isEdit ? 'حفظ' : 'إضافة'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTranslation(int ayahNumber) async {
    await AdminFirebaseService()
        .deleteTranslation(_selectedSurah, ayahNumber);
    _loadTranslations();
  }
}
