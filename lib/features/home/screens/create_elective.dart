import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/core/models/elective_model.dart';
import 'package:one/features/home/screens/forms_controller.dart';
import 'package:routemaster/routemaster.dart';

class CreateElectivePage extends ConsumerStatefulWidget {
  final String regulaitonId;
  const CreateElectivePage({
    super.key,
    required this.regulaitonId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateElectivePageState();
}

class _CreateElectivePageState extends ConsumerState<CreateElectivePage> {
  late TextEditingController name;
  late TextEditingController typeController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = TextEditingController();
    typeController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    name.dispose();
    typeController.dispose();
  }

  void addElective() async {
    await ref.watch(formsControllerProvider.notifier).addElective(
          context: context,
          regulationId: widget.regulaitonId,
          name: name.text,
          type: electiveTypeFromString(typeController.value.text)!,
        );
    name.clear();
    typeController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create elective"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "enter name",
                  hintText: "example: OE 1 , PE 1",
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
              DropdownMenu<ElectiveType>(
                initialSelection: ElectiveType.openElective,
                expandedInsets: const EdgeInsets.all(0),
                controller: typeController,
                // requestFocusOnTap is enabled/disabled by platforms when it is null.
                // On mobile platforms, this is false by default. Setting this to true will
                // trigger focus request on the text field and virtual keyboard will appear
                // afterward. On desktop platforms however, this defaults to true.
                // requestFocusOnTap: true,
                label: const Text('elective type'),
                onSelected: (ElectiveType? type) {
                  setState(() {});
                },
                dropdownMenuEntries: ElectiveType.values
                    .map<DropdownMenuEntry<ElectiveType>>((ElectiveType type) {
                  return DropdownMenuEntry<ElectiveType>(
                    value: type,
                    label: type.name,
                    // enabled: true,
                    // style: MenuItemButton.styleFrom(
                    //   foregroundColor: color.color,
                    // ),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: (name.text.isNotEmpty &&
                        typeController.value.text.isNotEmpty)
                    ? () {
                        addElective();
                      }
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
