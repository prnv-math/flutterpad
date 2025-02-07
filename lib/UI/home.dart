// ignore: library_prefixes
// import 'dart:ffi';
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterpad/UI/editor.dart';
import 'package:flutterpad/UI/tags.dart';
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
  final Set<int> _selectedNotes = {};
  bool _selectionMode = false;

  @override
  void initState() {
    super.initState();

    // _loadUserData();
  }

  // void _loadUserData() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     await Provider.of<UserDataProvider>(context, listen: false)
  //         .fetchUserData();
  //   });
  // }

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
          Visibility(
              visible: _selectionMode,
              child: Consumer<UserDataProvider>(
                  builder: (context, userDataProvider, child) {
                return IconButton(
                  icon: const Icon(Icons.select_all),
                  onPressed: () {
                    late final Set<int> displayedNoteIDs;
                    if (filteredNotes.isNotEmpty) {
                      displayedNoteIDs = filteredNotes.map((n) => n.id).toSet();
                    } else {
                      displayedNoteIDs = userDataProvider.userData.notes
                          .map((n) => n.id)
                          .toSet();
                    }
                    if (_selectedNotes.containsAll(displayedNoteIDs)) {
                      setState(() {
                        _selectedNotes.clear();
                      });
                    } else {
                      _selectedNotes.clear();
                      setState(() {
                        _selectedNotes.addAll(displayedNoteIDs);
                      });
                    }
                  },
                );
              })),
          Visibility(
              visible: _selectionMode,
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {},
              )),
          FutureBuilder(
              future: Provider.of<UserDataProvider>(context, listen: false)
                  .fetchUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                return Consumer<UserDataProvider>(
                  builder: (context, userDataProvider, child) {
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
                                    userDataProvider.userData.notes,
                                    userDataProvider.userData.tags));
                            if (res != null && res.isNotEmpty) {
                              setState(() {
                                filteredNotes = res;
                              });
                            }
                          },
                          icon: const Icon(Icons.search_rounded));
                    }
                  },
                );
              }),
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
            FutureBuilder(
                future: Provider.of<UserDataProvider>(context, listen: false)
                    .fetchUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                  return Expanded(child: Consumer<UserDataProvider>(
                    builder: (context, userdataProvider, child) {
                      final displayedNotes = filteredNotes.isEmpty
                          ? userdataProvider.userData.notes
                          : filteredNotes;
                      return ListView.builder(
                          itemCount: displayedNotes.length + 1,
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            // return Text('data#${i + 1}');
                            if (i != 0) {
                              return DecoratedBox(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: _selectedNotes.contains(
                                            userdataProvider
                                                .userData.notes[i - 1].id)
                                        ? ColorDict.noteCardColor
                                            .withOpacity(0.7)
                                        : Colors.transparent),
                                // : ColorDict.noteCardColor.withOpacity(0.7)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 4),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (!_selectionMode) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Editor(
                                                    displayedNotes[i - 1])));
                                      } else {
                                        _toggleSelection(
                                            displayedNotes[i - 1].id);
                                      }
                                    },
                                    onSecondaryTap: () {
                                      if (!kIsWeb) {
                                        if (io.Platform.isWindows) {
                                          if (!_selectionMode) {
                                            setState(() {
                                              _selectionMode = true;
                                              _selectedNotes.add(
                                                  displayedNotes[i - 1].id);
                                            });
                                          } else {
                                            _toggleSelection(
                                                displayedNotes[i - 1].id);
                                          }
                                        }
                                      }
                                    },
                                    onLongPress: () {
                                      setState(() {
                                        _selectionMode = true;
                                        _selectedNotes
                                            .add(displayedNotes[i - 1].id);
                                      });
                                    },
                                    child:
                                        NoteCard(note: displayedNotes[i - 1]),
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox(
                                height: 4,
                              );
                            }
                          });
                    },
                  ));
                })
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const TagScreen()));
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

  void _toggleSelection(int noteId) {
    setState(() {
      if (_selectedNotes.contains(noteId)) {
        _selectedNotes.remove(noteId);
        if (_selectedNotes.isEmpty) _selectionMode = false;
      } else {
        _selectedNotes.add(noteId);
      }
    });
  }

  @override
  void dispose() {
    // _searchController.dispose();
    super.dispose();
  }
}
