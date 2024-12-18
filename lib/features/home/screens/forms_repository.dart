import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:one/core/failuer.dart';
import 'package:one/core/models/elective_form_model.dart';
import 'package:one/core/models/elective_model.dart';
import 'package:one/core/models/elective_subject_model.dart';
import 'package:one/core/models/form_response_model.dart';
import 'package:one/core/models/regulation_model.dart';
import 'package:one/core/providers/firebase_providers.dart';
import 'package:one/core/type_defs.dart';
import 'package:one/features/auth/controller/auth_controller.dart';

final formsRepositoryProvider = Provider<FormsRepository>((ref) {
  return FormsRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

class FormsRepository {
  final FirebaseFirestore _firestore;
  FormsRepository({
    required firestore,
  }) : _firestore = firestore;

  CollectionReference get _regulation => _firestore.collection("regulation");
  CollectionReference get _forms => _firestore.collection("forms");

  FutureVoid addRegulation(Regulation regulation) async {
    try {
      return right(_regulation.doc(regulation.id).set(regulation.toMap()));
    } on FirebaseException catch (e) {
      return left(Failure(e.message.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid addForm(ElectiveForm form) async {
    try {
      return right(_forms.doc(form.id).set(form.toMap()));
    } on FirebaseException catch (e) {
      return left(Failure(e.message.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid addElective(Elective elective, String regulationId) async {
    try {
      return right(_regulation
          .doc(regulationId)
          .collection("electives")
          .doc(elective.id)
          .set(elective.toMap()));
    } on FirebaseException catch (e) {
      return left(Failure(e.message.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<int> getCountOfResponsesWithCourseId(
    String courseId,
    String formId,
  ) async {
    final Completer<int> completer = Completer<int>();
    // TODO: change timeout time when data is large
    Timer(const Duration(seconds: 2), () {
      if (!completer.isCompleted) {
        completer.completeError('Timeout, try again');
      }
    });

    try {
      final querySnapshot = await _firestore
          .collection('forms')
          .doc(formId)
          .collection('responses')
          .where('courseId', isEqualTo: courseId)
          .get();

      if (!completer.isCompleted) {
        completer.complete(querySnapshot.size);
      }
    } catch (e) {
      if (!completer.isCompleted) {
        completer.completeError(e);
      }
    }

    return completer.future;
  }

  FutureVoid addResponse(
    FormResponse response,
    String formId,
    int limit,
  ) async {
    try {
      var count =
          await getCountOfResponsesWithCourseId(response.courseId, formId);
      if (count >= limit) {
        throw ("limit reached form not submitted");
      }
      await _forms
          .doc(formId)
          .collection("responses")
          .doc(response.rollNumber)
          .set(response.toMap());
      count = await getCountOfResponsesWithCourseId(response.courseId, formId);
      if (count > limit) {
        final query = await _firestore
            .collection('forms')
            .doc(formId)
            .collection('responses')
            .where('courseId', isEqualTo: response.courseId)
            .orderBy('timestamp')
            .limit(limit)
            .get();
        bool late =
            query.docs.where((doc) => doc.id == response.rollNumber).isEmpty;
        log(query.docs.length.toString());
        if (late) {
          await _forms
              .doc(formId)
              .collection("responses")
              .doc(response.rollNumber)
              .delete();
          return left(Failure("that was too close. try again"));
        }
      }

      return right(FutureVoid);
    } on FirebaseException catch (e) {
      return left(Failure(e.message.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid addSubject(
    ElectiveSubject subject,
    String regulationId,
    String electiveId,
  ) async {
    try {
      return right(_regulation
          .doc(regulationId)
          .collection("electives")
          .doc(electiveId)
          .collection("subjects")
          .doc(subject.id)
          .set(subject.toMap()));
    } on FirebaseException catch (e) {
      return left(Failure(e.message.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<void> deleteRegulation(String id) async {
    return await _regulation.doc(id).delete();
  }

  Stream<Regulation> getRegulation(String id) {
    return _regulation
        .doc(id)
        .get()
        .then(
            (value) => Regulation.fromMap(value.data() as Map<String, dynamic>))
        .asStream();
  }

  Stream<ElectiveForm> getForm(String id) {
    return _forms
        .doc(id)
        .get()
        .then((value) =>
            ElectiveForm.fromMap(value.data() as Map<String, dynamic>))
        .asStream();
  }

  Stream<Elective> getElective(String regulationId, String electiveId) {
    return _regulation
        .doc(regulationId)
        .collection("electives")
        .doc(electiveId)
        .get()
        .then((value) => Elective.fromMap(value.data() as Map<String, dynamic>))
        .asStream();
  }

  Stream<List<ElectiveSubject>> getSubjects(
      String regulationId, String electiveId) {
    return _regulation
        .doc(regulationId)
        .collection("electives")
        .doc(electiveId)
        .collection("subjects")
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => ElectiveSubject.fromMap(
                  e.data(),
                ),
              )
              .toList(),
        );
  }

  Stream<List<Elective>> getElectives(String regulationId) {
    return _regulation
        .doc(regulationId)
        .collection("electives")
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Elective.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  Stream<List<FormResponse>> getResponses(String formId) {
    return _forms.doc(formId).collection("responses").snapshots().map(
          (event) => event.docs
              .map(
                (e) => FormResponse.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  Stream<List<Regulation>> fetchRegulation() {
    return _regulation
        .orderBy('startYear', descending: true)
        .snapshots()
        .map((event) {
      log(event.docs.length.toString());
      return event.docs
          .map(
            (e) => Regulation.fromMap(
              e.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    });
  }

  Stream<List<ElectiveForm>> fetchForms(Ref ref) {
    final String roll = ref.watch(userProvider)!.rollNO!;

    int batch = int.parse(
        "20${roll[4] == '1' ? roll.substring(0, 2) : (int.parse(roll.substring(0, 2)) - 1)}");
    return _forms
        .where(
          'batch',
          isEqualTo: batch,
        )
        .snapshots()
        .map((event) {
      log(event.docs.length.toString());
      return event.docs
          .map(
            (e) => ElectiveForm.fromMap(
              e.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    });
  }
}
