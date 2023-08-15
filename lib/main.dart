import 'package:flutter/material.dart';
import 'package:ncn/model/data_class/credential.dart';
import 'package:ncn/model/data_class/user_model.dart';
import 'package:ncn/page/add_new_customer.dart';
import 'package:ncn/page/customer_details.dart';
import 'package:ncn/page/customer_list.dart';
import 'package:ncn/page/login.dart';
import 'package:ncn/utils/constant.dart';

CredentialModel? credentialModel;
UserModel? userDataModel;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NazimKhan Cable Network',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          color: mainColor,
          centerTitle: false,
          elevation: 2,
          iconTheme: IconThemeData(
            color: Colors.white
          ),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold
          )
        )
      ),
      home: const LoginPage(),
    );
  }
}