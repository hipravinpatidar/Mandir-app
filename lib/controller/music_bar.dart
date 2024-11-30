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
        decoration: const BoxDecoration(
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
                  child: SizedBox(
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

              ],
            )
        ),
      ),
    );
  }
}