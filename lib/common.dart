import 'package:flutter/material.dart';

bool isDarkMode(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

bool isArabic(context) => Localizations.localeOf(context).languageCode == 'ar';

