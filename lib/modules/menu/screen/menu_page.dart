import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voc_client_app/modules/login/view_model/login_vm.dart';
import 'package:voc_client_app/modules/login/view_model/user_vm.dart';
import 'package:voc_client_app/modules/menu/view_model/menu_vm.dart';

import '../../../commons/constants.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Consumer<MenuVM>(builder: (context, vm, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                DrawerHeader(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      children: [
                        Consumer<UserVM>(builder: (context, vm, child) {
                          return Container(
                            height: 100,
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(40),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.white,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: const CircleAvatar(
                                    backgroundImage: NetworkImage("https://autobikes.vn/stores/news_dataimages/nguyenthuy/122021/02/20/3812_PVOIL_VOC_2021__2.jpg?rt=20211202203938"),
                                    maxRadius: 40,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(SIZES.kDefaultPadding),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        vm.user?.fullName ?? "NAN",
                                        style: STYLES.kTextStyleLable,
                                      ),
                                      Text(vm.user?.role ?? "NAN", style: STYLES.kTextStyleContent)
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                      ],
                    )),
                const Divider(thickness: 1.0, color: Colors.white12),
                InkWell(
                  onTap: () {
                    print("click cai dat");
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 40,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.password_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(width: SIZES.kDefaultPadding),
                        Text(
                          "Đổi mật khẩu",
                          style: STYLES.kTextStyleContent,
                        )
                      ],
                    ),
                  ),
                ),
                const Divider(thickness: 1.0, color: Colors.white12),
                InkWell(
                  onTap: () {
                    print("click cai dat");
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 40,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.fingerprint,
                          color: Colors.white,
                        ),
                        const SizedBox(width: SIZES.kDefaultPadding),
                        const SizedBox(
                          width: 135,
                          child: Text(
                            "Đăng nhập vân tay",
                            style: STYLES.kTextStyleContent,
                          ),
                        ),
                        Switch.adaptive(
                          value: true,
                          onChanged: (newValue) {},
                          activeColor: Colors.orange,
                          inactiveTrackColor: Colors.grey,
                        )
                      ],
                    ),
                  ),
                ),
                const Divider(thickness: 1.0, color: Colors.white12),
                Consumer<UserVM>(builder: (context, userVM, child) {
                  return InkWell(
                    onTap: () {
                      userVM.onChangeReciveNotify(!userVM.reciveNotify);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      height: 40,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.notifications_active_outlined,
                            color: Colors.white,
                          ),
                          const SizedBox(width: SIZES.kDefaultPadding),
                          const SizedBox(
                            width: 135,
                            child: Text(
                              "Nhận thông báo",
                              style: STYLES.kTextStyleContent,
                            ),
                          ),
                          Switch.adaptive(
                            value: userVM.reciveNotify,
                            onChanged: (newValue) {
                              userVM.onChangeReciveNotify(newValue);
                            },
                            activeColor: Colors.orange,
                            inactiveTrackColor: Colors.grey,
                          )
                        ],
                      ),
                    ),
                  );
                }),
                const Divider(thickness: 1.0, color: Colors.white12),
                Consumer<UserVM>(builder: (context, userVM, child) {
                  return InkWell(
                    onTap: () {
                      userVM.onChangeActionManual(!userVM.actionManual);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      height: 40,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.ads_click_outlined,
                            color: Colors.white,
                          ),
                          const SizedBox(width: SIZES.kDefaultPadding),
                          const SizedBox(
                            width: 135,
                            child: Text(
                              "Nhận lệnh thủ công",
                              style: STYLES.kTextStyleContent,
                            ),
                          ),
                          Switch.adaptive(
                            value: userVM.actionManual,
                            onChanged: (newValue) {
                              userVM.onChangeActionManual(newValue);
                            },
                            activeColor: Colors.orange,
                            inactiveTrackColor: Colors.grey,
                          )
                        ],
                      ),
                    ),
                  );
                }),
                const Divider(thickness: 1.0, color: Colors.white12),
                InkWell(
                  onTap: () {
                    print("click cai dat bluetooth");
                    vm.goToSettingBluetoothPage(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 40,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.bluetooth_audio_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(width: SIZES.kDefaultPadding),
                        SizedBox(
                          width: 135,
                          child: Text(
                            "Cài đặt bluetooth",
                            style: STYLES.kTextStyleContent,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const Divider(thickness: 1.0, color: Colors.white12),
                const Spacer(),
                InkWell(
                  onTap: (() {
                    // ignore: avoid_print
                    print("Click dang xuat");
                    vm.logout(context);
                  }),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 40,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.logout_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(width: SIZES.kDefaultPadding),
                        Text(
                          "Đăng xuất",
                          style: STYLES.kTextStyleContent,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                const Text("VOC App - v1.0.0", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))
              ],
            ),
          );
        }),
      ),
    );
  }
}
