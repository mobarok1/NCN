import '../../config/api-client.dart';
import '../data_class/response_model.dart';

class TransactionAPI{
  static Future<ResponseModel> addNewEntry(formData) async{
    return await ApiClient.post("transaction/add",formData);
  }
  static Future<ResponseModel> getTransactionHistory(customerId) async{
    return await ApiClient.get("transaction/history/$customerId");
  }

}