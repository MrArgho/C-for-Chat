class MessageModel{
  String? messageid;
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdon; //date & time

  //default constructor
  MessageModel({this.messageid, this.sender, this.text, this.seen, this.createdon});

  //map constructor to collect data from DB
  MessageModel.fromMap(Map<String, dynamic> map){
    messageid=map["messageid"];
    sender = map["sender"];
    text = map["text"];
    seen =map["seen"];
    createdon=map["createdon"].toDate();
  }

  //map constructor to store data to DB
  Map<String, dynamic>toMap(){
    return {
      "messageid":messageid,
      "sender":sender,
      "text":text,
      "seen":seen,
      "createdon":createdon
    };
  }
}