import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

class MainHomePage extends StatelessWidget {
  final String userId;

  const MainHomePage({super.key, required this.userId});

  Future<void> _checkPermission(BuildContext context) async {
    // 데이터베이스에서 접근 권한 상태 확인
    var response = await http.get(Uri.parse('http://127.0.0.1:5000/get_permission/$userId'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['image_permission'] == 1) {
        // 이미 권한이 허용된 경우 바로 갤러리 접근
        _accessGallery();
        return;
      }
    }

    // 권한이 허용되지 않았거나 조회 실패 시 갤러리 접근 권한 요청
    _requestPermission(context);
  }

  Future<void> _requestPermission(BuildContext context) async {
    // 갤러리 접근 권한 요청
    PermissionStatus status = await Permission.photos.request();

    if (status.isGranted) {
      // 권한이 허용되었을 때 데이터베이스에 업데이트 요청
      await http.post(
        Uri.parse('http://127.0.0.1:5000/update_permission'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId,
          'image_permission': 1, // 권한 허용
        }),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('갤러리 접근 권한이 허용되었습니다!')),
      );

      // 권한이 허용된 후 갤러리 접근
      _accessGallery();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('갤러리 접근 권한이 거부되었습니다.')),
      );

      if (status.isPermanentlyDenied) {
        openAppSettings(); // 사용자가 권한을 영구적으로 거부한 경우 설정으로 이동
      }
    }
  }

  void _accessGallery() {
    // 갤러리 접근 로직 구현
    // 여기에 갤러리에서 이미지를 선택하는 코드를 작성
    print('갤러리 접근 허용됨 - 여기에서 갤러리 접근 로직을 구현');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pill Check'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _checkPermission(context), // 권한 확인 후 접근
          child: const Text('사진 불러오기'),
        ),
      ),
    );
  }
}
