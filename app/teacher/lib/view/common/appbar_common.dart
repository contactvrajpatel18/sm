import 'package:flutter/material.dart';

PreferredSizeWidget AppbarCommon(String title, {bool showBack = false, List<Widget>? actions}) {
  return AppBar(
    title: Text(title),
    leading: showBack ?  BackButton() : null,
    actions: actions,
    backgroundColor: Colors.white,
  );
}
