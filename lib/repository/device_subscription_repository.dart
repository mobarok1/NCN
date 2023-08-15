import 'dart:convert';

import 'package:ncn/model/api/subscription_api.dart';
import 'package:ncn/model/data_class/cg_device.dart';
import 'package:ncn/model/data_class/package_model.dart';
import 'package:ncn/model/data_class/subscription.dart';

import '../model/api/customer_api.dart';
import '../model/data_class/response_model.dart';

class DeviceSubscriptionRepository{
  static Future<List<CGDeviceModel>> getCustomerDevices(String customerId) async{
    List<CGDeviceModel> customerDevices = [];
    ResponseModel responseModel = await CustomerAPI.customerDevices(customerId);

    if(responseModel.statusCode ==200){
      print(responseModel.body);
      for(var d in jsonDecode(responseModel.body)){
        customerDevices.add(CGDeviceModel.fromJSON(d));
      }
    }
    return customerDevices;
  }
  static Future<List<PackageModel>> getAvailablePackages(formData) async{
    List<PackageModel> packages = [];
    ResponseModel responseModel = await SubscriptionAPI.subscriptionAvailablePackages(formData);
    print(responseModel.body);
    if(responseModel.statusCode ==200){
      for(var d in jsonDecode(responseModel.body)){
        packages.add(PackageModel.fromJSON(d));
      }
    }

    print(responseModel.statusCode);
    return packages;
  }
  static Future<List<SubscriptionModel>> getDeviceSubscription(formData) async{
    List<SubscriptionModel> subscriptions = [];
    ResponseModel responseModel = await SubscriptionAPI.deviceSubscriptions(formData);

    if(responseModel.statusCode ==200){
      for(var d in jsonDecode(responseModel.body)){
        subscriptions.add(SubscriptionModel.fromJSON(d));
      }
    }
    return subscriptions;
  }
}