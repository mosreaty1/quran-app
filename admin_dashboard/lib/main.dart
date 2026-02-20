import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_shell.dart';
import 'services/admin_firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint('Firebase init: $e');
  }
  runApp(const QuranAdminApp());
}

class QuranAdminApp extends StatelessWidget {
  const QuranAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'لوحة إدارة القرآن',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF1B5E20),
          onPrimary: Colors.white,
          secondary: Color(0xFFC4922A),
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          surface: Color(0xFFF5F5F5),
          onSurface: Color(0xFF1A1A1A),
        ),
        textTheme: GoogleFonts.notoSansTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1B5E20),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: StreamBuilder(
        stream: AdminFirebaseService().authStream,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const _Loading();
          }
          if (snap.data != null) {
            return const DashboardShell();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
