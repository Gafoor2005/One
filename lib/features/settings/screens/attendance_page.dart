// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart' as parser;
import 'package:one/features/auth/controller/auth_controller.dart';
import 'package:one/features/home/screens/api_controller.dart';

class AttendanceModel {
  final String rollNO;
  final List<SubjectModel> subjects;
  final int totalHeld;
  final int totalAttended;
  final double totalPercent;
  AttendanceModel({
    required this.rollNO,
    required this.subjects,
    required this.totalHeld,
    required this.totalAttended,
    required this.totalPercent,
  });

  factory AttendanceModel.response(String html) {
    var document = parser.parse(html);
    final rollNoEle = document.querySelector(
      "#\\\\\\'tblReport\\\\\\' > table > tbody > tr:nth-child(1) > td > table > tbody > tr:first-child > td:nth-child(1)",
    );
    final rows = document
        .querySelector(
          "#\\\\\\'tblReport\\\\\\' > table > tbody > tr:nth-child(2) > td > center > table > tbody > tr > td > table > tbody > tr:first-child > td > table > tbody",
        )!
        .children;
    List<SubjectModel> subs = [];
    for (int i = 1; i < rows.length - 1; i++) {
      final subEle = rows[i].querySelector("tr > td:nth-child(1)")!;
      final heldEle = rows[i].querySelector("tr > td:nth-child(2)")!;
      final attEle = rows[i].querySelector("tr > td:nth-child(3)")!;
      final perEle = rows[i].querySelector("tr > td:nth-child(4)")!;
      subs.add(
        SubjectModel(
          name: subEle.innerHtml,
          held: int.parse(heldEle.innerHtml),
          attended: int.parse(attEle.innerHtml),
          percent: double.parse(perEle.innerHtml),
        ),
      );
    }
    final lastRow = rows[rows.length - 1];
    return AttendanceModel(
      rollNO: rollNoEle!.innerHtml,
      subjects: subs,
      totalHeld:
          int.parse(lastRow.querySelector("tr > td:nth-child(1)")!.innerHtml),
      totalAttended:
          int.parse(lastRow.querySelector("tr > td:nth-child(2)")!.innerHtml),
      totalPercent: double.parse(
          lastRow.querySelector("tr > td:nth-child(3)")!.innerHtml),
    );
  }

  AttendanceModel copyWith({
    String? rollNO,
    List<SubjectModel>? subjects,
    int? totalHeld,
    int? totalAttended,
    double? totalPercent,
  }) {
    return AttendanceModel(
      rollNO: rollNO ?? this.rollNO,
      subjects: subjects ?? this.subjects,
      totalHeld: totalHeld ?? this.totalHeld,
      totalAttended: totalAttended ?? this.totalAttended,
      totalPercent: totalPercent ?? this.totalPercent,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'rollNO': rollNO,
      'subjects': subjects.map((x) => x.toMap()).toList(),
      'totalHeld': totalHeld,
      'totalAttended': totalAttended,
      'totalPercent': totalPercent,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      rollNO: map['rollNO'] as String,
      subjects: List<SubjectModel>.from(
        (map['subjects'] as List<int>).map<SubjectModel>(
          (x) => SubjectModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalHeld: map['totalHeld'] as int,
      totalAttended: map['totalAttended'] as int,
      totalPercent: map['totalPercent'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory AttendanceModel.fromJson(String source) =>
      AttendanceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AttendanceModel(rollNO: $rollNO, subjects: $subjects, totalHeld: $totalHeld, totalAttended: $totalAttended, totalPercent: $totalPercent)';
  }

  @override
  bool operator ==(covariant AttendanceModel other) {
    if (identical(this, other)) return true;

    return other.rollNO == rollNO &&
        listEquals(other.subjects, subjects) &&
        other.totalHeld == totalHeld &&
        other.totalAttended == totalAttended &&
        other.totalPercent == totalPercent;
  }

  @override
  int get hashCode {
    return rollNO.hashCode ^
        subjects.hashCode ^
        totalHeld.hashCode ^
        totalAttended.hashCode ^
        totalPercent.hashCode;
  }
}

class SubjectModel {
  final String name;
  final int held;
  final int attended;
  final double percent;
  SubjectModel({
    required this.name,
    required this.held,
    required this.attended,
    required this.percent,
  });

  SubjectModel copyWith({
    String? name,
    int? held,
    int? attended,
    double? percent,
  }) {
    return SubjectModel(
      name: name ?? this.name,
      held: held ?? this.held,
      attended: attended ?? this.attended,
      percent: percent ?? this.percent,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'held': held,
      'attended': attended,
      'percent': percent,
    };
  }

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      name: map['name'] as String,
      held: map['held'] as int,
      attended: map['attended'] as int,
      percent: map['percent'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubjectModel.fromJson(String source) =>
      SubjectModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SubjectModel(name: $name, held: $held, attended: $attended, percent: $percent)';
  }

  @override
  bool operator ==(covariant SubjectModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.held == held &&
        other.attended == attended &&
        other.percent == percent;
  }

  @override
  int get hashCode {
    return name.hashCode ^ held.hashCode ^ attended.hashCode ^ percent.hashCode;
  }
}

final attendanceProvider = StateProvider<AttendanceModel?>((ref) => null);

class AttendancePage extends ConsumerStatefulWidget {
  const AttendancePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AttendancePageState();
}

class _AttendancePageState extends ConsumerState<AttendancePage> {
  bool access = true;
  void getAttendance(BuildContext context) async {
    if (await ref
        .watch(apiControllerProvider.notifier)
        .getAttendance(context, ref.watch(userProvider)!.rollNO)) {
      access = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AttendanceModel? attendance = ref.watch(attendanceProvider);
    if (attendance != null) {
      List<Widget> rows = [_AttendanceHead()];
      for (var e in attendance.subjects) {
        rows.add(_AttendanceRow(sub: e));
      }
      rows.add(
        _AttendanceTotal(
          att: attendance.totalAttended,
          held: attendance.totalHeld,
          per: attendance.totalPercent,
        ),
      );
      return Scaffold(
        appBar: AppBar(
          title: const Text("Attendance"),
          elevation: 2,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                // padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue.shade50,
                ),
                clipBehavior: Clip.antiAlias,
                child: Wrap(spacing: 10, runSpacing: 2, children: rows),
              ),
              Text(
                attendance.rollNO,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      getAttendance(context);
      return Scaffold(
        body: Center(
            child: (access)
                ? const Text("loading")
                : const Text("restriced acess!!")),
      );
    }
  }
}

class _AttendanceTotal extends StatelessWidget {
  final int held;
  final int att;
  final double per;
  const _AttendanceTotal({
    required this.held,
    required this.att,
    required this.per,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10,
      ),
      child: Flex(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        direction: Axis.horizontal,
        children: [
          const Expanded(
            flex: 2,
            child: Text(
              "Total",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              held.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              att.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              per.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceHead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Subjects",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "Held",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "Attend",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "%",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}

class _AttendanceRow extends StatelessWidget {
  final SubjectModel sub;
  const _AttendanceRow({
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 5,
      ),
      child: Flex(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: 2,
            child: Text(sub.name),
          ),
          Expanded(
            flex: 1,
            child: Text(
              sub.held.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              sub.attended.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              sub.percent.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
