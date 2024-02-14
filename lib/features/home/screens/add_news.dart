import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/features/home/screens/news_controller.dart';

class AddNews extends ConsumerStatefulWidget {
  const AddNews({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddNewsState();
}

class _AddNewsState extends ConsumerState<AddNews> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Text(
                "add news",
                style: TextStyle(
                  fontFamily: "AlegreyaSans",
                  fontSize: 24,
                ),
              ),
              Row(
                children: [
                  Text(
                    "enter title",
                    style: TextStyle(
                      fontFamily: "AlegreyaSans",
                    ),
                  ),
                ],
              ),
              TextField(
                style: const TextStyle(
                  fontFamily: 'AlegreyaSans',
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  height: 1,
                ),
                controller: _titleController,
                decoration: InputDecoration(
                    hintText: "enter title", border: OutlineInputBorder()),
              ),
              Row(
                children: [
                  Text(
                    "enter description",
                    style: TextStyle(
                      fontFamily: "AlegreyaSans",
                    ),
                  ),
                ],
              ),
              TextField(
                style: const TextStyle(
                  fontFamily: 'NotoSans',
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  height: 1.4,
                ),
                keyboardType: TextInputType.multiline,
                minLines: 1, //Normal textInputField will be displayed
                maxLines: 8,
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: "enter description",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      )),
      floatingActionButton: TextButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer),
        onPressed: () {
          ref.watch(newsControllerProvider.notifier).addNews(
                context: context,
                title: _titleController.text,
                description: _descriptionController.text,
              );
        },
        child: Text('submit'),
      ),
    );
  }
}
