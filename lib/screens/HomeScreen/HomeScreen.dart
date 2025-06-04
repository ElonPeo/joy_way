import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:joy_way/services/FirebaseServices/Authentication.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final Authentication auth = Authentication();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Trang Chủ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Chào mừng bạn đã đăng nhập!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            if (user != null)
              Text(
                'Email của bạn: ${user.email}',
                style: const TextStyle(fontSize: 18),
              ),
            // Bạn có thể hiển thị thêm thông tin người dùng ở đây
          ],
        ),
      ),
    );
  }
}