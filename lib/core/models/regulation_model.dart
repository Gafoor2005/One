// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Regulation {
  final String id;
  final String name;
  final int startYear;
  final int lifeSpan;
  Regulation({
    required this.id,
    required this.name,
    required this.startYear,
    required this.lifeSpan,
  });

  Regulation copyWith({
    String? id,
    String? name,
    int? startYear,
    int? lifeSpan,
  }) {
    return Regulation(
      id: id ?? this.id,
      name: name ?? this.name,
      startYear: startYear ?? this.startYear,
      lifeSpan: lifeSpan ?? this.lifeSpan,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'startYear': startYear,
      'lifeSpan': lifeSpan,
    };
  }

  factory Regulation.fromMap(Map<String, dynamic> map) {
    return Regulation(
      id: map['id'] as String,
      name: map['name'] as String,
      startYear: map['startYear'] as int,
      lifeSpan: map['lifeSpan'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Regulation.fromJson(String source) =>
      Regulation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Regulation(id: $id, name: $name, startYear: $startYear, lifeSpan: $lifeSpan)';
  }

  @override
  bool operator ==(covariant Regulation other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.startYear == startYear &&
        other.lifeSpan == lifeSpan;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ startYear.hashCode ^ lifeSpan.hashCode;
  }
}
