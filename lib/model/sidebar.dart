import 'package:flutter/material.dart';

class SideDrawerOptionsModel {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final Widget page;

  SideDrawerOptionsModel({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.page,
  });
}
