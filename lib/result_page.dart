import 'package:flutter/material.dart';
import 'custom_app_bar.dart'; // CustomAppBar 컴포넌트 import
import 'custom_bottom_bar.dart'; // CustomBottomBar 컴포넌트 import
import 'main_home.dart'; // MainHomePage import 추가
import 'PillDetailPage.dart'; // PillDetailPage import
import 'dart:typed_data'; // Uint8List import
import 'dart:io'; // File class import 추가

class ResultPage extends StatelessWidget {
  final File imageFile;
  final String drugName;
  final String formulation;
  final String color;
  final String efficacy;
  final Map<String, dynamic> fullData; // 상세 정보를 모두 전달
  final String userId; // userId 필드 추가

  const ResultPage({
    super.key,
    required this.imageFile,
    required this.drugName,
    required this.formulation,
    required this.color,
    required this.efficacy,
    required this.fullData,
    required this.userId, // userId 추가
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '인식결과', // CustomAppBar에서 제목 설정
        onBackPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainHomePage(userId: userId)), // MainHomePage로 이동 시 userId 전달
                (route) => false,
          );
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white, // 흰색 배경 설정
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.file(
                imageFile,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 24),
              _buildInfoBlock('이름', drugName),
              _buildInfoBlock('제형', formulation),
              _buildInfoBlock('색상', color),
              _buildInfoBlock('효능', efficacy),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PillDetailPage(
                          fullData: fullData,
                          userId: userId, // PillDetailPage로 이동 시 userId 전달
                        ),
                      ),
                    );
                  },
                  child: const Text('상세 정보 보기'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        onHomePressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainHomePage(userId: userId)), // MainHomePage로 이동 시 userId 전달
                (route) => false,
          );
        },
      ),
    );
  }

  // 블록 빌드 함수
  Widget _buildInfoBlock(String title, String content) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$title: $content',
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}
