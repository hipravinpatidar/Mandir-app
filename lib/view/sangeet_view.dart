import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jaap_latest/api_service/api_service.dart';
import 'package:jaap_latest/model/mandir_sangeet_model.dart';
import 'package:jaap_latest/view/sangeet_view_bhajan.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/audioplayer_manager.dart';
import '../controller/favourite_provider.dart';
import '../controller/language_manager.dart';
import '../controller/share_controller.dart';
import '../model/sangeet_model.dart';
import 'custom_colors.dart';
import 'lyrics_bhajan.dart';

class SangeetView extends HookWidget {
   SangeetView(
  this.godNameHindi,
  {
    //
    // required this.musicData,
    // required this.categoryId,
    // required this.subCategoryId,
    // required this.allcategorymodel,
    // required this.MyCurrentIndex,
    // required this.subCategoryModel,
     required this.godName,

  }
  );

  // final int MyCurrentIndex;
  // final List subCategoryModel;
   final String godName;
   final String godNameHindi;
  // final List<Sangeet> musicData;
  // final int categoryId;
  // final int subCategoryId;


  @override
  Widget build(BuildContext context) {

     AudioPlayerManager audioManager = AudioPlayerManager();

    // State variables
    final isLoading = useState<bool>(false);

    final mandirBhajan = useState<List<Subcategory>>([]);

    final bhajanDataList = useState<List<Sangeet>>([]);
    final allcategorymodel = useState<List<Sangeet>>([]);

    final categoryData = useState<Category?>(null); // To store the category details

     Future<void> fetchBhajanData() async {
       String currentLanguage = context.read<LanguageProvider>().language;

       audioManager = Provider.of<AudioPlayerManager>(context);

       print(" My Current Selected Language Is $currentLanguage");

       // print("My category Id ${widget.categoryId}");
       //  print("My SubCategoryId ${widget.subCategoryId}");

       isLoading.value = true;

       try {
         final musicListResponse = await ApiService().getData(
             "https://mahakal.rizrv.in/api/v1/bhagwan/bhagwan-sangeet?category_id=${1}&subcategory_id=${2}&language=$currentLanguage"
           //'${AppConstants.baseUrl}/api/v1/sangeet/sangeet-details?subcategory_id=${widget.subCategoryId}&language=$currentLanguage',
         );

         print("My dynamic bhajan $musicListResponse");

         //  print(" My Coming Language is ${LanguageProvider.selectedLanguage}");
         if (musicListResponse != null) {
           final sangeetModel = BhajanModel.fromJson(musicListResponse);

           bhajanDataList.value.clear();
           bhajanDataList.value = sangeetModel.sangeet.where((item) => item.status == 1).toList();
            audioManager.setPlaylist(bhajanDataList.value);
           isLoading.value = false;

           print(bhajanDataList.value.length);

         } else {
           print("Error: The response is null or improperly formatted.");

           isLoading.value = false;
         }
       } catch (error) {
         print("Failed to fetch music data: $error");
         isLoading.value = false;
         //_noData = true;
       }
     }

     Future<void> getAllCategoryData() async {
       String currentLanguage = context.read<LanguageProvider>().language;

       print("My category from this ${categoryData.value!.id}");

       isLoading.value = true;

       try {
         final res = await ApiService().getData(
           "https://mahakal.rizrv.in/api/v1/bhagwan/bhagwan-sangeet?category_id=${categoryData.value!.id}&subcategory_id=all&language=$currentLanguage",
         );

         print("My All Bhajan $res");

         // Ensure the response is a map and contains the expected list
         if (res is Map<String, dynamic> && res.containsKey('sangeet')) {
           final List<dynamic> dataList = res['sangeet'];

           final List<Sangeet> categoryList =
           dataList.map((e) => Sangeet.fromJson(e)).toList();

           allcategorymodel.value = categoryList.where((item) => item.status == 1).toList();

          // audioManager.playMusic(allcategorymodel.value[0]);

           //audioManager.playMusic(allcategorymodel.value[0]);

           print("all cat model ${allcategorymodel.value.length}");

         } else {
           isLoading.value = false;

           print("Unexpected response format: $res");
           allcategorymodel.value = []; // Clear data if response is invalid
         }
       } catch (error) {
         isLoading.value = false;

         print("Failed to fetch all category data: $error");
         allcategorymodel.value = []; // Clear data on error
       }
     }

    // API call function
    Future<void> getBhajanData() async {

      print("${godName}");
      print("${godNameHindi}");

      final Map<String, dynamic> requestData = {
        //"category_name": "shiv ji",
         "category_name": "$godName",
      };

      isLoading.value = true;

      try {

        // API Call
        final res = await ApiService().postData(
          "https://mahakal.rizrv.in/api/v1/bhagwan/get-by-category-name",
          requestData,
        );

        print(res);
        if (res == null) {
          print("API returned null response. Check your endpoint or parameters.");
          mandirBhajan.value = [];
          categoryData.value = null;
          return;
        }

        // Parse the response using MandirBhajanModel
        final mandirBhajanModel = MandirBhajanModel.fromJson(res);

        // Update the `mandirBhajan` with the list of subcategories and category
        categoryData.value = mandirBhajanModel.category;
        mandirBhajan.value = mandirBhajanModel.subcategories;

        fetchBhajanData();
        getAllCategoryData();


        print("Category: ${categoryData.value?.name}, ID: ${categoryData.value?.id}");
        print(mandirBhajan.value.length);

      } catch (e) {
        isLoading.value = false;
        print("Error in mandir bhajan: $e");
        mandirBhajan.value = []; // Clear data on error
        categoryData.value = null; // Clear category on error
      } finally {
        isLoading.value = false;
      }
    }

    // Future<void> handleRefresh() async {
    //     isLoading.value = true;
    //
    //   // Call your method to fetch data again or refresh the content
    //   await Future.wait([fetchBhajanData(), getAllCategoryData()]);
    //
    //   isLoading.value = false;
    // }


    // useEffect to trigger API call when the screen is rendered
    useEffect(() {
      getBhajanData();

      //audioManager = Provider.of<AudioPlayerManager>(context);

     // audioManager.playMusic(allcategorymodel.value[0]);


      return null; // Cleanup not required in this case
    }, []); // Empty dependency ensures it runs only once on screen load

  //      @override
  //  void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   audioManager = Provider.of<AudioPlayerManager>(context);
  // }



    var expandedBarHeight = MediaQuery.of(context).size.height * 0.62;
    var collapsedBarHeight = MediaQuery.of(context).size.height * 0.12;

    final selectedIndex = useState(0);
    final scrollController = useScrollController();
    final isCollapsed = useState(false);
    final didAddFeedback = useState(false);

    var screenWidth = MediaQuery.of(context).size.width;

   // List filteredCategories = subCategoryModel.where((cat) => cat.status != 0).toList();
   // List filteredCategories = mandirBhajan.value.where((cat) => cat.status!=0).toList();

    final List<Widget> tabs = [

      Tab(
        height: 25,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: selectedIndex.value == 0
                    ? Colors.transparent
                    : Colors.grey,
              )),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06, vertical: screenWidth * 0.009),
            child: Consumer<LanguageProvider>(
              builder: (BuildContext context, languageProvider, Widget? child) {
                return Text(
                  languageProvider.language == 'english' ? "All" : "सभी",
                  style: TextStyle(
                      fontSize: screenWidth * 0.03, fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
        ),
      ),


    //  ...filteredCategories.map((cat) {int index = filteredCategories.indexOf(cat) + 1;

      ...mandirBhajan.value.map((cat) {
        int index = mandirBhajan.value.indexOf(cat) + 1;
        return
         Tab(
          height: 25,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: selectedIndex.value == index
                      ? Colors.transparent
                      : Colors.grey,
                )),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: screenWidth * 0.009),
              child: Consumer<LanguageProvider>(
                builder: (BuildContext context, languageProvider, Widget? child) {
                  return Text(
                    languageProvider.language == 'english' ? cat.enName : cat.hiName,
                    style: TextStyle(
                        fontSize: screenWidth * 0.03, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
          ),
        );

      },)
    ];

    return Consumer<AudioPlayerManager>(
      builder: (BuildContext context, audioManager, Widget? child) {
        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            isCollapsed.value = scrollController.hasClients &&
                scrollController.offset >
                    (expandedBarHeight - collapsedBarHeight);
            if (isCollapsed.value && !didAddFeedback.value) {
              HapticFeedback.mediumImpact();
              didAddFeedback.value = true;
            } else if (!isCollapsed.value) {
              didAddFeedback.value = false;
            }
            return false;
          },
          child:  isLoading.value ? Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.orange,))) : DefaultTabController(
            length: mandirBhajan.value.length + 1,
            child: Stack(
              children: [

                BlurredBackdropImage(
                  audioManager: audioManager,
                ),

                NestedScrollView(
                  controller: scrollController,
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        expandedHeight: expandedBarHeight,
                        collapsedHeight: collapsedBarHeight,
                        centerTitle: false,
                        automaticallyImplyLeading: false,
                        pinned: true,
                        title: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: isCollapsed.value ? 1 : 0,
                            child: CollapsedAppBarContent(
                             audioManager: audioManager,
                             //musicData: bhajanDataList.value,
                             allcategorymodel: allcategorymodel.value,
                              selectedIndex: selectedIndex.value, // Cast to List<Sangeet>
                            )
                        ),
                        elevation: 0,
                        backgroundColor: isCollapsed.value
                            ? Colors.brown
                            : Colors.transparent,
                        flexibleSpace: FlexibleSpaceBar(
                          background: ExpandedAppBarContent(
                            audioManager: audioManager,
                           allcategorymodel: allcategorymodel.value,
                            musicData: bhajanDataList.value,
                           selectedIndex: selectedIndex.value, musicIndex: 0,
                          ),
                        ),
                        bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(80.0),
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              color: CustomColors.clrwhite,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: screenWidth * 0.05,
                                ),
                                Center(
                                  child: Consumer<LanguageProvider>(
                                    builder: (BuildContext context, languageProvider, Widget? child) {
                                      return Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.all_inclusive_outlined,
                                            size: screenWidth * 0.05,
                                            color: CustomColors.clrorange,
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.02,
                                          ),
                                          Text(
                                            languageProvider.language == 'english' ? "Divine Music of $godName" : "संगीत संग्रह $godNameHindi",
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.02,
                                          ),
                                          Icon(
                                            Icons.all_inclusive_outlined,
                                            size: screenWidth * 0.05,
                                            color: CustomColors.clrorange,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                TabBar(
                                  onTap: (index) {
                                    selectedIndex.value = index;
                                  },
                                  isScrollable: true,
                                  dividerColor: Colors.transparent,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.02),
                                  unselectedLabelColor: CustomColors.clrblack,
                                  labelColor: CustomColors.clrwhite,
                                  indicatorWeight: 0.1,
                                  tabAlignment: TabAlignment.start,
                                  indicator: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(5)),
                                  tabs: tabs,
                                ),
                                const Divider(),
                              ],
                            ),
                          ),
                        ),
                      )
                    ];
                  },
                  body: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [

                      // buildBhajanview(context, isLoading.value, true, false, allcategorymodel.value,
                      //    // bhajanDataList.value,
                      //     audioManager,0),

                      SangeetViewBhajan(0,isFixedTab: true,isAllTab: false,categoryId: categoryData.value!.id,),

                      ...mandirBhajan.value.map((cat) =>

                      // buildBhajanview(context, isLoading.value, false, true, allcategorymodel.value,
                      //    // bhajanDataList.value
                      //      audioManager,cat.id),

                       SangeetViewBhajan(cat.id,isAllTab: true,isFixedTab: false, categoryId: categoryData.value!.id,),)

                      // BhajanList(
                      //   subCategoryId,
                      //   subCategoryModel,
                      //   godName,
                      //   godNameHindi,
                      //   categoryId: categoryId,
                      //   isToggle: false,
                      //   isFixedTab: true,
                      //   isAllTab: false,
                      //   isMusicBarVisible: false,
                      // ),
                      // ...filteredCategories.map((cat) => BhajanList(
                      //   cat.id,
                      //   filteredCategories,
                      //   godName,
                      //   godNameHindi,
                      //   categoryId: categoryId,
                      //   isToggle: false,
                      //   isFixedTab: false,
                      //   isAllTab: true,
                      //   isMusicBarVisible: false,
                      // ))

                      ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

  }


  Widget buildBhajanview(BuildContext context,bool _isLoading,bool isFixedTab,bool isAllTab,List<Sangeet> allcategorymodel,AudioPlayerManager audioManager,int subId,) {
    var screenWidth = MediaQuery.of(context).size.width;

    List<Sangeet> bhajanDataList = [];

    Future<void> fetchBhajanData() async {
      String currentLanguage = context.read<LanguageProvider>().language;

      audioManager = Provider.of<AudioPlayerManager>(context);

      print(" My Current Selected Language Is $currentLanguage");

      // print("My category Id ${widget.categoryId}");
      //  print("My SubCategoryId ${widget.subCategoryId}");

      try {
        final musicListResponse = await ApiService().getData(
            "https://mahakal.rizrv.in/api/v1/bhagwan/bhagwan-sangeet?category_id=${1}&subcategory_id=${subId}&language=$currentLanguage"
          //'${AppConstants.baseUrl}/api/v1/sangeet/sangeet-details?subcategory_id=${widget.subCategoryId}&language=$currentLanguage',
        );

        print("My dynamic bhajan $musicListResponse");

        //  print(" My Coming Language is ${LanguageProvider.selectedLanguage}");
        if (musicListResponse != null) {
          final sangeetModel = BhajanModel.fromJson(musicListResponse);


          bhajanDataList.clear();
          bhajanDataList = sangeetModel.sangeet.where((item) => item.status == 1).toList();
          // audioManager.setPlaylist(bhajanDataList);
          _isLoading = false;

          print(bhajanDataList.length);

        } else {
          print("Error: The response is null or improperly formatted.");

          _isLoading = false;
        }
      } catch (error) {
        print("Failed to fetch music data: $error");
        _isLoading = false;
        //_noData = true;
      }
    }

    void playMusic(int index) {
    Sangeet? selectedMusic;

    if (isFixedTab) {
      // Assuming allcategorymodel contains Sangeet objects
      selectedMusic = allcategorymodel[index];
    } else if (isAllTab) {
      selectedMusic = bhajanDataList[index];
    }
    // else {
    //   // Assuming subCategoryModel contains Sangeet objects
    //   selectedMusic = widget.subCategoryModel[index];
    // }

    audioManager.playMusic(selectedMusic!).then((_) {
        //_isMusicBarVisible = widget.isToggle;
    }).catchError((error) {
      print('Error playing music: $error');
    });
  }


    Widget _buildMusicList() {
      final screenHeight = MediaQuery.of(context).size.height;
      final screenWidth = MediaQuery.of(context).size.width;

      if (_isLoading) {
        // Show loading indicator
        return Center(child: CircularProgressIndicator());
      }

      // Check if there's data in the relevant lists based on the tab type
      bool hasData;
      if (isFixedTab) {
        hasData = allcategorymodel.isNotEmpty;
        print("Fixed Tab - Data Available: $hasData, Count: ${allcategorymodel.length}");
      } else if (isAllTab) {
        hasData = bhajanDataList.isNotEmpty;
        print("All Tab - Data Available: $hasData, Count: ${bhajanDataList.length}");
      }
      // else {
      //   hasData = widget.subCategoryModel.isNotEmpty; // For other tab types
      //   print("Subcategory Tab - Data Available: $hasData, Count: ${widget.subCategoryModel.length}");
      // }

      // If no data is available, show the "No Data Here" message
      // if (!hasData) {
      //   return Center(child: Text("No Data Here"));
      // }

      // Display the list if there is data
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: isFixedTab
            ? allcategorymodel.length : bhajanDataList.length,
        // : widget.isAllTab
        // ? bhajanDataList.length
        //  : widget.subCategoryModel.length,
        padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
        itemBuilder: (context, index) {
          final itemData = isFixedTab
              ? allcategorymodel[index] : bhajanDataList[index];
          // : widget.isAllTab
          // ? bhajanDataList[index]
          // : widget.subCategoryModel[index];

          return InkWell(
            onTap: () => playMusic(index),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenWidth * 0.01,
                horizontal: screenWidth * 0.04,
              ),
              child: Row(
                children: [
                  // Show the image with a play indicator if the music is currently playing
                  audioManager.currentMusic != null &&
                      audioManager.isPlaying &&
                      audioManager.currentMusic!.id == itemData.id
                      ? Container(
                    height: screenHeight * 0.05,
                    width: screenWidth * 0.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      image: DecorationImage(
                        image: NetworkImage(itemData.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: const Image(
                        image: NetworkImage(
                          "https://cdn.pixabay.com/animation/2023/10/22/03/31/03-31-40-761_512.gif",
                        ),
                        color: Colors.white,
                      ),
                    ),
                  )
                      : Container(
                    height: screenHeight * 0.05,
                    width: screenWidth * 0.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      image: DecorationImage(
                        image: NetworkImage(itemData.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.4,
                          child: Text(
                            itemData.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.04,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.3,
                          child: Text(
                            itemData.singerName,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth * 0.03,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.offline_share_sharp,
                      color: Colors.orange,
                      size: screenWidth * 0.06,
                    ),
                    onPressed: () {
                      // shareMusic.shareSong(itemData);
                    },
                  ),
                  GestureDetector(
                    // onTap: () => _showBottomSheet(index),
                    child: Icon(
                      Icons.more_vert_rounded,
                      color: Colors.orange,
                      size: screenWidth * 0.07,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return
      Consumer<AudioPlayerManager>(
        builder: (context, audioManager, child) {
          return Scaffold(
            backgroundColor: CustomColors.clrwhite,
            body: Stack(
              children: [
                _isLoading
                    ? const Center(
                     child: CircularProgressIndicator(
                     color: CustomColors.clrblack,
                  ),
                )
                :
                _buildMusicList(),
                // Music bar logic remains the same
                //  if (_isMusicBarVisible && audioManager.currentMusic != null)
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: AnimatedContainer(
                //     duration: const Duration(milliseconds: 100),
                //     height: screenWidth * 0.19,
                //     color: Colors.brown,
                //     child: GestureDetector(
                //       onTap: () {
                //         Navigator.push(
                //           context,
                //           PageRouteBuilder(
                //             pageBuilder: (context, animation, secondaryAnimation) =>
                //                 MusicPlayer(
                //                   widget.godNameHindi,
                //                   musicData: bhajanDataList,
                //                   categoryId: widget.categoryId,
                //                   subCategoryId: widget.subCategoryId,
                //                   allcategorymodel: allcategorymodel,
                //                   MyCurrentIndex: audioManager.currentIndex,
                //                   subCategoryModel: widget.subCategoryModel,
                //                   godName: widget.godName,
                //                 ),
                //             transitionsBuilder: (context, animation, secondaryAnimation, child) {
                //               const begin = Offset(0.0, 1.0);
                //               const end = Offset.zero;
                //               const curve = Curves.easeInOutCirc;
                //               var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                //               return SlideTransition(
                //                 position: animation.drive(tween),
                //                 child: child,
                //               );
                //             },
                //             transitionDuration: const Duration(milliseconds: 1000),
                //           ),
                //         );
                //       },
                //       child: FractionallySizedBox(
                //         heightFactor: 1.2,
                //         widthFactor: 1.0,
                //         child: Padding(
                //           padding: EdgeInsets.symmetric(
                //             vertical: screenWidth * 0.02,
                //             horizontal: screenWidth * 0.02,
                //           ),
                //           child: Column(
                //             children: [
                //               Row(
                //                 crossAxisAlignment: CrossAxisAlignment.center,
                //                 children: [
                //                   Container(
                //                     width: screenWidth * 0.09,
                //                     height: screenWidth * 0.09,
                //                     decoration: BoxDecoration(
                //                       image: DecorationImage(
                //                         image: NetworkImage(
                //                           audioManager.currentMusic!.image,
                //                         ),
                //                         fit: BoxFit.cover,
                //                       ),
                //                       borderRadius: BorderRadius.circular(10),
                //                     ),
                //                   ),
                //                   Expanded(
                //                     child: Padding(
                //                       padding: EdgeInsets.only(
                //                         top: screenWidth * 0.02,
                //                         left: screenWidth * 0.02,
                //                       ),
                //                       child: Column(
                //                         crossAxisAlignment: CrossAxisAlignment.start,
                //                         children: [
                //                           SizedBox(
                //                             width: screenWidth * 0.5,
                //                             child: Text(
                //                               audioManager.currentMusic?.title ?? '',
                //                               style: const TextStyle(
                //                                 color: Colors.white,
                //                                 fontWeight: FontWeight.bold,
                //                                 overflow: TextOverflow.ellipsis,
                //                               ),
                //                               maxLines: 1,
                //                             ),
                //                           ),
                //                           SizedBox(
                //                             width: screenWidth * 0.5,
                //                             child: Text(
                //                               audioManager.currentMusic?.singerName ?? '',
                //                               style: const TextStyle(
                //                                 color: Colors.white,
                //                                 fontWeight: FontWeight.bold,
                //                                 overflow: TextOverflow.ellipsis,
                //                               ),
                //                               maxLines: 1,
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ),
                //                   ),
                //                   Row(
                //                     children: [
                //                       IconButton(
                //                         onPressed: () {
                //                           if (audioManager.isPlaying) {
                //                             if (widget.isFixedTab && allcategorymodel.isNotEmpty) {
                //                               int currentIndex = allcategorymodel.indexOf(audioManager.currentMusic!);
                //                               if (currentIndex > 0) {
                //                                 audioManager.playMusic(allcategorymodel[currentIndex - 1]);
                //                               } else {
                //                                 audioManager.playMusic(allcategorymodel.last);
                //                               }
                //                             } else {
                //                               audioManager.skipPrevious();
                //                             }
                //                           }
                //                         },
                //                         icon: Icon(
                //                           Icons.skip_previous,
                //                           color: Colors.white,
                //                           size: screenWidth * 0.08,
                //                         ),
                //                       ),
                //                       GestureDetector(
                //                         onTap: () => audioManager.togglePlayPause(),
                //                         child: Icon(
                //                           audioManager.isPlaying ? Icons.pause_circle : Icons.play_circle,
                //                           size: screenWidth * 0.08,
                //                           color: CustomColors.clrwhite,
                //                         ),
                //                       ),
                //                       IconButton(
                //                         onPressed: () {
                //                           if (audioManager.isPlaying) {
                //                             if (widget.isFixedTab && allcategorymodel.isNotEmpty) {
                //                               int currentIndex = allcategorymodel.indexOf(audioManager.currentMusic!);
                //                               if (currentIndex < allcategorymodel.length - 1) {
                //                                 audioManager.playMusic(allcategorymodel[currentIndex + 1]);
                //                               } else {
                //                                 audioManager.playMusic(allcategorymodel.first);
                //                               }
                //                             } else {
                //                               audioManager.skipNext();
                //                             }
                //                           }
                //                         },
                //                         icon: Icon(
                //                           Icons.skip_next,
                //                           color: Colors.white,
                //                           size: screenWidth * 0.08,
                //                         ),
                //                       ),
                //                       IconButton(
                //                         onPressed: () {
                //                           audioManager.stopMusic();
                //                           setState(() {
                //                             _isMusicBarVisible = false;
                //                           });
                //                         },
                //                         icon: Icon(
                //                           Icons.cancel,
                //                           color: Colors.white,
                //                           size: screenWidth * 0.08,
                //                         ),
                //                       ),
                //                       Icon(
                //                         Icons.keyboard_arrow_up,
                //                         color: Colors.white,
                //                         size: screenWidth * 0.08,
                //                       ),
                //                     ],
                //                   ),
                //                 ],
                //               ),
                //               Padding(
                //                 padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
                //                 child: Container(
                //                   height: 5,
                //                   width: double.infinity,
                //                   child: SliderTheme(
                //                     data: SliderThemeData(
                //                       activeTrackColor: CustomColors.clrwhite,
                //                       inactiveTrackColor: CustomColors.clrwhite.withOpacity(0.5),
                //                       trackHeight: 1.7,
                //                     ),
                //                     child: Slider(
                //                       min: 0.0,
                //                       max: audioManager.duration?.inSeconds.toDouble() ?? 1.0,
                //                       value: audioManager.currentPosition.inSeconds.toDouble().clamp(0.0, audioManager.duration?.inSeconds.toDouble() ?? 1.0),
                //                       onChanged: (double value) {
                //                         audioManager.seekTo(Duration(seconds: value.toInt()));
                //                       },
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          );
        },
      );
  }

}

class CollapsedAppBarContent extends StatefulWidget {

  final AudioPlayerManager audioManager;
  final List<Sangeet> allcategorymodel;
 // final List musicData;
  final int selectedIndex;

  const CollapsedAppBarContent(
     {
   required this.audioManager,
 //  required this.musicData,
   required this.allcategorymodel,
   required this.selectedIndex,
     }
  );

  @override
  State<CollapsedAppBarContent> createState() => _CollapsedAppBarContentState();
}

class _CollapsedAppBarContentState extends State<CollapsedAppBarContent> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Consumer<AudioPlayerManager>(
      builder: (BuildContext context, audioManager, Widget? child) {
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.01, vertical: screenWidth * 0.08),
          child: Column(
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  height: screenHeight * 0.05,
                  width: screenWidth * 0.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    image: DecorationImage(
                      image: NetworkImage(
                          audioManager.currentMusic?.image ??
                              'default_image_url'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.05,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.40,
                      child: Text(
                        audioManager.currentMusic?.title ??
                            'No Title',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.04,
                            overflow: TextOverflow.ellipsis,
                            color: CustomColors.clrwhite),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(

                      width: screenWidth * 0.3,
                      child: Text(
                       audioManager.currentMusic?.singerName ??
                            'No Singer',
                        style: TextStyle(
                            color: CustomColors.clrwhite,
                            fontSize: screenWidth * 0.03,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),

                // SizedBox(width: screenWidth * 0.01,),
                Row(
                  children: [
                    // Skip Previous Button
                    GestureDetector(
                      onTap: () {

                        if (audioManager != null) {
                          if (widget.selectedIndex == 0) {
                            // Fixed tab logic
                            Sangeet? currentMusic = audioManager.currentMusic;

                            if (currentMusic != null) {
                              int currentIndex =
                              widget.allcategorymodel.indexOf(currentMusic);

                              if (currentIndex != -1) {
                                if (currentIndex > 0) {
                                  // Play the previous song
                                  audioManager.playMusic(
                                      widget.allcategorymodel[currentIndex - 1]);
                                } else {
                                  // Loop back to the last song
                                  audioManager.playMusic(widget.allcategorymodel.last);
                                }
                              } else {
                                // Handle case where currentMusic is not in the list
                                if (widget.allcategorymodel.isNotEmpty) {
                                  audioManager.playMusic(widget.allcategorymodel.last);
                                } else {
                                  print("No music available in the list");
                                }
                              }
                            } else {
                              // Handle case where currentMusic is null
                              if (widget.allcategorymodel.isNotEmpty) {
                                audioManager.playMusic(widget.allcategorymodel.last);
                              } else {
                                print("No music available in the list");
                              }
                            }
                          } else {
                            // Dynamic tab logic
                            audioManager.skipPrevious(); // Skip to previous song in the dynamic list
                          }
                        }

                      },
                      child: Icon(
                        Icons.skip_previous,
                        color: CustomColors.clrwhite,
                        size: screenWidth * 0.08,
                      ),
                    ),

                    SizedBox(
                      width: screenWidth * 0.05,
                    ),
                  //  Toggle Play/Pause Button
                    GestureDetector(
                      onTap: () => audioManager.togglePlayPause(),
                      child: Icon(
                        audioManager.isPlaying
                            ? Icons.pause_circle
                            : Icons.play_circle,
                        size: screenWidth * 0.08,
                        color: CustomColors.clrwhite,
                      ),
                    ),

                    SizedBox(
                      width: screenWidth * 0.05,
                    ),
                    // Skip Next Button
                    GestureDetector(
                      onTap: () {

                        if (audioManager != null) {
                          if (widget.selectedIndex == 0) {
                            // Fixed tab logic
                            Sangeet? currentMusic = audioManager.currentMusic;

                            if (currentMusic != null) {
                              int currentIndex =
                              widget.allcategorymodel.indexOf(currentMusic);

                              if (currentIndex != -1) {
                                if (currentIndex < widget.allcategorymodel.length - 1) {
                                  // Play the next song
                                  audioManager.playMusic(
                                      widget.allcategorymodel[currentIndex + 1]);
                                } else {
                                  // Loop back to the first song
                                  audioManager.playMusic(widget.allcategorymodel.first);
                                }
                              } else {
                                // Handle case where currentMusic is not in the list
                                if (widget.allcategorymodel.isNotEmpty) {
                                  audioManager.playMusic(widget.allcategorymodel.first);
                                } else {
                                  print("No music available in the list");
                                }
                              }
                            } else {
                              // Handle case where currentMusic is null
                              if (widget.allcategorymodel.isNotEmpty) {
                                audioManager.playMusic(widget.allcategorymodel.first);
                              } else {
                                print("No music available in the list");
                              }
                            }
                          } else {
                            // Dynamic tab logic
                            audioManager
                                .skipNext(); // Skip to next song in the dynamic list
                          }
                        }
                      },
                      child: Icon(
                        Icons.skip_next,
                        color: CustomColors.clrwhite,
                        size: screenWidth * 0.08,
                      ),
                    ),
                  ],
                )
              ]),
            ],
          ),
        );
      },
    );
  }
}

class BlurredBackdropImage extends StatelessWidget {
  final AudioPlayerManager audioManager;

  const BlurredBackdropImage({required this.audioManager,});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: audioManager, // Listen for changes in the AudioPlayerManager
      builder: (context, child) {
        return SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 1.5,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // The background image
              Image.network(
                audioManager.currentMusic?.image ?? 'https://thumbs.dreamstime.com/b/no-thumbnail-image-placeholder-forums-blogs-websites-148010362.jpg',
                fit: BoxFit.cover,
              ),
              // The blur effect
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                child: Container(
                  color: Colors.black.withOpacity(0), // Transparent container
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ExpandedAppBarContent extends StatefulWidget {
 final AudioPlayerManager audioManager;
 final List<Sangeet> allcategorymodel;
 final List<Sangeet> musicData;
 final int selectedIndex;
 final int musicIndex;

  const ExpandedAppBarContent(
      {
       required this.audioManager,
       required this.allcategorymodel,
       required this.musicData,
       required this.selectedIndex, required this.musicIndex
    }
     );

  @override
  State<ExpandedAppBarContent> createState() => _ExpandedAppBarContentState();
}

class _ExpandedAppBarContentState extends State<ExpandedAppBarContent> {
  String formatDuration(Duration? duration) {
    if (duration == null) return '00:00';
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  final shareMusic = ShareMusic();

  void _showShuffleOptionsDialog(BuildContext context,
      AudioPlayerManager audioManager) {
    showDialog(
      context: context,
      builder: (context) {

        return ShuffleOptionsDialog(
          audioManager: audioManager,
        );
      },
    );
  }

  void playMusic(int index) {
    if (widget.audioManager != null) {
      Sangeet selectedMusic;
      if (widget.selectedIndex == 0) {
        selectedMusic = widget.allcategorymodel[index];
      } else {
        selectedMusic = widget.musicData[index];
      }
      widget.audioManager.playMusic(selectedMusic);
    }
  }

  @override
  void initState() {
   var allCategoryModel = widget.allcategorymodel;
   print(allCategoryModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Consumer<AudioPlayerManager>(
      builder: (BuildContext context, audiomanager, Widget? child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
          child:

          Consumer<FavouriteProvider>(
            builder: (BuildContext context, favouriteProvider, Widget? child) {

              Sangeet? currentMusic = audiomanager.currentMusic;

              if (currentMusic != null) {
                final isFavourite = favouriteProvider.favouriteBhajan.any((favourite) => favourite!.audio == currentMusic.audio);

                return
          Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenWidth * 0.17),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              child: Padding(
                                padding: EdgeInsets.all(screenWidth * 0.01),
                                child: Column(
                                  children: [
                                    Icon(Icons.arrow_back_ios_rounded, size: screenWidth * 0.06, color: Colors.white),
                                    const Text("Back", style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.53),
                          GestureDetector(
                            onTap: () {
                              shareMusic.shareSong(audiomanager.currentMusic!);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(screenWidth * 0.01),
                              child: const Column(
                                children: [
                                  Icon(Icons.share, color: Colors.white),
                                  Text("Share", style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.05, width: screenWidth * 0.05),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Lyricsbhajan(
                                      musicLyrics: audiomanager.currentMusic!.lyrics,
                                      musicName: audiomanager.currentMusic!.title),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.all(screenWidth * 0.01),
                              child: const Column(
                                children: [
                                  Icon(Icons.article,color: Colors.white,),
                                  //ImageIcon(AssetImage("assets/image/lyrics.png"), color: Colors.white),
                                  Text("Lyrics", style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.22),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            width: screenWidth * 0.6,
                            child: Text(
                              audiomanager.currentMusic?.title ??
                                  'No Title',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: screenWidth * 0.06,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.clrwhite,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.4,
                            child: Text(
                              audiomanager.currentMusic?.singerName ??
                                  'No Singer',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                color: CustomColors.clrwhite,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Additional widget content here...


                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: CustomColors.clrwhite,
                        trackHeight: 1.5,
                        trackShape: const RectangularSliderTrackShape(),
                        inactiveTrackColor: CustomColors.clrwhite.withOpacity(0.5),
                        thumbColor: CustomColors.clrwhite,
                        overlayColor: CustomColors.clrwhite.withOpacity(0.7),
                        valueIndicatorColor: CustomColors.clrwhite,
                      ),
                      child: Slider(
                        min: 0.0,
                        max: audiomanager.duration.inSeconds.toDouble(),
                        value: audiomanager.currentPosition.inSeconds.toDouble(),
                        onChanged: (double value) {
                          audiomanager.seekTo(Duration(seconds: value.toInt()));
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Text(
                              formatDuration(audiomanager.currentPosition),
                              style: TextStyle(
                                  color: CustomColors.clrwhite,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width * 0.04),
                              maxLines: 1,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            formatDuration(audiomanager.duration),
                            style: TextStyle(
                                color: CustomColors.clrwhite,
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width * 0.04),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () =>
                                  _showShuffleOptionsDialog(context, audiomanager),
                              child: Icon(Icons.shuffle,
                                  size: screenWidth * 0.08,
                                  color: CustomColors.clrwhite)),
                          SizedBox(width: screenHeight * 0.07),

                          GestureDetector(
                            onTap: () {
                              if (widget.selectedIndex == 0) {
                                print("My Index is ${widget.selectedIndex}");
                                // Fixed tab logic for skip previous
                                int currentIndex = widget.allcategorymodel
                                    .indexOf(audiomanager.currentMusic!);
                                if (currentIndex > 0) {
                                  playMusic(currentIndex - 1);
                                } else {
                                  playMusic(widget.allcategorymodel.length -
                                      1); // Loop back to the last song
                                }
                              } else {
                                print("My dynamic index ${widget.selectedIndex}");
                                audiomanager.skipPrevious(); // Assuming you have a skipPrevious method in your audioManager
                              }
                            },
                            child: Icon(Icons.skip_previous,
                                size: screenWidth * 0.1,
                                color: CustomColors.clrwhite),
                          ),

                          SizedBox(width: screenWidth * 0.06),
                          GestureDetector(
                            onTap: () => audiomanager.togglePlayPause(),
                            child: Icon(
                              audiomanager.isPlaying
                                  ? Icons.pause_circle
                                  : Icons.play_circle,
                              size: screenHeight * 0.07,
                              color: CustomColors.clrwhite,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.06),

                          GestureDetector(
                            onTap: () {
                              if (widget.selectedIndex == 0) {
                                print("My Index is ${widget.selectedIndex}");
                                // Fixed tab logic for skip next
                                int currentIndex = widget.allcategorymodel
                                    .indexOf(audiomanager.currentMusic!);

                                print(" My real Current Index is ${currentIndex}");

                                if (currentIndex <
                                    widget.allcategorymodel.length - 1) {
                                  playMusic(currentIndex + 1);
                                } else {
                                  playMusic(0); // Loop back to the first song
                                }
                              } else {
                                print("My dynamic index ${widget.selectedIndex}");
                                audiomanager
                                    .skipNext(); // Assuming you have a skipNext method in your audioManager
                              }
                            },
                            child: Icon(Icons.skip_next,
                                size: screenWidth * 0.1,
                                color: CustomColors.clrwhite),
                          ),

                          Spacer(),

                          GestureDetector(
                            onTap: () {

                             // favouriteProvider.toggleBookmark(currentMusic!);
                              print("Added to favourite");

                            },
                            child: Icon(
                              isFavourite ? Icons.favorite : Icons.favorite_border_sharp,
                              size: screenWidth * 0.08,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
             }
              else {
                // Handle the case when currentMusic is null
                return const Center(child: CircularProgressIndicator(color: Colors.orange,));
              }
            },
          ),
        );
      },
    );
  }
}

class ShuffleOptionsDialog extends StatefulWidget {
  final AudioPlayerManager audioManager;

  const ShuffleOptionsDialog({
    required this.audioManager,
  });

  @override
  _ShuffleOptionsDialogState createState() => _ShuffleOptionsDialogState();
}

class _ShuffleOptionsDialogState extends State<ShuffleOptionsDialog> {
  int _currentSelectedIndex = 0;

  List<int> indexSelected = [
    0,1,2
  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedIndex();
  }

  _loadSelectedIndex() async {
    final prefs = await SharedPreferences.getInstance();
    int selectedIndex = prefs.getInt('selectedIndex') ?? 0;
    setState(() {
      _currentSelectedIndex = selectedIndex;
    });
  }

  _saveSelectedIndex(int index) async {
   final prefs = await SharedPreferences.getInstance();
   prefs.setInt('selectedIndex', index);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return BottomSheet(onClosing: () {

    }, builder: (context) {
      return Container(
        height: 210,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05,vertical: screenWidth * 0.02),
          child: Column(
            children: [

              Text(
                'How to listen to Bhajan or Arti?',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CustomColors.clrblack,
                    fontSize: screenWidth * 0.05),
              ),

              const Divider(),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.fiber_smart_record_outlined,
                          color: CustomColors.clrorange, size: screenWidth * 0.05),
                      SizedBox(width: screenWidth * 0.05),
                      Text('Play Next',
                          style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.clrblack)),
                      const Spacer(),
                      Radio<int>(
                        value: indexSelected[0],
                        groupValue: _currentSelectedIndex,
                        activeColor: CustomColors.clrorange,
                        onChanged: (int? value) {
                          setState(() {
                            _currentSelectedIndex = value!;
                          });
                          _saveSelectedIndex(value!);
                          widget.audioManager.setShuffleMode(ShuffleMode.playNext);
                          // Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.looks_one_outlined,
                          color: CustomColors.clrorange, size: screenWidth * 0.05),
                      SizedBox(width: screenWidth * 0.05),
                      Text('Play Once and Close',
                          style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.clrblack)),
                      const Spacer(),
                      Radio<int>(
                        value: indexSelected[1],
                        groupValue: _currentSelectedIndex,
                        activeColor: CustomColors.clrorange,
                        onChanged: (int? value) {
                          setState(() {
                            _currentSelectedIndex = value!;
                          });
                          _saveSelectedIndex(value!);
                          widget.audioManager
                              .setShuffleMode(ShuffleMode.playOnceAndClose);
                          // Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Row(
                      children: [
                        Icon(Icons.loop,
                            color: CustomColors.clrorange, size: screenWidth * 0.05),
                        SizedBox(width: screenWidth * 0.05),
                        Text('Play on Loop',
                            style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.clrblack)),
                        Spacer(),
                        Radio<int>(
                          value: indexSelected[2],
                          groupValue: _currentSelectedIndex,
                          activeColor: CustomColors.clrorange,
                          onChanged: (int? value) {
                            setState(() {
                              _currentSelectedIndex = value!;
                            });
                            _saveSelectedIndex(value!);
                            widget.audioManager.setShuffleMode(ShuffleMode.playOnLoop);
                            //  Navigator.pop(context);
                          },
                        ),
                      ]),
                ],
              ),
            ],
          ),
        ),
      );
    },);
  }
}


