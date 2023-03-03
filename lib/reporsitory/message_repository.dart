// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studentcom/models/message.dart';

class MessageRepository extends ChangeNotifier {
  List messages = [
    Message(
        text: 'hello',
        sender: 'Ali',
        time: DateTime.now().subtract(const Duration(minutes: 3))),
    Message(
        text: 'hi',
        sender: 'Ayse',
        time: DateTime.now().subtract(const Duration(minutes: 2))),
    Message(
        text: 'how are you ?',
        sender: 'Ali',
        time: DateTime.now().subtract(const Duration(minutes: 1))),
    Message(
      text: 'i\'m fine',
      sender: 'Ayse',
      time: DateTime.now(),
    )
  ];
}

final messageProvider = ChangeNotifierProvider((ref) {
  return MessageRepository();
});

class NewMessageCount extends StateNotifier<int> {
  NewMessageCount(int state) : super(state);

  void resetMessage() {
    state = 0;
  }
}

final newMessageCountProvider =
    StateNotifierProvider<NewMessageCount, int>((ref) {
  return NewMessageCount(4);
});
