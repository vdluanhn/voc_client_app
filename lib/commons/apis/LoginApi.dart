import 'dart:convert';

import 'common/BaseApi.dart';

class LoginApi extends BaseApi {
  Future login(String username, String password) async {
    var response = await httpRequest.sendPost(
      uri: getUri('/public/auth'),
      requestBody: json.encode({"user_name": username, "password": password}),
    );
    return validateResponse(response);
  }

  Future getUserFromRefreshToken(String refreshToken) async {
    var response = await httpRequest.sendPost(
      uri: getUri('/identity-service/api/auth/refresh'),
      requestBody: json.encode({"refreshToken": refreshToken}),
    );
    return validateResponse(response);
  }
}
