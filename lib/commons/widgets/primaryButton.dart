import 'package:flutter/material.dart';

import '../themes/app_color.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback? onPressed;
  final double radius;
  final BorderSide side;

  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = AppColor.buttonColor,
    this.textColor = AppColor.white,
    this.radius = 12,
    this.side = BorderSide.none,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: TextButton.styleFrom(
        shadowColor: Colors.transparent,
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius), side: side),
        padding: EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 14.0,
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16.0),
      ),
    );
  }
}
