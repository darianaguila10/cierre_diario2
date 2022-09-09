import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Breakpoint {
  static const double sm = 500; // Small Mobile
  static const double md = 600; // Tablet
  static const double lg = 990; // Desktop
  static const double xl = 1240; // Large-desktop
  static const double xxl = 1440; // Extra extra large
}

extension MediaQueryValues on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
}

extension ContextEx on BuildContext {
  bool get isMobile => this.width <= Breakpoint.md;

  bool get isTablet => this.width < Breakpoint.lg && this.width >= Breakpoint.md;

  bool get isTabletOrLarger => this.width >= Breakpoint.md;

  bool get isDesktop => this.width >= Breakpoint.lg;

  //Orientation
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;

  bool get isLandscape => MediaQuery.of(this).orientation == Orientation.landscape;

  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 100;
}

extension ContextSize on BuildContext {
  // responsive height (movile or tablet)
  double respWidgetH(movile, tablet) => this.isTablet
      ? (this.isPortrait ? this.height : this.width) * tablet
      : (this.isPortrait ? this.height : this.width) * movile;

  double respText(refSize) {
    double unitHeightValue = (isPortrait ? height : width) * 0.001;
    double multiplier = 1.29;
    double value = (refSize * unitHeightValue) * multiplier;
    return value >= 11 ? value : 11;
  }

  double get respH => (this.isPortrait ? this.height : this.width);

  double get respW => (this.isPortrait ? this.width : this.height);
}

extension Stringformat on double {
  //form
  String formatCoinForm() {
    NumberFormat numberFormat = NumberFormat("#0.##", "en");
    return numberFormat.format(this);
  }

  String formatCoin({symbol = true}) {
    NumberFormat numberFormat = NumberFormat("#,##0.##", "en");
    return numberFormat.format(this);
  }
}

extension StringCoin on String {
  String capitalizeString() {
    return (this != null && this.length > 0) ? "${this[0].toUpperCase()}${this.substring(1)}" : '';
  }
}
