class NetworkModel{
  int id;
  String name;


  NetworkModel({required this.id, required this.name});

  factory NetworkModel.fromJSON(data){
    return NetworkModel(
        id: data["id"],
        name: data["name"]
    );
  }

}