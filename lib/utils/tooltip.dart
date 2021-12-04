import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

void showTooltip(BuildContext context, String text) => SuperTooltip(
      popupDirection: TooltipDirection.down,
      content: Text(
        text,
        style: Theme.of(context).textTheme.caption,
      ),
      backgroundColor: const Color(0xff373D3F),
      outsideBackgroundColor: Colors.transparent,
      hasShadow: false,
      borderWidth: 0,
      borderColor: Colors.transparent,
      borderRadius: 8,
      arrowBaseWidth: 16,
      arrowLength: 12,
      arrowTipDistance: 16,
    ).show(context);
