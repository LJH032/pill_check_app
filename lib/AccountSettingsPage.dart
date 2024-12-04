import 'package:flutter/material.dart';
import 'option.dart'; // ThemeState를 가져오기 위해 import

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
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
                      'Pill check',
                      style: TextStyle(
                        fontFamily: fonts[fontIndex] == 'Default' ? null : fonts[fontIndex],
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontSize: textSize,
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
        backgroundColor: const Color(0xFFE9E9E9),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // 이전 페이지로 돌아가기
          },
        ),
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
                                '계정 설정',
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
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          '계정 자동 로그인',
                          style: TextStyle(
                            fontSize: ThemeState.textSize.value,
                            color: ThemeState.textColor.value,
                          ),
                        ),
                        trailing: Switch(
                          value: false, // UI만 구성
                          onChanged: (value) {},
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Pill Check 알림 설정',
                          style: TextStyle(
                            fontSize: ThemeState.textSize.value,
                            color: ThemeState.textColor.value,
                          ),
                        ),
                        trailing: Switch(
                          value: false, // UI만 구성
                          onChanged: (value) {},
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          // 로그아웃 버튼 (UI만 존재)
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE9E9E9),
                          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 12.0),
                        ),
                        child: Text(
                          '로그아웃',
                          style: TextStyle(
                            fontSize: ThemeState.textSize.value,
                            color: ThemeState.textColor.value,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                // 이미지 추가
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Image.asset(
                      'assets/images/1.png', // 업로드한 이미지 경로
                      width: 300, // 이미지 너비
                      height: 300, // 이미지 높이
                      fit: BoxFit.contain, // 이미지 비율 유지
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ValueListenableBuilder(
                    valueListenable: ThemeState.textColor,
                    builder: (context, textColor, child) {
                      return ValueListenableBuilder(
                        valueListenable: ThemeState.textSize,
                        builder: (context, textSize, child) {
                          return Text(
                            'version 1.0',
                            style: TextStyle(
                              fontSize: textSize * 0.8,
                              fontStyle: FontStyle.italic,
                              color: textColor,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFE9E9E9),
        child: Container(
          height: 78,
          alignment: Alignment.center,
          child: IconButton(
            icon: const Icon(Icons.home, size: 30, color: Colors.black),
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/')); // 홈으로 이동
            },
          ),
        ),
      ),
    );
  }
}