import 'package:dalal_street_client/blocs/admin/tab2/tab2_cubit.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:fixnum/fixnum.dart';

Widget openMarketUI(BuildContext context, bool updateDayHighAndLow, bool error,
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
              'Open Market',
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
              'Do you want to update Day`s high and low ?',
              style: TextStyle(fontSize: 16),
            ),
            ListTile(
              title: const Text('Yes'),
              leading: Radio(
                value: true,
                groupValue: updateDayHighAndLow,
                onChanged: (bool? value) {
                  stateUpdateFunc(value, 'openMarket');
                },
                activeColor: Colors.green,
              ),
            ),
            ListTile(
              title: const Text('No'),
              leading: Radio(
                value: false,
                groupValue: updateDayHighAndLow,
                onChanged: (bool? value) {
                  stateUpdateFunc(value, 'openMarket');
                },
                activeColor: Colors.green,
              ),
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
                    : context.read<Tab2Cubit>().openMarket(updateDayHighAndLow);
              },
              child: const Text('Open Market'),
            )
          ]));
}

Widget closeMarketUI(BuildContext context, bool updatePrevDayClose, bool error,
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
              'Close Market',
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
              'Do you want to update Previous Day Close ?',
              style: TextStyle(fontSize: 16),
            ),
            ListTile(
              title: const Text('Yes'),
              leading: Radio(
                value: true,
                groupValue: updatePrevDayClose,
                onChanged: (bool? value) {
                  stateUpdateFunc(value, 'closeMarket');
                },
                activeColor: Colors.green,
              ),
            ),
            ListTile(
              title: const Text('No'),
              leading: Radio(
                value: false,
                groupValue: updatePrevDayClose,
                onChanged: (bool? value) {
                  stateUpdateFunc(value, 'closeMarket');
                },
                activeColor: Colors.green,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                error == true
                    ? null
                    : context.read<Tab2Cubit>().closeMarket(updatePrevDayClose);
              },
              child: const Text('Close Market'),
            )
          ]));
}

Widget blockUserUI(
    BuildContext context, int userId, Int64 penalty, bool error) {
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
              'Block User',
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
                  labelText: 'User Id',
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
                  error = true;
                  userId = 0;
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
                  labelText: 'Penalty',
                  labelStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.all(8),
                  errorStyle: TextStyle(
                    fontSize: 11.0,
                    color: bronze,
                  )),
              onChanged: (String? value) {
                if (value != null) {
                  error = false;
                  penalty = Int64(int.parse(value));
                } else {
                  error = true;
                  penalty = Int64(0);
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
                    : context.read<Tab2Cubit>().blockUser(userId, penalty);
              },
              child: const Text('Block User'),
            )
          ]));
}

Widget inspectUserUI(BuildContext context, int userId, int day,
    bool transactionType, bool error) {
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
              'Inspect User',
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
                  labelText: 'User Id ',
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
                  labelText: 'Day',
                  labelStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.all(8),
                  errorStyle: TextStyle(
                    fontSize: 11.0,
                    color: bronze,
                  )),
              onChanged: (String? value) {
                if (value != null) {
                  error = false;
                  day = int.parse(value);
                } else {
                  error = false;
                  day = 0;
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Transaction Type? ',
                  labelStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.all(8),
                  errorStyle: TextStyle(
                    fontSize: 11.0,
                    color: bronze,
                  )),
              onChanged: (String? value) {
                if (value == 'true') {
                  error = false;
                  transactionType = true;
                } else if (value == 'false') {
                  error = false;
                  transactionType = false;
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
                    : context
                        .read<Tab2Cubit>()
                        .inspectUser(userId, transactionType, day);
              },
              child: const Text('Inspect User'),
            )
          ]));
}

Widget unblockAllUsersUI(BuildContext context, bool error) {
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
              'Unblock All Users',
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
                    : context.read<Tab2Cubit>().unblockAllUsers();
              },
              child: const Text('Unblock All Users'),
            )
          ]));
}

Widget unblockUserUI(BuildContext context, int userId, bool error) {
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
              'Unblock User',
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
                  labelText: 'User ID ',
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
            ElevatedButton(
              onPressed: () {
                error == true
                    ? null
                    : context.read<Tab2Cubit>().unblockUser(userId);
              },
              child: const Text('Unblock User'),
            )
          ]));
}
