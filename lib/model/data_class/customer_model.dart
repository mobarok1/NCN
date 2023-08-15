import 'dart:convert';

import 'package:ncn/model/data_class/area_model.dart';
import 'package:ncn/model/data_class/network_model.dart';

class CustomerModel{
  String id;
  String name;
  String mobile;
  String address;
  String netId;

  CustomerModel({required this.id, required this.name, required this.mobile, required this.address, required this.netId});

  factory CustomerModel.fromJSON(data){
    data = data['\$'];
    return CustomerModel(
        id: data["CustomerNumber"],
        name: data["CustomerName"],
        mobile: data["CustomerMobilePhone"],
        address: data["CustomerAddress"]??"",
        netId: data["NetID"],
    );
  }
}