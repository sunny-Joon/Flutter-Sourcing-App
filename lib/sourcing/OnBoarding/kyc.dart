import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/Models/branch_model.dart';
import 'package:flutter_sourcing_app/const/validators.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:xml/xml.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sourcing_app/Models/global_model.dart';
import '../../DATABASE/database_helper.dart';
import '../../MasterAPIs/ckyc_repository.dart';
import '../../MasterAPIs/live_track_repository.dart';
import '../../Models/adhaar_model.dart';
import '../../Models/bank_names_model.dart';
import '../../Models/group_model.dart';
import '../../Models/place_codes_model.dart';
import '../../Models/range_category_model.dart';
import '../../api_service.dart';
import '../global_class.dart';
import 'on_boarding.dart';

class KYCPage extends StatefulWidget {
  final BranchDataModel data;
  final GroupDataModel GroupData;

  KYCPage({required this.data, required this.GroupData});

  @override
  _KYCPageState createState() => _KYCPageState();
}

class _KYCPageState extends State<KYCPage> {
  late ApiService apiService;
  late ApiService apiService_idc;
  late ApiService apiService_protean;
  late ApiService apiService_OCR;

  AdhaarDataModel? adhaardata;

  String nameReg = '[a-zA-Z. ]';
  String addReg = r'[a-zA-Z0-9. ()/,-]';
  String amountReg = '[0-9]';
  String cityReg = '[a-zA-Z ]';
  String IdsReg = '[a-zA-Z0-9/ ]';

  String FiType = "NEW";
  int _timeLeft = 60; // Timer starting at 60 seconds
  Timer? _timer;
  int imageStartIndex = 0;
  Color iconPan = Colors.red;
  Color iconDl = Colors.red;
  Color iconVoter = Colors.red;
  Color iconPassport = Colors.red;

  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  String? panCardHolderName ;
     // "Please search PAN card holder name for verification";
  String? dlCardHolderName;
  String? voterCardHolderName;
  List<RangeCategoryDataModel> states = [];
  List<RangeCategoryDataModel> marrital_status = [];
  List<RangeCategoryDataModel> relation = [];
  List<RangeCategoryDataModel> reasonForLoan = [];
  List<RangeCategoryDataModel> aadhar_gender = [];
  List<RangeCategoryDataModel> business_Type = [];
  List<RangeCategoryDataModel> income_type = [];
  List<RangeCategoryDataModel> bank = [];
  List<RangeCategoryDataModel> relationwithBorrower = [];
  List<PlaceData> listCityCodes = [];
  List<PlaceData> listDistrictCodes = [];
  List<PlaceData> listSubDistrictCodes = [];
  List<PlaceData> listVillagesCodes = [];
  PlaceData? selectedCityCode;
  PlaceData? selectedDistrictCode;
  PlaceData? selectedSubDistrictCode;
  PlaceData? selectedVillageCode;
  bool isCKYCNumberFound = false;
  List<String> loanDuration = ['Select', '12', '24', '36', '48'];

  List<String> titleList = ["Mr.", "Mrs.", "Miss"];
  String? selectedTitle;
  String expense = "";
  String income = "";
  String lati = "";
  String longi = "";
  String? selectedMarritalStatus;
  String? selectedLoanReason;

  RangeCategoryDataModel? stateselected;
  String genderselected = 'select';
  String relationwithBorrowerselected = 'select';
  String? bankselected;

  String? selectedloanDuration;
  String? _locationMessage;
  Position? position;
  bool otpVerified = false;
  bool _pageloading = true;

  bool verifyButtonClick = false;

  @override
  void initState() {
    apiService = ApiService.create(baseUrl: ApiConfig.baseUrl1);
    apiService_idc = ApiService.create(baseUrl: ApiConfig.baseUrl4);
    apiService_protean = ApiService.create(baseUrl: ApiConfig.baseUrl5);
    apiService_OCR = ApiService.create(baseUrl: ApiConfig.baseUrl6);
    // _focusNodeAdhaarId.addListener(_validateOnFocusChange);
    //    _mobileNoController.text="9910238307";
    fetchData();
    selectedloanDuration = loanDuration.isNotEmpty ? loanDuration[0] : null;
    _BabnkNamesAPI(context);
    // selectedTitle = titleList.isNotEmpty ? titleList[0] : null;

    geolocator(context);
    super.initState();
// Fetch states using the required cat_key
  }

  @override
  void dispose() {
    // _focusNodeAdhaarId
    //     .removeListener(_validateOnFocusChange); // Remove listener
    // _focusNodeAdhaarId.dispose(); // Dispose FocusNode when widget is disposed
    super.dispose();
  }

  Future<void> fetchData() async {
    states = await DatabaseHelper().selectRangeCatData("state");
    marrital_status =
        await DatabaseHelper().selectRangeCatData("marrital_status");
    relation = await DatabaseHelper().selectRangeCatData("relationship");
    reasonForLoan = await DatabaseHelper().selectRangeCatData("loan_purpose");
    aadhar_gender = await DatabaseHelper().selectRangeCatData("gender");
    business_Type = await DatabaseHelper()
        .selectRangeCatData("business-type"); // Call your SQLite method
    income_type = await DatabaseHelper()
        .selectRangeCatData("income-type"); // Call your SQLite method
    bank = await DatabaseHelper()
        .selectRangeCatData("banks"); // Call your SQLite method
    relationwithBorrower = await DatabaseHelper()
        .selectRangeCatData("relationship"); // Call your SQLite method

    setState(() {
      states.insert(
          0,
          RangeCategoryDataModel(
            catKey: 'Select',
            groupDescriptionEn: 'select',
            groupDescriptionHi: 'select',
            descriptionEn: 'Select',
            // Display text
            descriptionHi: 'select',
            sortOrder: 0,
            code: 'select', // Value of the placeholder
          ));
      // bank.insert(
      //     0,
      //     RangeCategoryDataModel(
      //       catKey: 'Select',
      //       groupDescriptionEn: 'select',
      //       groupDescriptionHi: 'select',
      //       descriptionEn: 'Select',
      //       // Display text
      //       descriptionHi: 'select',
      //       sortOrder: 0,
      //       code: 'select', // Value of the placeholder
      //     ));
      marrital_status.insert(
          0,
          RangeCategoryDataModel(
            catKey: 'Select',
            groupDescriptionEn: 'select',
            groupDescriptionHi: 'select',
            descriptionEn: 'Select',
            // Display text
            descriptionHi: 'select',
            sortOrder: 0,
            code: 'select', // Value of the placeholder
          ));
      relationwithBorrower.insert(
          0,
          RangeCategoryDataModel(
            catKey: 'Select',
            groupDescriptionEn: 'select',
            groupDescriptionHi: 'select',
            descriptionEn: 'Select',
            // Display text
            descriptionHi: 'select',
            sortOrder: 0,
            code: 'select', // Value of the placeholder
          ));
      aadhar_gender.insert(
          0,
          RangeCategoryDataModel(
            catKey: 'Select',
            groupDescriptionEn: 'select',
            groupDescriptionHi: 'select',
            descriptionEn: 'Select',
            // Display text
            descriptionHi: 'select',
            sortOrder: 0,
            code: 'select', // Value of the placeholder
          ));
    }); // Refresh the UI
    setState(() {
      _pageloading = false;
    });
  }

  // final _formKeys = List.generate(4, (index) => GlobalKey<FormState>());
  DateTime? _selectedDate;

  // TextEditingControllers for all input fields
  final _aadharIdController = TextEditingController();
  late var _nameController = TextEditingController();
  late var _nameMController = TextEditingController();
  late var _nameLController = TextEditingController();
  late var _ageController = TextEditingController();
  late var _dobController = TextEditingController();
  late var _mobileNoController = TextEditingController();
  late var _gurNameController = TextEditingController();
  late var _fatherFirstNameController = TextEditingController();
  late var _fatherMiddleNameController = TextEditingController();
  late var _fatherLastNameController = TextEditingController();
  late var _spouseFirstNameController = TextEditingController();
  late var _spouseMiddleNameController = TextEditingController();
  late var _spouseLastNameController = TextEditingController();
  late var _expenseController = TextEditingController();
  late var _incomeController = TextEditingController();
  late var _latitudeController = TextEditingController();
  late var _longitudeController = TextEditingController();
  late var _address1Controller = TextEditingController();
  late var _address2Controller = TextEditingController();
  late var _address3Controller = TextEditingController();
  late var _cityController = TextEditingController();
  late var _pincodeController = TextEditingController();
  late var _loan_amountController = TextEditingController();

  final _voterIdController = TextEditingController();
  final _passportController = TextEditingController();
  final _panNoController = TextEditingController();
  final _drivingLicenseController = TextEditingController();
  final _dlExpiryController = TextEditingController();
  final _passportExpiryController = TextEditingController();

  late List<BankNamesDataModel> bankNamesList = [];
  bool panVerified = false;
  bool dlVerified = false;
  bool voterVerified = false;
  String? dlDob;
  String? dobForProtien;
  String? dobForIDLC;
  String? dobForSaveFi;//2024-09-19
/*  String? selectedState;
  String? selectedEarningMemberType;
  String? selectedBusinessDetail;
  String? selectedLoanPurpose;
  String? selectedOccupation;
  String? selectedLoanDuration;
  String? selectedBank;*/
  String? Fi_Id;
  String? Fi_Code;
  String qrResult = "";
  File? _imageFile;
  // bool isPanVerified = false,
  //     isDrivingLicenseVerified = false,
  //     isVoterIdVerified = false,
  //     isPassportVerified = false;

  get isChecked => null;
  final FocusNode _focusNodeAdhaarId = FocusNode();

  String _errorMessageAadhaar = "";

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        //   _imageFile = File(pickedImage.path);
        _cropImage(File(pickedImage.path)!);
      });
    }
  }

  Future _cropImage(File imageFile) async {
    if (imageFile != null) {
      CroppedFile? cropped = await ImageCropper().cropImage(
          sourcePath: imageFile!.path,
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
                lockAspectRatio: false),
            IOSUiSettings(title: 'Crop')
          ]);

      if (cropped != null) {
        setState(() {
          _imageFile = File(cropped.path);
          //  filePicked=1;
        });
      }
    }
  }

  Widget _buildDatePickerField(BuildContext context, String labelText,
      TextEditingController controller, String type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: () => _selectDate2(context, controller, type),
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
      ),
    );
  }

  void _validateOnFocusChange() {
    setState(() {
      if (_aadharIdController.text.isEmpty) {
        _errorMessageAadhaar = AppLocalizations.of(context)!.aadhaaridfieldcannotbeempty;
      } else if (_aadharIdController.text.length != 12) {
        _errorMessageAadhaar = AppLocalizations.of(context)!.aadhaarmustbecharacterslong;
      } else if (!Validators.validateVerhoeff(_aadharIdController.text)) {
        _errorMessageAadhaar = AppLocalizations.of(context)!.aadhaaridisnotvalid;
      } else {
        _errorMessageAadhaar = "";
        if (_aadharIdController.text.length == 12) {
          adhaarAllData(context);
        }
      }
    });
  }

  void _selectDate(BuildContext context, TextEditingController controller, String type) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().isBefore(DateTime(DateTime.now().year - 21,
              DateTime.now().month, DateTime.now().day))
          ? DateTime.now()
          : DateTime(DateTime.now().year - 21, DateTime.now().month,
              DateTime.now().day),
      firstDate: DateTime(DateTime.now().year - 60, DateTime.now().month,
          DateTime.now().day), // You can set this to any reasonable past date
      lastDate: DateTime(
          DateTime.now().year - 21, DateTime.now().month, DateTime.now().day),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.black,
            hintColor: Colors.black,
            colorScheme: ColorScheme.light(
              primary: Color(0xFFD42D3F),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (type == "dob") {
          _selectedDate = picked;
          _dobController.text = DateFormat('dd-MM-yyyy').format(picked);
          dlDob = DateFormat('dd-MM-yyyy').format(picked);
          dobForSaveFi = DateFormat('yyyy-MM-dd').format(picked);
          dobForIDLC = DateFormat('yyyy/MM/dd').format(picked);
          dobForProtien = DateFormat('dd-MM-yyyy').format(picked);

          print("formattedDate1 $dlDob");
          print("formattedDate2 ${_dobController.text}");
          print("formattedDate2 ${dobForSaveFi}");
          print("formattedDate2 ${dobForIDLC}");
          print("formattedDate2 ${dobForProtien}");

          _calculateAge();
        }
      });
    }
    // if (controller == _dobController) {
    //   _calculateAge();
    // }
  }

  void _selectDate2(BuildContext context, TextEditingController controller,
      String type) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Only future dates
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.black,
            hintColor: Colors.black,
            colorScheme: ColorScheme.light(
              primary: Color(0xFFD42D3F),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
      /*  if (type == "dob") {
         *//* _selectedDate = picked;
          _dobController.text = DateFormat('dd-MM-yyyy').format(picked);
          dlDob = DateFormat('dd-MM-yyyy').format(picked);
          _calculateAge();*//*
        } else */if (type == "passExp") {
          _passportExpiryController.text =
              DateFormat('dd-MM-yyyy').format(picked);
        } else if (type == "dlExp") {
          _dlExpiryController.text = DateFormat('dd-MM-yyyy').format(picked);
        }
      });
    }
    // if (controller == _dobController) {
    //   _calculateAge();
    // }
  }

  /*Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime initialDate = _selectedDate ?? now;

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('yyyy/MM/dd').format(picked);
        print(_dobController.text);
      });
      _calculateAge();
    }
  }*/

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

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (bool value) {
          _onWillPop();
        },
        child: Scaffold(
          backgroundColor: Color(0xFFD42D3F),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.all(0),
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
                                    Icon(Icons.arrow_back_ios_sharp, size: 16),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();

                              /*if (_currentStep == 1) {
                                setState(() {
                                  Navigator.of(context).pop();
                                });
                              } else {
                                Navigator.of(context).pop();
                              }*/
                            },
                          ),
                          Center(
                            child: Image.asset(
                              'assets/Images/logo_white.png',
                              // Replace with your logo asset path
                              height: 30,
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            alignment: Alignment.center,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        //  _buildProgressIndicator(),
                        SizedBox(height: 30),
                        _pageloading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height -
                                        244,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black,
                                                blurRadius: 7,
                                              ),
                                            ],
                                          ),
                                          child: Form(
                                            key: _formKey,
                                            child: _getStepContent(context),
                                          ),
                                        ),
                                        Positioned(
                                          top:
                                              -35, // Adjust the position as needed
                                          left: 0,
                                          right: 0,
                                          child: Center(
                                            child: InkWell(
                                              onTap: () async {
                                                if (_currentStep == 0) {
                                                  File? pickedFile =
                                                      await GlobalClass()
                                                          .pickImage();
                                                  setState(() {
                                                    _imageFile = pickedFile;
                                                  });
                                                }
                                              },
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  ClipOval(
                                                    child: Container(
                                                      width: 70,
                                                      height: 70,
                                                      color:
                                                          Colors.grey.shade300,
                                                      child: _imageFile == null
                                                          ? Icon(
                                                              Icons.person,
                                                              size: 50.0,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : Image.file(
                                                              File(_imageFile!
                                                                  .path),
                                                              width: 70,
                                                              height: 70,
                                                              fit: BoxFit.cover,
                                                            ),
                                                    ),
                                                  ),
                                                  (_currentStep == 0)
                                                      ? Positioned(
                                                          bottom: 0,
                                                          right: 0,
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.blue,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            child: Icon(
                                                              Icons.edit,
                                                              size: 16,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                  _buildNextButton(context),
                                ],
                              )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  int calculateAgeFromString(String dateString,
      {String format = "yyyy-MM-dd"}) {
    try {
      // Parse the string date
      DateTime birthDate = DateFormat(format).parse(dateString);

      // Calculate age
      DateTime today = DateTime.now();
      int age = today.year - birthDate.year;

      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }

      return age;
    } catch (e) {
      // Handle parsing error
      print("Error parsing date: $e");
      return -1; // Return an invalid age to indicate error
    }
  }

  int calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;

    // Adjust for the month and day
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  void showToast_Error(String message) {
    Fluttertoast.showToast(
      msg: "$message",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 3),
      padding: EdgeInsets.all(1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                fontFamily: "Poppins-Regular", fontSize: 13, height: 2),
          ),
          SizedBox(height: 1),
          Container(
              padding: EdgeInsets.zero,
              width: double.infinity, // Set the desired width
              child: Center(
                child: TextFormField(
                  style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
                  controller: controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter $label';
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(addReg)),
                    TextInputFormatter.withFunction(
                      (oldValue, newValue) => TextEditingValue(
                        text: newValue.text.toUpperCase(),
                        selection: newValue.selection,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Future<void> saveFiMethod(BuildContext context) async {
    print("Sunny");
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        EasyLoading.show(
          status: AppLocalizations.of(context)!.loading,
        );
      });

      String adhaarid = _aadharIdController.text.toString();
      String title = selectedTitle ?? "";
      String name = _nameController.text.toString();
      String middlename = _nameMController.text.toString();
      String lastname = _nameLController.text.toString();
      String dob = dobForSaveFi!;
      String age = _ageController.text.toString();
      String gender = genderselected.toString();
      String guardianName  = _gurNameController.text.toString();
      print("gender13 $gender");
      print("Guardian_Name $guardianName");
      String mobile = _mobileNoController.text.toString();
      String fatherF = _fatherFirstNameController.text.toString();
      String fatherM = _fatherMiddleNameController.text.toString();
      String fatherL = _fatherLastNameController.text.toString();
      String spouseF = _spouseFirstNameController.text.toString();
      String spouseM = _spouseMiddleNameController.text.toString();
      String spouseL = _spouseLastNameController.text.toString();
      expense = _expenseController.text;
      income = _incomeController.text;
      lati = _latitudeController.text;
      longi = _longitudeController.text;
      int Expense =
          (expense != null && expense.isNotEmpty) ? int.parse(expense) : 0;
      int Income =
          (income != null && income.isNotEmpty) ? int.parse(income) : 0;
      double latitude =
          (lati != null && lati.isNotEmpty) ? double.parse(lati) : 0.0;
      double longitude =
          (longi != null && longi.isNotEmpty) ? double.parse(longi) : 0.0;
      String add1 = _address1Controller.text.toString();
      String add2 = _address2Controller.text.toString();
      String add3 = _address3Controller.text.toString();
      String city = _cityController.text.toString();
      String pin = _pincodeController.text.toString();
      String state = stateselected!.code.toString();
      bool ismarried = selectedMarritalStatus.toString() == 'Married';
      print("married $ismarried");
      String gCode = widget.GroupData.groupCode;
      String bCode = widget.data.branchCode.toString();

      String relation_with_Borrower = relationwithBorrowerselected;
      String bank_name = bankselected!.toString();
      print("bank $bank_name");
      String loan_Duration = selectedloanDuration!;
      String loan_amount = _loan_amountController.text.toString();

      int ModuleTypeId = GlobalClass.creator.toLowerCase().startsWith("vh") ? 2 : 1;
      print("ModuleTypeId $ModuleTypeId");

      final api = Provider.of<ApiService>(context, listen: false);

      await api
          .saveFi(
        GlobalClass.token,
        GlobalClass.dbName,
        adhaarid,
        title,
        name,
        middlename,
        lastname,
        dob,
        age,
        gender,
        guardianName,
        mobile,
        fatherF,
        fatherM,
        fatherL,
        spouseF,
        spouseM,
        spouseL,
        GlobalClass.creator,
        Expense,
        Income,
        latitude,
        longitude,
        add1,
        add2,
        add3,
        city,
        pin,
        state,
        ismarried,
        gCode,
        bCode,
        relation_with_Borrower,
        bank_name,
        loan_Duration,
        loan_amount,
        selectedLoanReason!,
        GlobalClass.creatorId,
        ModuleTypeId,
        _imageFile!,
      )
          .then((value) async {
        if (value.statuscode == 200) {
          EasyLoading.dismiss();
          getPlace("city", stateselected!.code, "", "");
          getPlace("district", stateselected!.code, "", "");
          setState(() {
            EasyLoading.dismiss();
            _currentStep += 1;
            Fi_Id = value.data[0].fiId.toString();
            GlobalClass.Fi_Id=value.data[0].fiId;
            Fi_Code = value.data[0].fiCode.toString();
            GlobalClass.ficode = value.data[0].fiCode.toString();

          });
        } else if (value.statuscode == 201) {
          EasyLoading.dismiss();
          print("status code 201");
          GlobalClass.showAlert(
            context,
            value.message,
            value.data[0].errormsg,
            Colors.red,
            1,
          );
        } else if (value.statuscode == 400) {
          EasyLoading.dismiss();
          GlobalClass.showSnackBar(context, "Something went wrong in API");
        }
        EasyLoading.dismiss();
      }).catchError((error) {
        GlobalClass.showSnackBar(context, "Error: ${error.toString()}");
        EasyLoading.dismiss();
      });
    } catch (e) {
      GlobalClass.showSnackBar(
          context, "An unexpected error occurred: ${e.toString()}");
      EasyLoading.dismiss();
    }
  }

  Future<void> saveIDsMethod(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      EasyLoading.show(
        status: AppLocalizations.of(context)!.loading,
      );
    });

    print("object");
    String fiid = Fi_Id.toString();
    String pan_no = _panNoController.text.toString();
    String dl = _drivingLicenseController.text.toString();
    String? DLExpireDate = _dlExpiryController.text.toString().isEmpty
        ? null
        : DateFormat('yyyy-MM-dd')
            .format(DateFormat('dd-MM-yyyy').parse(_dlExpiryController.text));
    String voter_id = _voterIdController.text.toString();
    String passport = _passportController.text.toString();
    String? PassportExpireDate =
        _passportExpiryController.text.toString().isEmpty
            ? null
            : _passportExpiryController.text;
    int isAadharVerified = 1;
    int is_phnno_verified = 1;
    int isNameVerify = 1;

    String AdharName = "";

    if (adhaardata != null && (adhaardata!.fName.isNotEmpty || adhaardata!.mName.isNotEmpty || adhaardata!.lName.isNotEmpty)) {
      AdharName = "${adhaardata!.fName} ${adhaardata!.mName} ${adhaardata!.lName}".trim();
    } else {
      AdharName = _nameController.text.trim();
      if (_nameMController.text.isNotEmpty && _nameLController.text.isNotEmpty) {
        AdharName = "${_nameController.text} ${_nameMController.text} ${_nameLController.text}".trim();
      } else if (_nameMController.text.isNotEmpty) {
        AdharName = "${_nameController.text} ${_nameMController.text}".trim();
      } else if (_nameLController.text.isNotEmpty) {
        AdharName = "${_nameController.text} ${_nameLController.text}".trim();
      }
    }


    print("AdharName $AdharName");

    /*var fields = {
      "Pan No.": pan_no,
      "Driving License": dl,
      "DL Expire Date": DLExpireDate,
      "Voter Id": voter_id,
      "Passport": passport,
      "Passport Expire Date": PassportExpireDate,
    };

    for (var field in fields.entries) {
      if (field.value == null || field.value!.isEmpty) {
        showAlertDialog(context, "Please fill in the ${field.key} field.");
        return;
      }
    }*/
    final api = Provider.of<ApiService>(context, listen: false);
     print("_nameController121 ${_nameController.text}");
    Map<String, dynamic> requestBody = {
      "Fi_ID": fiid,
      "pan_no": pan_no,
      "dl": dl,
      "voter_id": voter_id,
      "passport": passport,
      "PassportExpireDate": PassportExpireDate,
      "isAadharVerified": isAadharVerified,
      "is_phnno_verified": is_phnno_verified,
      "isNameVerify": isNameVerify,
      "Pan_Name": panCardHolderName,
      "VoterId_Name": voterCardHolderName,
      "Aadhar_Name": AdharName,
      "DrivingLic_Name": dlCardHolderName,
      "VILLAGE_CODE": selectedVillageCode!.villageCode,
      "CITY_CODE": selectedCityCode!.cityCode,
      "SUB_DIST_CODE": selectedSubDistrictCode!.subDistCode,
      "DIST_CODE": selectedDistrictCode!.distCode,
      "STATE_CODE": stateselected!.code,
      "DLExpireDate": DLExpireDate,
    };

    print("Fi_ID: $fiid,");
    print("pan_no: $pan_no,");
    print("dl: $dl,");
    print("voter_id: $voter_id,");
    print("passport: $passport,");
    print("PassportExpireDate: $PassportExpireDate,");
    print("isAadharVerified: $isAadharVerified,");
    print("is_phnno_verified: $is_phnno_verified,");
    print("isNameVerify: $isNameVerify,");
    print("Pan_Name: $panCardHolderName,");
    print("VoterId_Name: $voterCardHolderName,");
    print("Aadhar_Name: $AdharName,");
    print("DrivingLic_Name: $dlCardHolderName,");
    print("VILLAGE_CODE: $selectedVillageCode!.villageCode,");
    print("CITY_CODE: $selectedCityCode!.cityCode,");
    print("SUB_DIST_CODE: $selectedSubDistrictCode!.subDistCode,");
    print("DIST_CODE: $selectedDistrictCode!.distCode,");
    print("STATE_CODE: $stateselected!.code,");
    print("DLExpireDate: $DLExpireDate,");
    return await api
        .addFiIds(GlobalClass.token, GlobalClass.dbName, requestBody)
        .then((value) async {
      if (value.statuscode == 200) {
        EasyLoading.dismiss();
        LiveTrackRepository().saveLivetrackData("", "KYC Done", int.parse(fiid));

        setState(() {
          _currentStep += 1;
        });
        EasyLoading.dismiss();
        GlobalClass.showSuccessAlertclose(
          context,
          "KYC Saved with ${Fi_Code} and ${GlobalClass.creator} successfully!! \nPlease note these details for further process",
          1,
          destinationPage: OnBoarding(),
        );
      //  _showSuccessAndRedirect(value);

        // GlobalClass.showSuccessAlert(
        //     context,
        //     "KYC Saved with ${Fi_Code} and ${GlobalClass.creator} successfully!! \nPlease note these details for further process",
        //
        //     2);
      } else {
        EasyLoading.dismiss();
        GlobalClass.showUnsuccessfulAlert(context, value.message, 1);
      }
    }).catchError((onError) {
      EasyLoading.dismiss();
      GlobalClass.showErrorAlert(context, onError, 1);
    });
  }

  void savePersonalDetailsMethod() {}

  void saveDataMethod() {}

  Widget _buildTextField2(String label, TextEditingController controller, TextInputType inputType, int maxlength, String regex) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 3),
      padding: EdgeInsets.all(1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                fontFamily: "Poppins-Regular", fontSize: 13, height: 2),
          ),
          Container(
            width: double.infinity, // Set the desired width
            child: Center(
              child: TextFormField(
                style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),

                maxLength: maxlength,
                controller: controller,
                keyboardType: inputType, // Set the input type
                decoration: InputDecoration(
                    border: OutlineInputBorder(), counterText: ""),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter $label';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(regex)),
                  TextInputFormatter.withFunction(
                    (oldValue, newValue) => TextEditingValue(
                      text: newValue.text.toUpperCase(),
                      selection: newValue.selection,
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (label == AppLocalizations.of(context)!.voter) {
                    setState(() {
                      voterVerified = false;
                      voterCardHolderName = "";
                    });
                  } else if (label == AppLocalizations.of(context)!.dl) {
                    print('DL');
                    setState(() {
                      dlVerified = false;
                      dlCardHolderName = "";

                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

 /* void _showSuccessAndRedirect(GlobalModel value) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(
              "KYC Saved with ${Fi_Code} and ${GlobalClass.creator} successfully!! \nPlease note these details for further process"),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => OnBoarding()),
                );
              },
            ),],
        );
      },
    );
  }
*/
  void _showPopup(BuildContext context, Function(String) onResult) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(16.0),
            // Add padding around the content
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Adhaar Front Button
                SizedBox(
                  width: double.infinity, // Match the width of the dialog
                  child: TextButton(
                    onPressed: () async {
                      getDataFromOCR("adharFront", context);
                    },
                    child: Text(
                        AppLocalizations.of(context)!.adhaarfront,
                      style: TextStyle(
                          fontFamily: "Poppins-Regular", color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFFD42D3F),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5), // Adjust as needed
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10), // Space between buttons
                // Adhaar Back Button
                SizedBox(
                  width: double.infinity, // Match the width of the dialog
                  child: TextButton(
                    onPressed: () {
                      getDataFromOCR("adharBack", context);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.adhaarback,
                      style: TextStyle(
                          fontFamily: "Poppins-Regular", color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFFD42D3F),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5), // Adjust as needed
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10), // Space between buttons
                // Adhaar QR Button
                SizedBox(
                  width: double.infinity, // Match the width of the dialog
                  child: TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      try {
                        final result = await callJavaMethodQr(); // Call the method directly

                        if (result != null) {
                          print("QR Data: $result");

                          setQRData(result.replaceAll('[', "").replaceAll(']', "")); // Process the result as needed
                        }
                      } catch (e) {
                        print("Error: $e");
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!.aadhaarqr,
                      style: TextStyle(
                        fontFamily: "Poppins-Regular",
                        color: Colors.white,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFFD42D3F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // Adjust as needed
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
      dobForSaveFi = DateFormat('yyyy-MM-dd').format(parsedDate);
      dobForIDLC = DateFormat('yyyy/MM/dd').format(parsedDate);
      dobForProtien = DateFormat('dd-MM-yyyy').format(parsedDate);

      print("formattedDate1 $dlDob");
      print("formattedDate2 ${_dobController.text}");
      print("formattedDate2 ${dobForSaveFi}");
      print("formattedDate2 ${dobForIDLC}");
      print("formattedDate2 ${dobForProtien}");
      // Return the formatted date string in yyyy-MM-dd format
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      // Handle any invalid format
      return 'Invalid Date';
    }
  }

  Future<void> getDataFromOCR(String type, BuildContext context) async {
    File? pickedImage = await GlobalClass().pickImage();

    if (pickedImage != null) {
      EasyLoading.show();
      try {
        final response = await apiService_OCR.uploadDocument(
          type, // imgType
          pickedImage!, // File
        );
        if (response.statusCode == 200) {
          EasyLoading.dismiss();
          if (type == "adharFront") {
            setState(() {
              _aadharIdController.text = response.data.adharId;
              List<String> nameParts = response.data.name.trim().split(" ");
              if (nameParts.length == 1) {
                _nameController.text = nameParts[0];
              } else if (nameParts.length == 2) {
                _nameController.text = nameParts[0];
                _nameLController.text = nameParts[1];
              } else {
                _nameController.text = nameParts.first;
                _nameLController.text = nameParts.last;
                _nameMController.text =
                    nameParts.sublist(1, nameParts.length - 1).join(' ');
              }
              _dobController.text = formatDate(response.data.dob, 'dd/MM/yyyy');

              genderselected = aadhar_gender.firstWhere((item) =>
                      item.descriptionEn.toLowerCase() ==
                      response.data.gender.toLowerCase())
                  .descriptionEn;
              if (genderselected == "Male") {
                selectedTitle = "Mr.";
              } else {
                selectedTitle = "Mrs.";
              }
            });
            Navigator.of(context).pop();
          } else if (type == "adharBack") {
            setState(() {
              _pincodeController.text = response.data.pincode;
              _cityController.text = response.data.cityName;
              String cleanAddress(String name) {
                // Remove unwanted characters
                String cleanedAddrName =
                    name.replaceAll(RegExp(r'[^a-zA-Z0-9\s\-\(\)\./\\]'), '');

                // Replace multiple consecutive special characters with a single instance
                cleanedAddrName = cleanedAddrName.replaceAllMapped(
                    RegExp(r'(\s\s+|\-\-+|\(\(+|\)\)+|\.{2,}|/{2,}|\\{2,})'),
                    (match) {
                  // Get the matched string and determine the appropriate replacement
                  String matchedString = match.group(0)!;
                  if (matchedString.contains('-')) return '-';
                  if (matchedString.contains('(')) return '(';
                  if (matchedString.contains(')')) return ')';
                  if (matchedString.contains('.')) return '.';
                  if (matchedString.contains('/')) return '/';
                  if (matchedString.contains('\\')) return '\\';
                  return ' ';
                });
                return cleanedAddrName;
              }

              String cleanedAddName = cleanAddress(response.data.address1);
              print("Cleaned Address: $cleanedAddName");

              List<String> addressParts = cleanedAddName.split(" ");
              String address1 = '';
              String address2 = '';
              String address3 = '';

              if (addressParts.length >= 6) {
                address1 = addressParts.take(3).join(" ");  // First 3 words
                address2 = addressParts.sublist(3, 5).join(" ");  // 4th & 5th words
                address3 = addressParts.sublist(5).join(" ");  // Remaining words
              } else if (addressParts.length >= 4) {
                address1 = addressParts.take(3).join(" ");
                address2 = addressParts.sublist(3).join(" ");  // Remaining words go into address2
              } else if (addressParts.length == 3) {
                address1 = addressParts.take(2).join(" ");
                address2 = addressParts[2];
              } else if (addressParts.length == 2) {
                address1 = addressParts[0];
                address2 = addressParts[1];
              } else if (addressParts.length == 1) {
                address1 = addressParts[0];
              }

              _address1Controller.text = address1;
              _address2Controller.text = address2;
              _address3Controller.text = address3;

              print("Address1: $address1");
              print("Address2: $address2");
              print("Address3: $address3");


              _address1Controller.text = address1;
              _address2Controller.text = address2;
              _address3Controller.text = address3;
              print("Address1: $address1");
              print("Address2: $address2");
              print("Address3: $address3");

              if (response.data.relation.toLowerCase() == "father") {
                String cleanGuardianName(String name) {
                  return name.replaceAll(RegExp(r'[^a-zA-Z0-9.\s]'), '');
                }

                String cleanedGuardianName =
                    cleanGuardianName(response.data.guardianName);
                // print(cleanedGuardianName $cleanedGuardianName);
                _gurNameController.text = cleanedGuardianName;
                relationwithBorrowerselected = "Father";


                List<String> guarNameParts =
                    _gurNameController.text.trim().split(" ");
                if (guarNameParts.length == 1) {
                  _fatherFirstNameController.text = guarNameParts[0];
                } else if (guarNameParts.length == 2) {
                  _fatherFirstNameController.text = guarNameParts[0];
                  _fatherLastNameController.text = guarNameParts[1];
                } else {
                  _fatherFirstNameController.text = guarNameParts.first;
                  _fatherLastNameController.text = guarNameParts.last;
                  _fatherMiddleNameController.text = guarNameParts
                      .sublist(1, guarNameParts.length - 1)
                      .join(' ');
                }
              }
              else if (response.data.relation.toLowerCase() == "husband") {
                relationwithBorrowerselected = "Husband";
                selectedMarritalStatus = "Married";
                // selectedMarritalStatus = true;

                String cleanGuardianName(String name) {
                  return name.replaceAll(RegExp(r'[^a-zA-Z0-9.\s]'), '');
                }

                String cleanedGuardianName =
                    cleanGuardianName(response.data.guardianName);

                _gurNameController.text = cleanedGuardianName;

                List<String> guarNameParts =
                    cleanedGuardianName.trim().split(" ");

                if (guarNameParts.length == 1) {
                  _spouseFirstNameController.text = guarNameParts[0];
                } else if (guarNameParts.length == 2) {
                  _spouseFirstNameController.text = guarNameParts[0];
                  _spouseLastNameController.text = guarNameParts[1];
                } else {
                  _spouseFirstNameController.text = guarNameParts.first;
                  _spouseLastNameController.text = guarNameParts.last;
                  _spouseMiddleNameController.text = guarNameParts
                      .sublist(1, guarNameParts.length - 1)
                      .join(' ');
                }


              }
              stateselected = states
                  .firstWhere((item) =>
              item.descriptionEn.toLowerCase() ==
                  response.data.stateName.toLowerCase());
            });
            Navigator.of(context).pop();

            EasyLoading.dismiss();
          }
        } else {
          showToast_Error(
            AppLocalizations.of(context)!.datanotfetchedfromthisaadhaarleasechecktheimage);
          Navigator.of(context).pop();
          EasyLoading.dismiss();
        }
      } catch (_) {
        showToast_Error(
            AppLocalizations.of(context)!.datanotfetchedfromthisaadhaarleasechecktheimage);
        Navigator.of(context).pop();
        EasyLoading.dismiss();
      }
    }
  }

  List<List<int>> separateData(
      List<int> source, int separatorByte, int vtcIndex) {
    List<List<int>> separatedParts = [];
    int begin = 0;

    for (int i = 0; i < source.length; i++) {
      if (source[i] == separatorByte) {
        // Skip if first or last byte is a separator
        if (i != 0 && i != (source.length - 1)) {
          // Copy the range from 'begin' to 'i' (exclusive)
          separatedParts.add(source.sublist(begin, i));
        }
        begin = i + 1;

        // Check if we have got all the parts of text data
        if (separatedParts.length == (vtcIndex + 1)) {
          // This is required to extract image data
          // Assuming imageStartIndex is a global variable
          imageStartIndex = begin;
          break;
        }
      }
    }
    return separatedParts;
  }

  String decodeData(List<List<int>> encodedData) {
    String test = "";
    List<String> decodedData = [];

    for (var byteArray in encodedData) {
      // Decode using ISO-8859-1
      String decodedString =
          utf8.decode(byteArray); // Change to ISO-8859-1 if necessary
      decodedData.add(decodedString);

      test += decodedString;
      print(test);
    }

    return test;
  }

  List<int> bigIntToBytes(BigInt bigInt) {
    // Convert BigInt to a byte array (List<int>)
    List<int> byteArray = [];
    while (bigInt > BigInt.zero) {
      byteArray.add((bigInt & BigInt.from(0xFF)).toInt());
      bigInt = bigInt >> 8; // Shift right by 8 bits
    }
    return byteArray.reversed.toList(); // Reverse to maintain byte order
  }

  List<int> decompressData(List<int> byteScanData) {
    print(" Prints the first few bytes"); // Prints the first few bytes
    // Print data in hexadecimal format for better debugging
    String hexData = byteScanData
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join(' ');
    print('Data in hexadecimal: $hexData'); // Prints the first few bytes
    try {
      // Decompress the GZIP data
      List<int> decompressedData = GZipDecoder().decodeBytes(byteScanData);

      return decompressedData; // Return decompressed data as List<int>
    } catch (e) {
      print('Exception: Decompressing QRcode failed: $e');
      // Handle error appropriately (e.g., throw a custom exception)
      return []; // Returning an empty List<int> on error
    }
  }

  Future<void> geolocator(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      EasyLoading.show(
        status: AppLocalizations.of(context)!.loading,
      );
    });
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
              AppLocalizations.of(context)!.unabletofetchthelocation),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                geolocator(context); // Retry fetching the location
              },
              child: Text(AppLocalizations.of(context)!.retry),
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

  void _onRefreshButtonClick() async {
    await geolocator(context); // Call to get location and update fields
  }

  /*Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _stepIndicator(0),
        _lineIndicator(),
        _stepIndicator(1),
      ],
    );
  }*/

  /* Widget _stepIndicator(int step) {
    bool isActive = _currentStep == step;
    bool isCompleted = _currentStep > step;
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted
            ? Colors.greenAccent
            : (isActive ? Colors.green : Colors.grey.shade300),
      ),
      child: CircleAvatar(
        radius: 12,
        backgroundColor: isCompleted ? Colors.green : Colors.white,
        child: Text(
          (step + 1).toString(),
          style: TextStyle(
              color: isCompleted
                  ? Colors.white
                  : (isActive ? Colors.red : Colors.grey)),
        ),
      ),
    );
  }

  Widget _lineIndicator() {
    return Container(
      width: 20,
      height: 2,
      color: Colors.grey.shade300,
    );
  }*/

  Widget _getStepContent(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return _buildStepOne(context);
      case 1:
        return _buildStepTwo(context);
      default:
        return _buildStepOne(context);
    }
  }

  Widget _buildStepOne(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: Container(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 0),
              padding: EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.adhar,
                    style: TextStyle(
                        fontFamily: "Poppins-Regular", fontSize: 13, height: 2),
                  ),
                  SizedBox(height: 1),
                  Container(
                      padding: EdgeInsets.zero,
                      width: double.infinity,
                      child: Center(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          maxLength: 12,
                          style: TextStyle(
                              fontFamily: "Poppins-Regular", fontSize: 13),
                          focusNode: _focusNodeAdhaarId,
                          controller: _aadharIdController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              errorText: _errorMessageAadhaar.isEmpty
                                  ? null
                                  : _errorMessageAadhaar,
                              counterText: ""),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.aadhaaridfieldcannotbeempty;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _validateOnFocusChange();
                          },
                        ),
                      )),
                ],
              ),
            )),
            Padding(
              padding: EdgeInsets.only(top: 20),
              // Add 10px padding from above
              child: GestureDetector(
                onTap: () => _showPopup(context, (String result) {
                  setState(() {
                    qrResult = result;
                  });
                }), // Show popup on image click
                child: Icon(
                  Icons.qr_code_2_sharp,
                  size: 50.0, // Set the size of the icon
                  color: Colors.grey, // Set the color of the icon
                ),
              ),
            )
          ],
        ),

        Row(
          children: [
            SizedBox(
              width: 95, // Fixed width for the Title dropdown
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    AppLocalizations.of(context)!.title,
                    style:
                        TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Container(
                    alignment: Alignment.center,

                    height: 55,
                    // Fixed height
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton<String>(
                      value: selectedTitle,
                      isExpanded: true,
                      iconSize: 24,
                      hint: Text('Select'),
                      elevation: 16,
                      style: TextStyle(
                          fontFamily: "Poppins-Regular",
                          color: Colors.black,
                          fontSize: 13),
                      underline: Container(
                        height: 2,
                        color: Colors
                            .transparent, // Set to transparent to remove default underline
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedTitle = newValue!;
                        });
                      },
                      items: titleList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            // Add spacing between Title dropdown and Name field if needed
            Expanded(
              child: _buildTextField2(AppLocalizations.of(context)!.name,
                  _nameController, TextInputType.text, 30, nameReg),
            ),
          ],
        ),

        Row(
          children: [
            Expanded(
                child: _buildTextField2(AppLocalizations.of(context)!.mname,
                    _nameMController, TextInputType.text, 30, nameReg)),
            SizedBox(width: 10),
            // Add spacing between the text fields if needed
            Expanded(
                child: _buildTextField2(AppLocalizations.of(context)!.lname,
                    _nameLController, TextInputType.text, 30, nameReg)),
          ],
        ),

        Container(
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 3),
          padding: EdgeInsets.all(1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.gurname,
                style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
              ),
              SizedBox(height: 1),
              Container(
                  padding: EdgeInsets.zero,
                  width: double.infinity, // Set the desired width
                  child: Center(
                    child: TextFormField(
                        style: TextStyle(
                            fontFamily: "Poppins-Regular", fontSize: 13),
                        maxLength: 50,
                        controller: _gurNameController,
                        decoration: InputDecoration(
                          counterText: "",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.pleaseenterguardianname;
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(
                              nameReg)), // Allow only alphanumeric characters // Optional: to deny spaces
                          TextInputFormatter.withFunction(
                            (oldValue, newValue) => TextEditingValue(
                              text: newValue.text.toUpperCase(),
                              selection: newValue.selection,
                            ),
                          ),
                        ]),
                  )),
            ],
          ),
        ),

        Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                Text(
                  AppLocalizations.of(context)!.gender,
                  style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  alignment: Alignment.center,

                  width: 150,
                  // Adjust the width as needed
                  height: 55,
                  // Fixed height
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton<String>(
                    value: genderselected,
                    isExpanded: true,
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(
                        fontFamily: "Poppins-Regular",
                        color: Colors.black,
                        fontSize: 13),
                    underline: Container(
                      height: 2,
                      color: Colors
                          .transparent, // Set to transparent to remove default underline
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          genderselected =
                              newValue; // Update the selected value
                        });
                      }
                    },
                    items: aadhar_gender.map<DropdownMenuItem<String>>(
                      (RangeCategoryDataModel state) {
                        return DropdownMenuItem<String>(
                          value: state.code,
                          child: Text(state.descriptionEn),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ],
            )),
            SizedBox(width: 10),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                Text(
                  AppLocalizations.of(context)!.relationship,
                  style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  alignment: Alignment.center,

                  width: 150,
                  // Adjust the width as needed
                  height: 55,
                  // Fixed height
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton<String>(
                    value: relationwithBorrowerselected,
                    isExpanded: true,
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(
                        fontFamily: "Poppins-Regular",
                        color: Colors.black,
                        fontSize: 13),
                    underline: Container(
                      height: 2,
                      color: Colors
                          .transparent, // Set to transparent to remove default underline
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          relationwithBorrowerselected =
                              newValue; // Update the selected value
                        });
                      }
                    },
                    items: relationwithBorrower.map<DropdownMenuItem<String>>(
                        (RangeCategoryDataModel state) {
                      return DropdownMenuItem<String>(
                        value: state.code,
                        child: Text(state.descriptionEn),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ))
          ],
        ),

        Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 3),
                padding: EdgeInsets.all(1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.mno,
                      style: TextStyle(
                          fontFamily: "Poppins-Regular",
                          fontSize: 13,
                          height: 2),
                    ),
                    Container(
                      width: double.infinity, // Set the desired width
                      child: Center(
                        child: TextFormField(
                          style: TextStyle(
                              fontFamily: "Poppins-Regular", fontSize: 13),

                          maxLength: 10,
                          controller: _mobileNoController,
                          keyboardType:
                              TextInputType.number, // Set the input type
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), counterText: ""),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.pleaseentermobileno;
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(
                                '[a-zA-Z0-9]')), // Allow only alphanumeric characters // Optional: to deny spaces
                            TextInputFormatter.withFunction(
                              (oldValue, newValue) => TextEditingValue(
                                text: newValue.text.toUpperCase(),
                                selection: newValue.selection,
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              verifyButtonClick = false;
                              otpVerified = false;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 5),
            // Add spacing between the text field and the button
            Padding(
                padding: EdgeInsets.only(top: 20),
                // Add 10px padding from above
                child: InkWell(
                  onTap: () {
                    {
                      if (verifyButtonClick == false) {
                        if (_mobileNoController.text.isEmpty) {
                          showToast_Error(AppLocalizations.of(context)!.pleaseentermobileno);
                        } else if (_mobileNoController.text.length != 10) {
                          showToast_Error(AppLocalizations.of(context)!.pleaseentercorrectmobilenumber);
                        } else {
                          verifyButtonClick = true;
                          //getOTPByMobileNo(_mobileNoController.text);
                          mobileOtp(context, _mobileNoController.text);
                        }
                      }
                      // Implement OTP verification logic here
                    }
                  },
                  child: Card(
                    elevation: 4,
                    color: otpVerified ? Colors.green : Colors.grey,
                    shape: CircleBorder(),
                    child: Padding(
                      padding: EdgeInsets.all(9),
                      child: Icon(
                        otpVerified ? Icons.verified : Icons.sms,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )),
          ],
        ),

        Row(
          children: [
            // Age Box
            SizedBox(
              width: 80, // Set a fixed width for the age box
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    AppLocalizations.of(context)!.age,
                    style:
                        TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
                  ),
                  SizedBox(height: 3),
                  Container(
                    color: Colors.white,
                    child: TextField(
                      style: TextStyle(
                          fontFamily: "Poppins-Regular", fontSize: 13),
                      controller: _ageController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            // Date of Birth Box
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    AppLocalizations.of(context)!.dob,
                    style:
                        TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
                  ),
                  SizedBox(height: 3),
                  Container(
                    color: Colors.white,
                    child: TextField(
                      controller: _dobController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () =>
                              _selectDate(context, _dobController, "dob"),
                        ),
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        _buildTextField2(AppLocalizations.of(context)!.ffnane,
            _fatherFirstNameController, TextInputType.text, 30, nameReg),

        Row(
          children: [
            Expanded(
              child: _buildTextField2(AppLocalizations.of(context)!.mname,
                  _fatherMiddleNameController, TextInputType.text, 30, nameReg),
            ),
            SizedBox(width: 8),
            // Add spacing between the text fields if needed
            Expanded(
                child: _buildTextField2(
                    AppLocalizations.of(context)!.lname,
                    _fatherLastNameController,
                    TextInputType.text,
                    30,
                    nameReg)),
          ],
        ),

        SizedBox(
          height: 4,
        ),

        Text(
          AppLocalizations.of(context)!.marital,
          style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
        ),

        SizedBox(
          height: 4,
        ),

        Container(
          alignment: Alignment.center,

          width: double.infinity,
          // Adjust the width as needed
          height: 55,
          // Fixed height
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButton<String>(
            value: selectedMarritalStatus,
            isExpanded: true,
            iconSize: 24,
            elevation: 16,
            style: TextStyle(
                fontFamily: "Poppins-Regular",
                color: Colors.black,
                fontSize: 13),
            underline: Container(
              height: 2,
              color: Colors
                  .transparent, // Set to transparent to remove default underline
            ),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedMarritalStatus = newValue;
                });
              }
            },
            items: marrital_status
                .map<DropdownMenuItem<String>>((RangeCategoryDataModel state) {
              return DropdownMenuItem<String>(
                value: state.code,
                child: Text(state.descriptionEn),
              );
            }).toList(),
          ),
        ),
        // Conditionally show the spouse fields only when isMarried is true
        if (selectedMarritalStatus.toString() == 'Married')
          Column(
            children: [
              _buildTextField2(AppLocalizations.of(context)!.sfname,
                  _spouseFirstNameController, TextInputType.text, 30, nameReg),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField2(
                        AppLocalizations.of(context)!.mname,
                        _spouseMiddleNameController,
                        TextInputType.text,
                        30,
                        nameReg),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField2(
                        AppLocalizations.of(context)!.lname,
                        _spouseLastNameController,
                        TextInputType.text,
                        30,
                        nameReg),
                  ),
                ],
              ),
            ],
          ),
        Row(
          children: [
            Expanded(
              child: _buildTextField2(
                  AppLocalizations.of(context)!.monthlyincome,
                  _incomeController,
                  TextInputType.number,
                  7,
                  amountReg),
            ),
            SizedBox(width: 8),
            // Add spacing between the text fields if needed
            Expanded(
              child: _buildTextField2(
                  AppLocalizations.of(context)!.monthlyexpence,
                  _expenseController,
                  TextInputType.number,
                  7,
                  amountReg),
            ),
          ],
        ),
        _buildTextField(
            AppLocalizations.of(context)!.address1, _address1Controller),
        _buildTextField(
            AppLocalizations.of(context)!.address2, _address2Controller),
        _buildTextField(
            AppLocalizations.of(context)!.address3, _address3Controller),
        Row(
          children: [
            Expanded(
              child: _buildTextField2(AppLocalizations.of(context)!.city,
                  _cityController, TextInputType.text, 30, cityReg),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildTextField2(AppLocalizations.of(context)!.pincode,
                  _pincodeController, TextInputType.number, 6, amountReg),
            ),
          ],
        ),
        SizedBox(
          height: 4,
        ),

        _buildLabeledDropdownField(AppLocalizations.of(context)!.sstate,
            'State', states, stateselected, (RangeCategoryDataModel? newValue) {
          setState(() {
            stateselected = newValue;
          });
        }, String),
        _buildTextField2(AppLocalizations.of(context)!.loanamount,
            _loan_amountController, TextInputType.number, 7, amountReg),

        SizedBox(
          height: 6,
        ),
        Text(
          AppLocalizations.of(context)!.loanreason,
          style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
        ),
        SizedBox(
          height: 4,
        ),

        Container(
          alignment: Alignment.center,

          width: double.infinity,
          // Adjust the width as needed
          height: 55,
          // Fixed height
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButton<String>(
            value: selectedLoanReason,
            isExpanded: true,
            hint: Text(AppLocalizations.of(context)!.selectloanreason),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(
                fontFamily: "Poppins-Regular",
                color: Colors.black,
                fontSize: 13),
            underline: Container(
              height: 2,
              color: Colors
                  .transparent, // Set to transparent to remove default underline
            ),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedLoanReason = newValue; // Update the selected value
                });
              }
            },
            items: reasonForLoan
                .map<DropdownMenuItem<String>>((RangeCategoryDataModel state) {
              return DropdownMenuItem<String>(
                value: state.code,
                child: Text(state.descriptionEn),
              );
            }).toList(),
          ),
        ),
        SizedBox(
          height: 8,
        ),

        Row(
          children: [
            // Special Ability Dropdown
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.loanduration,
                    style:
                        TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
                  ),
                  SizedBox(height: 3),
                  Container(
                    alignment: Alignment.center,
                    width: 150,
                    // Adjust the width as needed
                    height: 55,
                    // Fixed height
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton<String>(
                      value: selectedloanDuration,
                      isExpanded: true,
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(
                          fontFamily: "Poppins-Regular",
                          color: Colors.black,
                          fontSize: 13),
                      underline: Container(
                        height: 2,
                        color: Colors
                            .transparent, // Set to transparent to remove default underline
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedloanDuration = newValue!;
                        });
                      },
                      items: loanDuration.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16), // Space between dropdowns
            // State Name Dropdown
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.bankname,
                    style:
                        TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
                  ),
                  SizedBox(height: 3),
                  Container(
                    alignment: Alignment.center,
                    height: 55,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton<String>(
                      value: bankselected,
                      isExpanded: true,
                      hint: Text(AppLocalizations.of(context)!.selectbank),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(
                          fontFamily: "Poppins-Regular",
                          color: Colors.black,
                          fontSize: 13),
                      underline: Container(
                        height: 2,
                        color: Colors.transparent,
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            bankselected = newValue;
                          });
                        }
                      },
                      items: bankNamesList.map<DropdownMenuItem<String>>(
                          (BankNamesDataModel state) {
                        return DropdownMenuItem<String>(
                          value: state.id.toString(),
                          child: Text(state.bankName),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // Row(
        //   children: [
        //     Expanded(
        //       child: Row(
        //         children: [
        //           Expanded(
        //             child: _buildTextField('Latitude', _latitudeController),
        //           ),
        //         ],
        //       ),
        //     ),
        //     SizedBox(width: 8),
        //     Expanded(
        //       child: Row(
        //         children: [
        //           Expanded(
        //             child: _buildTextField('Longitude', _longitudeController),
        //           ),
        //         ],
        //       ),
        //     ),
        //     SizedBox(width: 8),
        //     Padding(
        //       padding: EdgeInsets.only(top: 20),
        //       // Add 10px padding from above
        //       child: SizedBox(
        //         height: 40, // Smaller height for compact button
        //         width: 40, // Smaller width for compact button
        //         child: ElevatedButton(
        //           onPressed: geolocator,
        //           style: ElevatedButton.styleFrom(
        //             padding: EdgeInsets.all(0),
        //             // Remove padding for smaller size
        //             minimumSize: Size(40, 40), // Ensure button remains compact
        //           ),
        //           child: Icon(
        //             Icons.refresh,
        //             size: 18, // Smaller icon size for compact look
        //           ),
        //         ),
        //       ),
        //     )
        //   ],
        // ),
      ],
    ));
  }

  void _showOTPDialog(BuildContext context) {
    Timer? countdownTimer;
    int remainingTime = 60;
    bool cancelButtonVisible = false;
    String otp = "";
    void startCountdown(StateSetter setState) {
      countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (remainingTime > 0) {
          setState(() {
            remainingTime--;
          });
        } else {
          countdownTimer?.cancel();
          setState(() {
            cancelButtonVisible = true;
          });
        }
      });
    }

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal by tapping outside
      builder: (BuildContext context) {
        return WillPopScope(
            child: StatefulBuilder(
              builder: (context, setState) {
                // Start timer once the dialog opens
                if (countdownTimer == null) startCountdown(setState);

                return AlertDialog(
                  backgroundColor: Colors.white,
                  title: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.pleaseenterotphere,
                        style: TextStyle(
                          fontFamily: "Poppins-Regular",
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Pinput(
                        length: 6, // Number of PIN digits
                        onCompleted: (pin) {
                          otp = pin;
                        },
                        defaultPinTheme: PinTheme(
                          width: 40,
                          height: 40,
                          textStyle: const TextStyle(
                            fontFamily: "Poppins-Regular",
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Visibility(
                          visible: !cancelButtonVisible,
                          child: Text(
                            'Resend OTP in $remainingTime seconds',
                            style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                color: Colors.red),
                          )),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        verifyButtonClick = false;
                        countdownTimer?.cancel(); // Stop timer when submitting

                        if (otp.isEmpty || otp.length != 6) {
                          showToast_Error(AppLocalizations.of(context)!.pleaseenterotpproperly);
                        } else {
                          submitOtp(otp, context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Button color
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.submit,
                        style: TextStyle(
                            fontFamily: "Poppins-Regular", color: Colors.white),
                      ),
                    ),
                    Visibility(
                      visible: cancelButtonVisible,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            verifyButtonClick = false;
                          });
                          countdownTimer?.cancel(); // Stop timer when closing
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Button color
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.close,
                          style: TextStyle(
                              fontFamily: "Poppins-Regular",
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            onWillPop: () async => false);
      },
    ).then((_) {
      countdownTimer?.cancel(); // Cleanup when dialog is closed
    });
  }

  Widget _buildStepTwo(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 4),
                  padding: EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.panno,
                        style: TextStyle(
                          fontFamily: "Poppins-Regular",
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 1),
                      Container(
                        width: double.infinity, // Set the desired width
                        child: Center(
                          child: TextFormField(
                            maxLength: 10,
                            controller: _panNoController,
                            keyboardType:
                                TextInputType.text, // Set the input type
                            decoration: InputDecoration(
                                border: OutlineInputBorder(), counterText: ""),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.pleaseenterpannumber;
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(
                                  '[a-zA-Z0-9]')), // Allow only alphanumeric characters // Optional: to deny spaces
                              TextInputFormatter.withFunction(
                                (oldValue, newValue) => TextEditingValue(
                                  text: newValue.text.toUpperCase(),
                                  selection: newValue.selection,
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                panVerified = false;
                                panCardHolderName = "";

                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: InkWell(
                  enableFeedback: true,
                  onTap: () {
                    if (_panNoController.text.isEmpty ||
                        _panNoController.text.length != 10) {
                      showToast_Error(AppLocalizations.of(context)!.pleaseentercorrectpanno);
                    } else {
                      docVerifyIDC("pancard", _panNoController.text, "", "");
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: panVerified ? Colors.green : Colors.grey,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          panCardHolderName==null
          ? Text(
          AppLocalizations.of(context)!.pleasesearchpancardholdernameforverification,
          style: TextStyle(
          fontFamily: "Poppins-Regular",
              color: Colors.grey.shade400,
          fontSize: 11),
          )
        : Text(panCardHolderName!,

              style: TextStyle(
                  fontFamily: "Poppins-Regular",
                  color: Colors.green,
                  fontSize: !panVerified ? 11 : 14)),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: _buildTextField2(AppLocalizations.of(context)!.dl, _drivingLicenseController, TextInputType.text, 18, IdsReg),
              ),
              SizedBox(width: 10),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: () {
                    if (_drivingLicenseController.text.isEmpty ||
                        _drivingLicenseController.text.length < 10) {
                      showToast_Error(AppLocalizations.of(context)!.pleaseentercorrectdrivinglicense);
                    } else {
                      dlVerifyByProtean(GlobalClass.EmpId, _drivingLicenseController.text, dobForProtien!);

                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dlVerified ? Colors.green : Colors.grey,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          dlCardHolderName == null
              ? Text(
            AppLocalizations.of(context)!.pleasesearchdrivinglicenseholdernameforverification,
                  style: TextStyle(
                      fontFamily: "Poppins-Regular",
                      color: Colors.grey.shade400,
                      fontSize: 11),
                )
              : Text(dlCardHolderName!,
                  style: TextStyle(
                      fontFamily: "Poppins-Regular",
                      color: Colors.green,
                      fontSize: 14)),
          _buildDatePickerField(context, AppLocalizations.of(context)!.dlexpiry,
              _dlExpiryController, "dlExp"),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: _buildTextField2(AppLocalizations.of(context)!.voter, _voterIdController, TextInputType.text, 17, IdsReg),
              ),
              SizedBox(width: 10),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: () {
                    if (_voterIdController.text.isEmpty) {
                      showToast_Error(AppLocalizations.of(context)!.pleaseentervoterno);
                    } else {
                      voterVerifyByProtean(GlobalClass.EmpId, _voterIdController.text);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: voterVerified ? Colors.green : Colors.grey,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          voterCardHolderName == null
              ? Text(
            AppLocalizations.of(context)!.pleasesearchvotercardholdernameforverification,
                  style: TextStyle(
                      fontFamily: "Poppins-Regular",
                      color: Colors.grey.shade400,
                      fontSize: 11),
                )
              : Text(voterCardHolderName!,
                  style: TextStyle(
                      fontFamily: "Poppins-Regular",
                      color: Colors.green,
                      fontSize: 14)),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: _buildTextField(AppLocalizations.of(context)!.passport,
                    _passportController),
              ),
            ],
          ),
          _buildDatePickerField(
              context,
              AppLocalizations.of(context)!.passportexpiry,
              _passportExpiryController,
              "passExp"),
          _buildLabeledDropdownField(AppLocalizations.of(context)!.selectcity, 'Cities', listCityCodes, selectedCityCode, (PlaceData? newValue) {
            setState(() {
              selectedCityCode = newValue;
              selectedDistrictCode = null;
              selectedSubDistrictCode = null;
              selectedVillageCode = null;
              // getPlace("city",stateselected!.code,"","");
              // getPlace("district",stateselected!.code,"","");
            });
          }, String),
          _buildLabeledDropdownField(AppLocalizations.of(context)!.selectdistric, 'Districts', listDistrictCodes, selectedDistrictCode, (PlaceData? newValue) {
            setState(() {
              selectedDistrictCode = newValue;
              selectedSubDistrictCode = null;
              selectedVillageCode = null;
              getPlace("subdistrict", stateselected!.code,
                  selectedDistrictCode!.distCode!, "");
              // getPlace("district",stateselected!.code,"","");
            });
          }, String),
          _buildLabeledDropdownField(
              AppLocalizations.of(context)!.selectsubdistric,
              'Sub-Districts',
              listSubDistrictCodes,
              selectedSubDistrictCode, (PlaceData? newValue) {
            setState(() {
              selectedSubDistrictCode = newValue;
              selectedVillageCode = null;
              getPlace(
                  "village",
                  stateselected!.code,
                  selectedDistrictCode!.distCode!,
                  selectedSubDistrictCode!.subDistCode!);
              // getPlace("district",stateselected!.code,"","");
            });
          }, String),
          _buildLabeledDropdownField(
              AppLocalizations.of(context)!.selectvillage,
              'Village',
              listVillagesCodes,
              selectedVillageCode, (PlaceData? newValue) {
            setState(() {
              selectedVillageCode = newValue;
              // getPlace("city",stateselected!.code,"","");
              // getPlace("district",stateselected!.code,"","");
            });
          }, String),

        ],
      ),
    );
  }

  Widget _buildLabeledDropdownField<T>(
      String labelText,
      String label,
      List<T> items,
      T? selectedValue,
      ValueChanged<T?>? onChanged,
      Type objName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              labelText,
              style: TextStyle(
                fontFamily: "Poppins-Regular",
                fontSize: 13,
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: double
                  .infinity, // Ensure the dropdown takes the full width available
              child: DropdownButtonFormField<T>(
                isExpanded:
                    true, // Ensure the dropdown expands to fit its content
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: label,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400, // Border color when enabled
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: Colors.grey, // Border color when focused
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: Colors.grey, // Default border color
                    ),
                  ),
                ),
                value: selectedValue,
                items: items.map((T value) {
                  String setdata = "";
                  if (value is RangeCategoryDataModel) {
                    setdata = value.descriptionEn;
                  } else if (value is PlaceData) {
                    if (label == "Cities") {
                      setdata = value.cityName ?? "";
                    } else if (label == "Districts") {
                      setdata = value.distName ?? "";
                    } else if (label == "Sub-Districts") {
                      setdata = value.subDistName ?? "";
                    } else if (label == "Village") {
                      setdata = value.villageName ?? "";
                    }
                  }

                  return DropdownMenuItem<T>(
                    value: value,
                    child: Text(
                      setdata,
                      style: TextStyle(
                          fontFamily: "Poppins-Regular",
                          fontSize: 13,
                          fontWeight: FontWeight.normal),
                    ), // Convert the value to string for display
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void docVerifyIDC(String type, String txnNumber, String ifsc, String dob) async {
    EasyLoading.show(
      status: AppLocalizations.of(context)!.loading,
    );
    // print("object123 $dob");
    // DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(dob);
    // String formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);
    // print("formattedDate123 $formattedDate");


    try {
      Map<String, dynamic> requestBody = {
        "type": type,
        "txtnumber": txnNumber,
        "ifsc": ifsc,
        "userdob": dob,
        "key": "1",
      };

      // Hit the API
      final response = await apiService_idc.verifyIdentity(requestBody);

      // Handle response
      if (response is Map<String, dynamic>) {
        Map<String, dynamic> responseData = response["data"];
        // Parse JSON object if it’s a map
        if (type == "pancard") {
          if ((responseData['name'] == null || responseData['name'] == "")) {
            setState(() {
              panCardHolderName = "Data not Verified";
              panVerified = false;
            });
          } else if ((responseData['name'] != null ||
              responseData['name'] != "")) {
            setState(() {
              panCardHolderName = "${responseData['name']} ";
              panVerified = true;
            });
          } else if (responseData['name'] != null ||
              responseData['name'] != "") {
            setState(() {
              panCardHolderName = "${responseData['name']}";
              panVerified = true;
            });
          }
          if (!isCKYCNumberFound) {
            isCKYCNumberFound = await CkycRepository().searchCkyc(
                _aadharIdController.text,
                _panNoController.text,
                _voterIdController.text,
                _dobController.text,
                genderselected,
                _nameController.text +
                    " " +
                    _nameMController.text +
                    " " +
                    _nameLController.text);
          }
        } else if (type == "drivinglicense") {
          if (responseData['name'] == null || responseData['name'] == "") {
            setState(() {
              dlCardHolderName = "Data not Verified with DOB:$dob";
              dlVerified = false;
            });
          } else {
            setState(() {
              dlCardHolderName = "${responseData['name']}";
              dlVerified = true;
            });
          }
        } else if (type == "voterid") {
          if (responseData['name'] == null || responseData['name'] == "") {
            setState(() {
              voterCardHolderName = "Data not Verified";
              voterVerified = false;
            });
          } else {
            setState(() {
              voterCardHolderName = "${responseData['name']}";
              voterVerified = true;
            });
          }
          if (!isCKYCNumberFound) {
            isCKYCNumberFound = await CkycRepository().searchCkyc(
                _aadharIdController.text,
                _panNoController.text,
                _voterIdController.text,
                _dobController.text,
                genderselected,
                _nameController.text +
                    " " +
                    _nameMController.text +
                    " " +
                    _nameLController.text);
          }
        }
      } else {
        if (type == "pancard") {
          setState(() {
            panCardHolderName = "PAN no is not verified";
            panVerified = false;
          });
        } else if (type == "drivinglicense") {
          setState(() {
            dlCardHolderName = "Driving License is not verified";
            dlVerified = false;
          });
        } else if (type == "voterid") {
          setState(() {
            voterCardHolderName = "Voter no. is not verified";
            voterVerified = false;
          });
        }
        showToast_Error('${AppLocalizations.of(context)!.thisidisnotverified} $response');
        print("Unexpected Response: $response");
        EasyLoading.dismiss();
      }
      EasyLoading.dismiss();
    } catch (e) {
      showToast_Error("An error occurred: $e");

      if (type == "pancard") {
        setState(() {
          panCardHolderName = "PAN no is not verified";
          panVerified = false;
        });
      } else if (type == "drivinglicense") {
        setState(() {
          dlCardHolderName = "Driving License is not verified";
          dlVerified = false;
        });
      } else if (type == "voterid") {
        setState(() {
          voterCardHolderName = "Voter no. is not verified";
          voterVerified = false;
        });
      }
      EasyLoading.dismiss();
    }
  }


  void dlVerifyByProtean(String userid, String dlNo, String dob) async {
    EasyLoading.show(
      status: 'Loading...',
    );

    try {
      Map<String, dynamic> requestBody = {
        "userID": userid,
        "dlno": dlNo,
         "dob": dob
      };

      final response =
          await apiService_protean.getDLDetailsProtean(requestBody);

      if (response is Map<String, dynamic>) {
        Map<String, dynamic> responseData = response["data"];
        setState(() {
          print('Sunny Joon');
          EasyLoading.dismiss();

          if (responseData['result']['name'] != null) {
            dlCardHolderName = "${responseData['result']['name']}";
            dlVerified = true;
          } else {
            print("object1234 ${_dobController.text}");

            docVerifyIDC("drivinglicense", _drivingLicenseController.text, "", dobForIDLC!);
          }
        });
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();

        docVerifyIDC("drivinglicense", _drivingLicenseController.text, "",
            dobForIDLC!);
      }
    } catch (e) {
      // Handle errors
      docVerifyIDC("drivinglicense", _drivingLicenseController.text, "",
          dobForIDLC!);
      EasyLoading.dismiss();
    }
    EasyLoading.dismiss();
  }

  void voterVerifyByProtean(String userid, String voterNo) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      EasyLoading.show(status: AppLocalizations.of(context)!.loading,
      );
    });
    try {
      Map<String, dynamic> requestBody = {
        "userID": userid,
        "voterno": voterNo,
      };
      final response = await apiService_protean.getVoteretailsProtean(requestBody);

      if (response is Map<String, dynamic>) {
        EasyLoading.dismiss();
        Map<String, dynamic> responseData = response["data"];
        setState(() {
          EasyLoading.dismiss();
          if (responseData['result']['name'] != null) {
            voterCardHolderName = "${responseData['result']['name']}";
            voterVerified = true;
            EasyLoading.dismiss();
          } else {
            docVerifyIDC("voterid", _voterIdController.text, "", "");
          }
        });
      } else {
        docVerifyIDC("voterid", _voterIdController.text, "", "");
      }
    } catch (e) {
      docVerifyIDC("voterid", _voterIdController.text, "", "");
      EasyLoading.dismiss();
    }
    EasyLoading.dismiss();
  }

  Widget _buildNextButton(BuildContext context) {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width - 100,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFA60A19),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: 6),
        ),
        /*onPressed: () {
          if (_currentStep < 2) {
            setState(() {
              _currentStep += 1;
            });
          } else if (_formKey.currentState?.validate() ?? false) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Form submitted successfully")),
            );
          }
        },*/
        onPressed: () {
          if (_currentStep == 0) {
            if (FiType == "NEW") {
              if (firstPageFieldValidate()) {
                saveFiMethod(context);
              }
            } else {
              getPlace("city", stateselected!.code, "", "");
              getPlace("district", stateselected!.code, "", "");
              setState(() {
                _currentStep += 1;
              });
            }
          } else if (_currentStep == 1) {
          //  adhaarAllData(context);
            if (secondPageFieldValidate()) {
              saveIDsMethod(context);
            }
          }
          /*   } else if (_currentStep > 1) {
            showKycDoneDialog(context);
          }*/

          // if (_currentStep ==0) {
          //   setState(() {
          //     _currentStep += 1;
          //   });
          // } else if (_currentStep == 1) {
          //   if(secondPageFieldValidate()){
          //           saveIDsMethod(context);
          //         }
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text("Form submitted successfully")),
          //   );
          // }
        },
        child: Text(
          AppLocalizations.of(context)!.submit,
          style: TextStyle(
              fontFamily: "Poppins-Regular", color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Validation Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.ok,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /*void showKycDoneDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("KYC Done"),
          content: Text("Your KYC process is completed."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Close the current class
              },
            ),
          ],
        );
      },
    );
  }*/

  bool secondPageFieldValidate() {
    if (_panNoController.text.isNotEmpty) {
      if (!panVerified) {
        showToast_Error(AppLocalizations.of(context)!.pleaseverifypan);
        return false;
      }
    }
    if (_voterIdController.text.isNotEmpty) {
      if (voterCardHolderName == null) {
        showToast_Error(AppLocalizations.of(context)!.pleaseverifyvoterid);
        return false;
      }
    }
    if (_drivingLicenseController.text.isNotEmpty) {
      if (!dlVerified) {
        showToast_Error(AppLocalizations.of(context)!.pleaseverifydrivinglicense);
        return false;
      }
      if (_dlExpiryController.text.isEmpty) {
        showToast_Error(AppLocalizations.of(context)!.pleaseenterexpirydateofdrivinglicense);
        return false;
      }
    }

    if (!panVerified && !voterVerified && !dlVerified) {
      showToast_Error(AppLocalizations.of(context)!.pleaseenterandverifyeithervoteridoranyothertwoids);
      return false;
    } else if (checkIdMendate() == false) {
      showToast_Error(
          AppLocalizations.of(context)!.pleaseenterandverifyeithervoteridoranyothertwoids);
      return false;
    } else if (selectedCityCode == null) {
      showToast_Error(AppLocalizations.of(context)!.pleaseselectcity);
      return false;
    } else if (selectedDistrictCode == null) {
      showToast_Error(AppLocalizations.of(context)!.pleaseselectdistrict);
      return false;
    } else if (selectedSubDistrictCode == null) {
      showToast_Error(AppLocalizations.of(context)!.pleaseselectsubdistrict);
      return false;
    } else if (selectedVillageCode == null) {
      showToast_Error(AppLocalizations.of(context)!.pleaseselectvillage);
      return false;
    }

    return true;
  }

  bool checkIdMendate() {
    print("voterCardHolderName $voterCardHolderName");
    if (voterVerified || voterCardHolderName != null) {
      return true;
    } else if (panVerified && dlVerified) {
      return true;
    } else {
      return false;
    }
  }

  bool firstPageFieldValidate() {
    if (_aadharIdController.text.isEmpty) {
      showToast_Error(AppLocalizations.of(context)!.pleaseentercorrectaadhaarid);
      return false;
    }
    // else if(_errorMessageAadhaar.isNotEmpty){
    //   showToast_Error("Please enter valid aadhaar id");
    //   return false;
    // }
    else if (selectedTitle == null) {
      showToast_Error(AppLocalizations.of(context)!.pleasechoosetitle);
      return false;
    } else if (_nameController.text.isEmpty) {
      showToast_Error(AppLocalizations.of(context)!.pleaseenterborrowerfirstname);
      return false;
    } /* else if (_nameLController.text.isEmpty) {
      showToast_Error("Please enter borrower last name");
      return false;
    }*/
    else if (_gurNameController.text.isEmpty) {
      showToast_Error(AppLocalizations.of(context)!.pleaseenterguardianname);
      return false;
    } else if (genderselected.toLowerCase() == "select") {
      showToast_Error(AppLocalizations.of(context)!.pleaseselectborrowergender);
      return false;
    } else if (relationwithBorrowerselected.toLowerCase() == "select") {
      showToast_Error(AppLocalizations.of(context)!.pleaseselectborrowerrelationwithguardian);
      return false;
    } else if (_mobileNoController.text.isEmpty ||
        _mobileNoController.text.length != 10 ||
        !_mobileNoController.text.contains(RegExp(r'^[0-9]{10}$'))) {
      showToast_Error(AppLocalizations.of(context)!.pleaseentermobilenumber);
      return false;
    } else if (_dobController.text.isEmpty) {
      showToast_Error(AppLocalizations.of(context)!.pleaseenterdateofbirth);
      return false;
    } else if (_fatherFirstNameController.text.isEmpty) {
      showToast_Error(AppLocalizations.of(context)!.pleaseenterfatherfirstname);
      return false;
    } /*else if (_fatherLastNameController.text.isEmpty) {
      showToast_Error("Please enter father last name");
      return false;
    }*/
    else if (selectedMarritalStatus == null) {
      showToast_Error(AppLocalizations.of(context)!.pleaseselectmaritalstatus);
      return false;
    } else if (_expenseController.text.isEmpty) {
      showToast_Error(AppLocalizations.of(context)!.pleaseentermonthlyexpenses);
      return false;
    } else if (_incomeController.text.isEmpty) {
      showToast_Error(AppLocalizations.of(context)!.pleaseentermonthlyincome);
      return false;
    } else if ((!GlobalClass.creator.startsWith('VH') ||
            !GlobalClass.creator.startsWith('vh')) &&
        !(int.parse(_incomeController.text) <= 25000 &&
            int.parse(_incomeController.text) >= 10000)) {
      showToast_Error(
          AppLocalizations.of(context)!.incomeshouldbegreaterthanandlessthan);
      return false;
    } /*else if (!(int.parse(_incomeController.text)<=25000 && int.parse(_incomeController.text)>=10000)) {
      showToast_Error("Income should be greater than 10,000 and less than 25,000");
      return false;
    }*/
    else if ((int.parse(_expenseController.text) <=
        ((int.parse(_incomeController.text)) * 0.5))) {
      showToast_Error(AppLocalizations.of(context)!.expenseshouldbegreaterthan50ofincome);
      return false;
    } else if (selectedMarritalStatus!.toLowerCase() == "married" &&
        _spouseFirstNameController.text.isEmpty) {
      showToast_Error(AppLocalizations.of(context)!.pleaseenterspousefirstname);
      return false;
      /*else if (_spouseLastNameController.text.isEmpty) {
        showToast_Error("Please enter spouse last name");
        return false;
      }*/
    } else if (_address1Controller.text.isEmpty) {
      showToast_Error(AppLocalizations.of(context)!.pleaseenteraddress);
      return false;
    } else if (_cityController.text.isEmpty) {
      showToast_Error(AppLocalizations.of(context)!.pleaseentercity);
      return false;
    } else if (_pincodeController.text.isEmpty ||
        _pincodeController.text.length != 6) {
      showToast_Error(AppLocalizations.of(context)!.pleaseentercorrectpincode);
      return false;
    } else if (stateselected == null ||
        stateselected!.descriptionEn.toLowerCase() == "select") {
      showToast_Error(AppLocalizations.of(context)!.pleaseselectstate);
      return false;
    } else if (_loan_amountController.text.isEmpty) {
      showToast_Error(AppLocalizations.of(context)!.pleaseentercorrectloanamount);
      return false;
    } else if (!((int.parse(_loan_amountController.text)) >= 5000 &&
        (int.parse(_loan_amountController.text)) <= 300000)) {
      showToast_Error(
          AppLocalizations.of(context)!.loanamountshouldbelessthanthreelakhsandgreaterthan);
      return false;
    } else if (selectedLoanReason == null) {
      showToast_Error(AppLocalizations.of(context)!.pleaseselectloanreason);
      return false;
    } else if (selectedloanDuration == null ||
        selectedloanDuration!.toLowerCase() == "select") {
      showToast_Error(AppLocalizations.of(context)!.pleaseselectloanduration);
      return false;
    } else if (bankselected == null ||
        bankselected!.toLowerCase() == "select") {
      showToast_Error(AppLocalizations.of(context)!.pleaseselectbank);
      return false;
    } else if (_latitudeController.text.isEmpty ||
        _longitudeController.text.isEmpty) {
      showToast_Error(AppLocalizations.of(context)!.pleaseturnonlocationserviceofmobile);
      return false;
    } else if (_imageFile == null) {
      showToast_Error(AppLocalizations.of(context)!.pleasecaptureborrowerprofilepicture);
      return false;
    } else if (!otpVerified) {
      showToast_Error(AppLocalizations.of(context)!.pleaseverifymobilenumberwithotp);
      return false;
    }
    return true;
  }

  void getOTPByMobileNo(String text) {
    // Handle OTP submission here
    debugPrint("Submitted OTP: $text");
  }

  Future<void> verifyDocs(BuildContext context, String idNoController,
      String type, String ifsc, String dob) async {
    final api = ApiService.create(baseUrl: ApiConfig.baseUrl2);
    Map<String, dynamic> requestBody = {
      "type": type,
      "txtnumber": idNoController,
      "ifsc": ifsc,
      "userdob": dob,
      "key": "1"
    };

    return await api.verifyDocs(requestBody).then((value) {
      if (value.statusCode == 200) {
        setState(() {
          if (type == "passport") {
            setState() {
              iconPassport = Colors.green;
            }
          }
          if (type == "pancard") {
            iconPan = Colors.green;
          }
          if (type == "drivinglicense") {
            iconPassport = Colors.green;
          }
          if (type == "voterid") {
            iconPassport = Colors.green;
          }
        });
      }
    });
  }

  void getPlace(String type, String stateCode, String districtCode,
      String subDistrictCode) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      EasyLoading.show(
        status: AppLocalizations.of(context)!.loading,
      );
    });
    print(GlobalClass.token);
    try {
      PlaceCodesModel response = await apiService.getVillageStateDistrict(
        GlobalClass.token,
        GlobalClass.dbName,
        type, // Type
        subDistrictCode, // SubDistrictCode
        districtCode, // DistrictCode
        stateCode, // StateCode
      );

      if (response.statuscode == 200 && response.data.isNotEmpty) {
        setState(() {
          if (type == "city") {
            listCityCodes = response.data;
            print("Cities ${listCityCodes.length}");
          } else if (type == 'district') {
            listDistrictCodes = response.data;
          } else if (type == "subdistrict") {
            listSubDistrictCodes = response.data;
          } else if (type == "village") {
            listVillagesCodes = response.data;
          }
        });
      } else {
        GlobalClass.showUnsuccessfulAlert(context, "Message", 1);
      }

      EasyLoading.dismiss();
    } catch (e) {
      print("Error: $e");
      EasyLoading.dismiss();
    }
  }

  Future<void> mobileOtp(BuildContext context, String mobileNo) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      EasyLoading.show(
        status: AppLocalizations.of(context)!.loading,
      );
    });
    final api = ApiService.create(baseUrl: ApiConfig.baseUrl1);
    Map<String, dynamic> requestBody = {
      "MobileNo": mobileNo,
      "Language": "English",
      "ContentId": "1007458689942092806",
    };

    return await api
        .mobileOtpSend(GlobalClass.token, GlobalClass.dbName, requestBody)
        .then((value) {
      if (value.statuscode == 200) {
        EasyLoading.dismiss();
        _showOTPDialog(context);
      } else {
        EasyLoading.dismiss();
        GlobalClass.showErrorAlert(context,
            AppLocalizations.of(context)!.issueoccursinotpsending, 1);
      }
    }).catchError((onError) {
      EasyLoading.dismiss();
      GlobalClass.showErrorAlert(
          context, "Issue occurs in OTP sending...\n\n$onError", 1);
    });
  }

  void setQRData(result) {

    List<String> dataList = result.split(", ");

    if (dataList.length > 14) {
      if (dataList[0].toLowerCase().startsWith("v")) {
        _aadharIdController.text = dataList[2];
        if (_aadharIdController.text.length != 12) {
          GlobalClass.showErrorAlert(context, AppLocalizations.of(context)!.pleaseenteraadhaarnumber, 1);
          _aadharIdController.text = "";
        }
        List<String> nameParts = dataList[3].split(" ");
        if (nameParts.length == 1) {
          _nameController.text = nameParts[0];
        } else if (nameParts.length == 2) {
          _nameController.text = nameParts[0];
          _nameLController.text = nameParts[1];
        } else {
          _nameController.text = nameParts.first;
          _nameLController.text = nameParts.last;
          _nameMController.text =
              nameParts.sublist(1, nameParts.length - 1).join(' ');
        }

        _dobController.text = formatDate(dataList[4].trim(), 'dd-MM-yyyy');
        setState(() {
          if (dataList[5].trim().toLowerCase() == "m") {
            genderselected = "Male";
            selectedTitle = "Mr.";
          } else if (dataList[5].trim().toLowerCase() == "f") {
            genderselected = "Female";
            selectedTitle = "Mrs.";
          }
        });
        if (dataList[6].toLowerCase().contains("s/o") ||
            dataList[6].toLowerCase().contains("d/o")) {
          print("dataList[6] $dataList[6]");
          setState(() {
            relationwithBorrowerselected = "Father";
            List<String> guarNameParts =
                replaceCharFromName(dataList[6].trim()).split(" ");

            print("guarNameParts1 ${dataList[6].trim()}");
            print("guarNameParts $guarNameParts");
            if (guarNameParts.length == 1) {
              _fatherFirstNameController.text = guarNameParts[0];
            } else if (guarNameParts.length == 2) {
              _fatherFirstNameController.text = guarNameParts[0];
              _fatherLastNameController.text = guarNameParts[1];
            } else {
              _fatherFirstNameController.text = guarNameParts.first;
              _fatherLastNameController.text = guarNameParts.last;
              _fatherMiddleNameController.text =
                  guarNameParts.sublist(1, guarNameParts.length - 1).join(' ');
            }
          });
        } else if (dataList[6].toLowerCase().contains("w/o")) {
          setState(() {
            relationwithBorrowerselected = "Husband";
            List<String> guarNameParts =
                replaceCharFromName(dataList[6]).split(" ");
            if (guarNameParts.length == 1) {
              _spouseFirstNameController.text = guarNameParts[0];
            } else if (guarNameParts.length == 2) {
              _spouseFirstNameController.text = guarNameParts[0];
              _spouseLastNameController.text = guarNameParts[1];
            } else {
              _spouseFirstNameController.text = guarNameParts.first;
              _spouseLastNameController.text = guarNameParts.last;
              _spouseMiddleNameController.text =
                  guarNameParts.sublist(1, guarNameParts.length - 1).join(' ');
            }
          });
        }
        _cityController.text = dataList[7];
        _gurNameController.text = replaceCharFromName(dataList[6]);

        if (dataList[0].toLowerCase() == 'v2') {
          _pincodeController.text = dataList[11];
          stateselected = states.firstWhere((item) =>
          item.descriptionEn.toLowerCase() ==
              dataList[13].trim().toLowerCase());
          String address =
              "${dataList[9]},${dataList[10]},${dataList[12]},${dataList[14]},${dataList[15]}";
          List<String> addressParts = address.trim().split(",");
          if (addressParts.length == 1) {
            _address1Controller.text = addressParts[0];
          } else if (addressParts.length == 2) {
            _address1Controller.text = addressParts[0];
            _address2Controller.text = addressParts[1];
          } else {
            _address1Controller.text = addressParts.first;
            _address2Controller.text = addressParts.last;
            _address3Controller.text =
                addressParts.sublist(1, addressParts.length - 1).join(' ');
          }
        }
        else if (dataList[0].toLowerCase() == 'v4' && dataList[1].contains("3")) {
          print("AAAA0${dataList[0]}");
          print("AAAA1${dataList[1]}");
          print("AAAA2${dataList[2]}");
          print("AAAA3${dataList[3]}");
          print("AAAA4${dataList[4]}");
          print("AAAA5${dataList[5]}");
          print("AAAA6${dataList[6]}");
          print("AAAA7${dataList[7]}");
          print("AAAA8${dataList[8]}");
          print("AAAA9${dataList[9]}");
          print("AAAA10${dataList[10]}");
          print("AAAA11${dataList[11]}");
          print("AAAA12${dataList[12]}");
          print("AAAA13${dataList[13]}");
          print("AAAA14${dataList[14]}");
          print("AAAA15${dataList[15]}");
//[V4, 3, 270020250403123759485, Surendra Kumar, 05-07-1989, M, S/O Manohar Lal, Pilibhit, , vill. maseet post daulatpur patti, , 262001, , Uttar Pradesh, tehseel bisalpur, ]

          setState(() {
            stateselected = states.firstWhere((item) =>
            item.descriptionEn.toLowerCase() == dataList[13].toLowerCase());
            _pincodeController.text = dataList[11];
            String address =
                "${dataList[9]},${dataList[14]},${dataList[7]},${dataList[13]}}";
            print("AAAA19$address");

            List<String> addressParts = address.trim().split(",");
            if (addressParts.length == 1) {
              _address1Controller.text = addressParts[0];
            } else if (addressParts.length == 2) {
              _address1Controller.text = addressParts[0];
              _address2Controller.text = addressParts[1];
            } else {
              _address1Controller.text = addressParts.first;
              _address2Controller.text = addressParts.last;
              _address3Controller.text =
                  addressParts.sublist(1, addressParts.length - 1).join(' ');
            }
          });

        }
         else if (dataList[0].toLowerCase() == 'v4') {
          stateselected = states.firstWhere((item) =>
              item.descriptionEn.toLowerCase() == dataList[14].toLowerCase());
          _pincodeController.text = dataList[12];
          String address =
              "${dataList[10]},${dataList[11]},${dataList[13]},${dataList[15]},${dataList[16]}";

          List<String> addressParts = address.trim().split(",");
          if (addressParts.length == 1) {
            _address1Controller.text = addressParts[0];
          } else if (addressParts.length == 2) {
            _address1Controller.text = addressParts[0];
            _address2Controller.text = addressParts[1];
          } else {
            _address1Controller.text = addressParts.first;
            _address2Controller.text = addressParts.last;
            _address3Controller.text =
                addressParts.sublist(1, addressParts.length - 1).join(' ');
          }
        } else if (dataList[0].toLowerCase() == 'v3') {
          stateselected = states.firstWhere((item) =>
              item.descriptionEn.toLowerCase() == dataList[13].toLowerCase());
          _pincodeController.text = dataList[11];
          String address =
              "${dataList[9]},${dataList[14]},${dataList[15]},${dataList[12]},${dataList[7]}";

          List<String> addressParts = address.trim().split(",");
          if (addressParts.length == 1) {
            _address1Controller.text = addressParts[0];
          } else if (addressParts.length == 2) {
            _address1Controller.text = addressParts[0];
            _address2Controller.text = addressParts[1];
          } else {
            _address1Controller.text = addressParts.first;
            _address2Controller.text = addressParts.last;
            _address3Controller.text =
                addressParts.sublist(1, addressParts.length - 1).join(' ');
          }
        }
      } else {
        _aadharIdController.text = dataList[1];
        if (_aadharIdController.text.length != 12) {
          GlobalClass.showErrorAlert(context, AppLocalizations.of(context)!.pleaseenteraadhaarnumber, 1);
          _aadharIdController.text = "";
        }
        List<String> nameParts = dataList[2].split(" ");
        if (nameParts.length == 1) {
          _nameController.text = nameParts[0];
        } else if (nameParts.length == 2) {
          _nameController.text = nameParts[0];
          _nameLController.text = nameParts[1];
        } else {
          _nameController.text = nameParts.first;
          _nameLController.text = nameParts.last;
          _nameMController.text =
              nameParts.sublist(1, nameParts.length - 1).join(' ');
        }

        _dobController.text = formatDate(dataList[3], 'dd-MM-yyyy');
        setState(() {
          if (dataList[4].toLowerCase() == "m") {
            genderselected = "Male";
            selectedTitle = "Mr.";
          } else if (dataList[4].toLowerCase() == "f") {
            genderselected = "Female";
            selectedTitle = "Mrs.";
          }
        });
        if (dataList[5].toLowerCase().contains("s/o") ||
            dataList[5].toLowerCase().contains("d/o")) {
          setState(() {
            relationwithBorrowerselected = "Father";
            List<String> guarNameParts =
                replaceCharFromName(dataList[5]).split(" ");
            if (guarNameParts.length == 1) {
              _fatherFirstNameController.text = guarNameParts[0];
            } else if (guarNameParts.length == 2) {
              _fatherFirstNameController.text = guarNameParts[0];
              _fatherLastNameController.text = guarNameParts[1];
            } else {
              _fatherFirstNameController.text = guarNameParts.first;
              _fatherLastNameController.text = guarNameParts.last;
              _fatherMiddleNameController.text =
                  guarNameParts.sublist(1, guarNameParts.length - 1).join(' ');
            }
          });
        } else if (dataList[5].toLowerCase().contains("w/o")) {
          setState(() {
            relationwithBorrowerselected = "Husband";
            List<String> guarNameParts =
                replaceCharFromName(dataList[5]).split(" ");
            if (guarNameParts.length == 1) {
              _spouseFirstNameController.text = guarNameParts[0];
            } else if (guarNameParts.length == 2) {
              _spouseFirstNameController.text = guarNameParts[0];
              _spouseLastNameController.text = guarNameParts[1];
            } else {
              _spouseFirstNameController.text = guarNameParts.first;
              _spouseLastNameController.text = guarNameParts.last;
              _spouseMiddleNameController.text =
                  guarNameParts.sublist(1, guarNameParts.length - 1).join(' ');
            }
          });
        }
        _cityController.text = dataList[6];
        _gurNameController.text = replaceCharFromName(dataList[5]);

        _pincodeController.text = dataList[10];
        stateselected = states.firstWhere((item) =>
            item.descriptionEn.toLowerCase() == dataList[12].toLowerCase());
        String address =
            "${dataList[8]},${dataList[9]},${dataList[11]},${dataList[13]},${dataList[14]}";
        List<String> addressParts = address.trim().split(",");
        if (addressParts.length == 1) {
          _address1Controller.text = addressParts[0];
        } else if (addressParts.length == 2) {
          _address1Controller.text = addressParts[0];
          _address2Controller.text = addressParts[1];
        } else {
          _address1Controller.text = addressParts.first;
          _address2Controller.text = addressParts.last;
          _address3Controller.text =
              addressParts.sublist(1, addressParts.length - 1).join(' ');
        }
      }
    }

  }

  Future<void> _BabnkNamesAPI(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      EasyLoading.show(
        status: AppLocalizations.of(context)!.loading,
      );
    });

    final api = Provider.of<ApiService>(context, listen: false);

    return await api
        .bankNames(GlobalClass.token, GlobalClass.dbName)
        .then((value) async {
      if (value.statuscode == 200) {
        EasyLoading.dismiss();
        if (!value.data.isEmpty) {
          setState(() {
            bankNamesList = value.data;
          });
        }
      } else {
        EasyLoading.dismiss();
        showToast_Error(AppLocalizations.of(context)!.banknamelistnotfetched);
      }
    });
  }

  String replaceCharFromName(String gurName) {
    return gurName.toUpperCase()
        .replaceAll("S/O ", "")
        .replaceAll("S/O: ", "")
        .replaceAll("D/O ", "")
        .replaceAll("D/O: ", "")
        .replaceAll("W/O ", "")
        .replaceAll("W/O: ", "");
  }

  Future<void> submitOtp(pin, BuildContext contextDialog) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      EasyLoading.show(
        status: AppLocalizations.of(context)!.loading,
      );
    });

    final api = ApiService.create(baseUrl: ApiConfig.baseUrl1);

    return await api
        .otpVerify(GlobalClass.token, GlobalClass.dbName,
            _mobileNoController.text, pin)
        .then((value) {
      if (value.statuscode == 200) {
        showToast_Error(AppLocalizations.of(context)!.otpverified);
        setState(() {
          otpVerified = true;
          verifyButtonClick = true;
        });
        Navigator.of(contextDialog).pop();
      } else {
        setState(() {
          otpVerified = false;
        });
        GlobalClass.showSnackBar(
            context, AppLocalizations.of(context)!.otpisnotverified);
      }
      EasyLoading.dismiss();
    }).catchError((err) {
      setState(() {
        otpVerified = false;
      });
      GlobalClass.showSnackBar(context, err);
      EasyLoading.dismiss();
    });
  }

  Future<void> _onWillPop() async {
    showDialog(
      barrierDismissible: false,
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
              AppLocalizations.of(context)!.doyouwanttoclosekycform,
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
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
    // return shouldClose ?? false; // Default to false if dismissed
  }

  Widget _buildShinyButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFFD42D3F), // foreground/text
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }

  Future<void> adhaarAllData(BuildContext contextDialog) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      EasyLoading.show(
        status: AppLocalizations.of(context)!.loading,
      );
    });
    print("object112211");

    final api = ApiService.create(baseUrl: ApiConfig.baseUrl1);

    return await api
        .dataByAdhaar(
      GlobalClass.token,
      GlobalClass.dbName,
      _aadharIdController.text,
    )
        .then((value) {
      if (value.statuscode == 200) {
        if (value.data[0].errormsg.isEmpty) {
          print("object112222");
          adhaardata = value.data[0];
          if (value.data[0].panNo.isEmpty &&
              value.data[0].dl.isEmpty &&
              value.data[0].voterId.isEmpty) {
            EasyLoading.dismiss();

            Future.delayed(
                Duration.zero, () => showIDCardDialog(context, adhaardata!, 2));

            /* setState(() {
              FiType = "OLD";
              Fi_Code=value.data[0].fiCode.toString();
              Fi_Id = value.data[0].fiId.toString();
              selectedTitle = value.data[0].title.trim();
              _nameController.text = value.data[0].fName;
              _nameMController.text = value.data[0].mName;
              _nameLController.text = value.data[0].lName;
                if(value.data[0].relationWithBorrower=="Husband"){
                  relationwithBorrowerselected="Husband";
                  _gurNameController.text="${value.data[0].spousEFirstName} ${value.data[0].spousEMiddleName} ${value.data[0].spousELastName}";
                }else if(value.data[0].relationWithBorrower=="Husband"){
                  relationwithBorrowerselected="Husband";
                  _gurNameController.text="${value.data[0].fatheRFirstName} ${value.data[0].fatheRMiddleName} ${value.data[0].fatheRLastName}";
                }
                genderselected=value.data[0].gender;
              relationwithBorrowerselected=(value.data[0].relationWithBorrower);
              _mobileNoController.text = value.data[0].pPhone;
              _dobController.text = value.data[0].dob.toString().split("T")[0];
              dlDob = value.data[0].dob.toString().split("T")[0];
              // _ageController.text =value.data[0].;
              if(value.data[0].pState.isNotEmpty){
                stateselected= states
                    .firstWhere((item) =>
                item.code.toLowerCase() ==
                    value.data[0].pState.toLowerCase());
              }

              _fatherFirstNameController.text = value.data[0].fatheRFirstName;
              _fatherMiddleNameController.text = value.data[0].fatheRMiddleName;
              _fatherLastNameController.text = value.data[0].fatheRLastName;
            //  selectedMarritalStatus = (value.data[0].isMarried)?"Married":"unmarried";
              _spouseFirstNameController.text = value.data[0].spousEFirstName;
              _spouseMiddleNameController.text = value.data[0].spousEMiddleName;
              _spouseLastNameController.text = value.data[0].spousELastName;
              _expenseController.text =value.data[0].expense.toString();
              _incomeController.text =value.data[0].income.toString();
           //   _latitudeController.text =value.data[0].latitude;
          //    _longitudeController.text =value.data[0].longitude;
              _address1Controller.text =value.data[0].pAddress1;
              _address2Controller.text =value.data[0].pAddress2;
              _address3Controller.text =value.data[0].pAddress3;
              _cityController.text =value.data[0].pCity;
              _pincodeController.text =value.data[0].pPincode;
              */ /*stateselected = states.firstWhere((item) =>
              item.descriptionEn.toLowerCase() == value.data[0].pState.toString().toLowerCase());*/ /*
              _loan_amountController.text =value.data[0].loanAmount.toString();
             EasyLoading.dismiss();

            });
            GlobalClass.showAlert(
              contextDialog,
              "KYC Already Exist with same Aadhaar",
              "Ficode: ${Fi_Code}\nCreator: ${GlobalClass.creator}\nBorrower Name: ${value.data[0].fName } ${value.data[0].mName } ${value.data[0].lName} ",
              Colors.red,
              1,
            );*/
          }
          else {
            EasyLoading.dismiss();
            Future.delayed(
                Duration.zero, () => showIDCardDialog(context, adhaardata!, 1));

            /*String ficode = value.data[0].fiCode.toString();
            GlobalClass.showErrorAlert(context,
                "Kyc is Already Done on this Adhaar Id(FiCode is $ficode)", 2);*/
          }
        }else {
          EasyLoading.dismiss();
        }
      } else {
        EasyLoading.dismiss();

        setState(() {});
      }
    }).catchError((err) {
      print("ERRORRRR$err");
      EasyLoading.dismiss();
    });
  }

  void showIDCardDialog(BuildContext context, AdhaarDataModel borrowerInfo, int page) {
    final String name = [
      borrowerInfo.fName,
      borrowerInfo.mName,
      borrowerInfo.lName
    ].where((part) => part != null && part.isNotEmpty).join(" ");
    final String aadhaarNo = borrowerInfo.aadharNo;
    final String panNo = borrowerInfo.panNo;
    final String dl = borrowerInfo.dl;
    final String voterId = borrowerInfo.voterId;
    final String dob = borrowerInfo.dob;
/*    print("sssssssss + $dob");

    String formattedDOB =
        '${dob.split('T')[0].split('-')[2]}-${dob.split('T')[0].split('-')[1]}-${dob.split('T')[0].split('-')[0]}';
    print("sssssssss + $formattedDOB");
    dobForSaveFi = DateFormat('yyyy-MM-dd').format(DateTime.parse(formattedDOB));
    dobForIDLC = DateFormat('yyyy/MM/dd').format(DateTime.parse(formattedDOB));
    dobForProtien = DateFormat('dd-MM-yyyy').format(DateTime.parse(formattedDOB));*/


    String datePart = dob.split('T')[0];

    List<String> dateParts = datePart.split('-');
    String formattedDOB = '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';
    print("Formatted DOB (dd-MM-yyyy): $formattedDOB");
    DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(formattedDOB);
     dobForSaveFi = DateFormat('yyyy-MM-dd').format(parsedDate);
     dobForIDLC = DateFormat('yyyy/MM/dd').format(parsedDate);
     dobForProtien = DateFormat('dd-MM-yyyy').format(parsedDate);

    print("formattedDate1 $dlDob");
    print("formattedDate2 ${_dobController.text}");
    print("formattedDate2 ${dobForSaveFi}");
    print("formattedDate2 ${dobForIDLC}");
    print("formattedDate2 ${dobForProtien}");

    final String loanAmt = borrowerInfo.loanAmount.toString();
    // final String imageUrl =GlobalClass().transformFilePathToUrl(borrowerInfo.profilepic);
    // final String imageUrl =GlobalClass().transformFilePathToUrl(borrowerInfo.profilepic);
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing dialog when tapping outside
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async =>
                false, // Prevent closing dialog with back button
            child: AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Center(
                  child: Text( AppLocalizations.of(context)!.borrowerdetails,
                      style: TextStyle(
                        fontSize: 16,
                      ))),
              content: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  width: 300,
                  padding: EdgeInsets.all(2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /*Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 2), // Border around image
                          borderRadius:
                          BorderRadius.circular(50), // Circle border
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(imageUrl),
                        ),
                      ),*/
                      SizedBox(height: 10),
                      // Name
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      // Adhaar No.
                      Text(
                        '${AppLocalizations.of(context)!.adharid} $aadhaarNo',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      // PAN, DL, Voter No. (showing all if they exist)
                      Column(
                        children: [
                          if (voterId.isNotEmpty)
                            Text('${AppLocalizations.of(context)!.voterid} $voterId',
                                style: TextStyle(fontSize: 16)),
                          if (panNo.isNotEmpty)
                            Text('${AppLocalizations.of(context)!.pannoid} $panNo', style: TextStyle(fontSize: 16)),
                          if (dl.isNotEmpty)
                            Text('${AppLocalizations.of(context)!.dlid} $dl', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      SizedBox(height: 5),
                      // DOB

                      Text(
                        '${AppLocalizations.of(context)!.dobid} $formattedDOB',
                        style: TextStyle(fontSize: 16),
                      ),

                      SizedBox(height: 5),
                      // Loan Amount
                      if (loanAmt.isNotEmpty)
                        Text('${AppLocalizations.of(context)!.lmt} $loanAmt',
                            style: TextStyle(fontSize: 16)),
                      SizedBox(height: 20),
                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          page == 2
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _currentStep += 1;
                                      Fi_Id = borrowerInfo.fiId.toString();
                                      Fi_Code = borrowerInfo.fiCode.toString();
                                      dlDob = borrowerInfo.dob.toString();
                                      print("sssssssss + $dlDob");

                                      _dobController.text =borrowerInfo.dob.toString();
                                      print("sssssssss + _dobController.text");

                                      _dobController.text = borrowerInfo.dob.toString().split("T")[0];
                                      print("sssssssss + _dobController.text");

                                      dlDob = borrowerInfo.dob.toString().split("T")[0];
                                      print("sssssssss + $dlDob");


                                      if (borrowerInfo.pState.isNotEmpty) {
                                        stateselected = states.firstWhere(
                                            (item) =>
                                                item.code.toLowerCase() ==
                                                borrowerInfo.pState
                                                    .toLowerCase());
                                      }
                                      //String statecode = borrowerInfo.pState.toString();


                                      print("sssssssss" + stateselected!.code);
                                      getPlace(
                                          "city", stateselected!.code, "", "");
                                      getPlace("district", stateselected!.code,
                                          "", "");
                                    });
                                    print('Verification Confirmed');
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 15),
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
                                        AppLocalizations.of(context)!.submit,
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
                                )
                              : SizedBox(),
                          page == 1
                              ? GestureDetector(
                                  onTap: () {
                                    print('Verification Rejected');
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 25),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.redAccent,
                                          Color(0xFFD42D3F)
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
                                        AppLocalizations.of(context)!.close,
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
                                )
                              : SizedBox(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }

  Future<String?> callJavaMethodQr() async {
    const platform = MethodChannel('com.example.intent');
    try {
      // Call the Java method
      final String result = await platform.invokeMethod('callJavaMethodQr');
      return result;
    } on PlatformException catch (e) {
      print("Failed to invoke Java method: ${e.message}");
      return null;
    }
  }


}
