// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/core/models/department_model.dart';
import 'package:one/core/models/elective_subject_model.dart';
import 'package:one/features/home/screens/forms_controller.dart';

class CreateSubjectPage extends ConsumerStatefulWidget {
  final String regulationId;
  final String electiveId;
  const CreateSubjectPage({
    super.key,
    required this.regulationId,
    required this.electiveId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateSubjectPageState();
}

final notForProvider = StateProvider<List<Department>>((ref) {
  return [Department.aiml, Department.ce];
});

class _CreateSubjectPageState extends ConsumerState<CreateSubjectPage> {
  late TextEditingController idController;
  late TextEditingController limitController;
  late TextEditingController nameController;
  late TextEditingController offeredByController;
  List<Department> notFor = [Department.cse, Department.aiml];

  RegExp get _courseId => RegExp(r'^[A-Z]{2}\d{4}$');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idController = TextEditingController();
    limitController = TextEditingController();
    nameController = TextEditingController();
    offeredByController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    limitController.dispose();
    idController.dispose();
    nameController.dispose();
    offeredByController.dispose();
  }

  void addSubject() async {
    // log(offeredByController.value.toString());
    await ref.watch(formsControllerProvider.notifier).addSubject(
          context: context,
          regulationId: widget.regulationId,
          electiveId: widget.electiveId,
          subject: ElectiveSubject(
            id: idController.text,
            name: nameController.text,
            offeredBy:
                departmentFromString(offeredByController.text.toLowerCase())!,
            notFor: notFor,
            limit: int.parse(limitController.text),
          ),
        );
    idController.clear();
    nameController.clear();
    offeredByController.clear();
    limitController.clear();
    notFor = [];
    setState(() {});
  }

  String? validatePassword(String value) {
    if (!_courseId.hasMatch(value) && value.isNotEmpty) {
      return "invlaid";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        // titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("add subject", style: Theme.of(context).textTheme.titleMedium),
            Text("${widget.regulationId}/${widget.electiveId}",
                style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Course ID",
                  hintText: "example: CS3504",
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.only(
                      left: 15, bottom: 11, top: 11, right: 15),
                  errorText: validatePassword(idController.text),
                ),
                controller: idController,
                // inputFormatters: [
                //   FilteringTextInputFormatter.allow(RegExp(r'^[A-Z]{2}\d{4}$')),
                // ],
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: "Course name",
                  hintText: "enter name of the subject",
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
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
                  labelText: "Course limit",
                  hintText: "how many people can apply?",
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                ),
                controller: limitController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Offered by",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          "select the departments which is offering this subject",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  DropdownMenu<Department>(
                    width: 130,
                    controller: offeredByController,
                    label: const Text(
                      'select',
                    ),
                    onSelected: (Department? type) {
                      setState(() {});
                    },
                    dropdownMenuEntries: Department.values
                        .map<DropdownMenuEntry<Department>>((Department type) {
                      return DropdownMenuEntry<Department>(
                        value: type,
                        label: type.name.toUpperCase(),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Not For",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          "select the departments which are not elegible to take this subject",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton.filled(
                    onPressed: () {
                      showModalBottomSheet(
                        elevation: 10,
                        context: context,
                        builder: (context) => StatefulBuilder(
                          builder: (context, setBottomState) => Container(
                            height: 300,
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Select not for",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                Center(
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    alignment: WrapAlignment.center,
                                    spacing: 2,
                                    children: [
                                      for (var e in Department.values)
                                        ChoiceChip(
                                          label: Text(e.name.toUpperCase()),
                                          selected: notFor.contains(e),
                                          selectedColor: Colors.blue.shade100,
                                          onSelected: (value) {
                                            setState(() {
                                              setBottomState(() {
                                                value
                                                    ? notFor.add(e)
                                                    : notFor.remove(e);
                                              });
                                            });
                                          },
                                        ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                runSpacing: 6,
                spacing: 8,
                children: [
                  for (var i in notFor)
                    Chip(
                      backgroundColor: const Color(0xFFE1E4F3),
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: const BorderSide(
                            // color: Colors.blue.shade200,
                            color: Colors.transparent,
                            width: 2,
                          )),
                      label: Text(
                        i.name.toUpperCase(),
                        style: const TextStyle(
                          // fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3649AE),
                        ),
                      ),
                      onDeleted: () {
                        setState(() {
                          notFor.remove(i);
                        });
                      },
                      clipBehavior: Clip.antiAlias,
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
                            idController.text.isNotEmpty &&
                            _courseId.hasMatch(idController.text) &&
                            // notFor.isNotEmpty &&
                            limitController.text.isNotEmpty &&
                            offeredByController.value.text.isNotEmpty)
                        ? () {
                            addSubject();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: const Text("create"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
