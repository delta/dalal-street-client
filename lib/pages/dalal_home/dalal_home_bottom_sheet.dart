import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DalalHomeBottomSheet extends StatelessWidget {
  /// A map of labels and asset paths
  final Map<String, String> items;

  const DalalHomeBottomSheet({Key? key, required this.items}) : super(key: key);

  List<Widget> get _sheetItems => items
      .map((label, asset) => MapEntry(
          label,
          HomeSheetItem(
            icon: SvgPicture.asset(asset),
            label: label,
            onClick: () {},
          )))
      .values
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
