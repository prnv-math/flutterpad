import 'package:flutter/material.dart';
import 'package:flutterpad/models/userdata.dart';
import 'package:flutterpad/services/userservice.dart';

class UserDataProvider extends ChangeNotifier {
  UserData? _userData;
  UserData? get userData => _userData;

  Future<void> fetchUserDetails() async {
    final UserService userService = UserService();

    _userData = await userService.getUserData();
    notifyListeners();
  }
  //add note & tag edit, delete and all
}
