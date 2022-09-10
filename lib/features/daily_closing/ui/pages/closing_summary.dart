import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:cierre_diario2/utils/extensions.dart';

import '../../../../database/models/daily_closing.model.dart';
import '../../services/daily_closing_service.dart';

GlobalKey previewContainer = new GlobalKey();

class ClosingSummary extends StatefulWidget {
  const ClosingSummary({Key? key}) : super(key: key);

  @override
  State<ClosingSummary> createState() => _ClosingSummaryState();
}

class _ClosingSummaryState extends State<ClosingSummary> {
  @override
  Widget build(BuildContext context) {
    final DailyClosingService dailyClosingService = Provider.of<DailyClosingService>(context);
    Map<String, List<DailyClosingModel>> mapDailyClosing = groupBy(dailyClosingService.dailyClosingList, (obj) => obj.supplier!);

    List<String> keys = mapDailyClosing.keys.toList();
    return RepaintBoundary(
      key: previewContainer,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await _captureSocialPng(dailyClosingService, keys, mapDailyClosing);
          },
          child: Icon(Icons.share),
          backgroundColor: Color(0xFF495754),
        ),
        appBar: AppBar(
          title: const Text('Resumen'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(children: [
            Row(
              children: [
                headerTotal('Venta Total', dailyClosingService.getTotalSales()),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: keys.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: ExpansionTile(
                      collapsedIconColor: Colors.white,
                      iconColor: Colors.white,
                      backgroundColor: Color(0xFF313030),
                      collapsedBackgroundColor: Color(0xFF313030),
                      collapsedTextColor: Colors.black,
                      initiallyExpanded: true,
                      textColor: Colors.white,
                      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Container(
                          width: 70,
                          child: Text(
                            keys[index] == '' ? 'Harold' : keys[index].capitalizeString(),
                            style: TextStyle(color: Color.fromARGB(255, 223, 163, 95), fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Flexible(
                            child: headerColum((keys[index] == '') ? 'Venta' : 'Venta + G',
                                dailyClosingService.getSales(mapDailyClosing[keys[index]]!, isMine: keys[index] == ''))),
                        if (keys[index] == '')
                          Flexible(
                              child: headerColum('Inversión', dailyClosingService.getInversion(mapDailyClosing[keys[index]]!))),
                        if (keys[index] == '') Flexible(child: headerColum('Ganancia', dailyClosingService.getProfits()))
                      ]),
                      children: mapDailyClosing[keys[index]]!
                          .map((e) => e.amount != 0
                              ? Container(
                                  decoration: BoxDecoration(
                                      border: Border(top: BorderSide(color: Color.fromARGB(255, 182, 177, 177), width: 0.5))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          e.name!.capitalizeString(),
                                          style: TextStyle(color: Color.fromARGB(255, 216, 219, 217)),
                                        ),
                                        Text(e.amount.toString())
                                      ],
                                    ),
                                  ))
                              : SizedBox())
                          .toList(),
                    ),
                  );
                },
              ),
            )
          ]),
        ),
      ),
    );
  }

  Expanded headerTotal(String title, double amount) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Color(0xFFC0BEBE)),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            amount.formatCoin().toString(),
            style: TextStyle(
              fontSize: 20,
            ),
          )
        ],
      ),
    );
  }

  headerColum(String s, double i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            s.toString(),
            style: TextStyle(fontSize: 12, color: Color(0xFFC0BEBE)),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            i.formatCoin().toString(),
            style: TextStyle(fontSize: 15, color: Color(0xFFFFFFFF)),
          )
        ],
      ),
    );
  }

  Future<void> _captureSocialPng(
      DailyClosingService dailyClosingService, List<String> keys, Map<String, List<DailyClosingModel>> mapDailyClosing) {
    String listP = '';
    DateTime now = DateTime.now();
    listP += '-----CIERRE DIARIO-----\n';
    listP += '--${(DateFormat('EEEE', "es").format(now)).capitalizeString()} ${now.day}/${now.month}/${now.year}--\n\n';

    listP += '****Venta total****\n${dailyClosingService.salesTotal.formatCoin()} \n\n';

    for (var item in keys) {
      String venta = (dailyClosingService.getSales(mapDailyClosing[item]!, isMine: item == '').formatCoin());
      listP += (item == '' ? 'Harold' : item.capitalizeString());
      listP += '\n******************\n';
      listP +=  'V = $venta\n';
      if (item == '') {
        listP += 'I = ${dailyClosingService.getInversion(mapDailyClosing[item]!).formatCoin()}\n';
        listP += 'G = ${dailyClosingService.getProfits().formatCoin()}\n';
      }
      if (mapDailyClosing[item]!.length > 0 && mapDailyClosing[item]![0].amount! > 0) {
        print(mapDailyClosing[item]!.length);
        listP += '\n';
      }

      for (var element in mapDailyClosing[item]!) {
        if (element.amount != 0) {
          listP += element.name! + ' - ' + element.amount.toString() + '\n';
        }
      }
      listP += '******************\n';

      listP += '\n\n';
    }
    print(listP);
    return Future.delayed(const Duration(milliseconds: 20), () async {
      await Share.share(listP);
    }).catchError((onError) {
      print(onError);
    });
  }
}
