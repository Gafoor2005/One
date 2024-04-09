// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

class MyIds {
  final String? regulationId;
  final String? electiveId;
  MyIds({
    this.regulationId,
    this.electiveId,
  });

  MyIds copyWith({
    String? regulationId,
    String? electiveId,
  }) {
    return MyIds(
      regulationId: regulationId ?? this.regulationId,
      electiveId: electiveId ?? this.electiveId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'regulationId': regulationId,
      'electiveId': electiveId,
    };
  }

  factory MyIds.fromMap(Map<String, dynamic> map) {
    return MyIds(
      regulationId:
          map['regulationId'] != null ? map['regulationId'] as String : null,
      electiveId:
          map['electiveId'] != null ? map['electiveId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MyIds.fromJson(String source) =>
      MyIds.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'MyIds(regulationId: $regulationId, electiveId: $electiveId)';

  @override
  bool operator ==(covariant MyIds other) {
    if (identical(this, other)) return true;

    return other.regulationId == regulationId && other.electiveId == electiveId;
  }

  @override
  int get hashCode => regulationId.hashCode ^ electiveId.hashCode;
}
