import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studentcom/models/teacher.dart';
import 'package:studentcom/pages/teacher_form_page.dart';
import 'package:studentcom/reporsitory/teacher_repository.dart';

class TeacherPage extends ConsumerWidget {
  const TeacherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teacherRepository = ref.watch(teachersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Teacher')),
      body: Column(
        children: [
          PhysicalModel(
            borderRadius: BorderRadius.circular(50),
            color: Colors.grey,
            elevation: 20,
            child: Stack(children: [
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
                  child: Hero(
                    tag: 'teacherButton',
                    child: Material(
                      color: Colors.transparent,
                      child:
                          Text('${teacherRepository.teachers.length} Teacher'),
                    ),
                  ),
                ),
              ),
              const Align(
                widthFactor: 30,
                alignment: Alignment(0.9, 0.8),
                child: TeacherDownloadButton(),
              )
            ]),
          ),
          Expanded(
              child: RefreshIndicator(
            onRefresh: () async {
              ref.watch(teacherListProvide);
              ref.read(teachersProvider).download();
            },
            child: ref.watch(teacherListProvide).when(
                  data: (data) => ListView.separated(
                    itemBuilder: (context, index) => TeacherRow(
                      data[index],
                    ),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: data.length,
                  ),
                  error: (error, stackTrace) {
                    return const SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Text('error'),
                    );
                  },
                  loading: () {
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        onPressed: () async {
          final created = await Navigator.of(context).push<bool>(
              MaterialPageRoute(builder: (context) => const TeacherFormPage()));
          if (created == true) {
            print('update teacher');
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TeacherDownloadButton extends StatefulWidget {
  const TeacherDownloadButton({
    Key? key,
  }) : super(key: key);

  @override
  State<TeacherDownloadButton> createState() => _TeacherDownloadButtonState();
}

class _TeacherDownloadButtonState extends State<TeacherDownloadButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return isLoading
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : IconButton(
              icon: const Icon(
                Icons.download,
              ),
              onPressed: () async {
                try {
                  setState(() {
                    isLoading = true;
                  });
                  await ref.read(teachersProvider).download();
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                } finally {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
            );
    });
  }
}

class TeacherRow extends ConsumerWidget {
  final Teacher teacher;
  const TeacherRow(
    this.teacher, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text('${teacher.name} ${teacher.surname}'),
      leading: Text(
        teacher.gender == 'male' ? '👨🏼' : '🤵🏼‍♀️',
        style: const TextStyle(fontSize: 30),
      ),
    );
  }
}
