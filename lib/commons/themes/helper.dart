// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final dateFormatter = DateFormat('dd/MM/yyyy');
final datetimeFormatter = DateFormat('dd/MM/yyyy HH:mm:ss');

final dateTimeFormmatter = DateFormat('HH:mm:ss dd/MM/yyyy');

final formatter = NumberFormat("###,###.###", "vi-VN");

final monthFormatter = DateFormat('MM/yyyy');
const _locale = 'vi-VN';

String numberFormat(String s) => NumberFormat.decimalPattern(_locale).format(int.parse(s));

bool isEmpty(var object) {
  if (object == false || object == 'false' || object == 'null' || object == 'Null' || object == 'N/A' || object == null || object == {} || object == '') {
    return true;
  }
  if (object is Iterable && object.length == 0) {
    return true;
  }
  return false;
}

String formatPhoneNumber(String phoneNumber) {
  return phoneNumber.indexOf('0') == 0 ? '84' + phoneNumber.substring(1) : phoneNumber;
}

String enumToString(Object o) => o.toString().split('.').last;

DateTime getDateTime(String dateTimeString) {
  DateTime datetime = DateTime.parse(dateTimeString).toLocal();
  return datetime;
}

String parseDate(String dateTimeString) {
  String result = '';
  try {
    DateTime datetime = getDateTime(dateTimeString);
    result = dateFormatter.format(datetime);
  } catch (ex) {
    debugPrint(ex.toString());
  }
  return result;
}

String parseDateTime(String dateTimeString) {
  String result = '';
  try {
    DateTime datetime = getDateTime(dateTimeString);
    result = dateTimeFormmatter.format(datetime);
  } catch (ex) {
    debugPrint(ex.toString());
  }
  return result;
}

bool isNumber(var object) {
  try {
    int.parse(object);
    return true;
  } catch (ex) {
    return false;
  }
}

String formatISOTime(DateTime date) {
  //converts date into the following format: // or 2019-06-04T12:08:56.235-0700
  var duration = date.timeZoneOffset;
  if (duration.isNegative) {
    return (DateFormat("yyyy-MM-ddTHH:mm:ss.mmm").format(date));
  } else {
    return (DateFormat("yyyy-MM-ddTHH:mm:ss.mmm").format(date));
  }
}
// TextField(focusNode: AlwaysDisabledFocusNode())
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
// TextField(focusNode: FirstDisabledFocusNode(),)
class FirstDisabledFocusNode extends FocusNode {
  @override
  bool consumeKeyboardToken() {
    return false;
  }
}

class Constants {
  static String STORAGE_CONFIG_PAPERS = "data.app-config.papers";
  static String STORAGE_CONFIG_ACCOUNTS = "data.app-config.accounts";
  static String STORAGE_CONFIG = "data.app-config";
  static String STORAGE_USER_INFO = "user_info_perm";
  static String STORAGE_LAST_LOGIN_USER_NAME = "last_login_username";
  static String STORAGE_LAST_LOGIN_PASSWORD = "last_login_password";
  static String STORAGE_IS_SAVE_PASSWORD = "is_save_password";
  static String STORAGE_USER_SHOP_INFO = "data.user-info";
}

class TransNumMoneyToText {
  int addOne(int value) => value + 1;
  static List<int> _separateNumber(int inputNumber) {
    List<int> bufferList = [];
    while (inputNumber > 0) {
      bufferList.add(inputNumber % 10);
      inputNumber = (inputNumber / 10).floor();
    }

    return bufferList;
  }

  static List<String> _numberToString(List<int> list) {
    List<String> nList = list.map((item) => item.toString()).toList();
    print(list[0].runtimeType);

    for (var i = 0; i < list.length; i++) {
      if (list[i] == 1 && (i % 3 == 0) && list[i] > 1) {
        //  && list[i + 1] > 1
        nList[i] = 'mốt';
      } else if (list[i] == 1) {
        nList[i] = 'một';
      } else if (list[i] == 2) {
        nList[i] = 'hai';
      } else if (list[i] == 3) {
        nList[i] = 'ba';
      } else if (list[i] == 4 && i % 3 != 0) {
        nList[i] = 'bốn';
      } else if (list[i] == 4 && i % 3 == 0) {
        nList[i] = 'tư';
      } else if (list[i] == 5 && i % 3 != 0) {
        nList[i] = 'năm';
      } else if (list[i] == 5 && i % 3 == 0 && list.length != i + 1) {
        nList[i] = 'lăm';
      } else if (list[i] == 5 && i % 3 == 0 && list.length == i + 1) {
        nList[i] = 'năm';
      } else if (list[i] == 6) {
        nList[i] = 'sáu';
      } else if (list[i] == 7) {
        nList[i] = 'bảy';
      } else if (list[i] == 8) {
        nList[i] = 'tám';
      } else if (list[i] == 9) {
        nList[i] = 'chín';
      } else {
        nList[i] = 'không';
      }
    }
    return nList;
  }

  static List<String> _readPrefix(List<dynamic> list) {
    for (var i = 0; i < list.length; i++) {
      if (i % 3 == 0 && list[i] != 'không') {
        list[i] += '';
      } else if (i % 3 == 0 && list[i] == 'không') {
        list[i] = '';
      } else if (i % 3 == 1 && list[i] == 'không' && list[i - 1] != '') {
        list[i] = 'lẻ';
      } else if (i % 3 == 1 && list[i - 1] == 'không' && list[i - 1] == '') {
        list[i] = '';
      } else if (i % 3 == 1 && list[i] == 'một') {
        list[i] = ' mười'; // Cái này là mười (<19)
      } else if (i % 3 == 1 && list[i] != 'mốt') {
        list[i] += ' mươi'; // Cái này là mươi (>19)
      } else {
        list[i] += ' trăm';
      }
    }

    List<String> nList = list.map((item) => item.toString()).toList();
    return nList;
  }

  // Đọc hậu tố:
  static List<String> readSuffix(List<dynamic> list) {
    int len = list.length;
    if (len <= 3) {
      list[0] += '';
    } else if (len > 3 && len <= 6) {
      list[0] += '';
      list[3] += ' nghìn';
    } else if (len > 6 && len <= 9) {
      list[0] += '';
      list[3] += ' nghìn';
      list[6] += ' triệu';
    } else {
      list[0] += '';
      list[3] += ' nghìn';
      list[6] += ' triệu';
      list[9] += ' tỉ';
    }

    List<String> nList = list.map((item) => item.toString()).toList();
    return nList;
  }

  static String readNumber(int inputNumber) {
    List<int> newArray = _separateNumber(inputNumber);
    print("newArray: ${jsonEncode(newArray)}");
    List<String> stringifiedNumber = _numberToString(newArray);
    print("stringifiedNumber: ${jsonEncode(stringifiedNumber)}");

    var pArray = _readPrefix(stringifiedNumber);
    print("pArray: ${jsonEncode(pArray)}");
    var sArray = readSuffix(pArray);
    print("sArray: ${jsonEncode(sArray)}");

    List<String> ssArray = sArray.toList();
    sArray.forEach((element) {
      if (element == "không mươi") ssArray.removeWhere((element1) => element1 == element);
    });
    while ((ssArray.length > 0 && (ssArray[0] == "" || ssArray[0] == "không mươi" || ssArray[0] == "không trăm" || ssArray[0] == "không nghìn")) ||
        (ssArray.length > 1 &&
            (ssArray[0] == "" || ssArray[0] == "không mươi" || ssArray[0] == "không trăm" || ssArray[0] == "không nghìn") &&
            (ssArray[1] == "" || ssArray[1] == " nghìn" || ssArray[1] == " triệu" || ssArray[1] == " trăm")) ||
        (ssArray.length > 1 &&
            (ssArray[1] == "" || ssArray[1] == "không mươi" || ssArray[1] == "không trăm" || ssArray[1] == "không nghìn") &&
            (ssArray[0] == "" || ssArray[0] == " nghìn" || ssArray[0] == " triệu" || ssArray[0] == " trăm"))) {
      ssArray.removeAt(0);
      print("-----ssArray: ${jsonEncode(ssArray)}");
    }

    var srArray = ssArray.reversed.toList();
    print("srArray: ${jsonEncode(srArray)}");

    var result = '';

    for (var i = 0; i < srArray.length; i++) {
      result += srArray[i] + ' ';
    }
    result = result.replaceAll('  ', ' ');
    print("result: $result \n-------------------------------------");
    return result.trim();
  }
}
