import 'package:flutter/material.dart';

class NavigatorModel {
  final Widget page;
  final GlobalKey<NavigatorState> navKey;

  NavigatorModel({required this.page, required this.navKey});
}
