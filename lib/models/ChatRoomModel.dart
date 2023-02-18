class ChatRoomModel{
  String? chatroomid;
  Map<String,dynamic>? participants;
  String? lastMessage;

  //default constructor
  ChatRoomModel({this.chatroomid, this.participants, this.lastMessage});

  //map constructor to collect data from DB
  ChatRoomModel.fromMap(Map<String, dynamic>map){
    chatroomid=map["chatroomid"];
    participants=map["participants"];
    lastMessage=map["lastmessage"];
  }

  //map constructor to store data to DB
  Map<String,dynamic>toMap(){
    return{
      "chatroomid":chatroomid,
      "participants":participants,
      "lastmessage":lastMessage,
    };
  }
}