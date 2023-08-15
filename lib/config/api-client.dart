import 'dart:convert';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../model/data_class/credential.dart';
import '../model/data_class/response_model.dart';


class ApiClient{
  static const serverBaseURL="http://10.0.2.2:8081/";
 // static const serverBaseURL="https://metamicapp.softobit.com/";


  static Future<ResponseModel> postPublic(String endPoint,Map formData) async{
    try {
      http.Response? response = await http.post(Uri.parse(serverBaseURL + endPoint),
          headers: {
            'content-type':'application/json',
            'Authorization':'Bearer mobarok',
            'x-api-key':'web3@ncn@softobit',
          },
          body: jsonEncode(formData)
      ).timeout(const Duration(seconds: 60));
      return ResponseModel(
          success: true,
          message: "SUCCESS",
          statusCode: response.statusCode,
          body: response.body
      );
    } catch (e) {
      print(e);
      return ResponseModel(
          success: false,
          message: "Something wrong!, please send us a report",
          statusCode: 500,
          body: ""
      );
    }
  }

  static Future<ResponseModel> post(String endPoint,Map formData) async{

    try {

      if((credentialModel!.expireAt.subtract(const Duration(seconds: 20))).isBefore(DateTime.now())){
             ResponseModel responseModel = await requestRefreshToken();
             if(responseModel.statusCode == 200){
               credentialModel = CredentialModel.fromJSON(responseModel.body);
             }
      }

      http.Response? response = await http.post(Uri.parse(serverBaseURL + endPoint),
          headers: {
            'content-type':'application/json',
            'Authorization':'Bearer ${credentialModel!.token}',
            'x-api-key':'web3@ncn@softobit',
          },
          body: jsonEncode(formData)
      ).timeout(const Duration(seconds: 60));
      return ResponseModel(
          success: true,
          message: "SUCCESS",
          statusCode: response.statusCode,
          body: response.body
      );
    } catch (e) {
      print(e);
      return ResponseModel(
          success: false,
          message: "Something wrong!, please send us a report",
          statusCode: 500,
          body: ""
      );
    }
  }
  static Future<ResponseModel> patch(String endPoint,Map formData) async{
    print(serverBaseURL + endPoint);
    print(formData);
    try {

      if((credentialModel!.expireAt.subtract(const Duration(seconds: 20))).isBefore(DateTime.now())){
        ResponseModel responseModel = await requestRefreshToken();
        if(responseModel.statusCode == 200){
          credentialModel = CredentialModel.fromJSON(responseModel.body);
        }
      }

      http.Response? response = await http.patch(Uri.parse(serverBaseURL + endPoint),
          headers: {
            'content-type':'application/json',
           'Authorization':'Bearer ${credentialModel!.token}',
            'x-api-key':'web3@ncn@softobit',
          },
          body: jsonEncode(formData)
      ).timeout(const Duration(seconds: 60));
      return ResponseModel(
          success: true,
          message: "SUCCESS",
          statusCode: response.statusCode,
          body: response.body
      );
    } catch (e) {
      print(e);
      return ResponseModel(
          success: false,
          message: "Something wrong!, please send us a report",
          statusCode: 500,
          body: ""
      );
    }
  }
  static Future<ResponseModel> get(String endPoint) async{
    try {

      if((credentialModel!.expireAt.subtract(const Duration(seconds: 20))).isBefore(DateTime.now())){
        ResponseModel responseModel = await requestRefreshToken();
        if(responseModel.statusCode == 200){
          credentialModel = CredentialModel.fromJSON(responseModel.body);
        }
      }

      http.Response? response = await http.get(Uri.parse(serverBaseURL + endPoint),
          headers: {
            'content-type':'application/json',
            'Authorization':'Bearer ${credentialModel!.token}',
            'x-api-key':'web3@ncn@softobit',
          },
      ).timeout(const Duration(seconds: 60));
      return ResponseModel(
          success: true,
          message: "SUCCESS",
          statusCode: response.statusCode,
          body: response.body
      );
    } catch (e) {
      return ResponseModel(
          success: false,
          message: "Something wrong!, please send us a report",
          statusCode: 500,
          body: ""
      );
    }
  }

  static Future<ResponseModel> requestRefreshToken() async{

    try {
      http.Response? response = await http.post(Uri.parse("${serverBaseURL}user/refresh"),
          headers: {
            'content-type':'application/json',
            'Authorization':'Bearer ${credentialModel!.refreshToken}',
            'x-api-key':'web3@ncn@softobit',
          },
          body: jsonEncode({})
      ).timeout(const Duration(seconds: 60));
      return ResponseModel(
          success: true,
          message: "SUCCESS",
          statusCode: response.statusCode,
          body: response.statusCode==200?jsonDecode(response.body):{}
      );
    } catch (e) {
      print(e);
      return ResponseModel(
          success: false,
          message: "Something wrong!, please send us a report",
          statusCode: 500,
          body: ""
      );
    }
  }

}