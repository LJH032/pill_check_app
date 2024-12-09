import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main_home.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart';
class LoginHomePage extends StatefulWidget {
  const LoginHomePage({super.key});

  @override
  _LoginHomePageState createState() => _LoginHomePageState();
}
// 거의 다고침
// 푸쉬가안되네
class _LoginHomePageState extends State<LoginHomePage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // GoogleSignIn 인스턴스 생성

  // 공통된 로그인 정보 DB 저장 함수
  Future<void> _storeLoginInfoToDB({
    required String userId,
    required String loginType,
    required String accessToken,
    String? refreshToken,
  }) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/store-login-info'), // 서버의 로그인 정보 저장 API
      headers: {
        'Content-Type': 'application/json',  // 헤더에서 Content-Type을 'application/json'으로 설정
      },
      body: json.encode({
        'user_id': userId,
        'login_type': loginType,
        'access_token': accessToken,
        'refresh_token': refreshToken ?? '', // refreshToken이 null일 경우 빈 문자열로 처리
      }),
    );

    if (response.statusCode == 200) {
      print('로그인 정보 DB 저장 성공');
    } else {
      print('로그인 정보 DB 저장 실패');
    }
  }

  // Google 로그인
  Future<void> _loginWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        print('Google Sign-In 성공! 사용자 이메일: ${account.email}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google 로그인 성공: ${account.email}')),
        );

        final authentication = await account.authentication;
        final accessToken = authentication.accessToken!;

        // accessToken만 DB에 저장
        await _storeLoginInfoToDB(
          userId: account.email,
          loginType: 'google',
          accessToken: accessToken,
          refreshToken: '',  // refreshToken을 사용할 수 없으면 빈 문자열로 설정
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainHomePage(userId: account.email),
          ),
        );
      } else {
        print('Google Sign-In 취소됨');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google 로그인 취소됨')),
        );
      }
    } catch (error) {
      print('Google Sign-In 오류 발생: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google 로그인 오류 발생: $error')),
      );
    }
  }

  Future<void> _loginWithKakao() async {
    try {
      // 카카오톡 설치 여부 확인
      print('카카오톡 설치 여부 확인 시작');
      bool isKakaoInstalled = await isKakaoTalkInstalled();
      print('카카오톡 설치 여부: $isKakaoInstalled'); // 카카오톡 설치 여부 확인

      // 카카오톡 앱 또는 카카오 계정 로그인 수행
      print('카카오톡 앱 또는 카카오 계정 로그인 시도');
      OAuthToken token = isKakaoInstalled
          ? await UserApi.instance.loginWithKakaoTalk() // 카카오톡 앱으로 로그인
          : await UserApi.instance.loginWithKakaoAccount(); // 카카오 계정으로 로그인
      print('카카오톡 또는 카카오 계정 로그인 완료');

      if (token != null && token.accessToken != null) {
        print('카카오 로그인 성공, 액세스 토큰: ${token.accessToken}');

        // 사용자 정보 요청
        print('사용자 정보 요청 시작');
        User user = await UserApi.instance.me();
        print('사용자 정보 요청 완료');

        String userId = user.id.toString();
        String? email = user.kakaoAccount?.email; // 이메일 정보 가져오기

        print('사용자 정보: ID=$userId, 이메일=$email');

        // 홈 페이지로 이동
        print('홈 페이지로 이동');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainHomePage(userId: userId),
          ),
        );
      } else {
        print('카카오 로그인 실패: 토큰이 유효하지 않음');
      }
    } catch (e) {
      print('로그인 중 오류 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 실패: ${e.toString()}')),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.white),
          Positioned(
            bottom: 190,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/1.png',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              fit: BoxFit.contain,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Pill check',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cursive',
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  height: 320,
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      // Kakao 로그인 버튼
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _loginWithKakao,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: Image.asset(
                            'assets/images/kakao.png',
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                          ),
                          label: const Text(
                            '카카오 계정으로 로그인',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Google 로그인 버튼
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _loginWithGoogle,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: Image.asset(
                            'assets/images/google.png',
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                          ),
                          label: const Text(
                            'Google 계정으로 로그인',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
