// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studentcom/models/student.dart';

class StudentRepository extends ChangeNotifier {
  List Students = [
    Student(name: 'Hasan', surname: 'Can', age: 12, gender: 'male'),
    Student(name: 'Huseyin', surname: 'Ay', age: 12, gender: 'male'),
    Student(name: 'Asli', surname: 'Cetin', age: 12, gender: 'female'),
    Student(name: 'Sila', surname: 'Turgut', age: 12, gender: 'female'),
    Student(name: 'Dursun', surname: 'Can', age: 12, gender: 'male')
  ];

  final Set<Student> myLove = {};

  void love(Student student, bool seviyorMuyum) {
    if (seviyorMuyum) {
      myLove.add(student);
    } else {
      myLove.remove(student);
    }
    notifyListeners();
  }

  bool doILove(Student student) {
    return myLove.contains(student);
  }
}

final studentsProvider = ChangeNotifierProvider((ref) {
  return StudentRepository();
});
