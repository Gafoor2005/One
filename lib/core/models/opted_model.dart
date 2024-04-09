// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Opted {
  final String rollNo;
  final String name;
  final DateTime timestamp;
  final String subjectId;
  Opted({
    required this.rollNo,
    required this.name,
    required this.timestamp,
    required this.subjectId,
  });

  Opted copyWith({
    String? rollNo,
    String? name,
    DateTime? timestamp,
    String? subjectId,
  }) {
    return Opted(
      rollNo: rollNo ?? this.rollNo,
      name: name ?? this.name,
      timestamp: timestamp ?? this.timestamp,
      subjectId: subjectId ?? this.subjectId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'rollNo': rollNo,
      'name': name,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'subjectId': subjectId,
    };
  }

  factory Opted.fromMap(Map<String, dynamic> map) {
    return Opted(
      rollNo: map['rollNo'] as String,
      name: map['name'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      subjectId: map['subjectId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Opted.fromJson(String source) =>
      Opted.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Opted(rollNo: $rollNo, name: $name, timestamp: $timestamp, subjectId: $subjectId)';
  }

  @override
  bool operator ==(covariant Opted other) {
    if (identical(this, other)) return true;

    return other.rollNo == rollNo &&
        other.name == name &&
        other.timestamp == timestamp &&
        other.subjectId == subjectId;
  }

  @override
  int get hashCode {
    return rollNo.hashCode ^
        name.hashCode ^
        timestamp.hashCode ^
        subjectId.hashCode;
  }
}
