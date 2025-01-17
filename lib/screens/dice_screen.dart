import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/token_info.dart'; // TokenInfo 모델 임포트
import '../widgets/snack_bar.dart'; // 스낵바 위젯 임포트

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;

  // 임의의 사용자 데이터
  String currentName = "홍길동";
  String currentEmail = "honggildong@example.com";

  @override
  void initState() {
    super.initState();
    // 사용자 정보를 가져오기 위한 컨트롤러 초기화
    nameController = TextEditingController(text: currentName);
    emailController = TextEditingController(text: currentEmail);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  // 사용자 정보 업데이트 요청
  Future<void> updateProfile(BuildContext context) async {
    // 실제 API 호출을 대체하는 로직
    String updatedName = nameController.text;
    String updatedEmail = emailController.text;

    showSnackBar(context, '프로필이 업데이트 되었습니다!\n이름: $updatedName\n이메일: $updatedEmail');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('프로필'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: '이름',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: '이메일',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                updateProfile(context);
              },
              child: Text('프로필 업데이트'),
            ),
            SizedBox(height: 20.0),
            Text(
              '현재 사용자: $currentName',
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              '이메일: $currentEmail'
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
