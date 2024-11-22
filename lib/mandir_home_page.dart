import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
class MandirHomePage extends StatefulWidget {

  int? id;
  String? hiName;
  String? enName;
  String? thumbNail;

  List<String>? images;

   MandirHomePage({super.key,this.id,this.enName,this.hiName,this.thumbNail,this.images});

  @override
  State<MandirHomePage> createState() => _MandirHomePageState();
}

class _MandirHomePageState extends State<MandirHomePage> {

  bool _isThaliGifVisible = false;
  bool _animateBell = false;

  Offset _offset = Offset.zero;

  bool isPlaying = false;
  bool isShankPlaying = false;

  int _currentBackgroundIndex = 0;
  int _currentToranIndex = 0;
  int _currentThaliIndex = 0;

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
    'assets/images/coper_thali.png',
  ];

  // FLOWERSSSS

  bool _isFlowerVisible = false;

  void _dropFlower(){
    setState(() {
      _isFlowerVisible = true;
    });

    Timer(Duration(seconds: 5),(){
      setState(() {
        _isFlowerVisible = false;
      });
    });

  }

  // BELL-11111   List of images for
  final String bellImage = 'assets/images/Bell_1.png';
 // Path to your bell image
  final String bellGif = 'assets/images/bell_video.gif';
 // Path to your GIF
  bool _showGif = false;
 // State to track which image to show
  final String bellImages = 'assets/images/bell_2.png';
 // Path to your bell image
  final String bellGifs = 'assets/images/bell_video.gif';
 // Path to your GIF
  bool _showGifs = false;
 // State to track which image to show
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

  final player1 = AudioPlayer();

  final player2 = AudioPlayer();

  final artiPlayer = AudioPlayer();

  final shankPlayer = AudioPlayer();

  int selectedIndex = 0;

  bool isLoading = false;

  late  PageController _pageController;

  @override
  void initState() {
    super.initState();
    simulateLoading();
    _pageController = PageController();
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
    player1.dispose();
    shankPlayer.dispose();
    artiPlayer.dispose();
    player2.dispose();
    _pageController.dispose();
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
    await player1.stop(); // Stop the current playback
    await player1.play(AssetSource(audiopath)); // Restart the sound
  }

  Future<void> playBellSecond() async {
    String audiopath = "images/mybell.mp3";
    await player2.stop(); // Stop the current playback
    await player2.play(AssetSource(audiopath)); // Restart the sound
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
  Widget build(BuildContext context) {

    var imagesList = widget.images;

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return  Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:
            
        Stack(
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
            scrollDirection: Axis.vertical,
            onPageChanged: (index) {
              // When reaching the end of the list, jump back to the first image
              if (index == imagesList.length) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  _pageController.jumpToPage(0);
                });
              }
            },
            itemCount: imagesList!.length + 1, // Add +1 for the looping logic
            itemBuilder: (context, index) {
              // If it's the extra index, show the first image
              final displayIndex = index % imagesList.length;

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

          _isThaliGifVisible ?

          Visibility(
              visible: true,
              child:
              Image.asset(
                "assets/images/flower.gif", // Replace with your GIF path
              )
          ) :

                Visibility(
                  visible: _isFlowerVisible,
                  child:
                  Image.asset(
                    "assets/images/flowerwhitwfull.gif", // Replace with your GIF path
                  )
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


            _showGif ? Positioned(
              bottom: screenHeight * 0.520,
             // left: screenWidth * 0.10,
                child: Image.asset(
                  bellGif,
                  height: 100,
                )
            ) :  Positioned(
              bottom: screenHeight * 0.520,
              left: screenWidth * 0.10,
              child: GestureDetector(
                onTap: () {
                  _toggleImage(true);
                  playBellFirst();
                },
                child:
                Image.asset(
                  bellImage,
                  height: 100,
                )
              ),
            ),

            _showGifs ? Positioned(
                bottom: screenHeight * 0.520,
                 left: screenWidth * 0.70,
                child: Image.asset(
                  bellGif,
                  height: 100,
                )
            ) :  Positioned(
              bottom: screenHeight * 0.520,
              left: screenWidth * 0.79,
              child: GestureDetector(
                  onTap: () {
                    _toggleImages(true);
                    playBellSecond();
                  },
                  child:
                  Image.asset(
                    bellImage,
                    height: 100,
                  )
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
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 150),
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

                Positioned(
                  top: 380,
                  left: 8,
                  child: Column(
                    children: [
                      IgnorePointer(
                        ignoring:
                        false, // Allow interaction with the buttons
                        child: GestureDetector(
                          onTap: _dropFlower,

                         // _showFlower, // Call the function to show the flower GIF
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.white, width: 1),
                              color: Colors.orange.shade800
                                  .withOpacity(0.4), // Highlight color
                              borderRadius: BorderRadius.circular(300),
                            ),
                            child: Image.asset(
                                "assets/images/flower_b.png"),
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          " flower ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: 455,
                  left: 8,
                  child: Column(
                    children: [
                      IgnorePointer(
                        ignoring:
                        false, // Allow interaction with the buttons
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              toggleArti();

                              // _isFlowerVisible = !_isFlowerVisible;
                              // if (_isFlowerVisible && !_hasFlowerStarted) {
                              //   _hasFlowerStarted = true;
                              // }
                              _isThaliGifVisible =
                              !_isThaliGifVisible;
                            });
                          },
                          child: Container(
                            child: Image.asset("assets/images/aarti_b.png"),
                            width: 45,
                            height: 45,
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
                        decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          "  aarti  ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 530, left: 8, right: 8),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          // Text(_showGif ? 'Show Original Image' : 'Show Bell GIF'),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                playShank();
                              });
                            },
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.white, width: 1),
                                color: Colors.orange.shade300
                                    .withOpacity(0.4), // highlight color
                                borderRadius: BorderRadius.circular(300),
                              ),
                              child: Image.asset("assets/images/shank.png"),
                            ),
                          ),
                          const SizedBox(height: 3),

                          Container(
                            decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Text(
                              " Song ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: 606,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
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
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.white, width: 1),
                              color: Colors.orange.shade800
                                  .withOpacity(0.4), // highlight color
                              borderRadius: BorderRadius.circular(300),
                            ),
                            child:
                            Image.asset("assets/images/sanget_b.png"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: 606,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Change background and images on tap
                            setState(() {
                               _currentToranIndex =
                                (_currentToranIndex + 1) %
                                      toranImages.length;
                            });
                          },
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.white, width: 1),
                              color: Colors.orange.shade800
                                  .withOpacity(0.4), // highlight color
                              borderRadius: BorderRadius.circular(300),
                            ),
                            child:
                            Image.asset("assets/images/sanget_b.png"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

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
                          'assets/images/coper_thali.png',
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




