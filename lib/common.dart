import 'package:flutter/material.dart';

bool isDarkMode(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;
