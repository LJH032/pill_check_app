import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // File class import
import 'main_home.dart'; // MainHomePage import 추가
import 'result_page.dart'; // ResultPage import 추가

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
      var request = http.MultipartRequest('POST', Uri.parse('http://127.0.0.1:5000/predict'));
      request.files.add(await http.MultipartFile.fromPath('image', widget.imageFile.path));
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var data = json.decode(responseData.body);

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pill Check'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(), // 로딩 애니메이션 표시
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _uploadAndAnalyzeImage(), // 업로드 및 분석 재시도
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // 버튼 색상
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: const Text('Retry Upload'), // 버튼 텍스트
            ),
          ],
        ),
      ),
    );
  }
}
