import 'package:flutter/material.dart';
import 'package:jaap_latest/controller/language_manager.dart';
import 'package:jaap_latest/view/mandir.dart';
import 'package:provider/provider.dart';
import '../api_service/api_service.dart';
import 'mandir_model.dart';

class Gridtabs extends StatefulWidget {
  const Gridtabs({super.key});

  @override
  State<Gridtabs> createState() => _GridtabsState();
}

class _GridtabsState extends State<Gridtabs> {

  bool isLoading = false;

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

            // _tabController = TabController(length: mandirTabs.length, vsync: this);
            //
            // _pageController = PageController(initialPage: 0);
            //
            // // TabController listener for tab updates
            // _tabController.addListener(() {
            //   if (_tabController.indexIsChanging) {
            //     _pageController.jumpToPage(_tabController.index);
            //     setState(() {
            //       selectedIndex = _tabController.index;
            //     });
            //   }
            // });

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
  void initState() {
    super.initState();
    getTabs();
  }

  @override
  Widget build(BuildContext context) {


    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text("Mandir",style: TextStyle(fontSize: screenWidth * 0.06,color: Colors.orange,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),


      body:  isLoading ? Center(child: CircularProgressIndicator(color: Colors.orange,)) : GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        childAspectRatio: 1.2,
      ),
        itemCount: mandirTabs.length,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
        itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01,vertical: screenWidth * 0.01),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Mandir(tabIndex: index),));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Container(
                  height: screenWidth * 0.3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(image: NetworkImage(
                      mandirTabs[index].thumbnail
                    ),fit: BoxFit.cover),

                  ),
                ),
                Consumer<LanguageProvider>(builder: (BuildContext context, languageProvider, Widget? child) {
                  return Text(
                    languageProvider.language == "english" ?
                    mandirTabs[index].enName : mandirTabs[index].hiName,
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth * 0.04),);
                },
                )
              ],
            ),
          ),
        );
      },),

    );
  }
}
