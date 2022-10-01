import 'package:cierre_diario2/database/models/daily_closing.model.dart';
import 'package:cierre_diario2/features/daily_closing/services/daily_closing_service.dart';
import 'package:cierre_diario2/features/daily_closing/ui/pages/closing_summary.dart';
import 'package:cierre_diario2/features/daily_closing/ui/pages/create_edit_daily_closing.page.dart';
import 'package:cierre_diario2/features/daily_closing/ui/widgets/daily_closing_card.dart';
import 'package:cierre_diario2/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:animate_do/animate_do.dart';

class DailyClosingPage extends StatefulWidget {
  const DailyClosingPage({Key? key}) : super(key: key);

  @override
  _DailyClosingPageState createState() => _DailyClosingPageState();
}

class _DailyClosingPageState extends State<DailyClosingPage> {
  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom == 0.0;
    final dailyClosingService = Provider.of<DailyClosingService>(context);

    return Scaffold(
        floatingActionButton: Visibility(visible:keyboardIsOpened ,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ClosingSummary()),
              );
            },
            child: Icon(Icons.check),
            backgroundColor: Color(0xFF495754),
          ),
        ),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Cierre diario'),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text("Reiniciar"),
                            content: const Text("¿Desea reiniciar todas las mercancías?"),
                            actions: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: const Color(0xFF353535),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                                child: Text('No'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: const Color(0xFF495754),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                                child: Text('Si'),
                                onPressed: () {
                                  dailyClosingService.loadDailyClosingData();

                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ));
                },
                icon: Icon(Icons.replay_outlined)),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text("Eliminar"),
                            content: const Text("¿Desea eliminar todas las mercancías?"),
                            actions: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: const Color(0xFF353535),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                                child: Text('No'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: const Color(0xFF495754),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                                child: Text('Si'),
                                onPressed: () {
                                  dailyClosingService.deleteAll();

                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ));
                },
                icon: Icon(Icons.delete_forever_rounded)),
            IconButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateOrEditDailyClosing()));
                },
                icon: Icon(Icons.add)),
          ],
        ),
        body: GetBody(dailyClosingService));
  }
}

class GetBody extends StatefulWidget {
  final DailyClosingService dailyClosingService;

  GetBody(this.dailyClosingService, {Key? key}) : super(key: key);

  @override
  State<GetBody> createState() => _GetBodyState();
}

class _GetBodyState extends State<GetBody> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.dailyClosingService.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(children: [
      Container(
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (v) {
                      setState(() {});
                    },
                    onFieldSubmitted: (contains) {
                      widget.dailyClosingService.search(searchController.text);
                    },
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        labelText: "Mercancía",
                        labelStyle: TextStyle(color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: const Color(0xFFB1BDBA),
                          ),
                          onPressed: () {
                            widget.dailyClosingService.search(searchController.text);
                            FocusScope.of(context).requestFocus(new FocusNode());
                          },
                        )),
                  ),
                ),
                if (searchController.text != null && searchController.text.length > 0)
                  ElasticIn(
                    child: IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: const Color(0xFFB1BDBA),
                        ),
                        onPressed: () {
                          searchController.clear();
                          widget.dailyClosingService.search('');
                          FocusScope.of(context).requestFocus(new FocusNode());
                        }),
                  ),
              ],
            )),
      ),
      Expanded(
        child: GroupedListView<DailyClosingModel, String>(
          elements: widget.dailyClosingService.dailyClosingListToShow,
          physics: const BouncingScrollPhysics(),
          itemComparator: (e1, e2) => e1.name!.toLowerCase().compareTo(e2.name!.toLowerCase()),
          groupBy: (element) => element.supplier!,
          padding: const EdgeInsets.only(bottom: 80, left: 10, right: 10, top: 10),
          groupSeparatorBuilder: (String groupByValue) => SizedBox(
            height: 40,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 98, 154, 240).withOpacity(0.4),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    groupByValue == '' ? 'Harold' : groupByValue,
                    style: TextStyle(fontSize: 13, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          itemBuilder: (context, DailyClosingModel element) {
            return MerchandiseCard(
              key: Key(element.id!.toString()),
              dailyClosingModel: element,
              onTap: () {},
              backgroundColor: Color(0xFF313030),
            );
          },
          useStickyGroupSeparators: true, // optional
          floatingHeader: true, // optional
          order: GroupedListOrder.ASC, // optional
        ),
      ),
      /*      IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                decoration: BoxDecoration(
                    color: Color(0xFF353535),
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(15.0),
                    )),
                child: Column(
                  children: [
                    Text(
                      'Venta',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(widget.dailyClosingService.getSales().formatCoin(symbol: true),
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 18)),
                  ],
                ),
              ),
            ),
            VerticalDivider(
              color: Colors.white,
              width: 2,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                decoration: BoxDecoration(
                    color: Color(0xFF495754),
                    borderRadius: new BorderRadius.only(
                      topRight: const Radius.circular(15.0),
                    )),
                child: Column(
                  children: [
                    Text(
                      'Ganancia',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(widget.dailyClosingService.getProfit().formatCoin(symbol: true),
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 18)),
                  ],
                ),
              ),
            )
          ],
        ),
      )
  */
    ]);
  }
}
