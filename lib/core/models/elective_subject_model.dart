// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:one/core/models/department_model.dart';

class ElectiveSubject {
  final String id;
  final String name;
  final Department offeredBy;
  final List<Department> notFor;
  final int limit;
  ElectiveSubject({
    required this.id,
    required this.name,
    required this.offeredBy,
    required this.notFor,
    required this.limit,
  });

  ElectiveSubject copyWith({
    String? id,
    String? name,
    Department? offeredBy,
    List<Department>? notFor,
    int? limit,
  }) {
    return ElectiveSubject(
      id: id ?? this.id,
      name: name ?? this.name,
      offeredBy: offeredBy ?? this.offeredBy,
      notFor: notFor ?? this.notFor,
      limit: limit ?? this.limit,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'offeredBy': offeredBy.name,
      'notFor': notFor.map((x) => x.name).toList(),
      'limit': limit,
    };
  }

  factory ElectiveSubject.fromMap(Map<String, dynamic> map) {
    return ElectiveSubject(
      id: map['id'] as String,
      name: map['name'] as String,
      offeredBy: departmentFromString(map['offeredBy'])!,

      ///contains error List<dynamic> not subtype of List<String>
      ///so remove List<String> replace with List
      // notFor: List<Department>.from(
      //   (map['notFor'] as List<String>).map<Department>(
      //     (x) => departmentFromString(x)!,
      //   ),
      // ),
      notFor: List<Department>.from(
        (map['notFor'] as List).map<Department>(
          (x) => departmentFromString(x)!,
        ),
      ),
      limit: map['limit'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ElectiveSubject.fromJson(String source) =>
      ElectiveSubject.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ElectiveSubject(id: $id, name: $name, offeredBy: $offeredBy, notFor: $notFor, limit: $limit)';
  }

  @override
  bool operator ==(covariant ElectiveSubject other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.offeredBy == offeredBy &&
        listEquals(other.notFor, notFor) &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        offeredBy.hashCode ^
        notFor.hashCode ^
        limit.hashCode;
  }
}
