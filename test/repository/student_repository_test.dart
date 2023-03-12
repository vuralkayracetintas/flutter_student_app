import 'package:flutter_test/flutter_test.dart';
import 'package:studentcom/models/student.dart';
import 'package:studentcom/reporsitory/student_repository.dart';

void main() {
  test('Counter value should be incremented', () {
    final studentRepository = StudentRepository();
    final newStudent = Student(
        name: 'test name', surname: 'test surname', age: 23, gender: 'male');

    studentRepository.Students.add(newStudent);
  });
}
