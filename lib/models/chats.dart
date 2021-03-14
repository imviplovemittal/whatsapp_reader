import 'package:dataclass/dataclass.dart';
import 'package:flutter/cupertino.dart';

class ChatMessage{
  final int epoch;
  final String message;
  final String sender;
  final ChatType type;
  final String chatName;


  const ChatMessage({
    @required this.epoch,
    @required this.message,
    @required this.sender,
    @required this.type,
    @required this.chatName,
  });

  ChatMessage copyWith({
    int epoch,
    String message,
    String sender,
    ChatType type,
    String chatName,
  }) {
    if ((epoch == null || identical(epoch, this.epoch)) &&
        (message == null || identical(message, this.message)) &&
        (sender == null || identical(sender, this.sender)) &&
        (type == null || identical(type, this.type)) &&
        (chatName == null || identical(chatName, this.chatName))) {
      return this;
    }

    return new ChatMessage(
      epoch: epoch ?? this.epoch,
      message: message ?? this.message,
      sender: sender ?? this.sender,
      type: type ?? this.type,
      chatName: chatName ?? this.chatName,
    );
  }

  @override
  String toString() {
    return 'ChatMessage{epoch: $epoch, message: $message, sender: $sender, type: $type, chatName: $chatName}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessage &&
          runtimeType == other.runtimeType &&
          epoch == other.epoch &&
          message == other.message &&
          sender == other.sender &&
          type == other.type &&
          chatName == other.chatName);

  @override
  int get hashCode => epoch.hashCode ^ message.hashCode ^ sender.hashCode ^ type.hashCode ^ chatName.hashCode;

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return new ChatMessage(
      epoch: map['epoch'] as int,
      message: map['message'] as String,
      sender: map['sender'] as String,
      type: (map['type'] as String == "ChatType.MESSAGE") ? ChatType.MESSAGE : ChatType.INFO,
      chatName: map['chatName'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'epoch': this.epoch,
      'message': this.message,
      'sender': this.sender,
      'type': this.type.toString(),
      'chatName': this.chatName,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

enum ChatType {
  MESSAGE,
  INFO
}