// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:one/core/common/loader.dart';
import 'package:one/core/models/department_model.dart';
import 'package:one/core/models/elective_subject_model.dart';
import 'package:one/features/auth/controller/auth_controller.dart';
import 'package:one/features/auth/widgets/large_button.dart';
import 'package:one/features/home/screens/forms_controller.dart';
import 'package:one/features/home/screens/my_ids.dart';

class FormPage extends ConsumerStatefulWidget {
  final String formId;
  const FormPage({
    super.key,
    required this.formId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FormPageState();
}

class _FormPageState extends ConsumerState<FormPage> {
  ElectiveSubject? selectedSubject;

  void submitForm() async {
    await ref.watch(formsControllerProvider.notifier).addResponse(
          context: context,
          formId: widget.formId,
          courseId: selectedSubject!.id,
          limit: selectedSubject!.limit,
        );
  }

  bool submitted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final rollNumber = ref.watch(userProvider)!.rollNO;
    if (ref.watch(userProvider)!.out == null ||
        (ref.watch(userProvider)!.out != null &&
            ref.watch(userProvider)!.out !=
                (int.parse(widget.formId.substring(2, 4)) + 4))) {
      return const Scaffold(
        body: Center(
          child: Text("this form is not for u"),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.formId),
      ),
      body: ref.watch(formProvider(widget.formId)).when(
            data: (form) => ref
                .watch(subjectsProvider(MyIds(
                  regulationId: form.regulationId,
                  electiveId: form.electiveId,
                ).toJson()))
                .when(
                  data: (subjects) => ref
                      .watch(responsesProvider(widget.formId))
                      .when(
                        data: (responses) {
                          int registerIndex = responses.indexWhere(
                              (response) => response.rollNumber == rollNumber);
                          if (registerIndex != -1) {
                            String registeredCourseId =
                                responses[registerIndex].courseId;
                            // log(responses[registerIndex].courseId);
                            selectedSubject = subjects.singleWhere(
                                (subject) => subject.id == registeredCourseId);
                            // log(selectedSubject.toString());
                            submitted = true;
                          }

                          return Scaffold(
                            body: ListView.builder(
                              itemCount: subjects.length,
                              itemBuilder: (context, index) {
                                if (subjects[index].notFor.contains(
                                    departmentFromRollNumber(
                                        ref.watch(userProvider)!.rollNO!))) {
                                  // return Text(subjects[index].name);
                                  return const SizedBox();
                                }
                                int registerCount = responses
                                    .where((response) =>
                                        response.courseId == subjects[index].id)
                                    .length;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0,
                                    vertical: 5,
                                  ),
                                  child: ChoiceChip(
                                    padding: const EdgeInsets.all(20),
                                    label: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            subjects[index].name,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                            "$registerCount/${subjects[index].limit.toString()}"),
                                      ],
                                    ),
                                    side: const BorderSide(
                                      color: Colors.black12,
                                      width: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    selected: (((selectedSubject != null) &&
                                                (registerCount <
                                                    subjects[index].limit)) ||
                                            (submitted))
                                        ? (selectedSubject!.id ==
                                            subjects[index].id)
                                        : false,
                                    onSelected: ((registerCount >=
                                                subjects[index].limit) ||
                                            submitted)
                                        ? null
                                        : (value) {
                                            (value)
                                                ? selectedSubject =
                                                    subjects[index]
                                                : selectedSubject = null;
                                            // log(selectedSubject.toString());
                                            setState(() {});
                                          },
                                  ),
                                );
                              },
                            ),
                            bottomNavigationBar: BottomAppBar(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: LargeButton(
                                        onTap: ((selectedSubject != null) &&
                                                !(submitted) &&
                                                responses
                                                        .where((response) =>
                                                            response.courseId ==
                                                            selectedSubject!.id)
                                                        .length <
                                                    selectedSubject!.limit)
                                            ? () => submitForm()
                                            : null,
                                        text: "submit"),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        error: (error, stackTrace) => Text(error.toString()),
                        loading: () => const Loader(),
                      ),
                  error: (error, stackTrace) => Text(error.toString()),
                  loading: () => const Loader(),
                ),
            error: (error, stackTrace) => Text(error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}

class SubmissionSuccess extends StatelessWidget {
  const SubmissionSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: 500,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.circleCheck),
            SizedBox(
              height: 10,
            ),
            Text("response submitted successfully"),
          ],
        ),
      ),
    );
  }
}
