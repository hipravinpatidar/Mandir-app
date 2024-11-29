import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view/custom_colors.dart';
import '../view/sangeet_view.dart';
import 'audioplayer_manager.dart';


class MusicBar extends StatefulWidget {

  final String? hiName;
  final String? enName;
  final bool animateBell;

  const MusicBar({super.key, this.hiName, this.enName, required this.animateBell,});

  @override
  State<MusicBar> createState() => _MusicBarState();
}

class _MusicBarState extends State<MusicBar> {
  @override
  Widget build(BuildContext context) {
    final audioManager = Provider.of<AudioPlayerManager>(context);

    var screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SangeetView(widget.hiName ?? '', godName: widget.enName ?? '',),));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 1000),
        height: 70.0, // Adjust as needed
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(1),topRight: Radius.circular(1)),
          color: Colors.orange,

        ),
        child:
        Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
            child:
            Row(
              children: [

                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(image: NetworkImage(audioManager.currentMusic!.image),fit: BoxFit.cover)
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03,vertical: screenWidth * 0.03),
                  child: Container(
                    width: screenWidth * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                      Text(audioManager.currentMusic!.title,style: TextStyle(fontSize: screenWidth * 0.04,color: Colors.white,fontWeight: FontWeight.bold),maxLines: 1,),
                       Text(audioManager.currentMusic!.singerName,style: TextStyle(fontSize: screenWidth * 0.04,color: Colors.white,fontWeight: FontWeight.bold),maxLines: 1,),

                      ],
                    ),
                  ),
                ),



                        // Skip Previous
                        // IconButton(
                        //   onPressed: () {
                        //     audioManager.skipPrevious();
                        //   },
                        //   icon: Icon(
                        //     Icons.skip_previous,
                        //     color: Colors.white,
                        //     size: screenWidth * 0.09,
                        //   ),
                        // ),

                        // Toggle Play Pause
                        GestureDetector(
                          onTap: () => audioManager.togglePlayPause(),
                          child: Icon(
                            audioManager.isPlaying
                                ? Icons.pause_circle
                                : Icons.play_circle ,
                            size: screenWidth * 0.1,
                            color: CustomColors.clrwhite,
                          ),
                        ),

                        // Skip Next
                        // IconButton(
                        //   onPressed: () {
                        //     audioManager.skipNext();
                        //   },
                        //   icon: Icon(
                        //     Icons.skip_next,
                        //     color: Colors.white,
                        //     size: screenWidth * 0.09,
                        //   ),
                        // ),

                         Spacer(),
                        // Remove Music Bar
                        IconButton(
                          onPressed: () {
                            audioManager.stopMusic();
                            audioManager.resetMusicBarVisibility();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: screenWidth * 0.07,
                          ),
                        ),




                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //
                //
                //     Container(
                //       width: screenWidth * 0.1,
                //       height: screenWidth * 0.1,
                //       decoration: BoxDecoration(
                //         image: DecorationImage(
                //           image: NetworkImage(audioManager.currentMusic!.image),
                //           fit: BoxFit.cover,
                //         ),
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //     ),
                //
                //     //SizedBox(width: screenWidth * 0.03,),
                //     Expanded(
                //       child: Padding(
                //         padding: EdgeInsets.only(
                //           top: screenWidth * 0.03,
                //           left: screenWidth * 0.02,
                //         ),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //
                //             Row(
                //               children: [
                //
                //                 SizedBox(
                //                   width: screenWidth * 0.24,
                //                   child: Text(
                //                     audioManager.currentMusic!.title,
                //                     style: const TextStyle(
                //                       color: Colors.white,
                //                       fontWeight: FontWeight.bold,
                //                       overflow: TextOverflow.ellipsis,
                //                     ),
                //                     maxLines: 1,
                //                   ),
                //                 ),
                //
                //                 // SizedBox(width: screenWidth * 0.04,),
                //                 // SizedBox(
                //                 //   width: screenWidth * 0.05,
                //                 //   child: Text("${audioManager.currentMusic!.singerName}",
                //                 //     style: const TextStyle(
                //                 //       color: Colors.white,
                //                 //       fontWeight: FontWeight.bold,
                //                 //       overflow: TextOverflow.ellipsis,
                //                 //     ),
                //                 //     maxLines: 1,
                //                 //   ),
                //                 // ),
                //               ],
                //
                //             ),
                //
                //
                //             SizedBox(
                //               width: screenWidth * 0.4,
                //               child: Text(
                //                 audioManager.currentMusic!.singerName ?? '',
                //                 style: const TextStyle(
                //                   color: Colors.white,
                //                   fontWeight: FontWeight.bold,
                //                   overflow: TextOverflow.ellipsis,
                //                 ),
                //                 maxLines: 1,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //
                //     SizedBox(height: screenWidth * 0.07,),
                //
                //     Row(
                //
                //
                //       children: [
                //
                //
                //         // Skip Previous
                //         IconButton(
                //           onPressed: () {
                //             audioManager.skipPrevious();
                //           },
                //           icon: Icon(
                //             Icons.skip_previous,
                //             color: Colors.white,
                //             size: screenWidth * 0.08,
                //           ),
                //         ),
                //
                //         // Toggle Play Pause
                //         GestureDetector(
                //           onTap: () => audioManager.togglePlayPause(),
                //           child: Icon(
                //             audioManager.isPlaying
                //                 ? Icons.pause_circle
                //                 : Icons.play_circle,
                //             size: screenWidth * 0.08,
                //             color: CustomColors.clrwhite,
                //           ),
                //         ),
                //
                //         // Skip Next
                //         IconButton(
                //           onPressed: () {
                //             audioManager.skipNext();
                //           },
                //           icon: Icon(
                //             Icons.skip_next,
                //             color: Colors.white,
                //             size: screenWidth * 0.08,
                //           ),
                //         ),
                //
                //         // Remove Music Bar
                //         IconButton(
                //           onPressed: () {
                //             audioManager.stopMusic();
                //             audioManager.resetMusicBarVisibility();
                //           },
                //           icon: Icon(
                //             Icons.arrow_drop_up_outlined,
                //             color: Colors.white,
                //             size: screenWidth * 0.08,
                //           ),
                //         ),
                //       ],
                //
                //     )
                //
                //
                //
                //     // Skip Next
                //     // IconButton(
                //     //   onPressed: () {
                //     //     if (audioManager.isPlaying) {
                //     //       // Skip to the next track
                //     //       audioManager.skipNext();
                //     //     } else {
                //     //       // Handle the case where the music is not playing
                //     //       audioManager.toggleMusicBarVisibility();
                //     //     }
                //     //   },
                //     //   icon: Icon(
                //     //     audioManager.isPlaying
                //     //         ? Icons.skip_next
                //     //         : Icons.highlight_remove_outlined,
                //     //     color: Colors.white,
                //     //     size: screenWidth * 0.1,
                //     //   ),
                //     // ),
                //
                //   ],
                // ),

                // Padding(
                //   padding:EdgeInsets.symmetric(vertical: screenWidth * 0.01),
                //   child: Container(
                //     height: 5,
                //     width: double.infinity,
                //     child: SliderTheme(
                //       data: SliderThemeData(
                //         activeTrackColor: CustomColors.clrwhite,
                //         trackHeight: 1.5,
                //         trackShape: const RectangularSliderTrackShape(),
                //         inactiveTrackColor: CustomColors.clrwhite.withOpacity(0.5),
                //         thumbColor: CustomColors.clrwhite,
                //         thumbShape: SliderComponentShape.noThumb,
                //         overlayColor: CustomColors.clrwhite.withOpacity(0.7),
                //         valueIndicatorColor: CustomColors.clrwhite,
                //       ),
                //       child: Slider(
                //         min: 0.0,
                //         max: audioManager.duration.inSeconds.toDouble(),
                //         value: audioManager.currentPosition.inSeconds.toDouble(),
                //         onChanged: (double value) {
                //           audioManager.seekTo(Duration(seconds: value.toInt()));
                //         },
                //       ),
                //     ),
                //   ),
                // ),

              ],
            )
        ),
      ),
    );
  }
}