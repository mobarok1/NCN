import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ncn/model/data_class/customer_model.dart';
import 'package:ncn/model/data_class/subscription.dart';
import 'package:ncn/repository/device_subscription_repository.dart';
import 'package:ncn/utils/constant.dart';
import '../model/api/subscription_api.dart';
import '../model/data_class/cg_device.dart';
import '../model/data_class/response_model.dart';
import 'add_subscription.dart';

class DeviceSubscriptions extends StatefulWidget {
  final CGDeviceModel deviceModel;
  final String customerId;
  const DeviceSubscriptions({super.key,required this.deviceModel, required this.customerId});
  @override
  State<DeviceSubscriptions> createState() => _DeviceSubscriptionsState();
}

class _DeviceSubscriptionsState extends State<DeviceSubscriptions> {
  bool loading = false;
  List<SubscriptionModel> subscriptionList = [];

  getSubscriptions() async{
    setState(() {
      loading = true;
    });

    var formData = {
      "casid": widget.deviceModel.number

    };
    subscriptionList = await DeviceSubscriptionRepository.getDeviceSubscription(formData);
    if(!mounted) return;
    setState(() {
      loading = false;
    });
  }
  stopSubscription(String deviceId,String articleNumber) async{
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
    if(response.statusCode==202){
      if(!mounted) return;
      getSubscriptions();
    }else{
      if(!mounted) return;
      showDialog(context: context,
          builder: (ctx){
            String message = "Failed to stop subscription";
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
                      getSubscriptions();
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
    getSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subscriptions"),
        actions: [
          TextButton.icon(
              onPressed: () async{
                await Navigator.push(context, MaterialPageRoute(builder: (ctx)=>AddDeviceSubscription(deviceModel: widget.deviceModel, customerId: widget.customerId,)));
                getSubscriptions();
              },
              icon: const Icon(Icons.add,color: Colors.white,),
              label: const Text("Add",style: TextStyle(color: Colors.white),),
          )
        ],
      ),
      body:loading?const Center(
        child: CircularProgressIndicator(),
      ): subscriptionList.isNotEmpty? ListView(
        children: subscriptionList.map((e) =>
            Card(
              margin: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 5,
                bottom: 10
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      initialValue: widget.deviceModel.number,
                      readOnly: true,
                      decoration: const InputDecoration(
                        label: Text("Device ID (CAS ID)"),
                          prefixIcon: Icon(Icons.security)

                      ),
                    ),
                    TextFormField(
                      initialValue: e.name,
                      readOnly: true,
                      decoration: const InputDecoration(
                          label: Text("Package Name"),
                          prefixIcon: Icon(Icons.drive_file_rename_outline)

                      ),
                    ),
                    TextFormField(
                      initialValue: e.orgStartDate,
                      readOnly: true,
                      decoration: const InputDecoration(
                        label: Text("Start Date"),
                          prefixIcon: Icon(Icons.backpack)

                      ),
                    ),
                    TextFormField(
                      initialValue: e.invalid?"Invalid":"Valid",
                      readOnly: true,
                      decoration: const InputDecoration(
                        label: Text("Status"),
                          prefixIcon: Icon(Icons.timer)

                      ),
                    ),

                    TextFormField(
                      initialValue: e.expireDate,
                      readOnly: true,
                      style: TextStyle(
                        color: Colors.red[900]
                      ),
                      decoration: const InputDecoration(
                        label: Text("Expire Date"),
                        prefixIcon: Icon(Icons.date_range)
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                              onPressed: (){
                                showDialog(
                                    context: context,
                                    builder: (ctx){
                                      return  AlertDialog(
                                        title: Text("Are you sure to stop this subscription?"),
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
                                                stopSubscription(widget.deviceModel.number, e.artNumber);
                                              },
                                              child: const Text("Yes")
                                          ),
                                        ],
                                      );
                                    }
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                  Colors.red[900]
                                )
                              ),
                              icon: const Icon(Icons.cancel,color: Colors.white,),
                              label: const Text("End",style: TextStyle(color: Colors.white),)
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Expanded(
                          child: ElevatedButton.icon(
                              onPressed: (){

                              },
                              style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      mainColor
                                  )
                              ),
                              icon: const Icon(Icons.autorenew,color: Colors.white,),
                              label: const Text("Renew",style: TextStyle(color: Colors.white),)
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
        ).toList(),
      ):
          const Center(
            child: Text("No subscription found"),
          )
    );
  }
}
