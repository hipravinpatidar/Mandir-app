import 'package:flutter/foundation.dart';

class LanguageProvider with ChangeNotifier{

  String _language = "english";

  String get language => _language;

  void toggleLanguage() {
    _language = _language == 'english' ? 'hindi' : 'english';
    notifyListeners();
  }

}