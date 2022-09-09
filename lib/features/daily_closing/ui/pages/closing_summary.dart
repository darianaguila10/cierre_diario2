import 'package:cierre_diario2/utils/extensions.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../database/models/daily_closing.model.dart';
import '../../services/daily_closing_service.dart';

class ClosingSummary extends StatefulWidget {
  const ClosingSummary({Key? key}) : super(key: key);

  @override
  State<ClosingSummary> createState() => _ClosingSummaryState();
}

class _ClosingSummaryState extends State<ClosingSummary> {
  @override
  Widget build(BuildContext context) {
    final dailyClosingService = Provider.of<DailyClosingService>(context);
    Map<String, List<DailyClosingModel>> mapDailyClosing = groupBy(dailyClosingService.dailyClosingList, (obj) => obj.supplier!);

    List<String> keys = mapDailyClosing.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(children: [
          Row(
            children: [
              headerTotal('Venta', dailyClosingService.getTotalSales()),
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
                      Flexible(child: headerColum('Venta', dailyClosingService.getSales(mapDailyClosing[keys[index]]!))),
                      if (keys[index] == '')
                        Flexible(child: headerColum('Inversión', dailyClosingService.getInversion(mapDailyClosing[keys[index]]!))),
                      if (keys[index] == '')
                        Flexible(child: headerColum('Ganancia', dailyClosingService.getProfits()))
                    ]),
                    children: mapDailyClosing[keys[index]]!
                        .map((e) => Container(
                            decoration: BoxDecoration(
                                border: Border(top: BorderSide(color: Color.fromARGB(255, 182, 177, 177), width: 0.5))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    e.name!.capitalizeString(),
                                    style: TextStyle(color: Color.fromARGB(255, 216, 219, 217)),
                                  ),
                                  Text(e.amount.toString()
                                  )
                                ],
                              ),
                            )))
                        .toList(),
                  ),
                );
              },
            ),
          )
        ]),
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
}
