import 'package:dalal_street_client/models/menu_item.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DalalHomeBottomSheet extends StatelessWidget {
  final List<MenuItem> items;
  final void Function(int index) onItemClick;

  const DalalHomeBottomSheet({
    Key? key,
    required this.items,
    required this.onItemClick,
  }) : super(key: key);

  List<Widget> get _sheetItems => items
      .map(
        (menuItem) => Builder(
          builder: (context) => HomeSheetItem(
            icon: SvgPicture.asset(menuItem.icon),
            label: menuItem.name,
            onClick: () {
              // Close bottom sheet
              Navigator.pop(context);
              onItemClick(items.indexOf(menuItem));
            },
          ),
        ),
      )
      .toList();

  @override
  build(context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 150,
            height: 4.5,
            decoration: const BoxDecoration(
              color: lightGray,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),
          ..._sheetItems,
          const SizedBox(height: 12),
        ],
      );
}

class HomeSheetItem extends StatelessWidget {
  final Widget icon;
  final String label;
  final void Function() onClick;

  const HomeSheetItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.onClick,
  }) : super(key: key);

  @override
  build(context) => InkWell(
        onTap: onClick,
        child: SizedBox(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                icon,
                const SizedBox(width: 20),
                Text(
                  label,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
}
