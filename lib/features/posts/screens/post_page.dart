import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one/core/utils.dart';
import 'package:one/features/posts/controller/post_controller.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  final InputBorder myInputBorder = UnderlineInputBorder(
    borderRadius: BorderRadius.circular(0),
    borderSide: const BorderSide(
      style: BorderStyle.none,
      color: Colors.white70,
      width: 2,
    ),
  );

  void addPost() {
    if ((titleController.text != '') && (descriptionController.text != '')) {
      ref.read(postControllerProvider.notifier).shareTextPost(
            context: context,
            title: titleController.text.trim(),
            description: descriptionController.text.trim(),
          );
    } else {
      showSnackBar(context, "fill the fields");
    }
  }

  int inputIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
        backgroundColor: Colors.blue.shade500,
      ),
      backgroundColor: const Color.fromARGB(255, 161, 141, 219),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  //   child: Text(
                  //     "Post",
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.w600,
                  //       fontSize: 25,
                  //     ),
                  //   ),
                  // ),
                  IndexedStack(
                    index: inputIndex,
                    children: [
                      SizedBox(
                        height: (constraints.maxHeight),
                        child: TextField(
                          // autofocus: true,
                          controller: titleController,
                          scrollPadding: const EdgeInsets.all(30),
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Colors.white,
                                  ),
                          maxLines: 50,

                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            hintText: "Enter Title",
                            hintStyle: const TextStyle(color: Colors.white30),
                            fillColor: const Color.fromRGBO(103, 65, 217, 1),
                            focusColor: Colors.white,
                            filled: true,
                            focusedBorder: myInputBorder,
                            enabledBorder: myInputBorder.copyWith(),
                            border: myInputBorder.copyWith(),
                            contentPadding: const EdgeInsets.only(
                              right: 20,
                              left: 20,
                              top: 20,
                              bottom: 0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: (constraints.maxHeight),
                        child: TextField(
                          controller: descriptionController,
                          // scrollPadding: EdgeInsets.all(30),
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Colors.white,
                                  ),
                          maxLines: 50,
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            hintText: "enter sub title here",
                            hintStyle: const TextStyle(color: Colors.white30),
                            fillColor: const Color.fromRGBO(103, 65, 217, 1),
                            focusColor: Colors.white,
                            filled: true,
                            focusedBorder: myInputBorder,
                            enabledBorder: myInputBorder.copyWith(),
                            border: myInputBorder.copyWith(),
                            contentPadding: const EdgeInsets.only(
                              right: 20,
                              left: 20,
                              top: 20,
                              bottom: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          inputIndex != 0
              ? ElevatedButton(
                  onPressed: () {
                    setState(() {
                      inputIndex--;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.square(50),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const FaIcon(FontAwesomeIcons.arrowLeft),
                )
              : const SizedBox(),
          const SizedBox(
            width: 10,
          ),
          ElevatedButton(
            onPressed: () {
              if (inputIndex < 1) {
                setState(() {
                  inputIndex++;
                });
              } else {
                addPost();
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.square(50),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const FaIcon(FontAwesomeIcons.arrowRight),
          ),
        ],
      ),
    );
  }
}
