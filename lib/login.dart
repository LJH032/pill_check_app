import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main_home.dart';

class LoginHomePage extends StatefulWidget {
  const LoginHomePage({super.key});

  @override
  _LoginHomePageState createState() => _LoginHomePageState();
}

class _LoginHomePageState extends State<LoginHomePage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // GoogleSignIn 인스턴스 생성

  Future<void> _loginWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        print('Google Sign-In 성공! 사용자 이메일: ${account.email}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google 로그인 성공: ${account.email}')),
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
    final url =
        'https://kauth.kakao.com/oauth/authorize?client_id=baf21c9586cd52ac6c4211378fee4a17&redirect_uri=kakao%3Abaf21c9586cd52ac6c4211378fee4a17%3A%2F%2Foauth&response_type=code';


    try {
      print('Kakao OAuth 요청 URL: $url');
      final result = await FlutterWebAuth.authenticate(
        url: url,
        callbackUrlScheme: 'kakaobaf21c9586cd52ac6c4211378fee4a17', // Kakao 스킴 설정
      );
      print('Kakao 인증 성공, 결과 URL: $result');

      final code = Uri.parse(result).queryParameters['code'];
      print('Kakao Authorization Code: $code');

      final response = await http.post(
        Uri.parse('https://kauth.kakao.com/oauth/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'authorization_code',
          'client_id': 'baf21c9586cd52ac6c4211378fee4a17',
          'client_secret': 'c27aba5f2eb37186820b4b6fc9f864a5',
          'redirect_uri': 'kakao%3Abaf21c9586cd52ac6c4211378fee4a17%3A%2F%2Foauth',
          'code': code!,
        },
      );

      if (response.statusCode == 200) {
        print('Kakao OAuth 토큰 요청 성공: ${response.body}');
        final responseBody = json.decode(response.body);
        final accessToken = responseBody['access_token'];
        print('Kakao Access Token: $accessToken');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kakao 로그인 성공!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MainHomePage(userId: 'example_user_id')), // MainHomePage로 이동
        );
      } else {
        print('Kakao OAuth 토큰 요청 실패: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kakao 로그인 실패!')),
        );
      }
    } catch (e) {
      print('Kakao 인증 에러: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kakao 에러 발생: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
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