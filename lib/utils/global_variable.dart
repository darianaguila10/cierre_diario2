class GlobalVariable {
  static final GlobalVariable _globalVariable = GlobalVariable._internal();

  static int numberStarts = 0;

  static get getnumberStarts => numberStarts;

  static addNumberStarts({int value=1}) {
    numberStarts += value;
  }

  factory GlobalVariable() {
    return _globalVariable;
  }

  GlobalVariable._internal();
}
