import 'package:client/controller/chat_controller.dart';
import 'package:client/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// !NOTE: Server socket.io version should be less than 2.4.1
//can use new flag table to tract recent message and seen status
void main() {
  runApp(
    GetMaterialApp(
      home: ChatApp(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepOrange.shade900,
        primarySwatch: Colors.deepOrange,
      ),
    ),
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
}

class ChatApp extends StatelessWidget {
  ChatApp({Key? key}) : super(key: key);
  final ChatController controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38.0),
              child: TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  hintText: "Enter your name here",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 38.0,
                vertical: 10,
              ),
              child: ElevatedButton(
                onPressed: () {
                  controller.me = controller.nameController.text;
                  Get.offAll(const HomePage());
                },
                child: const Text("Begin"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 60),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
