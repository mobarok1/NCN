import 'package:flutter/material.dart';
import 'package:ncn/model/data_class/customer_model.dart';
import '../../repository/customer_repository.dart';

class CustomerPersonalInfo extends StatefulWidget {
  final String customerId;
  const CustomerPersonalInfo({super.key,required this.customerId});

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
    customerModel = await CustomerRepository.getCustomerDetails(widget.customerId);

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
        Card(
          margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 20,
                top: 10
            ),
            child: Column(
              children: [
                TextFormField(
                  initialValue: customerModel!.id,
                  readOnly: true,
                  decoration: const InputDecoration(
                      label: Text("Customer ID"),
                      prefixIcon: Icon(Icons.key)
                  ),
                ),
                TextFormField(
                  initialValue: customerModel!.name,
                  readOnly: true,
                  decoration: const InputDecoration(
                      label: Text("Customer Name"),
                      prefixIcon: Icon(Icons.person)
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
                  initialValue: customerModel!.netId,
                  readOnly: true,
                  decoration: const InputDecoration(
                      label: Text("Feed Network"),
                      prefixIcon: Icon(Icons.account_tree)
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
