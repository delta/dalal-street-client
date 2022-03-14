import 'package:dalal_street_client/blocs/admin/tab3/tab3_cubit.dart';
import 'package:dalal_street_client/proto_build/actions/AddDailyChallenge.pbenum.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:fixnum/fixnum.dart';

Widget updateEndOfDayValuesUI(BuildContext context, bool error) {
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
              'Update End Of Day Values',
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
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                error == true
                    ? null
                    : context.read<Tab3Cubit>().updateEndOfDaysValues();
              },
              child: const Text('Update End Of Day Values'),
            )
          ]));
}

Widget updateStockPriceUI(
    BuildContext context, int stockId, Int64 newPrice, bool error) {
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
              'Update Stock Price',
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
                  labelText: 'New stock Price',
                  labelStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.all(8),
                  errorStyle: TextStyle(
                    fontSize: 11.0,
                    color: bronze,
                  )),
              onChanged: (String? value) {
                if (value != null) {
                  error = false;
                  newPrice = Int64(int.parse(value));
                } else {
                  error = true;
                  newPrice = Int64(0);
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
                        .read<Tab3Cubit>()
                        .updateStockPrice(stockId, newPrice);
              },
              child: const Text('Update Stock Price'),
            )
          ]));
}

Widget addStocksToExchangeUI(
    BuildContext context, int stockId, Int64 newStocks, bool error) {
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
              'Add Stocks To Exchange',
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
                  labelText: 'Number of Stocks',
                  labelStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.all(8),
                  errorStyle: TextStyle(
                    fontSize: 11.0,
                    color: bronze,
                  )),
              onChanged: (String? value) {
                if (value != null) {
                  error = false;
                  newStocks = Int64(int.parse(value));
                } else {
                  error = true;
                  newStocks = Int64(0);
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
                        .read<Tab3Cubit>()
                        .addStocksToExchange(stockId, newStocks);
              },
              child: const Text('Add Stocks To Exchange'),
            )
          ]));
}

Widget addMarketEventUI(
    BuildContext context,
    String headline,
    String text,
    String imageUri,
    int stockId,
    bool isGlobal,
    bool error,
    Function stateUpdateFunc) {
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
              'Add Market Event',
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
                  labelText: 'Stock Id ',
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
                  error = false;
                  stockId = 0;
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Headline',
                    labelStyle: TextStyle(fontSize: 14),
                    contentPadding: EdgeInsets.all(8),
                    errorStyle: TextStyle(
                      fontSize: 11.0,
                      color: bronze,
                    )),
                onChanged: (String? value) {
                  if (value != null) {
                    error = false;
                    headline = value.toString();
                  } else {
                    error = true;
                    headline = ' ';
                  }
                }),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Text',
                    labelStyle: TextStyle(fontSize: 14),
                    contentPadding: EdgeInsets.all(8),
                    errorStyle: TextStyle(
                      fontSize: 11.0,
                      color: bronze,
                    )),
                onChanged: (String? value) {
                  if (value != null) {
                    error = false;
                    text = value.toString();
                  } else {
                    error = true;
                    text = ' ';
                  }
                }),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Image URI',
                    labelStyle: TextStyle(fontSize: 14),
                    contentPadding: EdgeInsets.all(8),
                    errorStyle: TextStyle(
                      fontSize: 11.0,
                      color: bronze,
                    )),
                onChanged: (String? value) {
                  if (value != null) {
                    error = false;
                    imageUri = value.toString();
                  } else {
                    error = true;
                    imageUri = ' ';
                  }
                }),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Is Global news?',
              style: TextStyle(fontSize: 16),
            ),
            ListTile(
              title: const Text('Yes'),
              leading: Radio(
                value: true,
                groupValue: isGlobal,
                onChanged: (bool? value) {
                  stateUpdateFunc(value, 'news');
                },
                activeColor: Colors.green,
              ),
            ),
            ListTile(
              title: const Text('No'),
              leading: Radio(
                value: false,
                groupValue: isGlobal,
                onChanged: (bool? value) {
                  stateUpdateFunc(value, 'news');
                },
                activeColor: Colors.green,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                context.read<Tab3Cubit>().addMarketEvent(
                    stockId, headline, text, imageUri, isGlobal);
              },
              child: const Text('Add Market Event'),
            )
          ]));
}

String dailyChallengeToString(ChallengeType challenge) {
  switch (challenge) {
    case ChallengeType.Cash:
      return 'Cash';
    case ChallengeType.NetWorth:
      return 'NetWorth';
    case ChallengeType.SpecificStock:
      return 'Specific Stock';
    case ChallengeType.StockWorth:
      return 'Stock Worth';
  }
  return '';
}

Widget addDailyChallengeUI(
    BuildContext context,
    int marketDay,
    int? stockId,
    int reward,
    Int64 values,
    ChallengeType challengeType,
    bool error,
    Function stateUpdateFunc) {
  error = false;
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
              'Add Daily Challenge',
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
            const Text(
              'Enter Challenge Type',
              style: TextStyle(fontSize: 16),
            ),
            DropdownButton(
                value: challengeType,
                items: [
                  ChallengeType.Cash,
                  ChallengeType.NetWorth,
                  ChallengeType.StockWorth,
                  ChallengeType.SpecificStock
                ]
                    .map((e) => DropdownMenuItem(
                        child: Text(dailyChallengeToString(e)), value: e))
                    .toList(),
                onChanged: (ChallengeType? challengeType) {
                  stateUpdateFunc(challengeType, 'dailyChallenge');
                }),
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
                  labelText: 'Reward',
                  labelStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.all(8),
                  errorStyle: TextStyle(
                    fontSize: 11.0,
                    color: bronze,
                  )),
              onChanged: (String? value) {
                if (value != null) {
                  error = false;
                  reward = int.parse(value);
                } else {
                  error = true;
                  reward = 0;
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
                  labelText: 'Value',
                  labelStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.all(8),
                  errorStyle: TextStyle(
                    fontSize: 11.0,
                    color: bronze,
                  )),
              onChanged: (String? value) {
                if (value != null) {
                  error = false;
                  values = Int64(int.parse(value));
                } else {
                  values = Int64(0);
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
                    : context.read<Tab3Cubit>().addDailyChallenge(
                        marketDay, stockId, reward, values, challengeType);
              },
              child: const Text('Add Daily Challenge'),
            )
          ]));
}

Widget openDailyChallengeUI(BuildContext context, bool error) {
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
              'Open Daily Challenge',
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
                error == true
                    ? null
                    : context.read<Tab3Cubit>().openDailyChallenge();
              },
              child: const Text('Open Daily Challenge'),
            )
          ]));
}

Widget closeDailyChallengeUI(BuildContext context, bool error) {
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
              'Close Daily Challenge',
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
                error == true
                    ? null
                    : context.read<Tab3Cubit>().closeDailyChallenges();
              },
              child: const Text('Close Daily Challenge'),
            )
          ]));
}
