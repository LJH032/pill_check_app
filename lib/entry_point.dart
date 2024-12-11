import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart'; // Kakao SDK import
import 'custom_app_bar.dart'; // CustomAppBar 컴포넌트 불러오기
import 'custom_bottom_bar.dart'; // CustomBottomBar 컴포넌트 불러오기
import 'tema.dart'; // 테마 설정 페이지 import
import 'main_home.dart'; // MainHome import
import 'AccountSettingsPage.dart';
import 'login.dart';
import 'result_page.dart';

void main() {
  KakaoSdk.init(
    nativeAppKey: "fe4182a212808903410b9c65cac7cf6d", // 카카오 네이티브 앱 키
    loggingEnabled: true, // 디버그용 로깅 활성화
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pill Check',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginHomePage(), // 진입점을 LoginHomePage로 설정
    );
  }
}

// 전역 상태 관리
class ThemeState {
  static ValueNotifier<Color> backgroundColor = ValueNotifier<Color>(Colors.white);
  static ValueNotifier<Color> textColor = ValueNotifier<Color>(Colors.black);
  static ValueNotifier<double> textSize = ValueNotifier<double>(16.0); // 글씨 크기 초기값
  static ValueNotifier<int> fontIndex = ValueNotifier<int>(0); // 폰트 인덱스 상태
}

class SettingsPage extends StatelessWidget {
  final String userId;
  const SettingsPage({super.key, required this.userId});
//last
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
                                  fontFamily: fonts[fontIndex] == 'Default' ? null : fonts[fontIndex],
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
                              builder: (context) => AccountSettingsPage(userId: userId), // AccountSettingsPage로 이동
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Image.asset(
                            'assets/images/1.png', // 이미지 경로
                            width: 300, // 이미지 너비
                            height: 300, // 이미지 높이
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
                                  fontFamily: fonts[fontIndex] == 'Default' ? null : fonts[fontIndex],
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
            MaterialPageRoute(builder: (context) => MainHomePage(userId: userId)), // MainHomePage로 이동
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
                        fontFamily: fonts[fontIndex] == 'Default' ? null : fonts[fontIndex],
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
