import 'package:flutter/material.dart';
import 'custom_app_bar.dart'; // CustomAppBar 컴포넌트 불러오기
import 'custom_bottom_bar.dart'; // CustomBottomBar 컴포넌트 불러오기
import 'entry_point.dart'; // ThemeState를 가져오기 위해 import

class ThemeSettingsPage extends StatefulWidget {
  const ThemeSettingsPage({super.key});

  @override
  _ThemeSettingsPageState createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  double _temporaryTextSize = ThemeState.textSize.value; // 임시 글씨 크기
  Color _temporaryBackgroundColor = ThemeState.backgroundColor.value; // 배경색
  Color _temporaryTextColor = ThemeState.textColor.value; // 글자 색상
  final List<String> _fonts = ['Default', 'Serif', 'Monospace']; // 사용할 폰트 리스트
  int _temporaryFontIndex = ThemeState.fontIndex.value; // 임시 폰트 인덱스

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // CustomAppBar로 교체
      appBar: CustomAppBar(
        title: 'Pill Check',
        onBackPressed: () {
          Navigator.pop(context); // 이전 페이지로 돌아가기
        },
      ),
      body: Stack(
        children: [
          // 배경색 적용
          Positioned.fill(
            child: Container(
              color: _temporaryBackgroundColor, // 임시 배경색
            ),
          ),
          // UI 요소
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader('화면 테마 설정'),
              _buildSectionTitle('배경색상'),
              _buildColorOptions(),
              _buildSectionTitle('글씨 크기 및 폰트 설정'),
              _buildFontSettings(),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // 설정 적용: 배경색, 텍스트 색상, 글씨 크기, 폰트 반영
                    ThemeState.backgroundColor.value = _temporaryBackgroundColor;
                    ThemeState.textColor.value = _temporaryTextColor;
                    ThemeState.textSize.value = _temporaryTextSize;
                    ThemeState.fontIndex.value = _temporaryFontIndex; // 폰트 상태 업데이트

                    Navigator.pop(context); // 설정 적용 후 뒤로가기
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDDD6D6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50.0, vertical: 12.0),
                  ),
                  child: Text(
                    '적용',
                    style: TextStyle(
                      fontSize: _temporaryTextSize,
                      color: _temporaryTextColor,
                      fontFamily: _fonts[_temporaryFontIndex] == 'Default'
                          ? null
                          : _fonts[_temporaryFontIndex],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
          // 이미지를 UI 요소 위로 이동
          Positioned(
            left: 0,
            right: 0,
            top: 300,
            child: IgnorePointer(
              child: Image.asset(
                'assets/images/1.png',
                width: 300,
                height: 350,
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ),
          ),
        ],
      ),
      // CustomBottomBar로 교체
      bottomNavigationBar: CustomBottomBar(
        onHomePressed: () {
          Navigator.popUntil(context, ModalRoute.withName('/')); // 홈으로 이동
        },
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Container(
      color: const Color(0xFFBDBDBD),
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: _temporaryTextSize,
          fontWeight: FontWeight.bold,
          color: _temporaryTextColor,
          fontFamily: _fonts[_temporaryFontIndex] == 'Default'
              ? null
              : _fonts[_temporaryFontIndex],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: _temporaryTextSize,
          fontWeight: FontWeight.bold,
          color: _temporaryTextColor,
          fontFamily: _fonts[_temporaryFontIndex] == 'Default'
              ? null
              : _fonts[_temporaryFontIndex],
        ),
      ),
    );
  }

  Widget _buildColorOptions() {
    final colors = [
      {'color': Colors.red, 'label': '기본'},
      {'color': Colors.black, 'label': '블랙'},
      {'color': Colors.white, 'label': '화이트'},
      {'color': Colors.purple, 'label': '퍼플'},
      {'color': Colors.yellow, 'label': '옐로우'},
      {'color': Colors.greenAccent, 'label': '연두'},
      {'color': Colors.blue, 'label': '하늘'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Wrap(
        spacing: 16.0,
        runSpacing: 16.0,
        children: colors.map((colorInfo) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _temporaryBackgroundColor = colorInfo['color'] as Color;
                _temporaryTextColor = _temporaryBackgroundColor == Colors.black
                    ? Colors.white
                    : Colors.black;
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: colorInfo['color'] as Color,
                ),
                const SizedBox(height: 8),
                Text(
                  colorInfo['label'] as String,
                  style: TextStyle(
                    fontSize: _temporaryTextSize * 0.6,
                    color: _temporaryTextColor,
                    fontFamily: _fonts[_temporaryFontIndex] == 'Default'
                        ? null
                        : _fonts[_temporaryFontIndex],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFontSettings() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                '글씨 크기',
                style: TextStyle(
                    fontSize: _temporaryTextSize, color: _temporaryTextColor),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (_temporaryTextSize < 24.0) _temporaryTextSize += 2.0;
                  });
                },
                icon: const Icon(Icons.arrow_drop_up),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (_temporaryTextSize > 12.0) _temporaryTextSize -= 2.0;
                  });
                },
                icon: const Icon(Icons.arrow_drop_down),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                '폰트',
                style: TextStyle(
                    fontSize: _temporaryTextSize, color: _temporaryTextColor),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (_temporaryFontIndex < _fonts.length - 1) {
                      _temporaryFontIndex++;
                    }
                  });
                },
                icon: const Icon(Icons.arrow_drop_up),
              ),
              Text(
                _fonts[_temporaryFontIndex],
                style: TextStyle(
                  fontSize: _temporaryTextSize,
                  color: _temporaryTextColor,
                  fontFamily: _fonts[_temporaryFontIndex] == 'Default'
                      ? null
                      : _fonts[_temporaryFontIndex],
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (_temporaryFontIndex > 0) {
                      _temporaryFontIndex--;
                    }
                  });
                },
                icon: const Icon(Icons.arrow_drop_down),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
