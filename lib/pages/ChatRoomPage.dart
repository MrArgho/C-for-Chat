import 'dart:developer';

import 'package:c_for_chat/main.dart';
import 'package:c_for_chat/models/ChatRoomModel.dart';
import 'package:c_for_chat/models/MessageModel.dart';
import 'package:c_for_chat/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoomPage(
      {super.key,
      required this.targetUser,
      required this.chatroom,
      required this.userModel,
      required this.firebaseUser});
  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();

  void sendMessages() async {
    String msg = messageController.text.trim();
    messageController.clear();

    if (msg != "") {
      MessageModel newMessage = MessageModel(
        messageid: uuid.v1(),
        sender: widget.userModel.uid,
        createdon: DateTime.now(),
        text: msg,
        seen: false,
      );

      //store this msg in DB
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .collection("messages")
          .doc(newMessage.messageid)
          .set(newMessage.toMap());

      widget.chatroom.lastMessage = msg;
      widget.chatroom.createdon=DateTime.now();
      FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).set(widget.chatroom.toMap());

      log("message sent   :D");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage:
                  NetworkImage(widget.targetUser.profilepic.toString()),
            ),
            SizedBox(
              width: 10,
            ),
            Text(widget.targetUser.fullname.toString()),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              //conversation will be here
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("chatrooms")
                        .doc(widget.chatroom.chatroomid)
                        .collection("messages")
                        .orderBy("createdon", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {
                          QuerySnapshot dataSnapshot = snapshot.data
                              as QuerySnapshot; //converting AsyncSnapshot into querySnapshot
                          return ListView.builder(
                            reverse: true,
                            itemCount: dataSnapshot.docs.length,
                            itemBuilder: (context, index) {
                              MessageModel currentMessage =
                                  MessageModel.fromMap(dataSnapshot.docs[index]
                                      .data() as Map<String, dynamic>);
                              return Row(
                                mainAxisAlignment: (currentMessage.sender ==
                                        widget.userModel.uid)
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 300,
                                      ),
                                      margin: EdgeInsets.symmetric(
                                        vertical: 2,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: (currentMessage.sender ==
                                            widget.userModel.uid)
                                            ? Colors.grey
                                            : Colors.blueGrey[900],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: (currentMessage.sender ==
                                                widget.userModel.uid)
                                                ? Colors.black
                                                : Colors.grey[200],
                                          ),
                                          currentMessage.text.toString())),
                                ],
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                                "An error Occured! Please check your internet connection  :)"),
                          );
                        } else {
                          return Center(
                            child: Text("Say Hi to your New Friend"),
                          );
                        }
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(55),
                child: Container(
                  color: Colors.grey[300],
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: messageController,
                          maxLines:
                              null, //eta dile keyboard e bottom-right corner e nextLine button ase
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter message"),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          sendMessages();
                        },
                        icon: Icon(
                          Icons.send,
                          //color: Theme.of(context).colorScheme.secondary,
                          color: Colors.blueGrey[900],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
