class SummeryReport{
  int totalCustomer,totalDevice,expireDevice;
  double balance;

  SummeryReport({required this.totalCustomer, required this.totalDevice, required this.expireDevice,required this.balance});

  factory SummeryReport.fromJSON(data){
    return SummeryReport(
        totalDevice: data["totalDevice"],
        totalCustomer: data["totalCustomer"],
        balance: data["balance"].toDouble(),
        expireDevice: data["expiredDevice"],
    );
  }
}