class TransactionModel {
  double amount;
  String reference,type,creditId,note,fromName,toName;
  DateTime transactionDate;

  TransactionModel({
    required this.amount,
    required this.reference,
    required this.creditId,
    required this.type,
    required this.transactionDate,
    required this.note,
    required this.fromName,
    required this.toName
  });

  factory TransactionModel.fromJSON(data){
    return TransactionModel(
      amount: data["amount"].toDouble()??0.0,
      reference: data["reference"],
      type: data["type"],
      creditId: data["creditId"].toString(),
      transactionDate: DateTime.parse(data["transDate"]),
      note: data["note"],
      fromName: data["debitName"]??"N/A",
      toName: data["creditName"]??"N/A",
    );
  }
}
