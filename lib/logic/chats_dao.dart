
import 'package:sqflite/sqflite.dart';
import 'package:whatsapp_reader/models/chat_model.dart';
import 'package:whatsapp_reader/models/chats.dart';

class ChatsDao {

  static final ChatsDao _chatsDao = ChatsDao._internal();

  static const initQueries = [
    'CREATE TABLE messages (epoch INTEGER, message TEXT, sender TEXT, type TEXT, chatName TEXT)',
    'create index type_index on messages(type)',
    'create index chat_index on messages(chatName)',
    'CREATE TABLE chats (name TEXT, lastMessage TEXT, lastMessageTime INTEGER)'
  ];

  factory ChatsDao() {
    return _chatsDao;
  }

  ChatsDao._internal();

  Database db;

  Future init() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + "/demo.db";
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          initQueries.forEach((element) async {
            await db.execute(element);
          });
        });
  }

  insertChatMessage(ChatMessage chat) async {
    try {
      db.insert('messages', chat.toMap());
    }
    on Exception {}
  }

  insertChat(ChatModel chat) async {
    try {
      db.insert('chats', chat.toMap());
    }
    on Exception {}
  }

  Future<List<ChatModel>> getChats() async {
    var chatsFuture = await db.rawQuery('SELECT * FROM chats ORDER BY lastMessageTime DESC');
    return Future.value(chatsFuture.map((e) => ChatModel.fromMap(e)).toList());
  }

  Future<List<ChatMessage>> getMessages(String chatName) async {
    var chatsFuture = await db.rawQuery('SELECT * FROM messages where chatName = "$chatName" ORDER BY epoch');
    return Future.value(chatsFuture.map((e) => ChatMessage.fromMap(e)).toList());
  }

}