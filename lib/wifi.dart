import 'package:flutter/material.dart';
import 'custom_app_bar.dart'; // CustomAppBar 컴포넌트 불러오기
import 'custom_bottom_bar.dart'; // CustomBottomBar import
import 'main_home.dart'; // MainHomePage import

class WifiDisconnectedPage extends StatelessWidget {
  final String userId; // userId 필드 추가

  const WifiDisconnectedPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Pill Check', // CustomAppBar에서 제목 설정
        onBackPressed: () {
          // 뒤로 가기 버튼 동작: MainHomePage로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainHomePage(userId: userId)), // userId 전달
          );
        },
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white, // 배경색
          ),
          // 와이파이 아이콘
          Positioned(
            top: 100, // 화면 상단에서 100px 위치
            left: 0,
            right: 0,
            child: Icon(
              Icons.wifi_off,
              size: 120,
              color: Colors.red.shade400, // 아이콘 색상
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 250), // 아이콘 아래 여유 공간
                const Text(
                  '와이파이 연결이 끊겼습니다!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '와이파이 연결을 확인한 후\n다시 시도해주세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    // 재시도 버튼 동작: 이전 페이지로 돌아가기
                    Navigator.pop(context); // 이전 페이지로 돌아가기
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade400,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 16.0,
                    ),
                  ),
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text(
                    '재시도',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
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
          // 홈 버튼 동작: MainHomePage로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainHomePage(userId: userId)), // userId 전달
          );
        },
      ),
    );
  }
}
