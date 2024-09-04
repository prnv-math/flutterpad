import 'package:flutterpad/models/note.dart';
import 'package:flutterpad/models/tag.dart';
import 'package:flutterpad/models/userdata.dart';

class UserService {
  Future<UserData> getUserData() async {
    //return some value for now
    Tag tag = Tag(id: 01, name: "Important");
    Note note1 = Note(id: 01, title: "Guidelines"),
        note2 = Note(id: 02, title: "To-Do");
    note1.addTag(tag);
    note2.addTag(tag);
    return UserData(userID: "01", notes: [note1, note2], tags: [tag]);
  }
  //define client-end-functions for CRUD on note,tag
}
