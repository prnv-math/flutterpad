import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterpad/UI/home.dart';
import 'package:flutterpad/models/note.dart';
import 'package:flutterpad/services/userdataprovider.dart';
import 'package:flutterpad/utils/dictionary.dart';
import 'package:provider/provider.dart';

class Editor extends StatefulWidget {
  final Note note;
  const Editor(this.note, {super.key});

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  late TextEditingController _textEditingController;
  late TextEditingController _titleEditingController;
  // late ScrollController _textScrollController;
  late Timer? _debounceTimer = Timer(const Duration(milliseconds: 100), () {});
  bool menuShowing = false;

  @override
  void initState() {
    _debounceTimer?.cancel();
    _textEditingController = TextEditingController(text: widget.note.content);
    _titleEditingController = TextEditingController(text: widget.note.title);
    // _textScrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorDict.noteCardColor,
      // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(
        // clipBehavior: Clip.none,
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: ColorDict.noteCardColor,

        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: TextField(
          textCapitalization: TextCapitalization.sentences,
          controller: _titleEditingController,
          style: const TextStyle(
            fontFamily: 'monospace',
          ),
          decoration: const InputDecoration.collapsed(
              hintText: "Untitled Note",
              hintStyle: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.normal,
                  fontSize: 16)),
          onChanged: (_) {
            if (_debounceTimer?.isActive ?? false) {
              _debounceTimer!.cancel();
            }
            _debounceTimer = Timer(const Duration(milliseconds: 500), () {
              context.read<UserDataProvider>().updateNoteTitle(
                  widget.note, _titleEditingController.text.trim());
            });
          },
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  _debounceTimer?.cancel();
                  return Home();
                },
              ));
            },
            icon: const Icon(Icons.arrow_back_outlined)),
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 2),
              child: PopupMenuButton(
                  // color: Colors.white,
                  offset: const Offset(0, 12),
                  position: PopupMenuPosition.under,
                  onCanceled: () {
                    setState(() {
                      menuShowing = false;
                    });
                  },
                  onOpened: () {
                    setState(() {
                      menuShowing = true;
                    });
                  },
                  itemBuilder: (_) {
                    return [
                      const PopupMenuItem(
                          child: Text(
                        "Insert",
                        style: TextStyle(color: ColorDict.bgColor),
                      )),
                      const PopupMenuItem(
                          child: Text(
                        "Share",
                        style: TextStyle(color: ColorDict.bgColor),
                      )),
                      const PopupMenuItem(
                          child: Text(
                        "Delete",
                        style: TextStyle(color: ColorDict.bgColor),
                      ))
                    ];
                  },
                  icon: menuShowing
                      ? const Icon(Icons.arrow_drop_up)
                      : const Icon(Icons.arrow_drop_down_outlined)))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 8, top: 8, bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 8,
              spacing: 6,
              children: () {
                final List<TextButton> tagBtns = [];
                for (var tag in widget.note.getTags()) {
                  tagBtns.add(TextButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorDict.bgColor,
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: ColorDict.noteCardborder),
                              borderRadius: BorderRadius.circular(20))),
                      child: Text(
                        tag.name,
                        style: const TextStyle(
                            color: ColorDict.noteCardColor, fontSize: 10),
                      )));
                }

                return tagBtns;
              }(),
            ),
            SizedBox(
              height: 24,
            ),
            Expanded(
              child: TextField(
                // clipBehavior: Clip.antiAlias,
                // scrollController: _textScrollController,
                // scrollPhysics: ScrollPhysics(),
                expands: true,
                controller:
                    // widget.note.content.isEmpty
                    //     ? TextEditingController():
                    _textEditingController,
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
                    context.read<UserDataProvider>().updateNoteContent(
                        widget.note, _textEditingController.text.trim());
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _textEditingController.dispose();
    _titleEditingController.dispose();
    super.dispose();
  }
}
