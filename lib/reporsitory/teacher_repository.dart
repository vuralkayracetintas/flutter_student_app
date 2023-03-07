// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studentcom/services/data_services.dart';
import '../models/teacher.dart';

class TeacherRepository extends ChangeNotifier {
  List<Teacher> teachers = [];
// Teacher('Burak', 'Can', 12, 'male'),
  // Teacher('Cagatay', 'Ay', 12, 'male'),
  // Teacher('Zehra', 'Cetin', 12, 'female'),
  // Teacher('Kubra', 'Turgut', 12, 'female'),
  // Teacher('Ilayda', 'Can', 12, 'female')
  final DataServices dataServices;
  TeacherRepository(this.dataServices);
  Future<void> download() async {
    Teacher teacher = await dataServices.teacherDownload();

    teachers.add(teacher);
    notifyListeners();
  }

  Future<List<Teacher>> getAll() async {
    teachers = await dataServices.getTeacher();
    return teachers;
  }
}

final teachersProvider = ChangeNotifierProvider((ref) {
  return TeacherRepository(ref.watch(dataServiceProvider));
});

final teacherListProvide = FutureProvider((ref) {
  return ref.watch(teachersProvider).getAll();
});
