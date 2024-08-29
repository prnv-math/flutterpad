import 'package:flutterpad/models/tag.dart';

class Note {
  final int id;
  final String title;
  late final DateTime dateCreated;
  late DateTime dateModified;
  final List<Tag> _tags = [];
  String content =
      "Remember that Flutter's layout system is different from traditional HTML layouts, so you might need to adapt your approach to achieve the desired results.";

  Note({required this.id, required this.title}) {
    dateCreated = DateTime.now();
    dateModified = DateTime.now();
  }

  //Tag management for note
  void addTag(Tag tag) {
    if (!_tags.contains(tag)) {
      _tags.add(tag);
    }
  }

  void removeTag(Tag tag) {
    _tags.remove(tag);
  }

  List<Tag> getTags() {
    return _tags;
  }
}
