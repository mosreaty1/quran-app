import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/admin_firebase_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    final err = await AdminFirebaseService()
        .signIn(_emailCtrl.text.trim(), _passCtrl.text);
    if (mounted) {
      setState(() { _loading = false; _error = err; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // ── Left panel: brand ────────────────────────────────────────────
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0D3B14), Color(0xFF1B5E20), Color(0xFF2E7D32)],
                ),
              ),
              child: Stack(
                children: [
                  // Geometric pattern
                  Positioned.fill(child: CustomPaint(painter: _PatternPainter())),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFC4922A), width: 3),
                            color: Colors.white.withOpacity(0.08),
                          ),
                          child: Center(
                            child: Text(
                              'القرآن\nالكريم',
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: GoogleFonts.amiri(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  height: 1.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'لوحة التحكم',
                          style: GoogleFonts.amiri(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Admin Dashboard',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white60,
                              letterSpacing: 3),
                        ),
                        const SizedBox(height: 30),
                        // Feature bullets
                        ...[
                          ('إدارة الترجمات', Icons.translate),
                          ('إدارة المستخدمين', Icons.people_outline),
                          ('إعدادات التطبيق', Icons.settings_outlined),
                          ('إحصاءات مباشرة', Icons.bar_chart_outlined),
                        ].map((f) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(f.$2, color: const Color(0xFFC4922A), size: 16),
                                  const SizedBox(width: 8),
                                  Text(f.$1,
                                      style: const TextStyle(
                                          color: Colors.white70, fontSize: 13),
                                      textDirection: TextDirection.rtl),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Right panel: login form ───────────────────────────────────────
          Container(
            width: 420,
            color: const Color(0xFFF8F8F8),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'تسجيل الدخول',
                        style: GoogleFonts.amiri(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1B5E20)),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'مخصص للمديرين فقط',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade500),
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 32),

                      // Email field
                      _buildField(
                        controller: _emailCtrl,
                        label: 'البريد الإلكتروني',
                        icon: Icons.email_outlined,
                        keyboard: TextInputType.emailAddress,
                        validator: (v) => v == null || !v.contains('@')
                            ? 'أدخل بريد إلكتروني صحيح'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Password field
                      _buildField(
                        controller: _passCtrl,
                        label: 'كلمة المرور',
                        icon: Icons.lock_outlined,
                        obscure: _obscure,
                        suffix: IconButton(
                          icon: Icon(_obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          onPressed: () =>
                              setState(() => _obscure = !_obscure),
                        ),
                        validator: (v) =>
                            v == null || v.length < 6
                                ? 'كلمة المرور قصيرة جداً'
                                : null,
                      ),
                      const SizedBox(height: 12),

                      // Error message
                      if (_error != null)
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Text(
                            _error!,
                            style: TextStyle(
                                color: Colors.red.shade700, fontSize: 13),
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      const SizedBox(height: 24),

                      // Login button
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B5E20),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: _loading ? null : _login,
                          child: _loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : const Text('دخول',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                        ),
                      ),

                      const SizedBox(height: 30),
                      Divider(color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      Text(
                        'Quran App Admin v2.0',
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade400),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboard,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      obscureText: obscure,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF1B5E20)),
        suffixIcon: suffix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: Color(0xFF1B5E20), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
    );
  }
}

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    for (double x = 0; x < size.width; x += 50) {
      for (double y = 0; y < size.height; y += 50) {
        canvas.drawCircle(Offset(x, y), 18, p);
        canvas.drawRect(
            Rect.fromCenter(center: Offset(x, y), width: 24, height: 24), p);
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
