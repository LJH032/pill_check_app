import 'package:flutter/material.dart';
import 'custom_app_bar.dart'; // CustomAppBar 컴포넌트 불러오기
import 'custom_bottom_bar.dart'; // CustomBottomBar 컴포넌트 불러오기
import 'entry_point.dart'; // ThemeState를 가져오기 위해 import

class BlankPage extends StatelessWidget {
  const BlankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Pill check', // 제목을 고정
        onBackPressed: () => Navigator.pop(context), // 뒤로가기
      ),
      body: ValueListenableBuilder(
        valueListenable: ThemeState.backgroundColor,
        builder: (context, backgroundColor, child) {
          return Container(
            color: backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                                '버전 및 업데이트 확인',
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
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      Image.asset(
                        'assets/images/1.png',
                        width: 300,
                        height: 350,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      ),
                      const SizedBox(height: 16),
                      _buildTextContainer(
                        '- Pill check의 현 버전은 1.0입니다.\n'
                            '사진불러오기 권한허용 업데이트.\n'
                            '카카오톡/구글 로그인을 업데이트 하였습니다.\n',
                      ),
                      const SizedBox(height: 16),
                      _buildTextContainer(
                        '- 12/26 version 업데이트 예정 (v1.3):\n'
                            '알약 커뮤니티 기능 생성\n'
                            '사용자 프로필 기능 생성',
                      ),
                    ],
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
      bottomNavigationBar: CustomBottomBar(
        onHomePressed: () {
          Navigator.popUntil(context, ModalRoute.withName('/')); // 홈으로 이동
        },
      ),
    );
  }

  Widget _buildTextContainer(String content) {
    return ValueListenableBuilder(
      valueListenable: ThemeState.textColor,
      builder: (context, textColor, child) {
        return ValueListenableBuilder(
          valueListenable: ThemeState.textSize,
          builder: (context, textSize, child) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: ThemeState.backgroundColor.value.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                content,
                style: TextStyle(
                  fontSize: textSize,
                  color: textColor,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
