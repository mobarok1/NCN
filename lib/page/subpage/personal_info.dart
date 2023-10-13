import 'package:flutter/material.dart';
import '../../model/data_class/customer_model.dart';
import '../../repository/customer_repository.dart';
import '../view/update_customer.dart';

class CustomerPersonalInfo extends StatefulWidget {
  final CustomerModel customerModel;
  const CustomerPersonalInfo({super.key,required this.customerModel});

  @override
  State<CustomerPersonalInfo> createState() => _CustomerPersonalInfoState();
}

class _CustomerPersonalInfoState extends State<CustomerPersonalInfo> {
  bool loading = false;
  CustomerModel? customerModel;

  getCustomerModel() async{
    setState(() {
      loading = true;
    });
    customerModel = await CustomerRepository.getCustomerDetails(widget.customerModel.customerId);

    if(!mounted) return;
    setState(() {
      loading = false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCustomerModel();
  }


  @override
  Widget build(BuildContext context) {
    return loading?const Center(
      child: CircularProgressIndicator(),
    ): customerModel==null?
    const Center(
        child: Text("Failed to load info"),
      ): ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 20,
              top: 10
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Personal Info",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const Divider(),
              TextFormField(
                initialValue: customerModel!.customerId,
                readOnly: true,
                decoration: const InputDecoration(
                    label: Text("Customer ID"),
                    prefixIcon: Icon(Icons.key)
                ),
              ),
              TextFormField(
                initialValue: customerModel!.customerName,
                readOnly: true,
                decoration: const InputDecoration(
                    label: Text("Customer Name"),
                    prefixIcon: Icon(Icons.person),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black12
                      )
                    )
                ),
              ),
              TextFormField(
                initialValue: customerModel!.mobile,
                readOnly: true,
                decoration: const InputDecoration(
                    label: Text("Mobile No"),
                    prefixIcon: Icon(Icons.call_rounded)
                ),
              ),
              TextFormField(
                initialValue: customerModel!.address,
                readOnly: true,
                decoration: const InputDecoration(
                    label: Text("Address"),
                    prefixIcon: Icon(Icons.location_history)
                ),
              ),
              TextFormField(
                initialValue: customerModel!.netName,
                readOnly: true,
                decoration: const InputDecoration(
                    label: Text("Feed Network"),
                    prefixIcon: Icon(Icons.account_tree)
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                  onPressed: (){
                    showDialog(
                        context: context,
                        builder: (ctx){
                          return AlertDialog(
                            scrollable: true,
                            content: UpdateCustomer(
                              customerModel: customerModel!,
                              onDone: () {
                                getCustomerModel();
                              },
                            ),
                          );
                        }
                    );
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Colors.green[900]
                      ),
                      padding: const MaterialStatePropertyAll(
                          EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15
                          )
                      )
                  ),
                  icon: const Icon(Icons.edit_note,color: Colors.white,size: 18,),
                  label: const Text("Update",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  )
              ),
            ],
          ),
        )
      ],
    );
  }
}
