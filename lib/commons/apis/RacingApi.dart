import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:voc_client_app/models/RacingViolation.dart';

import '../../modules/login/view_model/user_vm.dart';
import 'common/BaseApi.dart';

class RacingApi extends BaseApi {
  Future getCheckinData(context, String racingLevelCode, String racingTypeCode) async {
    UserVM userVm = Provider.of<UserVM>(context, listen: false);
    String? token = userVm.user?.accessToken;
    var response = await httpRequest.sendGet(uri: getUri('/api/racings-mngt/$racingLevelCode/$racingTypeCode', useBaseUrl: false), token: token);
    return validateResponse(response);
  }

  Future checkin(context, String cardNumber, String racingTypeCode) async {
    UserVM userVm = Provider.of<UserVM>(context, listen: false);
    String? token = userVm.user?.accessToken;
    var response = await httpRequest.sendPost(
      uri: getUri('/api/racings/checkin'),
      requestBody: json.encode({"card_number": cardNumber, "racing_type_code": racingTypeCode}),
      token: token,
    );
    return validateResponse(response);
  }

  Future start(context, String cardNumber, String racingTypeCode, String eventTime) async {
    UserVM userVm = Provider.of<UserVM>(context, listen: false);
    String? token = userVm.user?.accessToken;
    var response = await httpRequest.sendPost(
      uri: getUri('/api/racings/start'),
      requestBody: json.encode({"card_number": cardNumber, "racing_type_code": racingTypeCode, "event_time": eventTime}),
      token: token,
    );
    return validateResponse(response);
  }

  Future finish(context, String cardNumber, String racingTypeCode, String eventTime) async {
    UserVM userVm = Provider.of<UserVM>(context, listen: false);
    String? token = userVm.user?.accessToken;
    var response = await httpRequest.sendPost(
      uri: getUri('/api/racings/finish'),
      requestBody: json.encode({"card_number": cardNumber, "racing_type_code": racingTypeCode, "event_time": eventTime}),
      token: token,
    );
    return validateResponse(response);
  }

  Future completeByTeam(context, String cardNumber, String racingTypeCode, String? comment, String? racingCancelation, List? updateViolations) async {
    UserVM userVm = Provider.of<UserVM>(context, listen: false);
    String? token = userVm.user?.accessToken;
    var response = await httpRequest.sendPost(
      uri: getUri('/api/racings/complete-by-team'),
      requestBody: json.encode({"card_number": cardNumber, "racing_type_code": racingTypeCode, "comment": comment, "racing_cancelation": racingCancelation, "update_violations": updateViolations}),
      token: token,
    );
    return validateResponse(response);
  }

  Future completeForce(context, String cardNumber, String racingTypeCode, String? comment, String? racingCancelation, List<RacingViolation>? updateViolations) async {
    UserVM userVm = Provider.of<UserVM>(context, listen: false);
    String? token = userVm.user?.accessToken;
    var response = await httpRequest.sendPost(
      uri: getUri('/api/racings/complete-force'),
      requestBody: json.encode({"card_number": cardNumber, "racing_type_code": racingTypeCode, "comment": comment, "racing_cancelation": racingCancelation, "update_violations": updateViolations}),
      token: token,
    );
    return validateResponse(response);
  }

  Future undoRacing(context, String cardNumber, String racingTypeCode) async {
    UserVM userVm = Provider.of<UserVM>(context, listen: false);
    String? token = userVm.user?.accessToken;
    var response = await httpRequest.sendPost(
      uri: getUri('/api/racings/undo-racing'),
      requestBody: json.encode({"card_number": cardNumber, "racing_type_code": racingTypeCode}),
      token: token,
    );
    return validateResponse(response);
  }
}
