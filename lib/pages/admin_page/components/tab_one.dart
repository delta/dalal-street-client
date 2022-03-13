import 'package:dalal_street_client/blocs/admin/tab1/tab1_cubit.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:fixnum/fixnum.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';

Widget sendNewsUI(BuildContext context, String news, bool error) {
  return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Send News',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: white,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'News: ',
                  labelStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.all(8),
                  errorStyle: TextStyle(
                    fontSize: 11.0,
                    color: bronze,
                  )),
              onChanged: (String? value) {
                if (value != null) {
                  error = false;
                  news = value.toString();
                } else {
                  error = true;
                  news = ' ';
                }
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  error = true;
                  return 'Can\'t be empty';
                }
                {
                  error = false;
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                error == true ? null : context.read<Tab1Cubit>().sendNews(news);
              },
              child: const Text('Send News'),
            )
          ]));
}

Widget sendNotifsUI(BuildContext context, String notifs, int userId,
    bool isGlobal, bool error, Function stateUpdateFunc) {
  return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Send Notifications',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: white,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Is it a Global notification?',
              style: TextStyle(fontSize: 16),
            ),
            ListTile(
              title: const Text('True'),
              leading: Radio(
                value: true,
                groupValue: isGlobal,
                onChanged: (bool? value) {
                  stateUpdateFunc(value, 'notif');
                },
                activeColor: Colors.green,
              ),
            ),
            ListTile(
              title: const Text('False'),
              leading: Radio(
                value: false,
                groupValue: isGlobal,
                onChanged: (bool? value) {
                  stateUpdateFunc(value, 'notif');
                },
                activeColor: Colors.green,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'UserId (Not necessary for global notification)',
                  labelStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.all(8),
                  errorStyle: TextStyle(
                    fontSize: 11.0,
                    color: bronze,
                  )),
              onChanged: (String? value) {
                if (value != null) {
                  error = false;
                  userId = int.parse(value);
                } else {
                  error = false;
                  userId = 0;
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Notification ',
                  labelStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.all(8),
                  errorStyle: TextStyle(
                    fontSize: 11.0,
                    color: bronze,
                  )),
              onChanged: (String? value) {
                if (value != null) {
                  error = false;
                  notifs = value.toString();
                } else {
                  error = true;
                  notifs = ' ';
                }
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  error = true;
                  return 'Can\'t be empty';
                }
                {
                  error = false;
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                error == true
                    ? null
                    : context
                        .read<Tab1Cubit>()
                        .sendNotifications(userId, notifs, isGlobal);
              },
              child: const Text('Send Notifications'),
            )
          ]));
}

Widget setMarketDayUI(BuildContext context, int marketDay, bool error) {
  return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set Market Day',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: white,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Market day',
                  labelStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.all(8),
                  errorStyle: TextStyle(
                    fontSize: 11.0,
                    color: bronze,
                  )),
              onChanged: (String? value) {
                if (value != null) {
                  error = false;
                  marketDay = int.parse(value);
                } else {
                  error = true;
                  marketDay = 0;
                }
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  error = true;
                  return 'Can\'t be empty';
                }
                {
                  error = false;
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                error == true
                    ? null
                    : context.read<Tab1Cubit>().setMarketDay(marketDay);
              },
              child: const Text('Set Market Day'),
            )
          ]));
}

Widget sendDividendsUI(
    BuildContext context, int stockId, Int64 dividendAmount, bool error) {
  return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Send Dividends',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: white,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Stock Id',
                  labelStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.all(8),
                  errorStyle: TextStyle(
                    fontSize: 11.0,
                    color: bronze,
                  )),
              onChanged: (String? value) {
                if (value != null) {
                  error = false;
                  stockId = int.parse(value);
                } else {
                  error = true;
                  stockId = 0;
                }
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  error = true;
                  return 'Can\'t be empty';
                }
                {
                  error = false;
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Dividend Amount',
                  labelStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.all(8),
                  errorStyle: TextStyle(
                    fontSize: 11.0,
                    color: bronze,
                  )),
              onChanged: (String? value) {
                if (value != null) {
                  error = false;
                  dividendAmount = Int64(int.parse(value));
                } else {
                  error = true;
                  dividendAmount = Int64(0);
                }
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  error = true;
                  return 'Can\'t be empty';
                }
                {
                  error = false;
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                error == true
                    ? null
                    : context
                        .read<Tab1Cubit>()
                        .sendDividends(stockId, dividendAmount);
              },
              child: const Text('Send Dividends'),
            )
          ]));
}

Widget setGivesDividendsUI(
    BuildContext context,
    int? stockId,
    bool givesDividends,
    bool error,
    Map<int, Stock> mapOfStocks,
    Function stateUpdateFunc) {
  Map<int, String> stockNameMap = {};
  mapOfStocks.forEach((stockid, value) {
    stockNameMap[stockid] = value.fullName;
  });
  List<DropdownMenuItem<dynamic>> options = stockNameMap.entries
      .map((entry) =>
          DropdownMenuItem<dynamic>(child: Text(entry.value), value: entry.key))
      .toList();
  return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set Gives Dividends',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: white,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Choose Stock:',
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.start,
            ),
            DropdownButton(
                isExpanded: true,
                value: stockId,
                items: options,
                onChanged: (dynamic a) => {stateUpdateFunc(a, 'setDiv')}),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                error == true
                    ? null
                    : context
                        .read<Tab1Cubit>()
                        .setGivesDividends(stockId, givesDividends);
              },
              child: const Text('Set Gives Dividends'),
            )
          ]));
}

Widget setBankruptcyUI(BuildContext context, int? stockId, bool isBankrupt,
    bool error, Map<int, Stock> mapOfStocks, Function stateUpdateFunc) {
  Map<int, String> stockNameMap = {};
  mapOfStocks.forEach((stockid, value) {
    stockNameMap[stockid] = value.fullName;
  });
  List<DropdownMenuItem<dynamic>> options = stockNameMap.entries
      .map((entry) =>
          DropdownMenuItem<dynamic>(child: Text(entry.value), value: entry.key))
      .toList();
  return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set Bankruptcy',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: white,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Choose Stock:',
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.start,
            ),
            DropdownButton(
                isExpanded: true,
                value: stockId,
                items: options,
                onChanged: (dynamic a) => {stateUpdateFunc(a, 'bankrupt')}),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                error == true
                    ? null
                    : context
                        .read<Tab1Cubit>()
                        .setBankruptcy(stockId, isBankrupt);
              },
              child: const Text('Set Bankruptcy'),
            )
          ]));
}

Widget loadStocksUI(BuildContext context, bool error) {
  return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Load Stocks',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: white,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                error == true ? null : context.read<Tab1Cubit>().loadStocks();
              },
              child: const Text('Load Stocks'),
            )
          ]));
}
