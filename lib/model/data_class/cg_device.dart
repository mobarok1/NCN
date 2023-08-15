class CGDeviceModel{
  String number,cardType,note;
  bool connected;
  DateTime addedTime;
  CGDeviceModel({required this.number, required this.cardType, required this.addedTime,required this.connected,required this.note});

  factory CGDeviceModel.fromJSON(data){
    data = data['\$'];
    return CGDeviceModel(
        number: data["Number"],
        cardType: data["CardType"],
        connected: data["Connected"]!='0',
        note: data["Comment"],
        addedTime: DateTime.parse(data["TimeAdded"])
    );
  }
}