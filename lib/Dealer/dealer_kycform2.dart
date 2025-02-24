import 'dart:async';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../Models/range_category_model.dart';
import '../api_service.dart';
import '../sourcing/ProfilePage/qr_scan_page.dart';
import '../sourcing/global_class.dart';
import 'dealerCrif.dart';
import 'dealer_kycform.dart';

class DealerKYCPage2 extends StatefulWidget {
  @override
  _DealerKYCPage2State createState() => _DealerKYCPage2State();
}

class _DealerKYCPage2State extends State<DealerKYCPage2> {

  final List<Widget> imageSliders = [];
  final List<Widget> idSliders = [];
  final CarouselSliderController _controller = CarouselSliderController();
  final CarouselSliderController _idcontroller = CarouselSliderController();
  int _current = 0;
  int _idcurrent = 0;
  File? _aadhaarImageF;
  File? _aadhaarImageB;
  File? _panImage;
  File? _dlImage;
  File? _voterImage;
  late ApiService apiService_OCR;

  String? selectedProduct;
  List<String> productList = ['Select', 'Bike', 'Car', 'Medical Instrument'];
  String? selectedDealer;
  List<String> dealerList = ['Select', 'MG Central', 'Pasco Automobiles', 'Kalra'];

  int _currentStep = 0;
  String panCardHolderName =
      "Please search PAN card holder name for verification";
  String? dlCardHolderName;
  String? voterCardHolderName;

  List<RangeCategoryDataModel> aadhar_gender = [];

  String? _locationMessage;
  Position? position;
  bool otpVerified = false;
  bool dataFetched = false;
  bool kycFetched = false;

  @override
  void initState() {
    super.initState();
    initializer();
  }

  Future<void> initializer () async {
    apiService_OCR = ApiService.create(baseUrl: ApiConfig.baseUrl6);
    geolocator(context);
    updatelist();
    updatelist2();
    Future.delayed(Duration.zero, () {
      this. SelectDealer();
    });

  }

  DateTime? _selectedDate;
  String name1 = "";
  String name2 = "";
  String name3 = "";
  String aadhaarNo = "";
  String Dob = "";
  String pinCode = "";
  String city = "";
  String state = "";
  String GurName = "";
  String relatn = "";
  String add1 = "";
  String add2 = "";
  String add3 = "";
  String fatherFname = "";
  String fatherMname = "";
  String fatherLname = "";
  String spouseFname = "";
  String spouseMname = "";
  String spouseLname = "";
  String genderselected = "";
  String selectedTitle = "";
  String selectedMarritalStatus = "";

  late var _ageController = TextEditingController();
  late var _latitudeController = TextEditingController();
  late var _longitudeController = TextEditingController();
  late var ExShowroomPriceController = TextEditingController();
  late var RTOPriceController = TextEditingController();
  late var InsurancePriceController = TextEditingController();
  late var InvoiceValueController = TextEditingController();
  late var MSPController = TextEditingController();

  bool panVerified = false;
  bool dlVerified = false;
  bool voterVerified = false;
  String? dlDob;
  String? Fi_Id;
  String? Fi_Code;
  String qrResult = "";
  bool isPanVerified = false,
      isDrivingLicenseVerified = false,
      isVoterIdVerified = false,
      isPassportVerified = false;

  get isChecked => null;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Color(0xFFD42D3F),
          body: SingleChildScrollView(
            child: Center(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 13.0, vertical: 24.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 1, color: Colors.grey.shade300),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                                ),
                                height: 40,
                                width: 40,
                                alignment: Alignment.center,
                                child: Center(
                                  child:
                                  Icon(Icons.arrow_back_ios_sharp, size: 13),
                                ),
                              ),
                              onTap: () {
                                if (_currentStep == 1) {
                                  setState(() {
                                    _currentStep--;
                                  });
                                } else {
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                            Center(
                              child: Image.asset(
                                'assets/Images/logo_white.png',
                                // Replace with your logo asset path
                                height: 30,
                              ),
                            ),
                            InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                                ),
                                height: 40,
                                width: 40,
                                alignment: Alignment.center,
                                child: Center(
                                  child:
                                  Icon(Icons.qr_code_scanner_outlined, size: 28,color: Colors.white,),
                                ),
                              ),
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => QRViewExample()),
                                );

                                if (result != null) {
                                  //
                                  // BigInt bigIntScanData = BigInt.parse(result);
                                  // List<int> byteScanData = bigIntToBytes(bigIntScanData);
                                  //
                                  // List<int> decompByteScanData = decompressData(byteScanData);
                                  // List<List<int>>  parts =separateData(decompByteScanData, 255, 15);
                                  //
                                  // setState(() {
                                  //
                                  //   qrResult= decodeData(parts);
                                  // });
                                  Navigator.push(context, MaterialPageRoute(builder:(context) =>  DealerKYCPage(result: result)));

                                  print('rrr' + result);
                                  //  setQRData(result);
                                }
                              },
                            ),

                          ],
                        ),
                      ),
                      //  _buildProgressIndicator(),
                      Column(
                        children: [
                          /*Container(
                          height:200,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Background container
                              Positioned(
                                bottom: 20,
                                child:Container(
                                  width: MediaQuery.of(context).size.width-50,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: Colors.blue[700], // Darker blue background
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Card(
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
                                    clipBehavior: Clip.antiAlias,
                                    child:_aadhaarImageF == null?Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Upload Aadhaar Front",style: TextStyle(color: Colors.white),),
                                      Icon(Icons.camera_alt, color: Colors.white, size: 30),
                                    ],
                                  ):Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                       Image.file(
                                        File(_aadhaarImageF!.path),
                                         width: MediaQuery.of(context).size.width-50,
                                         height: 140,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ],
                                  ),
                                  )
                                ),
                              ),
                              // Floating bottom row
                              Positioned(
                                bottom: 0, // Adjust to make it appear partially outside
                                child: Container(
                                  width: 120,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.blue[400], // Lighter blue for contrast
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                      onTap: () async {
                                        File? pickedFile =
                                            await
                                        GlobalClass().pickImage();
                                        setState(() {
                                          getDataFromOCR("adharFront", context,pickedFile);

                                          _aadhaarImageF = pickedFile!;

                                        });
                                },
                                  child:_aadhaarImageF == null?
                                      Icon(Icons.add, color: Colors.white, size: 25):
                                        Text("Aadhaar Front",style: TextStyle(color: Colors.white),),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ),
                        Container(
                          height:200,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Background container
                              Positioned(
                                bottom: 20,
                                child:Container(
                                  width: MediaQuery.of(context).size.width-50,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: Colors.blue[700], // Darker blue background
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child:Card(
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),

                                    clipBehavior: Clip.antiAlias,
                                    child: _aadhaarImageB == null?Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Upload Aadhaar Back",style: TextStyle(color: Colors.white),),
                                      Icon(Icons.camera_alt, color: Colors.white, size: 30),
                                    ],
                                  ):Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.file(
                                        File(_aadhaarImageB!.path),
                                        width: MediaQuery.of(context).size.width-50,
                                        height: 140,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ],
                                  ),
                                  )
                                ),
                              ),
                              // Floating bottom row
                              Positioned(
                                bottom: 0, // Adjust to make it appear partially outside
                                child: Container(
                                  width: 120,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.blue[400], // Lighter blue for contrast
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          File? pickedFile =
                                          await
                                          GlobalClass().pickImage();
                                          setState(() {
                                            getDataFromOCR("adharBack", context,pickedFile);

                                            _aadhaarImageB = pickedFile!;

                                          });
                                        },
                                        child:_aadhaarImageB == null?
                                        Icon(Icons.add, color: Colors.white, size: 25):
                                        Text("Aadhaar Back",style: TextStyle(color: Colors.white),),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ),*/
                          /* Container(
                            height: 200,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Background container
                                Positioned(
                                  bottom: 20,
                                  child: Container(
                                      width: MediaQuery.of(context).size.width -
                                          50,
                                      height: 140,
                                      decoration: BoxDecoration(
                                        color: Colors.blue[
                                            700], // Darker blue background
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(17)),
                                        color: Colors.transparent,
                                        clipBehavior: Clip.antiAlias,
                                        child: _panImage == null
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Upload Pan",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  Icon(Icons.camera_alt,
                                                      color: Colors.white,
                                                      size: 30),
                                                ],
                                              )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.file(
                                                    File(_panImage!.path),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            50,
                                                    height: 140,
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ],
                                              ),
                                      )),
                                ),
                                // Floating bottom row
                                Positioned(
                                  bottom:
                                      0, // Adjust to make it appear partially outside
                                  child: Container(
                                    width: 120,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[
                                          400], // Lighter blue for contrast
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            File? pickedFile =
                                                await GlobalClass().pickImage();
                                            setState(() {
                                              _panImage = pickedFile!;
                                            });
                                          },
                                          child: _panImage == null
                                              ? Icon(Icons.add,
                                                  color: Colors.white, size: 25)
                                              : Text(
                                                  "Pan card",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        Container(
                            height: 200,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Background container
                                Positioned(
                                  bottom: 20,
                                  child: Container(
                                      width: MediaQuery.of(context).size.width -
                                          50,
                                      height: 140,
                                      decoration: BoxDecoration(
                                        color: Colors.blue[
                                            700], // Darker blue background
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(17)),
                                        color: Colors.transparent,
                                        clipBehavior: Clip.antiAlias,
                                        child: _dlImage == null
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Upload DL",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  Icon(Icons.camera_alt,
                                                      color: Colors.white,
                                                      size: 30),
                                                ],
                                              )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.file(
                                                    File(_dlImage!.path),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            50,
                                                    height: 140,
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ],
                                              ),
                                      )),
                                ),
                                // Floating bottom row
                                Positioned(
                                  bottom:
                                      0, // Adjust to make it appear partially outside
                                  child: Container(
                                    width: 120,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[
                                          400], // Lighter blue for contrast
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            File? pickedFile =
                                                await GlobalClass().pickImage();
                                            setState(() {
                                              _dlImage = pickedFile!;
                                            });
                                          },
                                          child: _dlImage == null
                                              ? Icon(Icons.add,
                                                  color: Colors.white, size: 25)
                                              : Text(
                                                  "Driving License",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        Container(
                            height: 200,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Background container
                                Positioned(
                                  bottom: 20,
                                  child: Container(
                                      width: MediaQuery.of(context).size.width -
                                          50,
                                      height: 140,
                                      decoration: BoxDecoration(
                                        color: Colors.blue[
                                            700], // Darker blue background
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(17)),
                                        color: Colors.transparent,
                                        clipBehavior: Clip.antiAlias,
                                        child: _voterImage == null
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Upload Voter Id",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  Icon(Icons.camera_alt,
                                                      color: Colors.white,
                                                      size: 30),
                                                ],
                                              )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.file(
                                                    File(_voterImage!.path),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            50,
                                                    height: 140,
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ],
                                              ),
                                      )),
                                ),
                                // Floating bottom row
                                Positioned(
                                  bottom:
                                      0, // Adjust to make it appear partially outside
                                  child: Container(
                                    width: 120,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[
                                          400], // Lighter blue for contrast
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            File? pickedFile =
                                                await GlobalClass().pickImage();
                                            setState(() {
                                              _voterImage = pickedFile!;
                                            });
                                          },
                                          child: _voterImage == null
                                              ? Icon(Icons.add,
                                                  color: Colors.white, size: 25)
                                              : Text(
                                                  "Voter Id",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),*/
                          CarouselSlider(
                            items: imageSliders,
                            carouselController: _controller,
                            options: CarouselOptions(
                                autoPlay: false,
                                enlargeCenterPage: true,
                                aspectRatio: 2.0,
                                scrollDirection: Axis.horizontal,
                                enableInfiniteScroll: false,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _current = index;
                                  });
                                }),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: imageSliders.asMap().entries.map((entry) {
                              return GestureDetector(
                                onTap: () => _controller.animateToPage(entry.key),
                                child: Container(
                                  width: 12.0,
                                  height: 12.0,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                          ? Colors.white
                                          : Colors.greenAccent)
                                          .withOpacity(
                                          _current == entry.key ? 0.9 : 0.4)),
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CarouselSlider(
                            items: idSliders,
                            carouselController: _idcontroller,
                            options: CarouselOptions(
                                autoPlay: false,
                                enlargeCenterPage: true,
                                aspectRatio: 2.0,
                                scrollDirection: Axis.horizontal,
                                enableInfiniteScroll: false,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _idcurrent = index;
                                  });
                                }),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: idSliders.asMap().entries.map((entry) {
                              return GestureDetector(
                                onTap: () =>
                                    _idcontroller.animateToPage(entry.key),
                                child: Container(
                                  width: 12.0,
                                  height: 12.0,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                          ? Colors.white
                                          : Colors.greenAccent)
                                          .withOpacity(_idcurrent == entry.key
                                          ? 0.9
                                          : 0.4)),
                                ),
                              );
                            }).toList(),
                          ),

                          /*ExpandableCard(
                          padding: EdgeInsets.zero,
                          title: 'Aadhaar Info',
                          button2Value: 'Edit',
                          sectionRowCount: 2,
                          sectionRowTitles: const ['Front', 'Back'],
                          totalText: 2,
                          backgroundColor: Colors.white,
                          elevation: 4.0,
                          button2Elevation: 5.0,
                          button2Color: Colors.blue,
                          button1TextColor: Colors.blue,
                          button2BorderRadius: 5.0,
                          cardBorderRadius: 10,
                          sectionRowData: const {
                            'Front': ['Name', 'DOB', 'Aadhaar No.', 'Gender'],
                            'Back': [
                              'Guardian Name',
                              'Father Name',
                              'Spouse Name',
                              'Address',
                              'Pin',
                              'State',
                              'City'
                            ],
                          },
                          textButtonActionFirst: 'Details...',
                          textButtonActionSecond: 'Close',
                          onPressedButton2: () {
                            //do something
                          },
                        ),
                        TapToExpand(
                          title: const Text(
                            'Aadhaar Details',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          titlePadding:
                              EdgeInsets.only(left: 10, right: 10, top: 0),
                          isScrollable: false,
                          borderRadius: BorderRadius.circular(10),
                          backgroundcolor: Colors.grey,
                          iconSize: 40,
                          outerOpenedPadding: 0,
                          outerClosedPadding: 0,
                          spaceBetweenBodyTitle: 0,
                          paddingCurve: Cubic(0, 0, 0, 0),
                          curve: SawTooth(0),
                          content: Column(
                            children: <Widget>[
                              Text(
                                "Name",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Text(
                                "DOB",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Text(
                                "Gender",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Text(
                                "Aadhaar No.",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Text(
                                "Guardian ",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Text(
                                "Father",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Text(
                                "Address",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Text(
                                "Pin",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Text(
                                "State",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Text(
                                "City",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ],
                          ),
                        ),*/
                          SizedBox(
                            height: 30,
                          ),
                          dataFetched?Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(10),
                            child: ExpandablePanel(
                              header: Text(
                                'Aadhaar card',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              collapsed: Text(
                                'Name : Raghvendra Pratap Singh',
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              expanded: Column(
                                children: [
                                  Text(
                                    'DOB',
                                    softWrap: true,
                                  ),
                                  Text(
                                    'Gender',
                                    softWrap: true,
                                  ),
                                  Text(
                                    'Aadhaar',
                                    softWrap: true,
                                  ),
                                  Text(
                                    'Guardian',
                                    softWrap: true,
                                  ),
                                  Text(
                                    'Father',
                                    softWrap: true,
                                  ),
                                  Text(
                                    'Address',
                                    softWrap: true,
                                  ),
                                  Text(
                                    'Pin',
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            ),
                          ):SizedBox(),
                          SizedBox(height: 10,),
                          kycFetched?Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(10),
                            child: ExpandablePanel(
                              header: Text(
                                'KYC Details',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              collapsed: Text(
                                'Name : Raghvendra Pratap Singh',
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              expanded: Column(
                                children: [
                                  Text(
                                    'ID Name: Pan Card',
                                    softWrap: true,
                                  ),
                                  Text(
                                    'Id No. :ABCSD1234Z',
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            ),
                          ):SizedBox(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "${_locationMessage}",
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  geolocator(context);
                                },
                                child: Card(
                                  elevation: 5,
                                  shape: CircleBorder(),
                                  child: Padding(
                                    padding: EdgeInsets.all(3),
                                    child: Icon(
                                      Icons.refresh,
                                      size: 30,
                                      color: Color(0xffb41d2d),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DealerCrif()));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 25),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.redAccent, Color(0xFFD42D3F)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    blurRadius: 10,
                                    offset: Offset(5, 5),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'Check Crif',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10.0,
                                        color: Colors.black.withOpacity(0.5),
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],)

            ),
          ),
        ));
  }

  void _calculateAge() {
    if (_selectedDate != null) {
      DateTime today = DateTime.now();
      int age = today.year - _selectedDate!.year;

      if (today.month < _selectedDate!.month ||
          (today.month == _selectedDate!.month &&
              today.day < _selectedDate!.day)) {
        age--;
      }

      _ageController.text = age.toString();
    } else {
      _ageController.text = '';
    }
  }

  String formatDate(String date, dateFormat) {
    try {
      // Parse the input string to a DateTime object
      DateTime parsedDate = DateFormat(dateFormat).parse(date);
      setState(() {
        _selectedDate = parsedDate;
        _calculateAge();
      });
      dlDob = DateFormat('dd-MM-yyyy').format(parsedDate);
      // Return the formatted date string in yyyy-MM-dd format
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      // Handle any invalid format
      return 'Invalid Date';
    }
  }

  Future<void> getDataFromOCR(
      String type, BuildContext context, File? pickedFile) async {
    EasyLoading.show();
    File? pickedImage = pickedFile;

    print("sssgetDataFromOCR");
    if (pickedImage != null) {
      print("ssspickedImage");

      try {
        final response = await apiService_OCR.uploadDocument(
          type, // imgType
          pickedImage, // File
        );
        if (response.statusCode == 200) {
          print("sss200");

          if (type == "adharFront") {
            print("adharFront");

            setState(() {
              aadhaarNo = response.data.adharId;
              List<String> nameParts = response.data.name.trim().split(" ");
              if (nameParts.length == 1) {
                name1 = nameParts[0];
              } else if (nameParts.length == 2) {
                name1 = nameParts[0];
                name2 = nameParts[1];
              } else {
                name1 = nameParts.first;
                name3 = nameParts.last;
                name2 = nameParts.sublist(1, nameParts.length - 1).join(' ');
              }
              Dob = formatDate(response.data.dob, 'dd/MM/yyyy');
              // genderselected = aadhar_gender
              //     .firstWhere((item) =>
              //         item.descriptionEn.toLowerCase() ==
              //         response.data.gender.toLowerCase())
              //     .descriptionEn;
              genderselected = response.data.gender;
              print(genderselected);
              // if (genderselected == "Male") {
              //   selectedTitle = "Mr.";
              // } else {
              //   selectedTitle = "Mrs.";
              // }
            });
            showIDCardDialog(context, 1);
            //Navigator.of(context).pop();
          } else if (type == "adharBack") {
            setState(() {
              pinCode = response.data.pincode;
              city = response.data.cityName;
              state = response.data.stateName;
              List<String> addressParts =
              response.data.address1.trim().split(" ");
              if (addressParts.length == 1) {
                add1 = addressParts[0];
              } else if (addressParts.length == 2) {
                add1 = addressParts[0];
                add2 = addressParts[1];
              } else {
                add1 = addressParts.first;
                add2 = addressParts.last;
                add3 = addressParts.sublist(1, addressParts.length - 1).join(' ');
              }

            if (response.data.relation.toLowerCase() == "father") {
                GurName = response.data.guardianName;
                relatn = "Father";
              List<String> guarNameParts = GurName.trim().split(" ");
              if (guarNameParts.length == 1) {
                fatherFname = guarNameParts[0];
              } else if (guarNameParts.length == 2) {
                fatherFname = guarNameParts[0];
                fatherLname = guarNameParts[1];
              } else {
                fatherFname = guarNameParts.first;
                fatherLname = guarNameParts.last;
                fatherMname = guarNameParts
                    .sublist(1, guarNameParts.length - 1)
                    .join(' ');
              }
            }
            else if (response.data.relation.toLowerCase() == "husband") {
              GurName = response.data.guardianName;
              setState(() {
                relatn = "Husband";
                selectedMarritalStatus = "Married";
              });

              List<String> guarNameParts = GurName.trim().split(" ");
              if (guarNameParts.length == 1) {
                spouseFname = guarNameParts[0];
              } else if (guarNameParts.length == 2) {
                spouseFname = guarNameParts[0];
                spouseLname = guarNameParts[1];
              } else {
                spouseFname = guarNameParts.first;
                spouseLname = guarNameParts.last;
                spouseMname = guarNameParts
                    .sublist(1, guarNameParts.length - 1)
                    .join(' ');
              }
    }
              dataFetched = true;

            });

            showIDCardDialog(context, 2);
          }
          EasyLoading.dismiss();
        } else {
          /* showToast_Error(
              "Data not fetched from this Aadhaar card please check the image");*/
          showToast_Error("1");
          EasyLoading.dismiss();
          print("sss201");

        }
      } catch (err) {
        /*showToast_Error(
            "Data not fetched from this Aadhaar card please check the image");*/
        showToast_Error("2" + err.toString());
        print(err.toString());
        EasyLoading.dismiss();
        print("sss202");

      }
    }
  }

  Future<void> geolocator(BuildContext context) async {
    EasyLoading.show(status: "Location Fetching...");
    try {
      position = await _getCurrentPosition();
      setState(() {
        if (position != null) {
          _locationMessage = "${position!.latitude},${position!.longitude}";
          print("Geolocation: $_locationMessage");
          _latitudeController.text = position!.latitude.toString();
          _longitudeController.text = position!.longitude.toString();
        }
      });
    } catch (e) {
      setState(() {
        _locationMessage = e.toString();
        _latitudeController.clear();
        _longitudeController.clear();
      });
      print("Geolocation Error: $_locationMessage");

      _showRefreshDialog(context);
    }
    EasyLoading.dismiss();
  }

  void _showRefreshDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Error'),
          content: Text(
              'Unable to fetch the location. Would you like to try again?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                geolocator(context); // Retry fetching the location
              },
              child: Text('Retry'),
            ),
          ],
        );
      },
    );
  }

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<bool> _onWillPop() async {
    // Show a confirmation dialog
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to close KYC page?'),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), // Stay in the app
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  EasyLoading.dismiss();
                  Navigator.of(context).pop(true);
                }, // Exit the app
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; // Default to false if dialog is dismissed
  }

  void showToast_Error(String message) {
    Fluttertoast.showToast(
      msg: "$message",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 13.0,
    );
  }

  void showIDCardDialog(BuildContext context, int step) {
    TextEditingController nameController = TextEditingController(
        text: [name1, name2, name3]
            .where((part) => part != null && part.isNotEmpty)
            .join(" "));
    TextEditingController aadhaarController =
        TextEditingController(text: aadhaarNo);
    TextEditingController dobController = TextEditingController();
    if (Dob != "") {
      String formattedDOB =
          '${Dob.split('T')[0].split('-')[2]}-${Dob.split('T')[0].split('-')[1]}-${Dob.split('T')[0].split('-')[0]}';
      dobController.text = formattedDOB;
    }
    TextEditingController genderController =
        TextEditingController(text: genderselected);
    TextEditingController relationController =
        TextEditingController(text: relatn);
    TextEditingController guardianController =
        TextEditingController(text: GurName);
    TextEditingController fatherController = TextEditingController(
        text: [fatherFname, fatherMname, fatherLname]
            .where((part) => part != null && part.isNotEmpty)
            .join(" "));
    TextEditingController statusController =
        TextEditingController(text: selectedMarritalStatus);
    TextEditingController spouseController = TextEditingController(
        text: [spouseFname, spouseMname, spouseLname]
            .where((part) => part != null && part.isNotEmpty)
            .join(" "));
    TextEditingController addressController = TextEditingController(
        text: [add1, add2, add3]
            .where((part) => part != null && part.isNotEmpty)
            .join(" "));
    TextEditingController stateController = TextEditingController(text: state);
    TextEditingController cityController = TextEditingController(text: city);
    TextEditingController pinController = TextEditingController(text: pinCode);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: Colors.yellow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.yellowAccent, width: 5),
            ),
            title: Center(
              child: Text(
                'Aadhaar Details',
                style: TextStyle(fontSize: 16),
              ),
            ),
            content: SingleChildScrollView(
              child: Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(0),
                child: step == 1
                    ? Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          buildEditableRow("Name", nameController),
                          buildEditableRow("Aadhaar ID", aadhaarController),
                          buildEditableRow("DOB", dobController),
                          buildEditableRow("Gender", genderController),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Save updated values
                                  String updatedName = nameController.text;
                                  String updatedAadhaar =
                                      aadhaarController.text;
                                  String updatedDOB = dobController.text;
                                  String updatedGender = genderController.text;
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 25),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.greenAccent,
                                        Color(0xFF0BDC15)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.4),
                                        blurRadius: 10,
                                        offset: Offset(5, 5),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'OKAY',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 10.0,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            offset: Offset(2.0, 2.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          buildEditableRow("Relation", relationController),
                          buildEditableRow("Guardian", guardianController),
                          buildEditableRow("Father", fatherController),
                          buildEditableRow("Status", statusController),
                          buildEditableRow("Spouse", spouseController),
                          buildEditableRow("Address", addressController),
                          buildEditableRow("State", stateController),
                          buildEditableRow("City", cityController),
                          buildEditableRow("PinCode", pinController),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  String updatedRelation =
                                      relationController.text;
                                  String updatedGuardian =
                                      guardianController.text;
                                  String updatedFather = fatherController.text;
                                  String updatedStatus = statusController.text;
                                  String updatedSpouse = spouseController.text;
                                  String updatedAddress =
                                      addressController.text;
                                  String updatedState = stateController.text;
                                  String updatedCity = cityController.text;
                                  String updatedPin = pinController.text;
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 25),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.greenAccent,
                                        Color(0xFF0BDC15)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.4),
                                        blurRadius: 10,
                                        offset: Offset(5, 5),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'OKAY',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 10.0,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            offset: Offset(2.0, 2.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildEditableRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ),
        ],
      ),
    );
  }

  void updatelist() {
     imageSliders.add(
        Container(
        height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 20,
              child: Container(
                  width: 250,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.redAccent, Color(0xFFD42D3F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    // color: Color(0xf7b94848), // Darker blue background
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17)),
                    clipBehavior: Clip.antiAlias,
                    child: _aadhaarImageF == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Upload Aadhaar Front",
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(Icons.camera_alt,
                            color: Colors.white, size: 30),
                      ],
                    )
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.file(
                          File(_aadhaarImageF!.path),
                          width: MediaQuery.of(context).size.width - 50,
                          height: 132,
                          fit: BoxFit.fitWidth,
                        ),
                      ],
                    ),
                  )),
            ),
            Positioned(
              bottom: 0, // Adjust to make it appear partially outside
              child: Container(
                width: 120,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.redAccent, Color(0xFFD42D3F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  // color: Colors.blue[400]+Color(0xf7b94848), // Lighter blue for contrast
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {
                        File? pickedFile = await GlobalClass().pickImage();
                        setState(() {
                          getDataFromOCR("adharFront", context, pickedFile);
                          _aadhaarImageF = pickedFile!;
                          imageSliders.clear();
                          updatelist();
                        });
                      },
                      child: _aadhaarImageF == null
                          ? Icon(Icons.add, color: Colors.white, size: 25)
                          : Text(
                        "Aadhaar Front",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        )));
    imageSliders.add(Container(
        height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background container
            Positioned(
              bottom: 20,
              child: Container(
                  width: 250,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.redAccent, Color(0xFFD42D3F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    // color: Colors.blue[700], // Darker blue background
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17)),
                    clipBehavior: Clip.antiAlias,
                    child: _aadhaarImageB == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Upload Aadhaar Back",
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(Icons.camera_alt,
                            color: Colors.white, size: 30),
                      ],
                    )
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.file(
                          File(_aadhaarImageB!.path),
                          width: MediaQuery.of(context).size.width - 50,
                          height: 132,
                          fit: BoxFit.fitWidth,
                        ),
                      ],
                    ),
                  )),
            ),
            // Floating bottom row
            Positioned(
              bottom: 0, // Adjust to make it appear partially outside
              child: Container(
                width: 120,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.redAccent, Color(0xFFD42D3F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  // color: Colors.blue[400], // Lighter blue for contrast
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {
                        File? pickedFile = await GlobalClass().pickImage();
                        setState(() {
                          getDataFromOCR("adharBack", context, pickedFile);
                          _aadhaarImageB = pickedFile!;
                          imageSliders.clear();
                          updatelist();
                        });
                      },
                      child: _aadhaarImageB == null
                          ? Icon(Icons.add, color: Colors.white, size: 25)
                          : Text(
                        "Aadhaar Back",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        )));
  }

  void updatelist2() {
    print("pickedFilepan $_panImage");

    idSliders.add(Container(
        height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background container
            Positioned(
              bottom: 20,
              child: Container(
                  width: 250,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.redAccent, Color(0xFFD42D3F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    //color: Colors.blue[700], // Darker blue background
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17)),
                    color: Colors.transparent,
                    clipBehavior: Clip.antiAlias,
                    child: _panImage == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Upload Pan",
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(Icons.camera_alt,
                            color: Colors.white, size: 30),
                      ],
                    )
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.file(
                          File(_panImage!.path),
                          width: MediaQuery.of(context).size.width - 50,
                          height: 132,
                          fit: BoxFit.fitWidth,
                        ),
                      ],
                    ),
                  )),
            ),
            // Floating bottom row
            Positioned(
              bottom: 0, // Adjust to make it appear partially outside
              child: Container(
                width: 120,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.redAccent, Color(0xFFD42D3F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  // color: Colors.blue[400], // Lighter blue for contrast
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {
                        File? pickedFile = await GlobalClass().pickImage();
                        print("pickedFile $pickedFile");
                        setState(() {
                          _panImage = pickedFile!;
                          kycFetched = true;
                          print("pickedFile22 $_panImage");
                          idSliders.clear();
                         updatelist2();
                        });
                      },
                      child: _panImage == null
                          ? Icon(Icons.add, color: Colors.white, size: 25)
                          : Text(
                        "Pan card",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        )));
    idSliders.add(Container(
        height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background container
            Positioned(
              bottom: 20,
              child: Container(
                  width: 250,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.redAccent, Color(0xFFD42D3F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    //color: Colors.blue[700], // Darker blue background
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17)),
                    color: Colors.transparent,
                    clipBehavior: Clip.antiAlias,
                    child: _dlImage == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Upload DL",
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(Icons.camera_alt,
                            color: Colors.white, size: 30),
                      ],
                    )
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.file(
                          File(_dlImage!.path),
                          width: MediaQuery.of(context).size.width - 50,
                          height: 132,
                          fit: BoxFit.fitWidth,
                        ),
                      ],
                    ),
                  )),
            ),
            // Floating bottom row
            Positioned(
              bottom: 0, // Adjust to make it appear partially outside
              child: Container(
                width: 120,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.redAccent, Color(0xFFD42D3F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  //color: Colors.blue[400], // Lighter blue for contrast
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {
                        File? pickedFile = await GlobalClass().pickImage();
                        setState(() {
                          _dlImage = pickedFile!;
                          kycFetched = true;
                          idSliders.clear();
                          updatelist2();
                        });
                      },
                      child: _dlImage == null
                          ? Icon(Icons.add, color: Colors.white, size: 25)
                          : Text(
                        "Driving License",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        )));
    idSliders.add(Container(
        height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background container
            Positioned(
              bottom: 20,
              child: Container(
                  width: 250,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.redAccent, Color(0xFFD42D3F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    //color: Colors.blue[700], // Darker blue background
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17)),
                    color: Colors.transparent,
                    clipBehavior: Clip.antiAlias,
                    child: _voterImage == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Upload Voter Id",
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(Icons.camera_alt,
                            color: Colors.white, size: 30),
                      ],
                    )
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.file(
                          File(_voterImage!.path),
                          width: MediaQuery.of(context).size.width - 50,
                          height: 132,
                          fit: BoxFit.fitWidth,
                        ),
                      ],
                    ),
                  )),
            ),
            // Floating bottom row
            Positioned(
              bottom: 0, // Adjust to make it appear partially outside
              child: Container(
                width: 120,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.redAccent, Color(0xFFD42D3F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  //color: Colors.blue[400], // Lighter blue for contrast
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {
                        File? pickedFile = await GlobalClass().pickImage();
                        setState(() {
                          _voterImage = pickedFile!;
                          kycFetched = true;
                          idSliders.clear();
                          updatelist2();
                        });
                      },
                      child: _voterImage == null
                          ? Icon(Icons.add, color: Colors.white, size: 25)
                          : Text(
                        "Voter Id",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        )));
  }



  Future<void> SelectDealer() async {
    print("2323");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            child: StatefulBuilder(
            builder: (context, setState) {
          // Start timer once the dialog opens

          return  AlertDialog(
          backgroundColor: Colors.white, // Red background
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                'Product',
                style: TextStyle(
                    color: Color(0xFFD42D3F), fontWeight: FontWeight.bold),textAlign: TextAlign.center,
              ),

              SizedBox(height: 5),
              Container(
                alignment: Alignment.center,
                height: 55,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButton<String>(
                  value: selectedProduct,
                  // Make sure this variable exists
                  isExpanded: true,
                  iconSize: 24,
                  iconEnabledColor: Colors.black,
                  dropdownColor: Colors.white,
                  elevation: 13,
                  style: TextStyle(
                    fontFamily: "Poppins-Regular",
                    color: Colors.black,
                    fontSize: 13,
                  ),
                  underline: Container(
                    height: 2,
                    color: Colors.transparent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedProduct = newValue!;
                    });
                  },
                  items: productList.map((String value) {
                    // Make sure this list exists
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),

              Text(
                'Dealer',
                style: TextStyle(
                    color: Color(0xFFD42D3F), fontWeight: FontWeight.bold),textAlign: TextAlign.center,
              ),

              SizedBox(height: 5),
              Container(
                alignment: Alignment.center,
                height: 55,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButton<String>(
                  value: selectedDealer,
                  // Make sure this variable exists
                  isExpanded: true,
                  iconSize: 24,
                  iconEnabledColor: Colors.black,
                  dropdownColor: Colors.white,
                  elevation: 13,
                  style: TextStyle(
                    fontFamily: "Poppins-Regular",
                    color: Colors.black,
                    fontSize: 13,
                  ),
                  underline: Container(
                    height: 2,
                    color: Colors.transparent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDealer = newValue!;
                    });
                  },
                  items: dealerList.map((String value) {
                    // Make sure this list exists
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 5),

              _buildShinyButton(
                'Submit',
                    () {
                  Navigator.pop(context);
                },
              ),

            ],
          ),
        );
            },
            ),
            onWillPop: () async => false);
    });
      }


  Widget _buildShinyButton(String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.redAccent, Color(0xFFD42D3F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              offset: Offset(5, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black.withOpacity(0.5),
                  offset: Offset(2.0, 2.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
