import 'package:cierre_diario2/database/models/daily_closing.model.dart';
import 'package:cierre_diario2/features/daily_closing/services/daily_closing_service.dart';
import 'package:cierre_diario2/features/daily_closing/ui/pages/create_edit_daily_closing.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


class MerchandiseCard extends StatefulWidget {
  final onTap;
  final DailyClosingModel dailyClosingModel;
  final Color backgroundColor;

  const MerchandiseCard({
    Key? key,
    required this.dailyClosingModel,
    this.onTap,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  State<MerchandiseCard> createState() => _MerchandiseCardState();
}

class _MerchandiseCardState extends State<MerchandiseCard> with WidgetsBindingObserver {
  final borderRadius = BorderRadius.circular(15);
  final FocusNode inputFocusNode = FocusNode();
  late TextEditingController _numberController;

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    inputFocusNode.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final value = WidgetsBinding.instance!.window.viewInsets.bottom;
    if (value == 0) {
      if (_numberController.text == '') {
        _numberController.text = '0';
      }
      inputFocusNode.unfocus();
    }
  }

  @override
  void initState() {
    _numberController = TextEditingController(text: widget.dailyClosingModel.amount!.toString());
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dailyClosingService = Provider.of<DailyClosingService>(context, listen: false);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
      ),
      child: Material(
        color: widget.backgroundColor,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: widget.onTap,
          onLongPress: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CreateOrEditDailyClosing(
                      dailyClosingModel: widget.dailyClosingModel,
                    )));
          },
          borderRadius: borderRadius,
          child: Ink(
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          widget.dailyClosingModel.name!,
                          maxLines: 3,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              if (widget.dailyClosingModel.amount! > 0) {
                                widget.dailyClosingModel.amount = widget.dailyClosingModel.amount! - 1;
                                _numberController.text = widget.dailyClosingModel.amount.toString();
                                dailyClosingService.changeValue(widget.dailyClosingModel);
                              }
                            },
                            icon: const Icon(
                              Icons.remove,
                              color: const Color(0xFFB1BDBA),
                            )),
                        SizedBox(
                          child: TextFormField(
                            focusNode: inputFocusNode,
                            controller: _numberController,
                            onChanged: (v) {
                              if (widget.dailyClosingModel.amount != '') {
                                widget.dailyClosingModel.amount = int.parse(v);
                                dailyClosingService.changeValue(widget.dailyClosingModel);
                              } else {
                                widget.dailyClosingModel.amount = 0;
                                dailyClosingService.changeValue(widget.dailyClosingModel);
                              }
                            },
                            decoration: const InputDecoration(border: InputBorder.none),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                            ],
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Color(0xFFB1BDBA),
                          ),
                          width: 40,
                        ),
                        IconButton(
                          onPressed: () {
                            widget.dailyClosingModel.amount = widget.dailyClosingModel.amount! + 1;
                            _numberController.text = widget.dailyClosingModel.amount.toString();
                            dailyClosingService.changeValue(widget.dailyClosingModel);
                          },
                          icon: Icon(Icons.add),
                          color: const Color(0xFFB1BDBA),
                        ),
                      ],
                    ),
                  ],
                )),
            decoration: BoxDecoration(
              borderRadius: borderRadius,
            ),
          ),
        ),
      ),
    );
  }
}
