import 'package:flutterpad/models/note.dart';
import 'package:flutterpad/models/tag.dart';
import 'package:flutterpad/models/userdata.dart';

abstract class StorageService {
  static UserData _userData = UserData(userID: "01", notes: [
    () {
      final n = Note(id: 01, title: "Guidelines");
      n.addTag(Tag(id: 01, name: "Important"));
      n.addTag(Tag(id: 02, name: "Favorites"));

      return n;
    }(),
    () {
      final n = Note(id: 02, title: "Tips");
      // n.addTag(Tag(id: 01, name: "Important"));
      return n;
    }()
  ], tags: [
    Tag(id: 01, name: "Important"),
    Tag(id: 02, name: "Favorites")
  ]);
  static Future<UserData> getUserData() async {
    return _userData;
  }

  static void setUserData(UserData d) {
    _userData = d;
  }

  static void updateNoteText(Note n, String text) {
    if (_userData.notes.contains(n)) {
      _userData.notes.elementAt(_userData.notes.indexOf(n)).content = text;
    }
  }

  static void updateTitleText(Note note, String title) {
    if (_userData.notes.contains(note)) {
      _userData.notes.elementAt(_userData.notes.indexOf(note)).title = title;
    }
  }
}
