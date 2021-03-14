import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_reader/logic/chats_dao.dart';
import 'package:whatsapp_reader/models/chat_model.dart';
import 'package:whatsapp_reader/models/chats.dart';

class ProcessFiles {
  static uploadAndProcessChatsFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(allowedExtensions: ['txt'], type: FileType.custom);
    String msgs = "";
    if (result != null) {
      File file = File(result.files.single.path);
      PlatformFile f = result.files.first;
      String chatName = f.name.split('WhatsApp Chat with ')[1].split('.txt')[0];
      String data = await file.readAsString();

      var messages = <ChatMessage>[];

      LineSplitter.split(data).forEach((line) async {
        if (line.isNotEmpty && line.length > 3 && line[2] == '/') {
          var date = DateFormat(r'''dd/MM/yy, hh:mm a''')
                  .parse(line.split(' - ').first.toUpperCase())
                  .add(Duration(milliseconds: DateTime(1970 + 2000).millisecondsSinceEpoch))
                  .millisecondsSinceEpoch +
              19800000;
          if (messages.length > 0 && messages.last.epoch == date) date++;

          String sender;

          String msg = line.split(' - ').sublist(1).join(' - ');
          if (msg.split(': ').length > 1) {
            sender = msg.split(': ').first;
            msg = msg.split(': ').sublist(1).join(': ');
          }

          msgs += "$date\n";
          msgs += line += "\n";
          messages.add(ChatMessage(
            epoch: date,
            message: msg,
            sender: sender,
            type: sender == null ? ChatType.INFO : ChatType.MESSAGE,
            chatName: chatName,
          ));
          // database.insert("chats", {'epoch': date, 'message': line});
        } else {
          msgs += line += "\n";
          final lastMsg = messages.last;
          messages[messages.length - 1] = ChatMessage(
            epoch: lastMsg.epoch,
            message: lastMsg.message + "$line",
            sender: lastMsg.sender,
            type: lastMsg.type,
            chatName: lastMsg.chatName,
          );
        }
      });

      var chatsDao = ChatsDao();
      await chatsDao.init();

      messages.forEach((chatMessage) {
        chatsDao.insertChatMessage(chatMessage);
      });

      var lastMessage = messages.where((element) => element.type == ChatType.MESSAGE).last;

      chatsDao.insertChat(ChatModel(chatName, lastMessage.message, lastMessage.epoch));

    }
  }
}
