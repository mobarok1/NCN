class UserModel{
  int id,netId;
  String userName;
  String name;
  UserModel({required this.id, required this.userName,required this.name,required this.netId});

  factory UserModel.fromJSON(data){
    return UserModel(
        id: data["id"],
        name: data["name"],
        userName: data["userName"],
        netId: data["netid"],
    );
  }
}