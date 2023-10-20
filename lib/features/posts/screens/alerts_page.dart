import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:one/core/common/error_text.dart';
import 'package:one/core/common/loader.dart';
import 'package:one/core/models/post_model.dart';
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
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Routemaster.of(context).push('/create-post');
        },
        style: ElevatedButton.styleFrom(
          elevation: 5,
          shadowColor: Colors.black,
          fixedSize: const Size.square(50),
          padding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Center(
          child: FaIcon(FontAwesomeIcons.feather),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final Post post;
  const CustomCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            post.description,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(post.username),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(DateFormat('MMMd').format(post.createdAt)),
                  const Text(" | "),
                  Text(DateFormat('jm').format(post.createdAt)),
                  // Text(post.createdAt.)
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
