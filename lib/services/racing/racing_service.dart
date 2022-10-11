import 'package:get/get.dart';
import 'package:voc_client_app/commons/apis/common/ApiResponse.dart';
import 'package:voc_client_app/commons/themes/alert_dialog.dart';
import 'package:voc_client_app/services/racing/iracing_service.dart';

import '../../commons/apis/RacingApi.dart';
import '../../models/RacingViolation.dart';

class RacingService implements IRacingService {
  RacingApi racingApi = RacingApi();
  @override
  Future start(String cardNumber, String racingTypeCode, String startTime) async {
    try {
      ApiResponse response = await racingApi.start(Get.context, cardNumber, racingTypeCode, startTime);
      if (response.success) {
        print('Goi START API thanh cong');
      } else {
        print('Goi START API THAT BAI: ${response.responseBody}');
        showToastMessage(Get.context!, message: response.responseBody);
      }
    } catch (e) {
      print('Goi START API THAT BAI: $e');
      showToastMessage(Get.context!, message: e.toString());
      throw e;
    }
  }

  @override
  Future finish(String cardNumber, String racingTypeCode, String finishTime) async {
    try {
      ApiResponse response = await racingApi.finish(Get.context, cardNumber, racingTypeCode, finishTime);
      if (response.success) {
        print('Goi FINISH API thanh cong');
      } else {
        print('Goi FINISH API THAT BAI: ${response.responseBody}');
        showToastMessage(Get.context!, message: response.responseBody);
      }
    } catch (e) {
      print('Goi FINISH API THAT BAI: $e');
      showToastMessage(Get.context!, message: e.toString());
      throw e;
    }
  }

  @override
  Future completeByTeam(String cardNumber, String racingTypeCode, String? comment, String? racingCancelation, List<RacingViolation>? updateViolations) async {
    try {
      ApiResponse response = await racingApi.completeByTeam(Get.context, cardNumber, racingTypeCode, comment, racingCancelation, updateViolations);
      if (response.success) {
        print('Goi COMPLETE API thanh cong');
      } else {
        print('Goi COMPLETE API THAT BAI: ${response.responseBody}');
        showToastMessage(Get.context!, message: response.responseBody);
      }
    } catch (e) {
      print('Goi COMPLETE API THAT BAI: $e');
      showToastMessage(Get.context!, message: e.toString());
      throw e;
    }
  }

  @override
  Future completeForce(String cardNumber, String racingTypeCode, String? comment, String? racingCancelation, List<RacingViolation>? updateViolations) async {
    try {
      ApiResponse response = await racingApi.completeByTeam(Get.context, cardNumber, racingTypeCode, comment, racingCancelation, updateViolations);
      if (response.success) {
        print('Goi COMPLETE FORCE API thanh cong');
      } else {
        print('Goi COMPLETE FORCE API THAT BAI: ${response.responseBody}');
        showToastMessage(Get.context!, message: response.responseBody);
      }
    } catch (e) {
      print('Goi COMPLETE FORCE API THAT BAI: $e');
      showToastMessage(Get.context!, message: e.toString());
      throw e;
    }
  }

  @override
  Future undoRacing(String cardNumber, String racingTypeCode) async {
    try {
      ApiResponse response = await racingApi.undoRacing(Get.context, cardNumber, racingTypeCode);
      if (response.success) {
        print('Goi UNDO API thanh cong');
      } else {
        print('Goi UNDO API THAT BAI: ${response.responseBody}');
        showToastMessage(Get.context!, message: response.responseBody);
      }
    } catch (e) {
      print('Goi UNDO API THAT BAI: $e');
      showToastMessage(Get.context!, message: e.toString());
      throw e;
    }
  }
}
