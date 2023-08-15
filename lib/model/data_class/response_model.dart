class ResponseModel{
  bool success;
  String message;
  int statusCode;
  dynamic body;

  ResponseModel({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.body
  });
}