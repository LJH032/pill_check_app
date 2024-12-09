import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // File 클래스를 임포트
import 'upload_loading.dart'; // LoadingPage 임포트
import 'allow.dart'; // AllowPage 임포트

class MainHomePage extends StatefulWidget {
  final String userId;

  const MainHomePage({super.key, required this.userId});

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  // 선택된 이미지 경로와 권한 상태를 저장하는 변수
  String? _imagePath;
  String? _permissionStatus;

  // 권한 상태를 확인하고, 갤러리 접근을 시도하는 메소드
  Future<void> _checkPermission(BuildContext context) async {
    var response = await http.get(Uri.parse('http://10.0.2.2:5000/get_permission/${widget.userId}'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['image_permission'] == 1) {
        setState(() {
          _permissionStatus = '권한 허용됨';
        });
        _accessGallery();
        return;
      }
    }

    setState(() {
      _permissionStatus = '권한이 없으므로 요청합니다';
    });

    // 권한이 허용되지 않았거나 조회 실패 시 갤러리 접근 권한 요청
    _requestPermission(context);
  }

  // 권한을 요청하고, 권한 허용 시 데이터베이스 업데이트 및 갤러리 접근
  Future<void> _requestPermission(BuildContext context) async {
    // AllowPage를 호출하여 갤러리 권한 요청
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AllowPage(userId: widget.userId);
      },
    );
  }

  // 갤러리에서 이미지 선택
  Future<void> _accessGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });

      // 이미지 선택 후, LoadingPage로 이동하여 업로드 및 분석 요청
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoadingPage(
            imageFile: File(_imagePath!),
            userId: widget.userId, // 사용자 ID 전달
          ),
        ),
      );
    } else {
      setState(() {
        _imagePath = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pill Check'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // 권한 상태 표시
            Text(
              _permissionStatus ?? '권한 상태를 확인 중...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 선택된 이미지 미리보기
            _imagePath != null
                ? Column(
              children: [
                Image.file(
                  File(_imagePath!),
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                const Text('선택된 이미지'),
              ],
            )
                : const Text('이미지가 선택되지 않았습니다.'),
            const SizedBox(height: 20),

            // 사진 불러오기 버튼
            ElevatedButton(
              onPressed: () => _checkPermission(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // 버튼 색상
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: const Text('사진 불러오기'),
            ),
            const SizedBox(height: 20),

            // 이미지 선택 후 다음 단계로 이동하는 버튼 (선택된 이미지가 있을 때만 활성화)
            _imagePath != null
                ? ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoadingPage(
                      imageFile: File(_imagePath!),
                      userId: widget.userId, // 사용자 ID 전달
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // 버튼 색상
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: const Text('분석 시작'),
            )
                : Container(), // 이미지가 없으면 버튼 숨김
          ],
        ),
      ),
    );
  }
}
