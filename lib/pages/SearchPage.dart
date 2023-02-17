import 'package:c_for_chat/models/UserModel.dart';
import 'package:c_for_chat/pages/ChatRoomPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                color: Theme.of(context).colorScheme.secondary,
                child: Text("Search"),
              ),
              SizedBox(
                height: 25,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where("email", isEqualTo: searchController.text).where("email", isNotEqualTo: widget.userModel.email)
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
                            tileColor:Colors.grey[200],
                          //selectedTileColor: Colors.black,
                          onTap: (){
                            //tap krle ei searchpage pop hoye jbe & charoom page khule jabe, pop hoa mane hocche jodi chatroom page theke back kori then direct homepage() e back krbo, searchPage() e na
                              Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context){
                                  return ChatRoomPage();
                                }
                              )
                            );
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(searchedUser.profilepic!),
                            backgroundColor: Colors.grey,
                          ),
                          title: Text(searchedUser.fullname!, style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),),
                          subtitle: Text(searchedUser.email!),
                          trailing:Icon(Icons.mark_unread_chat_alt, color: Colors.lightBlue,)
                        );
                      }
                      else{
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
