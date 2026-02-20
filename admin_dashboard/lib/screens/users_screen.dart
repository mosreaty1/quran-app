import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../services/admin_firebase_service.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: StreamBuilder<QuerySnapshot>(
        stream: AdminFirebaseService().usersStream(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 8),
                  Text('خطأ: ${snap.error}',
                      textDirection: ui.TextDirection.rtl),
                ],
              ),
            );
          }
          final docs = snap.data?.docs ?? [];
          return Column(
            children: [
              // Header stats bar
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                child: Row(
                  children: [
                    Text('${docs.length} مستخدم',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B5E20))),
                    const Spacer(),
                    const Icon(Icons.people, color: Color(0xFF1B5E20), size: 18),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Table
              Expanded(
                child: docs.isEmpty
                    ? const _EmptyState(
                        message: 'لا يوجد مستخدمون بعد',
                        icon: Icons.people_outline)
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: docs.length,
                        itemBuilder: (context, i) {
                          final data =
                              docs[i].data() as Map<String, dynamic>;
                          final uid = docs[i].id;
                          final email = data['email'] ?? '';
                          final name = data['displayName'] ?? 'مجهول';
                          final isAnon = data['isAnonymous'] ?? false;
                          final lastActive =
                              (data['lastActive'] as Timestamp?)
                                  ?.toDate();

                          return Container(
                            margin:
                                const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              children: [
                                // Avatar
                                CircleAvatar(
                                  backgroundColor: isAnon
                                      ? Colors.grey.shade300
                                      : const Color(0xFF1B5E20)
                                          .withOpacity(0.1),
                                  child: Text(
                                    isAnon
                                        ? '?'
                                        : (name.isEmpty
                                            ? '?'
                                            : name[0].toUpperCase()),
                                    style: TextStyle(
                                      color: isAnon
                                          ? Colors.grey
                                          : const Color(0xFF1B5E20),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            isAnon ? 'مستخدم مجهول' : name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14),
                                          ),
                                          const SizedBox(width: 8),
                                          if (isAnon)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 1),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text('مجهول',
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey),
                                                  textDirection:
                                                      ui.TextDirection.rtl),
                                            ),
                                        ],
                                      ),
                                      if (email.isNotEmpty)
                                        Text(email,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey)),
                                      if (lastActive != null)
                                        Text(
                                          'آخر نشاط: ${DateFormat.yMMMd('ar').format(lastActive)}',
                                          style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey),
                                          textDirection: ui.TextDirection.rtl,
                                        ),
                                    ],
                                  ),
                                ),
                                // UID chip
                                Tooltip(
                                  message: uid,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius:
                                          BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      uid.substring(0, 8),
                                      style: const TextStyle(
                                          fontSize: 10,
                                          fontFamily: 'monospace',
                                          color: Colors.grey),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Delete
                                IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      color: Colors.red, size: 18),
                                  tooltip: 'حذف المستخدم',
                                  onPressed: () =>
                                      _confirmDelete(context, uid, email),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, String uid, String email) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تأكيد الحذف',
            textDirection: ui.TextDirection.rtl),
        content: Text('هل تريد حذف المستخدم: $email ؟',
            textDirection: ui.TextDirection.rtl),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء')),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              AdminFirebaseService().deleteUser(uid);
              Navigator.pop(context);
            },
            child: const Text('حذف',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  const _EmptyState({required this.message, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(message,
              style: GoogleFonts.amiri(
                  fontSize: 18, color: Colors.grey.shade400),
              textDirection: ui.TextDirection.rtl),
        ],
      ),
    );
  }
}
