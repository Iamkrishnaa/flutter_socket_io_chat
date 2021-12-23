import 'package:client/controller/chat_controller.dart';
import 'package:client/models/user.dart';
import 'package:client/views/user_conversation_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    controller.connect();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tei Chat"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                // socket.emit(
                //   "message",
                //   jsonEncode(
                //     {"message": "Hello, Pathako xu hai", "name": "Krishna"},
                //   ),
                // );
              },
              icon: const Icon(
                Icons.refresh,
              )),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.chatUsers.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 16),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  User currentUser = controller.chatUsers[index];
                  return GestureDetector(
                    onTap: () {
                      controller.selectedUser = currentUser;
                      Get.to(() => ChatPage());
                    },
                    child: UserConversationList(
                      name: currentUser.userName,
                      message: currentUser.message,
                      profileImage: currentUser.profileImage,
                      lastTime: currentUser.lastTime,
                      isMessageRead: (index == 0 || index == 3) ? true : false,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
