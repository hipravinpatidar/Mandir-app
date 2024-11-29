// import 'dart:async';
//
// import 'package:flutter/material.dart';
//
// class FlowerApp extends StatelessWidget {
//   const FlowerApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Flower Fall Animation'),
//         ),
//         body: const FlowerAnimationScreen(),
//       ),
//     );
//   }
// }
//
// class FlowerAnimationScreen extends StatefulWidget {
//   const FlowerAnimationScreen({super.key});
//
//   @override
//   State<FlowerAnimationScreen> createState() => _FlowerAnimationScreenState();
// }
//
// class _FlowerAnimationScreenState extends State<FlowerAnimationScreen> {
//
//
//   bool isFirstvisible = false;
//   bool isSecondvisible = false;
//
//   Timer? _timer;
//
//   List<UniqueKey> _gifKeys = [UniqueKey(), UniqueKey()]; // UniqueKey for reset
//
//   void _resetGif(int index) {
//
//     _timer?.cancel();
//
//     setState(() {
//       _gifKeys[index] = UniqueKey(); // Resets the specific GIF
//
//       // Stop GIF playback after 5 seconds
//     _timer = Timer(const Duration(seconds: 8), () {
//       setState(() {
//         isFirstvisible = false;
//         isSecondvisible = false;
//       });
//
//     });
//     });}
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: Stack(
//             children: [
//               // GIF 1
//               Positioned.fill(
//                 child: Visibility(
//                   visible: isFirstvisible, // Always visible
//                   child: _buildGifWidget(0, 'assets/images/flower.gif'),
//                 ),
//               ),
//               // GIF 2
//               Positioned.fill(
//                 child: Visibility(
//                   visible: isSecondvisible, // Always visible
//                   child: _buildGifWidget(1, 'assets/images/flowerwhitwfull.gif'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: (){
//                 _resetGif(0);
//                 isFirstvisible = true;
//                 },
//               child: const Text('Play Flower 1'),
//             ),
//             const SizedBox(width: 10),
//             ElevatedButton(
//               onPressed: (){
//                 _resetGif(1);
//                 isSecondvisible = true;
//               },
//               child: const Text('Play Flower 2'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildGifWidget(int index, String assetPath) {
//     return Center(
//       child: RepaintBoundary(
//         key: _gifKeys[index], // Resets the widget when key changes
//         child: Image.asset(
//           assetPath,
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
// }
//

// import 'dart:async';
//
// import 'package:flutter/material.dart';
//
// class FlowerApp extends StatelessWidget {
//   const FlowerApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Flower Fall Animation'),
//         ),
//         body: const FlowerAnimationScreen(),
//       ),
//     );
//   }
// }
//
// class FlowerAnimationScreen extends StatefulWidget {
//   const FlowerAnimationScreen({super.key});
//
//   @override
//   State<FlowerAnimationScreen> createState() => _FlowerAnimationScreenState();
// }
//
// class _FlowerAnimationScreenState extends State<FlowerAnimationScreen> {
//   // Lists of GIFs for both buttons
//   final List<String> flower1Gifs = [
//     'assets/images/flower.gif',
//     'assets/images/flower.gif',
//     'assets/images/flower.gif',
//   ];
//
//   final List<String> flower2Gifs = [
//     'assets/images/flowerwhitwfull.gif',
//     'assets/images/flowerwhitwfull.gif',
//     'assets/images/flowerwhitwfull.gif',
//   ];
//
//   // Current index for each list
//   int flower1Index = 0;
//   int flower2Index = 0;
//
//   // Visibility flags
//   bool isFirstVisible = false;
//   bool isSecondVisible = false;
//
//   Timer? _timer;
//
//   // UniqueKey list to reset GIFs
//   final List<UniqueKey> _gifKeys = [UniqueKey(), UniqueKey()];
//
//   void _resetGif(int index, bool isFirst) {
//     // Cancel the existing timer if running
//     _timer?.cancel();
//
//     setState(() {
//       // Reset the UniqueKey
//       _gifKeys[index] = UniqueKey();
//
//       // Make the appropriate GIF visible
//       if (isFirst) {
//         isFirstVisible = true;
//         isSecondVisible = false;
//       } else {
//         isSecondVisible = true;
//         isFirstVisible = false;
//       }
//
//       // Stop GIF playback after 8 seconds
//       _timer = Timer(const Duration(seconds: 8), () {
//         setState(() {
//           isFirstVisible = false;
//           isSecondVisible = false;
//         });
//       });
//     });
//   }
//
//   void _playNextGif(bool isFirst) {
//     if (isFirst) {
//       // Play the next GIF in the first list
//       flower1Index = (flower1Index + 1) % flower1Gifs.length; // Loop back to start
//       _resetGif(0, true);
//     } else {
//       // Play the next GIF in the second list
//       flower2Index = (flower2Index + 1) % flower2Gifs.length; // Loop back to start
//       _resetGif(1, false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: Stack(
//             children: [
//               // GIF 1
//               Positioned.fill(
//                 child: Visibility(
//                   visible: isFirstVisible,
//                   child: _buildGifWidget(flower1Index, flower1Gifs, 0),
//                 ),
//               ),
//               // GIF 2
//               Positioned.fill(
//                 child: Visibility(
//                   visible: isSecondVisible,
//                   child: _buildGifWidget(flower2Index, flower2Gifs, 1),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () => _playNextGif(true), // Play next GIF for Flower 1
//               child: const Text('Play Flower 1'),
//             ),
//             const SizedBox(width: 10),
//             ElevatedButton(
//               onPressed: () => _playNextGif(false), // Play next GIF for Flower 2
//               child: const Text('Play Flower 2'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildGifWidget(int index, List<String> gifList, int keyIndex) {
//     return Center(
//       child: RepaintBoundary(
//         key: _gifKeys[keyIndex], // Reset the widget when key changes
//         child: Image.asset(
//           gifList[index],
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
// }


import 'dart:async';

import 'package:flutter/material.dart';

class FlowerApp extends StatelessWidget {
  const FlowerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flower Fall Animation'),
        ),
        body: const FlowerAnimationScreen(),
      ),
    );
  }
}

class FlowerAnimationScreen extends StatefulWidget {
  const FlowerAnimationScreen({super.key});

  @override
  State<FlowerAnimationScreen> createState() => _FlowerAnimationScreenState();
}

class _FlowerAnimationScreenState extends State<FlowerAnimationScreen> {
  // Lists of GIFs for Flower 1 and Flower 2
  final List<String> flower1Gifs = [
    'assets/images/flower.gif',
    'assets/images/flower.gif',
  ];
  final List<String> flower2Gifs = [

    'assets/images/flowerwhitwfull.gif',
    'assets/images/flowerwhitwfull.gif',
  ];

  // Dynamic list to track active GIFs
  final List<_GifAnimation> activeGifs = [];

  void _playNewGif(bool isFirst) {
    final gifList = isFirst ? flower1Gifs : flower2Gifs;
    final gifIndex = activeGifs.where((gif) => gif.isFirst == isFirst).length % gifList.length;

    setState(() {
      activeGifs.add(_GifAnimation(
        gifPath: gifList[gifIndex],
        isFirst: isFirst,
        key: UniqueKey(),
      ));
    });

    // Remove GIF after 8 seconds
    Timer(const Duration(seconds: 8), () {
      setState(() {
        activeGifs.removeWhere((gif) => gif.key == activeGifs.last.key);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: activeGifs.map((gif) {
              return Positioned.fill(
                key: gif.key,
                child: _buildGifWidget(gif.gifPath),
              );
            }).toList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _playNewGif(true), // Play new Flower 1 GIF
              child: const Text('Play Flower 1'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => _playNewGif(false), // Play new Flower 2 GIF
              child: const Text('Play Flower 2'),
            ),
          ],
        ),
      ],
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
