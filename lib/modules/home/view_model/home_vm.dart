import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:voc_client_app/services/bluetooth_control/bluetooth_service.dart';
import 'package:voc_client_app/services/racing/racing_service.dart';

import '../../../commons/themes/alert_dialog.dart';
import '../../../commons/themes/helper.dart';
import '../../../commons/widgets/InputFormFieldCustom.dart';
import '../../../models/RacingModel.dart';
import '../../../models/RacingViolation.dart';
import '../../../models/Team.dart';
import '../../../services/team/team_service.dart';
import '../../login/view_model/user_vm.dart';

class HomeVM extends ChangeNotifier {
  FocusNode focusNode = FocusNode();
  bool isReady = false;
  bool processing = false;
  bool initPageFail = false;
  bool isEnableCancelDNF = false;
  late RacingModel racingModel;
  TeamService teamService = TeamService();
  RacingService racingService = RacingService();
  List<RacingViolation> raceViolations = [];
  late RacingViolation vioErr10;
  late RacingViolation vioErr30;
  String startTimeStr = "00:00:00.000";
  String finishTimeStr = "00:00:00.000";
  String teamCarName = 'Nhấn sẵn sàng để chuẩn bị vào thi';

  DateTime timeFinish = DateTime.now();
  int totalTimeFinish = 0;
  int nErr10s = 0;
  int nErr30s = 0;

  bool isShowPopupConfirmFinish = false;
  BuildContext? contextShowed;

  TextEditingController txtCardNumberController = TextEditingController();

  final StopWatchTimer stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    onChange: (value) {
      // print('onChange $value');
    },
    onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
    onStopped: () {
      print('onStop');
    },
    onEnded: () {
      print('onEnded');
    },
  );

  void resetState() async {
    try {
      vioErr10 = RacingViolation();
      vioErr30 = RacingViolation();
      if (!stopWatchTimer.isRunning) {
        racingModel = RacingModel();
        isEnableCancelDNF = false;
        isReady = false;
      }
    } catch (e) {
      print(e);
    }

    processing = false;
  }

  void initWorkerTimer() {
    // final Bluetooth bluetooth = Provider.of<BluetoothService>(Get.context!, listen: false);
    stopWatchTimer.rawTime.listen((value) {
      // print('rawTime $value ${StopWatchTimer.getDisplayTime(value)} STATE ${racingModel.currentRacingState}');
      totalTimeFinish = value;
      timeFinish = DateTime.now();
      if (racingModel.currentRacingState == RacingState.READY) {
        finishTimeStr = "00:00:00.000";
      } else {
        finishTimeStr = DateFormat("HH:mm:ss.SSS").format(timeFinish);
        var durationTotalTime = Duration(milliseconds: totalTimeFinish);
        totalTime =
            "${durationTotalTime.inHours.remainder(60).toString().padLeft(2, '0')}:${durationTotalTime.inMinutes.remainder(60).toString().padLeft(2, '0')}:${durationTotalTime.inSeconds.remainder(60).toString().padLeft(2, '0')}.${durationTotalTime.inMilliseconds.remainder(1000).toString().padLeft(3, '0')}";
      }
      // bluetooth.write(totalTime);
      notifyListeners();
    });
    stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
    stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
    stopWatchTimer.records.listen((value) => print('records $value'));
    stopWatchTimer.fetchStopped.listen((value) {
      print('stopped from stream');
    });
    stopWatchTimer.fetchEnded.listen((value) {
      print('ended from stream');
    });
  }

  int msLNH = 0;
  int msLNG = 0;
  String timeLNH = "00:00";
  String timeLNG = "00:00";
  String totalTime = "00:00:00.000";
  void onChangeLNH(int value) {
    nErr10s = value;
    int sDurations = 10 * value;
    Duration duration = Duration(seconds: sDurations);
    timeLNH = "${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}";
    if (racingModel.isFinish()) {
      racingModel.setLNH(value);
    }
    vioErr10 = RacingViolation(violationTypeCode: "LNH", quantity: value);
    msLNH = sDurations * 1000;
    var durationTotalTime = Duration(milliseconds: racingModel.getTotalTime().toInt());
    if (!racingModel.isDnf()) {
      totalTime =
          "${durationTotalTime.inHours.remainder(60).toString().padLeft(2, '0')}:${durationTotalTime.inMinutes.remainder(60).toString().padLeft(2, '0')}:${durationTotalTime.inSeconds.remainder(60).toString().padLeft(2, '0')}.${durationTotalTime.inMilliseconds.remainder(1000).toString().padLeft(3, '0')}";
    }
    notifyListeners();
  }

  void onChangeLNG(int value) {
    nErr30s = value;
    int sDurations = 30 * value;
    Duration duration = Duration(seconds: sDurations);
    timeLNG = "${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}";
    if (racingModel.isFinish()) {
      racingModel.setLNG(value);
    }
    vioErr30 = RacingViolation(violationTypeCode: "LNG", quantity: value);
    msLNG = sDurations * 1000;
    var durationTotalTime = Duration(milliseconds: racingModel.getTotalTime().toInt());
    if (!racingModel.isDnf()) {
      totalTime =
          "${durationTotalTime.inHours.remainder(60).toString().padLeft(2, '0')}:${durationTotalTime.inMinutes.remainder(60).toString().padLeft(2, '0')}:${durationTotalTime.inSeconds.remainder(60).toString().padLeft(2, '0')}.${durationTotalTime.inMilliseconds.remainder(1000).toString().padLeft(3, '0')}";
    }
    notifyListeners();
  }

  void onClickReadyGUI(bool isValue) {
    if (isValue) {
      resetGUI();
    } else {}
  }

  void resetGUI() {
    startTimeStr = "00:00:00.000";
    finishTimeStr = "00:00:00.000";
    stopWatchTimer.onStopTimer();
    stopWatchTimer.onResetTimer();
    isEnableCancelDNF = false;
    isShowPopupConfirmFinish = false;
    nErr10s = 0;
    nErr30s = 0;
    timeLNH = "00:00";
    timeLNG = "00:00";
    totalTime = "00:00:00.000";
    vioErr10 = RacingViolation();
    vioErr30 = RacingViolation();
  }

  void onClickReadyOrNot(bool isValue) {
    racingModel = RacingModel();
    isReady = isValue;
    print('SAN SANG : $isReady');
    if (isValue) {
      racingModel.onReady();
      onClickReadyGUI(isValue);
      teamCarName = 'Mời quẹt thẻ để bắt đầu thi';
      txtCardNumberController.clear();
    } else {
      racingModel.onNotReady();
      teamCarName = 'Nhấn sẵn sàng để chuẩn bị vào thi';
    }
    notifyListeners();
  }

  Future onRace(BuildContext context, String cardNumber, {String action = ""}) async {
    var userVM = Provider.of<UserVM>(context, listen: false);
    if (isEmpty(cardNumber) && userVM.actionManual) {
      //  FocusScope.of(context).requestFocus(focusNode);
      // showAlertDialog(context,
      //     widget: Material(
      //       color: Colors.transparent,
      //       child: Column(
      //         children: [
      //           const SizedBox(height: 10),
      //           InputFormFieldCustom(
      //             controller: txtCardNumberController,
      //             showSuffixIcon: ShowSuffixIcon.AUTO,
      //             lableText: "Nhập mã thẻ",
      //             hintText: "Nhập mã thẻ",
      //             onTextChange: (value) {},
      //           )
      //         ],
      //       ),
      //     ),
      //     title: 'Mã thẻ đội thi',
      //     buttonName1: 'Để sau',
      //     callback1: () {
      //       txtCardNumberController.clear();
      //       Navigator.pop(context);
      //     },
      //     buttonName2: 'Bắt đầu',
      //     callback2: () {
      //       if ((!isEmpty(txtCardNumberController.text))) {
      //         Navigator.of(context).pop();
      //         onRace(context, txtCardNumberController.text);
      //       } else {
      //         showToastMessage(Get.context!, message: 'Vui lòng nhập mã thẻ đội thi');
      //       }
      //     });
      return;
    }

    print('INPUT OLD: $cardNumber - ${racingModel.currentRacingState} - $racingModel');
    Team? team = await teamService.findTeamByCard(context, cardNumber);
    if (team == null) {
      showAlertDialog(
        Get.context!,
        message: "Không tồn tại đội thi ứng với mã thẻ: $cardNumber",
        buttonName1: 'OK',
        callback1: () => Navigator.pop(Get.context!),
      );
    } else {
      print('INPUT OLD: $cardNumber - ${racingModel.currentRacingState} - ${team.carName}');
      if (racingModel.isNotReady()) {
        print("Chua san san");
        showToastMessage(Get.context!, message: "Mã thẻ $cardNumber chưa sẵn sáng!");
        return;
      } else if (action == "START" || racingModel.isReady()) {
        print("Da san san");
        // ignore: use_build_context_synchronously
        onClickStart(context, team);
      } else if (action == "FINISH" || racingModel.isStart()) {
        print("Da bat dau, dang thi");
        // ignore: use_build_context_synchronously
        onClickFinish(context, cardNumber);
      } else if (action == "CONFIRM_FINISH" || racingModel.isFinish()) {
        print("Da ket thuc - dang nhan xac nhan ket thuc");
        if (!isShowPopupConfirmFinish) {
          isShowPopupConfirmFinish = true;
          contextShowed = Get.context!;
          print("---------------click lan 1 hoan thanh");
          // ignore: use_build_context_synchronously
          showAlertDialog(context,
              title: "Xác nhận kết thúc bài thi",
              message: 'Mời $teamCarName \nQUẸT THẺ ĐỂ XÁC NHẬN HOÀN THÀNH BÀI THI.',
              buttonName2: 'Đồng ý',
              callback2: () async {
                Navigator.maybePop(context);
                onClickCompletedForce(context, cardNumber); //Nguoi bam tren giao dien thi la force
              },
              buttonName1: 'Bỏ qua',
              callback1: () {
                isShowPopupConfirmFinish = false;
                Navigator.maybePop(context);
              });
        } else {
          print("---------------click lan 2 hoan thanh");
          // ignore: use_build_context_synchronously
          Navigator.maybePop(Get.context!);
          // ignore: use_build_context_synchronously
          onClickCompletedByTeam(Get.context!, cardNumber);
          isShowPopupConfirmFinish = false;
        }
      }
      print('INPUT NEW: $cardNumber - ${racingModel.currentRacingState} - ${team.carName}');
      notifyListeners();
    }
  }

  //Click vao button chuc nang xac nhan hoan thanh
  void onClickConfirmFinish() {
    if (racingModel.isFinish()) {
      isShowPopupConfirmFinish = true;
      showAlertDialog(Get.context!,
          title: "Xác nhận kết thúc bài thi",
          message: 'Mời $teamCarName \nQUẸT THẺ ĐỂ XÁC NHẬN HOÀN THÀNH BÀI THI.',
          buttonName2: 'Đồng ý',
          callback2: () async {
            Navigator.pop(Get.context!);
            onClickCompletedForce(Get.context!, racingModel.racingTeam!.cardNumber!);
            isShowPopupConfirmFinish = false;
          },
          buttonName1: 'Bỏ qua',
          callback1: () {
            isShowPopupConfirmFinish = false;
            Navigator.pop(Get.context!);
          });
    } else {
      showAlertDialog(Get.context!, title: "Thông báo", message: 'Chưa hoàn thành bài thi', buttonName1: 'Đồng ý', callback1: () async {
        Navigator.pop(Get.context!);
      });
    }
  }

  void onClickStartGUI() {
    teamCarName = 'Đội thi: [${racingModel.racingTeam?.racingOrder!} - ${racingModel.racingTeam?.teamName!}] - Mã thẻ: [${racingModel.racingTeam?.cardNumber!}]';
    isEnableCancelDNF = true;
  }

  //start game
  void onClickStart(BuildContext context, Team team) async {
    try {
      print("onClickStart: ${team.cardNumber} - ${racingModel.currentRacingState}");
      var userVM = Provider.of<UserVM>(context, listen: false);
      //1.  Goi ham start local
      var startDate = await racingModel.onStart(team, userVM.racingTypeSelected!.racingTypeCode!);
      startTimeStr = DateFormat('HH:mm:ss.SSS').format(startDate);
      //2. Start dong ho dem
      stopWatchTimer.onStartTimer();
      //3. Update GUI
      onClickStartGUI();
      //4. Luu racing start vao local may
      UserVM userVm = Provider.of<UserVM>(Get.context!, listen: false);
      String keyStart = "START_${userVm.racingLevelSelected?.racingLevelCode}_${userVm.racingTypeSelected?.racingTypeCode}_${team.cardNumber}_${team.teamId}";
      // LocalStorageService.writeItem(keyStart, jsonEncode(racingModel));
      //5. Goi API start len server
      String startTime = formatISOTime(startDate);
      racingService.start(team.cardNumber!, userVM.racingTypeSelected!.racingTypeCode!, startTime);
      //6. Update start len LED

      //7. End notif Widget
      notifyListeners();
    } on Exception catch (e) {
      //Thong bao neu start loi
      showAlertDialog(
        Get.context!,
        message: e.toString(),
        buttonName1: 'OK',
        callback1: () => Navigator.pop(Get.context!),
      );
    }
  }

  void onClickFinishGUI() {
    var durationTotalTime = Duration(milliseconds: racingModel.getTotalTime().toInt());
    totalTime =
        "${durationTotalTime.inHours.remainder(60).toString().padLeft(2, '0')}:${durationTotalTime.inMinutes.remainder(60).toString().padLeft(2, '0')}:${durationTotalTime.inSeconds.remainder(60).toString().padLeft(2, '0')}.${durationTotalTime.inMilliseconds.remainder(1000).toString().padLeft(3, '0')}";
    totalTimeFinish = racingModel.getTotalTime().toInt();
  }

  int nsAllowFinish = 5;
  void onClickFinish(BuildContext context, String cardNumber) async {
    try {
      print("onClickFinish: $cardNumber - ${racingModel.currentRacingState}");
      //1. Valid
      if (!racingModel.allowFinish(nsAllowFinish)) {
        showToastMessage(context, message: "Ít nhất $nsAllowFinish (s) mới có thể hoàn thành!");
        return;
      }
      var userVm = Provider.of<UserVM>(context, listen: false);
      //2. Finish local phan thi
      var finishDate = await racingModel.onFinish(cardNumber);
      //3. Stop dong ho dem gio

      stopWatchTimer.onStopTimer();
      //4. Goi API dong bo finish len server
      String finishTime = formatISOTime(finishDate);
      finishTimeStr = DateFormat('HH:mm:ss.SSS').format(finishDate);
      racingService.finish(cardNumber, userVm.racingTypeSelected!.racingTypeCode!, finishTime);
      //5. Finish len GUI
      onClickFinishGUI();
      //6. Luu thong tin local may
      String keyFinish = "FINISH_${userVm.racingLevelSelected?.racingLevelCode}_${userVm.racingTypeSelected?.racingTypeCode}_${racingModel.racingTeam?.cardNumber}_${racingModel.racingTeam?.teamId}";
      // LocalStorageService.writeItem(keyFinish, jsonEncode(racingModel));

      //7. Sync finish len LED

      //8. Notif update Widgets
      notifyListeners();
    } on Exception catch (e) {
      showAlertDialog(
        Get.context!,
        message: e.toString(),
        buttonName1: 'OK',
        callback1: () => Navigator.pop(Get.context!),
      );
    }
  }

  void onClickCompletedByTeamGUI() {
    isEnableCancelDNF = false;
  }

  String reasonCompleted = "";
  void onClickCompletedByTeam(BuildContext context, String cardNumber) async {
    if (!processing) {
      processing = true;
      notifyListeners();
    }
    try {
      var userVm = Provider.of<UserVM>(context, listen: false);
      //1. Stop timer
      stopWatchTimer.onStopTimer();
      //2. Gọi ham complete local
      racingModel.onComplete();
      //3. Call API dong bo du lieu len server
      raceViolations = [];
      if (vioErr10.quantity > 0) raceViolations.add(vioErr10);
      if (vioErr30.quantity > 0) raceViolations.add(vioErr30);
      if (racingModel.dnf) {
        racingService.completeForce(cardNumber, userVm.racingTypeSelected!.racingTypeCode!, reasonCompleted, "DNF", raceViolations);
      } else {
        racingService.completeByTeam(cardNumber, userVm.racingTypeSelected!.racingTypeCode!, reasonCompleted, null, raceViolations);
      }
      //4. Luu lai trang thai vao storage local
      String keyFinish = "FINISH_${userVm.racingLevelSelected?.racingLevelCode}_${userVm.racingTypeSelected?.racingTypeCode}_${racingModel.racingTeam?.cardNumber}_${racingModel.racingTeam?.teamId}";
      // LocalStorageService.writeItem(keyFinish, jsonEncode(racingModel));
      //5. Update giao dien
      onClickCompletedByTeamGUI();
      //6. Set ve not ready
      onClickReadyOrNot(false);
    } on Exception catch (e) {
      showAlertDialog(
        Get.context!,
        message: e.toString(),
        buttonName1: 'OK',
        callback1: () => Navigator.pop(Get.context!),
      );
    } finally {
      processing = false;
      notifyListeners();
    }
  }

  void onClickCompletedForce(BuildContext context, String cardNumber) async {
    if (!processing) {
      processing = true;
      notifyListeners();
    }
    try {
      var userVm = Provider.of<UserVM>(context, listen: false);
      //1. Stop timer
      stopWatchTimer.onStopTimer();

      //2. Gọi ham complete local
      racingModel.onComplete();
      //3. Call API dong bo du lieu len server
      raceViolations = [];
      if (vioErr10.quantity > 0) raceViolations.add(vioErr10);
      if (vioErr30.quantity > 0) raceViolations.add(vioErr30);
      racingService.completeForce(cardNumber, userVm.racingTypeSelected!.racingTypeCode!, reasonCompleted, racingModel.isDnf() ? 'DNF' : null, raceViolations);
      //4. Luu lai trang thai vao storage local
      String keyFinish =
          "COMPLETE_FORCE_${userVm.racingLevelSelected?.racingLevelCode}_${userVm.racingTypeSelected?.racingTypeCode}_${racingModel.racingTeam?.cardNumber}_${racingModel.racingTeam?.teamId}";
      // LocalStorageService.writeItem(keyFinish, jsonEncode(racingModel));
      //5. Update giao dien
      onClickCompletedByTeamGUI();
      //6. Set ve not ready
      onClickReadyOrNot(false);
    } on Exception catch (e) {
      showAlertDialog(
        Get.context!,
        message: e.toString(),
        buttonName1: 'OK',
        callback1: () => Navigator.pop(Get.context!),
      );
    } finally {
      processing = false;
      notifyListeners();
    }
  }

  void onClickDNFGUI() {
    isEnableCancelDNF = false;
    totalTime = "DNF";
  }

  void onClickDNF(BuildContext context, String cardNumber) async {
    try {
      print("onClickDNF: ${racingModel.currentRacingState}");
      showAlertDialog(
        Get.context!,
        message: 'DNF bài thì sẽ không thể khôi phục lại được. \nBạn chắc chắn muốn DNF bài thi?',
        buttonName1: 'Đồng ý',
        callback1: () {
          Navigator.pop(Get.context!);
          //1. Goi ham local DNF
          racingModel.onDnf();
          //2. Stop dong ho dem gio
          stopWatchTimer.onStopTimer();
          //3. Luu trang thai vao localmay
          var userVm = Provider.of<UserVM>(context, listen: false);
          String keyFinish = "DNF_${userVm.racingLevelSelected?.racingLevelCode}_${userVm.racingTypeSelected?.racingTypeCode}_${racingModel.racingTeam?.cardNumber}_${racingModel.racingTeam?.teamId}";
          // LocalStorageService.writeItem(keyFinish, jsonEncode(racingModel));
          // //4. Goi API luu trang thai len server
          // racingService.completeForce(cardNumber, userVM.racingTypeSelected!.racingTypeCode!, "", 'DNF', raceViolations);
          //5. Update giao dien
          onClickDNFGUI();
          //7. Dong popup
        },
        buttonName2: 'Bỏ qua',
        callback2: () => Navigator.pop(Get.context!),
      );
    } on Exception catch (e) {
      showAlertDialog(
        Get.context!,
        message: e.toString(),
        buttonName1: 'OK',
        callback1: () => Navigator.pop(Get.context!),
      );
    } finally {
      notifyListeners();
    }
  }

  void onUndoRacing(BuildContext context) async {
    try {
      print("onUndoRacing: ${racingModel.currentRacingState}");

      var userVm = Provider.of<UserVM>(context, listen: false);
      if (racingModel.currentRacingState != RacingState.NOT_READY) {
        showAlertDialog(
          Get.context!,
          message: 'Hủy bài thi sẽ không quay lại được. Bạn chắc chắn muốn hủy bài thi để thi lại?',
          buttonName1: 'Đồng ý',
          callback1: () {
            Navigator.pop(Get.context!);
            //1. Stop dong ho dem
            stopWatchTimer.onStopTimer();
            stopWatchTimer.onResetTimer();
            //2. Huy bai thi
            racingModel.onDispose();
            //3. Goi API huy bai thi
            racingService.undoRacing(racingModel.racingTeam!.cardNumber!, userVm.racingTypeSelected!.racingTypeCode!);
            //4. Restart lai racing
            racingModel = RacingModel();
            //5. Reset trạng thai NotReady
            onClickReadyOrNot(false);
            resetGUI();
            //6. Reset led controller
            String keyFinish =
                "DNF_${userVm.racingLevelSelected?.racingLevelCode}_${userVm.racingTypeSelected?.racingTypeCode}_${racingModel.racingTeam?.cardNumber}_${racingModel.racingTeam?.teamId}";
            // LocalStorageService.writeItem(keyFinish, jsonEncode(racingModel));

            //7. Dong popup
          },
          buttonName2: 'Bỏ qua',
          callback2: () => Navigator.pop(Get.context!),
        );
        notifyListeners();
      } else {
        showAlertDialog(
          Get.context!,
          message: 'Chưa bắt đầu bài thi',
          buttonName1: 'OK',
          callback1: () => Navigator.pop(Get.context!),
        );
      }
    } on Exception catch (e) {
      showAlertDialog(
        Get.context!,
        message: e.toString(),
        buttonName1: 'OK',
        callback1: () => Navigator.pop(Get.context!),
      );
    }
  }
}
