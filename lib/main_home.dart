import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'upload_loading.dart';
import 'allow.dart';
import 'custom_bottom_bar.dart';
import 'setting.dart';
import 'setting_dart.dart';
import 'entry_point.dart'; // ThemeState를 사용하기 위해 import

class MainHomePage extends StatefulWidget {
  final String userId;

  const MainHomePage({super.key, required this.userId});

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  String? _imagePath;
  String? _permissionStatus;

  Future<void> _checkPermission(BuildContext context) async {
    try {
      var response = await http.get(Uri.parse(''));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['image_permission'] == 1) {
          if (mounted) {
            setState(() {
              _permissionStatus = '권한 허용됨';
            });
          }
          _accessGallery();
          return;
        }
      }

      if (mounted) {
        setState(() {
          _permissionStatus = '권한이 없으므로 요청합니다';
        });
      }

      _requestPermission(context);
    } catch (e) {
      if (mounted) {
        setState(() {
          _permissionStatus = '권한 상태 확인 실패: ${e.toString()}';
        });
      }
      print('Error: $e');
    }
  }

  Future<void> _requestPermission(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AllowPage(userId: widget.userId);
      },
    );
  }

  Future<void> _accessGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (mounted) {
        setState(() {
          _imagePath = image.path;
        });
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoadingPage(
            imageFile: File(_imagePath!),
            userId: widget.userId,
          ),
        ),
      );
    } else {
      if (mounted) {
        setState(() {
          _imagePath = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ThemeState.backgroundColor,
      builder: (context, backgroundColor, child) {
        return ValueListenableBuilder(
          valueListenable: ThemeState.textColor,
          builder: (context, textColor, child) {
            return ValueListenableBuilder(
              valueListenable: ThemeState.textSize,
              builder: (context, textSize, child) {
                return ValueListenableBuilder(
                  valueListenable: ThemeState.fontIndex,
                  builder: (context, fontIndex, child) {
                    final fonts = ['Default', 'Serif', 'Monospace'];
                    return WillPopScope(
                      onWillPop: () async => false, // 시스템 뒤로가기 버튼 무시
                      child: Scaffold(
                        appBar: AppBar(
                          title: Text(
                            'Pill Check',
                            style: TextStyle(
                              fontFamily: fonts[fontIndex] == 'Default' ? null : fonts[fontIndex],
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              fontSize: textSize,
                            ),
                          ),
                          backgroundColor: const Color(0xFFE9E9E9),
                          centerTitle: true,
                          elevation: 0,
                          automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
                        ),
                        backgroundColor: backgroundColor,
                        body: Stack(
                          children: [
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/1.png',
                                    height: 300,
                                    width: 300,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    _permissionStatus ?? '사진 불러오기를 통해 \n알약을 인식해보세요!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: textSize,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                      fontFamily: fonts[fontIndex] == 'Default'
                                          ? null
                                          : fonts[fontIndex],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
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
                                      Text(
                                        '선택된 이미지',
                                        style: TextStyle(fontSize: textSize, color: textColor),
                                      ),
                                    ],
                                  )
                                      : Text(
                                    '알약이 아닌 사진은 인식을 못할 수 있습니다.',
                                    style: TextStyle(fontSize: 17, color: textColor),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton.icon(
                                    onPressed: () => _checkPermission(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF80CBC4),
                                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                                      minimumSize: const Size(150, 50),
                                      textStyle: TextStyle(
                                        fontSize: textSize,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: fonts[fontIndex] == 'Default'
                                            ? null
                                            : fonts[fontIndex],
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                    label: Text(
                                      '사진 불러오기',
                                      style: TextStyle(color: Colors.black, fontSize: textSize),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 13,
                              left: 16,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SettingPage1(userId: widget.userId), // SettingsPage로 이동
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.settings,
                                  size: 40,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        bottomNavigationBar: CustomBottomBar(
                          onHomePressed: () {},
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
