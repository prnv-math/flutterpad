import 'package:flutter/material.dart';
import 'package:flutterpad/models/note.dart';
import 'package:flutterpad/modules/notecard.dart';
import 'package:flutterpad/styles/styles.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorDict.bgColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontFamily: 'monospace',
          ),
        ),
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
          const SizedBox(
            width: 2,
          ),
          Container(
              margin: const EdgeInsets.only(right: 2),
              child: IconButton(
                  onPressed: () {}, icon: const Icon(Icons.info_rounded)))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: 6,
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    // return Text('data#${i + 1}');
                    if (i != 0) {
                      return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 4),
                          child: NoteCard(
                              note: Note(
                            id: i,
                            title: "Note#$i",
                          )));
                    } else {
                      return const SizedBox(
                        height: 4,
                      );
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
