import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/Models/login_model.dart';
import 'package:flutter_sourcing_app/collection_report.dart';
import 'package:flutter_sourcing_app/qr_payment_reports.dart';
import 'package:flutter_sourcing_app/referandearnactivity.dart';
import 'package:flutter_sourcing_app/submit_ss_qrtransaction.dart';
import 'package:flutter_sourcing_app/utils/current_location.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'global_class.dart';
import 'login_page.dart';
import 'notifications.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _creatorController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _validityController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController deviceSirNoController = TextEditingController();
  String tabName = "";
  Duration _remainingTime = Duration();
  String _timeDisplay = '';
  Timer? _timer;
  File? _imageFile;
  String? _imagePath;
  final picker = ImagePicker();
  bool punchCard = true;

  @override
  void initState() {
    super.initState();
    attendanceStatus(context);
    _initializeControllers();
    _startTimer();
    _loadImage();
    print("list ${GlobalClass.creatorlist}");
  }

  void _initializeControllers() {
    _creatorController.text = GlobalClass.creator;
    _idController.text = GlobalClass.id;
    _validityController.text = GlobalClass.address;
    _mobileNoController.text = GlobalClass.mobile;
    _nameController.text = GlobalClass.userName;
    _designationController.text = GlobalClass.designation;
  }

  void _startTimer() {
    String validityString = _validityController.text.trim();
    if (validityString.isNotEmpty && validityString.contains(':')) {
      List<String> timeParts = validityString.split(':');
      if (timeParts.length == 3) {
        try {
          int hours = int.parse(timeParts[0]);
          int minutes = int.parse(timeParts[1]);
          int seconds = int.parse(timeParts[2]);
          if (hours >= 0 &&
              minutes >= 0 &&
              seconds >= 0 &&
              minutes < 60 &&
              seconds < 60) {
            _remainingTime =
                Duration(hours: hours, minutes: minutes, seconds: seconds);
            _timeDisplay = _formatTime(_remainingTime);
            _timer = Timer.periodic(Duration(seconds: 1), (timer) {
              if (_remainingTime.inSeconds > 0) {
                setState(() {
                  _remainingTime -= Duration(seconds: 1);
                  _timeDisplay = _formatTime(_remainingTime);
                });
              } else {
                setState(() {
                  _timeDisplay = 'Session expired';
                });
                _timer?.cancel();
              }
            });
          } else {
            _setInvalidTimeFormat();
          }
        } catch (e) {
          _setInvalidTimeFormat();
        }
      } else {
        _setInvalidTimeFormat();
      }
    } else {
      _setInvalidTimeFormat();
    }
  }

  void _setInvalidTimeFormat() {
    setState(() {
      _timeDisplay = 'Invalid time format';
    });
  }

  String _formatTime(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath =
        prefs.getString('imagePath'); // Fetch the saved image path

    if (imagePath != null && imagePath.isNotEmpty) {
      setState(() {
        _imagePath = imagePath; // Save the path to _imagePath
        _imageFile = File(imagePath); // Convert the path to a File object
      });
    } else {
      print('No image found in SharedPreferences.');
    }
  }

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      await _cropImage(imageFile);
    } else {
      print('No image selected.');
    }
  }

  Future<void> _saveImage(File image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String path = image.path;
    await prefs.setString('imagePath', path);
    setState(() {
      _imageFile = image;
      _imagePath = path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD42D3F),


      endDrawer: Container(
        alignment: Alignment.center,
        width:120,
        height: MediaQuery.of(context).size.height /
            2, // Set the height of the drawer

        child: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QrPaymentReports()),
                  );
                },
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:  [
                    Icon(Icons.currency_rupee,size: 40,color: Colors.blue),
                    SizedBox(height: 5),
                    Text(AppLocalizations.of(context)!.qrpaymentreport, style: TextStyle(fontSize: 8)),
                  ],
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CollectionStatus()),
                  );
                },
                title: Column(
                  children:  [
                    Icon(Icons.currency_rupee,size: 50,color: Colors.blue),
                    SizedBox(height: 5),
                    Text(AppLocalizations.of(context)!.collectionreport, style: TextStyle(fontSize: 8)),
                  ],
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  MorphoRechargeDialog.show(context);
                },
                title: Column(
                  children: [
                    const Icon(Icons.fingerprint,size: 50,color: Colors.green,),
                    const SizedBox(height: 5),
                    Text(AppLocalizations.of(context)!.morpho, style: const TextStyle(fontSize: 8)),
                  ],
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SubmitSsQrTransaction(
                      smcode: "",
                    )),
                  );
                },
                title:Center(
                  child: Column(
                  children: [
                    const Icon(Icons.currency_rupee_rounded,size: 50,color: Colors.blue),
                    const SizedBox(height: 5),
                     Text(
                       AppLocalizations.of(context)!.payment,
                        style: const TextStyle(fontSize: 7),
                      ),
                  ],
                  ),

                ),
              )
            ],
          ),
        ),

      ),

      endDrawerEnableOpenDragGesture: true,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height - 45,
          ),
          child: Stack(
            children: [
              Positioned(
                top: -MediaQuery.of(context).size.width - 50,
                left: -50,
                right: -50,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/Images/sphere.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                left: 10,
                right: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => NotificationPage()));
                          },
                          icon: Icon(Icons.notification_add,color: Colors.white,)
                      ),
                      _buildCenterLogo(),
                      _buildLogoutButton(context),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 110,
                left: 10,
                right: 10,
                child:_buildProfilePicture(),
              ),

              Positioned.fill(
                top: 220,
                left: 10,
                right: 10,
                child: SingleChildScrollView(
                  // Added SingleChildScrollView here
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                   //   SizedBox(height: MediaQuery.of(context).size.width / 3),
                      _buildUserDetailsCard(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 6,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GridView.builder(

                            padding: EdgeInsets.zero,

                             gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 1,
                              mainAxisSpacing: 2,
                            ),
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return _buildGridItem(
                                    AppLocalizations.of(context)!.qrpaymentreport, Icons.qr_code, () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            QrPaymentReports()),
                                  );
                                });
                              } else if (index == 1) {
                                return _buildGridItem(
                                    AppLocalizations.of(context)!.morpho, Icons.fingerprint,
                                    () {
                                  MorphoRechargeDialog.show(context);
                                });
                              }else if (index == 2) {
                                return _buildGridItem(
                                    AppLocalizations.of(context)!.collectionreport, Icons.file_present_rounded,
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => CollectionStatus()),
                                      );
                                });
                              } else if (index == 3) {
                                return _buildGridItem(
                                    AppLocalizations.of(context)!.payment, Icons.currency_rupee,
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => SubmitSsQrTransaction(
                                          smcode: "",
                                        )),
                                      );
                                });
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                      ),
                      Card(
                        elevation: 10,
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                          color: punchCard ? Colors.green : Colors.grey,
                          width: MediaQuery.of(context).size.width - 50,
                          child: InkWell(
                            onTap: punchCard
                                ? () {
                                    punchInOut(context);
                                  }
                                : null,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 11.0),
                              alignment: Alignment.center,
                              child: Text(
                                tabName,
                                style: const TextStyle(
                                  fontFamily: "Poppins-Regular",
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),


                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Card(
                          elevation: 5,
                          clipBehavior: Clip.antiAlias,
                          color: Colors.transparent,
                          child: Stack(
                            children: [
                              Container(
                                height: 310,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(0),
                                  image: DecorationImage(
                                    image: AssetImage('assets/Images/earn6.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/Images/earn5.png',
                                  width: MediaQuery.of(context).size.width * 0.95,
                                  height: 280,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: MediaQuery.of(context).size.height * 0.03,
                                left: MediaQuery.of(context).size.width * 0.02,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => referandearnactivity()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFD42D3F),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: MediaQuery.of(context).size.width * 0.04,
                                      vertical: MediaQuery.of(context).size.height * 0.01,
                                    ),
                                    textStyle: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width * 0.035,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  child: Text(AppLocalizations.of(context)!.refernow,style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),


                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(String title, IconData icon, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 50,
            width: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.shade200, // Background color for grid item
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 40, // Adjust the size of the icon
              color: Colors.blueAccent,
            ),
          ),
        ),
       // Space between icon and text
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10, // Adjust text size
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }


  Widget _buildGridItem1(String title, IconData icon, VoidCallback onTap) {
    return Card(
      color: Colors.white,
      elevation: 6,
      margin: EdgeInsets.all(6),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.grey),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Poppins-Regular",
                  fontSize: 11,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.areyousure,
                  style: TextStyle(
                      color: Color(0xFFD42D3F),
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.doyouwant,
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildShinyButton(
                      AppLocalizations.of(context)!.no,
                          () {
                        EasyLoading.dismiss();
                        Navigator.of(context).pop(true);
                      },
                    ),
                    _buildShinyButton(
                      AppLocalizations.of(context)!.yes,
                          () {
                        EasyLoading.dismiss();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => LoginPage()));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      child: _buildIconContainer(Icons.logout, color: Color(0xFFD42D3F)),
    );
  }

  Widget _buildIconContainer(IconData icon, {Color color = Colors.grey}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(5),
      ),
      height: 40,
      width: 40,
      alignment: Alignment.center,
      child: Icon(icon, size: 16, color: color),
    );
  }
  Widget _buildShinyButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Color(0xFFD42D3F), // foreground/text
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }

  Widget _buildCenterLogo() {
    return Image.asset(
      'assets/Images/logo_white.png',
      height: 30,
    );
  }

  Widget _buildProfilePicture() {
    return Center(
      child: GestureDetector(
        onTap: getImage, // Trigger image selection
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[200],
          child: _imageFile == null
              ? ClipOval(
                  child: Image.asset(
                    'assets/Images/user_ic.png', // Default image if no image exists
                    width: 120, // Image width
                    height: 120, // Image height
                    fit: BoxFit.cover,
                  ),
                )
              : ClipOval(
                  child: Image.file(
                    _imageFile!, // Use _imageFile, which is a File object
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildUserDetailsCard() {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      color: Colors.white.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(Icons.credit_card, AppLocalizations.of(context)!.id
                , _idController),
            Divider(thickness: 2, indent: 16, endIndent: 16),
            _buildDetailRow(Icons.person, AppLocalizations.of(context)!.name , _nameController),
            Divider(thickness: 2, indent: 16, endIndent: 16),
            _buildDetailRow(Icons.phone, AppLocalizations.of(context)!.mno , _mobileNoController),
            Divider(thickness: 2, indent: 16, endIndent: 16),
            _buildDetailRow(Icons.work, AppLocalizations.of(context)!.designation , _designationController),
            Divider(thickness: 2, indent: 16, endIndent: 16),
/*
            _buildDetailList(Icons.admin_panel_settings, AppLocalizations.of(context)!.creater , _creatorController,),
*/
            Row(
              children: [
                Icon(Icons.admin_panel_settings, color: Color(0xFFD42D3F)),
                Text(
                  'Switch Creator ',
                  style: TextStyle(
                    fontFamily: "Poppins-Regular",
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    _creatorController.text,
                    style: TextStyle(
                      fontFamily: "Poppins-Regular",
                      color: Color(0xFFD42D3F),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Color(0xFFD42D3F)),
                  onPressed: () {
                    _showCreatorDialog(context);
                  },
                )
              ]
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      IconData icon, String label, TextEditingController controller) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFFD42D3F)),
        Text(label,
            style: TextStyle(
                fontFamily: "Poppins-Regular",
                fontSize: 11,
                fontWeight: FontWeight.bold)),
        Expanded(
          child: Text(
            controller.text,
            style: TextStyle(
                fontFamily: "Poppins-Regular", color: Color(0xFFD42D3F)),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailList(
      IconData icon, String label, TextEditingController controller) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFFD42D3F)),
        SizedBox(width: 8), // Add some space between the icon and the text
        Text(
          label,
          style: TextStyle(
            fontFamily: "Poppins-Regular",
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 8), // Add some space between the label and the dropdown
        Expanded(
          child: Container(
            height: 40, // Set the height to make it smaller
            padding: EdgeInsets.symmetric(horizontal: 8), // Add horizontal padding
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFD42D3F)),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButtonFormField<GetCreatorList>(
              decoration: InputDecoration(
                border: InputBorder.none, // Remove the internal border
                isDense: true, // Make the dropdown more compact
                contentPadding: EdgeInsets.symmetric(vertical: 10), // Center the text vertically
              ),
              value: GlobalClass.creatorlist.isNotEmpty
                  ? GlobalClass.creatorlist.first
                  : null,
              items: GlobalClass.creatorlist.map((GetCreatorList creator) {
                return DropdownMenuItem<GetCreatorList>(
                  value: creator,
                  child: Text(
                    creator.creatorName,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFFD42D3F),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (GetCreatorList? newValue) {
                if (newValue != null) {
                  GlobalClass.creator = newValue.creatorName;
                  GlobalClass.creatorId = newValue.creatorId.toString();
                  controller.text = newValue.creatorName;
                  print('Selected Creator: ${GlobalClass.creator}');

                }
              },
            ),
          ),
        ),
      ],
    );
  }


  Future<void> punchInOut(BuildContext context) async {
    EasyLoading.show(status: "Please wait...");
    var _latitude = 0.0;
    var _longitude = 0.0;
    currentLocation _locationService = currentLocation();
    try {
      Map<String, dynamic> locationData =
          await _locationService.getCurrentLocation();
      _latitude = locationData['latitude'];
      _longitude = locationData['longitude'];
    } catch (e) {
      print("Error getting current location: $e");
    }

    if (_latitude == 0.0 || _longitude == 0.0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Location Error"),
          content: Text(
            AppLocalizations.of(context)!.locationerror),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
      EasyLoading.dismiss();
      return;
    }

    EasyLoading.show(
      status: 'Loading...',
    );
    final api = ApiService.create(baseUrl: ApiConfig.baseUrl1);
    Map<String, dynamic> requestBody = {
      "location": "$_latitude,$_longitude",
    };
    EasyLoading.dismiss();

    return await api
        .punchInOut(GlobalClass.token, GlobalClass.dbName, requestBody, tabName)
        .then((value) {
      if (value.statuscode == 200) {
        EasyLoading.dismiss();
        if (tabName == "PUNCHOUT") {
          punchCard = false;
          tabName = "PUNCHIN";
        } else {
          setState(() {
            tabName = "PUNCHOUT";
          });
        }
        GlobalClass.showSuccessAlert(context, value.message, 1);
      } else {
        EasyLoading.dismiss();
        GlobalClass.showUnsuccessfulAlert(context, value.message, 1);
      }
    });
  }

  Future<void> attendanceStatus(BuildContext context) async {
    EasyLoading.show(
      status: 'Loading...',
    );

    final api = Provider.of<ApiService>(context, listen: false);

    await api.AttendanceStatus(
            GlobalClass.token, GlobalClass.dbName, GlobalClass.id)
        .then((value) async {
      if (value.statuscode == 200) {
        if (value.data.length > 0) {
          if (value.data[0].inTime.isNotEmpty && value.data[0].outTime.isNotEmpty) {
            setState(() {
              punchCard = false;
              tabName = "PUNCHIN";
            });
          } else {
            setState(() {
              tabName = "PUNCHOUT";
            });
          }
        } else {
          setState(() {
            tabName = "PUNCHIN";
          });
        }

        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        GlobalClass.showUnsuccessfulAlert(context, "Attendance Status Fail", 1);
      }
    }).catchError((error) {
      EasyLoading.dismiss();
      GlobalClass.showUnsuccessfulAlert(context, error.toString(), 1);
    });
  }

  Future<void> _cropImage(File imageFile) async {
    if (imageFile != null) {
      CroppedFile? cropped = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        compressQuality: 100,
        maxHeight: 700,
        maxWidth: 700,
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
            toolbarColor: Color(0xFFD42D3F),
            toolbarTitle: 'Crop',
            toolbarWidgetColor: Colors.white,
            cropGridColor: Colors.black,
            backgroundColor: Color(0xFFD42D3F),
            cropFrameColor: Color(0xFFD42D3F),
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(title: 'Crop')
        ],
      );

      if (cropped != null) {
        setState(() {
          _imageFile = File(cropped.path);
        });

        await _saveImage(_imageFile!);
      }
    }
  }

  void _showCreatorDialog(BuildContext context) {
    String? selectedCreatorName = GlobalClass.creator;
    String? selectedCreatorId = GlobalClass.creatorId;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Select Creator',
            style: TextStyle(color: Color(0xFFD42D3F)),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: GlobalClass.creatorlist.length,
              itemBuilder: (BuildContext context, int index) {
                final creator = GlobalClass.creatorlist[index];
                return ListTile(
                  title: Text(
                    creator.creatorName,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFD42D3F),
                    ),
                  ),
                  leading: Radio<String>(
                    value: creator.creatorId.toString(),
                    groupValue: selectedCreatorId,
                    onChanged: (String? value) {
                      if (value != null) {
                        selectedCreatorId = value;
                        selectedCreatorName = creator.creatorName;
                        (context as Element).markNeedsBuild();
                      }
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD42D3F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                minimumSize: Size(80, 40),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD42D3F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                minimumSize: Size(80, 40),
              ),
              onPressed: () {
                if (selectedCreatorName != null && selectedCreatorId != null) {
                  print('Selected Creator: $selectedCreatorName');
                  setState(() {
                    _creatorController.text = selectedCreatorName!;
                    _creatorController.text = selectedCreatorName!;
                    GlobalClass.creator = selectedCreatorName!;
                    GlobalClass.creatorId = selectedCreatorId!;
                  });
                }
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Select',style: TextStyle(color: Colors.white,)),
            ),
          ],
        );
      },
    );
  }
}

class MorphoRechargeDialog extends StatefulWidget {
  @override
  _MorphoRechargeDialogState createState() => _MorphoRechargeDialogState();

  // Static method to open the dialog
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MorphoRechargeDialog();
      },
    );
  }
}

class _MorphoRechargeDialogState extends State<MorphoRechargeDialog> {
  final TextEditingController _deviceSirNoController = TextEditingController();

  @override
  void dispose() {
    _deviceSirNoController.dispose(); // Clean up the controller
    super.dispose();
  }

  // API call function
  Future<void> _MorphoRechargeApi(
      BuildContext context, double latitude, double longitude) async {
    EasyLoading.show(status: 'Loading...');

    final api = Provider.of<ApiService>(context, listen: false);
    Map<String, dynamic> requestBody = {
      "creator": "AGRA",
      "groupCode": "009",
      "cityCode": "2299",
      "deviceSirNo": _deviceSirNoController.text,
      "Lat": latitude.toString(),
      "Long": longitude.toString()
    };

    await api
        .morphorecharge(GlobalClass.dbName, GlobalClass.token, requestBody)
        .then((value) async {
      if (value.statuscode == 200) {
        EasyLoading.dismiss();
        GlobalClass.showSuccessAlert(context, value.message, 2);
      } else {
        EasyLoading.dismiss();
        GlobalClass.showUnsuccessfulAlert(
            context, "Unsuccessful to send Request", 1);
      }
    }).catchError((error) {
      EasyLoading.dismiss();
      GlobalClass.showUnsuccessfulAlert(context, "Server side Error", 1);
    });
  }

  void _onSubmit() async {
    if (_deviceSirNoController.text.isEmpty) {
      GlobalClass.showErrorAlert(context, "Please enter Your Morpho S/N.", 1);
      return;
    }

    if (_deviceSirNoController.text.length != 11) {
      GlobalClass.showErrorAlert(context, "Invalid Morpho S/N. Please check and try again.", 1);
      return;
    }

    try {
      Map<String, dynamic> locationData = await currentLocation().getCurrentLocation();
      var _latitude = locationData['latitude'] ?? 0.0;
      var _longitude = locationData['longitude'] ?? 0.0;

      await _MorphoRechargeApi(context, _latitude, _longitude);
    } catch (e) {
      print("Error getting current location: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.morpho,
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              child: TextFormField(
                maxLength: 11,
                controller: _deviceSirNoController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.entermorpho,
                  border: OutlineInputBorder(),
                  counterText: "",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Device S/N';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: _onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFD42D3F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            minimumSize: Size(80, 40),
          ),
          child: Text(
            AppLocalizations.of(context)!.submit,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
