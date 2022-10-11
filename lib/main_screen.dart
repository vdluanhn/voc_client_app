import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:voc_client_app/modules/checkin/screen/checkin_page.dart';
import 'package:voc_client_app/modules/home/screen/home_page.dart';
import 'package:voc_client_app/modules/login/view_model/user_vm.dart';
import 'package:voc_client_app/modules/result/screen/result_page.dart';
import 'package:voc_client_app/modules/setting/screen/bluetooth_setting_page.dart';
import 'package:voc_client_app/modules/teams/screen/teams_page.dart';

class MainScreenVM extends ChangeNotifier {
  int pageSelected = 2;
  ZoomDrawerController zoomDrawerController = ZoomDrawerController();
  void onChangePage(int index) {
    pageSelected = index;
    notifyListeners();
  }

  void onClickMenu() {
    zoomDrawerController.toggle!();
  }
}

class MainScreen extends StatefulWidget {
  MainScreen({Key? key, required this.zoomDrawerController}) : super(key: key);
  ZoomDrawerController zoomDrawerController;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageSelected = 2;
  final GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey<CurvedNavigationBarState>();
  final screens = [
    const BluetoothSettingPage(),
    const CheckinPage(),
    const HomePage(),
    const ResultPage(),
    const TeamsPage(),
  ];

  @override
  void initState() {
    super.initState();

    var mainVM = Provider.of<MainScreenVM>(context, listen: false);
    mainVM.zoomDrawerController = widget.zoomDrawerController;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userVM = Provider.of<UserVM>(context, listen: false);
    const items = [
      Tooltip(message: "Cài đặt bluetooth kết nối thiết bị", child: Icon(Icons.bluetooth_searching_outlined, size: 30)),
      Tooltip(message: "Checkin", child: Icon(Icons.add_shopping_cart, size: 30)),
      Tooltip(message: "Thi đấu", child: Icon(Icons.shopping_cart_checkout_outlined, size: 30)),
      Tooltip(message: "Kết quả thi đấu", child: Icon(Icons.emoji_events_outlined, size: 30)),
      Tooltip(message: "Danh sách đội thi", child: Icon(Icons.list_alt_rounded, size: 30)),
    ];
    return SafeArea(
      top: false,
      child: ClipRect(
        child: Consumer<MainScreenVM>(builder: (context, vm, child) {
          return Scaffold(
              backgroundColor: Colors.white,
              extendBody: true,
              appBar: AppBar(
                backgroundColor: Colors.orange,
                elevation: 0,
                leading: Tooltip(
                  message: "Danh mục cấu hình, cài đặt ứng dụng",
                  child: IconButton(
                    onPressed: () {
                      widget.zoomDrawerController.toggle!();
                    },
                    icon: const Icon(Icons.menu_outlined),
                  ),
                ),
                title: Text(vm.pageSelected == 0
                    ? 'Bluetooth'
                    : vm.pageSelected == 1
                        ? 'Checkin'
                        : vm.pageSelected == 2
                            ? 'Thi đấu'
                            : vm.pageSelected == 3
                                ? 'Kết quả'
                                : "Đội thi"),
                // actions: [
                //   Tooltip(message: "Tìm kiếm sản phẩm, đơn hàng", child: IconButton(onPressed: () {}, icon: const Icon(Icons.search))),
                //   Tooltip(message: "Xem thông báo", child: IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_active_outlined))),
                // ]
                actions: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${userVM.racingLevelSelected?.racingLevel}',
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${userVM.racingTypeSelected?.racingType}',
                        style: const TextStyle(color: Colors.black),
                      )
                    ],
                  ),
                  const SizedBox(width: 10)
                ],
              ),
              bottomNavigationBar: Theme(
                data: Theme.of(context).copyWith(iconTheme: const IconThemeData(color: Colors.white)),
                child: CurvedNavigationBar(
                    key: bottomNavigationKey,
                    animationCurve: Curves.easeInOut,
                    animationDuration: const Duration(milliseconds: 200),
                    buttonBackgroundColor: Colors.purple,
                    color: Colors.orange,
                    backgroundColor: Colors.transparent,
                    height: 60,
                    index: vm.pageSelected,
                    items: items,
                    onTap: (index) => vm.onChangePage(index)),
              ),
              body: screens[vm.pageSelected]);
        }),
      ),
    );
  }
}
