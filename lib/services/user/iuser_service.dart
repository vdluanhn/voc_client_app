import 'package:flutter/cupertino.dart';

abstract class IUserService {
  void confirmLogout(BuildContext context);
  void gotoLoginPage(BuildContext context);
}
