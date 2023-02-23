import 'dart:developer';

import 'package:c_for_chat/main.dart';
import 'package:c_for_chat/models/UserModel.dart';
import 'package:c_for_chat/pages/ChatRoomPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/ChatRoomModel.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchPage(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  Future<ChatRoomModel?> getChatroomModel(UserModel targerUser) async {
    ChatRoomModel? chatRoom;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.${targerUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.length != 0) {
      //chatroom already exists, then fetch the existing chats
      log("chatroom already exists");
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      chatRoom = existingChatroom;
    } else {
      //create a new chatro0m
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: "",
        participants: {
          widget.userModel.uid.toString(): true,
          targerUser.uid.toString(): true,
        },
        users: [widget.userModel.uid.toString(), targerUser.uid.toString()],
        createdon: DateTime.now(),
      );
      //save this chatroom in DB
      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());
      chatRoom = newChatroom;
      log("created a new chatro0m");
    }
    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text("Search"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(labelText: "Email Address"),
              ),
              SizedBox(
                height: 25,
              ),
              CupertinoButton(
                onPressed: () {
                  setState(() {});
                },
                color: Colors.blueGrey[900],
                //color: Theme.of(context).colorScheme.secondary,
                child: Text("Search"),
              ),
              SizedBox(
                height: 25,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where("email", isEqualTo: searchController.text)
                    .where("email", isNotEqualTo: widget.userModel.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapShot =
                          snapshot.data as QuerySnapshot;

                      if (dataSnapShot.docs.length > 0) {
                        Map<String, dynamic> userMap =
                            dataSnapShot.docs[0].data() as Map<String, dynamic>;
                        UserModel searchedUser = UserModel.fromMap(userMap);
                        return ListTile(
                            tileColor: Colors.grey[200],
                            //selectedTileColor: Colors.black,
                            onTap: () async {
                              ChatRoomModel? chatroomModel =
                                  await getChatroomModel(searchedUser);
                              if (chatroomModel != null) {
                                //tap krle ei searchpage pop hoye jbe & charoom page khule jabe, pop hoa mane hocche jodi chatroom page theke back kori then direct homepage() e back krbo, searchPage() e na
                                Navigator.pop(context);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ChatRoomPage(
                                    targetUser: searchedUser,
                                    userModel: widget.userModel,
                                    firebaseUser: widget.firebaseUser,
                                    chatroom: chatroomModel,
                                  );
                                }));
                              }
                            },
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(searchedUser.profilepic!),
                              backgroundColor: Colors.grey,
                            ),
                            title: Text(
                              searchedUser.fullname!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(searchedUser.email!),
                            trailing: Icon(
                              Icons.mark_unread_chat_alt,
                              color: Colors.blueGrey[900],
                            ));
                      } else {
                        return Text("No result Founded   :(");
                      }
                    } else if (snapshot.hasError) {
                      return Text("An Error Occured   :(");
                    } else {
                      return Text("No result Founded   :(");
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
