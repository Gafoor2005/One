import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/features/home/screens/forms_controller.dart';

class CreateRegulation extends ConsumerStatefulWidget {
  const CreateRegulation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateRegulationState();
}

class _CreateRegulationState extends ConsumerState<CreateRegulation> {
  late TextEditingController name;
  late TextEditingController year;
  void add() async {
    await ref.watch(formsControllerProvider.notifier).addRegulation(
        context: context, name: name.text, startYear: int.parse(year.text));

    name.clear();
    year.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = TextEditingController();
    year = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    name.dispose();
    year.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("create regulation"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "enter name",
                  hintText: "example: R20",
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.only(
                      left: 15, bottom: 11, top: 11, right: 15),
                  helperText: (name.text.isEmpty)
                      ? null
                      : "regulaion ID:  ${name.text.trim().replaceAll(' ', "")}",
                  helperStyle: Theme.of(context).textTheme.labelMedium,
                ),
                controller: name,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "enter start year",
                  hintText: "example: 2023",
                  border: OutlineInputBorder(),
                ),
                controller: year,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: (name.text.isNotEmpty && year.text.isNotEmpty)
                    ? () => add()
                    : null,
                child: const Text("create"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
