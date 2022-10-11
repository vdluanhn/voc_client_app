import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:voc_client_app/commons/apis/DataCommApi.dart';
import 'package:voc_client_app/commons/apis/common/ErrorResponse.dart';
import 'package:voc_client_app/commons/themes/local_storage_utils.dart';
import 'package:voc_client_app/models/RacingLevel.dart';
import 'package:voc_client_app/models/RacingType.dart';
import 'package:voc_client_app/modules/home/screen/home_page.dart';
import 'package:voc_client_app/modules/login/view_model/user_vm.dart';
import 'package:voc_client_app/root_screen.dart';

import '../../../commons/apis/LoginApi.dart';
import '../../../commons/apis/common/ApiResponse.dart';
import '../../../commons/themes/alert_dialog.dart';
import '../../../commons/themes/helper.dart';
import '../../../models/Team.dart';

class LoginVM extends ChangeNotifier {
  TextEditingController usernameTC = TextEditingController(text: "admin");
  TextEditingController passwordTC = TextEditingController(text: "112233");
  bool processing = false;
  bool initPageFail = false;

  bool isSavePwd = true;

  LoginApi loginApi = LoginApi();
  DataCommApi dataApi = DataCommApi();

  late List<RacingLevel> racingLevels = [];
  late List<RacingType> racingTypes = [];
  late RacingLevel? racingLevelSelected;
  late RacingType? racingTypeSelected;
  late List<Team> teams = [];
  void resetState() async {
    try {
      processing = false;
      initPageFail = false;
      racingLevels = [];
      racingTypes = [];
      racingLevelSelected = racingTypeSelected = null;
    } catch (e) {
      print(e);
    }

    processing = false;
  }

  Future<void> loadDataInitPage(BuildContext context) async {
    try {
      if (!processing) {
        processing = true;
        // notifyListeners();
      }
      await Future.wait([getRacingLevels(context), getRacingTypes(context)]);

      if (racingLevels.isEmpty) {
        initPageFail = false;
        return;
      }
      if (racingLevels.isNotEmpty) racingLevelSelected = racingLevels.first;
      if (racingTypes.isNotEmpty) racingTypeSelected = racingTypes.first;

      String flagSavePwd = await LocalStorageService.readItem(Constants.STORAGE_IS_SAVE_PASSWORD);
      if (flagSavePwd == "SAVE") {
        isSavePwd = true;
        String pwd = await LocalStorageService.readItem(Constants.STORAGE_LAST_LOGIN_PASSWORD);
        if (!isEmpty(passwordTC.text) && passwordTC.text != pwd) {
        } else {
          passwordTC = TextEditingController(text: pwd);
        }
      } else {
        isSavePwd = false;
        passwordTC = TextEditingController(text: "");
      }
      String username = await LocalStorageService.readItem(Constants.STORAGE_LAST_LOGIN_USER_NAME);
      if (!isEmpty(usernameTC.text) && usernameTC.text != username) {
      } else {
        usernameTC = TextEditingController(text: username);
      }
    } catch (e) {
      print(e);
      initPageFail = true;
    } finally {
      processing = false;
      notifyListeners();
    }
  }

  Future login(BuildContext context) async {
    processing = true;
    notifyListeners();
    FocusScope.of(context).unfocus();
    try {
      if (isEmpty(usernameTC.text) || isEmpty(passwordTC.text)) {
        showAlertDialog(context, title: 'Thông báo', message: 'Vui lòng nhập thông tin đăng nhập', buttonName1: 'Thử lại', callback1: () => Navigator.pop(context));
        return;
      }
      // String authCode = usernameTC.text.trim() + ":" + passwordTC.text.trim();
      // var encodedAuth = base64.encode(ascii.encode(authCode));
      // String authHeader = "Basic " + encodedAuth;
      // UserVM userVm = Provider.of<UserVM>(context, listen: false);
      // var teams = await getTeamsByLevel(context);
      // userVm.teams = teams;
      // userVm.racingLevels = racingLevels;
      // userVm.racingTypes = racingTypes;
      // userVm.racingLevelSelected = racingLevelSelected;
      // userVm.racingTypeSelected = racingTypeSelected;
      // await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage(), settings: const RouteSettings(name: "/home")), (Route<dynamic> route) => false);
      // return;
      ApiResponse result = await loginApi.login(usernameTC.text.trim(), passwordTC.text.trim());
      if (result.success) {
        try {
          String authCode = usernameTC.text.trim() + ":" + passwordTC.text.trim();
          var encodedAuth = base64.encode(ascii.encode(authCode));
          String authHeader = "Basic " + encodedAuth;

          UserVM userVm = Provider.of<UserVM>(Get.context!, listen: false);
          userVm.setUser(result.responseObject);
          userVm.user?.accessToken = authHeader;
          LocalStorageService.writeItem("Authorization", authHeader);
          print("TOKEN: " + authHeader);

          var teams = await getTeamsByLevel(context);
          userVm.teams = teams;
          userVm.racingLevels = racingLevels;
          userVm.racingTypes = racingTypes;
          userVm.racingLevelSelected = racingLevelSelected;
          userVm.racingTypeSelected = racingTypeSelected;

          if (isSavePwd) {
            LocalStorageService.writeItem(Constants.STORAGE_LAST_LOGIN_USER_NAME, usernameTC.text);
            LocalStorageService.writeItem(Constants.STORAGE_LAST_LOGIN_PASSWORD, passwordTC.text);
            LocalStorageService.writeItem(Constants.STORAGE_IS_SAVE_PASSWORD, "SAVE");
          } else {
            LocalStorageService.deleteItem(key: Constants.STORAGE_LAST_LOGIN_PASSWORD);
            LocalStorageService.writeItem(Constants.STORAGE_IS_SAVE_PASSWORD, "NOTSAVE");
          }
        } catch (e) {}
        // push Device token to server if never push with this account
        // get storageUserInfo from storage, check if whether push or not

        await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const RootScreen(), settings: const RouteSettings(name: "/root")), (Route<dynamic> route) => false);
      } else {
        if (!result.fromSpecialError) {
          ErrorResponse response = ErrorResponse.fromJson(result.responseObject);
          showAlertDialog(context, title: 'Thông báo', message: response.message!, buttonName1: 'Thử lại', callback1: () => Navigator.pop(Get.context!));
        } else {
          showAlertDialog(context, title: 'Thông báo', message: "Có lỗi xảy ra, vui lòng kiểm tra và thử lại", buttonName1: 'Thử lại', callback1: () => Navigator.pop(Get.context!));
        }
      }
    } catch (ex) {
      debugPrint(ex.toString());
    } finally {
      processing = false;
      notifyListeners();
    }
  }

  Future<List<RacingLevel>> getRacingLevels(BuildContext context) async {
    try {
      // var configs = await rootBundle.loadString('assets/cfg/app_configs_level.json');
      // racingLevels = jsonDecode(configs).map((m) => RacingLevel.fromJson(m)).toList().cast<RacingLevel>();
      // LocalStorageService.writeItem("RACING_LEVELS", json.encode(racingLevels.map((e) => e.toJson()).toList()));
      // return racingLevels;
      ApiResponse result = await dataApi.getRacingLevels(context);
      if (result.success) {
        racingLevels = result.responseObject.map((m) => RacingLevel.fromJson(m)).toList().cast<RacingLevel>();
        LocalStorageService.writeItem("RACING_LEVELS", json.encode(racingLevels.map((e) => e.toJson()).toList()));
        return racingLevels;
      } else {
        if (!result.fromSpecialError) {
          ErrorResponse resErr = ErrorResponse.fromJson(result.responseObject);
          showToastMessage(Get.context!, message: resErr.message!);
        } else {
          showToastMessage(Get.context!, message: "Có lỗi xảy ra, vui lòng kiểm tra và thử lại");
        }
        var configs = await rootBundle.loadString('assets/cfg/app_configs_level.json');
        racingLevels = jsonDecode(configs).map((m) => RacingLevel.fromJson(m)).toList().cast<RacingLevel>();
        LocalStorageService.writeItem("RACING_LEVELS", json.encode(racingLevels.map((e) => e.toJson()).toList()));
        return racingLevels;
      }
    } catch (ex) {
      debugPrint(ex.toString());
    }
    return [];
  }

  Future<List<RacingType>> getRacingTypes(BuildContext context) async {
    try {
      // var configs = await rootBundle.loadString('assets/cfg/app_configs_type.json');
      // racingTypes = jsonDecode(configs).map((m) => RacingType.fromJson(m)).toList().cast<RacingType>();
      // LocalStorageService.writeItem("RACING_TYPES", json.encode(racingLevels.map((e) => e.toJson()).toList()));
      // return racingTypes;
      ApiResponse result = await dataApi.getRacingTypes(context);
      if (result.success) {
        racingTypes = result.responseObject.map((m) => RacingType.fromJson(m)).toList().cast<RacingType>();
        LocalStorageService.writeItem("RACING_TYPES", json.encode(racingTypes.map((e) => e.toJson()).toList()));
        return racingTypes;
      } else {
        if (!result.fromSpecialError) {
          ErrorResponse resErr = ErrorResponse.fromJson(result.responseObject);
          showToastMessage(Get.context!, message: resErr.message!);
        } else {
          showToastMessage(Get.context!, message: "Có lỗi xảy ra, vui lòng kiểm tra và thử lại");
        }
        var configs = await rootBundle.loadString('assets/cfg/app_configs_type.json');
        racingTypes = jsonDecode(configs).map((m) => RacingType.fromJson(m)).toList().cast<RacingType>();
        LocalStorageService.writeItem("RACING_TYPES", json.encode(racingLevels.map((e) => e.toJson()).toList()));
        return racingTypes;
      }
    } catch (ex) {
      debugPrint(ex.toString());
    }
    return [];
  }

  Future<List<Team>> getTeamsByLevel(BuildContext context) async {
    try {
      // var configs = await rootBundle.loadString('assets/cfg/app_configs_teams.json');
      // teams = jsonDecode(configs).map((m) => Team.fromJson(m)).toList().cast<Team>();
      // LocalStorageService.writeItem("TEAM_" + racingLevelSelected!.racingLevelCode!, json.encode(racingLevels.map((e) => e.toJson()).toList()));
      // return teams;
      ApiResponse result = await dataApi.getTeamsByLevel(context, racingLevelSelected!.racingLevelCode!);
      if (result.success) {
        teams = result.responseObject.map((m) => Team.fromJson(m)).toList().cast<Team>();
        LocalStorageService.writeItem("TEAM_" + racingLevelSelected!.racingLevelCode!, json.encode(racingTypes.map((e) => e.toJson()).toList()));
        return teams;
      } else {
        if (!result.fromSpecialError) {
          ErrorResponse resErr = ErrorResponse.fromJson(result.responseObject);
          showToastMessage(Get.context!, message: resErr.message!);
        } else {
          showToastMessage(Get.context!, message: "Có lỗi xảy ra, vui lòng kiểm tra và thử lại");
        }
        var configs = await rootBundle.loadString('assets/cfg/app_configs_teams.json');
        teams = jsonDecode(configs).map((m) => Team.fromJson(m)).toList().cast<Team>();
        LocalStorageService.writeItem("TEAM_" + racingLevelSelected!.racingLevelCode!, json.encode(racingLevels.map((e) => e.toJson()).toList()));
        return teams;
      }
    } catch (ex) {
      debugPrint(ex.toString());
      throw ex;
    }
  }

  void onSelectRacingType(RacingType object) {
    racingTypeSelected = object;
    notifyListeners();
  }

  void onSelectRacingLevel(RacingLevel object) {
    racingLevelSelected = object;
    notifyListeners();
  }
}
