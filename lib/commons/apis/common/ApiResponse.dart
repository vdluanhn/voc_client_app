class ApiResponse {
  ApiResponse({this.success = true, this.fromSpecialError = false, required this.statusCode, required this.responseBody, required this.responseObject, this.responseHeader, this.responseBodyByte});

  int statusCode;
  bool success;
  bool fromSpecialError;
  String responseBody;
  var responseObject;
  var responseHeader;
  var responseBodyByte;
}
