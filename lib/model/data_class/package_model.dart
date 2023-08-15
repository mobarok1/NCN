class PackageModel{
  String artcleId,name, period, price;

  PackageModel({required this.artcleId, required this.name, required this.period, required this.price});

  factory PackageModel.fromJSON(data){
    data = data['\$'];
    return PackageModel(
      artcleId: data["ArtNr"],
      name: data["Name"],
      period: data["Period"],
      price: data["Price"],
    );
  }

}
