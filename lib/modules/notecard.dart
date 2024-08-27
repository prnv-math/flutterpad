// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutterpad/models/note.dart';

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
      height: 150,
      decoration: BoxDecoration(
        color: const Color(0xFF747264),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF555843)),
      ),
      child:
          // Row(
          //   children: [
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [Text(widget.note.title), Text(widget.note.content)],
          //     ),
          //     Column()
          //   ],
          // ),
          GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(6),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 5 / 1,
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0, // Spacing between rows
              ),
              itemCount: 4,
              itemBuilder: (context, i) {
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF7D7463),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF555843)),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: const Row(
                      children: [
                        Icon(Icons.mail_outline_outlined),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Mail",
                        )
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
