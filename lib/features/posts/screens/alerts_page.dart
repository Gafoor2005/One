import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:one/core/common/error_text.dart';
import 'package:one/core/common/loader.dart';
import 'package:one/core/models/post_model.dart';
import 'package:one/core/utils.dart';
import 'package:one/features/auth/controller/auth_controller.dart';
import 'package:one/features/posts/controller/post_controller.dart';
import 'package:routemaster/routemaster.dart';

class AlertsPage extends ConsumerWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 161, 141, 219),
      // backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ref.watch(userPostsProvider).when(
                  data: (data) {
                    return Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final post = data[index];
                          if (index == 0) {
                            return Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 5),
                                  child: Text(
                                    "Alerts",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                                CustomCard(post: post),
                              ],
                            );
                          }
                          if (index == data.length - 1) {
                            return Column(
                              children: [
                                CustomCard(post: post),
                                const SizedBox(
                                  height: 100,
                                ),
                              ],
                            );
                          }
                          return CustomCard(post: post);
                        },
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    return ErrorText(
                      error: error.toString(),
                    );
                  },
                  loading: () => const Loader(),
                ),
          ],
        ),
      ),
      floatingActionButton: ref.watch(userProvider)!.isAdmin
          ? IconButton(
              color: Theme.of(context).primaryColor,
              style: IconButton.styleFrom(
                elevation: 5,
                backgroundColor: Colors.white,
                shadowColor: Colors.black,
                fixedSize: const Size.square(55),
                padding: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onPressed: () {
                Routemaster.of(context).push('/create-post');
              },
              icon: const FaIcon(FontAwesomeIcons.penToSquare),
            )
          // ? ElevatedButton(
          //     onPressed: () {
          //       Routemaster.of(context).push('/create-post');
          //     },
          //     style: ElevatedButton.styleFrom(
          //       elevation: 5,
          //       shadowColor: Colors.black,
          //       fixedSize: const Size.square(65),
          //       padding: const EdgeInsets.all(0),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(50),
          //       ),
          //     ),
          //     child: const Center(
          //       child: FaIcon(FontAwesomeIcons.plus),
          //     ),
          //   )
          : null,
    );
  }
}

class CustomCard extends ConsumerStatefulWidget {
  final Post post;
  const CustomCard({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomCardState();
}

class _CustomCardState extends ConsumerState<CustomCard> {
  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  Duration difference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day, date.hour, date.minute)
        .difference(
            DateTime(now.year, now.month, now.day, now.hour, now.minute));
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final n = calculateDifference(widget.post.createdAt);
    return GestureDetector(
      onLongPressStart: ref.watch(userProvider)!.isAdmin
          ? (value) {
              if (currentIndex != 1) {
                HapticFeedback.vibrate();
                setState(() {
                  currentIndex = 1;
                });
              } else {
                setState(() {
                  currentIndex = 0;
                });
              }
            }
          : null,
      onTap: () {
        if (currentIndex == 0) {
          Routemaster.of(context).push('/post/${widget.post.id}');
        } else {
          setState(() {
            currentIndex = 0;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(seconds: 10),
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromRGBO(103, 65, 217, 1),
        ),
        child: IndexedStack(
          index: currentIndex,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (widget.post.title.length < 86)
                      ? widget.post.title
                      : '${widget.post.title.substring(0, 80)} ...',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                        height: 1.3,
                      ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  // widget.post.description,
                  // style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  //       color: Colors.grey.shade300,
                  //     ),
                  // maxLines: expanded ? null : 6,
                  // softWrap: expanded ? null : false,
                  // overflow: expanded ? null : TextOverflow.ellipsis,
                  (widget.post.description.length < 290)
                      ? widget.post.description
                      : '${widget.post.description.substring(0, 290)} ... Read more',
                  style: const TextStyle(
                      color: Color.fromARGB(219, 255, 255, 255)),
                ),
                const SizedBox(
                  height: 10,
                ),
                // const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.post.username}・',
                      style: const TextStyle(
                        color: Colors.white60,
                      ),
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          (n == 0)
                              ? (difference(widget.post.createdAt).inHours == 0)
                                  ? '${-difference(widget.post.createdAt).inMinutes}m'
                                  : '${-difference(widget.post.createdAt).inHours}h'
                              : (n > -30)
                                  ? '${-n}d'
                                  : DateFormat('MMMd')
                                      .format(widget.post.createdAt),
                          style: const TextStyle(
                            color: Colors.white60,
                          ),
                        ),
                        // const Text(" | "),
                        // Text(DateFormat('jm').format(widget.post.createdAt)),
                        // Text(post.createdAt.)
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Center(
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor:
                                    const Color.fromARGB(255, 234, 234, 234),
                                title: Text(
                                  "are you sure want to delete ?",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                content: Text(
                                  (widget.post.title.length < 86)
                                      ? '\' ${widget.post.title} \' '
                                      : '\' ${widget.post.title.substring(0, 80)} ... \'',
                                  style: const TextStyle(color: Colors.black),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      if (currentIndex == 1) {
                                        setState(() {
                                          currentIndex = 0;
                                        });
                                      }
                                      ref
                                          .watch(
                                              postControllerProvider.notifier)
                                          .deletPost(widget.post.id)
                                          .then(
                                        (value) {
                                          showSnackBar(context,
                                              'message deleted successfully');
                                        },
                                      );
                                      Routemaster.of(context).pop();
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    child: const Text('delete'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Navigator.of(context).pop();
                                      if (currentIndex == 1) {
                                        setState(() {
                                          currentIndex = 0;
                                        });
                                      }
                                      Routemaster.of(context).pop();
                                    },
                                    child: const Text('cancel'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text("Delete"),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
