import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ncn/model/data_class/cg_device.dart';
import 'package:ncn/model/data_class/customer_model.dart';
import 'package:ncn/repository/device_subscription_repository.dart';
import 'package:ncn/utils/constant.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../model/api/customer_api.dart';
import '../../model/data_class/response_model.dart';
import '../device_subscriptions.dart';

class CustomerDevice extends StatefulWidget {
  final String customerId;
  const CustomerDevice({super.key,required this.customerId});

  @override
  State<CustomerDevice> createState() => _CustomerDeviceState();
}

class _CustomerDeviceState extends State<CustomerDevice> {
  bool loading = false;
  List<CGDeviceModel> customerDevices = [];

  getCustomerCustomerDevice() async{
    setState(() {
      loading = true;
    });
    customerDevices = await DeviceSubscriptionRepository.getCustomerDevices(widget.customerId);

    setState(() {
      loading = false;
    });
  }

  addNewDevice(String casID,String stbid,String sn,String note) async{
    var formData = {
      "customerid": widget.customerId,
      "casid": casID,
      "sn":sn,
      "stbid":stbid,
      "note": "",
    };
    setState(() {
      loading = true;
    });
    ResponseModel response = await CustomerAPI.addNewCustomerDevice(formData);
    setState(() {
      loading = false;
    });
    if(response.statusCode==201){
      Fluttertoast.showToast(msg: "Device Added");
      getCustomerCustomerDevice();
    }if(response.statusCode==209){
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

  @override
  void initState() {
    super.initState();
    getCustomerCustomerDevice();
  }


  @override
  Widget build(BuildContext context) {
    return loading?const Center(
      child: CircularProgressIndicator(),
    ): customerDevices.isNotEmpty?ListView(
      children: customerDevices.map((e) =>
         InkWell(
           onTap: (){

           },
           child: Card(
             margin: const EdgeInsets.symmetric(
               horizontal: 10,
               vertical: 10
             ),
             child:  Padding(
               padding: const EdgeInsets.all(12),
               child: Column(
                 children: [
                   TextFormField(
                     initialValue: e.number,
                     readOnly: true,
                     decoration: const InputDecoration(
                       label: Text("CAS ID"),
                         prefixIcon: Icon(Icons.security)
                     ),
                   ),
                   TextFormField(
                     initialValue: e.addedTime.toString(),
                     readOnly: true,
                     decoration: const InputDecoration(
                       label: Text("Added On"),
                       prefixIcon: Icon(Icons.add_alarm)

                     ),
                   ),
                   TextFormField(
                     initialValue: e.note,
                     readOnly: true,
                     decoration: const InputDecoration(
                       label: Text("Note"),
                       prefixIcon: Icon(Icons.event_note)
                     ),
                   ),
                   const SizedBox(
                     height: 15,
                   ),
                   ElevatedButton.icon(
                       onPressed: (){
                         Navigator.push(context, MaterialPageRoute( builder: (ctx)=>DeviceSubscriptions(deviceModel: e, customerId: widget.customerId,)));
                       },
                       style: const ButtonStyle(
                         backgroundColor: MaterialStatePropertyAll(
                           mainColor
                         ),
                       ),
                       icon: const Icon(Icons.subscriptions,color: Colors.white,size: 18,),
                       label: const Text("Subscription",
                          style: TextStyle(
                            color: Colors.white
                          ),
                       )
                   )
                 ],
               ),
             ),
           ),
         )

      ).toList()):Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "No Device Found"
        ),
        const SizedBox(
          height: 25,
        ),
        ElevatedButton(
            onPressed: () async{
              try{
                var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimpleBarcodeScannerPage(),
                    ));
                res = "CAS-ID:5C:3A:A5:01:AF:EF:BF:E8,STB-ID:540155841,SN:T2209BMC903574";
                if(res != null){
                  addNewDevice(res.toString().split(",").first.replaceFirst("CAS-ID:", ""), res.toString().split(",")[1].replaceFirst("STB-ID:", ""),res.toString().split(",")[2].replaceFirst("SN:", ""),"");
                  if (kDebugMode) {
                    print(res);
                  }
                }else{
                  Fluttertoast.showToast(msg: "No Code Found");
                }

              }catch(e){
                Fluttertoast.showToast(msg: "Failed to scan QR/Bar Code");
              }

            },
            child: const Text("Add New Device")
        )
      ],
    );
  }
}