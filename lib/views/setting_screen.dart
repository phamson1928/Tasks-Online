import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepOrange,
        title: const Text(
          "Cài đặt",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserProfileSection(),
            const Divider(height: 1),
            _buildAccountSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileSection() {
    final user = FirebaseAuth.instance.currentUser;
    String? username = user?.displayName;
    if (username == null || username.isEmpty) {
      username = "U";
    }

    String? avatarUrl = user?.photoURL;
    if (avatarUrl == null || avatarUrl.isEmpty) {
      avatarUrl = "https://via.placeholder.com/150";
    }
    String? email = user?.email;
    if (email == null || email.isEmpty) {
      email = "U";
    }
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(username,
                style:  TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              "Tài khoản",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          _buildSettingsItem(
            icon: Icons.info,
            title: "Về ứng dụng",
            subtitle: "Phiên bản 1.0.0",
            onTap: () {
              // Show app info
              _showAboutAppDialog();
            },
          ),
          _buildLogoutButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.deepOrange,
        size: 24,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: ElevatedButton(
        onPressed: () {
          _showLogoutConfirmationDialog();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade50,
          foregroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.logout),
            SizedBox(width: 10),
            Text(
              "Đăng xuất",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAboutAppDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Về ứng dụng"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.deepOrange.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.task_alt,
                size: 60,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "SmartTasks",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Phiên bản 1.0.0",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "© 2025 SmartTasks. Bản quyền thuộc về SmartTasks.",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Đóng",
              style: TextStyle(color: Colors.deepOrange),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận đăng xuất"),
        content: const Text("Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng không?"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Hủy",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              AuthService().signOut(context);
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red.shade50,
            ),
            child: const Text(
              "Đăng xuất",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}