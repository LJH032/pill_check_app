import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'custom_app_bar.dart';
import 'custom_bottom_bar.dart';

class PillDetailPage extends StatefulWidget {
  final Map<String, dynamic> fullData;
  final String userId;
  final double confidence;

  const PillDetailPage({
    super.key,
    required this.fullData,
    required this.userId,
    required this.confidence,
  });

  @override
  _PillDetailPageState createState() => _PillDetailPageState();
}

class _PillDetailPageState extends State<PillDetailPage> {
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    var response = await http.get(Uri.parse('http://10.0.2.2:5000/predict'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      String base64Image = data['image'];

      setState(() {
        imageBytes = base64Decode(base64Image);
      });
    } else {
      print('Failed to load image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '알약 상세 정보',
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
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
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: imageBytes != null
                          ? Image.memory(
                        imageBytes!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      )
                          : Image.asset(
                        'assets/images/2.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '신뢰도: ${widget.confidence.toStringAsFixed(2)}%',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '가져오신 알약의 정보를 알려드립니다.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildInfoBlock('이름', widget.fullData['drug_name']),
              _buildInfoBlock('제형', widget.fullData['formulation']),
              _buildInfoBlock('색상', widget.fullData['color']),
              _buildInfoBlock('효능', widget.fullData['efficacy']),
              _buildInfoBlock('분할선', widget.fullData['Separating_Line']),
              _buildInfoBlock('사용 방법', widget.fullData['usage_method']),
              _buildInfoBlock('주의사항', widget.fullData['warning']),
              _buildInfoBlock('주의사항(기타)', widget.fullData['precautions']),
              _buildInfoBlock('상호작용', widget.fullData['interactions']),
              _buildInfoBlock('부작용', widget.fullData['side_effects']),
              _buildInfoBlock('저장 방법', widget.fullData['storage_method']),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        onHomePressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildInfoBlock(String title, String content) {
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
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
