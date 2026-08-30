import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pic_collector/models/friend.dart';
import 'package:pic_collector/models/group.dart';
import 'package:pic_collector/screens/auth/login_screen.dart';
import 'package:pic_collector/utils/user_notice.dart';

/// Profile tab: the current user's profile with a logout button.
class ProfileScreen extends StatelessWidget {
  final Friend? friend;
  final List<Group>? allGroups;

  const ProfileScreen({super.key, this.friend, this.allGroups});

  /// Shows a confirmation dialog, then signs the user out and
  /// returns to the [LoginScreen] (clearing the navigation stack).
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;
              showSnackBar(context, 'You have been logged out');
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayEmail = friend?.email ?? user?.email ?? 'No email';
    final displayInitial = friend != null
        ? (friend!.name.isNotEmpty ? friend!.name[0].toUpperCase() : '?')
        : (user?.email != null && user!.email!.isNotEmpty
              ? user.email![0].toUpperCase()
              : '?');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- User avatar ---
              CircleAvatar(
                radius: 48,
                backgroundColor: friend?.color ?? Colors.blue,
                child: Text(
                  displayInitial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // --- User email ---
              Text(
                friend != null ? friend!.displayName : displayEmail,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
                displayEmail,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 48),
              // --- Logout button ---
              if (friend == null)
                SizedBox(
                  width: 200,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () => _showLogoutDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
