class ErrorResponse {
  String? timestamp;
  int? status;
  String? error;
  String? message;
  String? path;
  String? errorCode;

  ErrorResponse({this.timestamp, this.status, this.error, this.message, this.path, this.errorCode});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    status = json['status'];
    error = json['error'];
    message = json['message'];
    path = json['path'];
    errorCode = json['error_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timestamp'] = this.timestamp;
    data['status'] = this.status;
    data['error'] = this.error;
    data['message'] = this.message;
    data['path'] = this.path;
    data['error_code'] = this.errorCode;
    return data;
  }
}
