import 'package:flutter/material.dart';
import 'package:flutterpad/models/userdata.dart';
import 'package:flutterpad/services/storageservice.dart';

class UserDataProvider extends ChangeNotifier {
  UserData? _userData;
  UserData? get userData => _userData;

  Future<void> fetchUserData() async {
    _userData = await StorageService.getUserData();
    notifyListeners();
  }
  //add note & tag edit, delete and all
}
