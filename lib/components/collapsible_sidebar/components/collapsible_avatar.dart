import 'package:flutter/material.dart';

class CollapsibleAvatar extends StatelessWidget {
  const CollapsibleAvatar({
    Key? key,
    required this.avatarSize,
    required this.backgroundColor,
    required this.name,
    required this.avatarImg,
    required this.textStyle,
  }) : super(key: key);

  final double avatarSize;
  final Color backgroundColor;
  final String name;
  final Widget avatarImg;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) => Container(
        height: avatarSize,
        width: avatarSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(avatarSize),
          color: backgroundColor,
        ),
        child: avatarImg != null ? _avatar : _initials,
      );

  Widget get _avatar => ClipRRect(
        borderRadius: BorderRadius.circular(avatarSize),
        child: avatarImg,
      );

  Widget get _initials => Center(
        child: Text(
          name.substring(0, 1).toUpperCase(),
          style: textStyle,
        ),
      );
}
