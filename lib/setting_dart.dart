import 'package:flutter/material.dart';
import 'custom_app_bar.dart';
import 'custom_bottom_bar.dart';
import 'AccountSettingsPage.dart';
import 'tema.dart';
import 'main_home.dart';
import 'entry_point.dart';
import 'user.dart';

class SettingPage1 extends StatelessWidget {
  final String userId;

  const SettingPage1({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Pill Check',
        onBackPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainHomePage(userId: userId)), // MainHomePage로 이동
          );
        },
      ),
      body: ValueListenableBuilder(
        valueListenable: ThemeState.backgroundColor,
        builder: (context, backgroundColor, child) {
          return Container(
            color: backgroundColor,
            child: Column(
              children: [
                Container(
                  color: const Color(0xFFBDBDBD),
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.centerLeft,
                  child: ValueListenableBuilder(
                    valueListenable: ThemeState.textColor,
                    builder: (context, textColor, child) {
                      return ValueListenableBuilder(
                        valueListenable: ThemeState.textSize,
                        builder: (context, textSize, child) {
                          return ValueListenableBuilder(
                            valueListenable: ThemeState.fontIndex,
                            builder: (context, fontIndex, child) {
                              final fonts = ['Default', 'Serif', 'Monospace'];
                              return Text(
                                '설정',
                                style: TextStyle(
                                  fontFamily: fonts[fontIndex] == 'Default'
                                      ? null
                                      : fonts[fontIndex],
                                  fontSize: textSize,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
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
                      _buildSettingsTile(
                        icon: Icons.update,
                        title: '업데이트 확인',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BlankPage(), // BlankPage로 이동
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
                ValueListenableBuilder(
                  valueListenable: ThemeState.textColor,
                  builder: (context, textColor, child) {
                    return ValueListenableBuilder(
                      valueListenable: ThemeState.textSize,
                      builder: (context, textSize, child) {
                        return ValueListenableBuilder(
                          valueListenable: ThemeState.fontIndex,
                          builder: (context, fontIndex, child) {
                            final fonts = ['Default', 'Serif', 'Monospace'];
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'version 1.0',
                                style: TextStyle(
                                  fontFamily: fonts[fontIndex] == 'Default'
                                      ? null
                                      : fonts[fontIndex],
                                  color: textColor,
                                  fontSize: textSize * 0.8,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
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
    return ValueListenableBuilder(
      valueListenable: ThemeState.backgroundColor,
      builder: (context, backgroundColor, child) {
        final buttonBackgroundColor = backgroundColor == Colors.black
            ? Colors.grey.shade800
            : Colors.white; // 버튼 배경색
        final buttonTextColor = backgroundColor == Colors.black
            ? Colors.white
            : Colors.black; // 버튼 텍스트 색상

        return ValueListenableBuilder(
          valueListenable: ThemeState.textSize,
          builder: (context, textSize, child) {
            return ValueListenableBuilder(
              valueListenable: ThemeState.fontIndex,
              builder: (context, fontIndex, child) {
                final fonts = ['Default', 'Serif', 'Monospace'];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: buttonBackgroundColor,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: const Color(0xFFBBBBBB)),
                  ),
                  child: ListTile(
                    leading: Icon(icon, size: 30, color: buttonTextColor),
                    title: Text(
                      title,
                      style: TextStyle(
                        fontFamily: fonts[fontIndex] == 'Default'
                            ? null
                            : fonts[fontIndex],
                        fontSize: textSize,
                        fontWeight: FontWeight.bold,
                        color: buttonTextColor,
                      ),
                    ),
                    onTap: onTap,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
