import 'package:dalal_street_client/models/menu_item.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DalalHomeSideDrawer extends StatefulWidget {
  final Map<String, MenuItem> menu;
  final int currentIndex;
  final void Function(int index) onItemSelect;
  final void Function(int index) onItemReselect;

  const DalalHomeSideDrawer(
      {Key? key,
      required this.menu,
      required this.currentIndex,
      required this.onItemSelect,
      required this.onItemReselect})
      : super(key: key);

  @override
  State<DalalHomeSideDrawer> createState() => _DalalHomeSideDrawerState();
}

class _DalalHomeSideDrawerState extends State<DalalHomeSideDrawer> {
  List<Widget> get _menuItems {
    final currentKey = widget.menu.keys.toList()[widget.currentIndex];
    return widget.menu
        .map(
          (key, menuItem) => MapEntry(
            key,
            ListTile(
              title: Text(menuItem.name),
              leading: SvgPicture.asset(menuItem.icon),
              selected: currentKey == key,
              selectedTileColor: primaryColor,
              selectedColor: baseColor,
              onTap: () {
                final index = widget.menu.keys.toList().indexOf(key);
                if (key == currentKey) {
                  widget.onItemReselect(index);
                } else {
                  widget.onItemSelect(index);
                }
                // Close the drawer
                Navigator.pop(context);
              },
            ),
          ),
        )
        .values
        .toList();
  }

  @override
  build(context) => Drawer(
        backgroundColor: baseColor,
        child: ListView(
          children: _menuItems,
        ),
      );
}
