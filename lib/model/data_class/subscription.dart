class SubscriptionModel{
  String artNumber,name;
  String orgStartDate,expireDate,price;
  bool invalid;

  SubscriptionModel({required this.artNumber, required this.orgStartDate,required this.name, required this.expireDate, required this.price, required this.invalid});

  factory SubscriptionModel.fromJSON(data){
    data = data['\$'];
    return SubscriptionModel(
        artNumber: data["ArtNr"],
        name: data["Name"],
        orgStartDate: data["OrgStartDate"],
        expireDate:data["ExpireDate"],
        price: data["Price"],
        invalid: data["Invalid"]=='1'
    );
  }
}