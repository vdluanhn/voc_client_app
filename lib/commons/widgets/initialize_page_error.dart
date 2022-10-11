import 'package:flutter/material.dart';
import 'package:voc_client_app/commons/themes/app_style.dart';

class InitPageError extends StatefulWidget {
  InitPageError({Key? key, this.iconData, this.errorMsg, required this.onRetry, this.buttonName, this.imageError}) : super(key: key);
  final IconData? iconData;
  final String? errorMsg;
  final String? buttonName;
  final Image? imageError;
  final Function() onRetry;

  @override
  _InitPageErrorState createState() => _InitPageErrorState();
}

class _InitPageErrorState extends State<InitPageError> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 200,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              child: widget.imageError ?? Image.asset("assets/images/init_page_error.png"),
              width: 80,
              height: 80,
            ),
            const SizedBox(height: 10),
            Text(widget.errorMsg ?? "Có lỗi khi khởi tạo trang, vui lòng thử lại.", style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            Container(
              width: 140,
              height: 40,
              decoration: DECORATIONS.BOX_DECORATION_MAIN,
              child: TextButton.icon(onPressed: widget.onRetry, icon: Icon(widget.iconData ?? Icons.refresh), label: Text(widget.buttonName ?? "Tải lại trang")),
            )
          ],
        ),
      ),
    );
  }
}
