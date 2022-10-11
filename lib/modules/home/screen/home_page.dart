import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:voc_client_app/commons/themes/helper.dart';
import 'package:voc_client_app/models/RacingModel.dart';
import 'package:voc_client_app/modules/home/view_model/home_vm.dart';
import 'package:voc_client_app/modules/login/view_model/user_vm.dart';

import '../../../commons/themes/alert_dialog.dart';
import '../../../commons/themes/app_style.dart';
import '../../../commons/widgets/InputFormFieldCustom.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

const defaultDuration = Duration(days: 2, hours: 2, minutes: 30);
const defaultPadding = EdgeInsets.symmetric(horizontal: 10, vertical: 5);

class _HomePageState extends State<HomePage> {
  FocusNode focusNodeKb = FocusNode();
  // TextEditingController controller = new TextEditingController();

  String inputStr = "";

  //StopWatchTimer
  final _isHours = true;
  String startDate = DateFormat('dd/MM/yyyy HH:mm:ss.SSS').format(DateTime.now());

  FocusNode focusNodeText = FocusNode();

  @override
  void initState() {
    super.initState();
    var homeVM = Provider.of<HomeVM>(context, listen: false);
    homeVM.resetState();
    homeVM.initWorkerTimer();

    /// Can be set preset time. This case is "00:01.23".
    // _stopWatchTimer.setPresetTime(mSec: 1234);
    // _stopWatchTimer.onStartTimer();
  }

  @override
  void dispose() async {
    super.dispose();
    // var homeVM = Provider.of<HomeVM>(context, listen: false);
    // await homeVM.stopWatchTimer.dispose();
  }

  /// Get display millisecond time.
  static String getDisplayTimeMillisecond(int mSec) {
    final ms = (mSec % 1000).floor();
    return ms.toString().padLeft(3, '0');
  }

  static bool canPop(BuildContext context) {
    final NavigatorState? navigator = Navigator.maybeOf(context);
    return navigator != null && navigator.canPop();
  }

  @override
  Widget build(BuildContext context) {
    // var userVM = Provider.of<UserVM>(context, listen: false);
    // var homeVM = Provider.of<HomeVM>(context, listen: false);
    if (!focusNodeKb.hasFocus) {
      FocusScope.of(Get.context!).requestFocus(focusNodeKb);
    }
    return Scaffold(body: Consumer<HomeVM>(builder: (context, vm, child) {
      return SingleChildScrollView(
        child: RawKeyboardListener(
          autofocus: true,
          focusNode: focusNodeKb,
          onKey: (RawKeyEvent event) async {
            if (event is RawKeyDownEvent && event.data is RawKeyEventDataAndroid) {
              print("-------> ${event.data.logicalKey.keyLabel}");
              if (event.data.logicalKey.debugName != "Enter") {
                inputStr = inputStr + event.data.logicalKey.keyLabel;
              }
              if (event.data.logicalKey.debugName == "Enter" || event.isKeyPressed(LogicalKeyboardKey.enter)) {
                print("------->>> $inputStr");
                inputStr = inputStr.replaceAll('Enter', '').trim();
                setState(() {
                  vm.txtCardNumberController.text = inputStr;
                });

                Navigator.of(context).maybePop();
                // FocusScope.of(Get.context!).unfocus();
                // if (inputStr.length == 10 || inputStr.length == 24) {
                await vm.onRace(context, inputStr);

                // }
                inputStr = "";
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 8, top: 12, right: 8, bottom: 75),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Sẵn sàng",
                                style: STYLES.kTextHeaderStyle.copyWith(color: !vm.isEnableCancelDNF ? Colors.blue : Colors.blue.withOpacity(0.5)),
                              ),
                              const SizedBox(width: 5),
                              Switch.adaptive(
                                value: vm.isReady,
                                onChanged: vm.isEnableCancelDNF
                                    ? null
                                    : (value) {
                                        vm.onClickReadyOrNot(value);
                                        print(value);
                                      },
                                activeColor: Colors.orange,
                                inactiveTrackColor: Colors.grey,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: !vm.isEnableCancelDNF
                                    ? null
                                    : () {
                                        print("Click huy thi lai");
                                        vm.onUndoRacing(context);
                                      },
                                child: Text(
                                  "Hủy thi lại",
                                  style: STYLES.kTextContentStyle.copyWith(
                                      color: vm.isEnableCancelDNF ? Colors.red : Colors.red.withOpacity(0.5),
                                      fontStyle: FontStyle.italic,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              const Text("  |  "),
                              InkWell(
                                onTap: !vm.isEnableCancelDNF
                                    ? null
                                    : () {
                                        print("Click DNF");
                                        vm.onClickDNF(context, vm.racingModel.racingTeam!.cardNumber!);
                                      },
                                child: Text(
                                  "DNF",
                                  style: STYLES.kTextContentStyle.copyWith(
                                      color: vm.isEnableCancelDNF ? Colors.blue : Colors.blue.withOpacity(0.5),
                                      fontStyle: FontStyle.italic,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(),
                      isEmpty(vm.teamCarName)
                          ? SizedBox()
                          : Text(
                              vm.teamCarName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),

                      /// Display stop watch time
                      StreamBuilder<int>(
                        stream: vm.stopWatchTimer.rawTime,
                        initialData: vm.stopWatchTimer.rawTime.value,
                        builder: (context, snap) {
                          final value = vm.totalTimeFinish;
                          final displayTime = StopWatchTimer.getDisplayTime(value, hours: _isHours);
                          var ms = getDisplayTimeMillisecond(value);
                          var seconds = StopWatchTimer.getDisplayTimeSecond(value);
                          var minutes = StopWatchTimer.getDisplayTimeMinute(value);
                          var hours = StopWatchTimer.getDisplayTimeHours(value);
                          return Column(
                            children: <Widget>[
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.orangeAccent),
                                      child: Text('TG bắt đầu: ${vm.startTimeStr}')),
                                  Container(
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.orangeAccent),
                                      child: Text('TG kết thúc: ${vm.finishTimeStr}'))
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Divider(),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.orange),
                                      child: Text(hours, style: const TextStyle(fontSize: 60, fontFamily: 'Helvetica', fontWeight: FontWeight.w400))),
                                  const SizedBox(width: 10),
                                  Container(
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.orange),
                                      child: Text(minutes, style: const TextStyle(fontSize: 60, fontFamily: 'Helvetica', fontWeight: FontWeight.w400))),
                                  const SizedBox(width: 10),
                                  Container(
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.orange),
                                      child: Text(seconds, style: const TextStyle(fontSize: 60, fontFamily: 'Helvetica', fontWeight: FontWeight.w400))),
                                  const SizedBox(width: 10),
                                  Container(
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.orange.withOpacity(0.4)),
                                      child: Text(ms, style: const TextStyle(fontSize: 25, fontFamily: 'Helvetica', fontWeight: FontWeight.w400))),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Expanded(
                                      child: Text(
                                    "Lỗi nhẹ (+10s):",
                                    textAlign: TextAlign.end,
                                  )),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: CupertinoSpinBox(
                                        min: 0,
                                        max: 120,
                                        readOnly: true,
                                        enabled: vm.racingModel.currentRacingState == RacingState.FINISHED,
                                        value: vm.nErr10s.toDouble(),
                                        onChanged: (value) {
                                          int sErr10 = (value * 10).toInt();
                                          vm.onChangeLNH(value.toInt());
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Text(vm.timeLNH, textAlign: TextAlign.start)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Expanded(
                                      child: Text(
                                    "Lỗi nhẹ (+30s):",
                                    textAlign: TextAlign.end,
                                  )),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: CupertinoSpinBox(
                                        min: 0,
                                        max: 50,
                                        enabled: vm.racingModel.currentRacingState == RacingState.FINISHED,
                                        readOnly: true,
                                        value: vm.nErr30s.toDouble(),
                                        onChanged: (value) {
                                          int sErr30 = (value * 30).toInt();
                                          vm.onChangeLNG(value.toInt());
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Text(vm.timeLNG, textAlign: TextAlign.start)),
                                ],
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text(
                                      "TỔNG THỜI GIAN THI ĐẤU: ",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blueAccent),
                                    ),
                                  ),
                                  Text(
                                    isEmpty(vm.finishTimeStr) ? '00:00:00.000' : vm.totalTime,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }),
        // bottomNavigationBar: Consumer<HomeVM>(builder: (context, vm, child) {
        //   return BottomNavigationBar(
        //     selectedLabelStyle: const TextStyle(color: Colors.redAccent), //your text style
        //     unselectedLabelStyle: const TextStyle(color: Colors.redAccent), //your text style
        //     unselectedItemColor: Colors.redAccent,
        //     selectedItemColor: Colors.redAccent,
        //     selectedFontSize: 12,
        //     unselectedFontSize: 12,
        //     onTap: ((value) {
        //       if (value == 0) {
        //         Navigator.push(context, MaterialPageRoute(builder: (context) => const BluetoothSettingPage()));
        //       }
        //       if (value == 1) {
        //         vm.racingModel.isFinish() ? vm.onClickConfirmFinish() : null;
        //       }
        //     }),
        //     items: [
        //       const BottomNavigationBarItem(
        //         icon: Icon(Icons.keyboard_option_key, color: Colors.blue),
        //         label: "Tùy chọn",
        //       ),
        //       BottomNavigationBarItem(
        //         icon: Icon(Icons.confirmation_number_outlined, color: !vm.racingModel.isFinish() ? Colors.grey : Colors.blue),
        //         label: "Xác nhận kết quả",
        //       ),
        //       const BottomNavigationBarItem(
        //         icon: Icon(Icons.comment_bank_outlined, color: Colors.blue),
        //         label: "Message",
        //       )
        //     ],
        //   );
        // }),

        floatingActionButton: Consumer2<UserVM, HomeVM>(builder: (context, vmUser, vmHome, child) {
      return !vmUser.actionManual
          ? const SizedBox()
          : Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  vmHome.racingModel.isReady()
                      ? Padding(
                          padding: const EdgeInsets.only(left: 31, bottom: 70),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: FloatingActionButton.extended(
                              onPressed: !(vmHome.racingModel.isReady())
                                  ? null
                                  : () {
                                      FocusScope.of(Get.context!).requestFocus(focusNodeText);
                                      showAlertDialog(context,
                                          widget: Material(
                                            color: Colors.transparent,
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 10),
                                                InputFormFieldCustom(
                                                  focusNode: focusNodeText,
                                                  controller: vmHome.txtCardNumberController,
                                                  showSuffixIcon: ShowSuffixIcon.AUTO,
                                                  lableText: "Nhập mã thẻ",
                                                  hintText: "Nhập mã thẻ",
                                                  onTextChange: (value) {},
                                                )
                                              ],
                                            ),
                                          ),
                                          title: 'Mã thẻ đội thi',
                                          buttonName1: 'Để sau',
                                          callback1: () {
                                            vmHome.txtCardNumberController.clear();
                                            Navigator.of(context).maybePop();
                                          },
                                          buttonName2: 'Bắt đầu',
                                          callback2: () {
                                            if ((!isEmpty(vmHome.txtCardNumberController.text))) {
                                              Navigator.of(context).maybePop();
                                              vmHome.onRace(Get.context!, vmHome.txtCardNumberController.text, action: "START");
                                            } else {
                                              showToastMessage(Get.context!, message: 'Vui lòng nhập mã thẻ đội thi');
                                            }
                                          });
                                    },
                              icon: const Icon(Icons.shortcut_sharp),
                              label: const Text("START"),
                            ),
                          ),
                        )
                      : vmHome.racingModel.isStart()
                          ? Padding(
                              padding: const EdgeInsets.only(left: 31, bottom: 70),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: FloatingActionButton.extended(
                                  onPressed: !(vmHome.racingModel.isStart())
                                      ? null
                                      : () {
                                          // vm.onCheckin(context, controller.text, isByCardScan: false);
                                          vmHome.onRace(context, vmHome.txtCardNumberController.text, action: "FINISH");
                                        },
                                  icon: const Icon(Icons.emoji_flags_rounded),
                                  label: const Text("FINISH"),
                                ),
                              ),
                            )
                          : vmHome.racingModel.isFinish() || vmHome.racingModel.isDnf()
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 31, bottom: 70),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: FloatingActionButton.extended(
                                      onPressed: !(vmHome.racingModel.isFinish() || vmHome.racingModel.isDnf())
                                          ? null
                                          : () {
                                              // vm.onCheckin(context, controller.text, isByCardScan: false);
                                              vmHome.onRace(context, vmHome.txtCardNumberController.text, action: "CONFIRM_FINISH");
                                              if (!focusNodeKb.hasFocus) {
                                                FocusScope.of(Get.context!).requestFocus(focusNodeKb);
                                              }
                                            },
                                      icon: const Icon(Icons.emoji_flags_rounded),
                                      label: const Text("CONFIRM FINISH"),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                ],
              ),
            );
    }));
  }
}
