class PreRechargeModel{
  String deviceCASID,netName,resellerBuy;
  double boxPrice,downPayment,paid,dueAmount,customerRate,monthlyPayment,monthlyDue,resellerCommission,installmentFromReseller;

  PreRechargeModel({
      required this.deviceCASID,
      required this.netName,
      required this.resellerBuy,
      required this.boxPrice,
      required this.downPayment,
      required this.paid,
      required this.dueAmount,
      required this.customerRate,
      required this.monthlyPayment,
      required this.monthlyDue,
      required this.resellerCommission,
      required this.installmentFromReseller});

  factory PreRechargeModel.fromJSON(data){
    return PreRechargeModel(
        deviceCASID: data["deviceCASID"],
        netName: data["netName"],
        resellerBuy: data["resellerBuy"],
        boxPrice: data["boxPrice"].toDouble(),
        downPayment: data["downPayment"].toDouble(),
        paid: data["paid"].toDouble(),
        dueAmount: data["dueAmount"].toDouble(),
        customerRate: data["customerRate"].toDouble(),
        monthlyPayment: data["monthPayment"].toDouble(),
        monthlyDue: data["monthlyDue"].toDouble(),
        resellerCommission: data["resellerComission"].toDouble(),
        installmentFromReseller: data["boxInstallmentFromReseller"].toDouble()
    );
  }

}