class AreaModel{
  int id;
  String name;

  AreaModel({required this.id, required this.name});

  factory AreaModel.fromJSON(data){
    return AreaModel(
        id: data["id"],
        name: data["name"]
    );
  }

}