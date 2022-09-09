
import 'package:flutter/material.dart';


import 'package:cierre_diario2/utils/calc/calc.dart';

showCalc(BuildContext context, {required String amount}) {


    return showModalBottomSheet(
      backgroundColor:Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft:Radius.circular(25.0),topRight: Radius.circular(25.0)),
        ),
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: false,
        builder: (context) {
          return Calc(amount: amount,);
        });
  }