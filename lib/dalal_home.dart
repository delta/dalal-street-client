import 'package:dalal_street_client/components/stock_bar.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

class DalalHome extends StatelessWidget {
  DalalHome({Key? key}) : super(key: key);

  final _bottomMenu = {
    'Home': Icons.home,
    'Portfolio': Icons.cases_rounded,
    'DSE': Icons.monetization_on,
    'Leaderboard': Icons.account_balance,
    'User': Icons.person,
  };

  @override
  build(context) => SafeArea(
        child: Scaffold(
          appBar: const StockBar(),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: 1,
            fixedColor: primaryColor,
            backgroundColor: background2,
            type: BottomNavigationBarType.fixed,
            items: [
              for (var key in _bottomMenu.keys)
                BottomNavigationBarItem(
                  icon: Icon(_bottomMenu[key]),
                  label: key,
                )
            ],
          ),
        ),
      );
}
