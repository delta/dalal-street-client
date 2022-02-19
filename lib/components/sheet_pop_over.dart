import 'package:dalal_street_client/constants/icons.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SheetPopOver extends StatelessWidget {
  const SheetPopOver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: 150,
            height: 4.5,
            decoration: const BoxDecoration(
              color: lightGray,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            )),
        const SizedBox(
          height: 3,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(AppIcons.crossWhite)),
            ],
          ),
        ),
      ],
    );
  }
}
