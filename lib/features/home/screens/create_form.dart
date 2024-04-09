import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/core/common/loader.dart';
import 'package:one/core/models/elective_form_model.dart';
import 'package:one/core/models/elective_model.dart';
import 'package:one/core/models/regulation_model.dart';
import 'package:one/features/home/screens/forms_controller.dart';

class CreateFormPage extends ConsumerStatefulWidget {
  const CreateFormPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateFormPageState();
}

class _CreateFormPageState extends ConsumerState<CreateFormPage> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController regulationController;
  late TextEditingController batchController;
  late TextEditingController electiveController;

  Regulation? selectedRegulatin;
  Elective? selectedElective;
  int? selectedBatch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    regulationController = TextEditingController();
    batchController = TextEditingController();
    electiveController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
    regulationController.dispose();
    batchController.dispose();
    electiveController.dispose();
    selectedBatch = null;
    selectedElective = null;
    selectedRegulatin = null;
  }

  void createForm() async {
    await ref.watch(formsControllerProvider.notifier).addForm(
          context: context,
          form: ElectiveForm(
            //  "22-R20-OE1", id format
            id: "$selectedBatch-${selectedRegulatin!.id}-${selectedElective!.id}",
            name: nameController.text,
            description: descriptionController.text,
            regulationId: selectedRegulatin!.id,
            electiveId: selectedElective!.id,
            batch: selectedBatch!,
          ),
        );
    nameController.clear();
    descriptionController.clear();
    batchController.clear();
    electiveController.clear();
    regulationController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("create form"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: ref.watch(regulationProvider).when(
                data: (regulations) => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Name",
                        hintText: "example: OE1 registraion form",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                      ),
                      controller: nameController,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Description",
                        hintText:
                            "you can provide any description about this open elective form",
                        hintStyle: TextStyle(color: Colors.black26),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                      ),
                      controller: descriptionController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 4,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Regulation",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                "select the regulation for which you are creating this form",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        DropdownMenu<Regulation>(
                          width: 130,
                          controller: regulationController,
                          label: const Text(
                            'select',
                          ),
                          onSelected: (Regulation? regulation) {
                            setState(() {
                              selectedRegulatin = regulation;
                              batchController.clear();
                              electiveController.clear();
                            });
                          },
                          dropdownMenuEntries: regulations
                              .map<DropdownMenuEntry<Regulation>>(
                                  (Regulation regulation) {
                            return DropdownMenuEntry<Regulation>(
                              value: regulation,
                              label: regulation.name,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Year (Batch)",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                "select a Batch for which you are creating this form",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        DropdownMenu<int>(
                          enabled: regulationController.value.text.isNotEmpty,
                          width: 160,
                          controller: batchController,
                          label: const Text(
                            'select',
                          ),
                          onSelected: (int? batch) {
                            setState(() {
                              selectedBatch = batch;
                            });
                          },
                          dropdownMenuEntries: (selectedRegulatin != null)
                              ? [
                                  for (var i = selectedRegulatin!.startYear;
                                      i <
                                          selectedRegulatin!.startYear +
                                              selectedRegulatin!.lifeSpan;
                                      i++)
                                    DropdownMenuEntry(
                                        value: i, label: "$i - ${i + 4}")
                                ]
                              : [],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pick an elective",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                "select a elective for which you are creating this form",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        (selectedRegulatin == null)
                            ? DropdownMenu<Elective>(
                                enabled:
                                    regulationController.value.text.isNotEmpty,
                                width: 160,
                                label: const Text(
                                  'select',
                                ),
                                dropdownMenuEntries: const [],
                              )
                            : ref
                                .watch(electivesProvider(selectedRegulatin!.id))
                                .when(
                                  data: (electives) => DropdownMenu<Elective>(
                                    enabled: regulationController
                                        .value.text.isNotEmpty,
                                    width: 160,
                                    controller: electiveController,
                                    label: const Text(
                                      'select',
                                    ),
                                    onSelected: (Elective? elective) {
                                      setState(() {
                                        selectedElective = elective;
                                      });
                                    },
                                    dropdownMenuEntries: electives
                                        .map<DropdownMenuEntry<Elective>>(
                                          (elective) => DropdownMenuEntry(
                                            value: elective,
                                            label: elective.name,
                                          ),
                                        )
                                        .toList(),
                                  ),
                                  error: (error, stackTrace) =>
                                      Text(error.toString()),
                                  loading: () => const Loader(),
                                ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: (nameController.text.isNotEmpty &&
                                  descriptionController.text.isNotEmpty &&
                                  regulationController.text.isNotEmpty &&
                                  batchController.text.isNotEmpty &&
                                  electiveController.text.isNotEmpty &&
                                  (selectedRegulatin != null) &&
                                  (selectedElective != null))
                              ? () {
                                  createForm();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                          ),
                          child: const Text("create"),
                        ),
                      ],
                    ),
                  ],
                ),
                error: (error, stackTrace) => Text(error.toString()),
                loading: () => const Loader(),
              ),
        ),
      ),
    );
  }
}
