// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class News {
  String id;
  String title;
  String description;
  String sentBy;
  DateTime timestamp;
  News({
    required this.id,
    required this.title,
    required this.description,
    required this.sentBy,
    required this.timestamp,
  });

  News copyWith({
    String? id,
    String? title,
    String? description,
    String? sentBy,
    DateTime? timestamp,
  }) {
    return News(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      sentBy: sentBy ?? this.sentBy,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'sentBy': sentBy,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory News.fromMap(Map<String, dynamic> map) {
    return News(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      sentBy: map['sentBy'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory News.fromJson(String source) =>
      News.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'News(id: $id, title: $title, description: $description, sentBy: $sentBy, timestamp: $timestamp)';
  }

  @override
  bool operator ==(covariant News other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.sentBy == sentBy &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        sentBy.hashCode ^
        timestamp.hashCode;
  }
}
