import 'package:flutter/material.dart';
import 'package:ncn/model/api/subscription_api.dart';
import 'package:ncn/model/data_class/cg_device.dart';
import 'package:ncn/model/data_class/customer_model.dart';
import 'package:ncn/model/data_class/package_model.dart';
import 'package:ncn/repository/device_subscription_repository.dart';
import 'package:ncn/utils/constant.dart';

import '../model/data_class/response_model.dart';

class AddDeviceSubscription extends StatefulWidget {
  final CGDeviceModel deviceModel;
  final String customerId;
  final int? currentSubscriptionId;
  const AddDeviceSubscription({super.key,required this.deviceModel, required this.customerId,this.currentSubscriptionId});

  @override
  State<AddDeviceSubscription> createState() => _AddDeviceSubscriptionState();
}

class _AddDeviceSubscriptionState extends State<AddDeviceSubscription> {
  final formKey = GlobalKey<FormState>();

  bool loading = false;
  List<PackageModel> packages = [];
  PackageModel? selectedPackage;

  getDataList() async{
    setState(() {
      loading = true;
    });
    var formData = {
      "deviceid": widget.deviceModel.number
    };
    packages = await DeviceSubscriptionRepository.getAvailablePackages(formData);
    if(packages.isNotEmpty){
      selectedPackage = packages.first;
    }
    setState(() {
      loading = false;
    });
  }

  addSubscription(String deviceId,String articleNumber,int days) async{
    var formData = {
      "deviceid": deviceId,
      "packageArticleNumber": articleNumber,
      "days": days
    };
    print(formData);
    setState(() {
      loading = true;
    });
    ResponseModel response = await SubscriptionAPI.subscribePackage(formData);
    setState(() {
      loading = false;
    });
    if(response.statusCode==202){
      if(!mounted) return;
      Navigator.pop(context);

    }else{
      if(!mounted) return;
      showDialog(context: context,
          builder: (ctx){
            String message = "Failed to subscribe package";
            if(response.body != null){
              var body = response.body;
              if(body!=""){
                message = body;
              }
            }
            return  AlertDialog(
              title: const Text("Message"),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
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
    // TODO: implement initState
    super.initState();
    getDataList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Subscription"),
      ),
      body: Stack(
        children: [
          ListView(
            children: packages.map((e){
              return InkWell(
                onTap: (){
                  showDialog(
                      context: context,
                      builder: (ctx){
                        return  AlertDialog(
                          scrollable: true,
                          title: const Text("Package Activation"),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Text("Package: ${e.name} for ${e.period} Month",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text("Price: ${e.price} BDT",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text("Note: Customer balance is not enough. ${e.price} BDT will deduct from your account",
                                style: const TextStyle(
                                  color: Colors.red
                                ),
                              )
                            ],
                          ),
                          actions: [
                            TextButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                  addSubscription(widget.deviceModel.number, e.artcleId,30);
                                },
                                child: const Text("Activate")
                            ),
                            TextButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                  addSubscription(widget.deviceModel.number, e.artcleId,7);
                                },
                                child: const Text("7 Days")
                            ),
                            TextButton(
                                onPressed: (){
                                  Navigator.pop(context);

                                  addSubscription(widget.deviceModel.number, e.artcleId,3);
                                },
                                child: const Text("3 Days")
                            )
                          ],
                        );
                      }
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 5,
                      bottom: 10
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: TextFormField(
                                initialValue: e.name,
                                readOnly: true,
                                enabled: false,
                                style: const TextStyle(color: mainColor),
                                decoration: const InputDecoration(
                                    label: Text("Package",style: TextStyle(color: Colors.black),),
                                    prefixIcon: Icon(Icons.backpack,color: mainColor,)

                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Flexible(
                              child:  TextFormField(
                                initialValue: "${e.period} Month",
                                readOnly: true,
                                enabled: false,
                                style: const TextStyle(color: mainColor),
                                decoration: const InputDecoration(
                                    label: Text("Validity",style: TextStyle(color: Colors.black),),
                                    prefixIcon: Icon(Icons.timer,color: mainColor,)

                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: TextFormField(
                                initialValue: e.price,
                                readOnly: true,
                                enabled: false,
                                style: const TextStyle(
                                  color: mainColor,
                                ),
                                decoration: const InputDecoration(
                                    label: Text("Price ( BDT )",style: TextStyle(color: Colors.black),),
                                    prefixIcon: Icon(Icons.date_range,color: mainColor,)
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),

                          ],
                        ),


                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          loading?Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
                color: Colors.white.withOpacity(.5),
                child: const Center(child: CircularProgressIndicator())
            ),
          ):Container()
        ],
      ),
    );
  }
}
