import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/GlobalClass.dart';
import 'package:flutter_sourcing_app/Models/GroupModel.dart';
import 'package:flutter_sourcing_app/Models/branch_model.dart';
import 'package:flutter_sourcing_app/Models/place_codes_model.dart';
import 'package:flutter_sourcing_app/const/validators.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'ApiService.dart';
import 'DATABASE/DatabaseHelper.dart';
import 'Models/RangeCategoryModel.dart';
import 'QRScanPage.dart';

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

   int _timeLeft = 60; // Timer starting at 60 seconds
  Timer? _timer;

  int imageStartIndex = 0;


  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  String? panCardHolderName;
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

  List<String> loanDuration = ['12', '24', '36', '48'];

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
  String bankselected = 'select';

  String? selectedloanDuration;
  String? _locationMessage;
  Position? position;
  bool otpVerified=false;

  @override
  void initState() {

    apiService = ApiService.create(baseUrl: ApiConfig.baseUrl1);
    apiService_idc = ApiService.create(baseUrl: ApiConfig.baseUrl4);
    apiService_protean = ApiService.create(baseUrl: ApiConfig.baseUrl5);
    apiService_OCR = ApiService.create(baseUrl: ApiConfig.baseUrl6);
    _focusNodeAdhaarId.addListener(_validateOnFocusChange);
    _mobileNoController.text="9910238307";
    fetchData();
    selectedloanDuration = loanDuration.isNotEmpty ? loanDuration[0] : null;

    // selectedTitle = titleList.isNotEmpty ? titleList[0] : null;

    super.initState();
    geolocator(context);
// Fetch states using the required cat_key
  }
  @override
  void dispose() {
    _focusNodeAdhaarId.removeListener(_validateOnFocusChange); // Remove listener
    _focusNodeAdhaarId.dispose(); // Dispose FocusNode when widget is disposed
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
      bank.insert(
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
  }

 // final _formKeys = List.generate(4, (index) => GlobalKey<FormState>());
  DateTime? _selectedDate;

  // TextEditingControllers for all input fields
  final _aadharIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _nameMController = TextEditingController();
  final _nameLController = TextEditingController();
  final _ageController = TextEditingController();
  final _dobController = TextEditingController();
  final _mobileNoController = TextEditingController();
  final _gurNameController = TextEditingController();
  final _fatherFirstNameController = TextEditingController();
  final _fatherMiddleNameController = TextEditingController();
  final _fatherLastNameController = TextEditingController();
  final _spouseFirstNameController = TextEditingController();
  final _spouseMiddleNameController = TextEditingController();
  final _spouseLastNameController = TextEditingController();
  final _expenseController = TextEditingController();
  final _incomeController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _address3Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _groupCodeController = TextEditingController();
  final _branchCodeController = TextEditingController();
  final _loan_amountController = TextEditingController();

  final _voterIdController = TextEditingController();
  final _passportController = TextEditingController();
  final _panNoController = TextEditingController();
  final _drivingLicenseController = TextEditingController();
  final _dlExpiryController = TextEditingController();
  final _passportExpiryController = TextEditingController();

  bool panVerified = false;
  bool dlVerified = false;
  bool voterVerified = false;
  String? dlDob;
/*  String? selectedState;
  String? selectedEarningMemberType;
  String? selectedBusinessDetail;
  String? selectedLoanPurpose;
  String? selectedOccupation;
  String? selectedLoanDuration;
  String? selectedBank;*/
  String? Fi_Id;
  String qrResult = "";
  File? _imageFile;
  bool isPanVerified = false,
      isDrivingLicenseVerified = false,
      isVoterIdVerified = false,
      isPassportVerified = false;

  get isChecked => null;
  final FocusNode _focusNodeAdhaarId = FocusNode();
  String _errorMessageAadhaar="";

  void _pickImage() async {
    File? pickedImage = await GlobalClass().pickImage();
    if (pickedImage != null) {
      setState(() {
        _imageFile = pickedImage;
      });
    }
  }

  Widget _buildDatePickerField(BuildContext context, String labelText,
      TextEditingController controller,String type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        
        controller: controller,
        readOnly: true,
        onTap: () => _selectDate(context, controller,type),
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          suffixIcon:   Icon(Icons.calendar_today),


        ),
      ),
    );
  }
  void _validateOnFocusChange() {
    if (!_focusNodeAdhaarId.hasFocus) {
      // Validate the input when the text field loses focus
      setState(() {
        if (_aadharIdController.text.isEmpty) {
          _errorMessageAadhaar = 'Aadhaar Id field cannot be empty!';
        } else if (_aadharIdController.text.length !=12) {
          _errorMessageAadhaar = 'Aadhaar must be 12 characters long.';
        } else if(!Validators.validateVerhoeff(_aadharIdController.text)){
          _errorMessageAadhaar = 'Aadhaar id is not valid';
        }else{
          _errorMessageAadhaar="";
        }
      });
    }
  }
  void _selectDate(
      BuildContext context, TextEditingController controller,String type) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if(type=="dob"){
          _selectedDate = picked;
          _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
          _calculateAge();
        }else if(type=="passExp"){
       _passportExpiryController.text=DateFormat('yyyy-MM-dd').format(picked);

        }else if(type=="dlExp"){
          _dlExpiryController.text = DateFormat('yyyy-MM-dd').format(picked);


          dlDob = DateFormat('dd-MM-yyyy').format(picked);
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
    return WillPopScope(child: Scaffold(

      backgroundColor: Color(0xFFD42D3F),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              children: [
                SizedBox(height: 20,),
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
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          height: 40,
                          width: 40,
                          alignment: Alignment.center,
                          child: Center(
                            child: Icon(Icons.arrow_back_ios_sharp, size: 16),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
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
                //  _buildProgressIndicator(),
                SizedBox(height: 30),
                Container(
                  height: MediaQuery.of(context).size.height - 244,
                  child: Flexible(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
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
                            top: -35, // Adjust the position as needed
                            left: 0,
                            right: 0,
                            child: Center(
                              child: _imageFile == null
                                  ? InkWell(
                                onTap: _pickImage,
                                child: ClipOval(
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    color: Colors.grey,
                                    child: Icon(
                                      Icons.person,
                                      size: 50.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                                  : InkWell(
                                child: ClipOval(
                                  child: Image.file(
                                    File(_imageFile!.path),
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                onTap: _pickImage,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Icon(Icons.location_on_outlined,color: Colors.white,),
                      Text("${_locationMessage}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),

                    ],),
                    InkWell(
                      onTap: (){geolocator(context);},

                      child:  Card(
                        elevation: 5,
                        shape: CircleBorder(),
                        child: Padding(padding: EdgeInsets.all(3),child: Icon(Icons.refresh,size: 30,color: Color(0xffb41d2d),),),
                      ),
                    )


                  ],
                ),
                SizedBox(height: 10),
                _buildNextButton(context),
              ],
            ),
          ),
        ),
      ),
    ), onWillPop: _onWillPop);
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
      backgroundColor: Color(0xFFD42D3F),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _showErrorMessage(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }


  Widget _buildTextField(String label, TextEditingController controller) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 0),
      padding: EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, height: 2),
          ),
          SizedBox(height: 1),
          Container(
              padding: EdgeInsets.zero,
              width: double.infinity, // Set the desired width
              child: Center(
                child: TextFormField(

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
                ),
              )),
        ],
      ),
    );
  }

  Future<void> saveFiMethod(BuildContext context) async {
    try {
      EasyLoading.show(status: 'Loading...');

      String adhaarid = _aadharIdController.text.toString();
      String title = selectedTitle ?? "";
      String name = _nameController.text.toString();
      String middlename = _nameMController.text.toString();
      String lastname = _nameLController.text.toString();
      String dob = _dobController.text.toString();
      String age = _ageController.text.toString();
      String gendre = genderselected;
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
      int Income = (income != null && income.isNotEmpty) ? int.parse(income) : 0;
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
      String gCode = widget.GroupData.groupCode;
      String bCode = widget.data.branchCode.toString();

      String relation_with_Borrower = relationwithBorrowerselected;
      String bank_name = bankselected;
      String loan_Duration = selectedloanDuration!;
      String loan_amount = _loan_amountController.text.toString();
      String? Image;
      if (_imageFile == null) {
        Image = 'Null';
      }

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
        gendre,
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
        _imageFile!,
      )
          .then((value) async {
        if (value.statuscode == 200) {
          getPlace("city", stateselected!.code, "", "");
          getPlace("district", stateselected!.code, "", "");
          setState(() {
            _currentStep += 1;
            Fi_Id = value.data[0].fiId.toString();
          });
        } else if (value.statuscode == 201) {
          print("status code 201");
          GlobalClass.showAlert(
            context,
            value.message,
            value.data[0].errormsg,
            Colors.red,
          );
        } else if (value.statuscode == 400) {
          GlobalClass.showSnackBar(context, "Something went wrong in API");
        }
        EasyLoading.dismiss();
      }).catchError((error) {
        GlobalClass.showSnackBar(context, "Error: ${error.toString()}");
        EasyLoading.dismiss();
      });
    } catch (e) {
      GlobalClass.showSnackBar(context, "An unexpected error occurred: ${e.toString()}");
      EasyLoading.dismiss();
    }
  }


  Future<void> saveIDsMethod(BuildContext context) async {
    EasyLoading.show(status: 'Loading...',);

    print("object");
    String fiid = Fi_Id.toString();
    String pan_no = _panNoController.text.toString();
    String dl = _drivingLicenseController.text.toString();
    String DLExpireDate = _dlExpiryController.text.toString();
    String voter_id = _voterIdController.text.toString();
    String passport = _passportController.text.toString();
    String PassportExpireDate = _passportExpiryController.text.toString();
    int isAadharVerified = 1;
    int is_phnno_verified = 1;
    int isNameVerify = 1;

    var fields = {
      "Pan No.": pan_no,
      "Driving License": dl,
      "DL Expire Date": DLExpireDate,
      "Voter Id": voter_id,
      "Passport": passport,
      "Passport Expire Date": PassportExpireDate,
    };

    for (var field in fields.entries) {
      if (field.value == null || field.value.isEmpty) {
        showAlertDialog(context, "Please fill in the ${field.key} field.");
        return;
      }
    }

    final api = Provider.of<ApiService>(context, listen: false);

    Map<String, dynamic> requestBody = {
      //"Fi_ID": fiid,
      "Fi_ID": 1144,
      "pan_no": pan_no,
      "dl": dl,
      "DLExpireDate": DLExpireDate,
      "voter_id": voter_id,
      "passport": passport,
      "PassportExpireDate": PassportExpireDate,
      "isAadharVerified": isAadharVerified,
      "is_phnno_verified": is_phnno_verified,
      "VILLAGE_CODE": isNameVerify,
      "CITY_CODE": isNameVerify,
      "SUB_DIST_CODE": isNameVerify,
      "DIST_CODE": isNameVerify,
      "STATE_CODE": isNameVerify,
    };

    return await api
        .addFiIds(GlobalClass.token, GlobalClass.dbName, requestBody)
        .then((value) async {
      if (value.statuscode == 200) {
        setState(() {
          _currentStep += 1;
        });
        EasyLoading.dismiss();

      } else {
        EasyLoading.dismiss();

      }
    });
  }

  void savePersonalDetailsMethod() {}

  void saveDataMethod() {}

  Widget _buildTextField2(
      String label, TextEditingController controller, TextInputType inputType,int maxlength) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 1),
          Container(
            width: double.infinity, // Set the desired width
            child: Center(
              child: TextFormField(

                maxLength: maxlength,
                controller: controller,
                keyboardType: inputType, // Set the input type
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  counterText: ""
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter $label';
                  }
                  return null;
                },
                inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')), // Allow only alphanumeric characters // Optional: to deny spaces
                  TextInputFormatter.withFunction(
                        (oldValue, newValue) => TextEditingValue(
                      text: newValue.text.toUpperCase(),
                      selection: newValue.selection,
                    ),
                  ),
                ],
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
                        getDataFromOCR("adharFront",context);

                    },
                    child: Text(
                      'Adhaar Front',
                      style: TextStyle(color: Colors.white),
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
                      getDataFromOCR("adharBack",context);
                    },
                    child: Text(
                      'Adhaar Back',
                      style: TextStyle(color: Colors.white),
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
                          print(result);
                      setQRData(result);
                     //   onResult(qrResult);
                      }

                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Adhaar QR',
                      style: TextStyle(color: Colors.white),
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
  String formatDate(String date,dateFormat) {
    try {
      // Parse the input string to a DateTime object
      DateTime parsedDate = DateFormat(dateFormat).parse(date);
      setState(() {
        _selectedDate=parsedDate;
        _calculateAge();
      });

      // Return the formatted date string in yyyy-MM-dd format
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      // Handle any invalid format
      return 'Invalid Date';
    }
  }
  Future<void> getDataFromOCR(String type,BuildContext context) async {
    EasyLoading.show();
    File? pickedImage = await GlobalClass().pickImage();

    if (pickedImage != null) {



      try{

        final response = await apiService_OCR.uploadDocument(
          type, // imgType
          pickedImage!, // File
        );
        if(response.statusCode==200){

          if(type=="adharFront"){
            setState(() {
              _aadharIdController.text=response.data.adharId;
              List<String> nameParts = response.data.name.trim().split(" ");
              if (nameParts.length == 1) {
                _nameController.text = nameParts[0];
              } else if (nameParts.length == 2) {
                _nameController.text = nameParts[0];
                _nameLController.text = nameParts[1];
              } else {
                _nameController.text = nameParts.first;
                _nameLController.text = nameParts.last;
                _nameMController.text = nameParts.sublist(1, nameParts.length - 1).join(' ');
              }
              _dobController.text=formatDate(response.data.dob,'dd/MM/yyyy');
              genderselected = aadhar_gender.firstWhere((item) => item.descriptionEn.toLowerCase() == response.data.gender.toLowerCase()).descriptionEn;
              if(genderselected=="Male"){
                selectedTitle="Mr.";
              }else{
                selectedTitle="Mrs.";
              }
            });
            Navigator.of(context).pop();
          }else if(type=="adharBack"){
            _pincodeController.text=response.data.pincode;
            if(response.data.relation.toLowerCase()=="father"){
              _gurNameController.text=response.data.guardianName;
              setState(() {
                relationwithBorrowerselected="Father";

              });
              _cityController.text=response.data.cityName;
              List<String> addressParts = response.data.address1.trim().split(" ");
              if (addressParts.length == 1) {
                _address1Controller.text = addressParts[0];
              } else if (addressParts.length == 2) {
                _address1Controller.text = addressParts[0];
                _address2Controller.text = addressParts[1];
              } else {
                  _address1Controller.text = addressParts.first;
                  _address2Controller.text = addressParts.last;
                _address3Controller.text = addressParts.sublist(1, addressParts.length - 1).join(' ');
              }
List<String> guarNameParts = response.data.guardianName.trim().split(" ");
              if (guarNameParts.length == 1) {
                _fatherFirstNameController.text = guarNameParts[0];
              } else if (guarNameParts.length == 2) {
                _fatherFirstNameController.text = guarNameParts[0];
                _fatherLastNameController.text = guarNameParts[1];
              } else {
                  _fatherFirstNameController.text = guarNameParts.first;
                  _fatherLastNameController.text = guarNameParts.last;
                _fatherMiddleNameController.text = guarNameParts.sublist(1, guarNameParts.length - 1).join(' ');
              }

            }
            else if(response.data.relation.toLowerCase()=="husband"){
              _gurNameController.text=response.data.guardianName;
              setState(() {
                relationwithBorrowerselected="Husband";
                selectedMarritalStatus="Married";
              });
              _cityController.text=response.data.cityName;
              List<String> addressParts = response.data.address1.trim().split(" ");
              if (addressParts.length == 1) {
                _address1Controller.text = addressParts[0];
              } else if (addressParts.length == 2) {
                _address1Controller.text = addressParts[0];
                _address2Controller.text = addressParts[1];
              } else {
                  _address1Controller.text = addressParts.first;
                  _address2Controller.text = addressParts.last;
                _address3Controller.text = addressParts.sublist(1, addressParts.length - 1).join(' ');
              }
            List<String> guarNameParts = response.data.guardianName.trim().split(" ");
              if (guarNameParts.length == 1) {
                _spouseFirstNameController.text = guarNameParts[0];
              } else if (guarNameParts.length == 2) {
                _spouseFirstNameController.text = guarNameParts[0];
                _spouseLastNameController.text = guarNameParts[1];
              } else {
                _spouseFirstNameController.text = guarNameParts.first;
                _spouseLastNameController.text = guarNameParts.last;
                _spouseMiddleNameController.text = guarNameParts.sublist(1, guarNameParts.length - 1).join(' ');
              }

            }

          }
          EasyLoading.dismiss();
        }else{
          showToast_Error("Data not fetched from this Aadhaar card please check the image");
          Navigator.of(context).pop();
          EasyLoading.dismiss();
        }

      }catch(_){
        showToast_Error("Data not fetched from this Aadhaar card please check the image");
        Navigator.of(context).pop();
        EasyLoading.dismiss();

      }
    }
  }
  List<List<int>> separateData(List<int> source, int separatorByte, int vtcIndex) {
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
    String test="";
    List<String> decodedData = [];

    for (var byteArray in encodedData) {
      // Decode using ISO-8859-1
      String decodedString = utf8.decode(byteArray); // Change to ISO-8859-1 if necessary
      decodedData.add(decodedString);

      test+=decodedString;
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
    String hexData = byteScanData.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
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
    EasyLoading.show(status: "Location Fetching...");
    try {
      position = await _getCurrentPosition();
      setState(() {
        if (position != null) {
          _locationMessage =
          "${position!.latitude},${position!.longitude}";
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
                  : (isActive ? Color(0xFFD42D3F) : Colors.grey)),
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
            Expanded(child: Container(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 0),
              padding: EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Aadhaar ID",
                    style: TextStyle(fontSize: 16, height: 2),
                  ),
                  SizedBox(height: 1),
                  Container(
                      padding: EdgeInsets.zero,
                      width: double.infinity, // Set the desired width
                      child: Center(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          maxLength: 12,
                          focusNode: _focusNodeAdhaarId,
                          controller: _aadharIdController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            errorText: _errorMessageAadhaar.isEmpty ? null : _errorMessageAadhaar,
                            counterText: ""
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Aadhaar ID';
                            }
                            return null;
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
                    'Title',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 8,
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
                      elevation: 16,
                      style: TextStyle(color: Colors.black, fontSize: 16),
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
              child: _buildTextField2('Name', _nameController,TextInputType.name,30),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildTextField2('Middle Name', _nameMController,TextInputType.name,30)),
            SizedBox(width: 10),
            // Add spacing between the text fields if needed
            Expanded(child: _buildTextField2('Last Name', _nameLController,TextInputType.name,30)),
          ],
        ),
        _buildTextField2('Guardian Name', _gurNameController,TextInputType.name,60),
        Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 4,
                ),
                Text(
                  'Gender',
                  style: TextStyle(fontSize: 16),
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
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    underline: Container(
                      height: 2,
                      color: Colors.transparent, // Set to transparent to remove default underline
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          genderselected = newValue; // Update the selected value
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
                  height: 4,
                ),
                Text(
                  'Relationship',
                  style: TextStyle(fontSize: 16),
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
                    style: TextStyle(color: Colors.black, fontSize: 16),
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
              child: _buildTextField2('Mobile no', _mobileNoController,TextInputType.number,10),
            ),
            SizedBox(width:5),
            // Add spacing between the text field and the button
            Padding(
              padding: EdgeInsets.only(top: 20),
              // Add 10px padding from above
              child:  InkWell(
                onTap: (){
                  {

                    if (_mobileNoController.text.isEmpty) {
                      showToast_Error("Please enter mobile number");

                    }else{
                        //getOTPByMobileNo(_mobileNoController.text);
                      mobileOtp(context,_mobileNoController.text);




                    }
                    // Implement OTP verification logic here
                  }
                },
                child: Card(
                  elevation: 4,
                  color:otpVerified?Colors.green: Colors.grey,
                  shape: CircleBorder(),
                  child: Padding(padding: EdgeInsets.all(9),child: Icon(otpVerified?Icons.verified:Icons.sms,color: Colors.white,),),
                ),
              )
            ),
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
                    height: 4,
                  ),
                  Text(
                    'Age',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Container(
                    color: Colors.white,
                    child: TextField(
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
                    height: 4,
                  ),
                  Text(
                    'Date of Birth',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Container(
                    color: Colors.white,
                    child: TextField(
                      controller: _dobController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context, _dobController,"dob"),
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
        _buildTextField2('Father First Name', _fatherFirstNameController,TextInputType.text,30),
        Row(
          children: [
            Expanded(
              child:
                  _buildTextField2('Middle Name', _fatherMiddleNameController,TextInputType.text,30),
            ),
            SizedBox(width: 8),
            // Add spacing between the text fields if needed
            Expanded(
                child: _buildTextField2('Last Name', _fatherLastNameController,TextInputType.text,30)),
          ],
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          'Marital Status',
          style: TextStyle(fontSize: 16),
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
            style: TextStyle(color: Colors.black, fontSize: 16),
            underline: Container(
              height: 2,
              color: Colors
                  .transparent, // Set to transparent to remove default underline
            ),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedMarritalStatus =
                      newValue; // Update the selected value
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
        if (selectedMarritalStatus.toString()== 'Married')
          Column(
            children: [
              _buildTextField2('Spouse First Name', _spouseFirstNameController,TextInputType.text,30),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField2(
                        'Middle Name', _spouseMiddleNameController,TextInputType.text,30),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child:
                        _buildTextField2('Last Name', _spouseLastNameController,TextInputType.text,30),
                  ),
                ],
              ),
            ],
          ),
        Row(
          children: [
            Expanded(
                child: _buildTextField2('Monthly Expense', _incomeController,TextInputType.number,7),),
            SizedBox(width: 8),
            // Add spacing between the text fields if needed
            Expanded(
                child: _buildTextField2('Monthly Income', _expenseController,TextInputType.number,7),),
          ],
        ),
        _buildTextField('Address1', _address1Controller),
        _buildTextField('Address2', _address2Controller),
        _buildTextField('Address3', _address3Controller),
        Row(
          children: [
            Expanded(child: _buildTextField2('City', _cityController,TextInputType.text,30),),
            SizedBox(width: 16),
            Expanded(child: _buildTextField2('Pincode', _pincodeController,TextInputType.number,6),),
          ],
        ),
        SizedBox(
          height: 4,
        ),

        _buildLabeledDropdownField(
            'Select State', 'State', states, stateselected,
            (RangeCategoryDataModel? newValue) {
          setState(() {
            stateselected = newValue;

          });
        }, String),
        _buildTextField2(
            'Loan Amount', _loan_amountController, TextInputType.number,7),

        SizedBox(
          height: 4,
        ),
        Text(
          'Loan Reason',
          style: TextStyle(fontSize: 16),
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
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black, fontSize: 16),
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
          height: 4,
        ),

        Row(
          children: [
            // Special Ability Dropdown
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Loan Duraction',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 5),
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
                      style: TextStyle(color: Colors.black, fontSize: 16),
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
                    'Bank Name',
                    style: TextStyle(fontSize: 16),
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
                      value: bankselected,
                      isExpanded: true,
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black, fontSize: 16),
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
                      items: bank.map<DropdownMenuItem<String>>(
                          (RangeCategoryDataModel state) {
                        return DropdownMenuItem<String>(
                          value: state.code,
                          child: Text(state.descriptionEn),
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
    int remainingTime = 10;
    bool cancelButtonVisible=false;
    String pinCode="";
    void startCountdown(StateSetter setState) {
      countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (remainingTime > 0) {
          setState(() {
            remainingTime--;
          });
        } else {
          countdownTimer?.cancel();
          setState((){
            cancelButtonVisible=true;
          });
        }
      });
    }

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal by tapping outside
      builder: (BuildContext context) {
        return StatefulBuilder(

          builder: (context, setState) {
            // Start timer once the dialog opens
            if (countdownTimer == null) startCountdown(setState);

            return AlertDialog(
              backgroundColor: Colors.white,
              title: Row(
                children: [
                  Text(
                    'Please Enter OTP Here',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
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
                      pinCode = pin;
                    },
                    defaultPinTheme: PinTheme(
                      width: 40,
                      height:40,
                      textStyle: const TextStyle(
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
                    style: TextStyle(color: Colors.red),
                  ))
                  ,
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    countdownTimer?.cancel(); // Stop timer when submitting
                     
                    if(pinCode.isEmpty || pinCode.length!=6){
                      showToast_Error("Please Enter OTP Properly");
                    }else{
                      submitOtp(pinCode,context);
                    }



                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Button color
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
               Visibility(child:  ElevatedButton(
                 onPressed: () {
                   countdownTimer?.cancel(); // Stop timer when closing
                   Navigator.of(context).pop(); // Close the dialog
                 },
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.red, // Button color
                 ),
                 child: Text(
                   'Close',
                   style: TextStyle(color: Colors.white),
                 ),
               ),visible: cancelButtonVisible,),
              ],
            );
          },
        );
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
                child: _buildTextField2('PAN No', _panNoController,TextInputType.text,10),
              ),
              SizedBox(width: 10),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: InkWell(
                  enableFeedback: true,
                  onTap: () {
                    if (_panNoController.text.isEmpty || _panNoController.text.length!=10) {
                      showToast_Error("Please Enter Correct PAN No.");
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
          panCardHolderName == null
              ? Text(
                  "Please search PAN card holder name for verification",
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                )
              : Text(panCardHolderName!,
                  style: TextStyle(color: Colors.green, fontSize: 14)),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: _buildTextField2(
                    'Driving License', _drivingLicenseController,TextInputType.text,18),
              ),
              SizedBox(width: 10),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: () {
                    if (_drivingLicenseController.text.isEmpty) {
                      showToast_Error("Please Enter Driving License");
                    } else {
                      dlVerifyByProtean(GlobalClass.id,
                          _drivingLicenseController.text, dlDob!);
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
                  "Please search driving license holder name for verification",
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                )
              : Text(dlCardHolderName!,
                  style: TextStyle(color: Colors.green, fontSize: 14)),
          _buildDatePickerField(
              context, 'Driving License Expiry Date', _dlExpiryController,"dlExp"),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: _buildTextField2('Voter Id', _voterIdController,TextInputType.text,17),
              ),
              SizedBox(width: 10),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: () {
                    if (_voterIdController.text.isEmpty) {
                      showToast_Error("Please Enter Voter No.");
                    } else {
                      voterVerifyByProtean(
                          GlobalClass.id, _voterIdController.text);
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
                  "Please search voter card holder name for verification",
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                )
              : Text(voterCardHolderName!,
                  style: TextStyle(color: Colors.green, fontSize: 14)),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: _buildTextField('Passport', _passportController),
              ),
            ],
          ),
          _buildDatePickerField(
              context, 'Passport Expiry Date', _passportExpiryController,"passExp"),
          _buildLabeledDropdownField(
              'Select City', 'Cities', listCityCodes, selectedCityCode,
              (PlaceData? newValue) {
            setState(() {
              selectedCityCode = newValue;
              // getPlace("city",stateselected!.code,"","");
              // getPlace("district",stateselected!.code,"","");
            });
          }, String),
          _buildLabeledDropdownField('Select District', 'Districts',
              listDistrictCodes, selectedDistrictCode, (PlaceData? newValue) {
            setState(() {
              selectedDistrictCode = newValue;
               getPlace("subdistrict",stateselected!.code,selectedDistrictCode!.distCode!,"");
              // getPlace("district",stateselected!.code,"","");
            });
          }, String),
          _buildLabeledDropdownField(
              'Select Sub-District',
              'Sub-Districts',
              listSubDistrictCodes,
              selectedSubDistrictCode, (PlaceData? newValue) {
            setState(() {
              selectedSubDistrictCode = newValue;
               getPlace("village",stateselected!.code,selectedDistrictCode!.distCode!,selectedSubDistrictCode!.subDistCode!);
              // getPlace("district",stateselected!.code,"","");
            });
          }, String),
          _buildLabeledDropdownField('Select Village', 'Village',
              listVillagesCodes, selectedVillageCode, (PlaceData? newValue) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          DropdownButtonFormField<T>(
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
                child: Text(setdata), // Convert the value to string for display
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void docVerifyIDC(
      String type, String txnNumber, String ifsc, String dob) async {
    EasyLoading.show(status: 'Loading...',);
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
          setState(() {
            panCardHolderName =
                "${responseData['first_name']} ${responseData['last_name']}";
            panVerified = true;
          });
        } else if (type == "drivinglicense") {
          setState(() {
            dlCardHolderName = "${responseData['name']}";
            dlVerified = true;
          });
        } else if (type == "voterid") {
          setState(() {
            voterCardHolderName = "${responseData['name']}";
            voterVerified = true;
          });
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
        showToast_Error("Unexpected Response: $response");
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


  void dlVerifyByProtean(String userid,String dlNo,String dob) async {
    EasyLoading.show(status: 'Loading...',);


    try {
      // Initialize Dio

      // Create ApiService instance

      // API body
      Map<String, dynamic> requestBody = {
        "userID": userid,
        "dlno": dlNo,
        "dob": dob
      };

      // Hit the API

      final response = await apiService_protean.getDLDetailsProtean(requestBody);

      EasyLoading.show(status: 'Loading...',);


      // Handle response
      if (response is Map<String, dynamic>) {
        Map<String, dynamic> responseData = response["data"];
        // Parse JSON object if it’s a map
        setState(() {
          if (responseData['result']['name'] != null) {
            dlCardHolderName = "${responseData['result']['name']}";
            dlVerified = true;
          } else {
            docVerifyIDC("drivinglicense", _drivingLicenseController.text, "",
                _dobController.text);
          }
        });

      } else {
        docVerifyIDC("drivinglicense", _drivingLicenseController.text, "",
            _dobController.text);
      }
    } catch (e) {
      // Handle errors
      docVerifyIDC("drivinglicense", _drivingLicenseController.text, "",
          _dobController.text);
    }
    EasyLoading.dismiss();

  }


  void voterVerifyByProtean(String userid,String voterNo) async {
    EasyLoading.show(status: 'Loading...',);

    try {
      // Initialize Dio

      // Create ApiService instance

      // API body
      Map<String, dynamic> requestBody = {
        "userID": userid,
        "voterno": voterNo,
      };

      // Hit the API
      final response =
      await apiService_protean.getVoteretailsProtean(requestBody);

      // Handle response
      if (response is Map<String, dynamic>) {
        Map<String, dynamic> responseData = response["data"];
        // Parse JSON object if it’s a map
        setState(() {
          if (responseData['result'].responseData['name'] != null) {
            voterCardHolderName =
            "${responseData['result'].responseData['name']}";
            voterVerified = true;
          } else {
            docVerifyIDC("voterid", _voterIdController.text, "", "");
          }
        });
      } else {
        docVerifyIDC("voterid", _voterIdController.text, "", "");
      }
    } catch (e) {
      // Handle errors
      docVerifyIDC("voterid", _voterIdController.text, "", "");
    }
    EasyLoading.show(status: 'Loading...',);

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

          //  if (_currentStep == 0) {
          //    if(firstPageFieldVelidate()){
          //      saveFiMethod(context);
          //
          //    }
          //
          // } else if (_currentStep == 1) {
          //     if(secondPageFieldValidate()){
          //       saveIDsMethod(context);
          //     }
          //
          // } else if (_currentStep > 1) {
          //   showKycDoneDialog(context);
          // }

          if (_currentStep ==0) {
            setState(() {
              _currentStep += 1;
            });
          } else if (_currentStep == 1) {
            if(secondPageFieldValidate()){
                    saveIDsMethod(context);
                  }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Form submitted successfully")),
            );
          }
        },
        child: Text(
          "SUBMIT",
          style: TextStyle(color: Colors.white, fontSize: 16),
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
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showKycDoneDialog(BuildContext context) {
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
  }
bool secondPageFieldValidate(){

  if(_panNoController.text.isNotEmpty){
    if(!panVerified){
      showToast_Error("Please verify PAN");
      return false;
    }
  }
    if(_voterIdController.text.isNotEmpty){
      if(voterCardHolderName==null){
        showToast_Error("Please verify voter id");
        return false;
      }
    }
       if(_drivingLicenseController.text.isNotEmpty){
      if(!dlVerified){
        showToast_Error("Please verify driving license");
        return false;
      }
    }


    if(!panVerified && !voterVerified && !dlVerified){
      showToast_Error("Please enter and verify minimum any two IDs or voter Id");
      return false;
    }else if(checkIdMendate()==false){
      showToast_Error("Please enter and verify either voter Id or Any other two Ids");
      return false;
    }else if(selectedCityCode==null){
      showToast_Error("Please select city");
      return false;
    } else if(selectedDistrictCode==null){
      showToast_Error("Please select district");
      return false;
    } else if(selectedSubDistrictCode==null){
      showToast_Error("Please select subdistrict");
      return false;
    } else if(selectedVillageCode==null){
      showToast_Error("Please select village");
      return false;
    }

    return true;
}

bool checkIdMendate(){
    if(voterVerified){
      return true;
    }else if(panVerified && dlVerified){
      return true;
    }else{
      return false;
    }

}
  bool firstPageFieldVelidate() {
    if (_aadharIdController.text.isEmpty) {
      showToast_Error("Please enter correct aadhaar id");
      return false;
    } else if (selectedTitle == null) {
      showToast_Error("Please choose title");
      return false;
    } else if (_nameController.text.isEmpty) {
      showToast_Error("Please enter borrower first name");
      return false;
    } else if (_nameLController.text.isEmpty) {
      showToast_Error("Please enter borrower last name");
      return false;
    } else if (_gurNameController.text.isEmpty) {
      showToast_Error("Please enter guardian name");
      return false;
    } else if (genderselected.toLowerCase() == "select") {
      showToast_Error("Please select borrower's gender");
      return false;
    } else if (relationwithBorrowerselected.toLowerCase() == "select") {
      showToast_Error("Please select borrower's relation with guardian");
      return false;
    } else if (_mobileNoController.text.isEmpty ||
        _mobileNoController.text.length != 10) {
      showToast_Error("Please enter mobile correct number");
      return false;
    } else if (_dobController.text.isEmpty) {
      showToast_Error("Please enter date of birth");
      return false;
    } else if (_fatherFirstNameController.text.isEmpty) {
      showToast_Error("Please enter father first name");
      return false;
    } else if (_fatherLastNameController.text.isEmpty) {
      showToast_Error("Please enter father last name");
      return false;
    } else if (selectedMarritalStatus == null) {
      showToast_Error("Please select marital status");
      return false;
    } else if (selectedMarritalStatus!.toLowerCase() != "unmarried") {
      if (_spouseFirstNameController.text.isEmpty) {
        showToast_Error("Please enter spouse first name");
        return false;
      } else if (_spouseLastNameController.text.isEmpty) {
        showToast_Error("Please enter spouse last name");
        return false;
      }
    } else if (_address1Controller.text.isEmpty) {
      showToast_Error("Please enter address 1");
      return false;
    }  else if (_cityController.text.isEmpty) {
      showToast_Error("Please enter city");
      return false;
    } else if (_pincodeController.text.isEmpty ||
        _pincodeController.text.length != 6) {
      showToast_Error("Please enter correct Pin code");
      return false;
    } else if (stateselected!.descriptionEn.toLowerCase() == "select") {
      showToast_Error("Please select state");
      return false;
    } else if (_loan_amountController.text.isEmpty) {
      showToast_Error("Please enter correct loan amount");
      return false;
    } else if (selectedLoanReason == null) {
      showToast_Error("Please select loan reason");
      return false;
    } else if (selectedloanDuration == null) {
      showToast_Error("Please select loan duration");
      return false;
    } else if (bankselected.toLowerCase() == "select") {
      showToast_Error("Please select bank");
      return false;
    } else if (_latitudeController.text.isEmpty ||
        _longitudeController.text.isEmpty) {
      showToast_Error("Please turn on location service of mobile");
      return false;
    } else if (_imageFile == null) {
      showToast_Error("Please capture borrower profile picture");
      return false;
    } else if (!otpVerified) {
      showToast_Error("Please Verify Mobile number with OTP!!");
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

      // if (response.statuscode == 200 && response.data[0].isValid == null) {
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

      //} else {}
    } catch (e) {
      print("Error: $e");
    }
  }



    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Text(
                    'OTP',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(), // Pushes the timer and icon to the right
                  Text(
                    '$_timeLeft',
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.timer, color: Colors.green),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _otpController,
                    decoration: InputDecoration(
                      labelText: 'Enter OTP',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle submit action
                      String otp = _otpController.text;
                      print('OTP submitted: $otp');
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD42D3F), // Button color
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }


  Future<void> mobileOtp(BuildContext context, String mobileNo) async {
    final api = ApiService.create(baseUrl: ApiConfig.baseUrl1);
    Map<String, dynamic> requestBody = {
      "MobileNo": mobileNo,
      "Language": "English",
      "ContentId": "1007458689942092806",
    };

    return await api.mobileOtpSend( GlobalClass.dbName,requestBody).then((value) {

      if (value.statuscode == 200) {

          _showOTPDialog(context);


      }
    });

  }

  void setQRData(result) {
  List<String> dataList=result.split(",");
    if(dataList.length>14){
      _aadharIdController.text=dataList[2];
      List<String> nameParts = dataList[3].split(" ");
      if (nameParts.length == 1) {
        _nameController.text = nameParts[0];
      } else if (nameParts.length == 2) {
        _nameController.text = nameParts[0];
        _nameLController.text = nameParts[1];
      } else {
        _nameController.text = nameParts.first;
        _nameLController.text = nameParts.last;
        _nameMController.text = nameParts.sublist(1, nameParts.length - 1).join(' ');
      }

      _dobController.text=formatDate(dataList[4],'dd-MM-yyyy');
      setState(() {

        if(dataList[5].toLowerCase()=="m"){
        genderselected="Male";
        selectedTitle="Mr.";
        }else if(dataList[5].toLowerCase()=="f"){
          genderselected="Female";
          selectedTitle="Mrs.";

        }
      });
      if(dataList[6].toLowerCase().contains("s/o") || dataList[6].toLowerCase().contains("d/o")){
        setState(() {
          relationwithBorrowerselected="Father";
          List<String> guarNameParts = replaceCharFromName(dataList[6]).split(" ");
          if (guarNameParts.length == 1) {
            _fatherFirstNameController.text = guarNameParts[0];
          } else if (guarNameParts.length == 2) {
            _fatherFirstNameController.text = guarNameParts[0];
            _fatherLastNameController.text = guarNameParts[1];
          } else {
            _fatherFirstNameController.text = guarNameParts.first;
            _fatherLastNameController.text = guarNameParts.last;
            _fatherMiddleNameController.text = guarNameParts.sublist(1, guarNameParts.length - 1).join(' ');
          }


        });
      } else if(dataList[6].toLowerCase().contains("w/o")){
        setState(() {
          relationwithBorrowerselected="Husband";
          List<String> guarNameParts = replaceCharFromName(dataList[6]).split(" ");
          if (guarNameParts.length == 1) {
            _spouseFirstNameController.text = guarNameParts[0];
          } else if (guarNameParts.length == 2) {
            _spouseFirstNameController.text = guarNameParts[0];
            _spouseLastNameController.text = guarNameParts[1];
          } else {
            _spouseFirstNameController.text = guarNameParts.first;
            _spouseLastNameController.text = guarNameParts.last;
            _spouseMiddleNameController.text = guarNameParts.sublist(1, guarNameParts.length - 1).join(' ');
          }
        });
      }
      _cityController.text=dataList[7];
      _gurNameController.text=replaceCharFromName(dataList[6]);

      if(dataList[0].toLowerCase()=='v2'){
        _pincodeController.text=dataList[11];
        stateselected = states.firstWhere((item) => item.descriptionEn.toLowerCase() == dataList[13].toLowerCase());
        String address="${dataList[9]},${dataList[10]},${dataList[12]},${dataList[14]},${dataList[15]}";
        List<String> addressParts = address.trim().split(",");
        if (addressParts.length == 1) {
          _address1Controller.text = addressParts[0];
        } else if (addressParts.length == 2) {
          _address1Controller.text = addressParts[0];
          _address2Controller.text = addressParts[1];
        } else {
          _address1Controller.text = addressParts.first;
          _address2Controller.text = addressParts.last;
          _address3Controller.text = addressParts.sublist(1, addressParts.length - 1).join(' ');
        }

      }else if(dataList[0].toLowerCase()=='v4'){
        stateselected = states.firstWhere((item) => item.descriptionEn.toLowerCase() == dataList[14].toLowerCase());
        _pincodeController.text=dataList[12];
        String address="${dataList[10]},${dataList[11]},${dataList[13]},${dataList[15]},${dataList[16]}";

        List<String> addressParts = address.trim().split(",");
        if (addressParts.length == 1) {
          _address1Controller.text = addressParts[0];
        } else if (addressParts.length == 2) {
          _address1Controller.text = addressParts[0];
          _address2Controller.text = addressParts[1];
        } else {
          _address1Controller.text = addressParts.first;
          _address2Controller.text = addressParts.last;
          _address3Controller.text = addressParts.sublist(1, addressParts.length - 1).join(' ');
        }
      }

    }

  }
  String replaceCharFromName(String gurName){

  return gurName.replaceAll("S/O ", "").replaceAll("S/O: ", "").replaceAll("D/O ", "").replaceAll("D/O: ", "").replaceAll("W/O ", "").replaceAll("W/O: ", "");

  }



  Future<void> submitOtp(pin,BuildContext contextDialog) async {
    EasyLoading.show(status: "OTP verifying...");

    final api = ApiService.create(baseUrl: ApiConfig.baseUrl1);


    return await api.otpVerify(GlobalClass.token,GlobalClass.dbName, _mobileNoController.text,pin).then((value) {

      if (value.statuscode == 200) {
      showToast_Error("OTP Verified...");
      setState(() {
        otpVerified=true;
      });
      Navigator.of(contextDialog).pop();
      }else{
        setState(() {
          otpVerified=false;
        });
        GlobalClass.showSnackBar(context, "OTP is not verified \nPlease Enter Correct OTP");
      }
      EasyLoading.dismiss();
    }).catchError((err){
      setState(() {
        otpVerified=false;
      });
      GlobalClass.showSnackBar(context, err);
      EasyLoading.dismiss();

    });

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
            onPressed: () => Navigator.of(context).pop(false), // Stay in the app
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
    ) ?? false; // Default to false if dialog is dismissed



  }

}

