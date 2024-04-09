// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Elective {
  final String id;
  final String name;
  final ElectiveType type;
  Elective({
    required this.id,
    required this.name,
    required this.type,
  });

  Elective copyWith({
    String? id,
    String? name,
    ElectiveType? type,
  }) {
    return Elective(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'type': type.name,
    };
  }

  factory Elective.fromMap(Map<String, dynamic> map) {
    return Elective(
      id: map['id'] as String,
      name: map['name'] as String,
      type: electiveTypeFromString(map['type'] as String) ??
          ElectiveType.openElective,
    );
  }

  String toJson() => json.encode(toMap());

  factory Elective.fromJson(String source) =>
      Elective.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Elective(id: $id, name: $name, type: $type)';

  @override
  bool operator ==(covariant Elective other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.type == type;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ type.hashCode;
}

enum ElectiveType { openElective, professionalElective }

/// this is used to Convert string into instance
///
/// ElectiveType as Sting ➡️ ElectiveType instance
ElectiveType? electiveTypeFromString(String electiveAsString) {
  for (ElectiveType e in ElectiveType.values) {
    if (e.name == electiveAsString) {
      return e;
    }
  }
  return null;
}
