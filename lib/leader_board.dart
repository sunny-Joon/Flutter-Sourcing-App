import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'Models/leader_board_model.dart';
import 'api_service.dart';
import 'const/appcolors.dart';
import 'global_class.dart';

class LeaderBoard extends StatefulWidget {
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  int _current=0;
  late List<LeaderboardDataModel> leaderboardDataModel = [];
  AppColors appColors = AppColors();
  String selectedPeriod = "January";
  bool isDataAvailable = true;
  String errorMessage = '';

  final List<String> imgList = [
    "assets/Images/confeeti.gif",
  ];

  List<String> dropdownOptions = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  @override
  void initState() {
    super.initState();
    _getLeaderBoardDataForPeriod(selectedPeriod); // Fetch initial data for January
  }

  // Fetch leaderboard data for the selected period
  Future<void> _getLeaderBoardDataForPeriod(String period) async {
    EasyLoading.show(status: "Loading...");
    final api = ApiService.create(baseUrl: ApiConfig.baseUrl1);

    String startDate = getStartDateForPeriod(period);
    String endDate = getEndDateForPeriod(period);

    try {
      var response = await api
          .leaderboardList(GlobalClass.token, GlobalClass.dbName, "1", startDate, endDate);

      if (response.statuscode == 200) {
        if (response.data.isNotEmpty) {
          setState(() {
            leaderboardDataModel = response.data;
            isDataAvailable = true;
            errorMessage = '';
          });
        } else {
          setState(() {
            leaderboardDataModel.clear();
            isDataAvailable = false;
            errorMessage = 'No data available for $selectedPeriod.';
          });
        }
      } else {
        setState(() {
          leaderboardDataModel.clear();
          isDataAvailable = false;
          errorMessage = 'No data available for $selectedPeriod'; // Error if statuscode is not 200
        });
      }
    } catch (err) {
      setState(() {
        leaderboardDataModel.clear();
        isDataAvailable = false;
        errorMessage = 'An error occurred for $selectedPeriod'; // Error if there’s any failure during the request
      });
    } finally {
      EasyLoading.dismiss();
    }
  }

  String getStartDateForPeriod(String period) {
    DateTime now = DateTime.now();
    int month = dropdownOptions.indexOf(period) + 1;
    return DateTime(now.year, month, 1).toIso8601String().split('T')[0];
  }

  String getEndDateForPeriod(String period) {
    DateTime now = DateTime.now();
    int month = dropdownOptions.indexOf(period) + 1;
    DateTime firstDayNextMonth = DateTime(now.year, month + 1, 1);
    DateTime lastDayOfThisMonth = firstDayNextMonth.subtract(Duration(days: 1));
    return lastDayOfThisMonth.toIso8601String().split('T')[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.mainAppColor,
      body: Stack(
        children: [
          // GIF background
          Positioned.fill(
            child: Image.asset(
              imgList[0],  // Use the first image in the list (GIF)
              fit: BoxFit.cover,  // Make sure it covers the entire screen
            ),
          ),
          // The rest of the content
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        child: Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.center,
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
                              fontFamily: "Poppins-Regular",
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "LEADER BOARD",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins-Regular",
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
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
                  child: Image.asset('assets/Images/trophy_ic.png'),
                ),
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height / 1.4,
                      child: null,
                    ),
                    Positioned(
                      child: Container(
                        color: appColors.mainAppColor,
                        alignment: Alignment.bottomCenter,
                        width: MediaQuery.of(context).size.width / 1.1,
                        height: MediaQuery.of(context).size.height / 1.6,
                        child: Container(
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/Images/curvedBackground.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                          padding: const EdgeInsets.only(top: 65, left: 10, right: 10, bottom: 60),
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: ListView.builder(
                              itemCount: leaderboardDataModel.length,
                              itemBuilder: (context, index) {
                                final item = leaderboardDataModel[index];
                                final bool isFirstItem = index == 0;

                                return Container(
                                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Card(
                                            clipBehavior: Clip.antiAlias,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: appColors.mainAppColor,
                                                gradient: isFirstItem
                                                    ? const LinearGradient(
                                                  colors: [
                                                    Colors.yellow,
                                                    Colors.orangeAccent,
                                                    Colors.yellow,
                                                    Colors.orange,
                                                    Colors.orange
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomCenter,
                                                )
                                                    : null,
                                              ),
                                              height: 20,
                                              width: 20,
                                              child: Center(
                                                child: Text(
                                                  '${index + 1}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width / 3,
                                            child: Text(
                                              item.name,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Color(0xFFD42D3F),
                                                fontWeight: isFirstItem ? FontWeight.bold : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        item.totalDisbursementAmt,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFFD42D3F),
                                          fontWeight: isFirstItem ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
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
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    int index = dropdownOptions.indexOf(selectedPeriod);
                                    if (index > 0) {
                                      selectedPeriod = dropdownOptions[index - 1];
                                      _getLeaderBoardDataForPeriod(selectedPeriod);  // Fetch data for previous month
                                    }
                                  });
                                },
                                child: Icon(
                                  Icons.arrow_left,
                                  color: appColors.mainAppColor,
                                  size: 30,
                                ),
                              ),
                              SizedBox(width: 20),
                              Container(
                                width: 100,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  selectedPeriod,
                                  style: TextStyle(
                                    color: appColors.mainAppColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    int index = dropdownOptions.indexOf(selectedPeriod);
                                    if (index < dropdownOptions.length - 1) {
                                      selectedPeriod = dropdownOptions[index + 1];
                                      _getLeaderBoardDataForPeriod(selectedPeriod);  // Fetch data for next month
                                    }
                                  });
                                },
                                child: Icon(
                                  Icons.arrow_right,
                                  color: appColors.mainAppColor,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                          if (!isDataAvailable)
                            Padding(
                              padding: const EdgeInsets.only(top: 20), // Adjust the top padding for margin from the dropdown
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min, // Ensures the Column takes only the required space
                                  crossAxisAlignment: CrossAxisAlignment.center, // Centers the text horizontally
                                  children: [
                                    Icon(Icons.warning, color: Colors.red, size: 50),
                                    Text(
                                      errorMessage,
                                      style: TextStyle(color: Colors.red, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
