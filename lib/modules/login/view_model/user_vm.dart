import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:voc_client_app/services/user/iuser_service.dart';

import '../../../commons/themes/alert_dialog.dart';
import '../../../commons/themes/helper.dart';
import '../../../commons/themes/local_storage_utils.dart';
import '../../../models/RacingLevel.dart';
import '../../../models/RacingType.dart';
import '../../../models/Team.dart';
import '../../../models/User.dart';
import '../../home/view_model/home_vm.dart';
import '../screen/login_page.dart';

class UserVM extends ChangeNotifier implements IUserService {
  User? user;
  bool actionManual = false;
  bool reciveNotify = false;
  List<RacingLevel> racingLevels = [];
  List<RacingType> racingTypes = [];
  RacingLevel? racingLevelSelected;
  RacingType? racingTypeSelected;
  List<Team> teams = [];

  void onChangeActionManual(bool action) {
    actionManual = action;
    // var homeVM = Provider.of<HomeVM>(Get.context!, listen: false);
    // FocusScope.of(Get.context!).requestFocus(homeVM.focusNode);
    print('set action manual = $actionManual');
    notifyListeners();
  }

  void onChangeReciveNotify(bool action) {
    reciveNotify = action;
    print('set onChangeReciveNotify = $reciveNotify');
    notifyListeners();
  }

  void setUser(Map<dynamic, dynamic> newJson) async {
    if (user != null) {
      Map<dynamic, dynamic> userJson = user!.toJson();
      userJson.updateAll((key, value) {
        return isEmpty(newJson[key]) ? userJson[key] : newJson[key];
      });
      user = User.fromJson(userJson);
    } else {
      user = User.fromJson(newJson);
    }
    // getCarManufacture();
  }

  void logout(BuildContext context) async {
    user = null;
    LocalStorageService.deleteItem(key: 'users');
    LocalStorageService.deleteItem(key: Constants.STORAGE_USER_INFO);
    LocalStorageService.deleteItem(key: Constants.STORAGE_CONFIG);
    LocalStorageService.deleteItem(key: Constants.STORAGE_USER_SHOP_INFO);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage(), settings: RouteSettings(name: "/login_page")), (Route<dynamic> route) => false);
  }

  @override
  confirmLogout(BuildContext context) {
    return showAlertDialog(
      context,
      title: 'Thông báo',
      message: 'Bạn có chắc chắn muốn đăng xuất?',
      buttonName1: 'Hủy bỏ',
      buttonName2: 'Đồng ý',
      callback1: () => Navigator.pop(context),
      callback2: () {
        Provider.of<UserVM>(context, listen: false).logout(context);
      },
    );
  }

  @override
  gotoLoginPage(BuildContext context) {
    FocusScope.of(context).unfocus();
    // ignore: avoid_print
    print("Dieu huong sang man hinh cai dat tai khoan");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}
