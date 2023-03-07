import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rive/rive.dart';
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 207, 131, 220),
        title: const Text('Student Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const SizedBox(
            //   height: 200,
            //   width: 200,
            //   child: RiveAnimation.asset(
            //       'assets/animation/4342-8934-google-developer-student-clubs.riv'),
            // ),
            const SizedBox(
              height: 200,
              width: 500,
              child: RiveAnimation.asset(
                  'assets/animation/2335-4701-automatic-figma-to-flutter.riv'),
            ),
            Text('${teacherRepository.teachers.length}'),
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
              child: Hero(
                tag: 'teacherButton',
                child: Material(
                  child: Text('${teacherRepository.teachers.length} Teacher',
                      style: const TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const UserDrawerHeader(),
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

class UserDrawerHeader extends StatefulWidget {
  const UserDrawerHeader({
    super.key,
  });

  @override
  State<UserDrawerHeader> createState() => _UserDrawerHeaderState();
}

class _UserDrawerHeaderState extends State<UserDrawerHeader> {
  Future<Uint8List?>? _ppicFuture;
  @override
  void initState() {
    super.initState();
    _ppicFuture = _ppicDownload();
  }

  Future<Uint8List?> _ppicDownload() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final userRecMap = documentSnapshot.data();

    if (userRecMap == null) return null;
    if (userRecMap.containsKey('ppicref')) {
      var ppicRef = userRecMap['ppicref'];
      // ppicRef = 'ppic/eLpe6NbdqAN3k3rEwklMqBe1Z6z1.jpg';
      Uint8List? uint8list =
          await FirebaseStorage.instance.ref(ppicRef).getData();
      return uint8list;
    }
    //FirebaseStorage.instance.ref('ppics').child('$uid.jpg');
  }

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  XFile? xFile =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                  if (xFile == null) return;
                  final imagePath = xFile.path;
                  final uid = FirebaseAuth.instance.currentUser!.uid;
                  final ppicref = await FirebaseStorage.instance
                      .ref('ppic')
                      .child('$uid.jpg');

                  await ppicref.putFile(File(imagePath));
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .update({'ppicred': ppicref.fullPath});
                  _ppicFuture = _ppicDownload();
                  setState(() {});
                },
                child: FutureBuilder<Uint8List?>(
                    future: _ppicFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        final picInMemory = snapshot.data!;
                        return MovingAvatar(picInMemory: picInMemory);
                      }
                      return CircleAvatar(
                        radius: 30,
                        child: Text(
                            FirebaseAuth.instance.currentUser!.displayName![0]),
                      );
                    }),
              ),
              const SizedBox(width: 10),
              Text(FirebaseAuth.instance.currentUser!.displayName!),
            ],
          ),
          const SizedBox(height: 20),
          Text(FirebaseAuth.instance.currentUser!.email!),
        ],
      ),
    );
  }
}

class MovingAvatar extends StatefulWidget {
  const MovingAvatar({
    super.key,
    required this.picInMemory,
  });

  final Uint8List picInMemory;

  @override
  State<MovingAvatar> createState() => _MovingAvatarState();
}

class _MovingAvatarState extends State<MovingAvatar>
    with SingleTickerProviderStateMixin<MovingAvatar> {
  late Ticker _ticker;
  double animationLocation = 0.0;
  double askdja = 0.0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((Duration elapsed) {
      final angel = pi *
          elapsed.inMicroseconds /
          const Duration(seconds: 1).inMicroseconds;
      setState(() {
        animationLocation = sin(angel) * 30 + 30;
        askdja = sin(angel) * 30 + 30;
        //print(sin(angel) * 30 + 100);
      });
    });
    _ticker.start();

    // Timer(const Duration(seconds: 6), () {
    //   _ticker.stop();
    // });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: animationLocation),
      child: CircleAvatar(
        radius: 30,
        backgroundImage: MemoryImage(widget.picInMemory),
      ),
    );
  }
}
