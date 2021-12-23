class ChatMessage {
  String messageContent;
  bool isMe;
  String senderName;
  String receiver;
  ChatMessage({
    required this.messageContent,
    required this.isMe,
    required this.senderName,
    required this.receiver,
  });
}
