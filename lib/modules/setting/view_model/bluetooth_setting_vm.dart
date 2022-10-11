import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import 'package:voc_client_app/commons/themes/alert_dialog.dart';
import 'package:voc_client_app/commons/themes/helper.dart';

import '../../../services/bluetooth_control/bluetooth_service.dart';

class BluetoothSettingVM extends ChangeNotifier {
  TextEditingController keywordTC = TextEditingController();
  List<BluetoothDevice> blueDevices = [];
  bool initPageFail = false;
  bool processing = true;
  bool isFinish = false;
  late BluetoothDevice blueDeviceSelected;
  bool isConnected = false;
  bool isConnecting = false;

  //init page
  void resetPage() {
    keywordTC = TextEditingController(text: "1");
    processing = true;
    isFinish = false;
    blueDevices = [];
    initPageFail = false;
  }

  Future<void> loadDataInitPage(context) async {
    try {
      if (!processing) {
        processing = true;
      }
      var devices = await getDevices(context);
      if (isEmpty(devices)) {
        initPageFail = true;
      } else {
        initPageFail = false;
      }
    } catch (e) {
      initPageFail = true;
      print(e);
    } finally {
      processing = false;
      notifyListeners();
    }
  }

  Future onRefreshBlueDevices(BuildContext context) async {
    blueDevices = [];
    isFinish = false;
    await getDevices(context);
    notifyListeners();
  }

  Future onSearchBlueDevices(BuildContext context, String keyword) async {
    blueDevices = [];
    isFinish = false;
    await getDevices(context);
  }

  Future<List<BluetoothDevice>> getDevices(context) async {
    final Bluetooth bluetooth = Provider.of<BluetoothService>(context, listen: false);
    blueDevices = await bluetooth.getDevices();
    return blueDevices;
  }

  Future connect(BuildContext context) async {
    final Bluetooth bluetooth = Provider.of<BluetoothService>(context, listen: false);
    bool status = await bluetooth.connectTo(blueDeviceSelected.address);
    print('Connect bluetooth: $status');
    if (status) {}
    isConnected = status;
    isConnecting = false;
    await getDevices(context);
    notifyListeners();
  }

  Future disconnect(BuildContext context) async {
    final Bluetooth bluetooth = Provider.of<BluetoothService>(context, listen: false);
    var status = bluetooth.disconnect();
    isConnected = false;
    print('DisConnect bluetooth: $status');
    await getDevices(context);
    notifyListeners();
  }

  void onChangeBlueDeviceSelected(BluetoothDevice device) {
    blueDeviceSelected = device;
    notifyListeners();
  }

  Future<void> onSendMessageViaBlue(BuildContext context, String message) async {
    final Bluetooth bluetooth = Provider.of<BluetoothService>(context, listen: false);
    bluetooth.write(message);
    showToastMessage(context, message: "Gui noi dung: $message THANH CONG!");
    notifyListeners();
  }

  Future<void> loadMore(context) async {
    // await getDevices(context);
    isFinish = true;
  }

  @override
  void dispose() {
    keywordTC.dispose();
    super.dispose();
  }
}
