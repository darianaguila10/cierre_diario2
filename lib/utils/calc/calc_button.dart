import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CalcButton extends StatelessWidget {
  final String text;
  final int? fillColor;
  final int textColor;
  final double textSize;
  final Function callback;
  final Icon? icon;

  const CalcButton(
      {Key? key,
       this.text='',
       this.fillColor,
      this.textColor = 0xFFFFFFFF,
      this.textSize = 20,
      required this.callback,
       this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: SizedBox(
        width: 60,
        height: 60,
        child: TextButton(
          onPressed: () {
            callback(text);
          },
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
            backgroundColor: fillColor != null ? Color(fillColor!) : null,
            primary: Color(textColor),
          ),
          child: getIconText(),
        ),
      ),
    );
  }

  getIconText() {
    if (icon != null) return icon;
    return Text(
      text,
      maxLines: 1,
      style: TextStyle(
        fontSize: textSize,
      ),
    );
  }
}
