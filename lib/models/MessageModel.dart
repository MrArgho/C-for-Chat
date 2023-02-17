class MessageModel{
  String? sender;
  String? text;
  String? seen;
  String? createdon;

  //default constructor
  MessageModel({this.sender, this.text, this.seen, this.createdon});

  //map constructor to collect data from DB
  MessageModel.fromMap(Map<String, dynamic> map){
    sender = map["sender"];
    text = map["text"];
    seen =map["seen"];
    createdon=map["createdon"].toDate();
  }

  //map constructor to store data to DB
  Map<String, dynamic>toMap(){
    return {
      "sender":sender,
      "text":text,
      "seen":seen,
      "createdon":createdon
    };
  }
}