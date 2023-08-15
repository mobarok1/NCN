class UserModel{
  int id;
  String userName;
  String name;
  UserModel({required this.id, required this.userName,required this.name});

  factory UserModel.fromJSON(data){
    return UserModel(
        id: data["id"],
        name: data["name"],
        userName: data["userName"]
    );
  }
}