import 'package:dalal_street_client/components/collapsible_sidebar/collapsible_sidebar.dart';
import 'package:dalal_street_client/components/collapsible_sidebar/components/collapsible_item.dart';
import 'package:dalal_street_client/constants/icons.dart';
import 'package:dalal_street_client/constants/urls.dart';
import 'package:dalal_street_client/models/menu_item.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

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
        onTitleTap: onTitleClick,
        onAvatarTap: onAvatarClick,
        avatarImg: Image.asset(AppIcons.appLogo),
        backgroundColor: baseColor,
        selectedTextColor: baseColor,
        unselectedTextColor: white,
        unselectedIconColor: lightGray,
        textStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        sidebarBoxShadow: const [],
        screenPadding: 0,
        borderRadius: 8,
        itemSelectorDecoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(100),
        ),
        items: collapsibleItems,
        body: body,
      );

  List<CollapsibleItem> get collapsibleItems => menu.map((menuItem) {
        final index = menu.indexOf(menuItem);
        final selected = index == currentIndex;
        return CollapsibleItem(
          text: menuItem.name,
          icon: Padding(
            padding: const EdgeInsets.all(4),
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

  void onTitleClick() => launch(bestStandupComedyInTheWorld);

  void onAvatarClick() => launch(sigmaChad);
}
