import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PillDetailPage extends StatefulWidget {
  final Map<String, dynamic> fullData;
  final String userId;
  final double confidence;  // 신뢰도 추가

  const PillDetailPage({
    super.key,
    required this.fullData,
    required this.userId,
    required this.confidence,  // 신뢰도 추가
  });

  @override
  _PillDetailPageState createState() => _PillDetailPageState();
}

class _PillDetailPageState extends State<PillDetailPage> {
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    _loadImage();  // 서버에서 이미지 불러오기
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
      appBar: AppBar(title: Text('Pill Details')),
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
                  imageBytes != null
                      ? Image.memory(
                    imageBytes!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    'assets/images/2.png',
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
                        '신뢰도: ${widget.confidence.toStringAsFixed(2)}%',
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
    );
  }

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
