import '../../config/api-client.dart';
import '../data_class/response_model.dart';

class CustomerAPI{
  static Future<ResponseModel> addNewCustomer(formData) async{
    return await ApiClient.post("customer",formData);
  }
  static Future<ResponseModel> updateCustomer(formData) async{
    return await ApiClient.patch("customer",formData);
  }
  static Future<ResponseModel> addNewCustomerDevice(formData) async{
    return await ApiClient.post("customer/device",formData);
  }
  static Future<ResponseModel> customerDetails(String id) async{
    return await ApiClient.get("customer/$id");
  }
  static Future<ResponseModel> customerDevices(String customerId) async{
    return await ApiClient.get("customer/devices/$customerId");
  }
  static Future<ResponseModel> login(formData) async{
    return await ApiClient.postPublic("user/login",formData);
  }
  static Future<ResponseModel> userData() async{
    return await ApiClient.get("user");
  }
  static Future<ResponseModel> updatePassword(formData) async{
    return await ApiClient.patch("user/update/password",formData);
  }

  static Future<ResponseModel> getFeedReport(int id) async{
    return await ApiClient.get("report/feed/summery/$id");
  }

}