import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:voc_client_app/main_screen.dart';
import 'package:voc_client_app/modules/login/screen/login_page.dart';

import '../../../commons/themes/alert_dialog.dart';

class MenuVM extends ChangeNotifier {
  void logout(context) async {
    showAlertDialog(Get.context!,
        title: "Đăng xuất?",
        message: 'Bạn chắc chắn muốn đăng xuất ứng dụng?',
        buttonName1: 'Đồng ý',
        callback1: () async {
          Navigator.pop(Get.context!);
          await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginPage(), settings: const RouteSettings(name: "/")), (Route<dynamic> route) => false);
        },
        buttonName2: 'Bỏ qua',
        callback2: () {
          Navigator.pop(Get.context!);
        });
  }

  void goToSettingBluetoothPage(context) {
    var mainVM = Provider.of<MainScreenVM>(context, listen: false);
    mainVM.onChangePage(0);
    mainVM.onClickMenu();
  }
}
