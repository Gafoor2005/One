import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/core/models/elective_form_model.dart';
import 'package:one/core/models/elective_model.dart';
import 'package:one/core/models/elective_subject_model.dart';
import 'package:one/core/models/form_response_model.dart';
import 'package:one/core/models/regulation_model.dart';
import 'package:one/core/utils.dart';
import 'package:one/features/auth/controller/auth_controller.dart';
import 'package:one/features/home/screens/forms_repository.dart';
import 'package:uuid/uuid.dart';

import 'my_ids.dart';

final formsControllerProvider =
    StateNotifierProvider<FormsController, bool>((ref) {
  final formsRepository = ref.watch(formsRepositoryProvider);
  return FormsController(formsRepository: formsRepository, ref: ref);
});

final formsProvider = StreamProvider((ref) {
  final formsController = ref.watch(formsControllerProvider.notifier);
  return formsController.fetchForms();
});
final regulationProvider = StreamProvider((ref) {
  final formsController = ref.watch(formsControllerProvider.notifier);
  return formsController.fetchRegulation();
});
final singleRegulationProvider =
    StreamProvider.family<Regulation, String>((ref, id) {
  final formsController = ref.watch(formsControllerProvider.notifier);
  return formsController.getRegulation(id);
});
final formProvider = StreamProvider.family<ElectiveForm, String>((ref, id) {
  final formsController = ref.watch(formsControllerProvider.notifier);
  return formsController.getForm(id);
});
final electiveProvider = StreamProvider.family<Elective, String>((ref, json) {
  final formsController = ref.watch(formsControllerProvider.notifier);
  final id = MyIds.fromJson(json);
  return formsController.getElective(id.regulationId!, id.electiveId!);
});
final electivesProvider =
    StreamProvider.family<List<Elective>, String>((ref, regulationId) {
  final formsController = ref.watch(formsControllerProvider.notifier);
  return formsController.getElectives(regulationId);
});
final responsesProvider =
    StreamProvider.family<List<FormResponse>, String>((ref, formId) {
  final formsController = ref.watch(formsControllerProvider.notifier);
  return formsController.getResponses(formId);
});

final subjectsProvider =
    StreamProvider.family<List<ElectiveSubject>, String>((ref, json) {
  final formsController = ref.watch(formsControllerProvider.notifier);
  final id = MyIds.fromJson(json);
  return formsController.getSubjects(id.regulationId!, id.electiveId!);
});

class FormsController extends StateNotifier<bool> {
  final FormsRepository _formsRepository;
  final Ref _ref;

  FormsController({
    required FormsRepository formsRepository,
    required Ref ref,
  })  : _formsRepository = formsRepository,
        _ref = ref,
        super(false); //for loading status

  Future<String> addRegulation({
    required BuildContext context,
    required String name,
    required int startYear,
    int lifeSpan = 3,
  }) async {
    state = true;
    // String regulationId = const Uuid().v1();
    String regulationId = name.trim().replaceAll(" ", "");
    final user = _ref.read(userProvider)!;

    final Regulation regulation = Regulation(
      id: regulationId,
      name: name,
      startYear: startYear,
      lifeSpan: lifeSpan,
    );

    final res = await _formsRepository.addRegulation(regulation);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'regulation added successfully!');
        // Routemaster.of(context).pop();
      },
    );

    return regulationId;
  }

  Future<String> addForm({
    required BuildContext context,
    required ElectiveForm form,
  }) async {
    state = true;

    final res = await _formsRepository.addForm(form);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Form added successfully!');
        // Routemaster.of(context).pop();
      },
    );

    return form.id;
  }

  Future<int> addResponse({
    required BuildContext context,
    required String formId,
    required String courseId,
  }) async {
    state = true;
    int message = 0;
    // String electiveId = const Uuid().v1();
    final FormResponse response = FormResponse(
      rollNumber: _ref.watch(userProvider)!.rollNO,
      courseId: courseId,
      timestamp: DateTime.now(),
    );
    final res = await _formsRepository.addResponse(response, formId);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        message = 1;
        showSnackBar(context, 'response submitted successfully!');
        // Routemaster.of(context).pop();
      },
    );

    return message;
  }

  Future<String> addElective({
    required BuildContext context,
    required String regulationId,
    required String name,
    required ElectiveType type,
  }) async {
    state = true;
    // String electiveId = const Uuid().v1();
    String electiveId = name.trim().replaceAll(" ", "");
    final elective = Elective(
      id: electiveId,
      name: name,
      type: type,
    );
    final res = await _formsRepository.addElective(elective, regulationId);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Elective created successfully!');
        // Routemaster.of(context).pop();
      },
    );

    return electiveId;
  }

  Future<String> addSubject({
    required BuildContext context,
    required String regulationId,
    required String electiveId,
    required ElectiveSubject subject,
  }) async {
    state = true;
    // String electiveId = const Uuid().v1();
    // final elective = Elective(id: electiveId, name: name, type: type);
    final res =
        await _formsRepository.addSubject(subject, regulationId, electiveId);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Subject added successfully!');
        // Routemaster.of(context).pop();
      },
    );

    return electiveId;
  }

  Stream<List<ElectiveSubject>> getSubjects(
      String regulationId, String electiveId) {
    return _formsRepository.getSubjects(regulationId, electiveId);
  }

  Stream<List<Elective>> getElectives(String regulationId) {
    return _formsRepository.getElectives(regulationId);
  }

  Stream<List<FormResponse>> getResponses(String formId) {
    return _formsRepository.getResponses(formId);
  }

  Stream<List<Regulation>> fetchRegulation() {
    return _formsRepository.fetchRegulation();
  }

  Stream<List<ElectiveForm>> fetchForms() {
    return _formsRepository.fetchForms();
  }

  Future<void> deletRegulation(String id) {
    return _formsRepository.deleteRegulation(id);
  }

  Stream<Regulation> getRegulation(String id) {
    return _formsRepository.getRegulation(id);
  }

  Stream<ElectiveForm> getForm(String id) {
    return _formsRepository.getForm(id);
  }

  Stream<Elective> getElective(String regulationId, String electiveId) {
    return _formsRepository.getElective(regulationId, electiveId);
  }
}
