import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studentcom/models/teacher.dart';
import 'package:http/http.dart' as http;

class DataServices {
  final String baseUrl = 'https://63adecaf3e4651691667788e.mockapi.io/';

  Future<Teacher> teacherDownload() async {
    final response = await http.get(Uri.parse('$baseUrl/Teacher/1'));
    if (response.statusCode == 200) {
      return Teacher.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load teacher ${response.statusCode}');
    }
  }

  Future<void> addTeacher(Teacher teacher) async {
    await FirebaseFirestore.instance
        .collection('teachers')
        .add(teacher.toMap());
    // final response = await http.post(
    //   Uri.parse('$baseUrl/Teacher'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(teacher.toMap()),
    // );
    // if (response.statusCode == 201) {
    //   return;
    // } else {
    //   throw Exception('Failed to add teacher ${response.statusCode}');
    // }
  }

  Future<List<Teacher>> getTeacher() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('teachers').get();

    return querySnapshot.docs.map((e) => Teacher.fromMap(e.data())).toList();

    // final response = await http.get(Uri.parse('$baseUrl/Teacher'));
    // if (response.statusCode == 200) {
    //   final l = jsonDecode(response.body);
    //   return l.map<Teacher>((e) => Teacher.fromMap(e)).toList();
    // } else {
    //   throw Exception('Do not get teaches ${response.statusCode}');
    // }
  }
}

final dataServiceProvider = Provider((ref) {
  return DataServices();
});
