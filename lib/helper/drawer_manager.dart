import 'package:flutter/material.dart';

mixin DrawerManager on StatefulWidget {
  bool isDrawerOpen = false;
  void toggleDrawer() => isDrawerOpen = !isDrawerOpen;
}