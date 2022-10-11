import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../model/AppConfig.dart';
import '../../themes/helper.dart';

const APP_VERSION = "app_version";
const PLATFORM = 'platform';
const OS_VERSION = 'os_version';
const CLIENT_ID = 'client_id';
const REQUEST_ID = 'request_id';
const DEVICE_TOKEN = 'device_token';
const DEVICE_ID = 'device_id';
const DEVICE_NAME = 'device_name';
const APP_ID = 'app_id';

class HttpRequest {
  Future<dynamic> sendGet({
    required Uri uri,
    String? token,
    int timeout = 45,
    Map<String, String>? headers,
    String contentType = "application/x-www-form-urlencoded",
  }) async {
    debugPrint(uri.toString());
    // DeviceViewModel deviceVm = Provider.of<DeviceViewModel>(Get.context!, listen: false);
    Map<String, String>? defaultHeaders = {
      HttpHeaders.contentTypeHeader: contentType,
      // APP_VERSION: AppConfig.of(Get.context)!.appVersion,
      // APP_ID: AppConfig.of(Get.context)!.appId,
      // PLATFORM: AppConfig.of(Get.context)!.platform,
      // OS_VERSION: AppConfig.of(Get.context)!.osVersion,
      // // DEVICE_TOKEN: deviceVm.deviceToken!,
      // DEVICE_ID: AppConfig.of(Get.context)!.deviceId,
      // DEVICE_NAME: AppConfig.of(Get.context)!.deviceName,
      CLIENT_ID: 'VOC'
    };
    if (!isEmpty(token)) {
      defaultHeaders[HttpHeaders.authorizationHeader] = token!;
    }
    try {
      http.Response response = await http
          .get(
            uri,
            headers: headers ?? defaultHeaders,
          )
          .timeout(Duration(seconds: timeout));
      return response;
    } on TimeoutException catch (ex) {
      return http.Response(ex.toString(), 407);
    } catch (ex) {
      return http.Response(ex.toString(), 408);
    }
  }

  Future<dynamic> sendPost({required Uri uri, requestBody, String contentType = "application/json", Map<String, String>? customHeader, String? token, int timeout = 45}) async {
    debugPrint(uri.toString());
    debugPrint(requestBody.toString());
    // DeviceViewModel deviceVm = Provider.of<DeviceViewModel>(Get.context!, listen: false);
    try {
      Map<String, String>? headers = {
        HttpHeaders.contentTypeHeader: contentType,
        // APP_VERSION: AppConfig.of(Get.context)!.appVersion,
        // APP_ID: AppConfig.of(Get.context)!.appId,
        // PLATFORM: AppConfig.of(Get.context)!.platform,
        // OS_VERSION: AppConfig.of(Get.context)!.osVersion,
        // // DEVICE_TOKEN: deviceVm.deviceToken!,
        // DEVICE_ID: AppConfig.of(Get.context)!.deviceId,
        // DEVICE_NAME: AppConfig.of(Get.context)!.deviceName,
        CLIENT_ID: 'VOC'
      };
      if (!isEmpty(token)) {
        headers[HttpHeaders.authorizationHeader] = token!;
      }
      if (!isEmpty(customHeader)) {
        headers.addAll(customHeader!);
      }
      http.Response response = await http.post(uri, headers: headers, body: requestBody).timeout(Duration(seconds: timeout));
      return response;
    } on TimeoutException catch (ex) {
      return http.Response(ex.toString(), 407);
    } catch (ex) {
      return http.Response(ex.toString(), 408);
    }
  }

  Future<dynamic> sendPut({required Uri uri, String? requestBody, String? token, int timeout = 45}) async {
    debugPrint(uri.toString());
    debugPrint(requestBody.toString());
    // DeviceViewModel deviceVm = Provider.of<DeviceViewModel>(Get.context!, listen: false);

    Map<String, String>? headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      APP_VERSION: AppConfig.of(Get.context)!.appVersion,
      APP_ID: AppConfig.of(Get.context)!.appId,
      PLATFORM: AppConfig.of(Get.context)!.platform,
      OS_VERSION: AppConfig.of(Get.context)!.osVersion,
      // DEVICE_TOKEN: deviceVm.deviceToken!,
      DEVICE_ID: AppConfig.of(Get.context)!.deviceId,
      DEVICE_NAME: AppConfig.of(Get.context)!.deviceName,
      CLIENT_ID: 'V-Agency'
    };
    if (!isEmpty(token)) {
      headers[HttpHeaders.authorizationHeader] = token!;
    }

    try {
      http.Response response = await http.put(uri, headers: headers, body: requestBody).timeout(Duration(seconds: timeout));
      return response;
    } on TimeoutException catch (ex) {
      return http.Response(ex.toString(), 407);
    } catch (ex) {
      return http.Response(ex.toString(), 408);
    }
  }
}
