
import 'package:auto_size_text/auto_size_text.dart';

import 'package:math_expressions/math_expressions.dart';
import 'package:flutter/material.dart';

import '../coin_converter.dart';
import 'calc_button.dart';

class Calc extends StatefulWidget {
  final routeName = 'calc_page';
  final String amount;
  const Calc({Key? key,required this.amount}) : super(key: key);

  @override
  CalcState createState() => CalcState();
}

class CalcState extends State<Calc> {
  String _history = '';
  String _expression = '0';
  int colorText = 0xFF484B57;
  int colorTextBlack= 0xFFFFFFFF;
  
  void numClick(String text) {
    if (_expression.length < 30) {
      if (_expression.length > 0) {
        //si es un symbolo de +/*-
        if (isSymbol(text)) {
          if (!isSymbol(_expression[_expression.length - 1])) {
            //valida para no repetir una coma
            if (text == '.') {
              bool find = false;
              bool findSymbol = false;

              for (var i = _expression.length - 1; i >= 0; i--) {
                if ((isSymbol(_expression[i]) && _expression[i] != '.')) {
                  findSymbol = true;
                } else if ((_expression[i] == '.') && !findSymbol) {
                  find = true;
                }
              }
              if (!find) {
                print(false);
                setState(() => _expression += text);
              }
            } else {
              setState(() => _expression += text);
            }
          }
          //cambia el anterior si es un simbolo
          else if (text != '.' && _expression[_expression.length - 1] != '.') {
            _expression = _expression.substring(0, _expression.length - 1);
            setState(() {
              setState(() => _expression += text);
            });
          }
        }
        //si es un numero
        else if (isNumber(text)) {
          //si es la ultimo numero borra el numero y pone 0
          if (_expression.length == 1 &&
              _expression[_expression.length - 1] == '0') {
            setState(() => _expression = text);
          } else {
            setState(() => _expression += text);
          }
        }
      } else {
        setState(() => _expression += text);
      }
    }
  }

  bool isSymbol(String c) {
    return c.contains(RegExp(r'[+-/*]'));
  }

  bool isNumber(String c) {
    return c.contains(RegExp(r'[0-9]'));
  }

  @override
  void initState() {
    //recibe el valor
    if (this.widget.amount != null && this.widget.amount != '')
      _expression = this.widget.amount;
    super.initState();
  }

  void allClear(String text) {
    setState(() {
      _history = '';
      _expression = '0';
    });
  }

  void clearLast(String text) {
    if (_expression.length > 0)
      setState(() {
        _expression = _expression.substring(0, _expression.length - 1);
        if (_expression.length == 0) _expression = '0';
      });
  }

  void save(String text) {
    double value;
    String? data;
    if (_expression.length > 0 && _expression != 'Error') {
      //evalua la expresion
      evaluate('');

      //si es un numero valido lo retorna
      value = double.tryParse(_expression)!;
      print(value);
      if (value != null) {
        //Se formatea para que sean solo dos lugares despues de la coma
        data = formatCoinForm(value);

        //para validar numeros de 10 cifras
        if (data.length > 10) {
          data = '9999999999';
        }
      }
    }
    Navigator.of(context).pop(data);
  }

  void evaluate(String text) {
    if (_expression.length > 0) {
      //si es un symbolo de +/*-
      if (isSymbol(_expression[_expression.length - 1]))
        _expression = _expression.substring(0, _expression.length - 1);

      Parser p = Parser();
      Expression exp = p.parse(_expression);
      ContextModel cm = ContextModel();

      if (_expression != 'Error')
        setState(() {
          _history = _expression;

          try {
            _expression = exp.evaluate(EvaluationType.REAL, cm).toStringAsFixed(2);
          } catch (e) {
            print(e.toString());
          }
          //errores de division por 0
          if (_expression == 'Infinity') {
            _expression = 'Error';
          }
          //por si es un numero muy grande
          else {
            if (_expression.contains('e')) _expression = '9999999999';
          }
        });
    }
  }

  @override
  Widget build(BuildContext context) {


    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          /*   Container(
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                _history,
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF545F61),
                ),
              ),
            ),
            alignment: Alignment(1.0, 1.0),
          ), */
          Container(
            height: 50,
            alignment: Alignment(1.0, 1.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: AutoSizeText(
                _expression,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 40,
                  color:  Colors.white,
                ),
              ),
            ),

            /*    alignment: Alignment(1.0, 1.0), */
          ),
          /*  SizedBox(height: 40), */
          Divider(
            color: Color(0xFFB5B6B8),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CalcButton(
                text: 'AC',
                fillColor: 0xFF535370,
                callback: allClear,
              ),
              CalcButton(
                icon: Icon(Icons.backspace_outlined),
                fillColor: 0xFF535370,
                callback: clearLast,
              ),
              CalcButton(
                text: '/',
                fillColor:0xFFFFFFFF,
                textColor: colorText,
                callback: numClick,
              ),
              CalcButton(
                text: '*',
                fillColor: 0xFFFFFFFF,
                textColor: colorText,
                callback: numClick,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CalcButton(
                text: '7',
                textColor:colorTextBlack,
                callback: numClick,
              ),
              CalcButton(
                text: '8',
                textColor:colorTextBlack,
                callback: numClick,
              ),
              CalcButton(
                text: '9',
                textColor:colorTextBlack,
                callback: numClick,
              ),
              CalcButton(
                text: '-',
                fillColor:0xFFFFFFFF,
                textColor: colorText,
                textSize: 24,
                callback: numClick,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CalcButton(
                text: '4',
                textColor:colorTextBlack,
                callback: numClick,
              ),
              CalcButton(
                  text: '5',
                  callback: numClick,
                  textColor:colorTextBlack),
              CalcButton(
                text: '6',
                textColor:colorTextBlack,
                callback: numClick,
              ),
              CalcButton(
                text: '+',
                fillColor:0xFFFFFFFF,
                textColor: colorText,
                textSize: 24,
                callback: numClick,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CalcButton(
                text: '1',
                textColor:colorTextBlack,
                callback: numClick,
              ),
              CalcButton(
                text: '2',
                textColor:colorTextBlack,
                callback: numClick,
              ),
              CalcButton(
                text: '3',
                textColor:colorTextBlack,
                callback: numClick,
              ),
              CalcButton(
                text: '=',
                fillColor: 0xFF89AEFF,
                textColor: 0xFFFDFFFF,
                textSize: 24,
                callback: evaluate,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CalcButton(
                text: '.',
                textColor:colorTextBlack,
                callback: numClick,
              ),
              CalcButton(
                text: '0',
                textColor:colorTextBlack,
                callback: numClick,
              ),
              CalcButton(
                text: '00',
                textColor:colorTextBlack,
                callback: numClick,
              ),
              CalcButton(
                icon: Icon(
                  Icons.check,
                ),
                fillColor: 0xFF6277D7,
                textColor: 0xFFEFF7F5,
                callback: save,
              ),
            ],
          )
        ],
      ),
    );
  }
}
