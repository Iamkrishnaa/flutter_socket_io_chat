import 'dart:convert';

import 'package:client/models/chat_message.dart';
import 'package:client/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatController extends GetxController {
  late User selectedUser;
  late IO.Socket socket;
  var chatMessages = <ChatMessage>[].obs;
  var selectedUsersMessage = <ChatMessage>[].obs;
  String me = "";
  TextEditingController messageController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  ScrollController scrollController = ScrollController();
  var chatUsers = <User>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  void filterMessage() {
    var filteredMessages = chatMessages.where((message) {
      return message.senderName == selectedUser.userName ||
          (message.receiver == selectedUser.userName);
    }).toList();

    selectedUsersMessage.value = filteredMessages;
  }

  void connect() {
    socket = IO.io("https://gaurav.teispace.com/", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": true,
    });
    socket.connect();
    socket.onConnect((data) => print("Connected"));
    socket.emit(
      "login",
      jsonEncode(
        {"userName": me},
      ),
    );
    socket.on("receive-message", (data) {
      print(data["sender"]);
      ChatMessage receivedMessage = ChatMessage(
        messageContent: data["message"],
        isMe: false,
        senderName: data["sender"],
        receiver: me,
      );
      chatMessages.add(receivedMessage);
      filterMessage();
      scrollController.jumpTo(
        scrollController.position.maxScrollExtent + 60,
      );
    });
    socket.on("users", (users) {
      chatUsers.clear();
      for (int i = 0; i < users.length; i++) {
        if (users[i] == me) {
          continue;
        } else {
          chatUsers.add(User(
            lastTime: "20 min ago",
            message: "Hi There,",
            userName: users[i],
            profileImage: "https://krishna-adhikari.com.np/images/img2.jpg",
          ));
        }
      }
    });
  }

  void sendMessage(String receiver, String message) {
    socket.emit(
      "send_message",
      jsonEncode(
        {"senderName": me, "receiverName": receiver, "message": message},
      ),
    );
  }
}
