import 'package:flutter/material.dart';
import 'custom_app_bar.dart';
import 'custom_bottom_bar.dart';
import 'main_home.dart';
import 'AccountSettingsPage.dart';
import 'tema.dart';


class SettingsPage extends StatelessWidget {
  final String userId;
  const SettingsPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Pill Check',
        onBackPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainHomePage(userId: userId)),
          );
        },
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFFBDBDBD),
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.centerLeft,
            child: const Text(
              '설정',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildSettingsTile(
                  icon: Icons.color_lens,
                  title: '화면 테마 설정',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ThemeSettingsPage(),
                      ),
                    );
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.person,
                  title: '계정 설정',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountSettingsPage(userId: userId),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Image.asset(
                      'assets/images/1.png',
                      width: 300,
                      height: 300,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        onHomePressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainHomePage(userId: userId)),
          );
        },
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 30),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    );
  }
}
