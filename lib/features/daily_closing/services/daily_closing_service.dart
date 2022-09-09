import 'dart:async';

import 'package:cierre_diario2/database/database.dart';
import 'package:cierre_diario2/database/models/daily_closing.model.dart';
import 'package:flutter/material.dart';

class DailyClosingService extends ChangeNotifier {
  DatabaseHelper databaseHelper = DatabaseHelper();

  List<DailyClosingModel> dailyClosingList = [];
  List<DailyClosingModel> dailyClosingListToShow = [];

  bool isLoading = true;
  bool noData = false;
  double sales = 0;
  double profit = 0;

  DailyClosingService() {
    loadDailyClosingData(first: true);
  }

  Future<bool> loadDailyClosingData({first = false}) async {
    showloading();
    //load data
    List<DailyClosingModel> list = await databaseHelper.getDailyClosingList();

    dailyClosingList.clear();
    dailyClosingListToShow.clear();
    dailyClosingList.addAll(list);
    dailyClosingListToShow.addAll(list);

    hideLoading();

    return true;
  }

  Future<void> search(String text) async {
    dailyClosingListToShow.clear();
    dailyClosingListToShow.addAll(dailyClosingList.where((element) => element.name!.contains(text.toLowerCase())).toList());

    notifyListeners();
  }

  hideLoading() {
    isLoading = false;
    notifyListeners();
  }

  void showloading() {
    isLoading = true;
    notifyListeners();
  }

  Future<void> insert(DailyClosingModel dailyClosingModel) async {
    await databaseHelper.insert(dailyClosingModel);
    await loadDailyClosingData();
  }

  Future<void> edit(DailyClosingModel dailyClosingModel) async {
    await databaseHelper.update(dailyClosingModel);
    await loadDailyClosingData();
  }

  Future<void> deleteAll() async {
    await databaseHelper.deleteall(DailyClosingModel());
    await loadDailyClosingData();
  }

  double getTotalSales() {
    double sales = 0;
    int i = 0;
    for (var element in dailyClosingList) {
      sales += (element.price! * element.amount!);
    }
    return sales;
  }

  double getSales(List<DailyClosingModel> list,{bool isMine=false}) {
    double sales = 0;
    int i = 0;
    for (var element in list) {
      sales += ((isMine?element.price!:element.cost!) * element.amount!);
    }
    return sales;
  }
  double getProfits() {
    double profits = 0;
    int i = 0;
      for (var item in dailyClosingList) {
      profits += ((item.price!-item.cost!) * item.amount!);
        
    }
    return profits;
  }

    double getInversion(List<DailyClosingModel> list) {
    double inver = 0;
    int i = 0;
    for (var element in list) {
      inver += (element.cost! * element.amount!);
    }
    return inver;
  }
 

  void changeValue(DailyClosingModel dailyClosingModel) {
    dailyClosingList = dailyClosingList.map((e) => e.id == dailyClosingModel.id ? dailyClosingModel : e).toList();

    notifyListeners();
  }

  Future<void> delete(DailyClosingModel dailyClosingModel) async {
    await databaseHelper.delete(dailyClosingModel);
    int index = dailyClosingList.indexWhere((element) => element.id == dailyClosingModel.id);

    print(index);
    await loadDailyClosingData();
  }
}
