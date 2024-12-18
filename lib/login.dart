import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart'; // Kakao SDK
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main_home.dart';

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
      Uri.parse(''), // 서버의 로그인 정보 저장 API
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
      bool isKakaoInstalled = await isKakaoTalkInstalled();

      // 카카오톡 앱 또는 카카오 계정 로그인 수행
      OAuthToken token = isKakaoInstalled
          ? await UserApi.instance.loginWithKakaoTalk() // 카카오톡 앱으로 로그인
          : await UserApi.instance.loginWithKakaoAccount(); // 카카오 계정으로 로그인

      print('Kakao 로그인 성공, 액세스 토큰: ${token.accessToken}');

      // 사용자 정보 요청
      User user = await UserApi.instance.me();
      String email = user.kakaoAccount?.email ?? '';  // 이메일 정보를 가져옴

      print('Kakao 사용자 정보: 이메일=$email, 닉네임=${user.kakaoAccount?.profile?.nickname}');

      // 로그인 성공 후, DB에 정보 저장 (이메일을 사용하여 저장)
      await _storeLoginInfoToDB(
        userId: email,  // 구글과 마찬가지로 이메일을 userId로 사용
        loginType: 'kakao',  // 로그인 타입은 카카오로 지정
        accessToken: token.accessToken,  // 카카오 액세스 토큰
        refreshToken: '',  // 카카오는 refreshToken을 사용할 수 없으므로 빈 문자열로 설정
      );

      // 로그인 성공 메시지
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kakao 로그인 성공!')),
      );

      // 홈 페이지로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainHomePage(userId: email),  // 이메일을 MainHomePage로 전달
        ),
      );
    } catch (e) {
      print('Kakao 로그인 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kakao 로그인 실패: ${e.toString()}')),
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
