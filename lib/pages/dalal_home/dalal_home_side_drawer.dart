import 'package:dalal_street_client/models/menu_item.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DalalHomeSideDrawer extends StatelessWidget {
  final List<MenuItem> menu;
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

  List<Widget> get _menuItems => menu.map(
        (menuItem) {
          final index = menu.indexOf(menuItem);
          final selected = index == currentIndex;
          return Builder(
            builder: (context) => ListTile(
              title: Text(menuItem.name),
              leading: SvgPicture.asset(menuItem.icon),
              selected: selected,
              selectedTileColor: primaryColor,
              selectedColor: baseColor,
              onTap: () {
                if (selected) {
                  onItemReselect(index);
                } else {
                  onItemSelect(index);
                }
                // Close the drawer
                Navigator.pop(context);
              },
            ),
          );
        },
      ).toList();

  @override
  build(context) => Drawer(
        backgroundColor: baseColor,
        child: ListView(
          children: _menuItems,
        ),
      );
}
