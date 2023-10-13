import 'dart:convert';
import 'package:ncn/model/api/customer_api.dart';
import 'package:ncn/model/api/subscription_api.dart';
import 'package:ncn/model/data_class/customer_model.dart';
import '../config/api-client.dart';
import '../model/data_class/response_model.dart';

class CustomerRepository{
  static Future<CustomerModel?> getCustomerDetails(String id) async{
    CustomerModel? customerModel;
    ResponseModel responseModel = await CustomerAPI.customerDetails(id);

    if(responseModel.statusCode ==200){
     customerModel =  CustomerModel.fromJSON(jsonDecode(responseModel.body));
    }
    return customerModel;
  }
  static Future<List<CustomerModel>> getCustomerList(formData) async{
    ResponseModel responseModel = await ApiClient.post("customer/list",formData);
    List<CustomerModel> customerList = [];
    if(responseModel.statusCode ==200){

      for(var d in jsonDecode(responseModel.body)){
        customerList.add(CustomerModel.fromJSON(d));
      }
    }
    return customerList;
  }
  static Future<double> getCustomerBalance(String customerId) async{
    double balance = 0.0;
    var response = await SubscriptionAPI.getBalance(customerId);
    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      balance = data["balance"].toDouble();
    }
    return balance;
  }

}