// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class MsUserModel {
  final String id;
  final String userPrincipalName;
  final String displayName;
  final String givenName;
  final String surname;
  final String? jobTitle;
  final String? mail;
  final String? mobilePhone;
  final List<String>? roles;
  final String? photo;
  MsUserModel({
    required this.id,
    required this.userPrincipalName,
    required this.displayName,
    required this.givenName,
    required this.surname,
    this.jobTitle,
    this.mail,
    this.mobilePhone,
    this.roles,
    this.photo,
  });

  MsUserModel copyWith({
    String? id,
    String? userPrincipalName,
    String? displayName,
    String? givenName,
    String? surname,
    String? jobTitle,
    String? mail,
    String? mobilePhone,
    List<String>? roles,
    String? photo,
  }) {
    return MsUserModel(
      id: id ?? this.id,
      userPrincipalName: userPrincipalName ?? this.userPrincipalName,
      displayName: displayName ?? this.displayName,
      givenName: givenName ?? this.givenName,
      surname: surname ?? this.surname,
      jobTitle: jobTitle ?? this.jobTitle,
      mail: mail ?? this.mail,
      mobilePhone: mobilePhone ?? this.mobilePhone,
      roles: roles ?? this.roles,
      photo: photo ?? this.photo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userPrincipalName': userPrincipalName,
      'displayName': displayName,
      'givenName': givenName,
      'surname': surname,
      'jobTitle': jobTitle,
      'mail': mail,
      'mobilePhone': mobilePhone,
      'roles': roles,
      'photo': photo,
    };
  }

  factory MsUserModel.fromMap(Map<String, dynamic> map) {
    return MsUserModel(
      id: map['id'] as String,
      userPrincipalName: map['userPrincipalName'] as String,
      displayName: map['displayName'] as String,
      givenName: map['givenName'] as String,
      surname: map['surname'] as String,
      jobTitle: map['jobTitle'] != null ? map['jobTitle'] as String : null,
      mail: map['mail'] != null ? map['mail'] as String : null,
      mobilePhone:
          map['mobilePhone'] != null ? map['mobilePhone'] as String : null,
      roles: map['roles'] != null ? List<String>.from(map['roles']) : null,
      photo: map['photo'] != null ? map['photo'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MsUserModel.fromJson(String source) =>
      MsUserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MsUserModel(id: $id, userPrincipalName: $userPrincipalName, displayName: $displayName, givenName: $givenName, surname: $surname, jobTitle: $jobTitle, mail: $mail, mobilePhone: $mobilePhone, roles: $roles, photo: $photo)';
  }

  @override
  bool operator ==(covariant MsUserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userPrincipalName == userPrincipalName &&
        other.displayName == displayName &&
        other.givenName == givenName &&
        other.surname == surname &&
        other.jobTitle == jobTitle &&
        other.mail == mail &&
        other.mobilePhone == mobilePhone &&
        listEquals(other.roles, roles) &&
        other.photo == photo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userPrincipalName.hashCode ^
        displayName.hashCode ^
        givenName.hashCode ^
        surname.hashCode ^
        jobTitle.hashCode ^
        mail.hashCode ^
        mobilePhone.hashCode ^
        roles.hashCode ^
        photo.hashCode;
  }
}
