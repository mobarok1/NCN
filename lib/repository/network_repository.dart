import 'dart:convert';

import 'package:ncn/model/data_class/area_model.dart';
import 'package:ncn/model/data_class/customer_model.dart';

import '../config/api-client.dart';
import '../model/data_class/network_model.dart';
import '../model/data_class/response_model.dart';

class NetworkRepository{
  static Future<List<NetworkModel>> getNetworkList() async{
    ResponseModel responseModel = await ApiClient.get("network");
    List<NetworkModel> networks = [];
    if(responseModel.statusCode ==200){
      
      for(var d in jsonDecode(responseModel.body)){
        networks.add(NetworkModel.fromJSON(d));
      }
    }
    return networks;
  }
  static Future<List<AreaModel>> getAreaList() async{
    ResponseModel responseModel = await ApiClient.get("area");
    List<AreaModel> areas = [];
    if(responseModel.statusCode ==200){
      for(var d in jsonDecode(responseModel.body)){
        areas.add(AreaModel.fromJSON(d));
      }
    }
    return areas;
  }
}