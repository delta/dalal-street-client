import 'package:dalal_street_client/components/collapsible_sidebar/collapsible_sidebar.dart';
import 'package:dalal_street_client/components/collapsible_sidebar/components/collapsible_item.dart';
import 'package:dalal_street_client/models/menu_item.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DalalSideBar extends StatelessWidget {
  final List<MenuItem> menu;
  final int currentIndex;
  final void Function(int index) onItemSelect;
  final void Function(int index) onItemReselect;
  final Widget body;

  const DalalSideBar({
    Key? key,
    required this.menu,
    required this.currentIndex,
    required this.onItemSelect,
    required this.onItemReselect,
    required this.body,
  }) : super(key: key);

  @override
  build(context) => CollapsibleSidebar(
        title: 'Dalal Street',
        backgroundColor: baseColor,
        selectedTextColor: baseColor,
        unselectedTextColor: white,
        sidebarBoxShadow: const [],
        items: collapsibleItems,
        itemSelectorDecoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(100),
        ),
        body: body,
      );

  List<CollapsibleItem> get collapsibleItems => menu.map((menuItem) {
        final index = menu.indexOf(menuItem);
        final selected = index == currentIndex;
        return CollapsibleItem(
          text: menuItem.name,
          icon: Padding(
            padding: const EdgeInsets.all(2),
            child: SvgPicture.asset(
              menuItem.icon,
              color: selected ? baseColor : lightGray,
            ),
          ),
          onPressed: () {
            if (selected) {
              onItemReselect(index);
            } else {
              onItemSelect(index);
            }
          },
          isSelected: selected,
        );
      }).toList();
}
