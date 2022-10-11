import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:voc_client_app/commons/apis/RacingApi.dart';
import 'package:voc_client_app/commons/apis/common/ApiResponse.dart';
import 'package:voc_client_app/commons/themes/alert_dialog.dart';
import 'package:voc_client_app/models/RacingDataOrder.dart';
import 'package:voc_client_app/modules/login/view_model/user_vm.dart';

import '../../../commons/apis/common/ErrorResponse.dart';
import '../../../commons/themes/local_storage_utils.dart';

class CheckinVM extends ChangeNotifier {
  List<RacingDataOrder> checkinDatas = [];
  bool processing = true;
  FocusNode focusNode = FocusNode();
  TextEditingController txtCardNumberController = TextEditingController();

  RacingApi racingApi = RacingApi();

  void resetPage() {
    processing = true;
  }

  Future initDataPage(context) async {
    try {
      if (!processing) {
        processing = true;
        notifyListeners();
      }
      await getDatasCheckin(context);
    } on Exception catch (e) {
      //Thong bao neu start loi
      showAlertDialog(
        Get.context!,
        message: e.toString(),
        buttonName1: 'OK',
        callback1: () => Navigator.pop(Get.context!),
      );
    } finally {
      processing = false;
      notifyListeners();
    }
  }

  Future<List<RacingDataOrder>> getDatasCheckin(BuildContext context) async {
    try {
      var userVm = Provider.of<UserVM>(Get.context!, listen: false);
      ApiResponse result = await racingApi.getCheckinData(context, userVm.racingLevelSelected!.racingLevelCode!, userVm.racingTypeSelected!.racingTypeCode!!);
      if (result.success) {
        checkinDatas = result.responseObject.map((m) => RacingDataOrder.fromJson(m)).toList().cast<RacingDataOrder>();
        LocalStorageService.writeItem("RACING_DATA_CHECKIN", json.encode(checkinDatas.map((e) => e.toJson()).toList()));
        print("size of list checkins = ${checkinDatas.length}");
        return checkinDatas;
      } else {
        if (!result.fromSpecialError) {
          ErrorResponse resErr = ErrorResponse.fromJson(result.responseObject);
          showToastMessage(Get.context!, message: resErr.message!);
        } else {
          showToastMessage(Get.context!, message: "Có lỗi xảy ra, vui lòng kiểm tra và thử lại");
        }
      }
    } catch (ex) {
      debugPrint(ex.toString());
    }
    return [];
  }

  Future checkin(BuildContext context, String cardNumber, String typeCode) async {
    try {
      var userVm = Provider.of<UserVM>(Get.context!, listen: false);
      ApiResponse result = await racingApi.checkin(context, cardNumber, typeCode);
      if (result.success) {
        print("size of list checkins = ${result.responseBody}");
        showToastMessage(Get.context!, message: "Mã thẻ $cardNumber checkin thành công!");
      } else {
        if (!result.fromSpecialError) {
          ErrorResponse resErr = ErrorResponse.fromJson(result.responseObject);
          showToastMessage(Get.context!, message: resErr.message!);
        } else {
          showToastMessage(Get.context!, message: "Có lỗi xảy ra, vui lòng kiểm tra và thử lại");
        }
      }
    } catch (ex) {
      debugPrint(ex.toString());
    }
  }

  bool showConfirmCheckin = false;
  Future<void> onCheckin(context, String cardNumber, {bool isByCardScan = true}) async {
    var userVm = Provider.of<UserVM>(Get.context!, listen: false);
    if (isByCardScan) {
      if (showConfirmCheckin) {
        Navigator.pop(Get.context!);
        showConfirmCheckin = false;
        await checkin(context, cardNumber, userVm.racingTypeSelected!.racingTypeCode!);
      } else {
        showConfirmCheckin = true;
        showAlertDialog(Get.context!, buttonName1: "Đồng ý", title: "Quẹt thẻ checkin", message: "Mời quẹt thẻ để checkin!", callback1: () async {
          Navigator.pop(Get.context!);
          showConfirmCheckin = false;
          await checkin(context, cardNumber, userVm.racingTypeSelected!.racingTypeCode!);
        });
      }
    } else {
      //nhan card number tu textbox ngươi dung nhap (show popup co o nhap ma the)
      if (showConfirmCheckin) {
        Navigator.pop(Get.context!);
        showConfirmCheckin = false;
        await checkin(context, cardNumber, userVm.racingTypeSelected!.racingTypeCode!);
      } else {
        showConfirmCheckin = true;
        showAlertDialog(Get.context!, buttonName1: "Đồng ý", title: "Quẹt thẻ checkin", message: "Mời quẹt thẻ để checkin!", callback1: () async {
          Navigator.pop(Get.context!);
          showConfirmCheckin = false;
          await checkin(context, cardNumber, userVm.racingTypeSelected!.racingTypeCode!);
        });
      }
    }
  }
}
