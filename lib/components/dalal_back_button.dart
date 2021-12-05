import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

class DalalBackButton extends StatelessWidget {
  final void Function()? onClick;

  const DalalBackButton({Key? key, this.onClick}) : super(key: key);

  @override
  Widget build(context) => GestureDetector(
        onTap: onClick ?? () => Navigator.maybePop(context),
        child: Row(
          children: const [
            Icon(
              Icons.arrow_back_rounded,
              color: lightGrey,
            ),
            SizedBox(width: 8),
            Text(
              'Back',
              style: TextStyle(
                fontSize: 18,
                color: lightGrey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
}
