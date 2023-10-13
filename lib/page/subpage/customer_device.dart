import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ncn/page/subpage/recharge_device.dart';

import '../../model/api/customer_api.dart';
import '../../model/api/subscription_api.dart';
import '../../model/data_class/customer_model.dart';
import '../../model/data_class/response_model.dart';
import '../../repository/customer_repository.dart';
import '../../utils/constant.dart';

class CustomerDevice extends StatefulWidget {
  final CustomerModel customer;
  final VoidCallback onUpdate;
  const CustomerDevice({super.key,required this.customer, required this.onUpdate,});

  @override
  State<CustomerDevice> createState() => _CustomerDeviceState();
}

class _CustomerDeviceState extends State<CustomerDevice> {
  late CustomerModel customer;
  bool loading = false;
  // getCustomerCustomerDevice() async{
  //   setState(() {
  //     loading = true;
  //   });
  //   customerDevices = await DeviceSubscriptionRepository.getCustomerDevices(customer.customerId);
  //   if(!mounted) return;
  //   setState(() {
  //     loading = false;
  //   });
  // }
  
  loadCustomer() async{
    setState(() {
      loading = true;
    });
    var res = await CustomerRepository.getCustomerDetails(customer.customerId);
    if(res != null){
      customer = res;
    }
    setState(() {
      loading = false;
    });
  }

  addNewDevice(formData) async{

    setState(() {
      loading = true;
    });
    ResponseModel response = await CustomerAPI.addNewCustomerDevice(formData);
    setState(() {
      loading = false;
    });
    if(response.statusCode==201){
      Fluttertoast.showToast(msg: "Device Added");
      loadCustomer();
    }else if(response.statusCode==209){
      Fluttertoast.showToast(msg: "Device Already Added");
    }else{
      String message = "Failed to Add";
      if(response.body != null){
        var body = response.body;
        if(body!=""){
          message = body;
        }
      }
      Fluttertoast.showToast(msg: message);
    }
  }

  stopSubscription(String deviceId,String articleNumber) async {
    var formData = {
      "deviceid": deviceId,
      "packageArticleNumber": articleNumber
    };
    setState(() {
      loading = true;
    });
    ResponseModel response = await SubscriptionAPI.stopPackage(formData);
    setState(() {
      loading = false;
    });
    if (response.statusCode == 202) {
      if (!mounted) return;
      loadCustomer();
    } else {
      if (!mounted) return;
      showDialog(context: context,
          builder: (ctx) {
            String message = "Failed to stop subscription";
            if (response.body != null) {
              var body = response.body;
              if (body != "") {
                message = body;
              }
            }
            return AlertDialog(
              title: const Text("Message"),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      loadCustomer();
                    },
                    child: const Text("Close")
                ),

              ],
            );
          }
      );
    }
  }

  @override
  void initState() {
    customer = widget.customer;
    loadCustomer();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return loading?const Center(
      child: CircularProgressIndicator(),
    ):Column(
      children: [
        Flexible(
          child: loading?const Center(
            child: CircularProgressIndicator(),
          ): customer.deviceCASID.isNotEmpty?SingleChildScrollView(
            child: InkWell(
              onTap: (){
              },
              child: Column(
                children: [
                  TextFormField(
                    initialValue: customer.deviceCASID,
                    readOnly: true,
                    decoration: const InputDecoration(
                        label: Text("CAS ID"),
                        prefixIcon: Icon(Icons.security)
                    ),
                  ),
                  TextFormField(
                    initialValue:customer.deviceSaleDate!=null? DateFormat("yyyy-MM-dd hh:mm a").format(customer.deviceSaleDate!):"N/A",
                    readOnly: true,
                    decoration: const InputDecoration(
                        label: Text("Added On"),
                        prefixIcon: Icon(Icons.add_alarm)

                    ),
                  ),
                  TextFormField(
                    initialValue: "${customer.boxPrice} (${customer.boxType}) (NetPrice: ${customer.feedBoxPrice})",
                    readOnly: true,
                    decoration: const InputDecoration(
                        label: Text("Box Price"),
                        prefixIcon: Icon(Icons.shopping_cart)
                    ),
                  ),
                  TextFormField(
                    initialValue: "${customer.paid} BDT",
                    readOnly: true,
                    decoration: const InputDecoration(
                        label: Text("Box Paid"),
                        prefixIcon: Icon(Icons.payment)
                    ),
                  ),
                  TextFormField(
                    initialValue: "${customer.dueAmount} BDT",
                    readOnly: true,
                    style: TextStyle(
                        color: (customer.boxPrice-customer.paid) > 0? Colors.red:Colors.green,
                        fontWeight: FontWeight.bold
                    ),
                    decoration: const InputDecoration(
                        label: Text("Box Due"),
                        prefixIcon: Icon(Icons.payment)
                    ),
                  ),
                  TextFormField(
                    initialValue:customer.subsExpire==null?"N/A": DateFormat("yyyy-MM-dd").format(customer.subsExpire!),
                    readOnly: true,
                    style: TextStyle(
                        color: customer.subsExpire!=null? customer.subsExpire!.isBefore(DateTime.now())?Colors.red:Colors.green:Colors.red,
                        fontWeight: FontWeight.bold
                    ),
                    decoration:  const InputDecoration(
                        label: Text("Subs. Expire",
                          style: TextStyle(

                          ),
                        ),
                        prefixIcon: Icon(Icons.timer)
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton.icon(
                      onPressed: (){
                        showDialog(
                            context: context,
                            builder: (ctx){
                              return AlertDialog(
                                title: const Text("Recharge",
                                  style: TextStyle(

                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                content: RechargeDevice(
                                  customer,
                                  onRecharge: () {
                                      loadCustomer();
                                  },
                                ),
                              );
                            }
                        );
                      },
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              mainColor
                          ),
                          padding: MaterialStatePropertyAll(
                              EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15
                              )
                          )
                      ),
                      icon: const Icon(Icons.subscriptions,color: Colors.white,size: 18,),
                      label: const Text("Renew / Recharge",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      )
                  ),
                ],
              ),
            ),
          ):const Text(
              "No Device Found"
          ),
        )
      ],
    );
  }
}