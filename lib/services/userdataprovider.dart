import 'package:flutter/material.dart';
import 'package:flutterpad/models/note.dart';
import 'package:flutterpad/models/tag.dart';
import 'package:flutterpad/models/userdata.dart';
import 'package:flutterpad/services/databaseservice.dart';

class UserDataProvider extends ChangeNotifier {
  UserData _userData =
      UserData(userID: "1", username: "Guest", notes: [], tags: []);
  // UserData(userID: "01", username: "Guest", notes: [
  //   () {
  //     final n = Note(id: 01, title: "Guidelines");
  //     n.addTag(Tag(id: 01, name: "Important"));
  //     n.addTag(Tag(id: 02, name: "Favorites"));

  //     return n;
  //   }(),
  //   () {
  //     final n = Note(id: 02, title: "Tips");
  //     // n.addTag(Tag(id: 01, name: "Important"));
  //     return n;
  //   }()
  // ], tags: [
  //   Tag(id: 01, name: "Important"),
  //   Tag(id: 02, name: "Favorites")
  // ]);

  UserData get userData => _userData;

  Future<void> fetchUserData() async {
    final notes = await DatabaseService.instance.getAllNotes();
    final tags = await DatabaseService.instance.getAllTags();
    _userData = UserData(
        userID: _userData.userID,
        username: _userData.username,
        notes: notes,
        tags: tags);
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
