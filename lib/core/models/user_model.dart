// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  final String? displayName;
  final String name;
  final String profilePic;
  final String uid;
  final String oid;
  final String? fcm;
  final String email;
  final bool? isAdmin;
  final String? phoneNo;
  final String? rollNO;
  final DateTime lastSignInTime;
  final List<String>? roles;
  UserModel({
    this.displayName,
    required this.name,
    required this.profilePic,
    required this.uid,
    required this.oid,
    this.fcm,
    required this.email,
    this.isAdmin,
    this.phoneNo,
    this.rollNO,
    required this.lastSignInTime,
    this.roles,
  });

  UserModel copyWith({
    String? displayName,
    String? name,
    String? profilePic,
    String? uid,
    String? oid,
    String? fcm,
    String? email,
    bool? isAdmin,
    String? phoneNo,
    String? rollNO,
    DateTime? lastSignInTime,
    List<String>? roles,
  }) {
    return UserModel(
      displayName: displayName ?? this.displayName,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      uid: uid ?? this.uid,
      oid: oid ?? this.oid,
      fcm: fcm ?? this.fcm,
      email: email ?? this.email,
      isAdmin: isAdmin ?? this.isAdmin,
      phoneNo: phoneNo ?? this.phoneNo,
      rollNO: rollNO ?? this.rollNO,
      lastSignInTime: lastSignInTime ?? this.lastSignInTime,
      roles: roles ?? this.roles,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'displayName': displayName,
      'name': name,
      'profilePic': profilePic,
      'uid': uid,
      'oid': oid,
      'fcm': fcm,
      'email': email,
      'isAdmin': isAdmin,
      'phoneNo': phoneNo,
      'rollNO': rollNO,
      'lastSignInTime': lastSignInTime.millisecondsSinceEpoch,
      'roles': roles,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      displayName:
          map['displayName'] != null ? map['displayName'] as String : null,
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      uid: map['uid'] as String,
      oid: map['oid'] as String,
      fcm: map['fcm'] != null ? map['fcm'] as String : null,
      email: map['email'] as String,
      isAdmin: map['isAdmin'] != null ? map['isAdmin'] as bool : null,
      phoneNo: map['phoneNo'] != null ? map['phoneNo'] as String : null,
      rollNO: map['rollNO'] != null ? map['rollNO'] as String : null,
      lastSignInTime:
          DateTime.fromMillisecondsSinceEpoch(map['lastSignInTime'] as int),
      roles: map['roles'] != null
          ? List<String>.from((map['roles'] as List))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(displayName: $displayName, name: $name, profilePic: $profilePic, uid: $uid, oid: $oid, fcm: $fcm, email: $email, isAdmin: $isAdmin, phoneNo: $phoneNo, rollNO: $rollNO, lastSignInTime: $lastSignInTime, roles: $roles)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.displayName == displayName &&
        other.name == name &&
        other.profilePic == profilePic &&
        other.uid == uid &&
        other.oid == oid &&
        other.fcm == fcm &&
        other.email == email &&
        other.isAdmin == isAdmin &&
        other.phoneNo == phoneNo &&
        other.rollNO == rollNO &&
        other.lastSignInTime == lastSignInTime &&
        listEquals(other.roles, roles);
  }

  @override
  int get hashCode {
    return displayName.hashCode ^
        name.hashCode ^
        profilePic.hashCode ^
        uid.hashCode ^
        oid.hashCode ^
        fcm.hashCode ^
        email.hashCode ^
        isAdmin.hashCode ^
        phoneNo.hashCode ^
        rollNO.hashCode ^
        lastSignInTime.hashCode ^
        roles.hashCode;
  }
}

enum Section { a, b, c, d }

/// this is used to Convert string into instance
///
/// Section as Sting ➡️ Section instance
Section? sectionFromString(String secAsString) {
  for (Section e in Section.values) {
    if (e.name == secAsString) {
      return e;
    }
  }
  return null;
}

class Batch {
  final int fromYear;
  final int toYear;
  Batch({
    required this.fromYear,
    // required this.toYear,
  }) : toYear = fromYear + 4;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fromYear': fromYear,
      'toYear': toYear,
    };
  }

  factory Batch.fromMap(Map<String, dynamic> map) {
    return Batch(
      fromYear: map['fromYear'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Batch.fromJson(String source) =>
      Batch.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Batch(fromYear: $fromYear, toYear: $toYear)';

  @override
  bool operator ==(covariant Batch other) {
    if (identical(this, other)) return true;

    return other.fromYear == fromYear && other.toYear == toYear;
  }

  @override
  int get hashCode => fromYear.hashCode ^ toYear.hashCode;
}

// void main() {
//   // final Batch a = Batch(fromYear: 2022);
//   // print(a.fromYear.toString() + ' ' + a.toYear.toString());

//   final UserModel use = UserModel(
//     email: "g@dfdsoio.com",
//     name: "gafoor",
//     profilePic: "/pic",
//     uid: "uid46876",
//     isAuthenticated: true,
//     year: Batch(fromYear: 2022),
//     department: Department.cse,
//     section: Section.c,
//     rollNO: "222f2",
//   );

//   final a = use.toJson();
//   // print(a);
//   final b = UserModel.fromJson(a);
//   // print(b);
//   // print(use.department.name);
//   // print(Section.values[0].name);
// }
