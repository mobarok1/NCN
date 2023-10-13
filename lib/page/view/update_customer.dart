import 'package:flutter/material.dart';

import '../../model/api/customer_api.dart';
import '../../model/data_class/customer_model.dart';
import '../../model/data_class/response_model.dart';
import '../../utils/constant.dart';

class UpdateCustomer extends StatefulWidget {
  final CustomerModel customerModel;
  final VoidCallback onDone;
  const UpdateCustomer({super.key, required this.customerModel, required this.onDone});

  @override
  State<UpdateCustomer> createState() => _UpdateCustomerState();
}

class _UpdateCustomerState extends State<UpdateCustomer> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController customerName = TextEditingController();
  final TextEditingController customerMobileNumber = TextEditingController();
  final TextEditingController address = TextEditingController();

  bool loading = false;


 updateCustomer() async{
    var formData = {
      "id":widget.customerModel.customerId,
      "name": customerName.text,
      "phone": customerMobileNumber.text,
      "address": address.text,
    };
    setState(() {
      loading = true;
    });
    ResponseModel response = await CustomerAPI.updateCustomer(formData);
    setState(() {
      loading = false;
    });
    if(response.statusCode==202){
      if(!mounted) return;
      Navigator.pop(context);
      widget.onDone();
    }else{
      if(!mounted) return;
      showDialog(context: context,
          builder: (ctx){
            String message = "Failed to update";
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
    customerName.text = widget.customerModel.customerName;
    customerMobileNumber.text = widget.customerModel.mobile;
    address.text = widget.customerModel.address;
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SizedBox(
        width: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            loading?const LinearProgressIndicator():Container(),
            const SizedBox(
              height: 35,
            ),
            TextFormField(
              controller: customerName,
              focusNode: FocusNode(),
              cursorColor: mainColor,
              validator: (str){
                if(str!.isEmpty){
                  return "Name required";
                }else{
                  return null;
                }
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                  hintText: "Customer Name",
                  labelText: "Customer Name"
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: customerMobileNumber,
              focusNode: FocusNode(),
              cursorColor: mainColor,
              maxLength: 11,
              validator: (str){
                if(str!.isEmpty){
                  return "Mobile required";
                }else if(str.length != 11){
                  return "Invalid mobile Number";
                }else{
                  return null;
                }
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone_android),
                  hintText: "Mobile Number",
                  labelText: "Mobile Number"
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            TextFormField(
              controller: address,
              focusNode: FocusNode(),
              cursorColor: mainColor,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.add_location_rounded),
                  hintText: "Address (Optional)",
                  labelText: "Address (Optional)"
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed:  loading?null:  (){
                  if(formKey.currentState!.validate()){
                    updateCustomer();

                  }
                },
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      )
                  ),
                  padding: const MaterialStatePropertyAll(
                      EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 25
                      )
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith((states){
                    if (states.contains(MaterialState.disabled)) {
                      return null;
                    } else {
                      return mainColor;
                    }
                  }),
                ),
                child: loading?const Center(child: CircularProgressIndicator(),): const Text("Update Customer",style: TextStyle(color: Colors.white),)
            )
          ],
        ),
      ),
    );
  }
}
