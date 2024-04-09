// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FormResponse {
  final String rollNumber;
  final String courseId;
  final DateTime timestamp;
  FormResponse({
    required this.rollNumber,
    required this.courseId,
    required this.timestamp,
  });

  FormResponse copyWith({
    String? rollNumber,
    String? courseId,
    DateTime? timestamp,
  }) {
    return FormResponse(
      rollNumber: rollNumber ?? this.rollNumber,
      courseId: courseId ?? this.courseId,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'rollNumber': rollNumber,
      'courseId': courseId,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory FormResponse.fromMap(Map<String, dynamic> map) {
    return FormResponse(
      rollNumber: map['rollNumber'] as String,
      courseId: map['courseId'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory FormResponse.fromJson(String source) =>
      FormResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'FormResponse(rollNumber: $rollNumber, courseId: $courseId, timestamp: $timestamp)';

  @override
  bool operator ==(covariant FormResponse other) {
    if (identical(this, other)) return true;

    return other.rollNumber == rollNumber &&
        other.courseId == courseId &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode =>
      rollNumber.hashCode ^ courseId.hashCode ^ timestamp.hashCode;
}
