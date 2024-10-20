import 'package:flutter/material.dart';
import 'package:flutterpad/models/note.dart';
import 'package:flutterpad/models/tag.dart';
import 'package:flutterpad/utils/dictionary.dart';

class TagPadSearchDelegate extends SearchDelegate {
  final List<Note> allNotes;
  final List<Tag> allTags;
  List<String> filterCriteria = [];

  TagPadSearchDelegate(this.allNotes, this.allTags);

  // @override
  // PreferredSizeWidget buildBottom(BuildContext context) {
  //   return const PreferredSize(
  //       preferredSize: Size.fromHeight(56.0), child: Text('bottom'));
  // }

  @override
  List<Widget>? buildActions(BuildContext context) {
    int tagCount = filterCriteria.length;

    return [
      if (tagCount > 0)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Chip(
            label: Text('$tagCount'),
            labelStyle: const TextStyle(color: ColorDict.noteCardborder),
            backgroundColor: ColorDict.noteCardColor,
            shape: const StadiumBorder(
                side: BorderSide(
              color: ColorDict.noteCardborder,
              // style: BorderStyle.none
            )), // This makes the Chip circular
          ),
        ),
      IconButton(
          onPressed: () {
            query = '';
            filterCriteria.clear();
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Note> matchedNotes = allNotes.where((note) {
      bool matchesCriteria = filterCriteria.isEmpty ||
          filterCriteria.any((criteria) =>
              note.getTags().any((tag) => tag.name.contains(criteria)));

      bool matchesQuery =
          note.title.contains(query) || note.content.contains(query);

      return matchesCriteria && matchesQuery;
    }).toList();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      close(context, matchedNotes);
    });

    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> noteSuggestions = allNotes
        .where((note) =>
            note.title.toLowerCase().contains(query.toLowerCase()) &&
            filterCriteria.every(
                (c) => note.getTags().map((t) => t.name).toList().contains(c)))
        .map((note) => note.title)
        .toList();
    final List<String> tagSuggestions = allTags
        .where((tag) => tag.name.toLowerCase().contains(query.toLowerCase()))
        .map((tag) => tag.name)
        .toList();
    final List<String> moreSuggestions = allNotes
        .where((n) =>
            n.title.toLowerCase().contains(query.toLowerCase()) &&
            (filterCriteria.length == 1 ||
                filterCriteria.any((c) =>
                    n.getTags().map((t) => t.name).toList().contains(c))))
        .map((n) => n.title)
        .where((title) => !noteSuggestions.contains(title))
        .toList();
    if (query.isNotEmpty) {
      return ListView(
        // physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(4),
        children: [
          // Show Note name suggestions
          if (noteSuggestions.isNotEmpty)
            const Padding(
                padding: EdgeInsets.all(6.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 22,
                      color: Colors.black45,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Notes",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                    ),
                  ],
                )),
          ...noteSuggestions.map((noteName) {
            return ListTile(
              leading: const Icon(
                Icons.note,
                size: 22,
              ),
              title: Text(noteName),
              onTap: () {
                query = noteName;
                showResults(context);
              },
            );
          }).toList(),
          const SizedBox(
            height: 8,
          ),
          // Show Tag name suggestions
          if (tagSuggestions.isNotEmpty)
            const Padding(
                padding: EdgeInsets.all(6.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 22,
                      color: Colors.black45,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Tags",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                    ),
                  ],
                )),
          ...tagSuggestions.map((tagName) {
            return ListTile(
              leading: filterCriteria.contains(tagName)
                  ? const Icon(Icons.done)
                  : const Icon(Icons.view_sidebar_rounded),
              title: Text(tagName),
              onTap: () {
                // Add the tag to filter criteria and clear the query
                if (!filterCriteria.contains(tagName)) {
                  filterCriteria.add(tagName);
                  query = ''; // Clear the query
                  showSuggestions(context);
                }
                // Show updated suggestions
              },
            );
          }).toList(),
          const SizedBox(
            height: 8,
          ),
          // Show more note suggestions
          if (moreSuggestions.isNotEmpty)
            const Padding(
                padding: EdgeInsets.all(6.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.troubleshoot_rounded,
                      size: 22,
                      color: Colors.black38,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Similar",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54),
                    ),
                  ],
                )),
          ...moreSuggestions.map((noteName) {
            return ListTile(
              leading: const Icon(
                Icons.note,
                color: Colors.black54,
              ),
              title: Text(
                noteName,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
              onTap: () {
                filterCriteria.clear();
                query = noteName;
                showResults(context);
              },
            );
          }).toList(),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
