import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:voc_client_app/main_screen.dart';

import 'commons/apis/common/constant.dart';
import 'modules/menu/screen/menu_page.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final zoomDrawerController = ZoomDrawerController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZoomDrawer(
          menuScreen: MenuPage(),
          mainScreen: MainScreen(zoomDrawerController: zoomDrawerController),
          controller: zoomDrawerController,
          borderRadius: SIZES.kDefaultRadius * 2,
          showShadow: true,
          angle: -5.0,
          backgroundColor: Colors.grey,
          slideWidth: MediaQuery.of(context).size.width * (0.5)),
    );
  }
}
