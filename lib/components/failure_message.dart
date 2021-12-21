import 'package:flutter/material.dart';

class FailureMessage extends StatelessWidget {
  final String msg;
  final void Function() onClick;

  const FailureMessage({Key? key, required this.msg, required this.onClick})
      : super(key: key);

  @override
  build(context) => SizedBox(
        height: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(msg),
            OutlinedButton(
              onPressed: onClick,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
}
