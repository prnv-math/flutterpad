import 'package:flutter/material.dart';
import 'package:flutterpad/UI/home.dart';
import 'package:flutterpad/models/tag.dart';
import 'package:flutterpad/services/userdataprovider.dart';
import 'package:flutterpad/utils/dictionary.dart';
import 'package:provider/provider.dart';

class TagScreen extends StatefulWidget {
  const TagScreen({super.key});

  @override
  State<TagScreen> createState() => _TagScreenState();
}

class _TagScreenState extends State<TagScreen> {
  late final TextEditingController _tagNameEditController;
  late final TextEditingController _tagCreateController;
  Tag? editingTag;

  @override
  void initState() {
    _tagNameEditController = TextEditingController();
    _tagCreateController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context).userData;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          backgroundColor: ColorDict.noteCardColor,
          title: const Center(
            child: Text("Tags",
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 16)),
          ),
          actions: const [
            // IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
            // const SizedBox(
            //   width: 6,
            // ),
            // IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
            // const SizedBox(
            //   width: 4,
            // )

            // Expanded(
            //   child: SizedBox(
            //     // width: double.maxFinite,
            //     child: Center(
            //       child: Text("Tags",
            //           style: TextStyle(
            //               color: Colors.black87,
            //               fontWeight: FontWeight.w600,
            //               fontSize: 16)),
            //     ),
            //   ),
            // )
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return Home();
                },
              ));
            },
            icon: const Icon(Icons.arrow_back),
          )),
      backgroundColor: ColorDict.bgColor,
      body: Container(
        // constraints: BoxConstraints(minHeight: 120),
        // height: double.infinity,
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: ColorDict.noteCardColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: _tagCreateController,
              style: const TextStyle(
                fontFamily: 'monospace',
              ),
              decoration: InputDecoration(
                suffixIcon: editingTag != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: IconButton(
                          icon: const Icon(Icons.save),
                          onPressed: () {},
                          color: ColorDict.bgColor,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                              splashColor: ColorDict.noteCardborder,
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                // print("hi");
                              },
                              child: const Icon(
                                Icons.add,
                                color: ColorDict.bgColor,
                              )),
                        ),
                      ),
                label: Text(
                  editingTag != null
                      ? "Edit \"${editingTag!.name}\""
                      : "Create Tag",
                  style: const TextStyle(
                      //
                      // fontWeight: FontWeight.w500,
                      color: Colors.black87
                      //
                      ),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: ColorDict.noteCardborder),
                  borderRadius: BorderRadius.circular(10),
                ),
                // focusColor: ColorDict.noteCardborder,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: ColorDict.noteCardborder),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: ColorDict.noteCardborder),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (_) {},
            ),

            // const SizedBox(
            //   height: 12,
            // ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: TextField(
            //         enabled: editingTag != null,
            //         textCapitalization: TextCapitalization.words,
            //         controller: _tagNameEditController,
            //         style: const TextStyle(
            //           fontFamily: 'monospace',
            //         ),
            //         decoration: InputDecoration(
            //           suffixIcon: Padding(
            //             padding: const EdgeInsets.only(right: 6.0),
            //             child: IconButton(
            //               icon: const Icon(Icons.save),
            //               color: editingTag == null
            //                   ? Colors.black54
            //                   : ColorDict.bgColor,
            //               onPressed: () {},
            //             ),
            //           ),
            //           label: Text(
            //             editingTag == null
            //                 ? "Edit below Tags"
            //                 : "Edit \"${editingTag!.name}\"",
            //             style: TextStyle(
            //                 //
            //                 // fontWeight: FontWeight.w500,
            //                 color: Colors.black87
            //                 //
            //                 ),
            //           ),
            //           border: OutlineInputBorder(
            //             borderSide:
            //                 const BorderSide(color: ColorDict.noteCardborder),
            //             borderRadius: BorderRadius.circular(10),
            //           ),
            //           // focusColor: ColorDict.noteCardborder,
            //           focusedBorder: OutlineInputBorder(
            //             borderSide:
            //                 const BorderSide(color: ColorDict.noteCardborder),
            //             borderRadius: BorderRadius.circular(10),
            //           ),
            //           enabledBorder: OutlineInputBorder(
            //             borderSide:
            //                 const BorderSide(color: ColorDict.noteCardborder),
            //             borderRadius: BorderRadius.circular(10),
            //           ),
            //         ),
            //         onChanged: (_) {},
            //       ),
            //     ),
            //     const SizedBox(
            //       width: 6,
            //     ),
            //     IconButton(
            //         onPressed: editingTag == null ? null : () {},
            //         icon: Icon(
            //           Icons.delete,
            //           color: editingTag == null
            //               ? Colors.black54
            //               : ColorDict.bgColor,
            //         )),
            //     // const SizedBox(
            //     //   width: 6,
            //     // ),
            //     // IconButton(
            //     //     onPressed: editingTag == null ? null : () {},
            //     //     icon: Icon(
            //     //       Icons.close,
            //     //       color: editingTag == null
            //     //           ? Colors.black54
            //     //           : ColorDict.bgColor,
            //     //     ))
            //   ],
            // ),
            const SizedBox(
              height: 12,
            ),
            // Row(
            //   children: [
            //     ElevatedButton(
            //         onPressed: () {},
            //         child: const Text(
            //           "Search",
            //           style: TextStyle(color: ColorDict.bgColor),
            //         )),
            //     const SizedBox(
            //       width: 12,
            //     ),
            //     ElevatedButton(
            //         // style: ButtonStyle(
            //         //     backgroundColor: MaterialStatePropertyAll(
            //         //         Colors.white.withOpacity(0.985))),
            //         onPressed: () {},
            //         child: const Text(
            //           "Create",
            //           style: TextStyle(color: ColorDict.bgColor),
            //         )),
            //   ],
            // )

            Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 8,
              // spacing: 4,
              children: () {
                final List<Widget> tagBtns = [];
                if (userData != null) {
                  final tags = userData.tags;
                  for (var tag in tags) {
                    tagBtns.add(Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: editingTag == tag
                            ? ColorDict.bgColor.withOpacity(0.7)
                            : Colors.transparent,
                      ),
                      child: TextButton(
                          onPressed: () {
                            if (editingTag == tag) {
                              setState(() {
                                editingTag = null;
                              });
                            } else {
                              setState(() {
                                editingTag = tag;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(12, 40),
                              backgroundColor: ColorDict.bgColor,
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: ColorDict.noteCardborder),
                                  borderRadius: BorderRadius.circular(16))),
                          child: Text(
                            tag.name,
                            style: const TextStyle(
                                color: ColorDict.noteCardColor, fontSize: 12),
                          )),
                    ));
                  }
                  return tagBtns;
                  // return [Text("data")];
                } else {
                  return [const CircularProgressIndicator()];
                }
              }(),
            ),
            Expanded(
                child: SizedBox(
              width: 1,
            )),
            Visibility(
              visible: editingTag != null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        editingTag = null;
                      });
                    },
                    color: ColorDict.bgColor,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  // IconButton(
                  //   icon: const Icon(Icons.edit_note),
                  //   onPressed: () {
                  //     setState(() {
                  //       editingTag = null;
                  //     });
                  //   },
                  //   color: ColorDict.bgColor,
                  // ),
                  // SizedBox(
                  //   width: 6,
                  // ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        editingTag = null;
                      });
                    },
                    color: ColorDict.bgColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
