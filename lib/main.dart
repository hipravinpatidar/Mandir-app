import 'package:flutter/material.dart';
import 'package:jaap_latest/controller/audioplayer_manager.dart';
import 'package:jaap_latest/controller/favourite_provider.dart';
import 'package:jaap_latest/controller/language_manager.dart';
import 'package:provider/provider.dart';
import 'controller/share_controller.dart';
import 'view/mandir.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => LanguageProvider(),),
    ChangeNotifierProvider(create: (context) => AudioPlayerManager(),),
    ChangeNotifierProvider(create: (context) => FavouriteProvider(),),
    ChangeNotifierProvider(create: (context) => ShareMusic())
  ],
  child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    home:
    //FlowerApp()
    Mandir(tabIndex: 0,),

       // FlowerGifWidget()
  //  FlowerRainOnGod()
    );
  }
}
