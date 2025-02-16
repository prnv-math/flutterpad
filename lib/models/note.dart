import 'package:flutterpad/models/tag.dart';

class Note {
  final int id;
  late final DateTime dateCreated;
  late DateTime dateModified;
  final List<Tag> _tags = [];
  String title;
  String content = "";
  // "Remember that Flutter's layout system is different from traditional HTML layouts, so you might need to adapt your approach to achieve the desired results.";

  Note(
      {required this.id,
      required this.title,
      this.content = "",
      DateTime? dateCreatedAt,
      DateTime? dateModifiedLast}) {
    dateCreated = dateCreatedAt ?? DateTime.now();
    dateModified = dateModifiedLast ?? DateTime.now();
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

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date_created': dateCreated.toIso8601String().split('T').first,
      'date_modified': dateModified.toIso8601String().split('T').first
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      //null-check instead of migrating to new schema to set these to not-nullable (for now)
      dateCreatedAt: map['date_created'] != null
          ? DateTime.parse(map['date_created'])
          : DateTime.now(),
      dateModifiedLast: map['date_modified'] != null
          ? DateTime.parse(map['date_modified'])
          : DateTime.now(),
    );
  }
}
