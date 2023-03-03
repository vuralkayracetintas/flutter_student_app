import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studentcom/models/teacher.dart';
import 'package:studentcom/services/data_services.dart';

class TeacherFormPage extends ConsumerStatefulWidget {
  const TeacherFormPage({super.key});

  @override
  _TeacherFormPageState createState() => _TeacherFormPageState();
}

class _TeacherFormPageState extends ConsumerState<TeacherFormPage> {
  final Map<String, dynamic> inputVal = {};
  final _formKey = GlobalKey<FormState>();
  bool isSaving = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('name'),
                    ),
                    validator: (value) {
                      if (value?.isNotEmpty != true) {
                        return 'name cannot be empty';
                      }
                    },
                    onSaved: (newValue) {
                      inputVal['name'] = newValue;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('surname'),
                    ),
                    validator: (value) {
                      if (value?.isNotEmpty != true) {
                        return 'surname cannot be empty';
                      }
                    },
                    onSaved: (newValue) {
                      inputVal['surname'] = newValue;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('age'),
                    ),
                    validator: (value) {
                      if (value == null || value.isNotEmpty != true) {
                        return 'age cannot be empty';
                      }
                      if (int.parse(value) == null) {
                        return 'enter int value';
                      }
                    },
                    keyboardType: TextInputType.number,
                    onSaved: (newValue) {
                      inputVal['age'] = int.parse(newValue!);
                    },
                  ),
                  DropdownButtonFormField(
                    items: const [
                      DropdownMenuItem(
                        value: 'male',
                        child: Text('male'),
                      ),
                      DropdownMenuItem(
                        value: 'female',
                        child: Text('female'),
                      )
                    ],
                    value: inputVal['gender'],
                    onChanged: (value) {
                      inputVal['gender'] = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'gender cannot be empty';
                      }
                    },
                  ),
                  SizedBox(height: 70),
                  isSaving
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () {
                            final formState = _formKey.currentState;
                            if (formState == null) return;
                            if (formState.validate() == true) {
                              formState.save();
                              print(inputVal);
                            }
                            _save();
                          },
                          child: const Text('Save'))
                ],
              )),
        ),
      ),
    );
  }

  Future<void> _save() async {
    bool finish = false;
    while (!finish) {
      try {
        setState(() {
          isSaving = true;
        });
        await reelSave();
        finish = true;
        Navigator.of(context).pop(true);
      } catch (e) {
        final snackBar = ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
        await snackBar.closed;
      } finally {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Future<void> reelSave() async {
    await ref.read(dataServiceProvider).addTeacher(Teacher.fromMap(inputVal));
  }

  void asknda() {
    CircularProgressIndicator();
  }
}
