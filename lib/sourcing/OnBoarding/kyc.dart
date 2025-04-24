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
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xml/xml.dart';
import '../../DATABASE/database_helper.dart';
import '../../MasterAPIs/ckyc_repository.dart';
import '../../MasterAPIs/live_track_repository.dart';
import '../../Models/adhaar_model.dart';
import '../../Models/bank_names_model.dart';
import '../../Models/fino_model.dart';
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

  late DatabyAadhaarDataModel adhaardata;

  String nameReg = '[a-zA-Z. ]';
  String addReg = r'[a-zA-Z0-9. ()/,-]';
  String amountReg = '[0-9]';
  String cityReg = '[a-zA-Z ]';
  String IdsReg = '[a-zA-Z0-9/ ]';

  String FiType = "NEW";

  int imageStartIndex = 0;
  Color iconPan = Colors.red;
  Color iconDl = Colors.red;
  Color iconVoter = Colors.red;
  Color iconPassport = Colors.red;
  String? _mobileError;

  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  String? panCardHolderName;

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
  List<String> loanDuration = ['Select', '12', '24', '36'];

  List<String> titleList = ["Select","Mr.", "Mrs.", "Miss"];
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
  String kycType = "";

  bool verifyButtonClick = false;

  @override
  void initState() {
    apiService = ApiService.create(baseUrl: ApiConfig.baseUrl1);
    apiService_idc = ApiService.create(baseUrl: ApiConfig.baseUrl4);
    apiService_protean = ApiService.create(baseUrl: ApiConfig.baseUrl5);
    apiService_OCR = ApiService.create(baseUrl: ApiConfig.baseUrl6);

    fetchData();
    selectedloanDuration = loanDuration.isNotEmpty ? loanDuration[0] : null;
    _BabnkNamesAPI(context);

    geolocator(context);
    super.initState();
  }

  @override
  void dispose() {
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
      marrital_status.insert(
          0,
          RangeCategoryDataModel(
            catKey: 'Select',
            groupDescriptionEn: 'select',
            groupDescriptionHi: 'select',
            descriptionEn: 'Select',
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
            descriptionHi: 'select',
            sortOrder: 0,
            code: 'select', // Value of the placeholder
          ));
    }); // Refresh the UI
    setState(() {
      _pageloading = false;
    });
  }

  DateTime? _selectedDate;

  // TextEditingControllers for all input fields
  final _aadharIdController = TextEditingController();
  bool aadharIdFlag = true;
  late var _nameController = TextEditingController();
  bool nameFlag = false;
  late var _nameMController = TextEditingController();
  bool mNameFlag = false;
  late var _nameLController = TextEditingController();
  bool lNameFlag = false;

  late var _ageController = TextEditingController();

  late var _dobController = TextEditingController();
  bool dobFlag = false;

  late var _mobileNoController = TextEditingController();

  final mobileController = TextEditingController();

  late var _gurNameController = TextEditingController();
  bool gurFlag = false;

  late var _fatherFirstNameController = TextEditingController();
  bool ffNameFlag = false;

  late var _fatherMiddleNameController = TextEditingController();
  bool fmNameFlag = false;

  late var _fatherLastNameController = TextEditingController();
  bool flNameFlag = false;

  late var _spouseFirstNameController = TextEditingController();
  bool sfNameFlag = false;

  late var _spouseMiddleNameController = TextEditingController();
  bool smNameFlag = false;

  late var _spouseLastNameController = TextEditingController();
  bool slNameFlag = false;

  late var _latitudeController = TextEditingController();
  late var _longitudeController = TextEditingController();
  late var _address1Controller = TextEditingController();
  bool add1Flag = false;

  late var _address2Controller = TextEditingController();
  bool add2Flag = false;

  late var _address3Controller = TextEditingController();
  bool add3Flag = false;

  late var _cityController = TextEditingController();
  bool cityFlag = false;

  late var _pincodeController = TextEditingController();
  bool pinFlag = false;
  bool statesFLag = false;
  bool relationwithBorrowerFLag = false;
  bool genderFlag = false;
  bool titleFlag = false;
  bool maritalFlag = false;


  late var _loan_amountController = TextEditingController();

  final _motherFController = TextEditingController();
  final _motherMController = TextEditingController();
  final _motherLController = TextEditingController();

  late String selectednumOfChildren="Select";
  late String selectedschoolingChildren="Select";
  late String selectedotherDependents ="Select";
  List<String> onetonine = ['Select', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];


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
  String? dobForSaveFi; //2024-09-19
  String? Fi_Id;
  String? Fi_Code;
  String qrResult = "";
  File? _imageFile;

  get isChecked => null;
  final FocusNode _focusNodeAdhaarId = FocusNode();

  String _errorMessageAadhaar = "";

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
        _errorMessageAadhaar =
            AppLocalizations.of(context)!.aadhaaridfieldcannotbeempty;
      } else if (_aadharIdController.text.length != 12) {
        _errorMessageAadhaar =
            AppLocalizations.of(context)!.aadhaarmustbecharacterslong;
      } else if (!Validators.validateVerhoeff(_aadharIdController.text)) {
        _errorMessageAadhaar =
            AppLocalizations.of(context)!.aadhaaridisnotvalid;
      } else {
        _errorMessageAadhaar = "";
        if (_aadharIdController.text.length == 12) {
          adhaarAllData(context);
        }
      }
    });
  }

  void _selectDate(BuildContext context, TextEditingController controller,
      String type) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().isBefore(DateTime(DateTime.now().year - 21,
              DateTime.now().month, DateTime.now().day))
          ? DateTime.now()
          : DateTime(DateTime.now().year - 21, DateTime.now().month,
              DateTime.now().day),
      firstDate: DateTime(
          DateTime.now().year - 60, DateTime.now().month, DateTime.now().day),
      // You can set this to any reasonable past date
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

          _calculateAge();
        }
      });
    }
  }

  void _selectDate2(BuildContext context, TextEditingController controller,
      String type) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      // Only future dates
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
        if (type == "passExp") {
          _passportExpiryController.text =
              DateFormat('dd-MM-yyyy').format(picked);
        } else if (type == "dlExp") {
          _dlExpiryController.text = DateFormat('dd-MM-yyyy').format(picked);
        }
      });
    }
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
                            },
                          ),
                          Center(
                            child: Image.asset(
                              'assets/Images/logo_white.png',
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

  Widget _buildTextField2(String label, TextEditingController controller,
      TextInputType inputType, int maxlength, String regex, bool tFEnabled) {
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
                enabled: tFEnabled,
                maxLength: maxlength,
                controller: controller,
                keyboardType: inputType,
                // Set the input type
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

                          if(result.toUpperCase().contains("XML")){
                            print("XXXXXXX${result.toString()}");
                            Map<String, String> aadhaarData = setxmlData(result);
                            print("XXXXXXXuid:${aadhaarData['uid']}");
                            print("XXXXXXXname: ${aadhaarData['name']}");
                            print("XXXXXXXgender: ${aadhaarData['gender']}");
                            print("XXXXXXXyob: ${aadhaarData['yob']}");
                            print("XXXXXXXdob: ${aadhaarData['dob']}");
                            print("XXXXXXXco:${aadhaarData['co']}");
                            print("XXXXXXXlm: ${aadhaarData['lm']}");
                            print("XXXXXXXloc: ${aadhaarData['loc']}");
                            print("XXXXXXXvtc: ${aadhaarData['vtc']}");
                            print("XXXXXXXpo: ${aadhaarData['po']}");
                            print("XXXXXXXdist: ${aadhaarData['dist']}");
                            print("XXXXXXXsubdist: ${aadhaarData['subdist']}");
                            print("XXXXXXXstate: ${aadhaarData['state']}");
                            print("XXXXXXXpc: ${aadhaarData['pc']}");


                            setState(() {
                              kycType = "Q";

                              if(aadhaarData['name']!.isEmpty){
                                nameFlag = true;
                                mNameFlag = true;
                                lNameFlag = true;
                              }else{
                                List<String> nameParts = aadhaarData['name']!.split(" ");
                                if (nameParts.length == 1) {
                                  _nameController.text = nameParts[0];
                                  mNameFlag = true;
                                  lNameFlag = true;
                                } else if (nameParts.length == 2) {
                                  mNameFlag = true;
                                  _nameController.text = nameParts[0];
                                  _nameLController.text = nameParts[1];
                                } else {
                                  _nameController.text = nameParts.first;
                                  _nameLController.text = nameParts.last;
                                  _nameMController.text =nameParts.sublist(1, nameParts.length - 1).join(' ');
                                }
                              }

                           if(aadhaarData['dob'] == null){
                             dobFlag = true;
                           }else{
                             _dobController.text = formatDate(aadhaarData['dob']!.trim(), 'dd-MM-yyyy');

                           }

                            if(aadhaarData['gender'] ==null){
                              genderFlag = true;
                              titleFlag = true;
                            }else if (aadhaarData['gender'].toString().trim().toLowerCase() == "m") {
                              genderselected = "Male";
                              selectedTitle = "Mr.";
                            } else if (aadhaarData['gender'].toString().trim().toLowerCase() == "f") {
                              genderselected = "Female";
                              selectedTitle = "Mrs.";
                            }
                            if(aadhaarData['co'] ==null){
                              ffNameFlag = true;
                              flNameFlag = true;
                              fmNameFlag = true;
                              gurFlag = true;
                              sfNameFlag = true;
                              smNameFlag = true;
                              slNameFlag = true;
                            } else if (aadhaarData['co']!.toLowerCase().contains("s/o") ||
                                aadhaarData['co']!.toLowerCase().contains("d/o")) {
                              relationwithBorrowerselected = "Father";
                              maritalFlag = true;
                              _gurNameController.text = replaceCharFromName(aadhaarData['co']!);

                              List<String> guarNameParts = replaceCharFromName(
                                  aadhaarData['co']!.trim()).split(" ");

                              if (guarNameParts.length == 1) {
                                _fatherFirstNameController.text = guarNameParts[0];
                                flNameFlag = true;
                                fmNameFlag = true;
                              } else if (guarNameParts.length == 2) {
                                fmNameFlag = true;
                                _fatherFirstNameController.text = guarNameParts[0];
                                _fatherLastNameController.text = guarNameParts[1];
                              } else {
                                _fatherFirstNameController.text = guarNameParts.first;
                                _fatherLastNameController.text = guarNameParts.last;
                                _fatherMiddleNameController.text =
                                    guarNameParts.sublist(1, guarNameParts.length - 1).join(' ');
                              }

                            } else if (aadhaarData['co']!.toLowerCase().contains("w/o")) {

                              relationwithBorrowerselected = "Husband";
                              selectedMarritalStatus = "Married";
                              _gurNameController.text = replaceCharFromName(aadhaarData['co']!);

                              List<String> guarNameParts =
                              replaceCharFromName(aadhaarData['co']!).split(" ");

                              if (guarNameParts.length == 1) {
                                smNameFlag = true;
                                slNameFlag = true;
                                _spouseFirstNameController.text = guarNameParts[0];
                              } else if (guarNameParts.length == 2) {
                                smNameFlag = true;
                                _spouseFirstNameController.text = guarNameParts[0];
                                _spouseLastNameController.text = guarNameParts[1];
                              } else {
                                _spouseFirstNameController.text = guarNameParts.first;
                                _spouseLastNameController.text = guarNameParts.last;
                                _spouseMiddleNameController.text =guarNameParts.sublist(1, guarNameParts.length - 1).join(' ');
                              }

                            } else if (aadhaarData['co']!.toLowerCase().contains("c/o")) {
                              _gurNameController.text = replaceCharFromName(aadhaarData['co']!);
                              ffNameFlag = true;
                              flNameFlag = true;
                              fmNameFlag = true;
                              sfNameFlag = true;
                              smNameFlag = true;
                              slNameFlag = true;
                            }

                            if(aadhaarData['lm']==null&&aadhaarData['loc']==null&&aadhaarData['vtc']==null&&aadhaarData['po']==null&&aadhaarData['subdist']==null){
                              add1Flag = true;
                              add2Flag = true;
                              add3Flag = true;
                            }else{
                              String address = [
                                aadhaarData['lm'],
                                aadhaarData['loc'],
                                aadhaarData['vtc'],
                                aadhaarData['po'],
                                aadhaarData['subdist'],
                              ].where((e) => e != null && e!.trim().isNotEmpty).join(', ');

                              List<String> addressParts = address.trim().split(",");
                              print("RRRRRRRRRR$addressParts");
                              if (addressParts.length == 1) {
                                _address1Controller.text = addressParts[0];
                                add2Flag = true;
                                add3Flag = true;
                              } else if (addressParts.length == 2) {
                                add2Flag = true;
                                _address1Controller.text = addressParts[0];
                                _address2Controller.text = addressParts[1];
                              } else {
                                _address1Controller.text = addressParts.first;
                                _address2Controller.text = addressParts.last;
                                _address3Controller.text =addressParts.sublist(1, addressParts.length - 1).join(' ');
                              }
                            }

                            if(aadhaarData['state'] == null){
                              statesFLag = true;
                            }else{
                              stateselected = states.firstWhere((item) =>item.descriptionEn.toLowerCase() ==aadhaarData['state']!.trim().toLowerCase());
                            }
                            if(aadhaarData['pc'] == null){
                              pinFlag = true;
                            }else{
                              _pincodeController.text = aadhaarData['pc']!;
                            }
                            if(aadhaarData['dist'] == null){
                              cityFlag = true;
                            }else{
                              _cityController.text = aadhaarData['dist']!;
                            }

                            });
                          }else {
                            setQRData(result.replaceAll('[', "").replaceAll(
                                ']', "")); // Process the result as needed
                          }
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
                        borderRadius:
                            BorderRadius.circular(5), // Adjust as needed
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10), // Space between buttons
                // Adhaar Back Button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      showFinoConcent(context);
                    },
                    child: Text(
                      'Data Fetch By Morpho',
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
          content: Text(AppLocalizations.of(context)!.unabletofetchthelocation),
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
                          showToast_Error(AppLocalizations.of(context)!
                              .pleaseenterotpproperly);
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
                                      return AppLocalizations.of(context)!
                                          .aadhaaridfieldcannotbeempty;
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
                          onChanged: titleFlag?(String? newValue) {
                            setState(() {
                              selectedTitle = newValue!;
                            });
                          }:null,
                          items: titleList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              enabled: titleFlag,
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
                  child: _buildTextField2(
                      AppLocalizations.of(context)!.name,
                      _nameController,
                      TextInputType.text,
                      30,
                      nameReg,
                      nameFlag),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                    child: _buildTextField2(
                        AppLocalizations.of(context)!.mname,
                        _nameMController,
                        TextInputType.text,
                        30,
                        nameReg,
                        mNameFlag)),
                SizedBox(width: 10),
                // Add spacing between the text fields if needed
                Expanded(
                    child: _buildTextField2(
                        AppLocalizations.of(context)!.lname,
                        _nameLController,
                        TextInputType.text,
                        30,
                        nameReg,
                        lNameFlag)),
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
                            enabled: gurFlag,
                            decoration: InputDecoration(
                              counterText: "",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .pleaseenterguardianname;
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(nameReg)),
                              // Allow only alphanumeric characters // Optional: to deny spaces
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
                            onChanged: genderFlag?(String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  genderselected =
                                      newValue; // Update the selected value
                                });
                              }
                            }: null,
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
                            onChanged: relationwithBorrowerFLag?(String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  relationwithBorrowerselected =
                                      newValue; // Update the selected value
                                });
                              }
                            }:null,
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
                              keyboardType: TextInputType.number,
                              // Set the input type
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(), counterText: ""),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .pleaseentermobileno;
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('[a-zA-Z0-9]')),
                                // Allow only alphanumeric characters // Optional: to deny spaces
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
                              showToast_Error(AppLocalizations.of(context)!
                                  .pleaseentermobileno);
                            } else if (_mobileNoController.text.length != 10) {
                              showToast_Error(AppLocalizations.of(context)!
                                  .pleaseentercorrectmobilenumber);
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
            Text(
              AppLocalizations.of(context)!.alternateMobile,
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
                    controller: mobileController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      errorText: _mobileError,
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      // Only digits allowed
                      LengthLimitingTextInputFormatter(10),
                      // Maximum length of 10
                    ],
                  ),
                )),
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
                          enabled: dobFlag,
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

            _buildTextField2(
                AppLocalizations.of(context)!.ffnane,
                _fatherFirstNameController,
                TextInputType.text,
                30,
                nameReg,
                ffNameFlag),

            Row(
              children: [
                Expanded(
                  child: _buildTextField2(
                      AppLocalizations.of(context)!.mname,
                      _fatherMiddleNameController,
                      TextInputType.text,
                      30,
                      nameReg,
                      fmNameFlag),
                ),
                SizedBox(width: 8),
                // Add spacing between the text fields if needed
                Expanded(
                    child: _buildTextField2(
                        AppLocalizations.of(context)!.lname,
                        _fatherLastNameController,
                        TextInputType.text,
                        30,
                        nameReg,
                        flNameFlag)),
              ],
            ),

            SizedBox(
              height: 4,
            ),

            _buildTextField2(AppLocalizations.of(context)!.mothername,
                _motherFController, TextInputType.text, 30, nameReg, true),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Flexible(
                    child: _buildTextField2(AppLocalizations.of(context)!.mname,
                        _motherMController, TextInputType.text, 30, nameReg, true)),
                SizedBox(width: 13),
                // Add spacing between the text fields if needed
                Flexible(
                    child: _buildTextField2(AppLocalizations.of(context)!.lname,
                        _motherLController, TextInputType.text, 30, nameReg, true)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            _buildTextField2(AppLocalizations.of(context)!.address1,
                _address1Controller, TextInputType.text, 50, addReg, add1Flag),
            _buildTextField2(AppLocalizations.of(context)!.address2,
                _address2Controller, TextInputType.text, 50, addReg, add2Flag),
            _buildTextField2(AppLocalizations.of(context)!.address3,
                _address3Controller, TextInputType.text, 50, addReg, add3Flag),
            Row(
              children: [
                Expanded(
                  child: _buildTextField2(
                      AppLocalizations.of(context)!.city,
                      _cityController,
                      TextInputType.text,
                      30,
                      cityReg,
                      cityFlag),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildTextField2(
                      AppLocalizations.of(context)!.pincode,
                      _pincodeController,
                      TextInputType.number,
                      6,
                      amountReg,
                      pinFlag),
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),

            _buildLabeledDropdownField(AppLocalizations.of(context)!.sstate,
                'State', states, stateselected,statesFLag, (RangeCategoryDataModel? newValue) {
                  setState(() {
                    stateselected = newValue;
                  });
                }, String),

            _buildTextField2(AppLocalizations.of(context)!.loanamount,
                _loan_amountController, TextInputType.number, 7, amountReg, true),

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

            SizedBox(
              height: 10,
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
                onChanged: maritalFlag?(String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedMarritalStatus = newValue;
                    });
                  }
                }:null,
                items: marrital_status
                    .map<DropdownMenuItem<String>>((RangeCategoryDataModel state) {
                  return DropdownMenuItem<String>(
                    value: state.code,
                    enabled: maritalFlag,
                    child: Text(state.descriptionEn),
                  );
                }).toList(),
              ),
            ),
            // Conditionally show the spouse fields only when isMarried is true
            if (selectedMarritalStatus.toString() == 'Married')
              Column(
                children: [
                  _buildTextField2(
                      AppLocalizations.of(context)!.sfname,
                      _spouseFirstNameController,
                      TextInputType.text,
                      30,
                      nameReg,
                      sfNameFlag),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField2(
                            AppLocalizations.of(context)!.mname,
                            _spouseMiddleNameController,
                            TextInputType.text,
                            30,
                            nameReg,
                            smNameFlag),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: _buildTextField2(
                            AppLocalizations.of(context)!.lname,
                            _spouseLastNameController,
                            TextInputType.text,
                            30,
                            nameReg,
                            slNameFlag),
                      ),
                    ],
                  ),
                ],
              ),
            SizedBox(
              height: 10,
            ),

            if (selectedMarritalStatus.toString() != 'Unmarried' && selectedMarritalStatus.toString() != "" && selectedMarritalStatus.toString() !="Select")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.noofchildren,
                    style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton<String>(
                      value: selectednumOfChildren,
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
                          selectednumOfChildren = newValue!;
                        });
                      }
                          ,
                      items: onetonine.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)!.schoolgoingchildren,
                    style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton<String>(
                      value: selectedschoolingChildren,
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
                          selectedschoolingChildren = newValue!;
                        });
                      },
                      items: onetonine.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],),


            SizedBox(
              height: 10,
            ),
            Text(
              AppLocalizations.of(context)!.otherdependentis,
              style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButton<String>(
                value: selectedotherDependents,
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
                    selectedotherDependents = newValue!;
                  });
                },
                items: onetonine.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        ));
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
                            keyboardType: TextInputType.text,
                            // Set the input type
                            decoration: InputDecoration(
                                border: OutlineInputBorder(), counterText: ""),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.pleaseenterpannumber;
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[a-zA-Z0-9]')),
                              // Allow only alphanumeric characters // Optional: to deny spaces
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
                      showToast_Error(AppLocalizations.of(context)!
                          .pleaseentercorrectpanno);
                    } else if(panVerified){
                      showToast_Error("Already Verified");

                    }else {
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
          panCardHolderName == null
              ? Text(
                  AppLocalizations.of(context)!
                      .pleasesearchpancardholdernameforverification,
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
                child: _buildTextField2(
                    AppLocalizations.of(context)!.dl,
                    _drivingLicenseController,
                    TextInputType.text,
                    18,
                    IdsReg,
                    true),
              ),
              SizedBox(width: 10),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: () {
                    if (_drivingLicenseController.text.isEmpty ||
                        _drivingLicenseController.text.length < 10) {
                      showToast_Error(AppLocalizations.of(context)!
                          .pleaseentercorrectdrivinglicense);
                    } else if(dlVerified){
                      showToast_Error("Already Verified");

                    }else {
                      dlVerifyByProtean(GlobalClass.EmpId,
                          _drivingLicenseController.text, dobForProtien!);
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
                  AppLocalizations.of(context)!
                      .pleasesearchdrivinglicenseholdernameforverification,
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
                child: _buildTextField2(
                    AppLocalizations.of(context)!.voter,
                    _voterIdController,
                    TextInputType.text,
                    17,
                    IdsReg,
                    true),
              ),
              SizedBox(width: 10),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: () {
                    if (_voterIdController.text.isEmpty) {
                      showToast_Error(
                          AppLocalizations.of(context)!.pleaseentervoterno);
                    } else if(voterVerified){
                      showToast_Error("Already Verified");
                    }else {
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
                  AppLocalizations.of(context)!
                      .pleasesearchvotercardholdernameforverification,
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
          _buildLabeledDropdownField(AppLocalizations.of(context)!.selectcity,
              'Cities', listCityCodes, selectedCityCode,true, (PlaceData? newValue) {
            setState(() {
              selectedCityCode = newValue;
              selectedDistrictCode = null;
              selectedSubDistrictCode = null;
              selectedVillageCode = null;
            });
          }, String),
          _buildLabeledDropdownField(
              AppLocalizations.of(context)!.selectdistric,
              'Districts',
              listDistrictCodes,
              selectedDistrictCode,true, (PlaceData? newValue) {
            setState(() {
              selectedDistrictCode = newValue;
              selectedSubDistrictCode = null;
              selectedVillageCode = null;
              getPlace("subdistrict", stateselected!.code,
                  selectedDistrictCode!.distCode!, "");
            });
          }, String),
          _buildLabeledDropdownField(
              AppLocalizations.of(context)!.selectsubdistric,
              'Sub-Districts',
              listSubDistrictCodes,
              selectedSubDistrictCode,true, (PlaceData? newValue) {
            setState(() {
              selectedSubDistrictCode = newValue;
              selectedVillageCode = null;
              getPlace(
                  "village",
                  stateselected!.code,
                  selectedDistrictCode!.distCode!,
                  selectedSubDistrictCode!.subDistCode!);
            });
          }, String),
          _buildLabeledDropdownField(
              AppLocalizations.of(context)!.selectvillage,
              'Village',
              listVillagesCodes,
              selectedVillageCode,true, (PlaceData? newValue) {
            setState(() {
              selectedVillageCode = newValue;
             });
          }, String),
        ],
      ),
    );
  }

  Widget _buildLabeledDropdownField<T>(String labelText, String label, List<T> items, T? selectedValue,bool enabled, ValueChanged<T?>? onChanged, Type objName) {
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
              width: double.infinity,
              // Ensure the dropdown takes the full width available
              child: DropdownButtonFormField<T>(
                isExpanded: true,
                // Ensure the dropdown expands to fit its content
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: label,
                  enabled: enabled,
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
                onChanged: enabled?onChanged:null,
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
        showToast_Error(
            '${AppLocalizations.of(context)!.thisidisnotverified} $response');
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

            docVerifyIDC("drivinglicense", _drivingLicenseController.text, "",
                dobForIDLC!);
          }
        });
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();

        docVerifyIDC(
            "drivinglicense", _drivingLicenseController.text, "", dobForIDLC!);
      }
    } catch (e) {
      // Handle errors
      docVerifyIDC(
          "drivinglicense", _drivingLicenseController.text, "", dobForIDLC!);
      EasyLoading.dismiss();
    }
    EasyLoading.dismiss();
  }

  void voterVerifyByProtean(String userid, String voterNo) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      EasyLoading.show(
        status: AppLocalizations.of(context)!.loading,
      );
    });
    try {
      Map<String, dynamic> requestBody = {
        "userID": userid,
        "voterno": voterNo,
      };
      final response =
          await apiService_protean.getVoteretailsProtean(requestBody);

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

        onPressed: () {
          if (_currentStep == 0) {
            if (FiType == "NEW") {
              if (firstPageFieldValidate()) {
                setState(() {
                  if(genderFlag||relationwithBorrowerFLag||statesFLag||pinFlag||cityFlag||add3Flag||add2Flag||add1Flag||gurFlag||dobFlag||lNameFlag||mNameFlag||nameFlag||titleFlag){
                    kycType = "M";
                  }
                  if(selectedMarritalStatus.toString() == "Unmarried"){
                    selectedschoolingChildren = "0";
                    selectednumOfChildren = "0";
                  }
                });

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
            if (secondPageFieldValidate()) {
              saveIDsMethod(context);
            }
          }
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

  Future<void> verifyDocs(BuildContext context, String idNoController,String type, String ifsc, String dob) async {
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

  void getPlace(String type, String stateCode, String districtCode,String subDistrictCode) async {
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
        GlobalClass.showErrorAlert(
            context, AppLocalizations.of(context)!.issueoccursinotpsending, 1);
      }
    }).catchError((onError) {
      EasyLoading.dismiss();
      GlobalClass.showErrorAlert(
          context, "Issue occurs in OTP sending...\n\n$onError", 1);
    });
  }

  void setQRData(result) {
    kycType = "Q";
    List<String> dataList = result.split(", ");

    setState(() {
      if (dataList.length > 14) {
        if (dataList[0].toLowerCase().startsWith("v")) {
          _aadharIdController.text = dataList[2];
          if (_aadharIdController.text.length != 12) {
            GlobalClass.showErrorAlert(context,
                AppLocalizations.of(context)!.pleaseenteraadhaarnumber, 1);
            _aadharIdController.text = "";
          }
          List<String> nameParts = dataList[3].split(" ");
          if(dataList[3].isEmpty){
            nameFlag = true;
            mNameFlag = true;
            lNameFlag = true;
          }else if (nameParts.length == 1) {
            nameFlag = false;
            _nameController.text = nameParts[0];
          } else if (nameParts.length == 2) {
            nameFlag = false;
            lNameFlag = false;

            _nameController.text = nameParts[0];
            _nameLController.text = nameParts[1];
          } else {
            nameFlag = false;
            mNameFlag = false;
            lNameFlag = false;
            _nameController.text = nameParts.first;
            _nameLController.text = nameParts.last;
            _nameMController.text =nameParts.sublist(1, nameParts.length - 1).join(' ');
          }

          if(dataList[4].isEmpty){
            dobFlag = true;
          }else {
            _dobController.text = formatDate(dataList[4].trim(), 'dd-MM-yyyy');
          }
          setState(() {
            if(dataList[5].isEmpty){
              genderFlag = true;
              titleFlag = true;
            }else if (dataList[5].trim().toLowerCase() == "m") {
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
              maritalFlag = true;

              if(relationwithBorrowerselected.isEmpty){
                relationwithBorrowerFLag = true;
                ffNameFlag = true;
                fmNameFlag = true;
                flNameFlag = true;
              }

              if(dataList[6].isEmpty) {
                gurFlag = true;
              }else {
                List<String> guarNameParts = replaceCharFromName(
                    dataList[6].trim()).split(" ");

                if (guarNameParts.length == 1) {
                  ffNameFlag = false;
                  _fatherFirstNameController.text = guarNameParts[0];
                } else if (guarNameParts.length == 2) {
                  ffNameFlag = false;
                  flNameFlag = false;

                  _fatherFirstNameController.text = guarNameParts[0];
                  _fatherLastNameController.text = guarNameParts[1];
                } else {
                  ffNameFlag = false;
                  fmNameFlag = false;
                  flNameFlag = false;

                  _fatherFirstNameController.text = guarNameParts.first;
                  _fatherLastNameController.text = guarNameParts.last;
                  _fatherMiddleNameController.text =
                      guarNameParts.sublist(1, guarNameParts.length - 1).join(
                          ' ');
                }
              }
            });
          } else if (dataList[6].toLowerCase().contains("w/o")) {
            setState(() {
              relationwithBorrowerselected = "Husband";
              selectedMarritalStatus = "Married";

              if(relationwithBorrowerselected.isEmpty){
                relationwithBorrowerFLag = true;
                sfNameFlag = true;
                maritalFlag = true;
                smNameFlag = true;
                slNameFlag = true;
              }else {
                List<String> guarNameParts =
                replaceCharFromName(dataList[6]).split(" ");

                if (guarNameParts.length == 1) {
                  sfNameFlag = false;
                  _spouseFirstNameController.text = guarNameParts[0];
                } else if (guarNameParts.length == 2) {
                  sfNameFlag = false;
                  slNameFlag = false;

                  _spouseFirstNameController.text = guarNameParts[0];
                  _spouseLastNameController.text = guarNameParts[1];
                } else {
                  sfNameFlag = false;
                  smNameFlag = false;
                  slNameFlag = false;

                  _spouseFirstNameController.text = guarNameParts.first;
                  _spouseLastNameController.text = guarNameParts.last;
                  _spouseMiddleNameController.text =
                      guarNameParts.sublist(1, guarNameParts.length - 1).join(
                          ' ');
                }
              }
            });
          }
          if(dataList[7].isEmpty){
            cityFlag = true;
          }else{
            _cityController.text = dataList[7];
          }
          if(dataList[6].isEmpty){
            gurFlag = true;
          }else{
            _gurNameController.text = replaceCharFromName(dataList[6]);
            gurFlag = false;
          }

          if (dataList[0].toLowerCase() == 'v2') {

            if(dataList[11].isEmpty){
              pinFlag = true;
            }else{
              _pincodeController.text = dataList[11];
            }

            if(dataList[13].isEmpty){
              statesFLag = true;
            }else{
              stateselected = states.firstWhere((item) =>
              item.descriptionEn.toLowerCase() ==

                  dataList[13].trim().toLowerCase());
      }
            if(dataList[9].isEmpty&&dataList[10].isEmpty&&dataList[12].isEmpty&&dataList[14].isEmpty&&dataList[15].isEmpty){
              add1Flag = true;
              add2Flag = true;
              add3Flag = true;
            }else {
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
          }
          else if (dataList[0].toLowerCase() == 'v4' && dataList[1].contains("3")) {
            print("V433");

            setState(() {
              if(dataList[13].isEmpty){
               statesFLag = true;
              }else{
                stateselected = states.firstWhere((item) =>
                item.descriptionEn.toLowerCase() == dataList[13].toLowerCase());
              }
              if(dataList[11].isEmpty){
                pinFlag = true;
              }else{
                _pincodeController.text = dataList[11];

              }
              if(dataList[9].isEmpty&&dataList[14].isEmpty&&dataList[7].isEmpty&&dataList[13].isEmpty) {
                add1Flag = true;
                add2Flag = true;
                add3Flag = true;
              }else {
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
                      addressParts.sublist(1, addressParts.length - 1).join(
                          ' ');
                }
              }
            });
          }
          else if (dataList[0].toLowerCase() == 'v4') {
            int a = 0;

            setState(() {
              if(dataList[1].contains("2")){
                a=0;
              }
              if(dataList[14+a].isEmpty){
                statesFLag = true;
              }else {
                stateselected = states.firstWhere((item) =>
                item.descriptionEn.toLowerCase() == dataList[14].toLowerCase());
              }
              if(dataList[12+a].isEmpty){
                pinFlag = true;
              }else {
                _pincodeController.text = dataList[12+a];
              }
              if(dataList[10+a].isEmpty&&dataList[11+a].isEmpty&&dataList[13+a].isEmpty&&dataList[15+a].isEmpty&&dataList[16+a].isEmpty) {
                add1Flag = true;
                add2Flag = true;
                add3Flag = true;
              }else {
                String address =
                    "${dataList[10 + a]},${dataList[11 + a]},${dataList[13 +
                    a]},${dataList[15 + a]},${dataList[16 + a]}";

                List<String> addressParts = address.trim().split(",");
                if (addressParts.length == 1) {
                  _address1Controller.text = addressParts[0];
                  add2Flag = true;
                  add3Flag = true;
                } else if (addressParts.length == 2) {
                  add2Flag = true;
                  _address1Controller.text = addressParts[0];
                  _address2Controller.text = addressParts[1];
                } else {
                  _address1Controller.text = addressParts.first;
                  _address2Controller.text = addressParts.last;
                  _address3Controller.text =
                      addressParts.sublist(1, addressParts.length - 1).join(
                          ' ');
                }
              }
            });


          } else if (dataList[0].toLowerCase() == 'v3') {
            if(dataList[13].isEmpty){
              statesFLag = true;
            }else{
              stateselected = states.firstWhere((item) =>
              item.descriptionEn.toLowerCase() == dataList[13].toLowerCase());
            }
           if(dataList[11].isEmpty){
             pinFlag = true;
           }else {
             _pincodeController.text = dataList[11];
           }

            if(dataList[9].isEmpty&&dataList[14].isEmpty&&dataList[15].isEmpty&&dataList[12].isEmpty&&dataList[7].isEmpty) {
             add1Flag = true;
             add2Flag = true;
             add3Flag = true;
           }else {
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
               _address3Controller.text =addressParts.sublist(1, addressParts.length - 1).join(' ');
             }
           }
          }
        }
        else if(dataList[0].toLowerCase().startsWith("3")) {
          print("SSSSSSSSSS");
          _aadharIdController.text = dataList[1];
          if (_aadharIdController.text.length != 12) {
            GlobalClass.showErrorAlert(context,
                AppLocalizations.of(context)!.pleaseenteraadhaarnumber, 1);
            _aadharIdController.text = "";
          }
          if(dataList[2].isEmpty){
            nameFlag = true;
            mNameFlag = true;
            lNameFlag = true;
          }
          else {
            List<String> nameParts = dataList[2].split(" ");
            if (nameParts.length == 1) {
              _nameController.text = nameParts[0];
              mNameFlag = true;
              lNameFlag = true;
            } else if (nameParts.length == 2) {
              mNameFlag = true;

              _nameController.text = nameParts[0];
              _nameLController.text = nameParts[1];
            } else {
              _nameController.text = nameParts.first;
              _nameLController.text = nameParts.last;
              _nameMController.text =
                  nameParts.sublist(1, nameParts.length - 1).join(' ');
            }
          }
          if(dataList[3].isEmpty){
            dobFlag = true;
          }
          else{
            _dobController.text = formatDate(dataList[3], 'dd-MM-yyyy');
          }
          setState(() {
            if (dataList[4].toLowerCase() == "m") {
              genderselected = "Male";
              selectedTitle = "Mr.";
            } else if (dataList[4].toLowerCase() == "f") {
              genderselected = "Female";
              selectedTitle = "Mrs.";
            }
            if(genderselected.isEmpty || genderselected ==""){
              genderFlag = true;
              titleFlag =true;
            }
          });

          if(dataList[5].isEmpty){
            gurFlag = true;
            ffNameFlag = true;
            fmNameFlag = true;
            flNameFlag = true;
            sfNameFlag = true;
            smNameFlag = true;
            slNameFlag = true;
          }
          else {
            if (dataList[5].toLowerCase().contains("s/o") ||
                dataList[5].toLowerCase().contains("d/o")) {
              setState(() {
                relationwithBorrowerselected = "Father";
                sfNameFlag = true;
                smNameFlag = true;
                slNameFlag = true;
                _gurNameController.text = replaceCharFromName(dataList[5]);

                List<String> guarNameParts =
                replaceCharFromName(dataList[5]).split(" ");
                if (guarNameParts.length == 1) {
                  _fatherFirstNameController.text = guarNameParts[0];
                  fmNameFlag = true;
                  flNameFlag = true;
                } else if (guarNameParts.length == 2) {
                  _fatherFirstNameController.text = guarNameParts[0];
                  _fatherLastNameController.text = guarNameParts[1];
                  fmNameFlag = true;

                } else {
                  _fatherFirstNameController.text = guarNameParts.first;
                  _fatherLastNameController.text = guarNameParts.last;
                  _fatherMiddleNameController.text =guarNameParts.sublist(1, guarNameParts.length - 1).join(' ');
                }
              });
            }
            else if (dataList[5].toLowerCase().contains("w/o")) {
              setState(() {
                relationwithBorrowerselected = "Husband";
                selectedMarritalStatus = "Married";

                ffNameFlag = true;
                fmNameFlag = true;
                flNameFlag = true;
                List<String> guarNameParts =
                replaceCharFromName(dataList[5]).split(" ");
                if (guarNameParts.length == 1) {
                  smNameFlag = true;
                  slNameFlag = true;
                  _spouseFirstNameController.text = guarNameParts[0];
                } else if (guarNameParts.length == 2) {
                  smNameFlag = true;

                  _spouseFirstNameController.text = guarNameParts[0];
                  _spouseLastNameController.text = guarNameParts[1];
                } else {
                  _spouseFirstNameController.text = guarNameParts.first;
                  _spouseLastNameController.text = guarNameParts.last;
                  _spouseMiddleNameController.text =
                      guarNameParts.sublist(1, guarNameParts.length - 1).join(
                          ' ');
                }
              });
            }
            else if (dataList[5].toLowerCase().contains("c/o")) {
              setState(() {

                ffNameFlag = true;
                fmNameFlag = true;
                flNameFlag = true;
                relationwithBorrowerFLag = true;
                sfNameFlag = true;
                smNameFlag = true;
                slNameFlag = true;
                _gurNameController.text = replaceCharFromName(dataList[5]);
                maritalFlag = true;

              });
            } else {
              gurFlag = true;
              ffNameFlag = true;
              fmNameFlag = true;
              flNameFlag = true;
              relationwithBorrowerFLag = true;
              sfNameFlag = true;
              smNameFlag = true;
              maritalFlag = true;

              slNameFlag = true;
            }
          }
          if(dataList.length==16) {
            print("satish");
            if (dataList[6].isEmpty) {
              cityFlag = true;
            } else {
              _cityController.text = dataList[6];
            }

            if (dataList[10].isEmpty) {
              pinFlag = true;
            } else {
              _pincodeController.text = dataList[10];
            }
            if (dataList[12].isEmpty) {
              statesFLag = true;
            } else {
              stateselected = states.firstWhere((item) =>
              item.descriptionEn.toLowerCase() == dataList[12].toLowerCase());
            }
            if (dataList[8].isEmpty && dataList[9].isEmpty &&
                dataList[7].isEmpty&&
                dataList[11].isEmpty&&
                dataList[13].isEmpty) {
              add1Flag = true;
              add2Flag = true;
              add3Flag = true;
            } else {
              String address =
                  "${dataList[8]},${dataList[9]},${dataList[7]},${dataList[11]},${dataList[13]}";
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
          else {
            print("mohit");

            if (dataList[6].isEmpty) {
              cityFlag = true;
            } else {
              _cityController.text = dataList[6];
            }

            if (dataList[11].isEmpty) {
              pinFlag = true;
            } else {
              _pincodeController.text = dataList[11];
            }
            if (dataList[13].isEmpty) {
              statesFLag = true;
            } else {
              stateselected = states.firstWhere((item) =>
              item.descriptionEn.toLowerCase() == dataList[13].toLowerCase());
            }
            if (dataList[9].isEmpty && dataList[10].isEmpty &&dataList[8].isEmpty&&dataList[12].isEmpty) {
              add1Flag = true;
              add2Flag = true;
              add3Flag = true;
            } else {
              String address =
                  "${dataList[9]},${dataList[10]},${dataList[8]},${dataList[12]}";
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
        else {
          _aadharIdController.text = dataList[1];
          if (_aadharIdController.text.length != 12) {
            GlobalClass.showErrorAlert(context,
                AppLocalizations.of(context)!.pleaseenteraadhaarnumber, 1);
            _aadharIdController.text = "";
          }
          if(dataList[2].isEmpty){
            nameFlag = true;
            mNameFlag = true;
            lNameFlag = true;
          }else {
            List<String> nameParts = dataList[2].split(" ");
            if (nameParts.length == 1) {
              _nameController.text = nameParts[0];
              mNameFlag = true;
              lNameFlag = true;
            } else if (nameParts.length == 2) {
              mNameFlag = true;

              _nameController.text = nameParts[0];
              _nameLController.text = nameParts[1];
            } else {
              _nameController.text = nameParts.first;
              _nameLController.text = nameParts.last;
              _nameMController.text =
                  nameParts.sublist(1, nameParts.length - 1).join(' ');
            }
          }
          if(dataList[3].isEmpty){
            dobFlag = true;
          }else{
            _dobController.text = formatDate(dataList[3], 'dd-MM-yyyy');
          }
          setState(() {
            if (dataList[4].toLowerCase() == "m") {
              genderselected = "Male";
              selectedTitle = "Mr.";
            } else if (dataList[4].toLowerCase() == "f") {
              genderselected = "Female";
              selectedTitle = "Mrs.";
            }
            if(genderselected.isEmpty || genderselected ==""){
              genderFlag = true;
              titleFlag =true;
            }
          });

          if(dataList[5].isEmpty){
            gurFlag = true;
            ffNameFlag = true;
            fmNameFlag = true;
            flNameFlag = true;
            sfNameFlag = true;
            smNameFlag = true;
            slNameFlag = true;
          }else {
            if (dataList[5].toLowerCase().contains("s/o") ||
                dataList[5].toLowerCase().contains("d/o")) {
              setState(() {
                relationwithBorrowerselected = "Father";
                sfNameFlag = true;
                smNameFlag = true;
                slNameFlag = true;
                maritalFlag = true;

                _gurNameController.text = replaceCharFromName(dataList[5]);

                List<String> guarNameParts =
                replaceCharFromName(dataList[5]).split(" ");
                if (guarNameParts.length == 1) {
                  _fatherFirstNameController.text = guarNameParts[0];
                  fmNameFlag = true;
                  flNameFlag = true;
                } else if (guarNameParts.length == 2) {
                  _fatherFirstNameController.text = guarNameParts[0];
                  _fatherLastNameController.text = guarNameParts[1];
                  fmNameFlag = true;

                } else {
                  _fatherFirstNameController.text = guarNameParts.first;
                  _fatherLastNameController.text = guarNameParts.last;
                  _fatherMiddleNameController.text =guarNameParts.sublist(1, guarNameParts.length - 1).join(' ');
                }
              });
            }
            else if (dataList[5].toLowerCase().contains("w/o")) {
              setState(() {
                relationwithBorrowerselected = "Husband";
                selectedMarritalStatus = "Married";
                _gurNameController.text = replaceCharFromName(dataList[5]);

                ffNameFlag = true;
                fmNameFlag = true;
                flNameFlag = true;
                List<String> guarNameParts =
                replaceCharFromName(dataList[5]).split(" ");
                if (guarNameParts.length == 1) {
                  smNameFlag = true;
                  slNameFlag = true;
                  _spouseFirstNameController.text = guarNameParts[0];
                } else if (guarNameParts.length == 2) {
                  smNameFlag = true;

                  _spouseFirstNameController.text = guarNameParts[0];
                  _spouseLastNameController.text = guarNameParts[1];
                } else {
                  _spouseFirstNameController.text = guarNameParts.first;
                  _spouseLastNameController.text = guarNameParts.last;
                  _spouseMiddleNameController.text =
                      guarNameParts.sublist(1, guarNameParts.length - 1).join(
                          ' ');
                }
              });
            } else {
              gurFlag = true;
              ffNameFlag = true;
              fmNameFlag = true;
              flNameFlag = true;
              relationwithBorrowerFLag = true;
              sfNameFlag = true;
              smNameFlag = true;
              slNameFlag = true;
            }
          }

          if(dataList[6].isEmpty){
            cityFlag = true;
          }else{
            _cityController.text = dataList[6];

          }

          if(dataList[10].isEmpty){
            pinFlag = true;
          }else{
            _pincodeController.text = dataList[10];

          }
          if(dataList[12].isEmpty){
            statesFLag = true;
          }else {
            stateselected = states.firstWhere((item) =>
            item.descriptionEn.toLowerCase() == dataList[12].toLowerCase());
          }
          if(dataList[8].isEmpty&&dataList[9].isEmpty&&dataList[11].isEmpty&&dataList[13].isEmpty&&dataList[14].isEmpty) {
            add1Flag = true;
            add2Flag = true;
            add3Flag = true;

          }else {
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
    });

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
          kycType = "O";

          EasyLoading.dismiss();
          if (type == "adharFront") {
            setState(() {
              _aadharIdController.text = response.data.adharId;
              if(_aadharIdController.text.length == 12){
              print("dataaaadtat");
              adhaarAllData(context);
              }

              if(response.data.name.isEmpty){
                nameFlag = true;
                mNameFlag = true;
                lNameFlag = true;
              }
              List<String> nameParts = response.data.name.trim().split(" ");
              if (nameParts.length == 1) {
                _nameController.text = nameParts[0];
                mNameFlag = true;
                lNameFlag = true;
              } else if (nameParts.length == 2) {
                _nameController.text = nameParts[0];
                mNameFlag = true;

                _nameLController.text = nameParts[1];
              } else {
                _nameController.text = nameParts.first;
                _nameLController.text = nameParts.last;
                _nameMController.text =
                    nameParts.sublist(1, nameParts.length - 1).join(' ');
              }

              if(response.data.dob.isEmpty){
                dobFlag =true;
              }else{
                _dobController.text = formatDate(response.data.dob, 'dd/MM/yyyy');
              }
              genderselected = aadhar_gender
                  .firstWhere((item) =>
              item.descriptionEn.toLowerCase() ==
                  response.data.gender.toLowerCase())
                  .descriptionEn;
              if(genderselected.isEmpty){
                genderFlag = true;
                titleFlag =true;

              }

              if (genderselected == "Male") {
                selectedTitle = "Mr.";
              } else {
                selectedTitle = "Mrs.";
              }
            });
            Navigator.of(context).pop();
          }
          else if (type == "adharBack") {
            setState(() {

              if(response.data.pincode.isEmpty){
                pinFlag = true;
              }else {
                _pincodeController.text = response.data.pincode;
              }
              if(response.data.cityName.isEmpty){
                cityFlag = true;
              }else{
                _cityController.text = response.data.cityName;

              }
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

              if (response.data.relation.toLowerCase() == "father") {
                String cleanGuardianName(String name) {
                  return name.replaceAll(RegExp(r'[^a-zA-Z0-9.\s]'), '');
                }

                String cleanedGuardianName =
                cleanGuardianName(response.data.guardianName);
                // print(cleanedGuardianName $cleanedGuardianName);
                _gurNameController.text = cleanedGuardianName;
                gurFlag = false;
                relationwithBorrowerselected = "Father";
                maritalFlag = true;
                sfNameFlag = true;
                smNameFlag = true;
                slNameFlag = true;
                List<String> guarNameParts =
                _gurNameController.text.trim().split(" ");
                if (guarNameParts.length == 1) {
                  _fatherFirstNameController.text = guarNameParts[0];
                  fmNameFlag = true;
                  flNameFlag = true;
                } else if (guarNameParts.length == 2) {
                  _fatherFirstNameController.text = guarNameParts[0];
                  _fatherLastNameController.text = guarNameParts[1];
                  fmNameFlag = true;

                } else {
                  _fatherFirstNameController.text = guarNameParts.first;
                  _fatherLastNameController.text = guarNameParts.last;
                  _fatherMiddleNameController.text = guarNameParts
                      .sublist(1, guarNameParts.length - 1)
                      .join(' ');
                }
              } else if (response.data.relation.toLowerCase() == "husband") {
                relationwithBorrowerselected = "Husband";
                if(relationwithBorrowerselected.isEmpty){
                  relationwithBorrowerFLag = true;
                  maritalFlag = true;
                }
                selectedMarritalStatus = "Married";

                String cleanGuardianName(String name) {
                  return name.replaceAll(RegExp(r'[^a-zA-Z0-9.\s]'), '');
                }


                String cleanedGuardianName =
                cleanGuardianName(response.data.guardianName);

                _gurNameController.text = cleanedGuardianName;

                if(_gurNameController.text.isEmpty){
                  gurFlag = true;
                }

                List<String> guarNameParts =
                cleanedGuardianName.trim().split(" ");

                if (guarNameParts.length == 1) {
                  _spouseFirstNameController.text = guarNameParts[0];
                  smNameFlag = false;
                  slNameFlag = false;
                } else if (guarNameParts.length == 2) {
                  smNameFlag = false;
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

              stateselected = states.firstWhere((item) =>
              item.descriptionEn.toLowerCase() ==
                  response.data.stateName.toLowerCase());
            });
            Navigator.of(context).pop();

            EasyLoading.dismiss();
          }
        } else {
          showToast_Error(AppLocalizations.of(context)!
              .datanotfetchedfromthisaadhaarleasechecktheimage);
          Navigator.of(context).pop();
          EasyLoading.dismiss();
          setState(() {
            if(type == "adharFront"){
              nameFlag = true;
              mNameFlag = true;
              lNameFlag = true;
              genderFlag = true;
              titleFlag =true;

              dobFlag = true;
            }else if (type == "adharBack"){
              gurFlag = true;
              relationwithBorrowerFLag = true;
              add1Flag = true;
              add2Flag = true;
              add3Flag = true;
              pinFlag = true;
              cityFlag = true;
              statesFLag = true;
              ffNameFlag = true;
              fmNameFlag = true;
              flNameFlag = true;
              sfNameFlag = true;
              smNameFlag = true;
              slNameFlag = true;
            }
          });
        }
      } catch (_) {
        showToast_Error(AppLocalizations.of(context)!
            .datanotfetchedfromthisaadhaarleasechecktheimage);
        Navigator.of(context).pop();
        EasyLoading.dismiss();
        setState(() {
          if(type == "adharFront"){
            nameFlag = true;
            mNameFlag = true;
            lNameFlag = true;
            genderFlag = true;
            titleFlag =true;
            dobFlag = true;
          }else if (type == "adharBack"){
            gurFlag = true;
            relationwithBorrowerFLag = true;
            add1Flag = true;
            add2Flag = true;
            add3Flag = true;
            pinFlag = true;
            cityFlag = true;
            statesFLag = true;
            ffNameFlag = true;
            fmNameFlag = true;
            flNameFlag = true;
            sfNameFlag = true;
            smNameFlag = true;
            slNameFlag = true;
          }
        });

      }
    }
  }

  List<List<int>> separateData(
      List<int> source, int separatorByte, int vtcIndex) {
    List<List<int>> separatedParts = [];
    int begin = 0;

    for (int i = 0; i < source.length; i++) {
      if (source[i] == separatorByte) {
        if (i != 0 && i != (source.length - 1)) {
          separatedParts.add(source.sublist(begin, i));
        }
        begin = i + 1;
        if (separatedParts.length == (vtcIndex + 1)) {
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

  String replaceCharFromName(String gurName) {
    return gurName
        .toUpperCase()
        .replaceAll("S/O ", "")
        .replaceAll("S/O: ", "")
        .replaceAll("D/O ", "")
        .replaceAll("D/O: ", "")
        .replaceAll("C/O ", "")
        .replaceAll("C/O: ", "")
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

  void showFinoConcent(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing dialog when tapping outside
      builder: (BuildContext context) {
        bool? finoConsentValue = false;
        return StatefulBuilder(builder: (context,setState){
          return WillPopScope(
              onWillPop: () async =>
              false, // Prevent closing dialog with back button
              child: AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Center(
                    child: Text("Please read below consent before proceed",
                        style: TextStyle(
                            fontSize: 16,color: Colors.blue,fontWeight: FontWeight.bold
                        ))),
                content: SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //  mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Paisalo Digital Limited, as a Sub AUA/Sub KUA, will use your Aadhaar number to perform authentication via UIDAI. Upon successful authentication, only the following information will be shared with us by UIDAI:\n 1.) Aadhaar Number \n 2.) Demographic Information (Name, Gender, Date of Birth, Address, Photo)\n Note: We will only use this information for Aadhaar authentication and e-KYC purposes for your loan document e-signing. We will not collect or use any additional personal information beyond what is shared by UIDAI.\n If you are a parent or legal guardian of a child Aadhaar holder, please ensure that you understand and agree to this use on behalf of the child. By continuing, you confirm that you have been informed of:\n 1.) The nature of data shared by UIDAI during authentication.\n 2.) The specific use of this data by Paisalo Digital Limited.",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                        // Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                                value: finoConsentValue,
                                onChanged:(bool? value){
                                  setState(() {
                                    finoConsentValue = value;
                                  });
                                }
                            ),
                            Flexible(child: Text(
                              "Click Proceed to give your explicit consent.",
                              style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                fontSize: 10.0,
                                color: Color(0xFFD42D3F), // Custom color
                              ),
                            ),)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop(); // Close dialog
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                decoration: BoxDecoration(
                                  color: Colors.red[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (finoConsentValue!) {
                                  if (_aadharIdController.text.trim().isEmpty) {
                                    showToast_Error("Please enter Aadhaar number");
                                    return;
                                  }

                                  Navigator.of(context).pop();
                                  try {
                                    final resultrd = await callJavaMethodRd(_aadharIdController.text);
                                    print("callJavaMethodRd 11");

                                    if (resultrd != null) {
                                      final jsonMap = json.decode(resultrd);
                                      final model = FinoModel.fromJson(jsonMap);

                                      print("Name: ${model.poiName}, DOB: ${model.poiDob}");

                                      setState(() {
                                        _nameController.text = model.poiName ?? '';
                                        _dobController.text = model.poiDob ?? '';
                                      });
                                    }
                                  } catch (e) {
                                    print("Error: $e");
                                  }
                                } else {
                                  showToast_Error("Check Consent First");
                                }
                              },

                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 30),
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
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ));
        });
      },
    );
  }


  void showIDCardDialog( BuildContext context, DatabyAadhaarDataModel borrowerInfo, int page) {


    final String name = borrowerInfo.customerName;
    final String aadhaarNo = borrowerInfo.aadharNo;
    final String maskedaadhaarNo = AadhaarMasker(aadhaarNo);
    final String dob = borrowerInfo.dob.toString();
    final String Ficode = borrowerInfo.fiCode.toString();
    final String Creator = borrowerInfo.creatorName.toString();
    final String caseStatus = borrowerInfo.caseStatus.toString();

    String datePart = dob.split('T')[0];

    List<String> dateParts = datePart.split('-');
    String formattedDOB = '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';
    print("Formatted DOB (dd-MM-yyyy): $formattedDOB");
    DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(formattedDOB);
    dobForSaveFi = DateFormat('yyyy-MM-dd').format(parsedDate);
    dobForIDLC = DateFormat('yyyy/MM/dd').format(parsedDate);
    dobForProtien = DateFormat('dd-MM-yyyy').format(parsedDate);

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
                  child: Text(AppLocalizations.of(context)!.borrowerdetails,
                      style: TextStyle(
                        fontSize: 16,
                      ))),
              content: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  width: 300,
                  padding: EdgeInsets.all(2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                        '${AppLocalizations.of(context)!.adharid} $maskedaadhaarNo',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.start,
                      ),

                      SizedBox(height: 5),
                      // DOB

                      Text(
                        '${AppLocalizations.of(context)!.dobid} = $formattedDOB',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.start,
                      ),

                      SizedBox(height: 5),
                      // Loan Amount
                      Text(
                        '${AppLocalizations.of(context)!.ficode} $Ficode',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.start,
                      ),

                      SizedBox(height: 5),
                      // Loan Amount
                      Text('${AppLocalizations.of(context)!.creator} $Creator',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 5),
                      // Loan Amount
                      Text(
                          '${AppLocalizations.of(context)!.caseStatus} : $caseStatus',
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
                                      Fi_Id = borrowerInfo.fIId.toString();
                                      Fi_Code = borrowerInfo.fiCode.toString();
                                      dlDob = borrowerInfo.dob.toString();
                                      _dobController.text =
                                          borrowerInfo.dob.toString();
                                      _dobController.text = borrowerInfo.dob
                                          .toString()
                                          .split("T")[0];

                                      dlDob = borrowerInfo.dob
                                          .toString()
                                          .split("T")[0];

                                      if (borrowerInfo.pState.isNotEmpty) {
                                        stateselected = states.firstWhere(
                                            (item) =>
                                                item.code.toLowerCase() ==
                                                borrowerInfo.pState
                                                    .toLowerCase());
                                      }
                                      getPlace(
                                          "city", stateselected!.code, "", "");
                                      getPlace("district", stateselected!.code,
                                          "", "");
                                    });
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
    print("Called to invoke Java method");
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

  Future<String?> callJavaMethodRd(String adharno) async {
    const platform = MethodChannel('com.example.intent');
    try {
      final String resultrd = await platform.invokeMethod(
        'callJavaMethodRd',
        {'aadhaar': adharno},
      );
      return resultrd;
    } on PlatformException catch (e) {
      print("Failed to invoke Java method: ${e.message}");
      return null;
    }
  }


  String AadhaarMasker(String aadhaarNo) {
    return "xxxx xxxx " + aadhaarNo.substring(8);
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
          if (value.data[0].caseStatus.contains("KYC PEnding")) {
            EasyLoading.dismiss();

            Future.delayed(
                Duration.zero, () => showIDCardDialog(context, adhaardata!, 2));
          } else {
            EasyLoading.dismiss();
            Future.delayed(
                Duration.zero, () => showIDCardDialog(context, adhaardata!, 1));
          }
        } else {
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

  bool firstPageFieldValidate() {
    if (_aadharIdController.text.isEmpty) {
      showToast_Error(
          AppLocalizations.of(context)!.pleaseentercorrectaadhaarid);
      return false;
    }
    else if (selectedTitle == null) {
      showToast_Error(AppLocalizations.of(context)!.pleasechoosetitle);
      return false;
    } else if (_nameController.text.isEmpty) {
      showToast_Error(
          AppLocalizations.of(context)!.pleaseenterborrowerfirstname);
      return false;
    }

    else if (_gurNameController.text.isEmpty) {
      showToast_Error(AppLocalizations.of(context)!.pleaseenterguardianname);
      return false;
    } else if (genderselected.toLowerCase() == "select") {
      showToast_Error(AppLocalizations.of(context)!.pleaseselectborrowergender);
      return false;
    } else if (relationwithBorrowerselected.toLowerCase() == "select") {
      showToast_Error(AppLocalizations.of(context)!
          .pleaseselectborrowerrelationwithguardian);
      return false;
    } else if (_mobileNoController.text.isEmpty ||
        _mobileNoController.text.length != 10 ||
        !_mobileNoController.text.contains(RegExp(r'^[0-9]{10}$'))) {
      showToast_Error(AppLocalizations.of(context)!.pleaseentermobilenumber);
      return false;
    } else if (mobileController.text.isEmpty ||
        mobileController.text.length != 10 ||
        mobileController.text == _mobileNoController.text ||
        !mobileController.text.contains(RegExp(r'^[0-9]{10}$'))) {
      showToast_Error(
          AppLocalizations.of(context)!.pleaseentermobilenoalternate);
      return false;
    } else if (_dobController.text.isEmpty) {
      showToast_Error(AppLocalizations.of(context)!.pleaseenterdateofbirth);
      return false;
    } else if (_fatherFirstNameController.text.isEmpty) {
      showToast_Error(AppLocalizations.of(context)!.pleaseenterfatherfirstname);
      return false;
    }
    if (_motherFController.text.isEmpty) {
      showToast_Error(AppLocalizations.of(context)!.pleaseentermotherfirstname);
      return false;
    } else if (_loan_amountController.text.isEmpty) {
      showToast_Error(
          AppLocalizations.of(context)!.pleaseentercorrectloanamount);
      return false;
    } else if (!((int.parse(_loan_amountController.text)) >= 55000 &&
        (int.parse(_loan_amountController.text)) <= 300000)) {
      showToast_Error(AppLocalizations.of(context)!
          .loanamountshouldbelessthanthreelakhsandgreaterthan);
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
    }else if (selectedMarritalStatus == null ||selectedMarritalStatus!.toLowerCase() == "select") {
      showToast_Error(AppLocalizations.of(context)!.pleaseselectmaritalstatus);
      return false;
    }
    else if (selectedMarritalStatus!.toLowerCase() == "married" &&_spouseFirstNameController.text.isEmpty) {
      showToast_Error(
          AppLocalizations.of(context)!.pleaseenterspousefirstname);
      return false;
    } else if (selectedMarritalStatus!.toLowerCase() != "unmarried"&& selectednumOfChildren.toLowerCase() == 'select') {
      showToast_Error(
          AppLocalizations.of(context)!.pleaseselectnumberofchildren);
      return false;
    } else if (selectedMarritalStatus!.toLowerCase() != "unmarried"&&( selectedschoolingChildren.isEmpty ||
        selectedschoolingChildren.toLowerCase() == 'select')) {
      showToast_Error(
          AppLocalizations.of(context)!.pleaseselectschoolgoingchildren);
      return false;
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
    } else if (selectedotherDependents == null ||
        selectedotherDependents!.isEmpty ||
        selectedotherDependents!.toLowerCase() == 'select') {
      showToast_Error(
          AppLocalizations.of(context)!.pleaseselectotherdependents);
      return false;
    }  else if (_latitudeController.text.isEmpty ||
        _longitudeController.text.isEmpty) {
      showToast_Error(
          AppLocalizations.of(context)!.pleaseturnonlocationserviceofmobile);
      return false;
    } else if (_imageFile == null) {
      showToast_Error(
          AppLocalizations.of(context)!.pleasecaptureborrowerprofilepicture);
      return false;
    } else if (!otpVerified) {
      showToast_Error(
          AppLocalizations.of(context)!.pleaseverifymobilenumberwithotp);
      return false;
    }
    return true;
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
      String guardianName = _gurNameController.text.toString();
      String mobile = _mobileNoController.text.toString();
      String fatherF = _fatherFirstNameController.text.toString();
      String fatherM = _fatherMiddleNameController.text.toString();
      String fatherL = _fatherLastNameController.text.toString();
      String motherF = _motherFController.text.toString();
      String motherM = _motherMController.text.toString();
      String motherL = _motherLController.text.toString();
      String spouseF = _spouseFirstNameController.text.toString();
      String spouseM = _spouseMiddleNameController.text.toString();
      String spouseL = _spouseLastNameController.text.toString();
      lati = _latitudeController.text;
      longi = _longitudeController.text;
      int Expense = 0;
      int Income = 0;
      double latitude =(lati != null && lati.isNotEmpty) ? double.parse(lati) : 0.0;
      double longitude =(longi != null && longi.isNotEmpty) ? double.parse(longi) : 0.0;
      String add1 = _address1Controller.text.toString();
      String add2 = _address2Controller.text.toString();
      String add3 = _address3Controller.text.toString();
      String city = _cityController.text.toString();
      String pin = _pincodeController.text.toString();
      String state = stateselected!.code.toString();
      bool ismarried = selectedMarritalStatus.toString() == 'Married';
      String gCode = widget.GroupData.groupCode;
      String bCode = widget.data.branchCode.toString();
      String relation_with_Borrower = relationwithBorrowerselected;
      String bank_name = bankselected!.toString();
      String loan_Duration = selectedloanDuration!;
      String loan_amount = _loan_amountController.text.toString();
      int ModuleTypeId =GlobalClass.creator.toLowerCase().startsWith("vh") ? 2 : 1;
      String SelectedschoolingChildren = selectedschoolingChildren ==null?"0": selectedschoolingChildren;
      String SelectednumOfChildren = selectednumOfChildren ==null?"0": selectednumOfChildren;
      String CaseBy = kycType;

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
        motherF,
        motherM,
        motherL,
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
        mobileController.text,
        SelectedschoolingChildren,
        SelectednumOfChildren,
        selectedotherDependents,
        CaseBy,
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
            GlobalClass.Fi_Id = value.data[0].fiId;
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

  bool secondPageFieldValidate() {
    if (_panNoController.text.trim().isNotEmpty &&
        (panCardHolderName == null || panCardHolderName!.trim().isEmpty)) {
      showToast_Error(AppLocalizations.of(context)!.pleaseverifypan);
      return false;
    }

    if (_voterIdController.text.trim().isNotEmpty &&
        (voterCardHolderName == null || voterCardHolderName!.trim().isEmpty)) {
      showToast_Error(AppLocalizations.of(context)!.pleaseverifyvoterid);
      return false;
    }

    if (_drivingLicenseController.text.trim().isNotEmpty && dlCardHolderName.toString().isEmpty) {
      if (!dlVerified) {
        showToast_Error(AppLocalizations.of(context)!.pleaseverifydrivinglicense);
        return false;
      }

      if (_dlExpiryController.text.trim().isEmpty) {
        showToast_Error(AppLocalizations.of(context)!
            .pleaseenterexpirydateofdrivinglicense);
        return false;
      }

      if (dlCardHolderName == null || dlCardHolderName!.trim().isEmpty) {
        showToast_Error(AppLocalizations.of(context)!.pleaseverifydrivinglicense);
        return false;
      }
    }

    if (!checkIdMendate()) {
      showToast_Error(AppLocalizations.of(context)!
          .pleaseenterandverifyeithervoteridoranyothertwoids);
      return false;
    }

    String aadhaarName = "";

if(_nameController.text  != null && _nameController.text != ""){
  String address = [
    _nameController.text.trim(),
    _nameMController.text.trim(),
    _nameLController.text.trim(),
  ].where((e) => e != null && e!.trim().isNotEmpty).join(' ');
  aadhaarName = address;
}else{
  aadhaarName = adhaardata.customerName?.trim().toLowerCase() ?? '';
}
    String panName = panCardHolderName?.trim().toLowerCase() ?? '';
    String voterName = voterCardHolderName?.trim().toLowerCase() ?? '';
    String dlName = dlCardHolderName?.trim().toLowerCase() ?? '';

    print(panName + "bb"+voterName+ "bb"+ dlName+"bb");

    if (aadhaarName.isNotEmpty) {
      bool matched = true ,matched1 = true, matched2 = true;
      print(aadhaarName+"bb");

      if (panName.isEmpty || (panName != 'Data not Verified' && !panName.contains(aadhaarName))) {
        print("bb1");

        matched = false;
      }

      if (voterName.isNotEmpty ||( voterName.toLowerCase() == 'data not verified' && !voterName.contains(aadhaarName) && voterName.toLowerCase() != 'voter no. is not verified')) {
        matched1 = false;
        print(aadhaarName+"bb2");

      }

      if (dlName.isNotEmpty || (!dlName.toLowerCase().contains("data not verified") && !dlName.contains(aadhaarName))) {
        matched2 = false;
        print(aadhaarName+"bb3");

      }

      if (!matched && !matched1 && !matched2) {
        showToast_Error('Please enter correct ID: PAN, DL, or Voter name should match Aadhaar name.');
        return false;
      }
    }else{
      showToast_Error('Aadhaar name not fetched');

    }


    if (selectedCityCode == null) {
      showToast_Error(AppLocalizations.of(context)!.pleaseselectcity);
      return false;
    }

    if (selectedDistrictCode == null) {
      showToast_Error(AppLocalizations.of(context)!.pleaseselectdistrict);
      return false;
    }

    if (selectedSubDistrictCode == null) {
      showToast_Error(AppLocalizations.of(context)!.pleaseselectsubdistrict);
      return false;
    }

    if (selectedVillageCode == null) {
      showToast_Error(AppLocalizations.of(context)!.pleaseselectvillage);
      return false;
    }





    return true;


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
    int is_phnno_verified = panVerified ? 1 : 0;
    int Is_VoterVerified = voterVerified ? 1 : 0;
    int is_DLVerified = dlVerified ? 1 : 0;
    int isNameVerify = 1;

    String AdharName = "";

    if(_nameController.text != null && _nameController.text != "" ){
      AdharName = _nameController.text.trim();
      if (_nameMController.text.isNotEmpty && _nameLController.text.isNotEmpty) {
        AdharName = "${_nameController.text} ${_nameMController.text} ${_nameLController.text}".trim();
      } else if (_nameMController.text.isNotEmpty) {
        AdharName = "${_nameController.text} ${_nameMController.text}".trim();
      } else if (_nameLController.text.isNotEmpty) {
        AdharName = "${_nameController.text} ${_nameLController.text}".trim();
      }
    }else{
      if (adhaardata.customerName != null &&  adhaardata.customerName.isNotEmpty) {
        AdharName = "${adhaardata!.customerName}";
      }
    }


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
      "IsVoterVerified": Is_VoterVerified,
      "isDLVerified": is_DLVerified,
    };

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

      } else {
        EasyLoading.dismiss();
        GlobalClass.showUnsuccessfulAlert(context, value.message, 1);
      }
    }).catchError((onError) {
      EasyLoading.dismiss();
      GlobalClass.showErrorAlert(context, onError, 1);
    });
  }


    Map<String, String> setxmlData(String xmlString) {
      final document = XmlDocument.parse(xmlString);
      final element = document.getElement('PrintLetterBarcodeData');
      if (element == null) return {};
      return {
        'uid': element.getAttribute('uid') ?? '',
        'name': element.getAttribute('name') ?? '',
        'gender': element.getAttribute('gender') ?? '',
        'yob': element.getAttribute('yob') ?? '',
        'dob': element.getAttribute('dob') ?? '',
        'co': element.getAttribute('co') ?? '',
        'lm': element.getAttribute('lm') ?? '', // ← New line added here
        'loc': element.getAttribute('loc') ?? '',
        'vtc': element.getAttribute('vtc') ?? '',
        'po': element.getAttribute('po') ?? '',
        'dist': element.getAttribute('dist') ?? '',
        'subdist': element.getAttribute('subdist') ?? '',
        'state': element.getAttribute('state') ?? '',
        'pc': element.getAttribute('pc') ?? '',
      };
    }

}
