import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class DalalLoadingBar extends StatelessWidget {
  const DalalLoadingBar({Key? key}) : super(key: key);

// Show lottie animation in primary color
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 200,
        width: 200,
        child: Lottie.asset('assets/lottie/loading.json'));
  }
}
