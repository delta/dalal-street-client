import 'package:dalal_street_client/constants/icons.dart';
import 'package:dalal_street_client/models/menu_item.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DalalHomeNavBar extends StatelessWidget {
  final List<MenuItem> menu;
  final int currentIndex;
  final void Function(int index) onItemSelect;
  final void Function(int index) onItemReselect;
  final void Function() onMoreClick;

  DalalHomeNavBar({
    Key? key,
    required this.menu,
    required this.currentIndex,
    required this.onItemSelect,
    required this.onItemReselect,
    required this.onMoreClick,
  }) : super(key: key);

  final _moreItem = MenuItem('More', AppIcons.hamburger);

  List<BottomNavigationBarItem> get _menuItems => (menu + [_moreItem])
      .map(
        (menuItem) => BottomNavigationBarItem(
          icon: SvgPicture.asset(menuItem.icon),
          activeIcon: SvgPicture.asset(
            menuItem.icon,
            color: primaryColor,
          ),
          label: menuItem.name,
        ),
      )
      .toList();

  @override
  build(context) => BottomNavigationBar(
        currentIndex: currentIndex,
        fixedColor: primaryColor,
        backgroundColor: background2,
        type: BottomNavigationBarType.fixed,
        items: _menuItems,
        onTap: (value) {
          // Don't select the item when more is clicked
          if (value == _menuItems.length - 1) {
            onMoreClick();
            return;
          }
          if (value != currentIndex) {
            onItemSelect(value);
          } else {
            onItemReselect(value);
          }
        },
      );
}
