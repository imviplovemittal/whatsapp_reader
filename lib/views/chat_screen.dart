import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_reader/logic/chats_dao.dart';
import 'package:whatsapp_reader/models/chats.dart';

class ChatScreen extends StatefulWidget {
  final String chatName;

  const ChatScreen({this.chatName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatsDao chatsDao = ChatsDao();
  List<ChatMessage> messages = [];
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatName),
      ),
      backgroundColor: Colors.black87,
      body: Container(
        child: FutureBuilder<List<ChatMessage>>(
          future: getMessages(widget.chatName),
          builder: (BuildContext context, AsyncSnapshot<List<ChatMessage>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var messages = snapshot.data;
              jumpToEnd();
              return ListView.builder(
                  controller: _controller,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return getMessageElement(messages[index]);
                  });
            } else {
              return LinearProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Future<List<ChatMessage>> getMessages(String chatName) async {
    chatsDao.init();
    return chatsDao.getMessages(chatName);
  }

  jumpToEnd() async {
    Timer(
      Duration(seconds: 2),
      () => _controller.animateTo(_controller.position.maxScrollExtent, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn),
    );
  }
}

Widget getMessageElement(ChatMessage message) {
  switch (message.type) {
    case ChatType.MESSAGE:
      return getMessage(message);
    case ChatType.INFO:
      return Center(
        child: Container(
          decoration: BoxDecoration(color: Colors.deepPurple[900], borderRadius: BorderRadius.circular(6)),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: EdgeInsets.all(5),
          child: Text(
            message.message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      );
  }
  ;
}

Widget getMessage(ChatMessage message) {
  final DateFormat dateFormat = DateFormat("dd/MM/yy hh:mm aa");
  return Container(
    decoration: BoxDecoration(
      color: message.sender == primarySender ? Colors.white70 : Colors.cyan[100],
      borderRadius: BorderRadius.circular(6),
    ),
    margin: EdgeInsets.fromLTRB(
      message.sender == primarySender ? 50 : 10,
      5,
      message.sender == primarySender ? 10 : 50,
      5,
    ),
    padding: EdgeInsets.all(5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        message.sender == primarySender
            ? Container()
            : Text(
                message.sender,
                style: TextStyle(color: Colors.deepPurple[900], fontWeight: FontWeight.w600),
              ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Text(message.message),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              dateFormat.format(
                DateTime.fromMicrosecondsSinceEpoch(message.epoch),
              ),
            ),
          ],
        )
      ],
    ),
  );
}

var primarySender = "Viplove Mittal";
