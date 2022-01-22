import 'package:dalal_street_client/components/stock_bar.dart';
import 'package:dalal_street_client/pages/dalal_home/dalal_home_nav_bar.dart';
import 'package:flutter/material.dart';

class DalalHome extends StatelessWidget {
  DalalHome({Key? key}) : super(key: key);

  final _bottomMenu = {
    'Home': 'assets/icon/home.svg',
    'Portfolio': 'assets/icon/portfolio.svg',
    'DSE': 'assets/icon/rupee.svg',
    'Leaderboard': 'assets/icon/trophy.svg',
    'More': 'assets/icon/hamburger.svg',
  };

  @override
  build(context) => SafeArea(
        child: Scaffold(
          appBar: const StockBar(),
          bottomNavigationBar: DalalHomeNavBar(menu: _bottomMenu),
        ),
      );
}
