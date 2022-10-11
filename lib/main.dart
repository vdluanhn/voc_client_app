import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:voc_client_app/main_screen.dart';
import 'package:voc_client_app/modules/checkin/view_model/checkin_vm.dart';
import 'package:voc_client_app/modules/login/view_model/login_vm.dart';
import 'package:voc_client_app/modules/menu/view_model/menu_vm.dart';
import 'package:voc_client_app/modules/setting/view_model/bluetooth_setting_vm.dart';
import 'package:voc_client_app/root_screen.dart';
import 'package:voc_client_app/services/bluetooth_control/bluetooth_service.dart';

import 'commons/model/AppConfig.dart';
import 'commons/themes/app_theme.dart';
import 'modules/home/view_model/home_vm.dart';
import 'modules/login/screen/login_page.dart';
import 'modules/login/view_model/user_vm.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

checkPerm() async {
  if (await Permission.contacts.request().isGranted) {
    // Either the permission was already granted before or the user just granted it.
  }

// You can request multiple permissions at once.
  Map<Permission, PermissionStatus> statuses = await [
    Permission.location,
    Permission.storage,
  ].request();
  print(statuses[Permission.location]);
  if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
    // Use location.
  }
  var status = await Permission.bluetooth.status;
  if (status.isDenied) {
    await Permission.bluetooth.request();
  }
  if (await Permission.bluetooth.status.isPermanentlyDenied) {
    openAppSettings();
  }

  PermissionStatus _permissionStatus = PermissionStatus.denied;

  debugPrint(" ---------------- Asking for permission...");
  await Permission.manageExternalStorage.request();
  if (await Permission.manageExternalStorage.request().isGranted) {
    PermissionStatus permissionStatus = await Permission.manageExternalStorage.status;
    _permissionStatus = permissionStatus;
  }
}

Future<bool> requestPermission() async {
  List<Permission> requestPermissions = [
    Permission.bluetoothScan,
    Permission.bluetoothAdvertise,
    Permission.bluetoothConnect,
    Permission.location,
  ];
  for (Permission element in requestPermissions) {
    print(await element.status);
    if (await element.isPermanentlyDenied) {
      // await openAppSettings();
    } else {
      await element.request();
    }
  }
  if (await Permission.locationAlways.isDenied) {
    // await openAppSettings();
  }
  return true;
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermission();
  await GlobalConfiguration().loadFromAsset("app_settings");
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String _osVersion = '';
  String _deviceId = '', _deviceName = '';
  try {
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      _osVersion = iosDeviceInfo.systemVersion;
      _deviceId = iosDeviceInfo.identifierForVendor;
      _deviceName = iosDeviceInfo.model;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      _osVersion = androidDeviceInfo.version.release;
      _deviceId = androidDeviceInfo.androidId;
      _deviceName = androidDeviceInfo.model;

      if (androidDeviceInfo.version.sdkInt >= 31) {
        await [Permission.bluetoothConnect, Permission.bluetoothScan, Permission.bluetoothAdvertise, Permission.location].request();
      } else {
        await [Permission.bluetooth, Permission.location].request();
      }
    }
  } catch (ex) {
    print('-- Exception: ${ex.toString()}');
  }
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  var configuredApp = AppConfig(
    appName: packageInfo.appName,
    appVersion: packageInfo.version,
    appId: packageInfo.packageName,
    platform: Platform.isAndroid
        ? 'ANDROID'
        : Platform.isIOS
            ? 'IOS'
            : 'Unknown',
    osVersion: _osVersion,
    deviceId: _deviceId,
    deviceName: _deviceName,
    child: const MyApp(),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeVM>(
          create: (context) => HomeVM(),
        ),
        ChangeNotifierProvider<UserVM>(
          create: (context) => UserVM(),
        ),
        ChangeNotifierProvider<LoginVM>(
          create: (context) => LoginVM(),
        ),
        ChangeNotifierProvider<MenuVM>(
          create: (context) => MenuVM(),
        ),
        ChangeNotifierProvider<MainScreenVM>(
          create: (context) => MainScreenVM(),
        ),
        ChangeNotifierProvider<CheckinVM>(
          create: (context) => CheckinVM(),
        ),
        ChangeNotifierProvider<BluetoothSettingVM>(
          create: (context) => BluetoothSettingVM(),
        ),
        Provider(
          create: (_) => BluetoothService(),
        ),
      ],
      child: GetMaterialApp(
        // localizationsDelegates: const [
        //   DefaultWidgetsLocalizations.delegate,
        // ],
        // supportedLocales: const [Locale('vi'), Locale('en')],
        title: "VOC",
        theme: buildThemeData(),
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/home': (_) => const RootScreen(),
          '/': (_) => const LoginPage(),
        },
      ),
    );
  }
}
