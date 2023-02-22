class ChatRoomModel{
  String? chatroomid;
  Map<String,dynamic>? participants;
  String? lastMessage;
  List<dynamic>? users;
  DateTime? createdon;

  //default constructor
  ChatRoomModel({this.chatroomid, this.participants, this.lastMessage,this.users,this.createdon});

  //map constructor to collect data from DB
  ChatRoomModel.fromMap(Map<String, dynamic>map){
    chatroomid=map["chatroomid"];
    participants=map["participants"];
    lastMessage=map["lastmessage"];
    users = map["users"];
    createdon = map["createdon"].toDate();
  }

  //map constructor to store data to DB
  Map<String,dynamic>toMap(){
    return{
      "chatroomid":chatroomid,
      "participants":participants,
      "lastmessage":lastMessage,
      "users":users,
      "createdon":createdon,
    };
  }
}