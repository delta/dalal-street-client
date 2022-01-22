import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DalalHomeNavBar extends StatefulWidget {
  final Map<String, String> menu;

  const DalalHomeNavBar({Key? key, required this.menu}) : super(key: key);

  @override
  _DalalHomeNavBarState createState() => _DalalHomeNavBarState();
}

class _DalalHomeNavBarState extends State<DalalHomeNavBar> {
  List<BottomNavigationBarItem> get _menuItems => widget.menu
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
  build(context) => BottomNavigationBar(
        currentIndex: 0,
        fixedColor: primaryColor,
        backgroundColor: background2,
        type: BottomNavigationBarType.fixed,
        items: _menuItems,
      );
}
