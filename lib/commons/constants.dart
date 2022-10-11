import 'package:flutter/cupertino.dart';

class COLORS {
  static const Color kPrimaryColor = Color(0xFFF67952);
  static const Color kBackgroundColor = Color(0xFFFBFBFD);
  static const Color kBlack = Color(0x00000000);
}

class SIZES {
  static const double kDefaultPadding = 16.0;
  static const double kDefaultRadius = 12.0;
  static const double kDefaultSpaceHeight = 12.0;
}

class STYLES {
  static const TextStyle kTextStyleHeader = TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: COLORS.kPrimaryColor);
  static const TextStyle kTextStyleLable = TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: COLORS.kPrimaryColor);
  static const TextStyle kTextStyleContent = TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: COLORS.kBackgroundColor);
}
