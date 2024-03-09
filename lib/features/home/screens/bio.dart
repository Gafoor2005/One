// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:html/parser.dart' as parser;

class Bio {
  final String name;
  final String rollNo;
  final String dob;
  final String phone;
  final String email;
  Bio({
    required this.name,
    required this.rollNo,
    required this.dob,
    required this.phone,
    required this.email,
  });

  factory Bio.response(String html) {
    var document = parser.parse(html);
    final rollNo = document.querySelector(
        "#\\\\\\'divProfile_BioData\\\\\\' > table > tbody > tr:nth-child(2) > td:nth-child(2)");
    final name = document.querySelector(
        "#\\\\\\'divProfile_BioData\\\\\\' > table > tbody > tr:nth-child(3) > td:nth-child(2)");
    final dob = document.querySelector(
        "#\\\\\\'divProfile_BioData\\\\\\' > table > tbody > tr:nth-child(6) > td:nth-child(5)");
    final phone = document.querySelector(
        "#\\\\\\'divProfile_BioData\\\\\\' > table > tbody > tr:nth-child(12) > td:nth-child(5)");
    final email = document.querySelector(
        "#\\\\\\'divProfile_BioData\\\\\\' > table > tbody > tr:nth-child(13) > td:nth-child(2)");
    return Bio(
        name: name?.innerHtml ?? "name not found",
        rollNo: rollNo?.innerHtml ?? "roll not found",
        dob: dob?.innerHtml ?? "dob not found",
        phone: phone?.innerHtml ?? "not found",
        email: email?.innerHtml ?? "not found");
  }

  Bio copyWith({
    String? name,
    String? rollNo,
    String? dob,
    String? phone,
    String? email,
  }) {
    return Bio(
      name: name ?? this.name,
      rollNo: rollNo ?? this.rollNo,
      dob: dob ?? this.dob,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'rollNo': rollNo,
      'dob': dob,
      'phone': phone,
      'email': email,
    };
  }

  factory Bio.fromMap(Map<String, dynamic> map) {
    return Bio(
      name: map['name'] as String,
      rollNo: map['rollNo'] as String,
      dob: map['dob'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Bio.fromJson(String source) =>
      Bio.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Bio(name: $name, rollNo: $rollNo, dob: $dob, phone: $phone, email: $email)';
  }

  @override
  bool operator ==(covariant Bio other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.rollNo == rollNo &&
        other.dob == dob &&
        other.phone == phone &&
        other.email == email;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        rollNo.hashCode ^
        dob.hashCode ^
        phone.hashCode ^
        email.hashCode;
  }
}
