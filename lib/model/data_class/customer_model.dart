class CustomerModel {
  String customerId,customerName,mobile,address,network_id,netName;
  String deviceCASID,boxType;
  double balance,monthlyPayment,boxPrice,feedBoxPrice,downPayment,baseRate,customerRate,paid,subsBaseRate,resellerRate,dueAmount;
  DateTime? subsExpire,subsStart,deviceSaleDate;

  CustomerModel({
    required this.customerId,
    required this.customerName,
    required this.mobile,
    required this.deviceCASID,
    required this.boxType,
    required this.network_id,
    required this.netName,
    required this.balance,
    required this.monthlyPayment,
    required this.boxPrice,
    required this.downPayment,
    required this.baseRate,
    required this.customerRate,
    required this.paid,
    required this.subsBaseRate,
    required this.address,
    required this.dueAmount,
    required this.resellerRate,
    required this.feedBoxPrice,
    this.subsStart,
    this.subsExpire,
    this.deviceSaleDate
  });

  factory CustomerModel.fromJSON(data){
    return CustomerModel(
        customerId: data["customerId"].toString(),
        customerName: data["customerName"],
        mobile: data["mobile"],
        deviceCASID: data["deviceCASID"]??"",
        boxType: data["boxType"]??"",
        network_id: data["network_id"].toString(),
        balance: data["balance"].toDouble(),
        monthlyPayment: data["monthlyPayment"].toDouble()??0.0,
        boxPrice: data["boxPrice"].toDouble()??0.0,
        feedBoxPrice: data["feedBoxPrice"].toDouble()??0.0,
        downPayment: data["downPayment"].toDouble()??0.0,
        baseRate: data["baseRate"].toDouble()??0.0,
        customerRate: data["customerRate"].toDouble()??0.0,
        paid: data["paid"].toDouble()??0.0,
        dueAmount: data["dueAmount"].toDouble()??0.0,
        subsBaseRate: data["subsBaseRate"].toDouble()??0.0,
        subsStart: DateTime.tryParse(data["subsStart"]??""),
        subsExpire: DateTime.tryParse(data["subsExpire"]??""),
        deviceSaleDate: DateTime.tryParse(data["deviceSaleDate"]??""),
        netName: data["netName"],
        address: data["address"]??"",
        resellerRate: data["resellerRate"].toDouble(),
    );
  }
}