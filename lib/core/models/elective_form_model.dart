// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ElectiveForm {
  final String id;
  final String name;
  final String description;
  final String regulationId;
  final String electiveId;
  final int batch;
  ElectiveForm({
    required this.id,
    required this.name,
    required this.description,
    required this.regulationId,
    required this.electiveId,
    required this.batch,
  });

  ElectiveForm copyWith({
    String? id,
    String? name,
    String? description,
    String? regulationId,
    String? electiveId,
    int? batch,
  }) {
    return ElectiveForm(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      regulationId: regulationId ?? this.regulationId,
      electiveId: electiveId ?? this.electiveId,
      batch: batch ?? this.batch,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'regulationId': regulationId,
      'electiveId': electiveId,
      'batch': batch,
    };
  }

  factory ElectiveForm.fromMap(Map<String, dynamic> map) {
    return ElectiveForm(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      regulationId: map['regulationId'] as String,
      electiveId: map['electiveId'] as String,
      batch: map['batch'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ElectiveForm.fromJson(String source) =>
      ElectiveForm.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ElectiveForm(id: $id, name: $name, description: $description, regulationId: $regulationId, electiveId: $electiveId, batch: $batch)';
  }

  @override
  bool operator ==(covariant ElectiveForm other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.regulationId == regulationId &&
        other.electiveId == electiveId &&
        other.batch == batch;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        regulationId.hashCode ^
        electiveId.hashCode ^
        batch.hashCode;
  }
}
