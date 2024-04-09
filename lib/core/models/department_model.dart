enum Department {
  cse,
  aiml,
  aids,
  it,
  eee,
  ece,
  ce,
  me,
  bsh,
  other,
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
