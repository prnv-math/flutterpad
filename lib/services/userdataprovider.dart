import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterpad/models/note.dart';
import 'package:flutterpad/models/tag.dart';
import 'package:flutterpad/models/userdata.dart';
import 'package:flutterpad/services/databaseservice.dart';

class UserDataProvider extends ChangeNotifier {
  UserData _userData =
      UserData(userID: "1", username: "Guest", notes: [], tags: []);
  final Map<int, Note> _pendingNoteUpdates = {};
  Timer? _syncTimer;

  UserData get userData => _userData;

  UserDataProvider() {
    fetchUserData();
    _startSyncTimer();
  }

  Future<void> fetchUserData() async {
    final List<Note> notes;
    final List<Tag> tags;

    notes = await DatabaseService.instance.getAllNotes();
    tags = await DatabaseService.instance.getAllTags();
    _userData = UserData(
        userID: _userData.userID,
        username: _userData.username,
        notes: notes,
        tags: tags);
    notifyListeners();
  }

  void _startSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(minutes: 2), (_) async {
      await syncPendingUpdates();
    });
  }

  Future<void> syncPendingUpdates() async {
    if (_pendingNoteUpdates.isNotEmpty) {
      for (var note in _pendingNoteUpdates.values) {
        await DatabaseService.instance.updateNote(note);
      }
      _pendingNoteUpdates.clear();
      notifyListeners();
    }
  }

  //add note & tag edit, delete and all
  Future<void> addNote(Note note) async {
    await DatabaseService.instance.createNote(note);
    _userData.notes.add(note);
  }

  Future<void> deleteNote(int noteId) async {
    await DatabaseService.instance.deleteNote(noteId);
    _userData.notes.remove(_userData.notes.where((n) {
      return n.id == noteId;
    }).first);
  }

  void updateNote(int noteId, Note note) {
    final noteIdx = _userData.notes.indexWhere((n) => n.id == noteId);
    if (noteIdx < 0) {
      throw ArgumentError("invalid Note Id");
    }
    _userData.notes[noteIdx] = note;
    // print(note.title + " updated");
    // print(note.content);
    _pendingNoteUpdates[note.id] = note; // Store for later
  }

  Future<void> addTag(Tag tag) async {
    await DatabaseService.instance.createTag(tag);
    _userData.tags.add(tag);
  }

  Future<void> updateTag(int tagID, String tagName) async {
    await DatabaseService.instance.updateTag(tagID, tagName);
    final idx = _userData.tags.indexWhere((t) => t.id == tagID);
    Tag updatedTag = _userData.tags.elementAt(idx);
    updatedTag.name = tagName;
    _userData.tags[idx] = updatedTag;
  }

  Future<void> deleteTag(int tagId) async {
    await DatabaseService.instance.deleteTag(tagId);
    _userData.tags.remove(_userData.tags.where((t) {
      return t.id == tagId;
    }).first);
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    super.dispose();
  }
}
