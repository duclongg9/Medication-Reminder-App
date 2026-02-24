import 'package:flutter/material.dart';
import 'package:mvvm_project/views/login_page.dart';

class HomePage extends StatelessWidget {
  final String userName;
  final String title;

  const HomePage({super.key, required this.userName, required this.title});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.blue.shade50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 36, bottom: 45),
              child: HeaderSection(
                title: 'Xin chào bạn đến với hệ thống quản lý cá nhân',
              ),
            ),
            MenuSection(),
          ],
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  final String title;

  const HeaderSection({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        color: Color(0xFF1D4E9E),
        fontWeight: FontWeight.w700,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class MenuSection extends StatelessWidget {
  const MenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          MenuItem(
            icon: Icons.person_2,
            label: 'Quản lý người dùng',
            iconColor: Colors.blue,
            iconBackgroundColor: Colors.white,
          ),
          MenuItem(
            icon: Icons.event_note,
            label: 'Quản lý nhắc việc',
            iconColor: Colors.orange,
            iconBackgroundColor: Colors.white,
          ),
          MenuItem(
            icon: Icons.shopping_cart,
            label: 'Đặt hàng',
            iconColor: Colors.lightBlue,
            iconBackgroundColor: Colors.white,
          ),
          MenuItem(
            icon: Icons.map,
            label: 'Xem Bản Đồ',
            iconColor: Colors.red,
            iconBackgroundColor: Colors.white,
          ),
          MenuItem(
            icon: Icons.flutter_dash_outlined,
            label: 'Tổng quan Flutter',
            iconColor: Colors.blueAccent,
            iconBackgroundColor: Colors.white,
          ),
          MenuItem(
            icon: Icons.power_settings_new,
            label: 'Đăng xuất',
            iconColor: Colors.white,
            iconBackgroundColor: Colors.red,
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false, // xoá toàn bộ stack
              );
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color iconBackgroundColor;
  final VoidCallback? onTap;

  const MenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.iconBackgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          onTap: onTap,
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBackgroundColor, // Màu nền icon
              borderRadius: BorderRadius.circular(30), // bo tròn
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          title: Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1D4E9E),
            ),
          ),
        ),
      ),
    );
  }
}

