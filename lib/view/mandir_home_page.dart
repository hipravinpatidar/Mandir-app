import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:jaap_latest/controller/language_manager.dart';
import 'package:jaap_latest/view/sangeet_view.dart';
import 'package:provider/provider.dart';
import '../controller/audioplayer_manager.dart';
import '../controller/music_bar.dart';

class MandirHomePage extends StatefulWidget {

  int? id;
  String? hiName;
  String? enName;
  String? thumbNail;

  List<String>? images;

  MandirHomePage(
      {super.key,
      this.id,
      this.enName,
      this.hiName,
      this.thumbNail,
      this.images});

  @override
  State<MandirHomePage> createState() => _MandirHomePageState();
}

class _MandirHomePageState extends State<MandirHomePage> with TickerProviderStateMixin {

  late PageController _pageController;

  final firstBellPlayer = AudioPlayer();
  final secondBellPlayer = AudioPlayer();
  final artiPlayer = AudioPlayer();
  final shankPlayer = AudioPlayer();

  bool _isFlowerVisible = false;
  bool _isThaliGifVisible = false;
  bool _animateBell = false;
  bool _showGif = false;
  bool _showGifs = false;
  bool isLoading = false;
  bool isPlaying = false;
  bool isShankPlaying = false;

  Offset _offset = Offset.zero;

  int _currentBackgroundIndex = 0;
  int _currentToranIndex = 0;

  int selectedIndex = 0;

  // BELL-11111   L
  final String bellImage = 'assets/images/Bell_1.png';
  final String bellGif = 'assets/images/bell_video.gif';
  final String bellImages = 'assets/images/bell_2.png';
  final String bellGifs = 'assets/images/bell_video.gif';

  // Background images list
  List<String> backgroundImages = [

     'assets/images/mandirfirst.jpg',
     'assets/images/mandirsecond.jpg',
     'assets/images/mandirthird.jpg',
     'assets/images/mandirfourth.jpg',

  ];

  // Toran images list
  List<String> toranImages = [
    'assets/images/toranfirst.png',
    'assets/images/toranthird.png',
    'assets/images/toranfourth.png',
    'assets/images/toranfifth.png',
  ];

  void _toggleImage(bool isToggle) {
    setState(() {
      _showGif = isToggle; // Show the GIF
    });

    // Start a timer to switch back to the bell image after 1 second
    Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        _showGif = false; // Switch back to the bell image
      });
    });
  }

  void _toggleImages(bool isToggle) {
    setState(() {
      _showGifs = isToggle; // Show the GIF
    });

    // Start a timer to switch back to the bell image after 1 second
    Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        _showGifs = false; // Switch back to the bell image
      });
    });
  }

  Future<void> playShank() async {
    String audiopath = "images/_shank.mp3";

    if (isShankPlaying) {
      // Stop the audio if it's currently playing
      await shankPlayer.stop();
      setState(() {
        isShankPlaying = false;
      });
    } else {
      // Play the audio if it's not playing
      await shankPlayer.play(AssetSource(audiopath));
      setState(() {
        isShankPlaying = true;
      });
    }
  }

  Future<void> playBellFirst() async {
    String audiopath = "images/mybell.mp3";
    await firstBellPlayer.stop(); // Stop the current playback
    await firstBellPlayer.play(AssetSource(audiopath)); // Restart the sound
  }

  Future<void> playBellSecond() async {
    String audiopath = "images/mybell.mp3";
    await secondBellPlayer.stop(); // Stop the current playback
    await secondBellPlayer.play(AssetSource(audiopath)); // Restart the sound
  }

  Future<void> toggleArti() async {
    String audioPath = "images/arti_audio.mp3";

    _isThaliGifVisible = !_isThaliGifVisible;


    if (isPlaying) {
      // Stop the audio if it's currently playing
      await artiPlayer.stop();
      setState(() {
        isPlaying = false;
        _animateBell = false;
      });
    } else {
      // Play the audio if it's not playing
      await artiPlayer.play(AssetSource(audioPath));
      setState(() {
        isPlaying = true;
        _animateBell = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    simulateLoading();
    _pageController = PageController(initialPage: 1000);

    // Listen to when the audio has completed playing
      artiPlayer.onPlayerComplete.listen((event) {
      // Automatically stop the player and toggle the state
      artiPlayer.play(AssetSource("images/arti_audio.mp3"));
      _toggleImage(true);
      _toggleImages(true);
    });
  }

  void simulateLoading() async {
    // Simulate loading process
    await Future.delayed(Duration(seconds: 3));

    // Check if the widget is still mounted before calling setState
    if (mounted) {
      setState(() {
        // Update state here
        isLoading = true;
      });
    }
  }

  // Lists of GIFs for Flower 1 and Flower 2
  final List<String> flower1Gifs = [

    "assets/images/flowerloopfirst.gif",
    "assets/images/flowerloopsecond.gif",
    "assets/images/flowerloopthird.gif",
    "assets/images/flowerloopfourth.gif",

  ];
  final List<String> flower2Gifs = [

    "assets/images/flowerloopfifth.gif",
    "assets/images/flowerloopsixth.gif",
    'assets/images/flower.gif',
    'assets/images/flowerwhitwfull.gif',
  ];

  // Dynamic list to track active GIFs
  final List<_GifAnimation> activeGifs = [];

  // Map to manage timers for each GIF
  final Map<UniqueKey, Timer> _gifTimers = {};

  void _playNewGif(bool isFirst) {
    final gifList = isFirst ? flower1Gifs : flower2Gifs;
    final gifIndex = activeGifs.where((gif) => gif.isFirst == isFirst).length % gifList.length;

    // Create a new unique key for the GIF
    final gifKey = UniqueKey();

    // Add the new GIF
    setState(() {
      activeGifs.add(_GifAnimation(
        gifPath: gifList[gifIndex],
        isFirst: isFirst,
        key: gifKey,
      ));
    });

    // Schedule a timer to remove the GIF after 5 seconds
    _gifTimers[gifKey] = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          activeGifs.removeWhere((gif) => gif.key == gifKey);
          _gifTimers.remove(gifKey); // Remove the timer from the map
        });
      }
    });
  }

  @override
  void dispose() {
    // Cancel all timers when disposing the widget
    for (var timer in _gifTimers.values) {
      timer.cancel();
    }
    _gifTimers.clear();

    // Dispose other resources
    firstBellPlayer.dispose();
    shankPlayer.dispose();
    artiPlayer.dispose();
    secondBellPlayer.dispose();
    _pageController.dispose();

    super.dispose();
  }

  // void _playNewGif(bool isFirst) {
  //   final gifList = isFirst ? flower1Gifs : flower2Gifs;
  //   final gifIndex = activeGifs.where((gif) => gif.isFirst == isFirst).length % gifList.length;
  //
  //   setState(() {
  //     activeGifs.add(_GifAnimation(
  //       gifPath: gifList[gifIndex],
  //       isFirst: isFirst,
  //       key: UniqueKey(),
  //     ));
  //   });
  //
  //   // Remove GIF after 8 seconds
  //   Timer(const Duration(seconds: 8), () {
  //     setState(() {
  //       activeGifs.removeWhere((gif) => gif.key == activeGifs.last.key);
  //     });
  //   });
  // }
  //
  // @override
  // void dispose() {
  //   firstBellPlayer.dispose();
  //   shankPlayer.dispose();
  //   artiPlayer.dispose();
  //   secondBellPlayer.dispose();
  //   _pageController.dispose();
  //    super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var imagesList = widget.images;

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Background Container
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundImages[_currentBackgroundIndex]),
                  fit: BoxFit.cover,
                ),
              ),
              height: double.infinity,
              width: double.infinity,
            ),

            PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              pageSnapping: true,
              scrollDirection: Axis.vertical,
              onPageChanged: (index) {
                // No explicit jump logic needed for seamless infinite scrolling
                final actualIndex = index % imagesList!.length;
                print("Currently displaying image at index: $actualIndex");
              },
              itemBuilder: (context, index) {
                // Calculate the display index dynamically
                final displayIndex = index % imagesList!.length;

                return Stack(
                  children: [
                    // Display the image
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(imagesList[displayIndex]),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            _isThaliGifVisible
                ? Center(
                  child: Visibility(
                      visible: true,
                      child: Image.asset(
                        "assets/images/flower.gif", // Replace with your GIF path
                      )),
                )
                : Center(
                  child: Visibility(
                      visible: _isFlowerVisible,
                      child:

                      Stack(
                        children: [

                          // Display all active GIFs
                          for (var gif in activeGifs)
                            Positioned.fill(
                              child: _buildGifWidget(gif.gifPath),
                            ),

                        ],
                      )

                        // Stack(
                        //   children: activeGifs.map((gif) {
                        //     return Positioned.fill(
                        //       key: gif.key,
                        //       child: _buildGifWidget(gif.gifPath),
                        //     );
                        //   }).toList(),
                        // ),

                    ),
                ),

            // Toran at the top
            Positioned(
              top: 0,
              child: Container(
                height: screenHeight * 0.3,
                width: screenWidth,
                child: Image.asset(
                  toranImages[_currentToranIndex],
                  fit: BoxFit.fill,
                ),
              ),
            ),

            // Bells

            if (_animateBell) ...[
              Positioned(
                bottom: screenHeight * 0.520,
                // left: screenWidth * 0.10,
                child: Image.asset(
                  bellGif,
                  height: 100,
                ),
              ),
              Positioned(
                bottom: screenHeight * 0.520,
                left: screenWidth * 0.74,
                child: Image.asset(
                  bellGifs,
                  height: 100,
                ),
              ),
            ] else ...[
              _showGif
                  ? Positioned(
                      bottom: screenHeight * 0.520,
                      // left: screenWidth * 0.10,
                      child: Image.asset(
                        bellGif,
                        height: 100,
                      ))
                  : Positioned(
                      bottom: screenHeight * 0.520,
                      left: screenWidth * 0.10,
                      child: Consumer<AudioPlayerManager>(
                        builder: (BuildContext context, audioManager, Widget? child) {
                          return GestureDetector(
                              onTap: () {
                                _toggleImage(true);
                                playBellFirst();
                                audioManager.pauseMusic();
                              },
                              child: Image.asset(
                                bellImage,
                                height: 100,
                              ));
                        },
                      ),
                    ),
              _showGifs
                  ? Positioned(
                      bottom: screenHeight * 0.520,
                      left: screenWidth * 0.70,
                      child: Image.asset(
                        bellGif,
                        height: 100,
                      ))
                  : Positioned(
                      bottom: screenHeight * 0.520,
                      left: screenWidth * 0.79,
                      child: Consumer<AudioPlayerManager>(
                        builder: (BuildContext context, audioManager, Widget? child) {
                          return  GestureDetector(
                              onTap: () {
                                _toggleImages(true);
                                playBellSecond();
                                audioManager.pauseMusic();
                              },
                              child: Image.asset(
                                bellImage,
                                height: 100,
                              ));
                        },
                      ),
                    ),
            ],

            //   Overlay for buttons
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Stack(
                children: [
                  // Round thali
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: screenWidth * 0.2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _isThaliGifVisible
                              ? Image.asset(
                                  "assets/images/thali_round.gif",
                                  height: 500,
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),

                  // Flower Button
                  Consumer<AudioPlayerManager>(
                    builder: (BuildContext context, audioManager, Widget? child) {
                      return  Positioned(
                        top: audioManager.isMusicBarVisible ? screenWidth * 0.7 : screenWidth * 0.8,
                        left: screenWidth * 0.01,
                        child: Column(
                          children: [
                            IgnorePointer(
                              ignoring: false, // Allow interaction with the buttons
                              child: Container(
                                  width: screenWidth * 0.12,
                                  height: screenWidth * 0.12,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white, width: 1),
                                    // color: Colors.orange.shade800.withOpacity(0.4), // Highlight color
                                    borderRadius: BorderRadius.circular(300),
                                    image: DecorationImage(image:
                                    AssetImage("assets/images/flowerbuttonanimation.gif") )
                                  ),
                                  child: Column(
                                    children: [

                                      GestureDetector(
                                        onTap: () {
                                          _playNewGif(true);
                                          //_playFirstGif();
                                          //setState(() {
                                            //_isFlowerVisible = true;
                                        //  });
                                        },
                                        child: Container(
                                          height: 20,
                                          width: 30,
                                          color: Colors.transparent,
                                         // color: Colors.green,
                                        ),
                                      ),

                                      SizedBox(height: 2,),
                                      GestureDetector(
                                        onTap: () {
                                          _playNewGif(false);
                                         // _playSecondGif();
                                         // setState(() {
                                            _isFlowerVisible = true;
                                         // });
                                        },
                                        child: Container(
                                          height: 20,
                                          width: 30,
                                          color: Colors.transparent,
                                         // color: Colors.red,
                                        ),
                                      ),

                                    ],
                                  )
                                ),
                             // ),
                            ),
                            const SizedBox(height: 3),
                            Container(
                              height: screenWidth * 0.05,
                              width: screenWidth * 0.14,
                              decoration: BoxDecoration(
                                  color: Colors.orangeAccent,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Center(
                                child: Consumer<LanguageProvider>(
                                  builder: (BuildContext context, languageProvider, Widget? child) {
                                    return Text(
                                      languageProvider.language == "english" ? "Flower" : "पुष्प",
                                      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // Arti button
                  Consumer<AudioPlayerManager>(
                    builder: (BuildContext context, audioManager, Widget? child) {
                      return  Positioned(
                        top: audioManager.isMusicBarVisible ? screenWidth * 0.9 : screenWidth * 1,
                        left: screenWidth * 0.01,
                        child: Column(
                          children: [
                            IgnorePointer(
                              ignoring: false, // Allow interaction with the buttons
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    audioManager.pauseMusic();
                                    toggleArti();
                                  });
                                },
                                child: Container(
                                  child: Image.asset("assets/images/artibuttonanimation.gif"),
                                  width: screenWidth * 0.12,
                                  height: screenWidth * 0.12,
                                  decoration: BoxDecoration(
                                    border:
                                    Border.all(color: Colors.white, width: 1),
                                    color: Colors.orange.shade800
                                        .withOpacity(0.4), // highlight color
                                    borderRadius: BorderRadius.circular(300),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 3),
                            Container(
                              height: screenWidth * 0.05,
                              width: screenWidth * 0.14,
                              decoration: BoxDecoration(
                                  color: Colors.orangeAccent,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Center(
                                child: Consumer<LanguageProvider>(
                                  builder: (BuildContext context, languageProvider, Widget? child) {
                                    return Text(
                                      languageProvider.language == "english" ? "Aarti" : "आरती",
                                      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // Shank Button
                  Consumer<AudioPlayerManager>(
                    builder: (BuildContext context, audioManager, Widget? child) {
                      return Positioned(
                        top: audioManager.isMusicBarVisible ? 435 : 475,
                        left: screenWidth * 0.01,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  playShank();
                                });
                              },
                              child: Container(
                                width: screenWidth * 0.12,
                                height: screenWidth * 0.12,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 1),
                                  color: Colors.orange.shade300
                                      .withOpacity(0.4), // highlight color
                                  borderRadius: BorderRadius.circular(300),
                                ),
                                child: Image.asset("assets/images/shankbuttonanimation.gif"),
                              ),
                            ),
                            const SizedBox(height: 3),

                            Container(
                              height: screenWidth * 0.05,
                              width: screenWidth * 0.14,
                              decoration: BoxDecoration(
                                  color: Colors.orangeAccent,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Center(
                                child: Consumer<LanguageProvider>(
                                  builder: (BuildContext context, languageProvider, Widget? child) {
                                    return Text(
                                      languageProvider.language == "english" ? "Shankh" : "शंख",
                                      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // BackGround Button
                  Consumer<AudioPlayerManager>(
                    builder: (BuildContext context, audioManager, Widget? child) {
                      return Positioned(
                        top: audioManager.isMusicBarVisible ? 515 : 550,
                        left: screenWidth * 0.01,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Change background and images on tap
                                setState(() {
                                  _currentBackgroundIndex =
                                      (_currentBackgroundIndex + 1) %
                                          backgroundImages.length;
                                });
                              },
                              child: Container(
                                width: screenWidth * 0.12,
                                height: screenWidth * 0.12,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 1),
                                  color: Colors.orange.shade300
                                      .withOpacity(0.4), // highlight color
                                  borderRadius: BorderRadius.circular(300),
                                ),
                                child: Image.asset("assets/images/templebuttonanimation.gif"),
                              ),
                            ),
                            const SizedBox(height: 3),

                            Container(
                              height: screenWidth * 0.05,
                              width: screenWidth * 0.14,
                              decoration: BoxDecoration(
                                  color: Colors.orangeAccent,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Center(
                                child: Consumer<LanguageProvider>(
                                  builder: (BuildContext context, languageProvider, Widget? child) {
                                    return Text(
                                      languageProvider.language == "english" ? "Mandir" : "मंदिर",
                                      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // Chadhawa
                  Consumer<AudioPlayerManager>(
                    builder: (BuildContext context, audioManager, Widget? child) {
                      return  Positioned(
                        top: audioManager.isMusicBarVisible ? 350 : 380,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) => SangeetView(
                                  //         widget.hiName ?? '',
                                  //         godName: widget.enName ?? '',
                                  //       ),
                                  //     ));
                                },
                                child: Container(
                                  width: screenWidth * 0.14,
                                  height: screenWidth * 0.14,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white, width: 1),
                                    color: Colors.orange.shade800.withOpacity(0.4), // highlight color
                                    borderRadius: BorderRadius.circular(300),
                                  ),
                                  child: Image.asset("assets/images/chadawabutton.png"),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Container(
                                height: screenWidth * 0.05,
                                width: screenWidth * 0.17,
                                decoration: BoxDecoration(
                                    color: Colors.orangeAccent,
                                    borderRadius: BorderRadius.circular(6)),
                                child: Center(
                                  child: Consumer<LanguageProvider>(
                                    builder: (BuildContext context, languageProvider, Widget? child) {
                                      return Text(
                                        languageProvider.language == "english" ? "Chadawa" : "चढ़ावा",
                                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Sangeet
                  Consumer<AudioPlayerManager>(
                    builder: (BuildContext context, audioManager, Widget? child) {
                      return Positioned(
                        top: audioManager.isMusicBarVisible ? 433 : 465,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SangeetView(
                                          widget.hiName ?? '',
                                          godName: widget.enName ?? '',
                                        ),
                                      ));
                                },
                                child: Container(
                                  width: screenWidth * 0.14,
                                  height: screenWidth * 0.14,
                                  decoration: BoxDecoration(
                                    border:
                                    Border.all(color: Colors.white, width: 1),
                                    color: Colors.orange.shade800
                                        .withOpacity(0.4), // highlight color
                                    borderRadius: BorderRadius.circular(300),
                                  ),
                                  child: Image.asset("assets/images/bhajanbutton.png"),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Container(
                                height: screenWidth * 0.05,
                                width: screenWidth * 0.14,
                                decoration: BoxDecoration(
                                    color: Colors.orangeAccent,
                                    borderRadius: BorderRadius.circular(6)),
                                child: Center(
                                  child: Consumer<LanguageProvider>(
                                    builder: (BuildContext context, languageProvider, Widget? child) {
                                      return Text(
                                        languageProvider.language == "english" ? "Bhajan" : "भजन",
                                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Toran Button
                  Consumer<AudioPlayerManager>(
                    builder: (BuildContext context, audioManager, Widget? child) {
                      return Positioned(
                        top: audioManager.isMusicBarVisible ? 515 : 550,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Change background and images on tap
                                  setState(() {
                                    _currentToranIndex = (_currentToranIndex + 1) %
                                        toranImages.length;
                                  });
                                },
                                child: Container(
                                  width: screenWidth * 0.12,
                                  height: screenWidth * 0.12,
                                  decoration: BoxDecoration(
                                    border:
                                    Border.all(color: Colors.white, width: 1),
                                    color: Colors.orange.shade800
                                        .withOpacity(0.4), // highlight color
                                    borderRadius: BorderRadius.circular(300),
                                  ),
                                  child: Image.asset("assets/images/buttonanimate.gif"),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Container(
                                height: screenWidth * 0.05,
                                width: screenWidth * 0.14,
                                decoration: BoxDecoration(
                                    color: Colors.orangeAccent,
                                    borderRadius: BorderRadius.circular(6)),
                                child: Center(
                                  child: Consumer<LanguageProvider>(
                                    builder: (BuildContext context, languageProvider, Widget? child) {
                                      return  Text(
                                        languageProvider.language == "english" ? "Toran" : "तोरण",
                                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Puja Thali

                  _isThaliGifVisible
                      ? Container()
                      : Consumer<AudioPlayerManager>(
                        builder: (BuildContext context, audioManager, Widget? child) {
                          return Positioned(
                            bottom: audioManager.isMusicBarVisible ? 60 : 90,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {}, // Rotate when tapped
                                child: Draggable(
                                  feedback: Image.asset(
                                    'assets/images/silverthali.gif',
                                    height: 75,
                                  ),
                                  childWhenDragging: Container(), // Optional
                                  onDragStarted: () {
                                    // Optional callback when drag starts
                                  },
                                  onDragUpdate: (details) {
                                    // Update the position of the image based on the drag update
                                    setState(() {
                                      _offset = details.globalPosition;
                                    });
                                  },
                                  onDragEnd: (details) {
                                    // Optional callback when drag ends
                                  },
                                  child: Image.asset(
                                    "assets/images/silverthali.gif",
                                    //thaliImages[_currentThaliIndex],
                                    height: 65,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  // Other buttons...
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Consumer<AudioPlayerManager>(
        builder: (context, audioManager, child) {
          if (audioManager.isMusicBarVisible){
            return MusicBar(enName: widget.enName,hiName: widget.hiName,animateBell: _animateBell,);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildGifWidget(String gifPath) {
    return Center(
      child: RepaintBoundary(
        child: Image.asset(
          gifPath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

}

class _GifAnimation {
  final String gifPath;
  final bool isFirst;
  final UniqueKey key;

  _GifAnimation({required this.gifPath, required this.isFirst, required this.key});
}
