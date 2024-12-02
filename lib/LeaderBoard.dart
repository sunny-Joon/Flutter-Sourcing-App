import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/Models/leaderboardModel.dart';
import 'package:gif/gif.dart';
import 'ApiService.dart';
import 'GlobalClass.dart';
import 'const/appcolors.dart';

class LeaderBoard extends StatefulWidget {
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> with TickerProviderStateMixin {

  late List<LeaderboardDataModel> leaderboardDataModel=[];

  AppColors appColors = new AppColors();
  int _current = 0;
  late GifController _controllerGif;
  int isLoading = 1;
  //final CarouselController _controller = CarouselController();
  @override
  void initState() {
    super.initState();
    _controllerGif = GifController(vsync: this);
    _getLeaderBoardData(context);

  }

  @override
  void dispose() {
    _controllerGif.dispose();
    super.dispose();
  }

/*  final List<String> imgList = [
    "assets/images/banner3.gif",
    "assets/images/banner2.gif",
  ];*/
  Widget buildDot({required int index}) {
    return Container(
      width: 7,
      height: 7,
      margin: EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _current == index ? Colors.white : Colors.grey,
      ),
    );
  }

  Future<void> _getLeaderBoardData(BuildContext contextDialog) async {
    EasyLoading.show(status: "Loading...");

    final api = ApiService.create(baseUrl: ApiConfig.baseUrl1);

    return await api
        .leaderboardList(GlobalClass.token, GlobalClass.dbName, "1",
            "2024-10-20", "2024-11-20")
        .then((value) {
      if (value.statuscode == 200) {
        setState(() {
          leaderboardDataModel = value.data;
        });
        print("lll$leaderboardDataModel.length");
        EasyLoading.dismiss();
      } else {}
      EasyLoading.dismiss();
    }).catchError((err) {
      EasyLoading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.mainAppColor,
      body:SingleChildScrollView(child:  Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8,right: 8,top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  child: Container(
                    // decoration: BoxDecoration(
                    //   color: Colors.white,
                    //   border: Border.all(width: 1, color: Colors.grey.shade300),
                    //   borderRadius: BorderRadius.all(Radius.circular(5)),
                    // ),
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    // child: Center(
                    //   child: Icon(Icons.arrow_back_ios_sharp, size: 16),
                    // ),
                  ),
                  onTap: () {
                   // Navigator.of(context).pop();
                  },
                ),
                Column(
                  children: [
                    Text(
                      "ALL INDIA",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Visbycfbold',
                          fontSize: 16),
                    ),
                    Text(
                      "LEADER BOARD",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Visbycfbold',
                          fontSize: 14),
                    ),
                  ],
                ),
                /*Center(
                  child: Image.asset(
                    'assets/Images/logo_white.png', // Replace with your logo asset path
                    height: 40,
                  ),
                ),*/
                Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white38,
              borderRadius: BorderRadius.circular(50.0),
            ),
            alignment: Alignment.center,
            width: 80,
            height: 80,
            child:
            Image.asset('assets/Images/trophy_ic.png'),
          ),
          /*Container(
            child: Gif(
              fit: BoxFit.fitWidth,
              image: AssetImage("assets/images/render.gif"),
              controller:
                  _controllerGif, // if duration and fps is null, original gif fps will be used.
              //fps: 30,
              //duration: const Duration(seconds: 3),
              autostart: Autostart.no,
              onFetchCompleted: () {
                _controllerGif.reset();
                _controllerGif.forward();
              },
            ),
          ),*/
          Column(
            children: [
              /*Container(
                decoration: BoxDecoration(),
                child: Column(
                  children: [
                   */
              /* SizedBox(
                      height: MediaQuery.of(context).size.height / 20,
                    ),
                    Text(
                      "ALL INDIA",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Visbycfbold',
                          fontSize: 16),
                    ),
                    Text(
                      "LEADER BOARD",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Visbycfbold',
                          fontSize: 14),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 50),
                    *//**//*CarouselSlider.builder(
                      itemCount:
                          2, // Replace '3' with the total number of items
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: SizedBox(
                              // Adjust the width as needed// Adjust the height as needed
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Image.asset(
                                  imgList
                                      .elementAt(index)
                                      .toString(), // Replace with your image URL
                                  fit: BoxFit
                                      .cover, // Adjust the fit as needed (contain, cover, fill, etc.)
                                ),
                              ),
                            ));
                      },
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height /
                            7, // Adjust the height as needed
                        viewportFraction:
                            1.0, // Set to 1.0 to display only one item at a time
                        enableInfiniteScroll:
                            true, // Enable infinite scroll if needed
                        reverse:
                            false, // Set true/false for reversing the items
                        autoPlay: true, // Set true/false for autoplay
                        autoPlayInterval: Duration(
                            seconds: 10), // Autoplay interval if needed
                        autoPlayAnimationDuration: Duration(
                            milliseconds: 3000), // Autoplay animation duration
                        pauseAutoPlayOnTouch: false,
                        // Pause autoplay on touch

                        onPageChanged: (index, reason) {
                          *//**//*
                    *//**//*  setState(() {
                            print("page index $index");
                            _current = index;
                          });*//**//*
                    *//**//*
                        },
                      ),
                    ),*//**/
              /*
                    SizedBox(height: MediaQuery.of(context).size.height / 48),
                    *//**/
              /*Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        2, // Replace '3' with the total number of items
                        (index) => buildDot(index: index),
                      ),
                    ),*//**/
              /*
                    SizedBox(height: MediaQuery.of(context).size.height / 35),*/
              /*
                  ],
                ),
              ),*/
              /* isLoading != 0
                  ? isLoading == 1
                      ?*/
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height / 1.4,
                      child: null),
                  Positioned(
                    // top: 40,
                    child: Container(
                      color: appColors.mainAppColor,
                      alignment: Alignment.bottomCenter,
                      width: MediaQuery.of(context).size.width / 1.1,
                      height:
                      MediaQuery.of(context).size.height / 1.6,
                      child: Container(
                        margin: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/Images/curvedBackground.png'), // Replace with the actual image path
                            fit: BoxFit.fill,
                          ),
                        ),
                        padding: EdgeInsets.only(
                            top: 65, left: 10, right: 10, bottom: 60),
                        //  margin: EdgeInsets.only(top: 30,left: 10,right: 10),
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.builder(
                            itemCount: leaderboardDataModel.length,
                            itemBuilder: (context, index) {
                              final item = leaderboardDataModel[index];
                              final bool isFirstItem = index == 0;

                              return Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 25.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Card(
                                          clipBehavior:
                                          Clip.antiAlias,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: appColors
                                                  .mainAppColor,
                                              gradient: isFirstItem
                                                  ? const LinearGradient(
                                                colors: [
                                                  Colors.yellow,
                                                  Colors
                                                      .orangeAccent,
                                                  Colors.yellow,
                                                  Colors.orange,
                                                  Colors.orange
                                                ], // Define your gradient colors
                                                begin: Alignment
                                                    .topLeft,
                                                end: Alignment
                                                    .bottomCenter,
                                              )
                                                  : null, // No gradient for other items
                                            ),
                                            height: 20,
                                            width: 20,
                                            child: Center(
                                              child: Text(
                                                '${index + 1}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          width:
                                          MediaQuery.of(context)
                                              .size
                                              .width /
                                              3,
                                          child: Flexible(child: Text(
                                            item.name,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xFFD42D3F),
                                              fontWeight: isFirstItem
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),),

                                        ),
                                      ],
                                    ),
                                    Flexible(
                                      child: Text(
                                        item.totalDisbursementAmt,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFFD42D3F),
                                          /*decorationThickness: 1,
                                                    decoration: TextDecoration.underline,*/
                                          decorationColor: Color(0xFFD42D3F),
                                          fontWeight: isFirstItem ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    )

                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 38,
                    child: Text(
                      'Last Month Achievers',
                      style: TextStyle(
                          color: appColors.mainAppColor,
                          fontSize: 16,
                          fontFamily: 'Visbyfregular'),
                    ),
                  ),
                ],
              )
              /*: Container()
                  : CircularProgressIndicator(
                      color: appColors.white,
                    ),*/
            ],
          ),
        ],
      )),
    );
  }
}
