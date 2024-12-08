import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllowPage extends StatelessWidget {
  final String userId;

  const AllowPage({super.key, required this.userId});

  Future<void> _requestPermission(BuildContext context) async {
    // 서버에서 현재 권한 상태 조회
    var response = await http.get(Uri.parse('http://127.0.0.1:5000/get_permission/$userId'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['image_permission'] == 1) {
        // 권한이 이미 허용된 경우 이미지 선택으로 바로 이동
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미지 접근 권한이 이미 허용되었습니다.')),
        );
        return;
      }
    }

    // 갤러리 접근 권한 요청
    PermissionStatus status = await Permission.photos.request();

    if (status.isGranted) {
      // 권한이 허용되었을 때 권한 상태를 서버에 저장
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
    } else if (status.isDenied || status.isPermanentlyDenied) {
      // 권한이 거부되었을 때 권한 상태를 서버에 저장
      await http.post(
        Uri.parse('http://127.0.0.1:5000/update_permission'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId,
          'image_permission': 0, // 권한 거부
        }),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('갤러리 접근 권한이 거부되었습니다.')),
      );

      if (status.isPermanentlyDenied) {
        openAppSettings(); // 사용자가 권한을 영구적으로 거부한 경우 설정으로 이동
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        '갤러리 접근 권한 요청',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: const Text(
        '사진을 불러오기 위해 갤러리 접근 권한이 필요합니다. 권한을 허용하시겠습니까?',
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // 팝업 닫기
          },
          child: const Text(
            '취소',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context); // 팝업 닫기
            await _requestPermission(context); // 권한 요청 및 이미지 선택 함수 호출
          },
          child: const Text(
            '허용',
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
