import 'package:flutter/material.dart';
import 'main_home.dart'; // MainHomePage import 추가
import 'custom_app_bar.dart'; // CustomAppBar 컴포넌트 import
import 'custom_bottom_bar.dart'; // CustomBottomBar 컴포넌트 import

class PillDetailPage extends StatelessWidget {
  final Map<String, dynamic> fullData; // 상세 정보 데이터를 전달받음
  final String userId; // 사용자 ID를 받아옴

  const PillDetailPage({super.key, required this.fullData, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '상세 정보', // CustomAppBar에서 제목 설정
        onBackPressed: () {
          Navigator.pop(context); // 이전 화면으로 이동
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white, // 흰색 배경 설정
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: fullData['image'] != null
                    ? Image.memory(
                  fullData['image'],
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                )
                    : Image.asset(
                  'assets/images/2.png', // 기본 이미지 사용
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              _buildInfoBlock('이름', fullData['drug_name']),
              _buildInfoBlock('제형', fullData['formulation']),
              _buildInfoBlock('색상', fullData['color']),
              _buildInfoBlock('효능', fullData['efficacy']),
              _buildInfoBlock('분할선', fullData['Separating_Line']),
              _buildInfoBlock('사용 방법', fullData['usage_method']),
              _buildInfoBlock('주의사항', fullData['warning']),
              _buildInfoBlock('주의사항(기타)', fullData['precautions']),
              _buildInfoBlock('상호작용', fullData['interactions']),
              _buildInfoBlock('부작용', fullData['side_effects']),
              _buildInfoBlock('저장 방법', fullData['storage_method']),
              const SizedBox(height: 24),
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
