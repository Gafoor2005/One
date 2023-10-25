import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:one/core/common/error_text.dart';
import 'package:one/core/common/loader.dart';
import 'package:one/core/common/user_tile.dart';
import 'package:one/core/models/post_model.dart';
import 'package:one/features/auth/controller/auth_controller.dart';
import 'package:one/features/posts/controller/post_controller.dart';

class PostDetails extends ConsumerStatefulWidget {
  final String id;
  const PostDetails({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostDetailsState();
}

class _PostDetailsState extends ConsumerState<PostDetails> {
  Post? post;

  bool initDone = false;
  void getPostData() async {
    if (post == null) {
      post = await ref
          .watch(postControllerProvider.notifier)
          .getPost(widget.id)
          .first;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (initDone == false) {
      initDone = true;
      getPostData();
    }
    return Scaffold(
        backgroundColor: Colors.white.withAlpha(245),
        appBar: AppBar(
          elevation: 10,
        ),
        body: post == null
            ? const Loader()
            : SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: ref
                                    .watch(getUserDataProvider(post!.uid))
                                    .when(
                                      data: (data) => UserTile(user: data),
                                      error: (error, stackTrace) =>
                                          ErrorText(error: error.toString()),
                                      loading: () => const Loader(),
                                    ),
                              ),
                            ),
                            Text(DateFormat('yMMMd').format(post!.createdAt)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          post!.title,
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          post!.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ));
  }
}
