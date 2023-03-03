import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studentcom/pages/message_page.dart';
import 'package:studentcom/pages/splash_screen.dart';
import 'package:studentcom/pages/student_page.dart';
import 'package:studentcom/pages/teacher_page.dart';
import 'package:studentcom/reporsitory/message_repository.dart';
import 'package:studentcom/reporsitory/student_repository.dart';
import 'package:studentcom/reporsitory/teacher_repository.dart';
import 'package:studentcom/utilities/google_sign_in.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentRepository = ref.watch(studentsProvider);
    final teacherRepository = ref.watch(teachersProvider);
    var backGroundImage = false;
    final firebasePhoto = FirebaseAuth.instance.currentUser!.photoURL!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 207, 131, 220),
        title: const Text('Student Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                _goMessagePage(context);
              },
              child: Text(
                '${ref.watch(newMessageCountProvider)} new message',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                _goStudentPage(context);
              },
              child: Text(
                '${studentRepository.Students.length} student',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                _goTeacherPage(context);
              },
              child: Text('${teacherRepository.teachers.length} Teacher',
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(firebasePhoto)),
                      const SizedBox(width: 10),
                      Text(FirebaseAuth.instance.currentUser!.displayName!),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(FirebaseAuth.instance.currentUser!.email!),
                ],
              ),
            ),
            ListTile(
              title: const Text('Students'),
              onTap: () {
                _goStudentPage(context);
              },
            ),
            ListTile(
              title: const Text('Teacher'),
              onTap: () {
                _goTeacherPage(context);
              },
            ),
            ListTile(
              title: const Text('Message'),
              onTap: () {
                _goMessagePage(context);
              },
            ),
            ListTile(
              title: const Text('Sign Out'),
              onTap: () async {
                await signOutWithGoogle();
                _goSplash(context);
              },
            )
          ],
        ),
      ),
    );
  }

  void _goSplash(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SplashScreen()));
  }

  Future<void> _goMessagePage(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const MessagePage();
    }));
  }

  void _goStudentPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const StudentPage();
    }));
  }

  void _goTeacherPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const TeacherPage()));
  }
}
