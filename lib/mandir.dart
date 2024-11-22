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

  late TabController _tabController;
  late PageController _pageController;

  bool isLoading = false;
  int selectedIndex = 0;


  @override
  void initState() {
    super.initState();
    getTabs(); // Fetch data after initializing
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _pageController.dispose();
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

            _pageController = PageController(initialPage: 0);

            // TabController listener for tab updates
            _tabController.addListener(() {
              if (_tabController.indexIsChanging) {
                _pageController.jumpToPage(_tabController.index);
                setState(() {
                  selectedIndex = _tabController.index;
                });
              }
            });

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
      const Scaffold(backgroundColor: Colors.white,body:  Center(child: CircularProgressIndicator(color: Colors.orange,))) :
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
            icon: const Icon(
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
            labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
              tabs: tabs,
          ),

        ),
        body:

        PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          onPageChanged: (index) {
            // Looping Logic
            if (index == mandirTabs.length) {
              // Scrolled past the last tab, loop to the first
              Future.delayed(const Duration(milliseconds: 300), () {
                _pageController.jumpToPage(0); // Jump back to the first page
                _tabController.animateTo(0);  // Sync the TabBar
              });
            } else if (index == -1) {
              // Scrolled before the first tab, loop to the last
              Future.delayed(const Duration(milliseconds: 300), () {
                _pageController.jumpToPage(mandirTabs.length - 1); // Jump to the last page
                _tabController.animateTo(mandirTabs.length - 1);   // Sync the TabBar
              });
            } else {
              // Normal scroll behavior
              _tabController.animateTo(index % mandirTabs.length); // Sync TabBar
              setState(() {
                selectedIndex = index % mandirTabs.length;
              });
            }
          },
          itemCount: mandirTabs.length + 1, // Add +1 for the looping logic
          itemBuilder: (context, index) {
            // Handle extra index for looping
            final displayIndex = index % mandirTabs.length;
            final tab = mandirTabs[displayIndex];

            // Return the content for each tab
            return MandirHomePage(
              hiName: tab.hiName,
              enName: tab.enName,
              id: tab.id,
              images: tab.images,
              thumbNail: tab.thumbnail,
            );
          },
        ),
      );
  }
}
