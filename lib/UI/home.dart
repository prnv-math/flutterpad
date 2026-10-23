// ignore: library_prefixes
// import 'dart:ffi';
import 'dart:io' as io;
import 'dart:ui';
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
  final Set<String> _selectedTagFilters = {}; // State for tracking active tags
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
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
        centerTitle: false,
        title: _selectionMode
            ? Text('${_selectedNotes.length} Selected')
            : SizedBox(
                height: 42,
                child: TextField(
                  controller: _searchController,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: 'Search notes',
                    hintStyle: const TextStyle(
                        color: Colors.black87), // Greyed out hint text
                    // prefixIcon: const Icon(Icons.search,
                    //     color: Colors.black54, size: 20),
                    prefixIconConstraints:
                        const BoxConstraints(minWidth: 40, minHeight: 40),
                    suffixIcon: IconButton(
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 40, minHeight: 40),
                      style: IconButton.styleFrom(
                        // Matches your rectangular search bar border
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        minimumSize: const Size(40, 40),
                      ),
                      icon: Icon(
                        _searchController.text.isEmpty
                            ? Icons.search
                            : Icons.clear,
                        color: Colors.black54,
                        size: 20,
                      ),
                      onPressed: _searchController.text.isEmpty
                          ? null // Disabled when empty (no click action)
                          : () {
                              _searchController.clear();
                              setState(() {
                                filteredNotes.clear();
                                _selectedTagFilters.clear();
                              });
                              FocusScope.of(context).unfocus();
                            },
                    ),
                    suffixIconConstraints:
                        const BoxConstraints(minWidth: 40, minHeight: 40),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    filled: true,
                    fillColor: ColorDict.noteCardColor,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(4), // Rectangle border
                      borderSide:
                          const BorderSide(color: Colors.black26, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide:
                          const BorderSide(color: Colors.black26, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide:
                          const BorderSide(color: Colors.black26, width: 1.5),
                    ),
                  ),
                  onChanged: (query) {
                    setState(() {
                      if (query.isEmpty) {
                        filteredNotes.clear();
                      } else {
                        final userDataProvider = Provider.of<UserDataProvider>(
                            context,
                            listen: false);
                        filteredNotes = userDataProvider.userData.notes
                            .where((note) => note.title
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                            .toList();
                      }
                    });
                  },
                ),
              ),
        actions: [
          Visibility(
              visible: _selectionMode,
              child: Consumer<UserDataProvider>(
                  builder: (context, userDataProvider, child) {
                if (userDataProvider.userData.notes.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return IconButton(
                    icon: const Icon(Icons.select_all),
                    onPressed: () {
                      late final Set<int> displayedNoteIDs;
                      if (filteredNotes.isNotEmpty) {
                        displayedNoteIDs =
                            filteredNotes.map((n) => n.id).toSet();
                      } else {
                        displayedNoteIDs = userDataProvider.userData.notes
                            .map((n) => n.id)
                            .toSet();
                      }
                      if (_selectedNotes.containsAll(displayedNoteIDs)) {
                        setState(() => _selectedNotes.clear());
                      } else {
                        _selectedNotes.clear();
                        setState(() => _selectedNotes.addAll(displayedNoteIDs));
                      }
                    },
                  );
                }
              })),
          Visibility(
              visible: _selectionMode,
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // TODO: Implement bulk delete using _selectedNotes
                },
              )),
          if (!_selectionMode)
            Consumer<UserDataProvider>(
              builder: (context, userDataProvider, child) {
                return MenuAnchor(
                  style: MenuStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  builder: (BuildContext context, MenuController controller,
                      Widget? child) {
                    return IconButton(
                      icon: const Icon(Icons.label_outline),
                      tooltip: 'Filter by Tag',
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                    );
                  },
                  menuChildren: userDataProvider.userData.tags.isEmpty
                      ? [
                          const MenuItemButton(
                            child: Text('No tags available'),
                          )
                        ]
                      : userDataProvider.userData.tags.map((tag) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              checkboxTheme: CheckboxThemeData(
                                fillColor:
                                    WidgetStateProperty.resolveWith((states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return ColorDict.noteCardColor;
                                  }
                                  return null;
                                }),
                              ),
                            ),
                            child: CheckboxMenuButton(
                              value: _selectedTagFilters.contains(tag.name),
                              closeOnActivate:
                                  false, // Keeps menu open for multi-select
                              onChanged: (bool? checked) {
                                setState(() {
                                  if (checked == true) {
                                    _selectedTagFilters.add(tag.name);
                                  } else {
                                    _selectedTagFilters.remove(tag.name);
                                  }

                                  if (_selectedTagFilters.isEmpty) {
                                    filteredNotes.clear();
                                  } else {
                                    filteredNotes = userDataProvider
                                        .userData.notes
                                        .where((note) {
                                      final noteTagNames = note
                                          .getTags(
                                              userDataProvider.userData.tags)
                                          .map((t) => t.name)
                                          .toSet();
                                      return noteTagNames
                                          .containsAll(_selectedTagFilters);
                                    }).toList();
                                  }
                                });
                              },
                              child: Text(tag.name),
                            ),
                          );
                        }).toList(),
                );
              },
            ),
          if (!_selectionMode)
            Consumer<UserDataProvider>(
              builder: (context, userDataProvider, child) {
                return PopupMenuButton<String>(
                  color: Colors.white,
                  icon: const Icon(Icons.sort),
                  tooltip: 'Sort Notes',
                  offset: const Offset(0, 12),
                  position: PopupMenuPosition.under,
                  onSelected: (String sortMethod) {
                    setState(() {
                      final bool isFilterActive = filteredNotes.isNotEmpty ||
                          _selectedTagFilters.isNotEmpty ||
                          _searchController.text.isNotEmpty;
                      List<Note> listToSort = isFilterActive
                          ? filteredNotes
                          : userDataProvider.userData.notes;

                      if (sortMethod == 'az') {
                        listToSort.sort((a, b) => a.title
                            .toLowerCase()
                            .compareTo(b.title.toLowerCase()));
                      } else if (sortMethod == 'za') {
                        listToSort.sort((a, b) => b.title
                            .toLowerCase()
                            .compareTo(a.title.toLowerCase()));
                      }

                      if (!isFilterActive) {
                        filteredNotes = List.from(listToSort);
                      }
                    });
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'az',
                      child: Text('Name (A-Z)'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'za',
                      child: Text('Name (Z-A)'),
                    ),
                  ],
                );
              },
            ),
          if (!_selectionMode)
            IconButton(onPressed: () {}, icon: const Icon(Icons.info_rounded))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: <Widget>[
            Expanded(child: Consumer<UserDataProvider>(
              builder: (context, userdataProvider, child) {
                final bool isFilterActive = filteredNotes.isNotEmpty ||
                    _selectedTagFilters.isNotEmpty ||
                    _searchController.text.isNotEmpty;

                final displayedNotes = isFilterActive
                    ? filteredNotes
                    : userdataProvider.userData.notes;

                if (displayedNotes.isEmpty) {
                  return const Center(
                    child: Text(
                      "No notes found",
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                    itemCount: displayedNotes.length + 1,
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      if (i != 0) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: _selectedNotes.contains(
                                      userdataProvider.userData.notes[i - 1].id)
                                  ? ColorDict.noteCardColor
                                      .withAlpha((0.7 * 255).toInt())
                                  : Colors.transparent),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 4),
                            child: GestureDetector(
                              onTap: () {
                                if (!_selectionMode) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Editor(displayedNotes[i - 1])));
                                } else {
                                  _toggleSelection(displayedNotes[i - 1].id);
                                }
                              },
                              onSecondaryTap: () {
                                if (!kIsWeb) {
                                  if (io.Platform.isWindows) {
                                    if (!_selectionMode) {
                                      setState(() {
                                        _selectionMode = true;
                                        _selectedNotes
                                            .add(displayedNotes[i - 1].id);
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
                                  _selectedNotes.add(displayedNotes[i - 1].id);
                                });
                              },
                              child: NoteCard(note: displayedNotes[i - 1]),
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
              color: ColorDict.noteCardborder.withAlpha((0.8 * 255).toInt()),
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
    _searchController.dispose();
    super.dispose();
  }
}
