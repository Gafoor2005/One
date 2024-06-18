import 'dart:developer';

enum Department {
  //       "01": "CE",
  //       "02": "EEE",
  //       "03": "ME",
  //       "04": "ECE",
  //       "05": "CSE",
  //       "12": "IT",
  //       "42": "AIML",
  //       "54": "AIDS",
  //       "60": "IOT",
  ce("01"),
  eee("02"),
  me("03"),
  ece("04"),
  cse("05"),
  it("12"),
  aiml("42"),
  aids("54"),
  iot("60"),
  bsh(''),
  english(''),
  other('');

  const Department(this.code);
  final String code;
}

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

Department? departmentFromRollNumber(String rollNumber) {
  var deptCode = rollNumber.substring(6, 8);
  for (Department e in Department.values) {
    if (e.code == deptCode) {
      return e;
    }
  }
  return null;
}
