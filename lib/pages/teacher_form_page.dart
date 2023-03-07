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

class _TeacherFormPageState extends ConsumerState<TeacherFormPage>
    with SingleTickerProviderStateMixin {
  final Map<String, dynamic> inputVal = {};
  final _formKey = GlobalKey<FormState>();
  late final AnimationController _controller = AnimationController(vsync: this);

  final animatedTween = Tween<AlignmentGeometry>(
      begin: Alignment.centerLeft, end: Alignment.centerRight);

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
                  ScaleTransition(
                    scale: _controller,
                    child: const Icon(
                      Icons.person,
                      size: 200,
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('name'),
                    ),

                    validator: FormFieldValidator().isNotEmpty,
                    // (value) {
                    //   if (value?.isNotEmpty ?? false) {
                    //     return null;
                    //   } else {
                    //     return 'name cannot be empty';
                    //   }
                    // },
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
                      if (int.tryParse(value) == null) {
                        return 'sayisal deger';
                      }
                    },
                    keyboardType: TextInputType.number,
                    onSaved: (newValue) {
                      inputVal['age'] = int.parse(newValue!);
                    },
                    onChanged: (value) {
                      final v = double.parse(value);
                      _controller.animateTo(v / 100,
                          duration: Duration(seconds: 1));
                      print(v);
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
                  const SizedBox(height: 70),
                  isSaving
                      ? const Center(child: CircularProgressIndicator())
                      : AlignTransition(
                          alignment: animatedTween.animate(_controller),
                          child: ElevatedButton(
                              onPressed: () {
                                final formState = _formKey.currentState;
                                if (formState == null) return;
                                if (formState.validate() == true) {
                                  formState.save();
                                  print(inputVal);
                                }
                                _save();
                              },
                              child: const Text('Save')),
                        )
                ],
              )),
        ),
      ),
    );
  }

  Future<void> _save() async {
    bool finish = false;

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

  Future<void> reelSave() async {
    await ref.read(dataServiceProvider).addTeacher(Teacher.fromMap(inputVal));
  }

  void asknda() {
    const CircularProgressIndicator();
  }
}

class FormFieldValidator {
  String? isNotEmpty(String? value) {
    return (value?.isNotEmpty ?? false) ? null : ValidatorString._notEmpyt;
  }
}

class ValidatorString {
  static const _notEmpyt = 'name cannot be em';
}
