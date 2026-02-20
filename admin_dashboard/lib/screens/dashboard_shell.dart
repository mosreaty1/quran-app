import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/admin_firebase_service.dart';
import 'home_dashboard_screen.dart';
import 'users_screen.dart';
import 'translations_screen.dart';
import 'settings_screen.dart';

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int _selectedIndex = 0;

  final _navItems = const [
    _NavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'الرئيسية'),
    _NavItem(icon: Icons.people_outline, activeIcon: Icons.people, label: 'المستخدمون'),
    _NavItem(icon: Icons.translate_outlined, activeIcon: Icons.translate, label: 'الترجمات'),
    _NavItem(icon: Icons.settings_outlined, activeIcon: Icons.settings, label: 'الإعدادات'),
  ];

  final _screens = const [
    HomeDashboardScreen(),
    UsersScreen(),
    TranslationsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final svc = AdminFirebaseService();
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 800;

    return Scaffold(
      body: Row(
        children: [
          // ── Sidebar ───────────────────────────────────────────────────────
          if (isWide)
            Container(
              width: 220,
              color: const Color(0xFF0D3B14),
              child: Column(
                children: [
                  // Brand header
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 16),
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFFC4922A), width: 2),
                            color: Colors.white10,
                          ),
                          child: const Center(
                            child: Text('ق',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'لوحة التحكم',
                          style: GoogleFonts.amiri(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          svc.currentUser?.email ?? '',
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white38),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white12, height: 1),
                  // Nav items
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      children: List.generate(_navItems.length, (i) {
                        final item = _navItems[i];
                        final selected = _selectedIndex == i;
                        return ListTile(
                          leading: Icon(
                            selected ? item.activeIcon : item.icon,
                            color: selected
                                ? const Color(0xFFC4922A)
                                : Colors.white54,
                            size: 20,
                          ),
                          title: Text(
                            item.label,
                            style: TextStyle(
                              color: selected
                                  ? const Color(0xFFC4922A)
                                  : Colors.white70,
                              fontSize: 14,
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          selected: selected,
                          selectedTileColor: Colors.white.withOpacity(0.08),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          onTap: () =>
                              setState(() => _selectedIndex = i),
                        );
                      }),
                    ),
                  ),
                  // Sign out
                  const Divider(color: Colors.white12, height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout,
                        color: Colors.red, size: 20),
                    title: const Text('خروج',
                        style: TextStyle(color: Colors.red, fontSize: 14),
                        textDirection: TextDirection.rtl),
                    onTap: () => svc.signOut(),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          // ── Main content ─────────────────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                // Top app bar
                AppBar(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1A1A1A),
                  elevation: 0,
                  title: Text(
                    _navItems[_selectedIndex].label,
                    style: GoogleFonts.amiri(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1B5E20)),
                    textDirection: TextDirection.rtl,
                  ),
                  centerTitle: false,
                  leading: isWide ? const SizedBox.shrink() : null,
                  actions: [
                    // User email
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Center(
                        child: Text(
                          svc.currentUser?.email ?? 'Admin',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.grey),
                        ),
                      ),
                    ),
                    if (!isWide)
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.red),
                        onPressed: () => svc.signOut(),
                      ),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(1),
                    child: Container(
                        height: 1, color: Colors.grey.shade200),
                  ),
                ),
                Expanded(child: _screens[_selectedIndex]),
              ],
            ),
          ),
        ],
      ),
      // Mobile bottom nav
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (i) =>
                  setState(() => _selectedIndex = i),
              destinations: _navItems
                  .map((item) => NavigationDestination(
                        icon: Icon(item.icon),
                        selectedIcon: Icon(item.activeIcon),
                        label: item.label,
                      ))
                  .toList(),
            ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem(
      {required this.icon,
      required this.activeIcon,
      required this.label});
}
