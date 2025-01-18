import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/user_info.dart';
import '../models/token_info.dart';
import '../widgets/snack_bar.dart'; // 스낵바 위젯 임포트
import 'profile_screen.dart'; // ProfileScreen 임포트 추가

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserInfo? userInfo;
  String? responseError;
  bool isLogin = false;
  bool isButtonEnabled = false;
  String selectedLanguage = '한국어';

  TextEditingController namectl = TextEditingController();
  TextEditingController passwordctl = TextEditingController();

  // 버튼 활성화
  @override
  void initState() {
    super.initState();
    // TextEditingController의 리스너 추가
    namectl.addListener(_updateButtonState);
    passwordctl.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled = namectl.text.isNotEmpty && passwordctl.text.isNotEmpty;
    });
  }

  Future<void> loginRequest(BuildContext context) async {
    TokenInfo provider = context.read<TokenInfo>();
    final url = Uri.parse("http://10.0.2.2:8080/login");
    final body = userInfo!.toJson();

    try {
      final response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        setState(() {
          isLogin = true;
        });
        final refresh = response.headers['set-cookie'];
        final access = response.headers['authorization'];
        provider.saveAccessToken(access);
        provider.saveRefreshToken(refresh);
      } else if (response.statusCode == 401) {
        responseError = utf8.decode(response.bodyBytes);
      } else {
        setState(() {
          responseError = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        responseError = 'Exception: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                selectedLanguage = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(value: '한국어', child: Text('한국어')),
                const PopupMenuItem(value: '영어', child: Text('영어')),
                const PopupMenuItem(value: '일본어', child: Text('일본어')),
                const PopupMenuItem(value: '중국어', child: Text('중국어')),
              ];
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  Text(selectedLanguage),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 로고 추가
              Container(
                margin: EdgeInsets.only(top: 50.0),
                child: Image.asset(
                  'assets/logo.png',
                  width: 180,
                  height: 100,
                ),
              ),
              Form(
                child: Theme(
                  data: ThemeData(
                    inputDecorationTheme: InputDecorationTheme(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.pinkAccent),
                      ),
                      labelStyle: TextStyle(
                        color: Colors.green,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: namectl,
                          decoration: InputDecoration(
                            labelText: '아이디 또는 전화번호',
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        TextField(
                          controller: passwordctl,
                          decoration: InputDecoration(
                            labelText: '비밀번호',
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                        ),
                        SizedBox(height: 30.0),
                        // ================================== 로그인 버튼 =================================
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isButtonEnabled ? Color.fromARGB(255, 3, 199, 90) : Colors.grey,
                            minimumSize: Size(200, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: isButtonEnabled ? () {
                            setState(() {
                              userInfo = UserInfo(
                                username: namectl.text,
                                password: passwordctl.text,
                              );
                            });

                            loginRequest(context).then((_) {
                              if (isLogin) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                              } else {
                                showSnackBar(context, responseError!);
                              }
                            });
                          } : null, // 버튼 비활성화 처리
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 35.0,
                          ),
                        ),
                        if (responseError != null)
                          Text(responseError!, style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}