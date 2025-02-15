import 'package:flutter/material.dart';
import 'package:flutterpad/models/note.dart';
import 'package:flutterpad/models/tag.dart';
import 'package:flutterpad/models/userdata.dart';
import 'package:flutterpad/services/databaseservice.dart';

class UserDataProvider extends ChangeNotifier {
  UserData _userData =
      UserData(userID: "1", username: "Guest", notes: [], tags: []);

  UserData get userData => _userData;

  Future<void> fetchUserData() async {
    // TO-DO :
    late final List<Note> notes;
    late final List<Tag> tags;

    notes = await DatabaseService.instance.getAllNotes();
    tags = await DatabaseService.instance.getAllTags();
    _userData = UserData(
        userID: _userData.userID,
        username: _userData.username,
        notes: notes,
        tags: tags);
    notifyListeners();
  }

  //add note & tag edit, delete and all

  void updateNoteContent(Note n, String text) {
    if (_userData.notes.contains(n)) {
      _userData.notes.elementAt(_userData.notes.indexOf(n)).content = text;
    }
  }

  void updateNoteTitle(Note note, String title) {
    if (_userData.notes.contains(note)) {
      _userData.notes.elementAt(_userData.notes.indexOf(note)).title = title;
    }
  }
}
