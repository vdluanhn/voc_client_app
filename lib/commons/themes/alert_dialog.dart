import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_color.dart';

bool _isEmptyEx(var object) {
  if (object == false || object == 'false' || object == 'null' || object == 'Null' || object == 'N/A' || object == null || object == {} || object == '') {
    return true;
  }
  if (object is Iterable && object.length == 0) {
    return true;
  }
  return false;
}

void showAlertDialog(BuildContext context,
    {String message = '', Widget? widget, String title = 'Thông báo', required String buttonName1, String? buttonName2, callback1, callback2, barrierDismissible = true, bool? isVisible = true}) {
  showDialog(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (context) => WillPopScope(
        child: CupertinoAlertDialog(
          title: Text(title),
          content: (_isEmptyEx(widget)) ? Text(message) : widget,
          actions: (_isEmptyEx(buttonName2))
              ? [
                  CupertinoDialogAction(
                    child: Text(
                      buttonName1,
                      style: TextStyle(color: AppColor.primaryColor),
                    ),
                    onPressed: callback1,
                  ),
                ]
              : [
                  CupertinoDialogAction(
                    child: Text(
                      buttonName1,
                    ),
                    onPressed: callback1,
                  ),
                  CupertinoDialogAction(
                    child: Text(
                      buttonName2!,
                      style: TextStyle(color: AppColor.primaryColor),
                    ),
                    onPressed: callback2,
                  ),
                ],
        ),
        onWillPop: () async => barrierDismissible),
  );
}

void showToastMessage(BuildContext context, {String message = "", int secondsDissmiss = 4, DismissDirection dissmissDirection = DismissDirection.down}) {
  ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
    content: Text(
      message,
      textAlign: TextAlign.center,
    ),
    dismissDirection: dissmissDirection,
    duration: Duration(seconds: secondsDissmiss),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.black.withOpacity(0.5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    margin: const EdgeInsets.only(bottom: 20, right: 30, left: 30),
  ));
}
