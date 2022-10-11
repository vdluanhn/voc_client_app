import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:voc_client_app/models/RacingDataOrder.dart';
import 'package:voc_client_app/modules/checkin/view_model/checkin_vm.dart';

import '../../../commons/themes/alert_dialog.dart';
import '../../../commons/themes/helper.dart';
import '../../../commons/widgets/InputFormFieldCustom.dart';

class CheckinPage extends StatefulWidget {
  const CheckinPage({super.key});

  @override
  State<CheckinPage> createState() => _CheckinPageState();
}

class _CheckinPageState extends State<CheckinPage> {
  FocusNode focusNodeKb = FocusNode();
  TextEditingController controller = TextEditingController();

  String inputStr = "";
  @override
  void initState() {
    super.initState();

    var vm = Provider.of<CheckinVM>(context, listen: false);
    vm.resetPage();
    vm.initDataPage(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // focusNode.dispose();
    // controller.dispose();
  }

  static bool canPop(BuildContext context) {
    final NavigatorState? navigator = Navigator.maybeOf(context);
    return navigator != null && navigator.canPop();
  }

  @override
  Widget build(BuildContext context) {
    if (!focusNodeKb.hasFocus) {
      FocusScope.of(Get.context!).requestFocus(focusNodeKb);
    }
    return Consumer<CheckinVM>(builder: (context, vm, child) {
      return RawKeyboardListener(
        autofocus: true,
        focusNode: focusNodeKb,
        onKey: (RawKeyEvent event) async {
          if (event is RawKeyDownEvent && event.data is RawKeyEventDataAndroid) {
            print("-------> ${event.data.logicalKey.keyLabel}");
            if (event.data.logicalKey.keyLabel != null && event.data.logicalKey.debugName != "Enter") {
              inputStr = inputStr + event.data.logicalKey.keyLabel;
            }
            if (event.data.logicalKey.debugName == "Enter" || event.isKeyPressed(LogicalKeyboardKey.enter)) {
              print("------->>> $inputStr");
              inputStr = inputStr.replaceAll('Enter', '').trim();
              setState(() {
                vm.txtCardNumberController.text = inputStr;
              });
              Navigator.of(context).maybePop();
              // if (inputStr.length == 10 || inputStr.length == 24) {
              await vm.onCheckin(context, inputStr, isByCardScan: true);
              // }
              inputStr = "";
            }
          }
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 120),
              child: Column(
                children: [...List.generate(vm.checkinDatas.length, (index) => CheckinItem(datas: vm.checkinDatas, index: index))],
              ),
            ),
          ),
          floatingActionButton: Container(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                onPressed: () {
                  vm.showConfirmCheckin = true;
                  // FocusScope.of(context).requestFocus(vm.focusNode);
                  showAlertDialog(context,
                      widget: Material(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            InputFormFieldCustom(
                              focusNode: focusNodeKb,
                              controller: vm.txtCardNumberController,
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
                        vm.txtCardNumberController.clear();
                        Navigator.of(context).maybePop();
                      },
                      buttonName2: 'Bắt đầu',
                      callback2: () {
                        if ((!isEmpty(vm.txtCardNumberController.text))) {
                          Navigator.of(context).maybePop();
                          vm.onCheckin(context, vm.txtCardNumberController.text, isByCardScan: false);
                        } else {
                          showToastMessage(Get.context!, message: 'Vui lòng nhập mã thẻ đội thi');
                        }
                      });
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text("Checkin"),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class CheckinItem extends StatelessWidget {
  const CheckinItem({Key? key, required this.index, required this.datas})
      : super(
          key: key,
        );

  final int index;
  final List<RacingDataOrder> datas;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (() {
          print("on click item ${datas[index].team?.cardNumber}");
        }),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${datas[index].team!.racingOrder} - ${datas[index].team!.teamName!}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            Text(datas[index].racing!.checkinTime == null ? "Chưa checkin" : DateFormat('dd/MM/yyyy HH:mm:ss.SSS').format(datas[index].racing!.checkinTime!)),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${datas[index].team!.cardNumber}'),
                Text('${datas[index].racing!.racingState}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
