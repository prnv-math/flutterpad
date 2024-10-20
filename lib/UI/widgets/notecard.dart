// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutterpad/models/note.dart';
import 'package:flutterpad/utils/dictionary.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  const NoteCard({super.key, required this.note});

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(2),
        constraints: const BoxConstraints(minHeight: 120),
        decoration: BoxDecoration(
          color: ColorDict.noteCardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorDict.noteCardborder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${widget.note.title}\n"),
                    Wrap(
                      children: [
                        Text(
                          widget.note.content,
                          maxLines: 7,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const VerticalDivider(
              color: ColorDict.noteCardborder,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                // const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(() {
                      final String str;
                      final List<String> monthNames = [
                        'January',
                        'February',
                        'March',
                        'April',
                        'May',
                        'June',
                        'July',
                        'August',
                        'September',
                        'October',
                        'November',
                        'December'
                      ];
                      if (widget.note.dateModified.year !=
                          DateTime.now().year) {
                        str =
                            "${monthNames[widget.note.dateModified.month - 1]} ${widget.note.dateModified.day.toString().padLeft(2, '0')}, ${widget.note.dateModified.year}";
                      } else if (widget.note.dateModified.month !=
                          DateTime.now().month) {
                        str =
                            "${monthNames[widget.note.dateModified.month - 1]} ${widget.note.dateModified.day.toString().padLeft(2, '0')}";
                      } else if (widget.note.dateModified.day !=
                          DateTime.now().day) {
                        str =
                            "${monthNames[widget.note.dateModified.month - 1]} ${widget.note.dateModified.day.toString().padLeft(2, '0')}";
                      } else {
                        str =
                            "${widget.note.dateModified.hour.toString().padLeft(2, '0')}:${widget.note.dateModified.minute.toString().padLeft(2, '0')}";
                      }
                      return "$str\n";
                    }
                        //calls above anonymous function
                        ()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Wrap(
                            alignment: WrapAlignment.end,
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
                                                color:
                                                    ColorDict.noteCardborder),
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    child: Text(
                                      tag.name,
                                      style: const TextStyle(
                                          color: ColorDict.noteCardColor,
                                          fontSize: 10),
                                    )));
                              }

                              return tagBtns;
                            }(),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
