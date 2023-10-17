import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final InputBorder myInputBorder = UnderlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: const BorderSide(
      style: BorderStyle.none,
      color: Colors.white70,
      width: 2,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      "Post",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      // height: (constraints.maxHeight * .8),
                      child: TextField(
                        // scrollPadding: EdgeInsets.all(30),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.white,
                            ),
                        maxLines: 4,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: "enter title here",
                          hintStyle: TextStyle(color: Colors.white30),
                          fillColor: Color.fromRGBO(103, 65, 217, 1),
                          focusColor: Colors.white,
                          filled: true,
                          focusedBorder: myInputBorder,
                          enabledBorder: myInputBorder.copyWith(),
                          border: myInputBorder.copyWith(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      // height: (constraints.maxHeight - 50) * .8,
                      child: TextField(
                        // scrollPadding: EdgeInsets.all(30),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.white,
                            ),
                        maxLines: 8,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: "enter sub title here",
                          hintStyle: TextStyle(color: Colors.white30),
                          fillColor: Color.fromRGBO(103, 65, 217, 1),
                          focusColor: Colors.white,
                          filled: true,
                          focusedBorder: myInputBorder,
                          enabledBorder: myInputBorder.copyWith(),
                          border: myInputBorder.copyWith(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {},
        child: FaIcon(FontAwesomeIcons.arrowRight),
        style: ElevatedButton.styleFrom(
          minimumSize: Size.square(50),
          alignment: Alignment.center,
          padding: EdgeInsets.all(0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
