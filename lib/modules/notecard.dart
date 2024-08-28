// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutterpad/models/note.dart';
import 'package:flutterpad/styles/styles.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  const NoteCard({super.key, required this.note});

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  final int h = Random().nextInt(10) + 1;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120 + (50 * (h / 10)),
        decoration: BoxDecoration(
          color: ColorDict.noteCardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorDict.noteCardborder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(widget.note.title),
                  Text(
                    widget.note.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        )
        // GridView.builder(
        //     physics: const NeverScrollableScrollPhysics(),
        //     padding: const EdgeInsets.all(6),
        //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //       // childAspectRatio: 5.0,
        //       mainAxisExtent: 40,
        //       crossAxisCount: 2, // Number of columns
        //       crossAxisSpacing: 8.0,
        //       mainAxisSpacing: 8.0, // Spacing between rows
        //     ),
        //     itemCount: 4,
        //     itemBuilder: (context, i) {
        //       return Container(
        //         width: (i.isEven) ? 200 : null,
        //         decoration: BoxDecoration(
        //           color: ColorDict.noteCardColor,
        //           borderRadius: BorderRadius.circular(12),
        //           border: Border.all(color: ColorDict.noteCardborder),
        //         ),
        //         child: TextButton(
        //           onPressed: () {},
        //           child: const Row(
        //             children: [],
        //           ),
        //         ),
        //       );
        //     }),
        );
  }
}
