import 'package:flutter/cupertino.dart';
// import '../db_helper/db_helper.dart';
import '../model/sangeet_model.dart';

class FavouriteProvider with ChangeNotifier {
  late final List<Sangeet> _favouriteBhajan = [];

  List<Sangeet> get favouriteBhajan => _favouriteBhajan;

  FavouriteProvider() {
   // _loadBookmarks();
  }

  // Future<void> _loadBookmarks() async {
  //   _favouriteBhajan = await DBHelper.getBookmarks();
  //   notifyListeners();
  // }
  //
  // Future<void> toggleBookmark(Sangeet music, {bool isFixedTab = false}) async {
  //   // Check if the song is already bookmarked
  //   bool isBookmarked = _favouriteBhajan.any((bookmarked) => bookmarked.audio == music.audio);
  //
  //   if (isBookmarked) {
  //     // Remove the bookmark
  //     await DBHelper.deleteBookmark(music);
  //     _favouriteBhajan.removeWhere((bookmarked) => bookmarked.audio == music.audio);
  //   } else {
  //     // Add the bookmark
  //     await DBHelper.insertBookmark(music);
  //     _favouriteBhajan.add(music);
  //   }
  //
  //   // Notify listeners after updating bookmarks
  //   notifyListeners();
  // }
}