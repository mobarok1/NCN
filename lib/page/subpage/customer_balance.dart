import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ncn/model/api/subscription_api.dart';
import 'package:ncn/repository/customer_repository.dart';
import 'package:ncn/utils/constant.dart';

class CustomerBalance extends StatefulWidget {
  final String customerId;
  const CustomerBalance({super.key,required this.customerId});

  @override
  State<CustomerBalance> createState() => _CustomerBalanceState();
}

class _CustomerBalanceState extends State<CustomerBalance> {
  bool loading = false;
  double balance = 0;

  getCustomerBalance() async{
    setState(() {
      loading = true;
    });
    balance = await CustomerRepository.getCustomerBalance(widget.customerId);
    setState(() {
      loading = false;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCustomerBalance();
  }
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height:80,
            alignment: Alignment.center,
            child:  Text("Balance: $balance BDT",
              style: TextStyle(
                color: mainColor,
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),

            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
