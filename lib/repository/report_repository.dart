import 'dart:convert';

import '../model/api/customer_api.dart';
import '../model/data_class/response_model.dart';
import '../model/data_class/summery.dart';

class SummeryReportRepository{
  static Future<SummeryReport?> getSummery(int id) async{
    SummeryReport? customerModel;
    ResponseModel responseModel = await CustomerAPI.getFeedReport(id);
    print(id);
    if(responseModel.statusCode ==200){
      customerModel =  SummeryReport.fromJSON(jsonDecode(responseModel.body));
    }
    return customerModel;
  }

}