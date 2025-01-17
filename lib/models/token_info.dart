import 'package:flutter/material.dart';

class TokenInfo extends ChangeNotifier {
  String? accessToken;
  String? refreshToken;

  void saveAccessToken(String? token) {
    this.accessToken = token;
    notifyListeners();
  }

  void saveRefreshToken(String? token) {
    this.refreshToken = token;
    notifyListeners();
  }
}
