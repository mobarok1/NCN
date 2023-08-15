import 'package:flutter/material.dart';
import 'package:ncn/model/data_class/customer_model.dart';
import 'package:ncn/repository/customer_repository.dart';

import 'add_new_customer.dart';
import 'customer_details.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({super.key});

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  bool loading = false;
  List<CustomerModel> customerList = [];
  TextEditingController textEditingController = TextEditingController();

  getDataList() async{
    setState(() {
      loading = true;
    });
    var formData = {
      "search": textEditingController.text
    };
    customerList = await CustomerRepository.getCustomerList(formData);

    setState(() {
      loading = false;
    });
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
        title: TextFormField(
          controller: textEditingController,
          onChanged: (str){
            getDataList();
          },
          style: const TextStyle(
            color: Colors.white70
          ),
          maxLength: 15,
          decoration: const InputDecoration(
            hintText: "Customer Search",
            hintStyle: TextStyle(
              color: Colors.white60
            )
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async{
                await Navigator.push(context, MaterialPageRoute(builder: (ctx)=>const AddCustomer()));
                getDataList();
              },
              icon: const Icon(Icons.add)
          )
        ],
      ),

      body: loading?const LinearProgressIndicator(): ListView.separated(
        itemCount: customerList.length,
        itemBuilder: (ctx,i){
          return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(customerList[i].name),
                Text(customerList[i].mobile,
                  textAlign: TextAlign.end,
                )
              ],
            ),
            leading: Text(customerList[i].id.toString()),
            subtitle: Text(customerList[i].address),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (ctx)=>CustomerDetails(customerId: customerList[i].id,)));
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: 1,
          );
        },
      ),

    );
  }
}
