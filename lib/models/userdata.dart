import 'package:flutterpad/models/note.dart';
import 'package:flutterpad/models/tag.dart';

class UserData {
  final String userID;
  final List<Note> notes;
  final List<Tag> tags;

  UserData({required this.userID, required this.notes, required this.tags});
}