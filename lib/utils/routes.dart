import 'package:flutter/material.dart';

typedef ItemCreator<T> = T Function();

Route route<T extends Widget>(T widget) => MaterialPageRoute<void>(builder: (_) => widget);
