import '../../config/api-client.dart';
import '../data_class/response_model.dart';

class SubscriptionAPI{
  static Future<ResponseModel> deviceSubscriptions(formData) async{
    return await ApiClient.post("subscription/list",formData);
  }
  static Future<ResponseModel> getRechargeDetails(formData) async{
    return await ApiClient.post("subscription/rechargeDetails",formData);
  }
  static Future<ResponseModel> subscriptionAvailablePackages(formData) async{
    return await ApiClient.post("subscription/packages/available",formData);
  }
  static Future<ResponseModel> subscribePackage(formData) async{
    return await ApiClient.post("subscription/subscribe",formData);
  }
  static Future<ResponseModel> stopPackage(formData) async{
    return await ApiClient.post("subscription/stop",formData);
  }
  static Future<ResponseModel> renewPackage(formData) async{
    return await ApiClient.post("subscription/renewFeed",formData);
  }

  static Future<ResponseModel> getBalance(String customerId) async{
    return await ApiClient.get("customer/balance/$customerId");
  }
}