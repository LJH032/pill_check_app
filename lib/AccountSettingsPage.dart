import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_home.dart'; // MainHomePage import
import 'entry_point.dart'; // ThemeState를 가져오기 위해 import
import 'login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AccountSettingsPage extends StatefulWidget {
  final String userId; // userId 필드 추가

  const AccountSettingsPage({super.key, required this.userId}); // 생성자에서 userId를 받아옴

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  bool isAutoLoginEnabled = false; // 계정 자동 로그인 설정 여부
  bool isNotificationEnabled = false; // 알림 설정 여부

  GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    _loadSettings(); // 설정 값을 불러옴
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isAutoLoginEnabled = prefs.getBool('isAutoLoginEnabled') ?? false;
      isNotificationEnabled = prefs.getBool('isNotificationEnabled') ?? false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAutoLoginEnabled', isAutoLoginEnabled);
    await prefs.setBool('isNotificationEnabled', isNotificationEnabled);
  }

  Future<String?> fetchLoginType(String userId) async {
    final response = await http.post(
      Uri.parse(''),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['login_type']; // 'google' 또는 'kakao'
    } else {
      print('Failed to fetch login type: ${response.statusCode}');
      return null;
    }
  }

  Future<void> logout(String userId) async {
    try {
      // 서버로 로그아웃 요청 보내기
      final response = await http.post(
        Uri.parse(''),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['message'] == 'Google logout request') {
          // 구글 로그아웃 처리
          await googleLogout();
        } else if (responseData['message'] == 'Kakao logout request') {
          // 카카오 로그아웃 처리
          await kakaoLogout();
        }
      } else {
        print('로그아웃 처리 실패: ${response.body}');
      }
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  Future<void> googleLogout() async {
    try {
      await _googleSignIn.signOut();
      print('Google 로그아웃 성공');
    } catch (e) {
      print('구글 로그아웃 실패: $e');
    }
  }

  Future<void> kakaoLogout() async {
    try {
      await UserApi.instance.logout();
      print('카카오 로그아웃 성공');
    } catch (e) {
      print('카카오 로그아웃 실패: $e');
    }
  }

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
                      'Pill Check',
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
                  child: Text(
                    '계정 설정 (User ID: ${widget.userId})', // userId 표시
                    style: TextStyle(
                      fontFamily: ['Default', 'Serif', 'Monospace'][ThemeState.fontIndex.value],
                      fontSize: ThemeState.textSize.value,
                      fontWeight: FontWeight.bold,
                      color: ThemeState.textColor.value,
                    ),
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
                          value: isAutoLoginEnabled,
                          onChanged: (value) {
                            setState(() {
                              isAutoLoginEnabled = value;
                            });
                            _saveSettings(); // 설정을 저장
                          },
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
                          value: isNotificationEnabled,
                          onChanged: (value) {
                            setState(() {
                              isNotificationEnabled = value;
                            });
                            _saveSettings(); // 설정을 저장
                          },
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            // 로그아웃 처리
                            await logout(widget.userId); // userId는 사용자 ID를 전달

                            // LoginHomePage로 이동
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginHomePage()),
                            );
                          } catch (e) {
                            print('로그아웃 처리 중 오류 발생: $e');
                          }
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
                  child: Text(
                    'version 1.0',
                    style: TextStyle(
                      fontSize: ThemeState.textSize.value * 0.8,
                      fontStyle: FontStyle.italic,
                      color: ThemeState.textColor.value,
                    ),
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MainHomePage(userId: widget.userId),
                ),
                    (route) => false, // 이전 모든 페이지 제거
              );
            },
          ),
        ),
      ),
    );
  }
}
