import 'dart:convert';

import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:voc_client_app/commons/apis/common/httpUtils.dart';
import 'package:voc_client_app/modules/login/screen/login_page.dart';
import '../../themes/alert_dialog.dart';
import '../../themes/helper.dart';
import 'ApiResponse.dart';

abstract class BaseApi {
  Uri getUri(String fullPath, {Map<String, dynamic>? queryParameters, useBaseUrl = true, bool? isTest = false}) {
    if (isTest!) {
      Uri result = Uri.https("customermobile-uat.vetc.com.vn", fullPath, queryParameters);
      return result;
    } else {
      Uri result = Uri.http(apiUrl, fullPath, queryParameters);
      return result;
    }
  }

  String apiUrl = GlobalConfiguration().getValue("api_url");
  HttpRequest httpRequest = HttpRequest();

  /// @param BuildContext context: this param is not used anymore!
  /// It will be removed in the future.
  Future<ApiResponse> validateResponse(response, {showError: true}) async {
    bool success = false;
    bool fromSpecialError = false;
    String? mess = null;
    if (response.statusCode > 299) {
      //truong hop loi
      try {
        var bodyObj = json.decode(utf8.decode(response.bodyBytes));
        mess = bodyObj['message'];
      } catch (e) {}
    }
    switch (response.statusCode) {
      case 200:
        {
          success = true;
          break;
        }

      case 404:
        // not found
        fromSpecialError = true;
        {
          if (showError) {
            showAlertDialog(Get.context!, message: 'Không tìm thấy thông tin yêu cầu', buttonName1: 'Thử lại', callback1: () {
              Navigator.pop(Get.context!);
            });
          }

          break;
        }
      case 401:
        // expireToken
        fromSpecialError = true;

        {
          if (showError) {
            if (isEmpty(mess)) {
              mess = 'Thông tin đăng nhập không hợp lệ, vui lòng kiểm tra và thử lại';
            }
            showAlertDialog(Get.context!, message: mess!, buttonName1: 'Đồng ý', barrierDismissible: false, callback1: () {
              Navigator.pushAndRemoveUntil(Get.context!, MaterialPageRoute(builder: (context) => LoginPage(), settings: const RouteSettings(name: "/login_page")), (Route<dynamic> route) => false);
            });
          }
          break;
        }
      case 407:
        // timeOut
        fromSpecialError = true;
        {
          if (showError) {
            showAlertDialog(Get.context!, message: 'Kết nối hết hạn, vui lòng kiểm tra lại', buttonName1: 'Thử lại', callback1: () {
              Navigator.pop(Get.context!);
            });
          }

          break;
        }
      case 408:
        // cannot connect to host
        fromSpecialError = true;
        {
          if (showError) {
            showAlertDialog(Get.context!, message: 'Không kết nối được tới tên miền, vui lòng kiểm tra lại', buttonName1: 'Thử lại', callback1: () {
              Navigator.pop(Get.context!);
            });
          }

          break;
        }
      case 502:
        // non existed link
        fromSpecialError = true;
        {
          if (showError) {
            showAlertDialog(Get.context!, message: 'Đường dẫn không tồn tại, vui lòng liên hệ quản trị viên hệ thống', buttonName1: 'Thử lại', callback1: () {
              Navigator.pop(Get.context!);
            });
          }

          break;
        }

      case 302:
        // not found
        fromSpecialError = true;
        {
          if (showError) {
            if (response.body.toString().contains("Page404")) {
              showAlertDialog(Get.context!, message: 'Hệ thống đang được bảo trì, vui lòng thực hiện lại sau hoặc liên hệ 19006010 để được hỗ trợ.', buttonName1: 'Thử lại', callback1: () {
                Navigator.pop(Get.context!);
              });
            } else {
              showAlertDialog(Get.context!, message: 'Không tìm thấy thông tin yêu cầu', buttonName1: 'Thử lại', callback1: () {
                Navigator.pop(Get.context!);
              });
            }
          }

          break;
        }
    }

    var responseObject;
    var responseBody;
    var responseHeader;
    var responseBodyByte;

    if (!fromSpecialError) {
      try {
        // http.Response
        responseBody = response.body;
        responseHeader = response.headers;
        responseBodyByte = response.bodyBytes;
        responseObject = json.decode(utf8.decode(response.bodyBytes));
      } catch (ex) {
        // http.StreamedResponse
        try {
          responseBody = await response.stream.bytesToString();
          responseObject = json.decode(responseBody);
        } catch (ex) {
          // in case image bodyByte
          debugPrint(ex.toString());
        }
      }
    }

    ApiResponse result = ApiResponse(
        success: success,
        fromSpecialError: fromSpecialError,
        statusCode: response.statusCode,
        responseBody: responseBody,
        responseObject: responseObject,
        responseHeader: responseHeader,
        responseBodyByte: responseBodyByte);
    debugPrint(responseObject.toString());
    return result;
  }
}
