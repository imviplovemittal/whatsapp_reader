import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_reader/logic/chats_dao.dart';
import 'package:whatsapp_reader/logic/process_files.dart';
import 'package:whatsapp_reader/models/chat_model.dart';
import 'package:whatsapp_reader/views/chat_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ChatModel> chats = [];
  ChatsDao chatsDao = ChatsDao();

  Future<List<ChatModel>> getChats() async {
    await chatsDao.init();
    return chatsDao.getChats();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xff171719),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    SizedBox(
                      height: 160,
                    ),
                    Text(
                      "Messages",
                      style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        await ProcessFiles.uploadAndProcessChatsFile();
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Color(0xff444446), borderRadius: BorderRadius.circular(12)),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Row(
                        children: [
                          Text(
                            "Recent",
                            style: TextStyle(color: Colors.black45, fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          Spacer(),
                          Icon(
                            Icons.more_vert,
                            color: Colors.black45,
                          )
                        ],
                      ),
                    ),
                    FutureBuilder<List<ChatModel>>(
                      future: getChats(),
                      builder: (BuildContext context, AsyncSnapshot<List<ChatModel>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          var chats = snapshot.data;
                          return ListView.builder(
                            physics: ClampingScrollPhysics(),
                            itemCount: snapshot.data.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ChatTile(chats[index].name, chats[index].lastMessage, chats[index].lastMessageTime);
                            },
                          );
                        } else {
                          return LinearProgressIndicator();
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final int lastMessageTime;

  final DateFormat dateFormat = DateFormat("dd/MM/yy hh:mm aa");

  ChatTile(this.name, this.lastMessage, this.lastMessageTime);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      chatName: name,
                    )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.network(
                "https://cdn-images.zety.com/authors/christian_eilers_1.jpg",
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(color: Colors.black87, fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    lastMessage,
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                ],
              ),
            ),
            Container(
              child: Text(dateFormat.format(DateTime.fromMicrosecondsSinceEpoch(lastMessageTime))),
            )
          ],
        ),
      ),
    );
  }
}
