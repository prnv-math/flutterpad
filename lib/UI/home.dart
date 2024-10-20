import 'package:flutter/material.dart';
import 'package:flutterpad/UI/editor.dart';
import 'package:flutterpad/UI/widgets/notecard.dart';
import 'package:flutterpad/UI/widgets/tagpadsearchdelegate.dart';
import 'package:flutterpad/models/note.dart';
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
  List<Note> filteredNotes = [];

  @override
  void initState() {
    context.read<UserDataProvider>().fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorDict.bgColor,
      appBar: AppBar(
        backgroundColor: ColorDict.noteCardColor,
        leading: Builder(builder: (ctx) {
          return IconButton(
              onPressed: () {
                Scaffold.of(ctx).openDrawer();
              },
              icon: const Icon(Icons.menu));
        }),
        actions: [
          // SizedBox(
          //   width: 120,
          //   child: TextField(
          //     controller: _searchController,
          //     decoration: const InputDecoration(
          //       hintText: 'Search...',
          //       border: InputBorder.none, // Removes underline
          //       hintStyle:
          //           TextStyle(color: ColorDict.bgColor), // Hint text style
          //     ),
          //   ),
          // ),
          Consumer<UserDataProvider>(
            builder: (context, userDataProvider, child) {
              if (userDataProvider.userData == null) {
                return const IconButton(
                    onPressed: null, icon: Icon(Icons.search_rounded));
              }
              if (filteredNotes.isNotEmpty) {
                return IconButton(
                    onPressed: () {
                      setState(() {
                        filteredNotes.clear();
                      });
                    },
                    icon: const Icon(Icons.close));
              } else {
                return IconButton(
                    onPressed: () async {
                      final res = await showSearch(
                          context: context,
                          delegate: TagPadSearchDelegate(
                              userDataProvider.userData!.notes,
                              userDataProvider.userData!.tags));
                      if (res != null && res.isNotEmpty) {
                        setState(() {
                          filteredNotes = res;
                        });
                      }
                    },
                    icon: const Icon(Icons.search_rounded));
              }
            },
          ),
          const SizedBox(
            width: 2,
          ),
          Container(
              margin: const EdgeInsets.only(right: 2),
              child: IconButton(
                  onPressed: () {}, icon: const Icon(Icons.info_rounded)))
        ],
        centerTitle: true,
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
                  final displayedNotes = filteredNotes.isEmpty
                      ? userdataProvider.userData!.notes
                      : filteredNotes;
                  return ListView.builder(
                      itemCount: displayedNotes.length + 1,
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
                                        builder: (context) =>
                                            Editor(displayedNotes[i - 1])));
                              },
                              child: NoteCard(note: displayedNotes[i - 1]),
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
      drawer: Drawer(
        backgroundColor: ColorDict.bgColor,
        child: ListView(
          children: [
            SizedBox(
              width: double.maxFinite,
              height: 160,
              child: Center(
                  child: Text(
                Constants.appTitle,
                style: const TextStyle(color: ColorDict.noteCardborder),
              )),
            ),
            Divider(
              color: ColorDict.noteCardborder.withOpacity(0.8),
            ),
            ListTile(
              leading: const Icon(
                Icons.view_sidebar_rounded,
                color: ColorDict.noteCardColor,
              ),
              title: const Text(
                'Tags',
                style: TextStyle(color: ColorDict.noteCardColor),
              ),
              onTap: () {
                // Handle tap action
              },
            ),
            const ListTile(
              leading: Icon(
                Icons.calendar_month,
                color: ColorDict.noteCardColor,
              ),
              title: Text(
                'Activities',
                style: TextStyle(color: ColorDict.noteCardColor),
              ),
              onTap: null,
            ),
            const ListTile(
              leading: Icon(
                Icons.analytics_outlined,
                color: ColorDict.noteCardColor,
              ),
              title: Text(
                'Analytics',
                style: TextStyle(color: ColorDict.noteCardColor),
              ),
              onTap: null,
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
                color: ColorDict.noteCardColor,
              ),
              title: const Text(
                'Settings',
                style: TextStyle(color: ColorDict.noteCardColor),
              ),
              onTap: () {
                // Handle tap action
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // _searchController.dispose();
    super.dispose();
  }
}
