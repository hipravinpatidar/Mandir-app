import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jaap_latest/api_service/api_service.dart';
import 'package:jaap_latest/controller/language_manager.dart';
import 'package:jaap_latest/model/mandir_model.dart';
import 'package:provider/provider.dart';
import 'mandir_home_page.dart';

class Mandir extends StatefulWidget {
  const Mandir({super.key});

  @override
  State<Mandir> createState() => _MandirState();
}

class _MandirState extends State<Mandir> with TickerProviderStateMixin {


  bool isLoading = false;
  int selectedIndex = 0;

   TabController? _tabController;

  @override
  void initState() {
    super.initState();
    getTabs(); // Fetch data after initializing
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  List<MandirData> mandirTabs = [];

  Future<void> getTabs() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      // Fetch data from the API
      final res = await ApiService().getData("https://mahakal.rizrv.in/api/v1/bhagwan");
      print('Response: $res');

      if (res != null) {
        final tabsCategory = MandirModel.fromJson(res);

        // Check if the response contains data
        if (tabsCategory.data != null) {
          // Get current day and reorder data
          List<MandirData> reorderedTabs = reorderDataByDay(tabsCategory.data!);

          // Update state with reordered data
          setState(() {
            mandirTabs = reorderedTabs;


            _tabController = TabController(length: mandirTabs.length, vsync: this);

            _tabController!.addListener(() {
              // Only proceed if the index has actually changed
              if (_tabController!.index == _tabController!.previousIndex) {
                return; // No action if the tab hasn't changed
              }

              // Check if the user has reached the last tab and is trying to scroll past it
              if (_tabController!.index == mandirTabs.length - 1) {
                // Delay the transition to avoid abrupt jumping
                Future.delayed(Duration(milliseconds: 300), () {
                  // Check if the user is still on the last tab and trying to scroll past it
                  if (_tabController!.index == mandirTabs.length - 1) {
                    // Animate to the first tab to create an infinite loop effect
                    _tabController!.animateTo(0);
                    setState(() {
                      selectedIndex = 0; // Update the selectedIndex
                    });
                  }
                });
              } else {
                // If the tab is not the last one, update the selected index normally
                setState(() {
                  selectedIndex = _tabController!.index;
                });
              }

              // Print the tab change for debugging purposes
              print("Tab Changed: $selectedIndex");
            });



//             _tabController = TabController(length: mandirTabs.length, vsync: this);
//
// // Flag to prevent unwanted jumping to the first tab
//             bool shouldAnimateToFirstTab = false;
//
//             _tabController!.addListener(() {
//               // Check if the tab change is at the last index
//               if (_tabController!.index == mandirTabs.length - 1) {
//                 // We are at the last tab, set the flag to animate back to the first tab
//                 shouldAnimateToFirstTab = true;
//               }
//
//               // Check if the index has changed and it should only animate to the first tab once
//               if (_tabController!.index != _tabController!.previousIndex && shouldAnimateToFirstTab) {
//                 // Delay the jump to avoid abrupt transitions
//                 Future.delayed(Duration(milliseconds: 300), () {
//                   _tabController!.animateTo(0); // Animate back to the first tab
//                   setState(() {
//                     selectedIndex = 0; // Update selectedIndex
//                     shouldAnimateToFirstTab = false; // Reset the flag
//                   });
//                 });
//               }
//
//               // Update selectedIndex as the tab changes
//               if (_tabController!.index != _tabController!.previousIndex) {
//                 setState(() {
//                   selectedIndex = _tabController!.index;
//                 });
//                 print("Tab Changed: $selectedIndex");
//               }
//             });



// Real Code

            // _tabController = TabController(length: mandirTabs.length, vsync: this);
            //
            // _tabController!.addListener(() {
            //   // Check if the index has actually changed
            //   if (_tabController!.index != _tabController!.previousIndex) {
            //     setState(() {
            //       selectedIndex = _tabController!.index;
            //     });
            //
            //     // Check if the current tab is the last one
            //     if (selectedIndex == mandirTabs.length - 1) {
            //       Future.delayed(Duration(milliseconds: 300), () {
            //         _tabController!.animateTo(0); // Animate back to the first tab
            //         setState(() {
            //           selectedIndex = 0; // Reset selectedIndex to 0
            //         });
            //       });
            //     }
            //
            //     print("Tab Changed: $selectedIndex");
            //   }
            // });



            // _tabController = TabController(length: mandirTabs.length, vsync: this);
            //
            // // Add listener to detect tab changes
            // _tabController!.addListener(() {
            //
            //     if (_tabController!.index != _tabController!.previousIndex) {
            //       setState(() {
            //         selectedIndex = _tabController!.index;
            //       });
            //       print("Tab Changed: ${selectedIndex}");
            //     }
            //
            // });
            // print('Number of tabs: ${mandirTabs.length}');
            //

          });


        } else {
          print('Error: Received null or empty data.');
        }
      } else {
        print('Error: Received null response from API.');
      }
    } catch (e) {
      // Log and handle any exceptions
      print('Error fetching tabs: $e');
    } finally {
      // Reset loading state
      setState(() {
        isLoading = false;
      });
    }
  }

// Function to get the current day of the week
  String getCurrentDay() {
    final now = DateTime.now();
    return ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'][now.weekday % 7];
  }


// Function to reorder data based on the current day
  List<MandirData> reorderDataByDay(List<MandirData> data) {
    // Map for deity names associated with each day
    Map<String, String> deityForDay = {
      'Monday': 'Shiv',
      'Tuesday': 'Hanuman',
      'Wednesday': 'Ganesh',
      'Thursday': 'Vishnu',
      'Friday': 'Laxmi',
      'Saturday': 'Shani',
      'Sunday': 'Ram', // Assuming you want to add a deity for Sunday
    };

    // Get the deity for the current day
    String currentDay = getCurrentDay();
    String currentDeity = deityForDay[currentDay] ?? '';

    // Separate the current day's deity content from the rest
    List<MandirData> currentDayContent = data.where((item) {
      return item.enName.toLowerCase().contains(currentDeity.toLowerCase());
    }).toList();

    // Prepare the reordered list
    List<MandirData> reorderedList = [];

    // If there is a current day's deity and it has an event_image
    if (currentDayContent.isNotEmpty) {
      // Check if the event_image is not null
      if (currentDayContent[0].eventImage != null) {
        // Add the event_image to the images list
        currentDayContent[0].images.insert(0, currentDayContent[0].eventImage!);
      }

      // Add the current day's deity to the reordered list
      reorderedList.add(currentDayContent[0]);
    }

    // Prepare the other content
    List<MandirData> otherContent = data.where((item) {
      return !item.enName.toLowerCase().contains(currentDeity.toLowerCase());
    }).toList();

    // Add the other content to the reordered list
    reorderedList.addAll(otherContent);

    // Return the final reordered list
    return reorderedList;
  }


// Function to reorder data based on the current day
//   List<MandirData> reorderDataByDay(List<MandirData> data) {
//     // Map for deity names associated with each day
//     Map<String, String> deityForDay = {
//       'Monday': 'Shiv',
//       'Tuesday': 'Hanuman',
//       'Wednesday': 'Ganesh',
//       'Thursday': 'Vishnu',
//       'Friday': 'Durga',
//       'Saturday': 'Shani',
//       'Sunday': 'Surya',
//     };
//
//     // Get the deity for the current day
//     String currentDay = getCurrentDay();
//     String currentDeity = deityForDay[currentDay] ?? '';
//
//     // Separate the current day's deity content from the rest
//     List<MandirData> currentDayContent = data.where((item) {
//       return item.enName.toLowerCase().contains(currentDeity.toLowerCase());
//     }).toList();
//
//     List<MandirData> otherContent = data.where((item) {
//       return !item.enName.toLowerCase().contains(currentDeity.toLowerCase());
//     }).toList();
//
//     // Return reordered list
//     return [...currentDayContent, ...otherContent];
//   }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    List<Widget> tabs = [

      ...mandirTabs.map((cat) =>

          Tab(
            child:Container(
              height: 36,
              width: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                //shape: BoxShape.circle,
                 borderRadius: BorderRadius.circular(20),
                  border:
                  selectedIndex == mandirTabs.indexOf(cat)
                     ? Border.all(color: Colors.deepOrange,width:  selectedIndex == mandirTabs.indexOf(cat) ? 3 : 1)
                     : Border.all(color: Colors.white),
                  image: DecorationImage(image: NetworkImage(cat.thumbnail),fit: BoxFit.cover),
                  color: Colors.white
              ),
            ),

          ),)
    ];

    return
      isLoading ?
      Scaffold(backgroundColor: Colors.white,body:  Center(child: CircularProgressIndicator(color: Colors.orange,))) :
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          //toolbarHeight: 75,
          backgroundColor: Colors.orange.withOpacity(0.8),
          centerTitle: true,
          title: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.grey.withOpacity(0.5)),child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03,vertical: screenWidth * 0.01),
            child: Consumer<LanguageProvider>(
              builder: (BuildContext context, languageProvider, Widget? child) {
                return Text(
                  languageProvider.language == "english" ? mandirTabs[selectedIndex].enName : mandirTabs[selectedIndex].hiName
                  , style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white,fontSize: screenWidth * 0.05),);
              },
            ),
          ),),
          leading: IconButton(
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          actions: [
            Consumer<LanguageProvider>(
              builder: (BuildContext context, languageProvider, Widget? child) {
                return  IconButton(
                  onPressed: () {
                    languageProvider.toggleLanguage();
                  },
                  icon: Icon(Icons.translate,color:  languageProvider.language == "english" ?  Colors.white : Colors.black,),
                );
              },
            )
          ],
          bottom: TabBar(
            controller: _tabController,
            tabAlignment: TabAlignment.start,
              splashFactory: NoSplash.splashFactory,
          isScrollable: true,
              indicatorColor: Colors.transparent,
              dividerColor: Colors.transparent,
            labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
              tabs: tabs,
          ),

        ),
        body: TabBarView(
          controller: _tabController,
          physics: AlwaysScrollableScrollPhysics(),
        children: [

          ...mandirTabs.map((cat) =>
              MandirHomePage(hiName: cat.hiName,enName: cat.enName,id: cat.id,images: cat.images,thumbNail: cat.thumbnail,),
          )
        ])
      );
  }



}
