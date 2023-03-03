// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studentcom/models/message.dart';

import 'package:studentcom/reporsitory/message_repository.dart';

class MessagePage extends ConsumerStatefulWidget {
  const MessagePage({super.key});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends ConsumerState<MessagePage> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then(
        (value) => ref.read(newMessageCountProvider.notifier).resetMessage());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final messageRepository = ref.watch(messageProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Message Page'),
          backgroundColor: const Color.fromARGB(255, 207, 131, 220),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: messageRepository.messages.length,
                itemBuilder: (context, index) {
                  return MessageView(
                      messages: messageRepository.messages[
                          messageRepository.messages.length - index - 1]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                    border: Border(
                  top: BorderSide(color: Colors.black),
                )),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 10, bottom: 15),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(20.0))),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(2),
                        ),
                        onPressed: () => {},
                        child: const Icon(
                          size: 20,
                          Icons.send,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class MessageView extends StatelessWidget {
  final Message messages;
  const MessageView({
    Key? key,
    required this.messages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: messages.sender == 'Ali'
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.purple.shade100,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(messages.text,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
