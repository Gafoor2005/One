// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Post {
  final String id;
  final String uid;
  final String username;
  final String title;
  final String description;
  final DateTime createdAt;
  final List<String>? tags;
  final List<String>? viewedBy;
  final String? attachment;
  Post({
    required this.id,
    required this.uid,
    required this.username,
    required this.title,
    required this.description,
    required this.createdAt,
    this.tags,
    this.viewedBy,
    this.attachment,
  });

  Post copyWith({
    String? id,
    String? uid,
    String? username,
    String? title,
    String? description,
    DateTime? createdAt,
    List<String>? tags,
    List<String>? viewedBy,
    String? attachment,
  }) {
    return Post(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      username: username ?? this.username,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
      viewedBy: viewedBy ?? this.viewedBy,
      attachment: attachment ?? this.attachment,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'username': username,
      'title': title,
      'description': description,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'tags': tags,
      'viewedBy': viewedBy,
      'attachment': attachment,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as String,
      uid: map['uid'] as String,
      username: map['username'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      tags: map['tags'] != null ? List<String>.from(map['tags']) : null,
      viewedBy:
          map['viewedBy'] != null ? List<String>.from(map['viewedBy']) : null,
      attachment:
          map['attachment'] != null ? map['attachment'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) =>
      Post.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Post(id: $id, uid: $uid, username: $username, title: $title, description: $description, createdAt: $createdAt, tags: $tags, viewedBy: $viewedBy, attachment: $attachment)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uid == uid &&
        other.username == username &&
        other.title == title &&
        other.description == description &&
        other.createdAt == createdAt &&
        listEquals(other.tags, tags) &&
        listEquals(other.viewedBy, viewedBy) &&
        other.attachment == attachment;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uid.hashCode ^
        username.hashCode ^
        title.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        tags.hashCode ^
        viewedBy.hashCode ^
        attachment.hashCode;
  }
}

// void main() {
//   // print(Timestamp.now());
//   print(DateTime.timestamp());
// }
