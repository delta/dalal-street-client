import 'package:dalal_street_client/blocs/admin/add_daily_challenge/add_daily_challenge_cubit.dart';
import 'package:dalal_street_client/blocs/admin/add_market_event/add_market_event_cubit.dart';
import 'package:dalal_street_client/blocs/admin/add_stocks_to_exchange/add_stocks_to_exchange_cubit.dart';
import 'package:dalal_street_client/blocs/admin/close_daily_challenge/close_daily_challenge_cubit.dart';
import 'package:dalal_street_client/blocs/admin/open_daily_challenge/open_daily_challenge_cubit.dart';
import 'package:dalal_street_client/blocs/admin/update_end_of_day_values/update_end_of_day_values_cubit.dart';
import 'package:dalal_street_client/blocs/admin/update_stock_price/update_stock_price_cubit.dart';
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
                    : context
                        .read<UpdateEndOfDayValuesCubit>()
                        .updateEndOfDaysValues();
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
                  labelText: 'New stocks',
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
                        .read<UpdateStockPriceCubit>()
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
                        .read<AddStocksToExchangeCubit>()
                        .addStocksToExchange(stockId, newStocks);
              },
              child: const Text('Add Stocks To Exchange'),
            )
          ]));
}

Widget addMarketEventUI(BuildContext context, String headline, String text,
    String imageUri, int stockId, bool isGlobal, bool error) {
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
            ),
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
            ),
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
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Is Global? ',
                  labelStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.all(8),
                  errorStyle: TextStyle(
                    fontSize: 11.0,
                    color: bronze,
                  )),
              onChanged: (String? value) {
                if (value == 'true') {
                  error = false;
                  isGlobal = true;
                } else if (value == 'false') {
                  error = false;
                  isGlobal = false;
                } else {
                  error = true;
                }
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  error = true;
                  return 'Can\'t be empty';
                } else if (text != 'true' && text != 'false') {
                  error = true;
                  return 'Can only be true or false';
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
                    : context.read<AddMarketEventCubit>().addMarketEvent(
                        stockId, headline, text, imageUri, isGlobal);
              },
              child: const Text('Add Market Event'),
            )
          ]));
}

Widget addDailyChallengeUI(BuildContext context, int marketDay, int stockId,
    int reward, Int64 values, ChallengeType challengeType, bool error) {
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
            TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Challenge Type',
                  labelStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.all(8),
                  errorStyle: TextStyle(
                    fontSize: 11.0,
                    color: bronze,
                  )),
              onChanged: (String? value) {
                if (value != null) {
                  error = false;
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
                  error = true;
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
                    : context.read<AddDailyChallengeCubit>().addDailyChallenge(
                        marketDay,
                        {
                          ChallengeType.Cash,
                          ChallengeType.NetWorth,
                          ChallengeType.StockWorth,
                          ChallengeType.SpecificStock
                        },
                        values,
                        stockId,
                        reward);
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
                    : context
                        .read<OpenDailyChallengeCubit>()
                        .openDailyChallenge();
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
                    : context
                        .read<CloseDailyChallengeCubit>()
                        .closeDailyChallenges();
              },
              child: const Text('Close Daily Challenge'),
            )
          ]));
}
