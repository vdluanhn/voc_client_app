import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppConfig extends InheritedWidget {
  AppConfig({
    required this.appName,
    required this.appVersion,
    required this.appId,
    required this.platform,
    required this.osVersion,
    required this.deviceId,
    required this.deviceName,
    required Widget child,
  }) : super(child: child);

  final String appName;
  final String appVersion;
  final String appId;
  final String platform;
  final String osVersion;
  final String deviceId;
  final String deviceName;

  static AppConfig? of(BuildContext? context) {
    return context?.dependOnInheritedWidgetOfExactType<AppConfig>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
