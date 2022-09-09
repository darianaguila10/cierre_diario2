import 'dart:math';

import 'package:intl/intl.dart';



String formatearMoneda(double cant, {symbol = true}) {
  NumberFormat numberFormat = new NumberFormat("#,##0.##", "en");
  String activeSymbol = symbol ? "\$" : "";
  if (cant.abs() <= 999999.99) return activeSymbol + numberFormat.format(cant);

  int cantE = cant ~/ pow(10, 6);

  NumberFormat numberFormatM = new NumberFormat("#,##0", "en");
  return activeSymbol + numberFormatM.format(cantE) + " M";
}

//este no muesta lo del Million
String formatCoin(double cant, {symbol = true}) {
  NumberFormat numberFormat = new NumberFormat("#,##0.##", "en");
  return (symbol ? "\$" : "") + numberFormat.format(cant);
}

//este es para los form
String formatCoinForm(double cant) {
  NumberFormat numberFormat = new NumberFormat("#0.##", "en");
  return  numberFormat.format(cant);
} 

String formatMonedaForm(double cant) {
  NumberFormat numberFormat = new NumberFormat("0.##", "en");

  return numberFormat.format(cant);
}
