import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DalalHomeNavBar extends StatefulWidget {
  final Map<String, String> menu;
  final void Function(int index) onItemSelect;
  final void Function(int index) onItemReselect;
  final void Function() onMoreClick;

  const DalalHomeNavBar({
    Key? key,
    required this.menu,
    required this.onItemSelect,
    required this.onItemReselect,
    required this.onMoreClick,
  }) : super(key: key);

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
              color: (key == widget.menu.keys.toList()[currentIndex])
                  ? primaryColor
                  : null,
            ),
            label: key,
          )))
      .values
      .toList();

  int currentIndex = 0;

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
            widget.onMoreClick();
            return;
          }
          if (value != currentIndex) {
            widget.onItemSelect(value);
            setState(() => currentIndex = value);
          } else {
            widget.onItemReselect(value);
          }
        },
      );
}
