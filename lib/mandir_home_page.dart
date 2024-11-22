import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:gif_control_csx/gif_control_csx.dart';
import 'package:gif_control_csx/controller/gif_controller.dart';
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

  int _currentIndex = 0;

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
  List<String> toranImages =
  [
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

 // Controls the visibility of the GIF
  //bool _hasFlowerStarted = false;

 // To track if the flower animation has started
 //  void _showFlower() {
 //    setState(() {
 //      _isFlowerVisible = true; // Show the GIF
 //      if (!_hasFlowerStarted) {
 //        _hasFlowerStarted = true; // Mark that the flower animation has started
 //      }
 //    });
 //
 //    // Start a timer to hide the flower GIF after 2 seconds
 //    Timer(Duration(seconds: 5), () {
 //      setState(() {
 //        _isFlowerVisible = false; // Hide the GIF after 2 seconds
 //      });
 //    });
 //  }


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
    Timer(Duration(milliseconds: 1000), () {
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
    Timer(Duration(milliseconds: 1000), () {
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
              if (index == imagesList!.length) {
                Future.delayed(Duration(milliseconds: 300), () {
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
                  // Optional overlay or positioned widget
                  // Positioned(
                  //   top: 500,
                  //   left: 70,
                  //   right: 70,
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color: Colors.orange,
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(16.0),
                  //       child: Center(
                  //         child: Text(
                  //           "Hello, I Am Pravin",
                  //           style: TextStyle(color: Colors.white),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              );
            },
          ),



          // // PageView for Vertical Swiping
          // PageView.builder(
          //   allowImplicitScrolling: true,
          //   controller: _pageController,
          //   onPageChanged: (index) {
          //    // setState(() {
          //
          //       // Handle automatic jump back to the first or last item seamlessly
          //       if (index == widget.imagesList!.length) {
          //         _pageController.jumpToPage(0);
          //       }
          //    // });
          //   },
          //   itemCount: widget.imagesList!.length,
          //   scrollDirection: Axis.vertical,
          //   itemBuilder: (context, index) {
          //
          //     //final actualIndex = index % widget.imagesList!.length;
          //
          //     return Stack(
          //       children: [
          //
          //         Container(
          //           decoration: BoxDecoration(
          //             image: DecorationImage(
          //               image: NetworkImage(
          //                 widget.imagesList![index]
          //                   //widget.imagesList![index]
          //       ),
          //               //image: AssetImage("assets/images/matadurga.png"),
          //               fit: BoxFit.contain,
          //             ),
          //           ),
          //         ),
          //
          //         // Positioned(
          //         //   top: 500,
          //         //   left: 70,
          //         //   right: 70,
          //         //   child: Container(
          //         //       color: Colors.orange,
          //         //       decoration: BoxDecoration(
          //         //         borderRadius:
          //         //       ),
          //         //       child: Padding(
          //         //     padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02,vertical: screenWidth * 0.03),
          //         //     child: Center(child: Text("HELLO I Am Pravin")),
          //         //   )),
          //         // )
          //
          //       ],
          //     );
          //   },
          // ),


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
                    padding: EdgeInsets.only(top: 150),
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
                            child: Image.asset(
                                "assets/images/flower_b.png"), // Flower button
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.white, width: 1),
                              color: Colors.orange.shade800
                                  .withOpacity(0.4), // Highlight color
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
                        child: Text(
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
                        child: Text(
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
                              child: Image.asset("assets/images/shank.png"),
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.white, width: 1),
                                color: Colors.orange.shade300
                                    .withOpacity(0.4), // highlight color
                                borderRadius: BorderRadius.circular(300),
                              ),
                            ),
                          ),
                          SizedBox(height: 3),

                          Container(
                            decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
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

                            //  _currentToranIndex =
                               //   (_currentToranIndex + 1) %
                             //         toranImages.length;
                              // _currentShubhIndex = (_currentShubhIndex + 1) % shubhImages.length;
                              // _currentLabhIndex = (_currentLabhIndex + 1) % labhImages.length;
                             // _currentThaliIndex =
                                //  (_currentThaliIndex + 1) %
                                    //  thaliImages.length;
                            });
                          },
                          child: Container(
                            child:
                            Image.asset("assets/images/sanget_b.png"),
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

                              // _currentThaliIndex =
                              //  (_currentThaliIndex + 1) %
                              //  thaliImages.length;
                            });
                          },
                          child: Container(
                            child:
                            Image.asset("assets/images/sanget_b.png"),
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
                        child: Image.asset(
                          thaliImages[_currentThaliIndex],
                          height: 65,
                        ),
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



        // Stack(
        //   children: [
        //     Container(
        //         decoration: BoxDecoration(
        //           image: DecorationImage(
        //             image: AssetImage(backgroundImages[
        //             _currentBackgroundIndex]), // Use the same asset path
        //             fit: BoxFit.cover,
        //           ),
        //         ),
        //         height: 810,
        //         width: double.infinity,
        //         //child: Stack(
        //         //  children: [
        //
        //               //  TORAN
        //             // Container(
        //             //   height: screenHeight * 0.204,
        //             //   width: double.infinity,
        //             //   child: Image.asset(
        //             //     bellGif,
        //             //     // toranImages[_currentToranIndex],
        //             //     fit: BoxFit.fill,
        //             //   ),
        //             // ),
        //         //
        //         //     // Visibility(
        //         //     //   visible: _isFlowerVisible,
        //         //     //   child: Image.asset(
        //         //     //       'assets/images/flower.gif'), // Show the GIF
        //         //     // ),
        //         //  ],
        //        // )
        //     ),
        //
        //     PageView.builder(
        //      // reverse: true,
        //       pageSnapping: true,
        //       allowImplicitScrolling: true,
        //       onPageChanged: (index) {
        //         setState(() {
        //           _currentIndex = index;
        //         });
        //       },
        //       itemCount: widget.imagesList!.length,
        //       scrollDirection: Axis.vertical,
        //       itemBuilder: (context, index) {
        //         return
        //            Container(
        //             height: 300, // Full height
        //             width: 260, // Full width
        //             decoration: BoxDecoration(
        //               image: DecorationImage(
        //                 image: AssetImage("assets/images/matadurga.png"),
        //              //   image: NetworkImage(images[index]), // Ensure correct index access
        //                 fit: BoxFit.contain, // Change fit as needed (cover, contain, etc.)
        //               ),
        //             ),
        //
        //
        //           // CardSwiper(
        //           //   backCardOffset: const Offset(0, 10),
        //           //   cardsCount: images[index].length,
        //           //   cardBuilder: (context, cardIndex,x,y) {
        //           //     return Container(
        //           //       // height: double.infinity, // Full height
        //           //       // width: double.infinity, // Full width
        //           //       decoration: BoxDecoration(
        //           //         image: DecorationImage(
        //           //           image: NetworkImage(images[index]), // Ensure correct index access
        //           //           fit: BoxFit.contain, // Change fit as needed (cover, contain, etc.)
        //           //         ),
        //           //       ),
        //           //     );
        //           //   },
        //           //   scale: 0.4, // Adjust this to control scaling of the back cards
        //           //   padding: const EdgeInsets.all(10), // Adjust for spacing
        //           // ),
        //
        //         );
        //       },
        //     ),
        //
        //     //  TORAN
        //     Container(
        //      height: screenHeight * 0.3,
        //       width: double.infinity,
        //      // color: Colors.red,
        //      child:
        //       Image.asset(
        //          toranImages[_currentToranIndex],
        //         fit: BoxFit.fill,
        //       ),
        //     ),
        //
        //     Visibility(
        //       visible: _isFlowerVisible,
        //       child: Image.asset(
        //           'assets/images/flower.gif'), // Show the GIF
        //     ),
        //
        //
        //
        //
        //
        //     //
        //     // if (_showGif)
        //     //   Positioned(
        //     //     bottom: screenHeight * 0.617,
        //     //     left: screenWidth * 0.025,
        //     //     child: GestureDetector(
        //     //       onTap: () {
        //     //         _toggleImage(true);
        //     //       },
        //     //       child: Image.asset(
        //     //         bellGif, // Show the GIF
        //     //         height: 100,
        //     //       ),
        //     //     ),
        //     //   )
        //     // else
        //     //   Positioned(
        //     //     bottom: screenHeight * 0.617,
        //     //     left: screenWidth * 0.095,
        //     //     child: GestureDetector(
        //     //       onTap: () {
        //     //         playBellFirst();
        //     //         _toggleImage(true);
        //     //       },
        //     //       child: Image.asset(
        //     //         bellImage, // Show the original bell image
        //     //         height: 100,
        //     //       ),
        //     //     ),
        //     //   ),
        //     //
        //     // //  BELL-222222
        //     // if (_showGifs)
        //     //   Positioned(
        //     //     bottom: screenHeight * 0.617,
        //     //     left: screenWidth * 0.73,
        //     //     child: GestureDetector(
        //     //       onTap: () {
        //     //         _toggleImages(true);
        //     //       },
        //     //       child: Image.asset(
        //     //         bellGifs, // Show the GIF
        //     //         height: 100,
        //     //       ),
        //     //     ),
        //     //   )
        //     // else
        //     //   Positioned(
        //     //     bottom: screenHeight * 0.617,
        //     //     left: screenWidth * 0.80,
        //     //     child: GestureDetector(
        //     //       onTap: () {
        //     //         _toggleImages(true);
        //     //         playBellSecond();
        //     //       },
        //     //       child: Image.asset(
        //     //         bellImages, // Show the original bell image
        //     //         height: 100,
        //     //       ),
        //     //     ),
        //     //   ),
        //
        //
        //
        //     // Overlay for buttons
        //     Positioned(
        //       top: 0,
        //       left: 0,
        //       right: 0,
        //       bottom: 0,
        //       child: Stack(
        //         children: [
        //           Center(
        //             child: Padding(
        //               padding: EdgeInsets.only(top: 150),
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   _isThaliGifVisible
        //                       ? Image.asset(
        //                     "assets/images/thali_round.gif",
        //                     height: 500,
        //                   )
        //                       : Container(),
        //                 ],
        //               ),
        //             ),
        //           ),
        //
        //           // Positioned(
        //           //   top: 350,
        //           //   left: 15,
        //           //   child: ElevatedButton(
        //           //       onPressed: (){
        //           //         playSound();
        //           //       },
        //           //       child: Text("please press me"),
        //           //   ),
        //           // ),
        //
        //           Positioned(
        //             top: 380,
        //             left: 8,
        //             child: Column(
        //               children: [
        //                 IgnorePointer(
        //                   ignoring:
        //                   false, // Allow interaction with the buttons
        //                   child: GestureDetector(
        //                     onTap:
        //                     _showFlower, // Call the function to show the flower GIF
        //                     child: Container(
        //                       child: Image.asset(
        //                           "assets/images/flower_b.png"), // Flower button
        //                       width: 45,
        //                       height: 45,
        //                       decoration: BoxDecoration(
        //                         border:
        //                         Border.all(color: Colors.white, width: 1),
        //                         color: Colors.orange.shade800
        //                             .withOpacity(0.4), // Highlight color
        //                         borderRadius: BorderRadius.circular(300),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //                 SizedBox(height: 3),
        //                 Container(
        //                   decoration: BoxDecoration(
        //                       color: Colors.orangeAccent,
        //                       borderRadius: BorderRadius.circular(10)),
        //                   child: Text(
        //                     " flower ",
        //                     style: TextStyle(fontWeight: FontWeight.bold),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //
        //           Positioned(
        //             top: 455,
        //             left: 8,
        //             child: Column(
        //               children: [
        //                 IgnorePointer(
        //                   ignoring:
        //                   false, // Allow interaction with the buttons
        //                   child: GestureDetector(
        //                     onTap: () {
        //                       setState(() {
        //                         toggleArti();
        //                         _animateBell = true;
        //                         _isFlowerVisible = !_isFlowerVisible;
        //                         if (_isFlowerVisible && !_hasFlowerStarted) {
        //                           _hasFlowerStarted = true;
        //                         }
        //                         _isThaliGifVisible =
        //                         !_isThaliGifVisible;
        //
        //                         if(isPlaying = true){
        //                           _toggleImages(true); // Call your custom toggle function
        //                           _toggleImage(true);// Call the state toggle function
        //                         }
        //                       });
        //                     },
        //                     child: Container(
        //                       child: Image.asset("assets/images/aarti_b.png"),
        //                       width: 45,
        //                       height: 45,
        //                       decoration: BoxDecoration(
        //                         border:
        //                         Border.all(color: Colors.white, width: 1),
        //                         color: Colors.orange.shade800
        //                             .withOpacity(0.4), // highlight color
        //                         borderRadius: BorderRadius.circular(300),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //                 SizedBox(height: 3),
        //                 Container(
        //                   decoration: BoxDecoration(
        //                       color: Colors.orangeAccent,
        //                       borderRadius: BorderRadius.circular(10)),
        //                   child: Text(
        //                     "  aarti  ",
        //                     style: TextStyle(fontWeight: FontWeight.bold),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //
        //           Padding(
        //             padding: EdgeInsets.only(top: 530, left: 8, right: 8),
        //             child: Row(
        //               children: [
        //                 Column(
        //                   children: [
        //                     // Text(_showGif ? 'Show Original Image' : 'Show Bell GIF'),
        //                     GestureDetector(
        //                       onTap: () {
        //                         setState(() {
        //                           playShank();
        //                         });
        //                       },
        //                       child: Container(
        //                         child: Image.asset("assets/images/shank.png"),
        //                         width: 45,
        //                         height: 45,
        //                         decoration: BoxDecoration(
        //                           border: Border.all(
        //                               color: Colors.white, width: 1),
        //                           color: Colors.orange.shade300
        //                               .withOpacity(0.4), // highlight color
        //                           borderRadius: BorderRadius.circular(300),
        //                         ),
        //                       ),
        //                     ),
        //                     SizedBox(height: 3),
        //
        //                     Container(
        //                       decoration: BoxDecoration(
        //                           color: Colors.orangeAccent,
        //                           borderRadius: BorderRadius.circular(10)),
        //                       child: Text(
        //                         " Song ",
        //                         style: TextStyle(fontWeight: FontWeight.bold),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ],
        //             ),
        //           ),
        //
        //           Positioned(
        //             top: 600,
        //             child: Padding(
        //               padding: const EdgeInsets.symmetric(horizontal: 8.0),
        //               child: Row(
        //                 children: [
        //                   GestureDetector(
        //                     onTap: () {
        //                       // Change background and images on tap
        //                       setState(() {
        //                         _currentBackgroundIndex =
        //                             (_currentBackgroundIndex + 1) %
        //                                 backgroundImages.length;
        //                         _currentToranIndex =
        //                             (_currentToranIndex + 1) %
        //                                 toranImages.length;
        //                         // _currentShubhIndex = (_currentShubhIndex + 1) % shubhImages.length;
        //                         // _currentLabhIndex = (_currentLabhIndex + 1) % labhImages.length;
        //                         _currentThaliIndex =
        //                             (_currentThaliIndex + 1) %
        //                                 thaliImages.length;
        //                       });
        //                     },
        //                     child: Container(
        //                       child:
        //                       Image.asset("assets/images/sanget_b.png"),
        //                       width: 50,
        //                       height: 50,
        //                       decoration: BoxDecoration(
        //                         border:
        //                         Border.all(color: Colors.white, width: 1),
        //                         color: Colors.orange.shade800
        //                             .withOpacity(0.4), // highlight color
        //                         borderRadius: BorderRadius.circular(300),
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //
        //           _isThaliGifVisible
        //               ? Container()
        //               : Positioned(
        //             bottom: 40,
        //             left: 140,
        //             child: Center(
        //               child: GestureDetector(
        //                 onTap: () {}, // Rotate when tapped
        //                 child: Draggable(
        //                   child: Image.asset(
        //                     thaliImages[_currentThaliIndex],
        //                     // width: 100,
        //                     height: 65,
        //                   ),
        //                   feedback: Image.asset(
        //                     'assets/images/aarti.png',
        //                     height: 75,
        //                   ),
        //                   childWhenDragging: Container(), // Optional
        //                   onDragStarted: () {
        //                     // Optional callback when drag starts
        //                   },
        //                   onDragUpdate: (details) {
        //                     // Update the position of the image based on the drag update
        //                     setState(() {
        //                       _offset = details.globalPosition;
        //                     });
        //                   },
        //                   onDragEnd: (details) {
        //                     // Optional callback when drag ends
        //                   },
        //                 ),
        //               ),
        //             ),
        //           ),
        //           // Other buttons...
        //         ],
        //       ),
        //     ),
        //   ],
        // ),


      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// class TempleApp extends StatefulWidget {
//   @override
//   _TempleAppState createState() => _TempleAppState();
// }
//
// class _TempleAppState extends State<TempleApp> {
//   int _currentBackgroundIndex = 0;
//   int _currentToranIndex = 0;
//   int _currentThaliIndex = 0;
//   bool _isThaliGifVisible = false;
//   bool _isFlowerVisible = false;
//   bool _hasFlowerStarted = false;
//   bool _animateBell = false;
//   bool _showGif = false;
//   bool _showGifs = false;
//
//   // Example assets
//   final List<String> backgroundImages = ["assets/images/background1.png"];
//   final List<String> toranImages = ["assets/images/toran1.png"];
//   final List<String> thaliImages = ["assets/images/thali1.png"];
//   final String bellGif = "assets/images/bell.gif";
//   final String bellGifs = "assets/images/bell2.gif";
//   final String bellImage = "assets/images/bell.png";
//   final String bellImages = "assets/images/bell2.png";
//
//   Offset _offset = Offset(0, 0); // Draggable offset
//
//   void _toggleImage(bool value) {
//     setState(() {
//       _showGif = value;
//     });
//   }
//
//   void _toggleImages(bool value) {
//     setState(() {
//       _showGifs = value;
//     });
//   }
//
//   void toggleArti() {
//     setState(() {
//       _animateBell = !_animateBell;
//     });
//   }
//
//   void playBellFirst() {
//     print("Playing first bell sound");
//   }
//
//   void playBellSecond() {
//     print("Playing second bell sound");
//   }
//
//   void playShank() {
//     print("Playing shank sound");
//   }
//
//   void _showFlower() {
//     setState(() {
//       _isFlowerVisible = !_isFlowerVisible;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final double screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background Container
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage(backgroundImages[_currentBackgroundIndex]),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             height: double.infinity,
//             width: double.infinity,
//           ),
//
//           // PageView for Vertical Swiping
//           PageView.builder(
//             onPageChanged: (index) {
//               setState(() {
//                 _currentBackgroundIndex = index % backgroundImages.length;
//               });
//             },
//             itemCount: backgroundImages.length,
//             scrollDirection: Axis.vertical,
//             itemBuilder: (context, index) {
//               return Container(
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage("assets/images/matadurga.png"),
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               );
//             },
//           ),
//
//           // Toran at the top
//           Positioned(
//             top: 0,
//             child: Container(
//               height: screenHeight * 0.3,
//               width: screenWidth,
//               child: Image.asset(
//                 toranImages[_currentToranIndex],
//                 fit: BoxFit.fill,
//               ),
//             ),
//           ),
//
//           // Flower Visibility
//           Visibility(
//             visible: _isFlowerVisible,
//             child: Positioned(
//               top: screenHeight * 0.5,
//               child: Image.asset('assets/images/flower.gif'),
//             ),
//           ),
//
//           // Bells
//           if (_animateBell) ...[
//             Positioned(
//               bottom: screenHeight * 0.617,
//               left: screenWidth * 0.025,
//               child: Image.asset(
//                 bellGif,
//                 height: 100,
//               ),
//             ),
//             Positioned(
//               bottom: screenHeight * 0.617,
//               left: screenWidth * 0.73,
//               child: Image.asset(
//                 bellGifs,
//                 height: 100,
//               ),
//             ),
//           ] else ...[
//             Positioned(
//               bottom: screenHeight * 0.617,
//               left: screenWidth * 0.025,
//               child: GestureDetector(
//                 onTap: () {
//                   _toggleImage(true);
//                   playBellFirst();
//                 },
//                 child: Image.asset(
//                   _showGif ? bellGif : bellImage,
//                   height: 100,
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: screenHeight * 0.617,
//               left: screenWidth * 0.73,
//               child: GestureDetector(
//                 onTap: () {
//                   _toggleImages(true);
//                   playBellSecond();
//                 },
//                 child: Image.asset(
//                   _showGifs ? bellGifs : bellImages,
//                   height: 100,
//                 ),
//               ),
//             ),
//           ],
//
//           // Aarti and Flower Buttons
//           Positioned(
//             top: 380,
//             left: 8,
//             child: Column(
//               children: [
//                 GestureDetector(
//                   onTap: _showFlower,
//                   child: Container(
//                     child: Image.asset("assets/images/flower_b.png"),
//                     width: 45,
//                     height: 45,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.white, width: 1),
//                       color: Colors.orange.shade800.withOpacity(0.4),
//                       borderRadius: BorderRadius.circular(300),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 3),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.orangeAccent,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Text(
//                     "Flower",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Thali Draggable
//           if (!_isThaliGifVisible)
//             Positioned(
//               bottom: 40,
//               left: 140,
//               child: Draggable(
//                 child: Image.asset(
//                   thaliImages[_currentThaliIndex],
//                   height: 65,
//                 ),
//                 feedback: Image.asset(
//                   'assets/images/aarti.png',
//                   height: 75,
//                 ),
//                 childWhenDragging: Container(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }



