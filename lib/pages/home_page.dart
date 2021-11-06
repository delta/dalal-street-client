import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.userName}) : super(key: key);

  final String userName;

  @override
  Widget build(context) => Center(
        child: Text(
          'Current User: $userName',
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
      );
}
