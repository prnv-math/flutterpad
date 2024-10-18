import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterpad/UI/home.dart';
import 'package:flutterpad/models/note.dart';
import 'package:flutterpad/services/storageservice.dart';

class Editor extends StatefulWidget {
  final Note note;
  const Editor(this.note, {super.key});

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  late TextEditingController _textEditingController;
  late Timer? _debounceTimer = Timer(const Duration(milliseconds: 500), () {
    StorageService.updateNoteText(
        widget.note, _textEditingController.text.trim());
  });

  @override
  void initState() {
    _textEditingController = TextEditingController(text: widget.note.content);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.note.title,
          style: const TextStyle(
            fontFamily: 'monospace',
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ));
            },
            icon: const Icon(Icons.arrow_back_outlined)),
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 2),
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_drop_down_outlined)))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 8, top: 12),
        child: Column(children: [
          // Text(
          //   "Write here...",
          //   style: TextStyle(color: Colors.black38),
          // ),
          TextField(
            controller: widget.note.content.isEmpty
                ? TextEditingController()
                : _textEditingController,
            maxLines: null,
            // ,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration.collapsed(
                hintText: "Write here...",
                hintStyle: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.normal,
                    fontSize: 16)),
            style: const TextStyle(
              fontSize: 19,
              height: 1.5,
            ),
            onChanged: (_) {
              if (_debounceTimer?.isActive ?? false) {
                _debounceTimer!.cancel();
              }
              _debounceTimer = Timer(const Duration(milliseconds: 500), () {
                StorageService.updateNoteText(
                    widget.note, _textEditingController.text.trim());
              });
            },
          )
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _textEditingController.dispose();
    super.dispose();
  }
}
