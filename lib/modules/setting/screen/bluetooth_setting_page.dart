import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:loadmore/loadmore.dart';
import 'package:provider/provider.dart';
import 'package:voc_client_app/modules/setting/view_model/bluetooth_setting_vm.dart';
import '../../../commons/themes/app_color.dart';
import '../../../commons/themes/app_style.dart';
import '../../../commons/themes/helper.dart';
import '../../../commons/widgets/InputFormFieldCustom.dart';
import '../../../commons/widgets/LoadingSpinner.dart';
import '../../../commons/widgets/initialize_page_error.dart';
import '../../../services/bluetooth_control/bluetooth_service.dart';

class BluetoothSettingPage extends StatefulWidget {
  const BluetoothSettingPage({super.key});

  @override
  State<BluetoothSettingPage> createState() => _BluetoothSettingPageState();
}

class _BluetoothSettingPageState extends State<BluetoothSettingPage> {
  late String _value = "INIT";
  bool _connected = false;
  bool _connecting = true;
  int getRadom() {
    Random random = Random();
    return random.nextInt(1000);
  }

  @override
  void initState() {
    super.initState();
    BluetoothSettingVM vm = Provider.of<BluetoothSettingVM>(context, listen: false);
    vm.resetPage();
    vm.loadDataInitPage(context);
  }

  _connect(BuildContext context) async {
    final Bluetooth bluetooth = Provider.of<BluetoothService>(context, listen: false);
    bool status = await bluetooth.connectTo(_value);
    if (status) {}
    setState(() {
      _connected = status;
      _connecting = false;
    });
  }

  _disconnect(BuildContext context) async {
    final Bluetooth bluetooth = Provider.of<BluetoothService>(context, listen: false);
    bluetooth.disconnect();
    setState(() {
      _connected = false;
    });
  }

  List<BluetoothDevice> lstDevices = [];
  Future<List<BluetoothDevice>> getDevice() async {
    final Bluetooth bluetooth = Provider.of<BluetoothService>(context);
    lstDevices = await bluetooth.getDevices();
    return lstDevices;
  }

  Future<bool> _backPagePre(BuildContext context) {
    Navigator.of(context).pop();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final Bluetooth bluetooth = Provider.of<BluetoothService>(context);
    return WillPopScope(
      onWillPop: () {
        return _backPagePre(context);
      },
      child: Scaffold(
        body: Consumer<BluetoothSettingVM>(builder: (context, vm, child) {
          return Stack(
            children: [
              vm.initPageFail
                  ? InitPageError(onRetry: () {
                      setState(() {
                        vm.resetPage();
                        vm.loadDataInitPage(context);
                      });
                    })
                  : Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: SIZES.kSpaceHeightDefault),
                        //   child: InputFormFieldCustom(
                        //       controller: vm.keywordTC,
                        //       lableText: "Tìm kiếm thiết bị",
                        //       hintText: "Nhập tên thiết bị cần tìm",
                        //       showSuffixIcon: ShowSuffixIcon.AUTO,
                        //       keyboardType: TextInputType.text,
                        //       keyboardAction: TextInputAction.search,
                        //       onSubmitOnKeyboard: (value) {
                        //         FocusScope.of(context).unfocus();
                        //         vm.keywordTC.text = value;
                        //         vm.onSearchBlueDevices(context, value);
                        //       },
                        //       onTapSuffixIcon: () {
                        //         FocusScope.of(context).unfocus();
                        //         vm.keywordTC.clear();
                        //         vm.onSearchBlueDevices(context, vm.keywordTC.text);
                        //       }),
                        // ),
                        Expanded(
                          child: RefreshIndicator(
                            child: !isEmpty(vm.blueDevices) && vm.blueDevices.isNotEmpty
                                ? LoadMore(
                                    onLoadMore: () async {
                                      await Future.delayed(const Duration(milliseconds: 500));
                                      await vm.loadMore(context);
                                      return true;
                                    },
                                    whenEmptyLoad: false,
                                    delegate: const DefaultLoadMoreDelegate(),
                                    textBuilder: (status) {
                                      if (status == LoadMoreStatus.nomore) {
                                        return "Đã tải hết";
                                      }
                                      if (status == LoadMoreStatus.loading) {
                                        return "Đang tải thêm";
                                      }
                                      if (status == LoadMoreStatus.fail) {
                                        return "Tải thêm lỗi, vui lòng thử lại";
                                      }
                                      return DefaultLoadMoreTextBuilder.english(status);
                                    },
                                    isFinish: vm.isFinish, // vm.vehicles!.contents!.length >= vm.vehicles!.totalElements!,
                                    child: SingleChildScrollView(
                                      child: Container(
                                        padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 70),
                                        child: Column(
                                          children: [
                                            ...List.generate(
                                              vm.blueDevices.length,
                                              (index) => Container(
                                                width: double.infinity,
                                                margin: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Colors.amber.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.bluetooth_audio_outlined,
                                                          color: Colors.blueAccent,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text.rich(TextSpan(children: [
                                                              TextSpan(
                                                                text: vm.blueDevices[index].name,
                                                                style: STYLES.kTextContentStyle.copyWith(color: Colors.black),
                                                              )
                                                            ])),
                                                            const SizedBox(height: 8),
                                                            Text(
                                                              '${vm.blueDevices[index].address}',
                                                              style: const TextStyle(
                                                                color: AppColor.secondaryColor,
                                                              ),
                                                            ),
                                                            const SizedBox(height: 8),
                                                            Text(
                                                              'Trạng thái: ${vm.blueDevices[index].isConnected ? 'Đã kết nối' : 'Chưa kết nối'}',
                                                              style: TextStyle(
                                                                color: (vm.blueDevices[index].isConnected) == true
                                                                    ? AppColor.primaryColor
                                                                    : (vm.blueDevices[index].isBonded) == true
                                                                        ? Colors.blueGrey
                                                                        : Colors.red,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    IconButton(
                                                        tooltip: "Kết nối bluetooth",
                                                        onPressed: () async {
                                                          print("connect blue tooth");
                                                          vm.onChangeBlueDeviceSelected(vm.blueDevices[index]);
                                                          vm.blueDevices[index].isConnected ? vm.disconnect(context) : vm.connect(context);
                                                        },
                                                        icon: Icon(
                                                          Icons.change_circle_outlined,
                                                          color: (vm.blueDevices[index].isConnected) != true ? Colors.grey : Colors.blue,
                                                        )),
                                                    IconButton(
                                                        tooltip: "Gui message 1",
                                                        onPressed: () async {
                                                          print("send message to bluetooth");
                                                          vm.onSendMessageViaBlue(context, vm.keywordTC.text);
                                                        },
                                                        icon: Icon(
                                                          Icons.send_and_archive_outlined,
                                                          color: (vm.blueDevices[index].isConnected) != true ? Colors.grey : Colors.blue,
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))
                                : const Center(
                                    child: Text(
                                      'Chưa có thông tin',
                                      style: TextStyle(color: AppColor.grey),
                                    ),
                                  ),
                            onRefresh: () async {
                              await Future.delayed(const Duration(milliseconds: 500));
                              // ignore: use_build_context_synchronously
                              vm.onRefreshBlueDevices(context);
                            },

                            // Container(
                            //     decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), color: Colors.white),
                            //     child: FutureBuilder(
                            //       future: getDevice(),
                            //       builder: (context, AsyncSnapshot snapshot) {
                            //         if (!snapshot.hasData) {
                            //           return const Center(
                            //             child: CircularProgressIndicator(),
                            //           );
                            //         } else if (snapshot.hasError) {
                            //           return Center(
                            //             child: Text(snapshot.error.toString()),
                            //           );
                            //         } else {
                            //           return SingleChildScrollView(
                            //             child: Padding(
                            //               padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 70),
                            //               child: Column(
                            //                 children: [
                            //                   ...List.generate(
                            //                       lstDevices.length,
                            //                       (index) => Container(
                            //                             padding: const EdgeInsets.all(8),
                            //                             margin: const EdgeInsets.all(4),
                            //                             width: double.infinity,
                            //                             decoration: BoxDecoration(
                            //                               color: Colors.amber,
                            //                               borderRadius: BorderRadius.circular(8),
                            //                             ),
                            //                             child: Row(
                            //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //                               children: [
                            //                                 Column(mainAxisAlignment: MainAxisAlignment.spaceAround, crossAxisAlignment: CrossAxisAlignment.start, children: [
                            //                                   Text(
                            //                                     lstDevices[index].name ?? "NAN",
                            //                                     style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            //                                     textAlign: TextAlign.end,
                            //                                   ),
                            //                                   const SizedBox(height: 5),
                            //                                   Text(lstDevices[index].address ?? "NAN"),
                            //                                 ]),
                            //                                 ElevatedButton(
                            //                                     onPressed: () {
                            //                                       _value = lstDevices[index].address;
                            //                                       lstDevices[index].isConnected ? _disconnect(context) : _connect(context);
                            //                                     },
                            //                                     child: Text(lstDevices[index].isConnected ? "CONECTED" : "DISCONECTED"))
                            //                               ],
                            //                             ),
                            //                           ))
                            //                 ],
                            //               ),
                            //             ),
                            //           );
                            //         }
                            //       },
                            //     ),
                            //   ),
                          ),
                        )
                      ],
                    ),
              (vm.processing)
                  ? Container(
                      alignment: AlignmentDirectional.center,
                      color: AppColor.black.withOpacity(0.3),
                      child: Center(
                        child: LoadingSpinner(),
                      ),
                    )
                  : const SizedBox(),
            ],
          );
        }),
      ),
    );
  }
}
