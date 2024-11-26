import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:jaap_latest/controller/language_manager.dart';
import 'package:gif/gif.dart';
import 'package:jaap_latest/view/sangeet_view.dart';
import 'package:provider/provider.dart';

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

class _MandirHomePageState extends State<MandirHomePage>
    with SingleTickerProviderStateMixin {

  late PageController _pageController;
  late GifController _gifController;

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
  int _currentThaliIndex = 0;
  int currentGifIndex = 0;
  int selectedIndex = 0;

  // BELL-11111   L
  final String bellImage = 'assets/images/Bell_1.png';
  final String bellGif = 'assets/images/bell_video.gif';
  final String bellImages = 'assets/images/bell_2.png';
  final String bellGifs = 'assets/images/bell_video.gif';

  // Background images list
  List<String> backgroundImages = [
    'assets/images/backfirst.jpg',
    'assets/images/backsecond.jpg',
  ];

  // Toran images list
  List<String> toranImages = [
    'assets/images/toranfirst.png',
    'assets/images/toransecond.png',
    'assets/images/toranthird.png',
    'assets/images/toranfourth.png',
    'assets/images/toranfifth.png',
  ];

  // Thali images list
  List<String> thaliImages = [
    'assets/images/silverthali.gif',
  ];

  final List<String> _flowerGifs = [
    "assets/images/whiteflower.gif",
    "assets/images/whiteflower.gif",
    "assets/images/whiteflower.gif",
    "assets/images/whiteflower.gif",
  ];

  void playNextGif() {
    setState(() {
      _isFlowerVisible = true;
      print("is clicked");
      // Update the current GIF index
      currentGifIndex = (currentGifIndex + 1) % _flowerGifs.length;
    });

    // Restart the GIF animation
    _gifController.reset();
    _gifController.forward();
  }

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

    // Initialize the GifController with a duration
    _gifController = GifController(
      vsync: this,
    )..duration = const Duration(seconds: 3);

    // Listen to when the audio has completed playing
    artiPlayer.onPlayerComplete.listen((event) {
      // Automatically stop the player and toggle the state
      artiPlayer.play(AssetSource("images/arti_audio.mp3"));
      _toggleImage(true);
      _toggleImages(true);
    });
  }

  void simulateLoading() async {
    await Future.delayed(const Duration(seconds: 5)); // 5-second delay
    setState(() {
      isLoading = true; // Set isLoading to true after delay
    });
  }

  @override
  void dispose() {
    super.dispose();
    firstBellPlayer.dispose();
    shankPlayer.dispose();
    artiPlayer.dispose();
    secondBellPlayer.dispose();
    _pageController.dispose();
    _gifController.dispose();
  }

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
              physics: BouncingScrollPhysics(),
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
                ? Visibility(
                    visible: true,
                    child: Image.asset(
                      "assets/images/flower.gif", // Replace with your GIF path
                    ))
                : Visibility(
                    visible: _isFlowerVisible,
                    child: Gif(
                      image: AssetImage(_flowerGifs[currentGifIndex]),
                      controller: _gifController, // if duration and fps is null, original gif fps will be used.
                    //  placeholder: (context) => const Text('Loading...'),
                      onFetchCompleted: () {
                        _gifController.reset();
                        _gifController.forward();
                      },
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
                      child: GestureDetector(
                          onTap: () {
                            _toggleImage(true);
                            playBellFirst();
                          },
                          child: Image.asset(
                            bellImage,
                            height: 100,
                          )),
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
                      child: GestureDetector(
                          onTap: () {
                            _toggleImages(true);
                            playBellSecond();
                          },
                          child: Image.asset(
                            bellImage,
                            height: 100,
                          )),
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
                      padding: EdgeInsets.only(top: screenWidth * 0.4),
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
                  Positioned(
                    top: screenWidth * 0.8,
                    left: screenWidth * 0.01,
                    child: Column(
                      children: [
                        IgnorePointer(
                          ignoring: false, // Allow interaction with the buttons
                          child: GestureDetector(
                            onTap: () {
                              playNextGif();
                            },
                            child: Container(
                              width: screenWidth * 0.12,
                              height: screenWidth * 0.12,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 1),
                                color: Colors.orange.shade800
                                    .withOpacity(0.4), // Highlight color
                                borderRadius: BorderRadius.circular(300),
                              ),
                              child: Image.asset("assets/images/flower_b.png"),
                            ),
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
                                  languageProvider.language == "english" ? "Flower" : "पुष्प",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Arti button
                  Positioned(
                    top: screenWidth * 1,
                    left: screenWidth * 0.01,
                    child: Column(
                      children: [
                        IgnorePointer(
                          ignoring: false, // Allow interaction with the buttons
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                toggleArti();
                                _isThaliGifVisible = !_isThaliGifVisible;
                              });
                            },
                            child: Container(
                              child: Image.asset("assets/images/aarti_b.png"),
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Shank Button
                  Positioned(
                    top: 475,
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
                            child: Image.asset("assets/images/shank.png"),
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Backgroun Button
                  Positioned(
                    top: 555,
                    left: screenWidth * 0.01,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              color: Colors.orange.shade800
                                  .withOpacity(0.4), // highlight color
                              borderRadius: BorderRadius.circular(300),
                            ),
                            child: Image.asset("assets/images/sanget_b.png"),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Container(
                          height: screenWidth * 0.05,
                          width: screenWidth * 0.14,
                          decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(6)),
                          child:Center(
                            child: Consumer<LanguageProvider>(
                              builder: (BuildContext context, languageProvider, Widget? child) {
                                return Text(
                                  languageProvider.language == "english" ? "Mandir" : "मंदिर",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),


                  // Chadhawa
                  Positioned(
                    top: 390,
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
                                border:
                                Border.all(color: Colors.white, width: 1),
                                color: Colors.orange.shade800
                                    .withOpacity(0.4), // highlight color
                                borderRadius: BorderRadius.circular(300),
                              ),
                              child: Image.asset("assets/images/sanget_b.png"),
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
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Sangeet
                  Positioned(
                    top: 475,
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
                              child: Image.asset("assets/images/sanget_b.png"),
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
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Toran Button
                  Positioned(
                    top: 555,
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
                              child: Image.asset("assets/images/sanget_b.png"),
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
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Puja Thali

                  _isThaliGifVisible
                      ? Container()
                      : Positioned(
                          bottom: 90,
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
                                  thaliImages[_currentThaliIndex],
                                  height: 65,
                                ),
                              ),
                            ),
                          ),
                        ),
                  // Other buttons...
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
