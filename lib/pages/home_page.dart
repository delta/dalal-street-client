import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(context) => const Center(
        child: Text(
          'Dalal to the moon 🥳',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      );
}
