import 'package:flutter/material.dart';
import 'package:ncn/main.dart';
import 'package:ncn/repository/report_repository.dart';
import '../../model/api/subscription_api.dart';
import '../../model/data_class/customer_model.dart';
import '../../model/data_class/pre_recharge_model.dart';
import '../../model/data_class/response_model.dart';
import '../../repository/customer_repository.dart';
import '../../repository/device_subscription_repository.dart';
import '../../utils/constant.dart';

class RechargeDevice extends StatefulWidget {
  final VoidCallback onRecharge;
  final CustomerModel customerModel;
  const RechargeDevice(this.customerModel, {super.key, required this.onRecharge});

  @override
  State<RechargeDevice> createState() => _RechargeDeviceState();
}

class _RechargeDeviceState extends State<RechargeDevice> {
  bool loading = false;
  double balance = 0;
  PreRechargeModel? preRechargeModel;

  getCustomerBalance() async{
    setState(() {
      loading = true;
    });
    var report = await SummeryReportRepository.getSummery(userDataModel!.netId);
    if(report!=null){
      balance = report.balance;
    }else{
      balance = 0.00;
    }
    await getRechargeDetails();
    setState(() {
      loading = false;
    });
  }

  getRechargeDetails() async{
    var formData = {
      "casid": widget.customerModel.deviceCASID

    };
    preRechargeModel = await DeviceSubscriptionRepository.getRechargeDetails(formData);
  }

  renewSubscription() async{
    var formData = {
      "customerId": widget.customerModel.customerId,
      "note": "Entry: ${userDataModel!.userName}@${widget.customerModel.customerId}",
      "reference": "Feed Panel for ${widget.customerModel.customerId}",
      "casid": widget.customerModel.deviceCASID

    };
    setState(() {
      loading = true;
    });
    ResponseModel response = await SubscriptionAPI.renewPackage(formData);
    setState(() {
      loading = false;
    });
    if (response.statusCode == 202) {
      if (!mounted) return;
      widget.onRecharge();
      Navigator.pop(context);
    } else {
      if (!mounted) return;
    }
  }

  @override
  void initState() {
    super.initState();
    getCustomerBalance();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 550,
      width: 600,
      child: loading?const Center(
        child: CircularProgressIndicator(),
      ):Column(
        children: [
          Text(preRechargeModel!.deviceCASID,
            style: const TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          const Divider(),
          Flexible(
                child: Column(
                  children: [
                    getRow("Box Price", preRechargeModel!.boxPrice,2),
                    getRow("Paid", preRechargeModel!.paid,3,mainColorEnable: true,bold: true),
                    getRow("Reseller Buy", preRechargeModel!.resellerBuy,4),
                    getRow("Box Due", preRechargeModel!.dueAmount,5,red: true,bold: true),
                    getRow("Customer Rate", preRechargeModel!.customerRate,6),
                    getRow("Installment", preRechargeModel!.monthlyPayment,7),
                    getRow("Commission", preRechargeModel!.resellerCommission,8),
                  ],
                )
            ),
          Text("Due Today = ${preRechargeModel!.monthlyDue} BDT",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: mainColor
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          preRechargeModel!.monthlyDue > balance?
          const Text("Insufficient Balance",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red
            ),
            textAlign: TextAlign.center,
          ):Container(),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 20
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: preRechargeModel!.monthlyDue > balance?null: (){
                        showDialog(
                            context: context,
                            builder: (ctx){
                              return  AlertDialog(
                                title: const Text("Confirmation"),
                                content: const Text("Do you want to Recharge / Renew for 1 month?"),
                                actions: [
                                  TextButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      child: const Text("No")
                                  ),
                                  TextButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                        renewSubscription();
                                      },
                                      child: const Text("Yes")
                                  )
                                ],
                              );
                            }
                        );
                    },
                    style:  ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            preRechargeModel!.monthlyDue > balance?null: Colors.green
                        ),
                        padding: const MaterialStatePropertyAll(
                            EdgeInsets.symmetric(
                                horizontal: 10
                            )
                        )
                    ),
                    label:  Text("Renew/Recharge",style: TextStyle(
                        color: preRechargeModel!.monthlyDue > balance?null: Colors.white
                    ),),
                    icon:  Icon(Icons.battery_saver,color: preRechargeModel!.monthlyDue > balance?null: Colors.white,),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getRow(String title, value,int temp,{bool red = false,bool mainColorEnable = false,bool bold = false,}){
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5
      ),
      color: temp.isOdd? Colors.blue.withOpacity(.2):null,
      child: Row(
        children: [
          Expanded(child: Text(title)),
          const Padding(
            padding: EdgeInsets.all(4),
            child: Text(":"),
          ),
          Expanded(child: Text(value.toString(),
            style: TextStyle(
              color: red?Colors.red[900]:mainColorEnable?mainColor:null,
              fontWeight: bold?FontWeight.bold:null
            ),
          ),
          )
        ],
      ),
    );
  }
}
