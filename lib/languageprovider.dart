import 'package:flutter/cupertino.dart';

class languageprovider extends ChangeNotifier{
  static const List<Map<String,dynamic>> language = [
    {
      'name': 'English',
      'locale' : 'en',
    },

    {
      'name': 'Hindi',
      'locale' : 'hi',
    },

    {
      'name': 'Marathi',
      'locale' : 'mr',
    },
    {
      'name': 'Bangla',
      'locale' : 'bn',
    },

  ];

  Locale selectedLocale = Locale('en');

  void changelanguage(String language){
    selectedLocale = Locale(language);
    notifyListeners();
  }

}