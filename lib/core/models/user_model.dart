// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String name;
  final String profilePic;
  final String uid;
  final String email;
  final bool isAuthenticated;
  final Batch year;
  final Department department;
  final Section section;
  final String rollNO;
  UserModel({
    required this.name,
    required this.profilePic,
    required this.uid,
    required this.email,
    required this.isAuthenticated,
    required this.year,
    required this.department,
    required this.section,
    required this.rollNO,
  });

  UserModel copyWith({
    String? name,
    String? profilePic,
    String? uid,
    String? email,
    bool? isAuthenticated,
    Batch? year,
    Department? department,
    Section? section,
    String? rollNO,
  }) {
    return UserModel(
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      year: year ?? this.year,
      department: department ?? this.department,
      section: section ?? this.section,
      rollNO: rollNO ?? this.rollNO,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePic': profilePic,
      'uid': uid,
      'email': email,
      'isAuthenticated': isAuthenticated,
      'year': year.toMap(),
      'department': department.name,
      'section': section.name,
      'rollNO': rollNO,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      uid: map['uid'] as String,
      email: map['email'] as String,
      isAuthenticated: map['isAuthenticated'] as bool,
      year: Batch.fromMap(map['year'] as Map<String, dynamic>),
      department: departmentFromString(map['department']) as Department,
      section: sectionFromString(map['section']) as Section,
      rollNO: map['rollNO'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(name: $name, profilePic: $profilePic, uid: $uid, email: $email, isAuthenticated: $isAuthenticated, year: $year, department: $department, section: $section, rollNO: $rollNO)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.profilePic == profilePic &&
        other.uid == uid &&
        other.email == email &&
        other.isAuthenticated == isAuthenticated &&
        other.year == year &&
        other.department == department &&
        other.section == section &&
        other.rollNO == rollNO;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        profilePic.hashCode ^
        uid.hashCode ^
        email.hashCode ^
        isAuthenticated.hashCode ^
        year.hashCode ^
        department.hashCode ^
        section.hashCode ^
        rollNO.hashCode;
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

enum Department { cse, aiml, aids, eee, ece, ce, me, mba, other }

/// this is used to Convert string into instance
///
/// department as Sting ➡️ department instance
Department? departmentFromString(String deptAsString) {
  for (Department e in Department.values) {
    if (e.name == deptAsString) {
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
