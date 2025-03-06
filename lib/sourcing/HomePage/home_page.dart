import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/sourcing/HomePage/show_flash_dialog.dart';
import 'package:flutter_sourcing_app/sourcing/HomePage/target_set_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../../api_service.dart';
import '../global_class.dart';
import '../notifications.dart';
import '../../const/appcolors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentSliderValue = 2500; // Initial value in thousands
  int _displayValue = 0; // Display value for the text
  int _page = 0;
  AppColors appColors = new AppColors();
  late VideoPlayerController _controller;
  final ScrollController _scrollController = ScrollController();
  bool isExpanded = true;
  late String message = "";
  bool _isMuted = false;

  void _toggleAppBar() {
    if (isExpanded) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
    setState(() {
      isExpanded = !isExpanded;
    });
  }


  @override
  void dispose() {
    _controller.dispose();
  }

  @override
  void initState() {

    if(GlobalClass.banner_name.toLowerCase().endsWith(".mp4")){
      _controller = VideoPlayerController.network(
        'https://predeptest.paisalo.in:8084/LOSDOC/BannerPost/${GlobalClass.banner_name}', // Replace with your video URL
      )..initialize().then((_) {
        // Ensure the first frame is shown
        setState(() {});
        _controller.play(); // Autoplay

      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBannerDialog();
    });
    super.initState();
    if (GlobalClass.target == 0) {
      _showAlertDialog(context);
    } else {
      _displayValue = GlobalClass.target;
    }


    csoRankApi(context);


  }
  Future<void> csoRankApi(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      EasyLoading.show(
        status: AppLocalizations.of(context)!.loading,
      );
    });
    final api = ApiService.create(baseUrl: ApiConfig.baseUrl1);


    try {
      var response = await api
          .GetCsoRanks(GlobalClass.token, GlobalClass.dbName, GlobalClass.id, GlobalClass.getCurrentMonth(), GlobalClass.getCurrentYear());

      if (response.statuscode == 200 && response.data.isNotEmpty && (response.data[0].errormsg.isEmpty || response.data[0].errormsg == null)) {
        setState(() {
          int rank = response.data[0].rank;
          if(rank == 0){
            message = 'Calculating...';
          }else if (rank == 1) {
            message =  AppLocalizations.of(context)!.highesttarget;
          } else {
            rank = rank -1;
            message = '$rank People are earning more commission';
          }
        });
      } else{
        message = 'Calculating...';
     // GlobalClass.showUnsuccessfulAlert(context, response.message, 1);
      }
    } catch (err) {
      GlobalClass.showErrorAlert(context, "Error in fetching Rank", 1);
    } finally {
   //   EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [

          SliverAppBar(
            backgroundColor: Color(0xFFD42D3F),
            expandedHeight: GlobalClass.banner_name.isNotEmpty?200.0:0,
            floating: false,
            pinned: false,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: GlobalClass.banner_name.isNotEmpty?(GlobalClass.banner_name.toLowerCase().endsWith(".mp4")?(_controller.value.isInitialized
                  ?Stack(
                 children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),

                  Positioned(
                      bottom: 20,
                      child:Container(color: Colors.black12,width: MediaQuery.of(context).size.width,child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Color(0xFFD42D3F),
                            ),
                            onPressed: () {
                              setState(() {
                                if (_controller.value.isPlaying) {
                                  _controller.pause();
                                } else {
                                  _controller.play();
                                }
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              _isMuted ? Icons.volume_off : Icons.volume_up,
                              color: Color(0xFFD42D3F),
                            ),
                            onPressed: () {
                              setState(() {
                                _isMuted = !_isMuted;
                                _controller.setVolume(_isMuted ? 0 : 1);
                              });
                            },
                          ),

                        ],
                      ),) ),
                   Positioned(bottom:40,child:SizedBox(width: MediaQuery.of(context).size.width,child:   VideoProgressIndicator(
                     _controller,
                     allowScrubbing: true,
                     padding: EdgeInsets.symmetric(horizontal: 50),
                   ),),)
                ],
              )
                  : Center(child: CircularProgressIndicator(color: Colors.white,),)):Image.network(
                'https://predeptest.paisalo.in:8084/LOSDOC/BannerPost/${GlobalClass.banner_name}',
                fit: BoxFit.cover,
              )):Container(),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // First IconButton on the left
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NotificationPage()),
                        );
                      },
                      icon: Icon(
                        Icons.notification_add,
                        color: Colors.white,
                      ),
                    ),
                    // Spacer to move the second button to the center-right
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              size: 30,
                              color: Colors.white,
                            ),
                            onPressed: _toggleAppBar,
                          ),
                        ],
                      ),
                    ),
                    // Blank space for the right side
                    SizedBox(width: 48), // Can adjust size if needed
                  ],
                ),

                SizedBox(height: 40), // Add some space at the top
                Container(
                  width: MediaQuery.of(context).size.width - 30,
                  margin: EdgeInsets.symmetric(horizontal: 15.0), // 15dp margin on left and right
                  padding: EdgeInsets.only(left: 30.0, right: 30, top: 30, bottom: 50),
                  decoration: BoxDecoration(
                    color: Color(0xFFD42D3F),
                    borderRadius: BorderRadius.circular(18),
                    image: DecorationImage(
                      image: AssetImage('assets/Images/curvedBackground.png'), // replace with your background image
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo with top margin
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Image.asset(
                          'assets/Images/paisa_logo.png', // replace with your logo
                          height: 45,
                        ),
                      ),
                      // Rupees image with top margin
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Image.asset(
                          'assets/Images/rupees.png', // replace with your image asset
                          height: 30,
                        ),
                      ),
                      // Monthly text with top margin
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          AppLocalizations.of(context)!.month,
                          style: TextStyle(
                            fontFamily: "Poppins-Regular",
                            fontSize: 20,
                            color: Color(0xFF6D6D6D), // dark grey color
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // Disbursement Target text with top margin
                      Text(
                        AppLocalizations.of(context)!.comission,
                        style: TextStyle(
                          fontFamily: "Poppins-Regular",
                          fontSize: 20,
                          color: Color(0xFF6D6D6D),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      // Container with margin from top and bottom
                      SizedBox(height: 10),
                      Text(
                        '₹ ${_displayValue.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontFamily: "Poppins-Regular",
                          fontSize: 28,
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD42D3F), // Button background color
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10), // Button padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero, // Rectangular corners
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => TargetSetPage()),
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!.target,
                          style: TextStyle(
                            fontFamily: "Poppins-Regular",
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20), // Add space between sections
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 4,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 5,
                          margin: EdgeInsets.all(10),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                                children: [
                                  /*Text(
                                    'Current Earning',
                                    style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      fontSize: 16,
                                      color: Color(0xFF6D6D6D),
                                    ),
                                  ),
                                  SizedBox(height: 10), // Add some spacing
                                  Flexible(
                                    child: TextField(
                                      controller: TextEditingController(text: '\₹0000'),
                                      style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        fontSize: 16,
                                        color: Color(0xFF6D6D6D),
                                      ),
                                      textAlign: TextAlign.center,
                                      readOnly: true, // Make it read-only
                                      decoration: InputDecoration(
                                        border: InputBorder.none, // Remove underline
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),*/ // Add some spacing
                                  Text(
                                    message,
                                    style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      fontSize: 16,
                                      color: Color(0xFF6D6D6D),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Flexible(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 4,
                        child: Card(
                          color: Colors.red[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 5,
                          margin: EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.earnmaximum,
                                    style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    AppLocalizations.of(context)!.abruknanhi,
                                    style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20), // Add some space at the bottom
              ],
            ),
          ),
        ],
      ),
    );
  }



  Future<int?> _showAlertDialog(BuildContext context) async {
    _currentSliderValue = 2500; // Reset slider value to initial value

    return showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: EdgeInsets.zero,
              content: Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  image: DecorationImage(
                    image: AssetImage('assets/Images/curvedBackground.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Image.asset(
                        'assets/Images/paisa_logo.png',
                        height: 45,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Image.asset(
                        'assets/Images/rupees.png',
                        height: 30,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        AppLocalizations.of(context)!.month,
                        style: TextStyle(fontFamily: "Poppins-Regular",
                          fontSize: 24,
                          color: Color(0xFF6D6D6D),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        AppLocalizations.of(context)!.disbursement,
                        style: TextStyle(fontFamily: "Poppins-Regular",
                          fontSize: 24,
                          color: Color(0xFF6D6D6D),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Slider(
                        value: _currentSliderValue.toDouble(),
                        min: 0,
                        max: 10000, // Max value in thousands (10 million)
                        divisions:
                            10000, // Ensure divisions are set to the number of thousand increments
                        label:
                            '${(_currentSliderValue * 1000).toStringAsFixed(0)}',
                        onChanged: (value) {
                          setState(() {
                            _currentSliderValue = value.toInt();
                          });
                        },
                        onChangeEnd: (value) async {
                          await _setTarget(context, value.toInt());
                          Navigator.of(context).pop(value.toInt());
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Value: ${(_currentSliderValue * 1000).toStringAsFixed(0)}',
                        style: TextStyle(fontFamily: "Poppins-Regular",
                          fontSize: 16,
                          color: Color(0xFF6D6D6D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _setTarget(BuildContext context, int target) async {
    int targetAmount = target.toInt() * 1000;

    final api = Provider.of<ApiService>(context, listen: false);

    Map<String, dynamic> requestBody = {
      "TargetCommAmt": targetAmount,
    };

    return await api
        .insertMonthlytarget(GlobalClass.token, GlobalClass.dbName, requestBody)
        .then((value) async {
      if (value.statuscode == 200) {
        EasyLoading.dismiss();

        if (value.data[0].errormsg == null || value.data[0].errormsg.isEmpty) {
          GlobalClass.showSuccessAlert(context, value.message, 1);
          setState(() {
            _displayValue = targetAmount;
          });
        } else {
          GlobalClass.showUnsuccessfulAlert(context, value.data[0].errormsg, 1);
        }
      } else {
        EasyLoading.dismiss();
        GlobalClass.showErrorAlert(context, value.message, 1);
      }
    });
  }

  Future<void> _showBannerDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentDate = DateTime.now().toIso8601String().split('T')[0];

    // Check if the current date is already saved
    String? savedDate = prefs.getString('dialog_date');
    if (savedDate != currentDate) {
      // If not saved, show the dialog
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return BannerDialog(
            banner: GlobalClass.flash_image_name, // Replace with your banner URL
            text1: GlobalClass.flash_advertisement,
            text2:  GlobalClass.flash_description,
          );
        },
      );
    }

  }
}
