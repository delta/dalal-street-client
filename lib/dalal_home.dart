import 'package:dalal_street_client/components/stock_bar.dart';
import 'package:flutter/material.dart';

class DalalHome extends StatelessWidget {
  DalalHome({Key? key}) : super(key: key);

  final _bottomMenu = {
    'Home': Icons.home,
    'Portfolio': Icons.cases,
    'DSE': Icons.monetization_on,
    'Leaderboard': Icons.account_balance,
    'User': Icons.person,
  };

  @override
  build(context) => SafeArea(
        child: Scaffold(
          appBar: const StockBar(),
          bottomNavigationBar: BottomNavigationBar(
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
