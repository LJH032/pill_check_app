import 'package:flutter/material.dart';
import 'custom_app_bar.dart';
import 'custom_bottom_bar.dart';
import 'main_home.dart';
import 'PillDetailPage.dart';
import 'dart:io';
import 'entry_point.dart'; // ThemeState import

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
    return ValueListenableBuilder(
      valueListenable: ThemeState.backgroundColor,
      builder: (context, backgroundColor, child) {
        return ValueListenableBuilder(
          valueListenable: ThemeState.textColor,
          builder: (context, textColor, child) {
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
              backgroundColor: backgroundColor,
              body: SingleChildScrollView(
                child: Container(
                  color: backgroundColor,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 이미지 표시
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                imageFile,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // 신뢰도 표시
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '신뢰도: ${confidence.toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '알약 분석 결과입니다.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textColor.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildInfoBlock('이름', drugName, textColor),
                      _buildInfoBlock('제형', formulation, textColor),
                      _buildInfoBlock('색상', color, textColor),
                      _buildInfoBlock('효능', efficacy, textColor),
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            '상세 정보 보기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
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
          },
        );
      },
    );
  }

  // 블록 빌드 함수
  Widget _buildInfoBlock(String title, String content, Color textColor) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
