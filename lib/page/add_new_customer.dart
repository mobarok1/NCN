import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ncn/model/api/customer_api.dart';
import 'package:ncn/page/customer_details.dart';
import 'package:ncn/utils/constant.dart';

import '../model/data_class/customer_model.dart';
import '../model/data_class/response_model.dart';
import '../repository/customer_repository.dart';
class AddCustomer extends StatefulWidget {
  const AddCustomer({super.key});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController customerName = TextEditingController();
  final TextEditingController customerMobileNumber = TextEditingController();
  final TextEditingController address = TextEditingController();

  bool loading = false;


  addNewCustomer() async{
    var formData = {
      "name": customerName.text,
      "phone": customerMobileNumber.text,
      "address": address.text,
      "network":1
    };
    setState(() {
      loading = true;
    });
    ResponseModel response = await CustomerAPI.addNewCustomer(formData);
    setState(() {
      loading = false;
    });
    if(response.statusCode==201){
      if(!mounted) return;
      var body = response.body;
      if(body!=""){
        String id = jsonDecode(body)["userId"].toString();
        CustomerModel? customerModel = await CustomerRepository.getCustomerDetails(id);
        if(!mounted) return;
        if(customerModel!=null){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CustomerDetails(customer: customerModel, )));
        }

      }else{
          Navigator.pop(context);
      }

    }else{
      if(!mounted) return;
      showDialog(context: context,
          builder: (ctx){
            String message = "Failed to add customer";
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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Device"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                top: 10,
                bottom: 5
            ),
            child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                        onPressed: (){
                          if(formKey.currentState!.validate()){
                              addNewCustomer();

                          }
                        },
                        style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
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
                        child: loading?const Center(child: CircularProgressIndicator(),): const Text("Create Customer",style: TextStyle(color: Colors.white),)
                    )
                  ],
                ),
              ),
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
