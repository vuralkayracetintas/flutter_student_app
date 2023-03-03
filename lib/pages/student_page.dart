import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studentcom/models/student.dart';
import 'package:studentcom/reporsitory/student_repository.dart';

class StudentPage extends ConsumerWidget {
  const StudentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsRepository = ref.watch(studentsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Students')),
      body: Column(
        children: [
          PhysicalModel(
            borderRadius: BorderRadius.circular(50),
            color: const Color.fromARGB(255, 207, 131, 220),
            elevation: 20,
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
                child: Text('${studentsRepository.Students.length} Students'),
              ),
            ),
          ),
          Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) => StudentRow(
                        studentsRepository.Students[index],
                      ),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: studentsRepository.Students.length))
        ],
      ),
    );
  }
}

class StudentRow extends ConsumerWidget {
  final Student student;

  const StudentRow(
    this.student, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var seviyorMuyum = ref.watch(studentsProvider).doILove(student);
    return ListTile(
      title: Text('${student.name} ${student.surname}'),
      leading: IntrinsicWidth(
        child: Center(
          child: Text(
            student.gender == 'female' ? '🤵🏼‍♀️' : '👨🏼‍💼',
            style: const TextStyle(fontSize: 30),
          ),
        ),
      ),
      trailing: IconButton(
          onPressed: () {
            ref.read(studentsProvider).love(student, !seviyorMuyum);
          },
          icon: Icon(
            seviyorMuyum ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          )),
    );
  }
}
