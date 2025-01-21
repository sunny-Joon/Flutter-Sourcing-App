import 'package:flutter/material.dart';

class languageprovider extends ChangeNotifier {
  static const List<Map<String, dynamic>>language = [
    {
      'name': 'English',
      'locale': 'en',
      'icon': 'assets/Images/en.png', // Example icon path
    },
    {
      'name': 'Hindi',
      'locale': 'hi','icon': 'assets/Images/hi.png', // Example icon path
    },
    {
      'name': 'Marathi',
      'locale': 'mr',
      'icon': 'assets/Images/mr.png', // Example icon path
    },
    {
      'name': 'Bangla',
      'locale': 'bn',
      'icon': 'assets/Images/bn.png', // Example icon path
    },
    // Add more languages with their respective icons here
  ];

  Locale selectedLocale = const Locale('en');

  void changelanguage(String language) {
    selectedLocale = Locale(language);
    notifyListeners();
  }
}