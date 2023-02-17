class ChatRoomModel{
  String? chatroomid;
  List<String>? participants;

  //default constructor
  ChatRoomModel({this.chatroomid, this.participants});

  //map constructor to collect data from DB
  ChatRoomModel.fromMap(Map<String, dynamic>map){
    chatroomid=map["chatroomid"];
    participants=map["participants"];
  }

  //map constructor to store data to DB
  Map<String,dynamic>toMap(){
    return{
      "chatroomid":chatroomid,
      "participants":participants
    };
  }
}