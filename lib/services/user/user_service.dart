import 'package:flutter/material.dart';
import 'package:voc_client_app/modules/login/view_model/user_vm.dart';
import 'package:voc_client_app/services/user/iuser_service.dart';

import '../../commons/themes/alert_dialog.dart';
import '../../commons/themes/helper.dart';
import '../../commons/themes/local_storage_utils.dart';
import '../../modules/login/screen/login_page.dart';

class UserService extends ChangeNotifier implements IUserService {
  UserVM? user;
  @override
  void confirmLogout(BuildContext context) {
    return showAlertDialog(
      context,
      title: 'Thông báo',
      message: 'Bạn có chắc chắn muốn đăng xuất?',
      buttonName1: 'Hủy bỏ',
      buttonName2: 'Đồng ý',
      callback1: () => Navigator.pop(context),
      callback2: () {
        logout(context);
      },
    );
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
  void gotoLoginPage(BuildContext context) {
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
