// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ShowSuffixIcon { SHOW, HIDE, AUTO }

class InputFormFieldCustom extends StatefulWidget {
  final TextEditingController? controller;
  final String lableText;
  final String hintText;
  final Function(String)? onTextChange;
  final Function(String)? onSubmitOnKeyboard;
  final bool obscureText;
  final double height;
  final TextInputType keyboardType;
  final TextInputAction keyboardAction;
  final double fontSize;
  final double radius;
  final Function()? onTapSuffixIcon;
  final Widget? prefixIcon;
  final Icon suffixIcon;
  final ShowSuffixIcon showSuffixIcon;
  final bool enable;
  final String? regexInput;
  final int? maxLeght;
  final FocusNode? focusNode;
  final int? minLines;
  final int? maxLines;
  const InputFormFieldCustom({
    this.controller,
    this.onTextChange,
    this.lableText = '',
    this.hintText = 'Enter keyword',
    this.obscureText = false,
    this.height = 44.0,
    this.fontSize = 14.0,
    this.radius = 8.0,
    this.keyboardType = TextInputType.text,
    this.onTapSuffixIcon,
    this.prefixIcon,
    this.suffixIcon = const Icon(Icons.clear),
    this.showSuffixIcon = ShowSuffixIcon.AUTO,
    Key? key,
    this.keyboardAction = TextInputAction.done,
    this.onSubmitOnKeyboard,
    this.enable = true,
    this.regexInput,
    this.maxLeght,
    this.focusNode,
    this.minLines = 1,
    this.maxLines = 4,
  }) : super(key: key);

  @override
  State<InputFormFieldCustom> createState() => _InputFormFieldCustomState();
}

class _InputFormFieldCustomState extends State<InputFormFieldCustom> {
  bool _isShowSuffIcon = false;
  bool _isEmpty(var object) {
    if (object == false || object == 'false' || object == 'null' || object == 'N/A' || object == null || object == {} || object == '') {
      return true;
    }
    if (object is Iterable && object.length == 0) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    if (!_isEmpty(widget.controller) && !_isEmpty(widget.controller?.text) && widget.showSuffixIcon == ShowSuffixIcon.AUTO) {
      _isShowSuffIcon = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      textInputAction: widget.keyboardAction,
      obscureText: widget.obscureText,
      textAlignVertical: TextAlignVertical.center,
      enabled: widget.enable,
      focusNode: widget.focusNode,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      autofocus: true,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        suffixIcon: (_isShowSuffIcon && widget.showSuffixIcon == ShowSuffixIcon.AUTO) || widget.showSuffixIcon == ShowSuffixIcon.SHOW
            ? IconButton(
                icon: widget.suffixIcon,
                onPressed: widget.onTapSuffixIcon ??
                    () {
                      widget.controller?.clear();
                      widget.onTextChange != null ? widget.onTextChange!("") : null;
                      setState(() {
                        _isShowSuffIcon = false;
                      });
                    },
              )
            : null,
        labelText: widget.lableText,
        hintText: widget.hintText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        // focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(SIZES.kRadiusDefault)), borderSide: BorderSide(color: Colors.green)),
        // border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(SIZES.kRadiusDefault)), borderSide: BorderSide(color: Colors.green)),
      ),
      onChanged: (value) {
        // ignore: unnecessary_statements
        widget.onTextChange == null ? null : widget.onTextChange!(value);
        setState(() {
          if (_isEmpty(value)) {
            _isShowSuffIcon = false;
          } else {
            _isShowSuffIcon = true;
          }
        });
      },
      onFieldSubmitted: (value) {
        FocusScope.of(context).unfocus();
        try {
          widget.onSubmitOnKeyboard!(value);
        } catch (e) {}
      },
      inputFormatters: [
        widget.regexInput != null ? FilteringTextInputFormatter.allow(RegExp(widget.regexInput!)) : FilteringTextInputFormatter.deny(""),
        widget.maxLeght != null ? LengthLimitingTextInputFormatter(widget.maxLeght) : LengthLimitingTextInputFormatter(4000),
      ],
    );
  }
}
