import 'package:flutter/material.dart';

class TextStyleManager {
  static TextStyle headline(BuildContext ctx) =>
      Theme.of(ctx).textTheme.headline6!;

  static TextStyle body(BuildContext ctx) =>
      Theme.of(ctx).textTheme.bodyText2!;
}
