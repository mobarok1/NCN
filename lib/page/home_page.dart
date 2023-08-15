import 'package:flutter/material.dart';
import 'package:ncn/page/customer_list.dart';
import 'package:ncn/page/user_account.dart';
import 'package:ncn/utils/constant.dart';

import 'dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.account_circle_outlined),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (ctx)=>const AccountPage()));
          },
        ),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          const Dashboard(),
          const CustomerList(),
          Container(
           
          ),
          Container(),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(
            left: 10,right: 10,bottom: 10
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(45),
          child: BottomNavigationBar(
            showUnselectedLabels: true,
            showSelectedLabels: true,
            currentIndex: currentIndex,
            selectedItemColor: mainColor,
            unselectedItemColor: Colors.black45,
            onTap: (index){
              setState((){
                currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.supervised_user_circle),
                  label: "Customer"
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Devices"
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.battery_saver),
                  label: "Recharges"
              ),

            ],


          ),
        ),
      ),
    );
  }
}
