import 'package:flutter/material.dart';
import 'custom_app_bar.dart';
import 'custom_bottom_bar.dart';
import 'main_home.dart';
import 'PillDetailPage.dart';
import 'dart:typed_data';
import 'dart:io';

class ResultPage extends StatelessWidget {
  final File imageFile;
  final String drugName;
  final String formulation;
  final String color;
  final String efficacy;
  final Map<String, dynamic> fullData;
  final double confidence;
  final String userId;

  const ResultPage({
    super.key,
    required this.imageFile,
    required this.drugName,
    required this.formulation,
    required this.color,
    required this.efficacy,
    required this.fullData,
    required this.confidence,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '인식결과',
        onBackPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainHomePage(userId: userId)),
                (route) => false,
          );
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 이미지 표시
                  Image.file(
                    imageFile,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16),
                  // 신뢰도 표시
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '신뢰도: ${confidence.toStringAsFixed(2)}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
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
                          userId: userId,
                          confidence: confidence,
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
            MaterialPageRoute(builder: (context) => MainHomePage(userId: userId)),
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
