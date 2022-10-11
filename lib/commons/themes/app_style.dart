import 'package:flutter/material.dart';

import 'app_color.dart';

class SIZES {
  //Size for Document Page
  static const borderdatepicker = 15;

  //---------------------
  static const kTextHeaderSize = 17.0;
  static const kTextContentSize = 15.0;
  static const kTextLableSize = 14.0;
  static const kPadingDefault = 15.0;
  static const kRadiusDefault = 8.0;
  static const kSpaceHeightDefault = 8.0;
  static const kSpaceHeightInputControl = 11.0;
}

class STYLES {
  static const kTextHeaderStyle = TextStyle(color: AppColor.black, fontSize: SIZES.kTextHeaderSize);
  static const kTextContentStyle = TextStyle(color: Colors.black, fontSize: SIZES.kTextContentSize);
  static const kTextLableStyle = TextStyle(color: Colors.black87, fontSize: SIZES.kTextLableSize);
}

class DECORATIONS {
  // ignore: non_constant_identifier_names
  static BoxDecoration BOX_DECORATION_MAIN = BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(SIZES.kRadiusDefault)),
      boxShadow: [BoxShadow(color: AppColor.primaryColor.withOpacity(0.2), blurRadius: 4, spreadRadius: 1, offset: const Offset(0, 0))]);
}
