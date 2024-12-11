import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // File class import
import 'main_home.dart'; // MainHomePage import 추가
import 'result_page.dart'; // ResultPage import 추가
import 'custom_app_bar.dart'; // CustomAppBar import 추가
import 'custom_bottom_bar.dart'; // CustomBottomBar import 추가
import 'entry_point.dart'; // ThemeState import

class LoadingPage extends StatefulWidget {
  final File imageFile;
  final String userId; // userId 필드 추가

  const LoadingPage({super.key, required this.imageFile, required this.userId});

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    _uploadAndAnalyzeImage();
  }

  Future<void> _uploadAndAnalyzeImage() async {
    try {
      // Flask 서버에 이미지 업로드 및 분석 요청
      var request = http.MultipartRequest('POST', Uri.parse('http://10.0.2.2:5000/predict'));
      request.files.add(await http.MultipartFile.fromPath('image', widget.imageFile.path));
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var data = json.decode(responseData.body);

        // 신뢰도와 결과를 함께 전달받음
        double confidence = data['confidence'] ?? 0.0; // 신뢰도 (퍼센트로 변환된 값)

        // 서버에서 받은 데이터를 ResultPage로 전달
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              imageFile: widget.imageFile,
              drugName: data['drug_name'] ?? 'Unknown',
              formulation: data['formulation'] ?? 'Unknown',
              color: data['color'] ?? 'Unknown',
              efficacy: data['efficacy'] ?? 'Unknown',
              fullData: data, // 상세 정보를 모두 전달
              confidence: confidence, // 신뢰도 전달
              userId: widget.userId, // userId 전달
            ),
          ),
        );
      } else {
        _showError('Error: No data found');
      }
    } catch (e) {
      _showError('Error: ${e.toString()}');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainHomePage(userId: widget.userId)), // MainHomePage로 이동, userId 전달
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ThemeState.backgroundColor,
      builder: (context, backgroundColor, child) {
        return ValueListenableBuilder(
          valueListenable: ThemeState.textColor,
          builder: (context, textColor, child) {
            return ValueListenableBuilder(
              valueListenable: ThemeState.textSize,
              builder: (context, textSize, child) {
                return ValueListenableBuilder(
                  valueListenable: ThemeState.fontIndex,
                  builder: (context, fontIndex, child) {
                    final fonts = ['Default', 'Serif', 'Monospace'];
                    return WillPopScope(
                      onWillPop: () async {
                        // 뒤로가기 눌렀을 때 MainHomePage로 이동
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainHomePage(userId: widget.userId)),
                        );
                        return false; // 기본 뒤로가기 동작 방지
                      },
                      child: Scaffold(
                        appBar: CustomAppBar(
                          title: 'Pill Check',
                          onBackPressed: () {
                            // 뒤로가기 버튼 눌렀을 때 MainHomePage로 이동
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => MainHomePage(userId: widget.userId)),
                            );
                          },
                        ),
                        backgroundColor: backgroundColor,
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(), // 로딩 애니메이션 표시
                              const SizedBox(height: 20),
                              Text(
                                '조금만 기다려주세요\n로딩 중입니다...',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: textSize,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                  fontFamily: fonts[fontIndex] == 'Default'
                                      ? null
                                      : fonts[fontIndex],
                                ),
                              ),
                            ],
                          ),
                        ),
                        bottomNavigationBar: CustomBottomBar(
                          onHomePressed: () {
                            // 홈 버튼 눌렀을 때 MainHomePage로 이동
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => MainHomePage(userId: widget.userId)),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
