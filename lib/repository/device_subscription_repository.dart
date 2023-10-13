import 'dart:convert';
import '../model/api/subscription_api.dart';
import '../model/api/transaction_api.dart';
import '../model/data_class/package_model.dart';
import '../model/data_class/pre_recharge_model.dart';
import '../model/data_class/response_model.dart';
import '../model/data_class/subscription.dart';
import '../model/data_class/transactionModel.dart';

class DeviceSubscriptionRepository{
  static Future<List<PackageModel>> getAvailablePackages(formData) async{
    List<PackageModel> packages = [];
    ResponseModel responseModel = await SubscriptionAPI.subscriptionAvailablePackages(formData);
    if(responseModel.statusCode ==200){
      for(var d in jsonDecode(responseModel.body)){
        packages.add(PackageModel.fromJSON(d));
      }
    }
    return packages;
  }
  static Future<PreRechargeModel?> getRechargeDetails(formData) async{
    PreRechargeModel? preRecharge;
    ResponseModel responseModel = await SubscriptionAPI.getRechargeDetails(formData);
    if(responseModel.statusCode ==200){
        preRecharge = PreRechargeModel.fromJSON(jsonDecode(responseModel.body));

    }
    return preRecharge;
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

  static Future<List<TransactionModel>> getTransactionHistory(customerId) async{
    List<TransactionModel> subscriptions = [];
    ResponseModel responseModel = await TransactionAPI.getTransactionHistory(customerId);

    if(responseModel.statusCode ==200){
      for(var d in jsonDecode(responseModel.body)){
        subscriptions.add(TransactionModel.fromJSON(d));
      }
    }
    return subscriptions;
  }
}