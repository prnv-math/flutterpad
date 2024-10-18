import 'package:flutter/material.dart';
import 'package:flutterpad/UI/editor.dart';
import 'package:flutterpad/UI/widgets/notecard.dart';
import 'package:flutterpad/services/userdataprovider.dart';
import 'package:flutterpad/utils/dictionary.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({super.key});

  final String title = Constants.appTitle;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    context.read<UserDataProvider>().fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(103, 65, 136, 1),
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
            Expanded(child: Consumer<UserDataProvider>(
              builder: (context, userdataProvider, child) {
                if (userdataProvider.userData == null) {
                  return const CircularProgressIndicator();
                } else {
                  return ListView.builder(
                      itemCount: userdataProvider.userData!.notes.length + 1,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        // return Text('data#${i + 1}');
                        if (i != 0) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 4),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Editor(
                                            userdataProvider
                                                .userData!.notes[i - 1])));
                              },
                              child: NoteCard(
                                  note:
                                      userdataProvider.userData!.notes[i - 1]),
                            ),
                          );
                        } else {
                          return const SizedBox(
                            height: 4,
                          );
                        }
                      });
                }
              },
            ))
          ],
        ),
      ),
    );
  }
}
