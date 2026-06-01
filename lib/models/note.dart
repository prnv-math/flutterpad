import 'dart:ffi';

import 'package:flutterpad/models/tag.dart';

class Note {
  final int id;
  late final DateTime dateCreated;
  late DateTime dateModified;
  late final List<int> _tagIDs;
  String title;
  String content = "";
  // "Remember that Flutter's layout system is different from traditional HTML layouts, so you might need to adapt your approach to achieve the desired results.";

  Note(
      {required this.id,
      required this.title,
      this.content = "",
      DateTime? dateCreatedAt,
      DateTime? dateModifiedLast,
      List<int>? tagIDList}) {
    dateCreated = dateCreatedAt ?? DateTime.now();
    dateModified = dateModifiedLast ?? DateTime.now();
    _tagIDs = tagIDList ?? [];
  }

  //Tag management for note
  void addTag(Tag tag) {
    if (!_tagIDs.contains(tag.id)) {
      _tagIDs.add(tag.id);
    }
  }

  void removeTag(Tag tag) {
    _tagIDs.remove(tag.id);
  }

  List<Tag> getTags(List<Tag> allTags) {
    return allTags.where((t) => _tagIDs.contains(t.id)).toList();
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

  factory Note.fromMap(Map<String, dynamic> map,
      [List<int> tagIDs = const []]) {
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
        tagIDList: tagIDs);
  }
}
