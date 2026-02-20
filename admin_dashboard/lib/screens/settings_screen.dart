import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/admin_firebase_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, dynamic> _config = {};
  bool _loading = true;
  bool _saving = false;
  final _versionCtrl = TextEditingController();
  bool _maintenanceMode = false;
  final _messageCtrl = TextEditingController();

  // Admin management
  final _adminEmailCtrl = TextEditingController();
  final _adminUidCtrl = TextEditingController();
  List<Map<String, dynamic>> _admins = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _versionCtrl.dispose();
    _messageCtrl.dispose();
    _adminEmailCtrl.dispose();
    _adminUidCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final svc = AdminFirebaseService();
    final config = await svc.getConfig();
    final admins = await svc.getAdmins();
    if (mounted) {
      setState(() {
        _config = config;
        _versionCtrl.text = config['version'] ?? '2.0.0';
        _maintenanceMode = config['maintenanceMode'] ?? false;
        _messageCtrl.text = config['maintenanceMessage'] ?? '';
        _admins = admins;
        _loading = false;
      });
    }
  }

  Future<void> _saveConfig() async {
    setState(() => _saving = true);
    await AdminFirebaseService().saveConfig({
      'version': _versionCtrl.text.trim(),
      'maintenanceMode': _maintenanceMode,
      'maintenanceMessage': _messageCtrl.text.trim(),
    });
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ الإعدادات'),
          backgroundColor: Color(0xFF1B5E20),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      color: const Color(0xFFF5F5F5),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── App Settings ─────────────────────────────────────────────────
            _sectionHeader('إعدادات التطبيق', Icons.settings),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: _cardDecor(),
              child: Column(
                children: [
                  // Version
                  _labeledField(
                    label: 'إصدار التطبيق',
                    child: TextFormField(
                      controller: _versionCtrl,
                      decoration: _inputDecor('مثال: 2.0.0'),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Maintenance mode
                  _labeledField(
                    label: 'وضع الصيانة',
                    child: Row(
                      children: [
                        Switch(
                          value: _maintenanceMode,
                          activeColor: const Color(0xFF1B5E20),
                          onChanged: (v) =>
                              setState(() => _maintenanceMode = v),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _maintenanceMode ? 'مُفعَّل' : 'مُعطَّل',
                          style: TextStyle(
                            color: _maintenanceMode
                                ? Colors.red
                                : Colors.green.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_maintenanceMode) ...[
                    const SizedBox(height: 12),
                    _labeledField(
                      label: 'رسالة الصيانة',
                      child: TextFormField(
                        controller: _messageCtrl,
                        maxLines: 2,
                        decoration: _inputDecor(
                            'اكتب رسالة للمستخدمين أثناء الصيانة'),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: _saving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.save_outlined, size: 18),
                      label: Text(_saving ? 'جاري الحفظ...' : 'حفظ الإعدادات'),
                      onPressed: _saving ? null : _saveConfig,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Admin Management ─────────────────────────────────────────────
            _sectionHeader('إدارة المديرين', Icons.admin_panel_settings),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: _cardDecor(),
              child: Column(
                children: [
                  // Add admin form
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _adminEmailCtrl,
                          decoration: _inputDecor('البريد الإلكتروني'),
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _adminUidCtrl,
                          decoration: _inputDecor('UID (Firebase)'),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC4922A),
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.person_add, size: 16),
                        label: const Text('إضافة'),
                        onPressed: () async {
                          if (_adminUidCtrl.text.trim().isEmpty ||
                              _adminEmailCtrl.text.trim().isEmpty) return;
                          await AdminFirebaseService().addAdmin(
                            _adminUidCtrl.text.trim(),
                            _adminEmailCtrl.text.trim(),
                          );
                          _adminEmailCtrl.clear();
                          _adminUidCtrl.clear();
                          _loadData();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Admins list
                  if (_admins.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('لا يوجد مديرون مضافون',
                          style: TextStyle(color: Colors.grey),
                          textDirection: TextDirection.rtl),
                    )
                  else
                    ..._admins.map((admin) => ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFF1B5E20),
                            child: Icon(Icons.admin_panel_settings,
                                color: Colors.white, size: 18),
                          ),
                          title: Text(admin['email'] ?? admin['id']),
                          subtitle: Text(admin['id'] ?? '',
                              style: const TextStyle(
                                  fontSize: 10, fontFamily: 'monospace')),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle_outline,
                                color: Colors.red),
                            onPressed: () async {
                              await AdminFirebaseService()
                                  .removeAdmin(admin['id']);
                              _loadData();
                            },
                          ),
                        )),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Firebase Firestore rules ─────────────────────────────────────
            _sectionHeader('قواعد Firestore الموصى بها', Icons.security),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                '''rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
      match /bookmarks/{bookmarkId} {
        allow read, write: if request.auth.uid == userId;
      }
    }
    // Translations: public read, admin write
    match /translations/{surahId}/ayahs/{ayahId} {
      allow read: if true;
      allow write: if get(/databases/\$(database)/documents/admins/\$(request.auth.uid)).exists;
    }
    // Config: public read, admin write
    match /config/{docId} {
      allow read: if true;
      allow write: if get(/databases/\$(database)/documents/admins/\$(request.auth.uid)).exists;
    }
    // Admins: admin only
    match /admins/{adminId} {
      allow read, write: if get(/databases/\$(database)/documents/admins/\$(request.auth.uid)).exists;
    }
  }
}''',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Color(0xFFCDD6F4),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1B5E20), size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.amiri(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1B5E20)),
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }

  Widget _labeledField(
      {required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF555555)),
            textDirection: TextDirection.rtl),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  BoxDecoration _cardDecor() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      );

  InputDecoration _inputDecor(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: Color(0xFF1B5E20), width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      );
}
