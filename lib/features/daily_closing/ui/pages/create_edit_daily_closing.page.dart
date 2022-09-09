import 'package:cierre_diario2/database/models/daily_closing.model.dart';
import 'package:cierre_diario2/features/daily_closing/services/daily_closing_service.dart';
import 'package:cierre_diario2/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CreateOrEditDailyClosing extends StatefulWidget {
  final DailyClosingModel? dailyClosingModel;
  const CreateOrEditDailyClosing({Key? key, this.dailyClosingModel}) : super(key: key);

  @override
  _CreateOrEditDailyClosingState createState() => _CreateOrEditDailyClosingState();
}

class _CreateOrEditDailyClosingState extends State<CreateOrEditDailyClosing> {
  bool _validateF = false;
  GlobalKey<FormState> _keyForm = new GlobalKey();
  DailyClosingModel dailyClosingModel = DailyClosingModel();
  String title = 'Adicionar';
  late bool supplier=false;
  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {

    if (widget.dailyClosingModel != null) {
      title = 'Actualizar';
      dailyClosingModel.id = widget.dailyClosingModel?.id;
      dailyClosingModel.name = widget.dailyClosingModel?.name;
      dailyClosingModel.name = widget.dailyClosingModel?.name;
      dailyClosingModel.cost = widget.dailyClosingModel?.cost;
      dailyClosingModel.price = widget.dailyClosingModel?.price;
      dailyClosingModel.amount = widget.dailyClosingModel?.amount;
      dailyClosingModel.supplier = widget.dailyClosingModel?.supplier;
      supplier= widget.dailyClosingModel!.supplier!=''?true:false;

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dailyClosingService = Provider.of<DailyClosingService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('$title mercancía'),
        actions: <Widget>[
          if (widget.dailyClosingModel != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text("Eliminar"),
                          content: Text("¿Desea eliminar esta mercancía?"),
                          actions: <Widget>[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF353535),
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                              ),
                              child: Text('No'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF495754),
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                              ),
                              child: Text('Si'),
                              onPressed: () {
                                dailyClosingService.delete(dailyClosingModel);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ));
              },
            ),
        ],
      ),
      body: buildForm(),
    );
  }

  buildForm() {
    return Container(
      padding: EdgeInsets.only(top: 22, left: 22, right: 22),
      child: SingleChildScrollView(
          child: Container(
        child: Form(
            key: _keyForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  initialValue: dailyClosingModel.name,
                  validator: validator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLength: 30,
                  onSaved: (value) {
                    dailyClosingModel.name = value;
                  },
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(0), labelText: "Nombre", icon: Icon(Icons.shopping_cart_rounded)),
                ),
                TextFormField(
                  initialValue: (widget.dailyClosingModel != null) ? dailyClosingModel.cost!.formatCoinForm() : null,
                  validator: validator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLength: 15,
                  keyboardType: TextInputType.numberWithOptions(),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^(\d?)+\.?\d{0,2}')),
                    /* LengthLimitingTextInputFormatter(25) */
                  ],
                  onSaved: (value) {
                    dailyClosingModel.cost = double.parse(value!);
                  },
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(0), labelText: "Costo de mercancía", icon: Icon(Icons.content_paste)),
                ),
                TextFormField(
                  initialValue: (widget.dailyClosingModel != null) ? dailyClosingModel.price!.formatCoinForm() : null,
                  validator: validator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLength: 15,
                  keyboardType: TextInputType.numberWithOptions(),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^(\d?)+\.?\d{0,2}')),
                    /* LengthLimitingTextInputFormatter(25) */
                  ],
                  onSaved: (value) {
                    dailyClosingModel.price = double.parse(value!);
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0), labelText: "Precio de mercancía", icon: Icon(Icons.content_paste)),
                ),
                SizedBox(height: 20,),
                SwitchListTile(controlAffinity: ListTileControlAffinity.trailing,contentPadding: EdgeInsets.zero,
                    value: supplier,title: Text('Es de un proveedor'),
                    onChanged: (v) {
                      setState(() {
                        supplier = v;
                      });
                    }),
                SizedBox(height: 20,),


                    supplier?
                TextFormField(
                  initialValue: dailyClosingModel.supplier,
                  validator: validator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLength: 30,
                  onSaved: (value) {
                    dailyClosingModel.supplier = value;
                  },
                  decoration:
                      const InputDecoration(contentPadding: EdgeInsets.all(0), labelText: "Proveedor", icon: Icon(Icons.person)),
                ):SizedBox(),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF353535),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text("Cancelar"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF495754),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text("Aceptar"),
                        onPressed: () {
                          createOrEditItem();
                        })
                  ],
                )
              ],
            )),
      )),
    );
  }

  void createOrEditItem() async {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      final dailyClosingService = Provider.of<DailyClosingService>(context, listen: false);
      if (widget.dailyClosingModel == null) {
        await dailyClosingService.insert(dailyClosingModel);
      } else {
        await dailyClosingService.edit(dailyClosingModel);
      }

      Navigator.pop(context, true);
    } else {
      setState(() {
        _validateF = true;
      });
    }
  }

  String? validator(String? value) {
    if (value == null || value == '') return "Este campo es obligatorio.";
  }
}
