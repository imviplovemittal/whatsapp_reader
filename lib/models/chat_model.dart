class ChatModel {
  final String name;
  final String lastMessage;
  final int lastMessageTime;

  const ChatModel(this.name, this.lastMessage, this.lastMessageTime);

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  ChatModel copyWith({
    String name,
    String lastMessage,
    int lastMessageTime,
  }) {
    if ((name == null || identical(name, this.name)) &&
        (lastMessage == null || identical(lastMessage, this.lastMessage)) &&
        (lastMessageTime == null || identical(lastMessageTime, this.lastMessageTime))) {
      return this;
    }

    return new ChatModel(
      name ?? this.name,
      lastMessage ?? this.lastMessage,
      lastMessageTime ?? this.lastMessageTime,
    );
  }

  @override
  String toString() {
    return 'ChatModel{name: $name, lastMessage: $lastMessage, lastMessageTime: $lastMessageTime}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          lastMessage == other.lastMessage &&
          lastMessageTime == other.lastMessageTime);

  @override
  int get hashCode => name.hashCode ^ lastMessage.hashCode ^ lastMessageTime.hashCode;

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return new ChatModel(
      map['name'] as String,
      map['lastMessage'] as String,
      map['lastMessageTime'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'name': this.name,
      'lastMessage': this.lastMessage,
      'lastMessageTime': this.lastMessageTime,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

List<ChatModel> getSampleChats() {
  return [ChatModel("Viplove", "Viplove's last message", 9909809392479), ChatModel("Best Group", "Best group's last message", 897685745646)];
}
