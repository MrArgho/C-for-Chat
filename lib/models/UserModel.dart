class UserModel {
  String? uid;
  String? fullname;
  String? email;
  String? profilepic;

  //default constructor
  UserModel({this.uid, this.fullname, this.email, this.profilepic });

  //map constructor to collect data from DB
  UserModel.fromMap(Map<String, dynamic> map){
    uid = map["uid"];
    fullname = map["fullname"];
    email =map["email"];
    profilepic=map["profilepic"];
  }

  //map constructor to store data to DB
  Map<String, dynamic>toMap(){
    return {
      "uid":uid,
      "fullname":fullname,
      "email":email,
      "profilepic":profilepic
    };
  }
}

