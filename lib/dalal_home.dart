import 'package:dalal_street_client/components/stock_bar.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DalalHome extends StatelessWidget {
  DalalHome({Key? key}) : super(key: key);

  final _bottomMenu = {
    'Home': 'assets/icon/home.svg',
    'Portfolio': 'assets/icon/portfolio.svg',
    'DSE': 'assets/icon/rupee.svg',
    'Leaderboard': 'assets/icon/trophy.svg',
    'More': 'assets/icon/hamburger.svg',
  };

  List<BottomNavigationBarItem> get _menuItems => _bottomMenu
      .map((key, value) => MapEntry(
          key,
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              value,
              color: (key == 'Home') ? primaryColor : null,
            ),
            label: key,
          )))
      .values
      .toList();

  @override
  build(context) => SafeArea(
        child: Scaffold(
          appBar: const StockBar(),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: 0,
            fixedColor: primaryColor,
            backgroundColor: background2,
            type: BottomNavigationBarType.fixed,
            items: _menuItems,
          ),
        ),
      );
}
