import 'package:flutter/material.dart';
import 'package:ncn/model/data_class/customer_model.dart';
import 'package:ncn/page/subpage/customer_balance.dart';
import 'package:ncn/page/subpage/customer_device.dart';
import 'package:ncn/page/subpage/personal_info.dart';

class CustomerDetails extends StatefulWidget {
  final CustomerModel customer;
  const CustomerDetails({super.key,required this.customer});

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> with TickerProviderStateMixin{
  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController =TabController(length: 3,vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Details"),
        bottom: TabBar(
            controller: tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(
                text: "Personal",
              ),
              Tab(
                text: "Device",
              ),
              Tab(
                text: "Balance",
              )
            ]
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          CustomerPersonalInfo(customerModel: widget.customer,),
          CustomerDevice(
            customer: widget.customer,
            onUpdate: () {  },
          ),
          CustomerBalance(customerId: widget.customer.customerId)
        ],
      ),
    );
  }
}
