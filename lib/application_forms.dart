import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/Models/ocrdocscanningresponce.dart';
import 'package:flutter_sourcing_app/qr_scan_page.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'DATABASE/database_helper.dart';
import 'Models/bank_names_model.dart';
import 'Models/borrower_list_model.dart';
import 'Models/branch_model.dart';
import 'Models/get_all_model.dart';
import 'Models/group_model.dart';
import 'Models/kyc_scanning_model.dart';
import 'Models/place_codes_model.dart';
import 'Models/range_category_model.dart';
import 'api_service.dart';
import 'const/validators.dart';
import 'global_class.dart';

class ApplicationPage extends StatefulWidget {
  final BranchDataModel BranchData;
  final GroupDataModel GroupData;
  final BorrowerListDataModel selectedData;

  const ApplicationPage({
    super.key,
    required this.BranchData,
    required this.GroupData,
    required this.selectedData,
  });

  @override
  _ApplicationPageState createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  late KycScanningModel getData;
  late ApiService apiService_OCR;
  late ApiService apiService;
  List<ApplicationgetAllDataModel> BorrowerInfo = [];
  final FocusNode _focusNodeAdhaarId = FocusNode();
  String _errorMessageAadhaar="";
  String temp = "";
  bool verifyFlag = true;

  final picker = ImagePicker();
  late ApiService apiService_protean;
  bool _isPageLoading = false;
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  bool personalInfoEditable = true;
  bool FiFamilyEditable = true;
  bool FiIncomeEditable = true;
  bool FinancialInfoEditable = true;
  bool femMemIncomeEditable = true;
  bool GuarantorEditable = true;
  bool borrowerDocsUploded = false;
  bool UploadFiDocsEditable = true;
  bool editButtonFunctionOn = false;

  String pageTitle = "Application Form";

  final _mobileFocusNode = FocusNode();
  final _pinFocusNodeP = FocusNode();
  final _pinFocusNodeC = FocusNode();
  String? _emailError;
  String? _mobileError;
  String? _pinErrorP;
  String? _pinErrorC;
  bool _isAddressChecked = false;

  List<RangeCategoryDataModel> religion = [];
  List<RangeCategoryDataModel> cast = [];
  List<RangeCategoryDataModel> states = [];
  List<RangeCategoryDataModel> landOwner = [];

  List<RangeCategoryDataModel> relation = [];
  List<RangeCategoryDataModel> reasonForLoan = [];
  List<RangeCategoryDataModel> aadhar_gender = [];
  List<RangeCategoryDataModel> business_Type = [];
  List<RangeCategoryDataModel> income_type = [];
  List<RangeCategoryDataModel> bank = [];
  List<RangeCategoryDataModel> education = [];
  List<RangeCategoryDataModel> health = [];
  List<RangeCategoryDataModel> schoolType = [];
  List<RangeCategoryDataModel> occupationType = [];
  List<RangeCategoryDataModel> roofType = [];
  List<RangeCategoryDataModel> toiletType = [];
  List<RangeCategoryDataModel> houseType = [];

  List<String> titleList = ["Select", "Mr.", "Mrs.", "Miss"];
  List<String> accType = ["Select", "Current", "Savings", "Salary"];
  String expense = "";
  String income = "";
  String lati = "";
  String longi = "";
  String roofTypeSelected = "";
  String toiletTypeSelected = "";
  String houseTypeSelected = "";

  List<PlaceData> listCityCodes = [];
  List<PlaceData> listDistrictCodes = [];
  List<PlaceData> listSubDistrictCodes = [];
  List<PlaceData> listVillagesCodes = [];

  bool isPanVerified = false,
      isDrivingLicenseVerified = false,
      isVoterIdVerified = false,
      isPassportVerified = false;
  bool panVerified = false;
  bool dlVerified = false;
  bool voterVerified = false;
  bool _isHandicapVisible = false;
  String panCardHolderName =
      "Please search PAN card holder name for verification";
  String? dlCardHolderName;
  String? voterCardHolderName;
  bool banknameverified = false;

  //fiextra
  List<String> onetonine = [
    'Select',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9'
  ];
  List<String> loanDuration = ['Select', '12', '24', '36', '48'];
  List<String> trueFalse = ['Select', 'Yes', 'No'];
  List<String> handicapTypes = [
    'Visual Impairments',
    'Hearing Impairments',
    'Motor Impairments',
    'Cognitive Impairments',
    'Speech Impairments',
    'Combination Handicaps'
  ];

  Color iconPan = Color(0xFFD42D3F);
  Color iconPassport = Color(0xFFD42D3F);
  Color iconDl = Color(0xFFD42D3F);
  Color iconVoter = Color(0xFFD42D3F);

//FIEXTRA
  String? selectedReligionextra;
  String? selectedCast;
  String? selectedIsHandicap;
  String? selectedspecialAbility;
  String? selectedSpecialSocialCategory;
  RangeCategoryDataModel? selectedStateextraP;
  RangeCategoryDataModel? selectedStateextraC;
  PlaceData? selectedDistrict;
  PlaceData? selectedSubDistrict;
  PlaceData? selectedVillage;
  String? selectedResidingFor;
  String? selectedProperty;
  String? selectedPresentHouseOwner;
  String? selectedIsHouseRental;
  final emailIdController = TextEditingController();
  final placeOfBirthController = TextEditingController();
  final resCatController = TextEditingController();
  final mobileController = TextEditingController();
  final address1ControllerP = TextEditingController();
  final address2ControllerP = TextEditingController();
  final address3ControllerP = TextEditingController();
  late var address1ControllerC = TextEditingController();
  late var address2ControllerC = TextEditingController();
  late var address3ControllerC = TextEditingController();
  final cityControllerP = TextEditingController();
  final pincodeControllerP = TextEditingController();
  late var cityControllerC = TextEditingController();
  late var pincodeControllerC = TextEditingController();
  final loanAmountController = TextEditingController();

  //FEM MEM INCOME
  String? femselectedGender;
  String? femselectedRelationWithBorrower;
  String? femselectedHealth;
  String? femselectedEducation;
  String? femselectedSchoolType;
  String? femselectedBusiness;
  String? femselectedBusinessType;
  String? femselectedIncomeType;
  final _femNameController = TextEditingController();
  final _AgeController = TextEditingController();
  final _IncomeController = TextEditingController();

  //Financial INFO
  String? selectedAccountType /*selectedBankName*/;

  final _bank_IFCSController = TextEditingController();
  final _bank_AcController = TextEditingController();
  String? bankAccHolder, bankAddress;
  final _bankOpeningDateController = TextEditingController();

  // AddFiFamilyDetail
  final _motherFController = TextEditingController();
  final _motherMController = TextEditingController();
  final _motherLController = TextEditingController();
  String? selectednumOfChildren;
  String? selectedschoolingChildren;
  String? selectedotherDependents;

  //INCOME & EXPENSES
  String? selectedOccupation;
  String? selectedBusiness;
  String? selectedHomeType;
  String? selectedRoofType;
  String? selectedToiletType;
  String? selectedLivingWithSpouse;
  String? selectedEarningMembers;
  String? selectedBusinessExperience;
  String? selectedOtherEMI;
  final _future_IncomeController = TextEditingController();
  final _currentEMIController = TextEditingController();
  final _agriculture_incomeController = TextEditingController();
  final _other_IncomeController = TextEditingController();
  final _annuaL_INCOMEController = TextEditingController();
  final _otheR_THAN_AGRICULTURAL_INCOMEController = TextEditingController();
  final _pensionIncomeController = TextEditingController();
  final _any_RentalIncomeController = TextEditingController();
  final _rentController = TextEditingController();
  final _foodingController = TextEditingController();
  final _educationController = TextEditingController();
  final _healthController = TextEditingController();
  final _travellingController = TextEditingController();
  final _entertainmentController = TextEditingController();
  final _spendOnChildrenController = TextEditingController();
  final _othersController = TextEditingController();

  //Guarrantor Page
  final _aadharIdController = TextEditingController();
  final _fnameController = TextEditingController();
  final _mnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _guardianController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _ageController = TextEditingController();
  final _panController = TextEditingController();
  final _dlController = TextEditingController();
  final _voterController = TextEditingController();
  final _p_Address1Controller = TextEditingController();
  final _p_Address2Controller = TextEditingController();
  final _p_Address3Controller = TextEditingController();
  final _p_CityController = TextEditingController();
  final _pincodeController = TextEditingController();
  RangeCategoryDataModel? stateselected;
  String? relationselected;
  String? genderselected;
  String? religionselected;
  String? selectedTitle;
  String? selectedDependent;

//Guarrantor Page
  final FocusNode _fnameFocus = FocusNode();
  final FocusNode _mnameFocus = FocusNode();
  final FocusNode _lnameFocus = FocusNode();
  final FocusNode _p_Address1Focus = FocusNode();
  final FocusNode _p_Address2Focus = FocusNode();
  final FocusNode _p_Address3Focus = FocusNode();
  final FocusNode _p_CityFocus = FocusNode();
  final FocusNode _pincodeFocus = FocusNode();
  final FocusNode _dobFocus = FocusNode();
  final FocusNode _ageFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _panFocus = FocusNode();
  final FocusNode _dlFocus = FocusNode();
  final FocusNode _voterFocus = FocusNode();
  final FocusNode _aadharIdFocus = FocusNode();
  final FocusNode _guardianFocus = FocusNode();
  final FocusNode _emailIdFocus = FocusNode();
  final FocusNode _placeOfBirthFocus = FocusNode();
  final FocusNode _resCatFocus = FocusNode();
  final FocusNode _mobileFocus = FocusNode();
  final FocusNode _address1FocusP = FocusNode();
  final FocusNode _address2FocusP = FocusNode();
  final FocusNode _address3FocusP = FocusNode();
  final FocusNode _address1FocusC = FocusNode();
  final FocusNode _address2FocusC = FocusNode();
  final FocusNode _address3FocusC = FocusNode();
  final FocusNode _cityFocusP = FocusNode();
  final FocusNode _pincodeFocusP = FocusNode();
  final FocusNode _cityFocusC = FocusNode();
  final FocusNode _pincodeFocusC = FocusNode();
  final FocusNode _motherFFocus = FocusNode();
  final FocusNode _motherMFocus = FocusNode();
  final FocusNode _motherLFocus = FocusNode();

  //Fem Mem Income
  final FocusNode _femNameFocus = FocusNode();
  final FocusNode _IncomeFocus = FocusNode();
  final FocusNode _AgeFocus = FocusNode();
  final FocusNode _future_IncomeFocus = FocusNode();
  final FocusNode _currentEMIFocus = FocusNode();
  final FocusNode _agriculture_incomeFocus = FocusNode();
  final FocusNode _other_IncomeFocus = FocusNode();
  final FocusNode _annuaL_INCOMEFocus = FocusNode();
  final FocusNode _spendOnChildrenFocus = FocusNode();
  final FocusNode _otheR_THAN_AGRICULTURAL_INCOMEFocus = FocusNode();
  final FocusNode _pensionIncomeFocus = FocusNode();
  final FocusNode _any_RentalIncomeFocus = FocusNode();
  final FocusNode _rentFocus = FocusNode();
  final FocusNode _foodingFocus = FocusNode();
  final FocusNode _educationFocus = FocusNode();
  final FocusNode _healthFocus = FocusNode();
  final FocusNode _travellingFocus = FocusNode();
  final FocusNode _entertainmentFocus = FocusNode();
  final FocusNode _othersFocus = FocusNode();

  //Financial Info
  final FocusNode _bank_AcFocus = FocusNode();
  final FocusNode _bank_IFCSFocus = FocusNode();
  final FocusNode _bankOpeningDateFocus = FocusNode();
  late ApiService apiService_idc;
  late int FIID;

  bool isSpecialSocialCategoryVisible = false;

  DateTime? _selectedDate;
  String? Fi_Id;
  String qrResult = "";
  File? _imageFile;
  bool grPicFlag = false;
  late String _imageFile1;
  late String _imageFile2;
  File? adhaarFront;
  File? adhaarFront_coborrower;
  File? adhaarBack;
  File? adhaarBack_coborrower;
  File? panFront;
  File? panFront_coborrower;
  File? voterFront;
  File? voterFront_coborrower;
  File? voterback;
  File? voterback_coborrower;
  File? dlFront;
  File? dlFront_coborrower;
  File? passport;
  File? passbook;
  File? pickedImage;

  late String name, ficode, creator;
  String initialPanValue = '';
  String initialDlValue = '';
  String initialVoterValue = '';

  String nameReg = '[a-zA-Z. ]';
  String addReg = r'[a-zA-Z0-9. ()/,-]';
  String amountReg = '[0-9]';
  String cityReg = '[a-zA-Z ]';
  String idsReg = '[a-zA-Z0-9/ ]';

  @override
  void initState() {
    super.initState();
    _imageFile2 =
        GlobalClass().transformFilePathToUrl(widget.selectedData.profilePic);
    FIID = widget.selectedData.id;
    creator = widget.selectedData.creator;
    ficode = widget.selectedData.fiCode.toString();
    name = widget.selectedData.fullName;

    initialPanValue = _panController.text;
    initialDlValue = _dlController.text;
    initialVoterValue = _voterController.text;
    _panController.addListener(() {
      if (panVerified && _panController.text != initialPanValue) {
        setState(() {
          panVerified = false;
        });
      }
    });
    _dlController.addListener(() {
      if (dlVerified && _dlController.text != initialDlValue) {
        setState(() {
          dlVerified = false;
        });
      }
    });
    _voterController.addListener(() {
      if (voterVerified && _voterController.text != initialVoterValue) {
        setState(() {
          voterVerified = false;
        });
      }
    });
    GetDocs(context);
    apiService_OCR = ApiService.create(baseUrl: ApiConfig.baseUrl6);
    apiService = ApiService.create(baseUrl: ApiConfig.baseUrl1);
    getAllDataApi(context);
    apiService_idc = ApiService.create(baseUrl: ApiConfig.baseUrl4);

    initializeData(); // Fetch initial data
    _emailIdFocus.addListener(_validateEmail);
    _mobileFocusNode.addListener(_validateMobile);
    _pinFocusNodeP.addListener(() {
      _validatePincode("A");
    });
    _pinFocusNodeC.addListener(() {
      _validatePincode("B");
    });
    selectedIsHandicap = "No";
  }

  Future<void> initializeData() async {
    super.initState();
    fetchData();
    _calculateAge();
    selectedDependent = onetonine.isNotEmpty ? onetonine[0] : null;
    // selectedResidingFor = onetonine.isNotEmpty ? onetonine[0] : null;
    //selectedspecialAbility = trueFalse.isNotEmpty ? trueFalse[0] : null;
    selectedSpecialSocialCategory = trueFalse.isNotEmpty ? trueFalse[0] : null;
    selectedEarningMembers = trueFalse.isNotEmpty ? trueFalse[0] : null;
    selectedBusinessExperience = trueFalse.isNotEmpty ? trueFalse[0] : null;
  }

  Future<void> fetchData() async {
    states = await DatabaseHelper().selectRangeCatData("state");
    print("states ${states}");
    relation = await DatabaseHelper().selectRangeCatData("relationship");
    religion = await DatabaseHelper().selectRangeCatData("religion");
    reasonForLoan = await DatabaseHelper().selectRangeCatData("loan_purpose");
    aadhar_gender = await DatabaseHelper().selectRangeCatData("gender");
    business_Type = await DatabaseHelper()
        .selectRangeCatData("business-type"); // Call your SQLite method
    income_type = await DatabaseHelper()
        .selectRangeCatData("income-type"); // Call your SQLite method
    bank = await DatabaseHelper()
        .selectRangeCatData("banks"); // Call your SQLite method
    cast = await DatabaseHelper().selectRangeCatData("caste");

    landOwner = await DatabaseHelper().selectRangeCatData("land_owner");
    education = await DatabaseHelper().selectRangeCatData("education");
    health = await DatabaseHelper().selectRangeCatData("health");
    schoolType = await DatabaseHelper().selectRangeCatData("school-type");
    occupationType = await DatabaseHelper().selectRangeCatData("business-type");

    roofType = await DatabaseHelper().selectRangeCatData("house-roof-type");
    toiletType = await DatabaseHelper().selectRangeCatData("toilet-type");
    houseType = await DatabaseHelper().selectRangeCatData("house-type");
    setState(() {
      states.insert(
          0,
          RangeCategoryDataModel(
              catKey: 'Select',
              groupDescriptionEn: 'select',
              groupDescriptionHi: 'select',
              descriptionEn: 'Select',
              descriptionHi: 'select',
              sortOrder: 0,
              code: 'select'));
      relation.insert(
          0,
          RangeCategoryDataModel(
              catKey: 'Select',
              groupDescriptionEn: 'select',
              groupDescriptionHi: 'select',
              descriptionEn: 'Select',
              descriptionHi: 'select',
              sortOrder: 0,
              code: 'select'));
      religion.insert(
          0,
          RangeCategoryDataModel(
              catKey: 'Select',
              groupDescriptionEn: 'select',
              groupDescriptionHi: 'select',
              descriptionEn: 'Select',
              descriptionHi: 'select',
              sortOrder: 0,
              code: 'select'));
      landOwner.insert(
          0,
          RangeCategoryDataModel(
              catKey: 'Select',
              groupDescriptionEn: 'select',
              groupDescriptionHi: 'select',
              descriptionEn: 'Select',
              descriptionHi: 'select',
              sortOrder: 0,
              code: 'select'));
      education.insert(
          0,
          RangeCategoryDataModel(
              catKey: 'Select',
              groupDescriptionEn: 'select',
              groupDescriptionHi: 'select',
              descriptionEn: 'Select',
              descriptionHi: 'select',
              sortOrder: 0,
              code: 'select'));
      health.insert(
          0,
          RangeCategoryDataModel(
              catKey: 'Select',
              groupDescriptionEn: 'select',
              groupDescriptionHi: 'select',
              descriptionEn: 'Select',
              descriptionHi: 'select',
              sortOrder: 0,
              code: 'select'));
      occupationType.insert(
          0,
          RangeCategoryDataModel(
              catKey: 'Select',
              groupDescriptionEn: 'select',
              groupDescriptionHi: 'select',
              descriptionEn: 'Select',
              descriptionHi: 'select',
              sortOrder: 0,
              code: 'select'));
      schoolType.insert(
          0,
          RangeCategoryDataModel(
              catKey: 'Select',
              groupDescriptionEn: 'select',
              groupDescriptionHi: 'select',
              descriptionEn: 'Select',
              descriptionHi: 'select',
              sortOrder: 0,
              code: 'select'));

      cast.insert(
          0,
          RangeCategoryDataModel(
              catKey: 'Select',
              groupDescriptionEn: 'select',
              groupDescriptionHi: 'select',
              descriptionEn: 'Select',
              descriptionHi: 'select',
              sortOrder: 0,
              code: 'select'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (bool value) {
          _onWillPop();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0xFFD42D3F),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 24.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                              child: Icon(Icons.arrow_back_ios_sharp, size: 13),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                pageTitle,
                                style: TextStyle(
                                  fontFamily: "Poppins-Regular",
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
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
                    _buildProgressIndicator(),
                    SizedBox(height: 50),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 240,
                      child: Stack(clipBehavior: Clip.none, children: [
                        Container(
                          //height: MediaQuery.of(context).size.height - 230,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 10,
                                //   spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: _getStepContent(),
                          ),
                        ),
                        Positioned(
                            top: -50, // Adjust the position as needed
                            left: 0,
                            right: 0,
                            child: Text(
                              name,
                              style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            )),
                        Positioned(
                            top: -35, // Adjust the position as needed
                            left: 0,
                            right: 0,
                            child: Text(
                              ficode,
                              style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            )),
                        Positioned(
                            top: -20, // Adjust the position as needed
                            left: 0,
                            right: 0,
                            child: Text(
                              creator,
                              style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            )),
                        Positioned(
                            top: -35, // Adjust the position as needed
                            left: 0,
                            right: 0,
                            child: Center(
                              child: CircleAvatar(
                                radius: 35,
                                backgroundImage: NetworkImage(_imageFile2),
                              ),
                            )),
                      ]),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildPreviousButton(),
                          SizedBox(width: 8),
                          editButtonFunctionOn
                              ? _buildEditButton()
                              : SizedBox(),
                          SizedBox(width: 8),
                          _buildNextButton(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
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
              'Are you sure?',
              style: TextStyle(
                  color: Color(0xFFD42D3F),
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Do you want to close Application form?',
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShinyButton(
                  'No',
                  () {
                    EasyLoading.dismiss();
                    Navigator.of(context).pop(true);
                  },
                ),
                _buildShinyButton(
                  'Yes',
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

  Widget _getStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStepOne();
      case 1:
        return _buildStepTwo();
      case 2:
        return _buildStepThree();
      case 3:
        return _buildStepFour();
      case 4:
        return _buildStepFive();
      case 5:
        return _buildStepSix();
      case 6:
        return _buildStepSeven();
      case 7:
        return _buildStepEight();
      default:
        return _buildStepOne();
    }
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _stepIndicator(0),
        _lineIndicator(),
        _stepIndicator(1),
        _lineIndicator(),
        _stepIndicator(2),
        _lineIndicator(),
        _stepIndicator(3),
        _lineIndicator(),
        _stepIndicator(4),
        _lineIndicator(),
        _stepIndicator(5),
        _lineIndicator(),
        _stepIndicator(6),
        _lineIndicator(),
        _stepIndicator(7),
      ],
    );
  }

  Widget _stepIndicator(int step) {
    bool isActive = _currentStep == step;
    bool isCompleted = _currentStep > step;
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted
            ? Colors.greenAccent
            : (isActive ? Colors.green : Colors.grey.shade300),
      ),
      child: CircleAvatar(
        radius: 10,
        backgroundColor: isCompleted ? Colors.green : Colors.white,
        child: Text(
          (step + 1).toString(),
          style: TextStyle(
              fontFamily: "Poppins-Regular",
              fontSize: 10,
              color: isCompleted
                  ? Colors.white
                  : (isActive ? Color(0xFFD42D3F) : Colors.grey)),
        ),
      ),
    );
  }

  Widget _lineIndicator() {
    return Container(
      width: 10,
      height: 2,
      color: Colors.grey.shade300,
    );
  }

  Widget _buildStepOne() {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _buildTextField('Email ID', emailIdController, fixtraEditable),
        Text(
          "Email Id",
          style: TextStyle(
            fontFamily: "Poppins-Regular",
            fontSize: 13,
          ),
        ),
        SizedBox(height: 1),
        Container(
            width: double.infinity, // Set the desired width
            //   //height: 45, // Set the desired height
            child: Center(
              child: TextFormField(
                enabled: personalInfoEditable,
                controller: emailIdController,
                focusNode: _emailIdFocus,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  errorText: _emailError,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            )),
        SizedBox(height: 10),

        _buildTextField('Place of Birth', placeOfBirthController,
            personalInfoEditable, _placeOfBirthFocus, addReg),
        SizedBox(height: 10),

        // Control this flag to enable/disable fields

        Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dependent Persons',
                style: TextStyle(
                  fontFamily: "Poppins-Regular",
                  fontSize: 13, // Consistent font size
                  color: Colors.black, // Optional for consistency
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 16),
              Container(
                //height: 55,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButton<String>(
                  value: selectedDependent,
                  isExpanded: true,
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                    fontFamily: "Poppins-Regular",
                    fontSize: 13, // Consistent font size
                    color: Colors.black,
                  ),
                  underline: Container(
                    height: 2,
                    color: Colors.transparent,
                  ),
                  onChanged: personalInfoEditable
                      ? (String? newValue) {
                          setState(() {
                            selectedDependent = newValue!;
                          });
                        }
                      : null,
                  items: onetonine.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontFamily: "Poppins-Regular",
                          fontSize: 13, // Consistent font size
                          color: Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        /* Row(
          children: [
            // Dependent Persons Column

            SizedBox(width: 10), // Gap of 10 between the two columns

            // Flexible(
            //   child: Padding(
            //     padding: const EdgeInsets.only(left: 5.0),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           'Reservation Category',
            //           style: TextStyle(
            //             fontFamily: "Poppins-Regular",
            //             fontSize: 13, // Consistent font size
            //             color: Colors.black, // Optional for consistency
            //           ),
            //           textAlign: TextAlign.left,
            //         ),
            //         SizedBox(height: 1),
            //         TextField(
            //           controller: resCatController,
            //           focusNode: _resCatFocus,
            //           enabled: personalInfoEditable,
            //           style: TextStyle(
            //             fontFamily: "Poppins-Regular",
            //             fontSize: 13, // Consistent font size
            //             color: Colors.black,
            //           ),
            //           decoration: InputDecoration(
            //             border: OutlineInputBorder(
            //               borderRadius: BorderRadius.circular(5),
            //             ),
            //             contentPadding: EdgeInsets.symmetric(horizontal: 12),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        )*/

        SizedBox(height: 10),

        Row(
          children: [
            // Religion Column
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                // Gap of 5 to the right for the first column
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Align children to the start of the column
                  children: [
                    Text(
                      'Religion',
                      style: TextStyle(
                          fontFamily: "Poppins-Regular", fontSize: 13),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 1),
                    // Add some spacing between the Text and Container
                    Container(
                      //height: 45,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: selectedReligionextra,
                        isExpanded: true,
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
                        onChanged: personalInfoEditable
                            ? (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedReligionextra = newValue;
                                  });
                                }
                              }
                            : null,
                        items: religion.map<DropdownMenuItem<String>>(
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
            ),
            SizedBox(width: 10), // Gap of 10 between the two columns
            // Cast Column
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                // Gap of 5 to the left for the second column
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Align children to the start of the column
                  children: [
                    Text(
                      'Cast',
                      style: TextStyle(
                          fontFamily: "Poppins-Regular", fontSize: 13),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 1),
                    // Add some spacing between the Text and Container
                    Container(
                      //height: 45,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: selectedCast,
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
                        onChanged: personalInfoEditable
                            ? (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedCast =
                                        newValue; // Update the selected value
                                  });
                                }
                              }
                            : null,
                        items: cast.map<DropdownMenuItem<String>>(
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
            ),
          ],
        ),

        SizedBox(height: 10),

        Text(
          "Mobile No.",
          style: TextStyle(
            fontFamily: "Poppins-Regular",
            fontSize: 13,
          ),
        ),
        SizedBox(height: 1),
        Container(
            width: double.infinity, // Set the desired width
            //   //height: 45, // Set the desired height
            child: Center(
              child: TextFormField(
                enabled: personalInfoEditable,
                controller: mobileController,
                focusNode: _mobileFocusNode,
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
        SizedBox(height: 10),

        Row(
          children: [
            // Is Handicap Column
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                // Gap of 5 to the left for the second column
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Align children to the start of the column
                  children: [
                    Text(
                      'Is Handicap',
                      style: TextStyle(
                          fontFamily: "Poppins-Regular", fontSize: 13),
                      textAlign: TextAlign.left, // Align text to the left
                    ),
                    SizedBox(height: 1),
                    // Add some spacing between the Text and Container
                    Container(
                      //height: 45,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: selectedIsHandicap,
                        isExpanded: true,
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
                        onChanged: personalInfoEditable
                            ? (String? newValue) {
                                setState(() {
                                  selectedIsHandicap = newValue!;
                                  if (newValue == "Yes") {
                                    _isHandicapVisible = true;
                                  } else {
                                    _isHandicapVisible = false;
                                  }
                                });
                              }
                            : null,
                        items: trueFalse.map((String value) {
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
            ),

            SizedBox(width: _isHandicapVisible ? 10 : 0),
            // Gap of 10 between the two columns
            Visibility(
                visible: _isHandicapVisible,
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    // Gap of 5 to the left for the second column
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // Align children to the start of the column
                      children: [
                        Text(
                          'Special Ability',
                          style: TextStyle(
                              fontFamily: "Poppins-Regular", fontSize: 13),
                          textAlign: TextAlign.left, // Align text to the left
                        ),
                        SizedBox(height: 1),
                        // Add some spacing between the Text and Container
                        Container(
                          //height: 45,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButton<String>(
                            value: selectedspecialAbility,
                            isExpanded: true,
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
                            onChanged: personalInfoEditable
                                ? (String? newValue) {
                                    setState(() {
                                      selectedspecialAbility = newValue!;
                                      isSpecialSocialCategoryVisible =
                                          (newValue ==
                                              'Yes'); // Update visibility
                                    });
                                  }
                                : null,
                            items: handicapTypes.map((String value) {
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
                ))
            // Special Ability Column
            ,
          ],
        ),
        SizedBox(height: 10),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Special Social Category',
              style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
            ),
            SizedBox(height: 1),
            Container(
              width: MediaQuery.of(context).size.width,
              //height: 45,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButton<String>(
                value: selectedSpecialSocialCategory,
                isExpanded: true,
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
                onChanged: personalInfoEditable
                    ? (String? newValue) {
                        setState(() {
                          selectedSpecialSocialCategory = newValue!;
                        });
                      }
                    : null,
                items: trueFalse.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        ),

        SizedBox(height: 10),
        // Gap of 10 between the two columns

        Container(
          padding: EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xFFD42D3F),
            borderRadius: BorderRadius.zero, // Sharp corners
          ),
          child: Center(
            // Center widget to center the text inside the container
            child: Text(
              'PERMANENT',
              style: TextStyle(
                fontFamily: "Poppins-Regular",
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),

        _buildTextField('Address1', address1ControllerP, personalInfoEditable,
            _address1FocusP, addReg),
        SizedBox(height: 10),

        _buildTextField('Address2', address2ControllerP, personalInfoEditable,
            _address2FocusP, addReg),
        SizedBox(height: 10),

        _buildTextField('Address3', address3ControllerP, personalInfoEditable,
            _address3FocusP, addReg),
        SizedBox(height: 10),
        _buildLabeledDropdownField(
          'Select State',
          'State',
          states,
          selectedStateextraP,
          personalInfoEditable,
          (RangeCategoryDataModel? newValue) {
            setState(() {
              selectedDistrict = null;
              selectedVillage = null;
              selectedSubDistrict = null;

              selectedStateextraP = newValue;
            });

            // getPlace("city", selectedStateextraP!.code, "", "");
            getPlace("district", selectedStateextraP!.code, "", "");
          },
          String,
        ),

        /*Text(
          'State',
          style: TextStyle(fontSize: 13),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          // Adjust the width as needed
          //height: 45,
          // Fixed height
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButton<String>(
            value: selectedStateextraP,
            isExpanded: true,
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black, fontSize: 13),
            underline: Container(
              height: 2,
              color: Colors
                  .transparent, // Set to transparent to remove default underline
            ),
            onChanged: personalInfoEditable
                ?(String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedStateextraP = newValue; // Update the selected value
                });
              }
            }: null,
            items: states
                .map<DropdownMenuItem<String>>((RangeCategoryDataModel state) {
              return DropdownMenuItem<String>(
                value: state.code,
                child: Text(state.descriptionEn),
              );
            }).toList(),
          ),
        ),*/
        SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // City TextField
            Flexible(
              child: _buildTextField('City', cityControllerP,
                  personalInfoEditable, _cityFocusP, cityReg),
            ),
            SizedBox(width: 10),
            // Add some space between the City TextField and Pin Code Text
            // Pin Code Text and TextFormField
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pin Code",
                    style: TextStyle(
                      fontFamily: "Poppins-Regular",
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 1),
                  Container(
                    width: double.infinity, // Set the desired width
                    child: TextFormField(
                      enabled: personalInfoEditable,
                      controller: pincodeControllerP,
                      focusNode: _pinFocusNodeP,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        errorText: _pinErrorP,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        // Only digits allowed
                        LengthLimitingTextInputFormatter(6),
                        // Maximum length of 10
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 10),
        // Add some space between the City TextField and Pin Code Text

        Container(
          padding: EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xFFD42D3F),
            borderRadius: BorderRadius.zero, // Sharp corners
          ),
          child: Center(
            // Center widget to center the text inside the container
            child: Text(
              'CURRENT',
              style: TextStyle(
                fontFamily: "Poppins-Regular",
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: _isAddressChecked,
              onChanged: personalInfoEditable ? _onCheckboxChanged : null,
            ),
            Text(
              'Same as Permanent Address',
              style: TextStyle(
                fontFamily: "Poppins-Regular",
                fontSize: 10.0,
                color: Color(0xFFD42D3F), // Custom color
              ),
            ),
          ],
        ),
        _buildTextField('Address1', address1ControllerC, personalInfoEditable,
            _address1FocusC, addReg),
        SizedBox(height: 10),

        _buildTextField('Address2', address2ControllerC, personalInfoEditable,
            _address2FocusC, addReg),
        SizedBox(height: 10),

        _buildTextField('Address3', address3ControllerC, personalInfoEditable,
            _address3FocusC, addReg),
        SizedBox(height: 10),

        _buildLabeledDropdownField(
          'Select State',
          'State',
          states,
          selectedStateextraC,
          personalInfoEditable,
          (RangeCategoryDataModel? newValue) {
            setState(() {
              selectedStateextraC = newValue;
            });
          },
          String,
        ),
        SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // City TextField
            Flexible(
              child: _buildTextField('City', cityControllerC,
                  personalInfoEditable, _cityFocusC, cityReg),
            ),
            SizedBox(width: 10),
            // Add some space between the City TextField and Pin Code Text
            // Pin Code Text and TextFormField
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pin Code",
                    style: TextStyle(
                      fontFamily: "Poppins-Regular",
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 1),
                  Container(
                    width: double.infinity, // Set the desired width
                    child: TextFormField(
                      enabled: personalInfoEditable,
                      controller: pincodeControllerC,
                      focusNode: _pinFocusNodeC,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        errorText: _pinErrorC,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),

        /*Expanded(
              child: _buildLabeledDropdownField(
                  'Village', 'Village', listVillagesCodes, selectedVillage,
                  (PlaceData? newValue) {
                setState(() {
                  selectedVillage = newValue;
                });
              }, String),
            ),*/

        /*Row(
          children: [
            Expanded(
              child: _buildLabeledDropdownField(
                  'District', 'Districts', listDistrictCodes, selectedDistrict,
                  (PlaceData? newValue) {
                setState(() {
                  selectedVillage = null;
                  selectedSubDistrict = null;

                  selectedDistrict = newValue;

                  getPlace("subdistrict", selectedStateextraP!.code,
                      selectedDistrict!.distCode!, "");
                });
              }, String),
            ),
            SizedBox(width: 16.0), // Optional spacing between the dropdowns
            Expanded(
              child: _buildLabeledDropdownField(
                'Sub-District',
                'Sub-Districts',
                listSubDistrictCodes,
                selectedSubDistrict,
                (PlaceData? newValue) {
                  setState(() {
                    selectedSubDistrict = newValue;
                  });
                  getPlace(
                    "village",
                    selectedStateextraP!.code,
                    selectedDistrict!.distCode!,
                    selectedSubDistrict!.subDistCode!,
                  );
                },
                String,
              ),
            ),
          ],
        ),*/
        Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                // Gap of 5 to the left for the second column
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Align children to the start of the column
                  children: [
                    Text(
                      'Is House Rental',
                      style: TextStyle(
                          fontFamily: "Poppins-Regular", fontSize: 13),
                      textAlign: TextAlign.left, // Align text to the left
                    ),
                    SizedBox(height: 1),
                    // Add some spacing between the Text and Container
                    Container(
                      //height: 45,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: selectedIsHouseRental,
                        isExpanded: true,
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
                        onChanged: personalInfoEditable
                            ? (String? newValue) {
                                setState(() {
                                  selectedIsHouseRental = newValue!;
                                });
                              }
                            : null,
                        items: trueFalse.map((String value) {
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
            ),
            SizedBox(width: 16.0),
            // Optional spacing between the dropdown and the column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Residing for (Years)',
                    style:
                        TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton<String>(
                      value: selectedResidingFor,
                      isExpanded: true,
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
                      onChanged: personalInfoEditable
                          ? (String? newValue) {
                              setState(() {
                                selectedResidingFor = newValue!;
                              });
                            }
                          : null,
                      items: onetonine.map((String value) {
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
          ],
        ),

        SizedBox(height: 10),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Property (In Acres)',
                    style:
                        TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
                  ),
                  Container(
                    //width: 150,
                    // Adjust the width as needed
                    //height: 45,
                    // Fixed height
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton<String>(
                      value: selectedProperty,
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
                      onChanged: personalInfoEditable
                          ? (String? newValue) {
                              setState(() {
                                selectedProperty = newValue!;
                              });
                            }
                          : null,
                      items: onetonine.map((String value) {
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
            Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'House Owner',
                      style: TextStyle(
                          fontFamily: "Poppins-Regular", fontSize: 13),
                    ),
                    Container(
                      //width: 150,
                      // Adjust the width as needed
                      //height: 45,
                      // Fixed height
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: selectedPresentHouseOwner,
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
                        onChanged: personalInfoEditable
                            ? (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedPresentHouseOwner =
                                        newValue; // Update the selected value
                                  });
                                }
                              }
                            : null,
                        items: landOwner.map<DropdownMenuItem<String>>(
                            (RangeCategoryDataModel state) {
                          return DropdownMenuItem<String>(
                            value: state.code,
                            child: Text(state.descriptionEn),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ))
          ],
        )
      ],
    ));
  }

  Widget _buildStepTwo() {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('Mother name', _motherFController, FiFamilyEditable,
            _motherFFocus, nameReg),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Flexible(
                child: _buildTextField('Middle Name', _motherMController,
                    FiFamilyEditable, _motherMFocus, nameReg)),
            SizedBox(width: 13),
            // Add spacing between the text fields if needed
            Flexible(
                child: _buildTextField('Last Name', _motherLController,
                    FiFamilyEditable, _motherLFocus, nameReg)),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'No. of Children',
          style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
        ),
        SizedBox(
          height: 1,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          // Adjust the width as needed
          //height: 45,
          // Fixed height
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
            onChanged: FiFamilyEditable
                ? (String? newValue) {
                    setState(() {
                      selectednumOfChildren = newValue!;
                    });
                  }
                : null,
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
          'School Going Children',
          style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
        ),
        SizedBox(
          height: 1,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          // Adjust the width as needed
          //height: 45,
          // Fixed height
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
            onChanged: FiFamilyEditable
                ? (String? newValue) {
                    setState(() {
                      selectedschoolingChildren = newValue!;
                    });
                  }
                : null,
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
          'Other Dependents',
          style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          // Adjust the width as needed
          //height: 45,
          // Fixed height
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
            onChanged: FiFamilyEditable
                ? (String? newValue) {
                    setState(() {
                      selectedotherDependents = newValue!;
                    });
                  }
                : null,
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

  Widget _buildStepThree() {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Occupation',
                    style:
                        TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton<String>(
                      value: selectedOccupation,
                      isExpanded: true,
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(
                          fontFamily: "Poppins-Regular",
                          color: Colors.black,
                          fontSize: 13),
                      underline: Container(
                        height: 2,
                        color: Colors.transparent, // Remove default underline
                      ),
                      onChanged: FiIncomeEditable
                          ? (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedOccupation =
                                      newValue; // Update the selected value
                                });
                              }
                            }
                          : null,
                      items: occupationType.map<DropdownMenuItem<String>>(
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
            SizedBox(width: 10), // Spacing between the two columns
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Business Detail',
                    style:
                        TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton<String>(
                      value: selectedBusiness,
                      isExpanded: true,
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(
                          fontFamily: "Poppins-Regular",
                          color: Colors.black,
                          fontSize: 13),
                      underline: Container(
                        height: 2,
                        color: Colors.transparent, // Remove default underline
                      ),
                      onChanged: FiIncomeEditable
                          ? (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedBusiness =
                                      newValue; // Update the selected value
                                });
                              }
                            }
                          : null,
                      items: business_Type.map<DropdownMenuItem<String>>(
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
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Flexible(
              child: _buildTextField2(
                  'Current EMI',
                  _currentEMIController,
                  TextInputType.number,
                  FiIncomeEditable,
                  _currentEMIFocus,
                  6,
                  amountReg),
            ),
            SizedBox(width: 10), // Spacing between the two columns
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Home Type',
                    style:
                        TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    height: 55,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton<String>(
                      value: selectedHomeType,
                      isExpanded: true,
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
                      onChanged: FiIncomeEditable
                          ? (String? newValue) {
                              setState(() {
                                selectedHomeType = newValue!;
                              });
                            }
                          : null,
                      items: houseType.map<DropdownMenuItem<String>>(
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
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Roof Type',
                    style:
                        TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    //  //height: 45,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton<String>(
                      value: selectedRoofType,
                      isExpanded: true,
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
                      onChanged: FiIncomeEditable
                          ? (String? newValue) {
                              setState(() {
                                selectedRoofType = newValue!;
                              });
                            }
                          : null,
                      items: roofType.map<DropdownMenuItem<String>>(
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
            SizedBox(width: 10), // Spacing between the two columns
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Toilet Type',
                    style:
                        TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    //  //height: 45,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton<String>(
                      value: selectedToiletType,
                      isExpanded: true,
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
                      onChanged: FiIncomeEditable
                          ? (String? newValue) {
                              setState(() {
                                selectedToiletType = newValue!;
                              });
                            }
                          : null,
                      items: toiletType.map<DropdownMenuItem<String>>(
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
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Leave With Spouse',
                    style:
                        TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    //  //height: 45,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton<String>(
                      value: selectedLivingWithSpouse,
                      isExpanded: true,
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
                      onChanged: FiIncomeEditable
                          ? (String? newValue) {
                              setState(() {
                                selectedLivingWithSpouse = newValue!;
                              });
                            }
                          : null,
                      items: trueFalse.map((String value) {
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
            SizedBox(width: 10), // Spacing between the two columns
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Earning Member',
                    style:
                        TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    //  //height: 45,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton<String>(
                      value: selectedEarningMembers,
                      isExpanded: true,
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
                      onChanged: FiIncomeEditable
                          ? (String? newValue) {
                              setState(() {
                                selectedEarningMembers = newValue!;
                              });
                            }
                          : null,
                      items: onetonine.map((String value) {
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
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Business Experience',
          style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
          textAlign: TextAlign.left,
        ),
        Container(
          //  //height: 45,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButton<String>(
            value: selectedBusinessExperience,
            isExpanded: true,
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
            onChanged: FiIncomeEditable
                ? (String? newValue) {
                    setState(() {
                      selectedBusinessExperience = newValue!;
                    });
                  }
                : null,
            items: onetonine.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xFFD42D3F),
            borderRadius: BorderRadius.zero, // Sharp corners
          ),
          child: Center(
            // Center widget to center the text inside the container
            child: Text(
              'INCOMES',
              style: TextStyle(
                fontFamily: "Poppins-Regular",
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: _buildTextField2(
                      'Future Income',
                      _future_IncomeController,
                      TextInputType.number,
                      FiIncomeEditable,
                      _future_IncomeFocus,
                      6,
                      amountReg),
                ),
                Flexible(
                  child: _buildTextField2(
                      'Agriculture Income',
                      _agriculture_incomeController,
                      TextInputType.number,
                      FiIncomeEditable,
                      _agriculture_incomeFocus,
                      6,
                      amountReg),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: _buildTextField2(
                      'Rental Income',
                      _any_RentalIncomeController,
                      TextInputType.number,
                      FiIncomeEditable,
                      _any_RentalIncomeFocus,
                      6,
                      amountReg),
                ),
                Flexible(
                  child: _buildTextField2(
                      'Annual Income',
                      _annuaL_INCOMEController,
                      TextInputType.number,
                      FiIncomeEditable,
                      _annuaL_INCOMEFocus,
                      6,
                      amountReg),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: _buildTextField2(
                      'Other Income',
                      _other_IncomeController,
                      TextInputType.number,
                      FiIncomeEditable,
                      _other_IncomeFocus,
                      6,
                      amountReg),
                ),
                Flexible(
                  child: _buildTextField2(
                      'Pension Income',
                      _pensionIncomeController,
                      TextInputType.number,
                      FiIncomeEditable,
                      _pensionIncomeFocus,
                      6,
                      amountReg),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: _buildTextField2(
                      'Other than Agricultural Income',
                      _otheR_THAN_AGRICULTURAL_INCOMEController,
                      TextInputType.number,
                      FiIncomeEditable,
                      _otheR_THAN_AGRICULTURAL_INCOMEFocus,
                      6,
                      amountReg),
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xFFD42D3F),
            borderRadius: BorderRadius.zero, // Sharp corners
          ),
          child: Center(
            // Center widget to center the text inside the container
            child: Text(
              'EXPENSES ON',
              style: TextStyle(
                fontFamily: "Poppins-Regular",
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: _buildTextField2(
                      'Rent',
                      _rentController,
                      TextInputType.number,
                      FiIncomeEditable,
                      _rentFocus,
                      6,
                      amountReg),
                ),
                Flexible(
                  child: _buildTextField2(
                      'Food',
                      _foodingController,
                      TextInputType.number,
                      FiIncomeEditable,
                      _foodingFocus,
                      6,
                      amountReg),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: _buildTextField2(
                      'Education',
                      _educationController,
                      TextInputType.number,
                      FiIncomeEditable,
                      _educationFocus,
                      6,
                      addReg),
                ),
                Flexible(
                  child: _buildTextField2(
                      'Health',
                      _healthController,
                      TextInputType.number,
                      FiIncomeEditable,
                      _healthFocus,
                      6,
                      amountReg),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: _buildTextField2(
                      'Travelling',
                      _travellingController,
                      TextInputType.number,
                      FiIncomeEditable,
                      _travellingFocus,
                      6,
                      amountReg),
                ),
                Flexible(
                  child: _buildTextField2(
                      'Entertainment',
                      _entertainmentController,
                      TextInputType.number,
                      FiIncomeEditable,
                      _entertainmentFocus,
                      6,
                      amountReg),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: _buildTextField2(
                      'Children',
                      _spendOnChildrenController,
                      TextInputType.number,
                      FiIncomeEditable,
                      _spendOnChildrenFocus,
                      6,
                      amountReg),
                ),
                Flexible(
                  child: _buildTextField2(
                      'Others',
                      _othersController,
                      TextInputType.number,
                      FiIncomeEditable,
                      _othersFocus,
                      6,
                      amountReg),
                ),
              ],
            ),
          ],
        )
      ],
    ));
  }

  Widget _buildStepFour() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ACCOUNT TYPE',
            style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
            textAlign: TextAlign.left,
          ),
          Container(
            //  //height: 45,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButton<String>(
              value: selectedAccountType,
              isExpanded: true,
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
              onChanged: FinancialInfoEditable
                  ? (String? newValue) {
                      setState(() {
                        selectedAccountType = newValue!;
                      });
                    }
                  : null,
              items: accType.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 10), // Adds space between the fields

          Container(
            padding: EdgeInsets.all(0), // Padding of 10 from each side
            decoration: BoxDecoration(
              color: Colors.white, // Background color of the container
              border: Border.all(color: Color(0xFFD42D3F)), // Red border color
              borderRadius: BorderRadius.circular(10), // Circular corners
            ),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTextField('IFSC', _bank_IFCSController,
                      FinancialInfoEditable, _bank_IFCSFocus, '[a-zA-Z0-9]'),
                  _buildTextField2(
                      'BANK ACCOUNT NO.',
                      _bank_AcController,
                      TextInputType.number,
                      FinancialInfoEditable,
                      _bank_AcFocus,
                      17,
                      amountReg),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, // Text color
                        backgroundColor:
                            Color(0xFFD42D3F), // Background color of the button
                        padding: EdgeInsets.symmetric(vertical: 0.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // Rectangular shape
                        ),
                      ),
                      onPressed: FinancialInfoEditable
                          ? () {
                              if (_bank_AcController.text.isEmpty ||
                                  _bank_IFCSController.text.isEmpty) {
                                showToast_Error(
                                    "Please Enter Bank Account number and IFSC code");
                              } else if (_bank_IFCSController.text.length !=
                                  11) {
                                showToast_Error(
                                    "Please Enter Correct IFSC code");
                              } else if (_bank_AcController.text.length < 10) {
                                showToast_Error(
                                    "Please Enter Correct Account Number");

                              }else if(BorrowerInfo[0].bankAc != "" &&_bank_AcController.text == BorrowerInfo[0].bankAc){
                                showToast_Error("Account Number already Verified");
                              }else if(_bank_AcController.text==temp){
                                showToast_Error("Account Number already Verified");

                              }else {

                                ifscVerify(context, _bank_IFCSController.text);
                              }
                            }
                          : null,
                      child: Text(
                        'Verify Details',
                        style: TextStyle(
                            fontFamily: "Poppins-Regular",
                            fontSize: 18), // Text size
                      ),
                    ),
                  )
                ],
              ),
            )),
          ),
          SizedBox(height: 10), // Adds space between the fields

          bankAccHolder != null
              ? Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'BORROWER NAME:',
                        style: TextStyle(
                            fontFamily: "Poppins-Regular",
                            color: Colors.black,
                            fontSize: 13),
                      ),
                      TextSpan(
                        text: " ${bankAccHolder}",
                        style: TextStyle(
                            fontFamily: "Poppins-Regular",
                            color: Colors.green,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          bankAccHolder != null ? Divider() : SizedBox(),
          bankAddress != null
              ? Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'BANK ADDRESS:',
                        style: TextStyle(
                            fontFamily: "Poppins-Regular",
                            color: Colors.black,
                            fontSize: 13),
                      ),
                      TextSpan(
                        text: " ${bankAddress}",
                        style: TextStyle(
                            fontFamily: "Poppins-Regular",
                            color: Colors.green,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          bankAddress != null ? Divider() : SizedBox(),
          SizedBox(height: 10),

          Text(
            'ACCOUNT OPENING DATE',
            style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
          ),
          SizedBox(height: 10), // Adds space between the fields

          Container(
            color: Colors.white,
            child: TextField(
              enabled: FinancialInfoEditable,
              controller: _bankOpeningDateController,
              focusNode: _bankOpeningDateFocus,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, "open"),
                ),
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepFive() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField('Name', _femNameController, femMemIncomeEditable,
              _femNameFocus, nameReg),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Flexible(
                child: _buildTextField2(
                    'Age',
                    _AgeController,
                    TextInputType.number,
                    femMemIncomeEditable,
                    _AgeFocus,
                    2,
                    amountReg),
              ),
              SizedBox(width: 10), // Adds space between the fields
              Flexible(
                child: _buildTextField2(
                    'Income',
                    _IncomeController,
                    TextInputType.number,
                    femMemIncomeEditable,
                    _IncomeFocus,
                    6,
                    amountReg),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gender',
                      style: TextStyle(
                          fontFamily: "Poppins-Regular", fontSize: 13),
                    ),
                    Container(
                      height: 60,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: femselectedGender,
                        isExpanded: true,
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
                        onChanged: femMemIncomeEditable
                            ? (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    femselectedGender =
                                        newValue; // Update the selected value
                                  });
                                }
                              }
                            : null,
                        items: aadhar_gender.map<DropdownMenuItem<String>>(
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
              SizedBox(width: 10), // Spacing between the two columns
              Flexible(
                child: Column(
                  children: [
                    Text(
                      'Relation',
                      style: TextStyle(
                          fontFamily: "Poppins-Regular", fontSize: 13),
                    ),
                    Container(
                      height: 60,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: femselectedRelationWithBorrower,
                        isExpanded: true,
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
                        onChanged: femMemIncomeEditable
                            ? (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    femselectedRelationWithBorrower =
                                        newValue; // Update the selected value
                                  });
                                }
                              }
                            : null,
                        items: relation.map<DropdownMenuItem<String>>(
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
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Health',
                      style: TextStyle(
                          fontFamily: "Poppins-Regular", fontSize: 13),
                    ),
                    Container(
                      height: 60,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: femselectedHealth,
                        isExpanded: true,
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
                        onChanged: femMemIncomeEditable
                            ? (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    femselectedHealth =
                                        newValue; // Update the selected value
                                  });
                                }
                              }
                            : null,
                        items: health.map<DropdownMenuItem<String>>(
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
              SizedBox(width: 10), // Spacing between the two columns
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Education',
                      style: TextStyle(
                          fontFamily: "Poppins-Regular", fontSize: 13),
                    ),
                    Container(
                      height: 60,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: femselectedEducation,
                        isExpanded: true,
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
                        onChanged: femMemIncomeEditable
                            ? (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    femselectedEducation =
                                        newValue; // Update the selected value
                                  });
                                }
                              }
                            : null,
                        items: education.map<DropdownMenuItem<String>>(
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
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SchoolType',
                      style: TextStyle(
                          fontFamily: "Poppins-Regular", fontSize: 13),
                    ),
                    Container(
                      height: 60,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: femselectedSchoolType,
                        isExpanded: true,
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
                        onChanged: femMemIncomeEditable
                            ? (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    femselectedSchoolType =
                                        newValue; // Update the selected value
                                  });
                                }
                              }
                            : null,
                        items: schoolType.map<DropdownMenuItem<String>>(
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
              SizedBox(width: 10), // Spacing between the two columns
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Business',
                      style: TextStyle(
                          fontFamily: "Poppins-Regular", fontSize: 13),
                    ),
                    Container(
                      height: 60,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: femselectedBusiness,
                        isExpanded: true,
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
                        onChanged: femMemIncomeEditable
                            ? (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    femselectedBusiness =
                                        newValue; // Update the selected value
                                  });
                                }
                              }
                            : null,
                        items: occupationType.map<DropdownMenuItem<String>>(
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
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Business Type',
                      style: TextStyle(
                          fontFamily: "Poppins-Regular", fontSize: 13),
                    ),
                    Container(
                      height: 60,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: femselectedBusinessType,
                        isExpanded: true,
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
                        onChanged: femMemIncomeEditable
                            ? (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    femselectedBusinessType =
                                        newValue; // Update the selected value
                                  });
                                }
                              }
                            : null,
                        items: business_Type.map<DropdownMenuItem<String>>(
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
              SizedBox(width: 10), // Spacing between the two columns
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'IncomeType',
                      style: TextStyle(
                          fontFamily: "Poppins-Regular", fontSize: 13),
                    ),
                    Container(
                      height: 60,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: femselectedIncomeType,
                        isExpanded: true,
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
                        onChanged: femMemIncomeEditable
                            ? (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    femselectedIncomeType =
                                        newValue; // Update the selected value
                                  });
                                }
                              }
                            : null,
                        items: income_type.map<DropdownMenuItem<String>>(
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
        ],
      ),
    );
  }

  Widget _buildStepSix() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

        Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Aadhaar ID",
                  style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13, height: 2),
                ),
                SizedBox(height: 8), // Adjust the spacing
                Container(
                  padding: EdgeInsets.zero,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    maxLength: 12,
                    style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
                    focusNode: _focusNodeAdhaarId,
                    controller: _aadharIdController,
                    enabled: GuarantorEditable,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      errorText: _errorMessageAadhaar.isEmpty ? null : _errorMessageAadhaar,
                      counterText: "",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Aadhaar ID';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _validateOnFocusChange();
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: GestureDetector(
              onTap: () => _showPopup(context, (String result) {
                setState(() {
                  qrResult = result;
                });
              }),
              child: Icon(
                Icons.qr_code_2_sharp,
                size: 50.0,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),

      Row(
            children: [
              SizedBox(
                width: 95, // Fixed width for the Title dropdown
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title',
                      style: TextStyle(
                          fontFamily: "Poppins-Regular", fontSize: 13),
                    ),
                    Container(
                      height: 60,
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
                        style: TextStyle(
                            fontFamily: "Poppins-Regular",
                            color: Colors.black,
                            fontSize: 13),
                        underline: Container(
                          height: 2,
                          color: Colors
                              .transparent, // Set to transparent to remove default underline
                        ),
                        onChanged: GuarantorEditable
                            ? (String? newValue) {
                                setState(() {
                                  selectedTitle = newValue!;
                                });
                              }
                            : null,
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
              Flexible(
                child: _buildTextField('Name', _fnameController,
                    GuarantorEditable, _fnameFocus, nameReg),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                  child: _buildTextField('Middle Name', _mnameController,
                      GuarantorEditable, _mnameFocus, nameReg)),
              SizedBox(width: 13),
              // Add spacing between the text fields if needed
              Flexible(
                  child: _buildTextField('Last Name', _lnameController,
                      GuarantorEditable, _lnameFocus, nameReg)),
            ],
          ),
          _buildTextField2('Guardian Name', _guardianController, TextInputType.name, GuarantorEditable, _guardianFocus, 20, nameReg),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gender',
                      style: TextStyle(
                          fontFamily: "Poppins-Regular", fontSize: 13),
                    ),
                    Container(
                      // Adjust the width as needed
                      height: 60,
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
                        onChanged: GuarantorEditable
                            ? (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    genderselected =
                                        newValue; // Update the selected value
                                  });
                                }
                              }
                            : null,
                        items: aadhar_gender.map<DropdownMenuItem<String>>(
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
              SizedBox(width: 10),
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Relationship',
                      style: TextStyle(
                          fontFamily: "Poppins-Regular", fontSize: 13),
                    ),
                    Container(
                      // Adjust the width as needed
                      height: 60,
                      // Fixed height
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: relationselected,
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
                        onChanged: GuarantorEditable
                            ? (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    relationselected =
                                        newValue; // Update the selected value
                                  });
                                }
                              }
                            : null,
                        items: relation.map<DropdownMenuItem<String>>(
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
              )
            ],
          ),
          Text(
            'Religion',
            style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            // Adjust the width as needed
            //height: 60,
            // Fixed height
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButton<String>(
              value: religionselected,
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
              onChanged: GuarantorEditable
                  ? (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          religionselected =
                              newValue; // Update the selected value
                        });
                      }
                    }
                  : null,
              items: religion.map<DropdownMenuItem<String>>(
                  (RangeCategoryDataModel state) {
                return DropdownMenuItem<String>(
                  value: state.code,
                  child: Text(state.descriptionEn),
                );
              }).toList(),
            ),
          ),
          _buildTextField2('Mobile no', _phoneController, TextInputType.number,
              GuarantorEditable, _phoneFocus, 10, amountReg),
          Row(
            children: [
              // Age Box
              SizedBox(
                width: 80, // Set a fixed width for the age box
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Age',
                      style: TextStyle(
                          fontFamily: "Poppins-Regular", fontSize: 13),
                    ),
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
              SizedBox(width: 10),
              // Date of Birth Box
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date of Birth',
                      style: TextStyle(
                          fontFamily: "Poppins-Regular", fontSize: 13),
                    ),
                    Container(
                      color: Colors.white,
                      child: TextField(
                        enabled: GuarantorEditable,
                        controller: _dobController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context, "DOB"),
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
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(0), // Padding of 10 from each side
            decoration: BoxDecoration(
              color: Color(0xFFF8F8DA), // Custom grey color
              border: Border.all(color: Color(0xFFD42D3F)), // Red border color
              borderRadius: BorderRadius.circular(10), // Circular corners
            ),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PAN No',
                                style: TextStyle(
                                  fontFamily: "Poppins-Regular",
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(height: 1),
                              Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  // Set the desired width
                                  //  //height: 45, // Set the desired height
                                  child: Center(
                                    child: TextFormField(
                                      enabled: GuarantorEditable,
                                      controller: _panController,
                                      focusNode: _panFocus,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter PAN No';
                                        }
                                        return null;
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[a-zA-Z0-9]')),
                                        // Allow only alphanumeric characters // Optional: to deny spaces
                                        TextInputFormatter.withFunction(
                                          (oldValue, newValue) =>
                                              TextEditingValue(
                                            text: newValue.text.toUpperCase(),
                                            selection: newValue.selection,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: GestureDetector(
                            onTap: () {
                              if (_panController.text.isEmpty ||
                                  _panController.text.length != 10) {
                                showToast_Error("Please Enter Correct PAN No.");
                              } else {
                                verifyDocs(context, _panController.text,
                                    "pancard", "", "");
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: panVerified ? Colors.white : Colors.grey,
                              ),
                              child: Icon(
                                Icons.check_circle,
                                color:
                                    panVerified ? Colors.green : Colors.white,
                              ),
                            ),
                          )),
                    ],
                  ),
                  Text(panCardHolderName,
                      style: TextStyle(
                          fontFamily: "Poppins-Regular",
                          color: !panVerified
                              ? Colors.grey.shade400
                              : Colors.green,
                          fontSize: !panVerified ? 11 : 14)),
                  Row(
                    children: [
                      Flexible(
                        child: _buildTextField('Driving License', _dlController,
                            GuarantorEditable, _dlFocus, nameReg),
                      ),
                      SizedBox(width: 10),
                      Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: GestureDetector(
                            onTap: () {
                              if (_dlController.text.isEmpty ||
                                  _dlController.text.length > 16 ||
                                  _dobController.text.isEmpty) {
                                showToast_Error("DL No. or DOB is Incorrect");
                              } else {
                                verifyDocs(context, _dlController.text,
                                    "drivinglicense", "", "");
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: dlVerified
                                    ? Colors.green
                                    : Colors
                                        .grey, // Use the state variable for color
                              ),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                            ),
                          )),
                    ],
                  ),
                  dlCardHolderName == null
                      ? Text(
                          "Please search driving license holder name for verification",
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
                  SizedBox(height: 4),
                  Text(
                    'OR',
                    style: TextStyle(
                      fontFamily: "Poppins-Regular",
                      fontSize: 13,
                      color: Color(0xFFD42D3F), // Set the text color to red
                    ),
                    textAlign: TextAlign.center, // Center the text
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: _buildTextField('Voter Id', _voterController,
                            GuarantorEditable, _voterFocus, idsReg),
                      ),
                      SizedBox(width: 10),
                      Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: GestureDetector(
                            onTap: () {
                              if (_voterController.text.isEmpty ||
                                  _voterController.text.length != 10) {
                                showToast_Error("Please Enter Correct PAN No.");
                              } else {
                                verifyDocs(context, _voterController.text,
                                    "voterid", "", _dobController.text);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: voterVerified
                                    ? Colors.green
                                    : Colors
                                        .grey, // Use the state variable for color
                              ),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                            ),
                          )),
                    ],
                  ),
                  voterCardHolderName == null
                      ? Text(
                          "Please search voter card holder name for verification",
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
                ],
              ),
            )),
          ),
          SizedBox(height: 10),
          _buildTextField('Address 1', _p_Address1Controller, GuarantorEditable,
              _p_Address1Focus, addReg),
          SizedBox(height: 10),
          _buildTextField('Address 2', _p_Address2Controller, GuarantorEditable,
              _p_Address2Focus, addReg),
          SizedBox(height: 10),
          _buildTextField('Address 3', _p_Address3Controller, GuarantorEditable,
              _p_Address3Focus, addReg),
          SizedBox(height: 10),
          /*Text(
            'State Name',
            style: TextStyle(fontSize: 13),
          ),
          SizedBox(height: 1),
          Container(
            width: MediaQuery.of(context).size.width,
            // Adjust the width as needed
            height: 55,
            // Fixed height
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButton<RangeCategoryDataModel>(
              value: stateselected,
              isExpanded: true,
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.black, fontSize: 13),
              underline: Container(
                height: 2,
                color: Colors
                    .transparent, // Set to transparent to remove default underline
              ),
              onChanged:GuarantorEditable? (RangeCategoryDataModel? newValue) {
                if (newValue != null) {
                  setState(() {
                    stateselected = newValue; // Update the selected value
                  });
                }
              }:null,
              items: states.map<DropdownMenuItem<RangeCategoryDataModel>>(
                  (RangeCategoryDataModel state) {
                return DropdownMenuItem<RangeCategoryDataModel>(
                  value: state,
                  child: Text(state.descriptionEn),
                );
              }).toList(),
            ),
          ),*/
          _buildLabeledDropdownField(
              'Select State', 'State', states, stateselected, true,
              (RangeCategoryDataModel? newValue) {
            setState(() {
              stateselected = newValue;
            });
          }, String),
          SizedBox(height: 10),
          Row(
            children: [
              Flexible(
                  child: _buildTextField('City', _p_CityController,
                      GuarantorEditable, _p_CityFocus, cityReg)),
              SizedBox(width: 10),
              Flexible(
                  child: _buildTextField2(
                      'Pincode',
                      _pincodeController,
                      TextInputType.number,
                      GuarantorEditable,
                      _pincodeFocus,
                      6,
                      amountReg)),
            ],
          ),
          grPicFlag
              ? Image.network(_imageFile1)
              : (_imageFile == null
                  ? Text('No image selected.')
                  : Image.file(_imageFile!)),
          ElevatedButton(
            onPressed: getImage,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, // Makes the corners square
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(Icons.camera_alt),
                SizedBox(width: 8),
                // Optional: Adds space between the icon and text
                Text('Click Guarantor Pic'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepSeven() {
    return SingleChildScrollView(
      child: Container(
          height: MediaQuery.of(context).size.height - 280,
          width: double.infinity, // Set the width to the full screen size
          child: SingleChildScrollView(
            child: _isPageLoading
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildKycDocumentList(
                        isStepSeven: true), // Call the function here
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFD42D3F),
                    ),
                  ),
          )),
    ); // Call the function her
  }

  Widget _buildStepEight() {
    return SingleChildScrollView(
      child: Container(
          height: MediaQuery.of(context).size.height - 250,
          width: double.infinity, // Set the width to the full screen size
          child: SingleChildScrollView(
            child: _isPageLoading
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildKycDocumentListGur(
                        isStepEight: true), // Call the function here
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFD42D3F),
                    ),
                  ),
          )),
    ); // Call the function her
  }

  Widget _buildPreviousButton() {
    if (_currentStep == 0) {
      return SizedBox.shrink(); // Don't show the button on the first page
    }
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: 13),
        ),
        //  fixtraEditable,FiIncomeEditable,FinancialInfoEditable,GuarantorEditable,UploadFiDocsEditable,FiFamilyEditable,femMemIncomeEditable
        onPressed: () {
          setState(() {
            editButtonFunctionOn = true;
          });
          if (_currentStep == 0) {
            setState(() {});
          } else if (_currentStep == 1) {
            setState(() {
              pageTitle = "Personal Info";
              _currentStep -= 1;
            });
          } else if (_currentStep == 2) {
            setState(() {
              pageTitle = "Family Details";
              _currentStep -= 1;
            });
          } else if (_currentStep == 3) {
            setState(() {
              pageTitle = "Income & Expense";
              _currentStep -= 1;
            });
          } else if (_currentStep == 4) {
            setState(() {
              pageTitle = "Financial Info.";
              _currentStep -= 1;
            });
          } else if (_currentStep == 5) {
            setState(() {
              _currentStep -= 1;
              pageTitle = "Family Income";
            });
          } else if (_currentStep == 6) {
            setState(() {
              pageTitle = "Guarantor Form";
              _currentStep -= 1;
            });
          } else if (_currentStep == 7) {
            setState(() {
              editButtonFunctionOn = false;
              pageTitle = "Upload Docs";
              _currentStep -= 1;
            });
          }
        },

        child: Text(
          "PREVIOUS",
          style: TextStyle(
              fontFamily: "Poppins-Regular", color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: 13),
        ),
        onPressed: () {
          if (_currentStep == 0) {
            setState(() {
              personalInfoEditable = true;
            });
          } else if (_currentStep == 1) {
            setState(() {
              FiFamilyEditable = true;
            });
          } else if (_currentStep == 2) {
            setState(() {
              FiIncomeEditable = true;
            });
          } else if (_currentStep == 3) {
            setState(() {
              FinancialInfoEditable = true;
            });
          } else if (_currentStep == 4) {
            setState(() {
              femMemIncomeEditable = true;
            });
          } else if (_currentStep == 5) {
            DeleteGur(context);
          } else if (_currentStep == 6) {
            setState(() {
              UploadFiDocsEditable = true;
            });
          } else if (_currentStep == 7) {
            setState(() {
              UploadFiDocsEditable = true;
            });
          }
        },
        child: Text(
          "EDIT",
          style: TextStyle(
              fontFamily: "Poppins-Regular", color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFA60A19),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: 13),
        ),
        onPressed: () {
          // setState(() {
          //   _currentStep = 6;
          //   pageTitle = "Upload Docs";
          // });

          if (_currentStep == 0) {
            if (personalInfoEditable) {
              if (_stepOneValidations()) {
                AddFiExtraDetail(context);
              }
            } else {
              setState(() {
                _currentStep++;
                pageTitle = "Family Details";
              });
            }
          } else if (_currentStep == 1) {
            if (FiFamilyEditable) {
              if (_stepTwoValidations()) {
                AddFiFamilyDetail(context);
              }
            } else {
              setState(() {
                _currentStep++;
                pageTitle = "Income & Expense";
              });
            }
          } else if (_currentStep == 2) {
            if (FiIncomeEditable) {
              if (_stepThreeValidations()) {
                AddFiIncomeAndExpense(context);
              }
            } else {
              setState(() {
                _currentStep++;
                pageTitle = "Financial Info.";
              });
            }
          } else if (_currentStep == 3) {

            if (FinancialInfoEditable) {
              if (_stepFourValidations()) {
                AddFinancialInfo(context);
              }
            } else {
              setState(() {
                _currentStep++;
                pageTitle = "Family Income";
              });
            }
          } else if (_currentStep == 4) {
            if (femMemIncomeEditable) {
              if (_stepFiveValidations()) {
                FiFemMemIncome(context);
              }
            } else {
              setState(() {
                _currentStep++;
                pageTitle = "Guarantor Form";
              });
            }
          } else if (_currentStep == 5) {
            if (GuarantorEditable) {
              if (_stepSixValidations()) {
                saveGuarantorMethod(context);
              }
            } else {
              setState(() {
                _currentStep++;
                pageTitle = "Upload Docs";
                editButtonFunctionOn = false;
              });
            }
          } else if (_currentStep == 6) {
            if (!borrowerDocsUploded) {
              FiDocsUploadsApi(context, "0");
            } else {
              setState(() {
                _currentStep++;
                pageTitle = "Upload Gr Docs";
                editButtonFunctionOn = false;
              });
            }
          } else if (_currentStep == 7) {
            FiDocsUploadsApi(context, "1");
          }
        },
        child: Text(
          _currentStep == 7 ? "SUBMIT" : "NEXT",
          style: TextStyle(
              fontFamily: "Poppins-Regular", color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      bool saved, FocusNode FN, String regex) {
    return Container(
      //margin: EdgeInsets.symmetric(vertical: 4),
      // padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: "Poppins-Regular",
              fontSize: 13,
            ),
          ),
          SizedBox(height: 1),
          Container(
              width: double.infinity,
              color: Colors.white, // Set the desired width
              //  //height: 45, // Set the desired height
              child: Center(
                child: TextFormField(
                  enabled: saved,
                  controller: controller,
                  focusNode: FN,
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
                    FilteringTextInputFormatter.allow(RegExp(regex)),
                    // Allow only alphanumeric characters // Optional: to deny spaces
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

  Widget _buildTextField2(
      String label,
      TextEditingController controller,
      TextInputType inputType,
      bool saved,
      FocusNode FN,
      int maxlength,
      String regex) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 0),
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
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
                enabled: saved,
                controller: controller,
                focusNode: FN,
                keyboardType: inputType,
                maxLength: maxlength,
                // Set the maximum length
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  counterText:
                      '', // Optional: hides the counter below the field
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter $label';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(regex)),
                  // Allow only alphanumeric characters // Optional: to deny spaces
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

  Widget _buildListItem({
    required String title,
    String? path,
    int? id,
    String? GrNo,
    required String subType,
    required Function(File) onImagePicked,
  }) {
    String baseUrl = 'https://predeptest.paisalo.in:8084';
    String? modifiedPath = path?.replaceAll(r'D:\', '').replaceAll(r'\\', '/');
    String finalUrl = '$baseUrl/$modifiedPath';

    File? _selectedImage;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return GestureDetector(
          onTap: () async {
            pickedImage = await GlobalClass().pickImage();
            print("pickedImage $pickedImage");

            bool OSVVerified = false;
            if (pickedImage != null) {
              print("_selectedImage $_selectedImage");
              switch (id) {
                case 1:
                  OSVVerified = await OcrDocsScanning("aadharfront",
                      BorrowerInfo[0].aadharNo, "borrower", context);
                  if (OSVVerified) {
                    adhaarFront = pickedImage;
                  }
                  break;
                case 27:
                  OSVVerified = await OcrDocsScanning('aadharback',
                      BorrowerInfo[0].aadharNo, "borrower", context);
                  if (OSVVerified) {
                    adhaarBack = pickedImage;
                  }
                  break;
                case 3:
                  OSVVerified = await OcrDocsScanning('voterfront',
                      BorrowerInfo[0].voterId, "borrower", context);
                  if (OSVVerified) {
                    voterFront = pickedImage;
                  }
                  break;
                case 26:
                  OSVVerified = await OcrDocsScanning('voterback',
                      "1", "borrower", context);
                  if (OSVVerified) {
                    voterback = pickedImage;
                  }
                  break;
                case 4:
                  OSVVerified = await OcrDocsScanning(
                      'pan', BorrowerInfo[0].panNo, "borrower", context);
                  if (OSVVerified) {
                    panFront = pickedImage;
                  }
                  break;
                case 15:
                  OSVVerified = await OcrDocsScanning(
                      'DL', BorrowerInfo[0].dl, "borrower", context);
                  if (OSVVerified) {
                    dlFront = pickedImage;
                  }
                  break;
                case 2:
                  OSVVerified = await OcrDocsScanning(
                      'passbook', "1", "borrower", context);
                  if (OSVVerified) {
                    passbook = pickedImage;
                  }
                  break;
                case 30:
                  passport = pickedImage;

                  break;
                case 7:
                  OSVVerified = await OcrDocsScanning(
                      'aadharfront',
                      BorrowerInfo[0].guarantors[0].grAadharId,
                      "guarantor",
                      context);
                  if (OSVVerified) {
                    adhaarFront_coborrower = pickedImage;
                  }
                  break;
                case 29:
                  OSVVerified = await OcrDocsScanning(
                      'aadharback',
                      BorrowerInfo[0].guarantors[0].grAadharId,
                      "guarantor",
                      context);
                  if (OSVVerified) {
                    adhaarBack_coborrower = pickedImage;
                  }
                  break;
                case 5:
                  OSVVerified = await OcrDocsScanning(
                      'voterfront',
                      BorrowerInfo[0].guarantors[0].grVoter,
                      "guarantor",
                      context);
                  if (OSVVerified) {
                    voterFront_coborrower = pickedImage;
                  }
                  break;
                case 28:
                  OSVVerified = await OcrDocsScanning(
                      'voterback',
                      BorrowerInfo[0].guarantors[0].grVoter,
                      "guarantor",
                      context);
                  if (OSVVerified) {
                    voterback_coborrower = pickedImage;
                  }
                  break;
                case 8:
                  OSVVerified = await OcrDocsScanning(
                      'pan',
                      BorrowerInfo[0].guarantors[0].grPan,
                      "guarantor",
                      context);
                  if (OSVVerified) {
                    panFront_coborrower = pickedImage;
                  }
                  break;
                case 16:
                  OSVVerified = await OcrDocsScanning('DL',
                      BorrowerInfo[0].guarantors[0].grDl, "guarantor", context);
                  if (OSVVerified) {
                    dlFront_coborrower = pickedImage;
                  }
                  break;
              }
              print("OSVVerified $OSVVerified");

              setState(() {
                if (OSVVerified) {
                  _selectedImage = pickedImage;
                } else {
                  if (subType == 'borrower') {
                    if (borrowerDocsUploded) {
                      FiDocsUploadsApi(context, "0");
                    }
                  } else if (subType == 'guarantor') {
                    if (borrowerDocsUploded) {
                      FiDocsUploadsApi(context, "1");
                    }
                  }
                }
              });
            }
          },
          child: Card(
            color:
                path!.isNotEmpty ? Colors.green : Colors.yellowAccent.shade700,
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            child: Container(
              height: 70,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: "Poppins-Regular",
                        color: path.isNotEmpty ? Colors.white : Colors.black,
                      ),
                    ),
                    _selectedImage != null
                        ? Image.file(
                            _selectedImage!,
                            width: 50,
                            height: 50,
                          )
                        : path != null
                            ? Image.network(
                                finalUrl,
                                width: 50,
                                height: 50,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.hide_image_outlined,
                                      size: 30);
                                },
                              )
                            : Image.asset(
                                'assets/Images/rupees.png',
                                width: 50,
                                height: 50,
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

  List<Widget> _buildKycDocumentList({required bool isStepSeven}) {
    List<Widget> listItems = [];
    if (_isPageLoading) {
      if (isStepSeven) {
        KycScanningDataModel doc = getData.data;

        listItems.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Borrower Docs",
              style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
            ),
          ),
        );

        if (doc.addharExists == true) {
          listItems.add(_buildListItem(
            title: "Aadhar Front",
            path: doc.aadharPath,
            id: 1,
            GrNo: "0",
            onImagePicked: (File file) {
              setState(() {
                adhaarFront = file;
              });
            },
            subType: 'borrower',
          ));
          listItems.add(_buildListItem(
            title: "Aadhar Back",
            path: doc.aadharBPath,
            id: 27,
            GrNo: '0',
            onImagePicked: (File file) {
              setState(() {
                adhaarBack = file;
              });
            },
            subType: 'borrower',
          ));
        }

        if (doc.voterExists == true) {
          listItems.add(_buildListItem(
            title: "Voter Front",
            path: doc.voterPath,
            id: 3,
            GrNo: '0',
            onImagePicked: (File file) {
              setState(() {
                voterFront = file;
              });
            },
            subType: 'borrower',
          ));
          listItems.add(_buildListItem(
            title: "Voter Back",
            path: doc.voterBPath,
            id: 26,
            GrNo: '0',
            onImagePicked: (File file) {
              setState(() {
                voterFront = file;
              });
            },
            subType: 'borrower',
          ));
        }

        if (doc.panExists == true) {
          listItems.add(_buildListItem(
            title: "Pan Front",
            path: doc.panPath,
            id: 4,
            GrNo: '0',
            onImagePicked: (File file) {
              setState(() {
                panFront = file;
              });
            },
            subType: 'borrower',
          ));
        }

        if (doc.drivingExists == true) {
          listItems.add(_buildListItem(
            title: "DL Front",
            path: doc.drivingPath,
            id: 15,
            GrNo: '0',
            onImagePicked: (File file) {
              setState(() {
                dlFront = file;
              });
            },
            subType: 'borrower',
          ));
        }

        if (doc.passportExists == true) {
          listItems.add(_buildListItem(
            title: "Passport",
            path: doc.passportPath,
            id: 30,
            GrNo: '0',
            onImagePicked: (File file) {
              setState(() {
                passport = file;
              });
            },
            subType: 'borrower',
          ));
        }

        listItems.add(_buildListItem(
          title: "Passbook Front",
          path: doc.passBookPath,
          id: 2,
          GrNo: '0',
          onImagePicked: (File file) {
            setState(() {
              passbook = file;
            });
          },
          subType: 'borrower',
        ));
      }
    }
    return listItems;
  }

  List<Widget> _buildKycDocumentListGur({required bool isStepEight}) {
    List<Widget> listItems1 = [];
    if (_isPageLoading) {
      if (isStepEight) {
        if(getData.data.grDocs.isNotEmpty) {
          GrDoc grDoc = getData.data.grDocs[0];

          listItems1.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Co Borrower Docs",
                style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
              ),
            ),
          );

          if (grDoc.addharExists == true) {
            listItems1.add(_buildListItem(
              title: "Aadhar Front",
              path: grDoc.aadharPath,
              id: 7,
              GrNo: '1',
              onImagePicked: (File file) {
                setState(() {
                  adhaarFront_coborrower = file;
                });
              },
              subType: 'guarantor',
            ));
            listItems1.add(_buildListItem(
              title: "Aadhar Back",
              path: grDoc.aadharBPath,
              id: 29,
              GrNo: '1',
              onImagePicked: (File file) {
                setState(() {
                  adhaarBack_coborrower = file;
                });
              },
              subType: 'guarantor',
            ));
          }

          if (grDoc.voterExists == true) {
            listItems1.add(_buildListItem(
              title: "Voter Front",
              path: grDoc.voterPath,
              id: 5,
              GrNo: '1',
              onImagePicked: (File file) {
                setState(() {
                  voterFront_coborrower = file;
                });
              },
              subType: 'guarantor',
            ));
            listItems1.add(_buildListItem(
              title: "Voter Back",
              path: grDoc.voterBPath,
              id: 28,
              GrNo: '1',
              onImagePicked: (File file) {
                setState(() {
                  voterFront_coborrower = file;
                });
              },
              subType: 'guarantor',
            ));
          }

          if (grDoc.panExists == true) {
            listItems1.add(_buildListItem(
              title: "Pan Front",
              path: grDoc.panPath,
              id: 8,
              GrNo: '1',
              onImagePicked: (File file) {
                setState(() {
                  panFront_coborrower = file;
                });
              },
              subType: 'guarantor',
            ));
          }

          if (grDoc.drivingExists == true) {
            listItems1.add(_buildListItem(
              title: "DL Front",
              path: grDoc.drivingPath,
              id: 16,
              GrNo: '1',
              onImagePicked: (File file) {
                setState(() {
                  dlFront_coborrower = file;
                });
              },
              subType: 'guarantor',
            ));
          }
        }else{
          listItems1.add(
            Center(
              child: CircularProgressIndicator(
                color: Color(0xFFD42D3F),
              ),
            ),
          );
        }
      }
    } else {
      listItems1.add(
        Center(
          child: CircularProgressIndicator(
            color: Color(0xFFD42D3F),
          ),
        ),
      );
    }

    return listItems1;
  }

  Widget _buildLabeledDropdownField<T>(
      String labelText,
      String label,
      List<T> items,
      T? selectedValue,
      bool readOnly,
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
              width: double.infinity,
              // Ensure the dropdown takes the full width available
              child: DropdownButtonFormField<T>(
                isExpanded: true,
                // Ensure the dropdown expands to fit its content
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
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                    ), // Convert the value to string for display
                  );
                }).toList(),
                onChanged: readOnly ? onChanged : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, String type) async {
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
        if (type.contains("open")) {
          _bankOpeningDateController.text =
              DateFormat('yyyy-MM-dd').format(picked);
        } else {
          _dobController.text = DateFormat('dd-MM-yyyy').format(picked);
          _calculateAge();
        }
      });
    }
  }

  void _calculateAge() {
    print("DOBAGE$_selectedDate");
    if (_selectedDate != null) {
      print("DOBAGE$_selectedDate");

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

  bool DataValidate(BuildContext context, Map<String, dynamic> requestBody) {
    for (var entry in requestBody.entries) {
      var value = entry.value;
      if (value == null) {
        showAlertDialog(context, "Please fill in the ${entry.key} field.");
        return false;
      } else if (value is int && value == 0) {
        showAlertDialog(context, "Please fill in the ${entry.key} field.");
        return false;
      } else if (value is String) {
        if (value.isEmpty || value.toLowerCase() == 'select') {
          showAlertDialog(context, "Please fill in the ${entry.key} field.");
          return false;
        }
      }
    }
    return true;
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

  List<List<int>> separateData(
      List<int> source, int separatorByte, int vtcIndex) {
    int imageStartIndex = 0;

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
    }

    return test;
  }

  void _validateEmail() {
    print("object22");
    if (!_emailIdFocus.hasFocus) {
      setState(() {
        final email = emailIdController.text;
        if (email.isEmpty || !_isValidEmail(email)) {
          _emailError = 'Please enter a valid email address';
        } else {
          _emailError = null;
        }
      });
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return emailRegex.hasMatch(email);
  }

  void _validateMobile() {
    if (!_mobileFocusNode.hasFocus) {
      setState(() {
        final mobile = mobileController.text;
        if (mobile.isEmpty || !_isValidMobile(mobile)) {
          _mobileError = 'Please enter a valid mobile number';
        } else {
          _mobileError = null;
        }
      });
    }
  }

  bool _isValidMobile(String mobile) {
    final mobileRegex = RegExp(
      r"^[0-9]{10}$",
    );
    return mobileRegex.hasMatch(mobile);
  }

  void _validatePincode(String type) {
    if (type == "A") {
      if (!_pinFocusNodeP.hasFocus) {
        setState(() {
          final pin = pincodeControllerP.text;
          if (pin.isEmpty || !_isValidPin(pin)) {
            _pinErrorP = 'Please enter valid PIN';
          } else {
            _pinErrorP = null;
          }
        });
      }
    }
    if (type == "B") {
      if (!_pinFocusNodeC.hasFocus) {
        setState(() {
          final pin = pincodeControllerC.text;
          if (pin.isEmpty || !_isValidPin(pin)) {
            _pinErrorC = 'Please enter valid PIN';
          } else {
            _pinErrorC = null;
          }
        });
      }
    }
  }

  bool _isValidPin(String pin) {
    final pinRegex = RegExp(r'^[1-9][0-9]{5}$');
    return pinRegex.hasMatch(pin);
  }

  void _onCheckboxChanged(bool? newValue) {
    setState(() {
      _isAddressChecked = newValue ?? false;

      if (_isAddressChecked) {
        // Copy permanent address values to current address fields
        address1ControllerC.text = address1ControllerP.text;
        address2ControllerC.text = address2ControllerP.text;
        address3ControllerC.text = address3ControllerP.text;
        selectedStateextraC = selectedStateextraP;
        pincodeControllerC.text = pincodeControllerP.text;
        cityControllerC.text = cityControllerP.text;
      } else {
        // Clear current address fields
        address1ControllerC.clear();
        address2ControllerC.clear();
        address3ControllerC.clear();
        //selectedStateextraC.s();
        pincodeControllerC.clear();
        cityControllerC.clear();
      }
    });
  }

  void showToast_Error(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xFFD42D3F),
        textColor: Colors.white,
        fontSize: 13.0);
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

  void _showPopup(BuildContext context, Function(String) onResult) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(13.0),
            // Add padding around the content
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Adhaar Front Button
                SizedBox(
                  width: double.infinity, // Match the width of the dialog
                  child: TextButton(
                    onPressed: () {
                      getDataFromOCR("adharFront", context);
                    },
                    child: Text(
                      'Adhaar Front',
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
                      'Adhaar Back',
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
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QRViewExample()),
                      );

                      if (result != null) {
                        setQRData(result);
                      }
                      print("result $result");
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Adhaar QR',
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

  bool _stepOneValidations() {
    if (emailIdController.text.isEmpty) {
      showToast_Error("Please enter Email ID");
      _emailIdFocus.requestFocus();
      return false;
    } else if (placeOfBirthController.text.isEmpty) {
      showToast_Error("Please enter Place of Birth");
      _placeOfBirthFocus.requestFocus();
      return false;
    } else if (selectedDependent == null ||
        selectedDependent!.toLowerCase() == "select") {
      showToast_Error("Please select Dependents");
      return false;
    } else if (selectedReligionextra == null ||
        selectedReligionextra!.toLowerCase() == "select") {
      showToast_Error("Please select Religion");
      return false;
    } else if (selectedCast == null ||
        selectedCast!.toLowerCase() == "select") {
      showToast_Error("Please select cast");
      return false;
    }
    /*else if (resCatController.text.isEmpty) {
      showToast_Error("Please enter Reservation Category");
      _resCatFocus.requestFocus();
      return false;
    }*/
    else if (mobileController.text.isEmpty ||
        mobileController.text.length != 10 ||
        !mobileController.text.contains(RegExp(r'^[0-9]{10}$'))) {
      showToast_Error("Please enter correct Mobile Number");
      _mobileFocus.requestFocus();
      return false;
    } else if (selectedIsHandicap == null ||
        selectedIsHandicap!.toLowerCase() == "select") {
      showToast_Error("Please select Is Handicap");
      return false;
    } else if (selectedIsHandicap == "Yes" &&
        (selectedspecialAbility == null ||
            selectedspecialAbility!.toLowerCase() == "select")) {
      showToast_Error("Please select special ability");
      return false;
    } else if (selectedSpecialSocialCategory == null ||
        selectedSpecialSocialCategory!.toLowerCase() == "select") {
      showToast_Error("Please select Special Social Category");
      return false;
    } else if (address1ControllerP.text.isEmpty) {
      showToast_Error("Please enter Address Line 1 (Permanent)");
      _address1FocusP.requestFocus();
      return false;
    }
    /*else if (address2ControllerP.text.isEmpty) {
      showToast_Error("Please enter Address Line 2 (Permanent)");
      _address2FocusP.requestFocus();
      return false;
    } else if (address3ControllerP.text.isEmpty) {
      showToast_Error("Please enter Address Line 3 (Permanent)");
      _address3FocusP.requestFocus();
      return false;
    }*/
    else if (selectedStateextraP == null ||
        selectedStateextraP!.descriptionEn.isEmpty ||
        selectedStateextraP!.descriptionEn.toLowerCase() == 'select') {
      showToast_Error('Please select permanent state');
      return false;
    } else if (address1ControllerC.text.isEmpty) {
      showToast_Error("Please enter Address Line 1 (Current)");
      _address1FocusC.requestFocus();
      return false;
    }
    /*else if (address2ControllerC.text.isEmpty) {
      showToast_Error("Please enter Address Line 2 (Current)");
      _address2FocusC.requestFocus();
      return false;
    } else if (address3ControllerC.text.isEmpty) {
      showToast_Error("Please enter Address Line 3 (Current)");
      _address3FocusC.requestFocus();
      return false;
    }*/
    else if (selectedStateextraC == null ||
        selectedStateextraC!.descriptionEn.isEmpty ||
        selectedStateextraC!.descriptionEn.toLowerCase() == "select") {
      showToast_Error("Please select current state");
      return false;
    } else if (cityControllerP.text.isEmpty) {
      showToast_Error("Please enter City (Permanent)");
      _cityFocusP.requestFocus();
      return false;
    } else if (pincodeControllerP.text.isEmpty) {
      showToast_Error("Please enter Pincode (Permanent)");
      _pincodeFocusP.requestFocus();
      return false;
    } else if (cityControllerC.text.isEmpty) {
      showToast_Error("Please enter City (Current)");
      _cityFocusC.requestFocus();
      return false;
    } else if (pincodeControllerC.text.isEmpty) {
      showToast_Error("Please enter Pincode (Current)");
      _pincodeFocusC.requestFocus();
      return false;
    }
    /*else if (selectedDistrict == null) {
      showToast_Error("Please select District");

      return false;
    } else if (selectedSubDistrict == null) {
      showToast_Error("Please select Sub-District");

      return false;
    } else if (selectedVillage == null) {
      showToast_Error("Please select village");

      return false;
    }*/
    else if (selectedResidingFor == null) {
      showToast_Error("Please select years of residing");

      return false;
    } else if (selectedProperty == null) {
      showToast_Error("Please select property in acres");

      return false;
    } else if (selectedPresentHouseOwner == null) {
      showToast_Error("Please select house owner type");

      return false;
    }
    return true;
  }

  bool _stepTwoValidations() {
    if (_motherFController.text.isEmpty) {
      showToast_Error("Please enter Mother's First Name");
      _motherFFocus.requestFocus();
      return false;
    } else if (selectednumOfChildren == null ||
        selectednumOfChildren!.toLowerCase() == 'select') {
      showToast_Error("Please Select Number of Children");
      return false;
    } else if (selectedschoolingChildren == null ||
        selectedschoolingChildren!.isEmpty ||
        selectedschoolingChildren!.toLowerCase() == 'select') {
      showToast_Error("Please Select School Going Children");
      return false;
    } else if (selectedotherDependents == null ||
        selectedotherDependents!.isEmpty ||
        selectedotherDependents!.toLowerCase() == 'select') {
      showToast_Error("Please Select Other Dependents");
      return false;
    }
    return true;
  }

  bool _stepThreeValidations() {
    if (selectedOccupation == null ||
        selectedOccupation!.isEmpty ||
        selectedOccupation!.toLowerCase() == 'select') {
      showToast_Error("Please Select Occupation");
      return false;
    } else if (selectedBusiness == null ||
        selectedBusiness!.isEmpty ||
        selectedBusiness!.toLowerCase() == 'select') {
      showToast_Error("Please Select Business");
      return false;
    } else if (_currentEMIController.text.isEmpty) {
      showToast_Error("Please Enter Current EMIs Amount");
      return false;
    } else if (selectedHomeType == null ||
        selectedHomeType!.isEmpty ||
        selectedHomeType!.toLowerCase() == 'select') {
      showToast_Error("Please Select Home Type");
      return false;
    } else if (selectedRoofType == null ||
        selectedRoofType!.isEmpty ||
        selectedRoofType!.toLowerCase() == 'select') {
      showToast_Error("Please Select Roof Type");
      return false;
    } else if (selectedToiletType == null ||
        selectedToiletType!.isEmpty ||
        selectedToiletType!.toLowerCase() == 'select') {
      showToast_Error("Please Select Toilet Type");
      return false;
    } else if (selectedLivingWithSpouse == null ||
        selectedLivingWithSpouse!.isEmpty ||
        selectedLivingWithSpouse!.toLowerCase() == 'select') {
      showToast_Error("Please Select Living With Spouse");
      return false;
    } else if (selectedEarningMembers == null ||
        selectedEarningMembers!.isEmpty ||
        selectedEarningMembers!.toLowerCase() == 'select') {
      showToast_Error("Please Select Earning Members");
      return false;
    } else if (selectedBusinessExperience == null ||
        selectedBusinessExperience!.isEmpty ||
        selectedBusinessExperience!.toLowerCase() == 'select') {
      showToast_Error("Please Select Business Experience");
      return false;
    } else if (_future_IncomeController.text.isEmpty) {
      showToast_Error("Please Enter Future Income");
      return false;
    } else if (_agriculture_incomeController.text.isEmpty) {
      showToast_Error("Please Enter Agriculture Income");
      return false;
    } else if (_other_IncomeController.text.isEmpty) {
      showToast_Error("Please Enter Other Income");
      return false;
    } else if (_annuaL_INCOMEController.text.isEmpty) {
      showToast_Error("Please Enter Annual Income");
      return false;
    } else if (_otheR_THAN_AGRICULTURAL_INCOMEController.text.isEmpty) {
      showToast_Error("Please Enter Other Than Agricultural Income");
      return false;
    } else if (_pensionIncomeController.text.isEmpty) {
      showToast_Error("Please Enter Pension Income");
      return false;
    } else if (_any_RentalIncomeController.text.isEmpty) {
      showToast_Error("Please Enter Any Rental Income");
      return false;
    } else if (_rentController.text.isEmpty) {
      showToast_Error("Please Enter Rent");
      return false;
    } else if (_foodingController.text.isEmpty) {
      showToast_Error("Please Enter Fooding Expenses");
      return false;
    } else if (_educationController.text.isEmpty) {
      showToast_Error("Please Enter Education Expenses");
      return false;
    } else if (_healthController.text.isEmpty) {
      showToast_Error("Please Enter Health Expenses");
      return false;
    } else if (_travellingController.text.isEmpty) {
      showToast_Error("Please Enter Travelling Expenses");
      return false;
    } else if (_entertainmentController.text.isEmpty) {
      showToast_Error("Please Enter Entertainment Expenses");
      return false;
    } else if (_spendOnChildrenController.text.isEmpty) {
      showToast_Error("Please Enter Spending on Children");
      return false;
    } else if (_othersController.text.isEmpty) {
      showToast_Error("Please Enter Other Expenses");
      return false;
    }
    return true;
  }

  bool _stepFourValidations() {
    if (_bank_AcController.text.isEmpty) {
      showToast_Error("Please Enter Bank Account Number");
      _bank_AcFocus.requestFocus();
      return false;
    }
    /*else if (selectedBankName == null ||
        selectedBankName!.isEmpty ||
        selectedBankName!.toLowerCase() == 'select') {
      showToast_Error("Please Enter Bank Name");
      return false;
    }*/
    else if (_bank_IFCSController.text.isEmpty) {
      showToast_Error("Please Enter Bank IFSC Code");
      _bank_IFCSFocus.requestFocus();
      return false;
    } else if (_bankOpeningDateController.text.isEmpty) {
      showToast_Error("Please Enter Bank Opening Date");
      _bankOpeningDateFocus.requestFocus();
      return false;
    } else if (selectedAccountType == null ||
        selectedAccountType!.isEmpty ||
        selectedAccountType!.toLowerCase() == 'select') {
      showToast_Error("Please Select Account Type");
      return false;
    } else if (bankAddress == null || bankAddress!.isEmpty) {
      showToast_Error("Please check bank address not found with this IFSC");
      return false;
    } else if (bankAccHolder == null || bankAccHolder!.isEmpty) {
      showToast_Error("Account Holder name is not found");
      return false;
    }
    return true;
  }

  bool _stepFiveValidations() {
    if (_femNameController.text.isEmpty) {
      showToast_Error("Please Enter Family Member Name");
      return false;
    } else if (_AgeController.text.isEmpty) {
      showToast_Error("Please Enter Family Member Age");
      return false;
    } else if (_IncomeController.text.isEmpty) {
      showToast_Error("Please Enter Family Member Income");
      return false;
    } else if (femselectedGender == null ||
        femselectedGender!.isEmpty ||
        femselectedGender!.toLowerCase() == 'select') {
      showToast_Error("Please Select Gender");
      return false;
    } else if (femselectedRelationWithBorrower == null ||
        femselectedRelationWithBorrower!.isEmpty ||
        femselectedRelationWithBorrower!.toLowerCase() == 'select') {
      showToast_Error("Please Select Relation with Borrower");
      return false;
    } else if (femselectedHealth == null ||
        femselectedHealth!.isEmpty ||
        femselectedHealth!.toLowerCase() == 'select') {
      showToast_Error("Please Select Health Status");
      return false;
    } else if (femselectedEducation == null ||
        femselectedEducation!.isEmpty ||
        femselectedEducation!.toLowerCase() == 'select') {
      showToast_Error("Please Select Education Level");
      return false;
    } else if (femselectedSchoolType == null ||
        femselectedSchoolType!.isEmpty ||
        femselectedSchoolType!.toLowerCase() == 'select') {
      showToast_Error("Please Select School Type");
      return false;
    } else if (femselectedBusiness == null ||
        femselectedBusiness!.isEmpty ||
        femselectedBusiness!.toLowerCase() == 'select') {
      showToast_Error("Please Select Business");
      return false;
    } else if (femselectedBusinessType == null ||
        femselectedBusinessType!.isEmpty ||
        femselectedBusinessType!.toLowerCase() == 'select') {
      showToast_Error("Please Select Business Type");
      return false;
    } else if (femselectedIncomeType == null ||
        femselectedIncomeType!.isEmpty ||
        femselectedIncomeType!.toLowerCase() == 'select') {
      showToast_Error("Please Select Income Type");
      return false;
    } else if (_femNameController.text.isEmpty) {
      showToast_Error("Please Enter Name");
      _femNameFocus.requestFocus();
      return false;
    } else if (_AgeController.text.isEmpty) {
      showToast_Error("Please Enter Age");
      _AgeFocus.requestFocus();
      return false;
    } else if (_IncomeController.text.isEmpty) {
      showToast_Error("Please Enter Income");
      _IncomeFocus.requestFocus();
      return false;
    }
    return true;
  }

  bool _stepSixValidations() {
    if (_aadharIdController.text.isEmpty) {
      showToast_Error("Please Enter Aadhar ID");
      _aadharIdFocus.requestFocus();
      return false;
    } else if (selectedTitle == null ||
        selectedTitle!.isEmpty ||
        selectedTitle!.toLowerCase() == 'select') {
      showToast_Error("Please Select Title");
      return false;
    } else if (_fnameController.text.isEmpty) {
      showToast_Error("Please Enter First Name");
      _fnameFocus.requestFocus();
      return false;
    } else if (_guardianController.text.isEmpty) {
      showToast_Error("Please Enter Guardian Name");
      _guardianFocus.requestFocus();
      return false;
    }
    /* else if (_lnameController.text.isEmpty) {
      showToast_Error("Please Enter Last Name");
      _lnameFocus.requestFocus();
      return false;
    }*/
    else if (_phoneController.text.isEmpty ||
        _phoneController.text.length != 10 ||
        !_phoneController.text.contains(RegExp(r'^[0-9]{10}$'))) {
      showToast_Error("Please Enter Phone Number");
      _phoneFocus.requestFocus();
      return false;
    } else if (_dobController.text.isEmpty) {
      showToast_Error("Please Enter Date of Birth");
      _dobFocus.requestFocus();
      return false;
    } else if (_ageController.text.isEmpty) {
      showToast_Error("Please Enter Age");
      _ageFocus.requestFocus();
      return false;
    }
    // if (_voterController.text.isEmpty) {
    //   if (_panController.text.isEmpty) {
    //     showToast_Error("Please Enter PAN");
    //     _panFocus.requestFocus();
    //     return false;
    //   } else if (_dlController.text.isEmpty) {
    //     showToast_Error("Please Enter Driving License");
    //     _dlFocus.requestFocus();
    //     return false;
    //   }
    //   return false;
    // }
    else if (_p_Address1Controller.text.isEmpty) {
      showToast_Error("Please Enter Address Line 1");
      _p_Address1Focus.requestFocus();
      return false;
    } else if (_panController.text.isNotEmpty && !panVerified) {
      showToast_Error("Please Verify PAN No.");
      _panFocus.requestFocus();
      return false;
    } else if (_dlController.text.isNotEmpty && !dlVerified) {
      showToast_Error("Please Verify Driving License");
      _dlFocus.requestFocus();
      return false;
    } else if (_voterController.text.isNotEmpty && !voterVerified) {
      showToast_Error("Please Verify Voter No.");
      _panFocus.requestFocus();
      return false;
    }
    /*else if (_p_Address2Controller.text.isEmpty) {
      showToast_Error("Please Enter Address Line 2");
      _p_Address2Focus.requestFocus();
      return false;
    } else if (_p_Address3Controller.text.isEmpty) {
      showToast_Error("Please Enter Address Line 3");
      _p_Address3Focus.requestFocus();
      return false;
    }*/
    else if (_p_CityController.text.isEmpty) {
      showToast_Error("Please Enter Permanent City");
      _p_CityFocus.requestFocus();
      return false;
    } else if (_pincodeController.text.isEmpty ||
        _pincodeController.text.length != 6) {
      showToast_Error("Please Enter Correct Pincode");
      _pincodeFocus.requestFocus();
      return false;
    } else if (stateselected == null ||
        stateselected!.descriptionEn.toLowerCase() == 'select') {
      showToast_Error("Please Select State");
      return false;
    } else if (relationselected == null ||
        relationselected!.isEmpty ||
        relationselected!.toLowerCase() == 'select') {
      showToast_Error("Please Select Relation");
      return false;
    } else if (genderselected == null ||
        genderselected!.isEmpty ||
        genderselected!.toLowerCase() == 'select') {
      showToast_Error("Please Select Gender");
      return false;
    } else if (religionselected == null ||
        religionselected!.isEmpty ||
        religionselected!.toLowerCase() == 'select') {
      showToast_Error("Please Select Religion");
      return false;
    } else if (_imageFile == null) {
      showToast_Error("Please click Guarantor picture");
      return false;
    }
    return true;
  }

  Future<void> AddFiExtraDetail(BuildContext context) async {
    EasyLoading.show(
      status: 'Loading...',
    );

    int A = selectedIsHandicap == 'Yes' ? 1 : 0;
    print("objectrent $selectedIsHouseRental");
    int B = selectedIsHouseRental == 'Yes' ? 1 : 0;

    final api = Provider.of<ApiService>(context, listen: false);
    Map<String, dynamic> requestBody = {
      "fi_Id": FIID,
      "email_Id": emailIdController.text,
      "place_Of_Birth": placeOfBirthController.text,
      "depedent_Person": selectedDependent,
      "reservatioN_CATEGORY": "",
      "religion": selectedReligionextra ?? "",
      "Cast": selectedCast,
      "current_Phone": mobileController.text,
      "isHandicap": A,
      "handicap_type": selectedspecialAbility,
      "is_house_rental": B.toString(),
      "property_area": selectedProperty,
      "O_Address1": address1ControllerP.text,
      "O_Address2": address2ControllerP.text,
      "O_Address3": address3ControllerP.text,
      "O_City": cityControllerP.text,
      "O_State": selectedStateextraP!.descriptionEn,
      "O_Pincode": pincodeControllerP.text,
      "current_Address1": address1ControllerC.text,
      "current_Address2": address2ControllerC.text,
      "current_Address3": address3ControllerC.text,
      "current_City": cityControllerP.text,
      "current_State": selectedStateextraC!.descriptionEn,
      "current_Pincode": pincodeControllerP.text,
      "district": "",
      "sub_District": "",
      "village": "",
      "Resident_for_years": selectedResidingFor,
      "Present_House_Owner": selectedPresentHouseOwner
    };

    await api
        .updatePersonalDetails(
            GlobalClass.dbName, GlobalClass.token, requestBody)
        .then((value) async {
      if (value.statuscode == 200) {
        setState(() {
          _currentStep += 1;
          pageTitle = "Family Details";
          personalInfoEditable = false;
        });
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();

        // Handle failure
        GlobalClass.showUnsuccessfulAlert(
            context, "Failed to update details. Please try again.", 1);
      }
    }).catchError((error) {
      EasyLoading.dismiss();
      GlobalClass.showErrorAlert(context, error.toString(), 1);
    });
  }

  Future<void> AddFiFamilyDetail(BuildContext context) async {
    EasyLoading.show(
      status: 'Loading...',
    );

    String Fi_ID = FIID.toString();
    String motheR_FIRST_NAME = _motherFController.text.toString();
    String motheR_MIDDLE_NAME = _motherMController.text.toString();
    String motheR_LAST_NAME = _motherLController.text.toString();
    String motheR_MAIDEN_NAME = "";
    String noOfChildren = selectednumOfChildren!;
    String schoolingChildren = selectedschoolingChildren!;
    String otherDependents = selectedotherDependents!;

    final api = Provider.of<ApiService>(context, listen: false);

    Map<String, dynamic> requestBody = {
      "Fi_ID": Fi_ID,
      "motheR_FIRST_NAME": motheR_FIRST_NAME,
      "motheR_MIDDLE_NAME": motheR_MIDDLE_NAME,
      "motheR_LAST_NAME": motheR_LAST_NAME,
      "motheR_MAIDEN_NAME": motheR_MAIDEN_NAME,
      "noOfChildren": noOfChildren,
      "schoolingChildren": schoolingChildren,
      "otherDependents": otherDependents
    };

    return await api.FiFamilyDetail(
            GlobalClass.token, GlobalClass.dbName, requestBody)
        .then((value) async {
      if (value.statuscode == 200) {
        setState(() {
          _currentStep += 1;
          pageTitle = "Income & Expense";
          FiFamilyEditable = false;
        });
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
      }
    }).catchError((error) {});
  }


  Future<void> saveIDsMethod(BuildContext context) async {
    EasyLoading.show(
      status: 'Loading...',
    );

    print("object");
    int isNameVerify = 1;
    final _passportExpiryController = TextEditingController();
    final _dlExpiryController = TextEditingController();
    String? PassportExpireDate =
    _passportExpiryController.text.toString().isEmpty
        ? null
        : _passportExpiryController.text;
    String? DLExpireDate = _dlExpiryController.text.toString().isEmpty
        ? null
        : DateFormat('yyyy-MM-dd').format(
        DateFormat('dd-MM-yyyy').parse(_dlExpiryController.text));
    String fiid= FIID.toString();
    print("fiidrps $FIID.toString()");
    final api = Provider.of<ApiService>(context, listen: false);

    Map<String, dynamic> requestBody = {
      "Fi_ID": fiid,
      "pan_no": "",
      "dl": "",
      "voter_id": "",
      "passport": "",
      "PassportExpireDate": PassportExpireDate,
      "isAadharVerified": 0,
      "is_phnno_verified": 0,
      "isNameVerify": isNameVerify,
      "Pan_Name": "",
      "VoterId_Name": "",
      "Aadhar_Name": "",
      "DrivingLic_Name": "",
      "VILLAGE_CODE": "",
      "CITY_CODE": "",
      "SUB_DIST_CODE": "",
      "DIST_CODE": "",
      "STATE_CODE":"",
      "DLExpireDate": DLExpireDate,
      "BankAcc_Name": bankAccHolder,
    };

    return await api
        .addFiIds(GlobalClass.token, GlobalClass.dbName, requestBody)
        .then((value) async {
      if (value.statuscode == 200) {
        /*setState(() {
          _currentStep += 1;
        });*/
        EasyLoading.dismiss();

      } else {
        EasyLoading.dismiss();
        GlobalClass.showUnsuccessfulAlert(context, value.message, 1);
      }
    }).catchError((onError){
      EasyLoading.dismiss();
      GlobalClass.showErrorAlert(context, onError, 1);
    });
  }

  Future<void> AddFinancialInfo(BuildContext context) async {
    EasyLoading.show(
      status: 'Loading...',
    );

    String Fi_ID = FIID.toString();
    String bankType = selectedAccountType.toString();
    //  String bank_name = selectedBankName.toString();
    String bank_Ac = _bank_AcController.text.toString();
    String bank_IFCS = _bank_IFCSController.text.toString();
    String bank_address = bankAddress!;
    String bankOpeningDate = _bankOpeningDateController.text.toString();

    final api = Provider.of<ApiService>(context, listen: false);

    Map<String, dynamic> requestBody = {
      "Fi_ID": Fi_ID,
      "bankType": bankType,
      "bank_Ac": bank_Ac,
        //    "bank_name": bank_name,
      "bank_IFCS": bank_IFCS,
      "bank_address": bank_address,
      "bankOpeningDate": bankOpeningDate,
    };

    if (DataValidate(context, requestBody)) {
      await api.AddFinancialInfo(
              GlobalClass.token, GlobalClass.dbName, requestBody)
          .then((value) async {
        if (value.statuscode == 200) {
          setState(() {
            _currentStep += 1;
            pageTitle = "Family Income";
            FinancialInfoEditable = false;
          });
          EasyLoading.dismiss();
        } else {
          showToast_Error(value.data[0].errormsg);
          EasyLoading.dismiss();
        }
      }).catchError((error) {
        showToast_Error(error);
        EasyLoading.dismiss();
      });
    }
  }

  Future<void> FiFemMemIncome(BuildContext context) async {
    EasyLoading.show(
      status: 'Loading...',
    );

    String Fi_ID = FIID.toString();
    String Age = _AgeController.text;
    String Name = _femNameController.text;
    String Gender = femselectedGender.toString();
    String RelationWithBorrower = femselectedRelationWithBorrower.toString();
    String Health = femselectedHealth.toString();
    String Education = femselectedEducation.toString();
    String SchoolType = femselectedSchoolType.toString();
    String Business = femselectedBusiness.toString();
    String Income = _IncomeController.text;
    String BusinessType = femselectedBusinessType.toString();
    String IncomeType = femselectedIncomeType.toString();

    final api = Provider.of<ApiService>(context, listen: false);

    Map<String, dynamic> requestBody = {
      "Fi_ID": Fi_ID,
      "Name": Name,
      "Age": Age,
      "Gender": Gender,
      "RelationWithBorrower": RelationWithBorrower,
      "Health": Health,
      "Education": Education,
      "SchoolType": SchoolType,
      "Business": Business,
      "Income": Income,
      "BusinessType": BusinessType,
      "IncomeType": IncomeType
    };

    return await api.FIFamilyIncome(
            GlobalClass.token, GlobalClass.dbName, requestBody)
        .then((value) async {
      if (value.statuscode == 200) {
        setState(() {
          _currentStep += 1;
          pageTitle = "Guarantor Form";
          femMemIncomeEditable = false;
        });
        EasyLoading.dismiss();
      } else {
        showToast_Error(value.data[0].errormsg);
        EasyLoading.dismiss();
      }
    }).catchError((error) {
      showToast_Error(error);
      EasyLoading.dismiss();
    });
  }

  Future<void> AddFiIncomeAndExpense(BuildContext context) async {
    EasyLoading.show(
      status: 'Loading...',
    );

    String fi_ID = FIID.toString();
    String occupation = selectedOccupation.toString();
    String business_Detail = selectedBusiness.toString();
    String any_current_EMI = _currentEMIController.text;
    String homeType = selectedHomeType.toString();
    String homeRoofType = selectedRoofType.toString();
    String toiletType = selectedToiletType.toString();
    bool livingSpouse =
        selectedLivingWithSpouse.toString().toLowerCase() == "true"
            ? true
            : false;
    int earning_mem_count = int.parse(selectedEarningMembers.toString());
    int years_in_business = int.parse(selectedBusinessExperience.toString());
    int future_Income = int.parse(_future_IncomeController.text.toString());
    int agriculture_income =
        int.parse(_agriculture_incomeController.text.toString());
    int other_Income = int.parse(_other_IncomeController.text.toString());
    int annuaL_INCOME = int.parse(_annuaL_INCOMEController.text.toString());
    int spendOnChildren = int.parse(_spendOnChildrenController.text.toString());
    int otheR_THAN_AGRICULTURAL_INCOME =
        int.parse(_otheR_THAN_AGRICULTURAL_INCOMEController.text.toString());
    int pensionIncome = int.parse(_pensionIncomeController.text.toString());
    int any_RentalIncome =
        int.parse(_any_RentalIncomeController.text.toString());
    int rent = int.parse(_rentController.text.toString());
    int fooding = int.parse(_foodingController.text.toString());
    int education = int.parse(_educationController.text.toString());
    int health = int.parse(_healthController.text.toString());
    int travelling = int.parse(_travellingController.text.toString());
    int entertainment = int.parse(_entertainmentController.text.toString());
    int others = int.parse(_othersController.text.toString());
    String docs_path = "";

    final api = Provider.of<ApiService>(context, listen: false);

    Map<String, dynamic> requestBody = {
      "fi_ID": fi_ID,
      "occupation": occupation,
      "business_Detail": business_Detail,
      "any_current_EMI": any_current_EMI,
      "future_Income": future_Income,
      "agriculture_income": agriculture_income,
      "earning_mem_count": earning_mem_count,
      "other_Income": other_Income,
      "annuaL_INCOME": annuaL_INCOME,
      "spendOnChildren": spendOnChildren,
      "otheR_THAN_AGRICULTURAL_INCOME": otheR_THAN_AGRICULTURAL_INCOME,
      "years_in_business": years_in_business,
      "pensionIncome": pensionIncome,
      "any_RentalIncome": any_RentalIncome,
      "rent": rent,
      "fooding": fooding,
      "education": education,
      "health": health,
      "travelling": travelling,
      "entertainment": entertainment,
      "others": others,
      "homeType": homeType,
      "homeRoofType": homeRoofType,
      "toiletType": toiletType,
      "livingwithSpouse": livingSpouse,
      "docs_path": docs_path
    };

    return await api.AddFiIncomeAndExpense(
            GlobalClass.token, GlobalClass.dbName, requestBody)
        .then((value) async {
      if (value.statuscode == 200) {
        setState(() {
          _currentStep += 1;
          pageTitle = "Financial Info.";
          FiIncomeEditable = false;
          verifyFlag = false;
        });
        EasyLoading.dismiss();
      } else {
        showToast_Error(value.data[0].errormsg);
        EasyLoading.dismiss();
      }
    }).catchError((error) {
      showToast_Error(error);
      EasyLoading.dismiss();
    });
  }

  Future<void> GetDocs(BuildContext context) async {
    EasyLoading.show(
      status: 'Loading...',
    );

    final api = Provider.of<ApiService>(context, listen: false);

    return await api.KycScanning(
            GlobalClass.token, GlobalClass.dbName, FIID.toString())
        .then((value) async {
      if (value.statuscode == 200) {
        setState(() {
          getData = value;
          _isPageLoading = true;
          EasyLoading.dismiss();
        });
        EasyLoading.dismiss();
        if (value.data.aadharPath.isNotEmpty) {
          setState(() {
            borrowerDocsUploded = true;
          });
        }
      } else {
        EasyLoading.dismiss();
      }
    });
  }

  Future<void> FiDocsUploadsApi(BuildContext context, String GurNum) async {
    if (validateAllDocsForBorrower(context, GurNum)) {
      saveKYCAllDocs(context, GurNum);
    }
  }

/*Future<void> UploadFiDocs(BuildContext context, String? tittle, File? file,
      String? grNo, int? checklistid) async {
    EasyLoading.show(
      status: 'Loading...',
    );

    if (file == null) {
      GlobalClass.showUnsuccessfulAlert(context, "Please upload $tittle", 1);
    } else {
      final api = Provider.of<ApiService>(context, listen: false);
//https://predeptest.paisalo.in:8084/LOSDOC//FiDocs//38//FiDocuments//VoterIDBorrower0711_2024_43_01.png


   String baseUrl = 'https://predeptest.paisalo.in:8084';

    // Replace the front part of the file path and ensure the path uses forward slashes
    String? modifiedPath = path?.replaceAll(r'D:\', '').replaceAll(r'\\', '/');

    // Join the base URL with the modified path
    String finalUrl = '$baseUrl/$modifiedPath';
    File file = File(finalUrl);

      return await api
          .uploadFiDocs(GlobalClass.token, GlobalClass.dbName, FIID.toString(),
              int.parse(grNo!), checklistid!, tittle.toString(), file!)
          .then((value) async {
        if (value.statuscode == 200) {
          GetDocs(context);

  setState(() {
          _currentStep += 1;
          Fi_Id = value.data[0].fiId.toString();
        });
          EasyLoading.dismiss();
        } else {
          EasyLoading.dismiss();
        }
      });
    }
   // EasyLoading.dismiss();
  }*/
  Future<void> verifyDocs(BuildContext context, String txnNumber, String type, String ifsc, String dob) async {
    EasyLoading.show(
      status: 'Loading...',
    );
    try {
      Map<String, dynamic> requestBody = {
        "type": type,
        "txtnumber": txnNumber,
        "ifsc": ifsc,
        //"userdob": dob,
        "userdob": "2000-10-02",
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
            if (response["error"] == null) {
              panCardHolderName =
                  "${responseData['name']} ";
              panVerified = true;
            } else {
              panCardHolderName = "PAN no. is wrong please check";
              panVerified = false;
            }
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
        }else if (type == "bankaccount") {
          setState(() {
            bankAccHolder = "${responseData['full_name']}";
            banknameverified = true;
            saveIDsMethod(context);
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
        } else if (type == "bankaccount") {
          setState(() {
            bankAccHolder = "Bank Account is not verified";
            banknameverified = false;
            saveIDsMethod(context);
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
      }else if (type == "bankaccount") {
        setState(() {
          bankAccHolder = "Bank Account is not verified";
          banknameverified = false;
          saveIDsMethod(context);
        });
      }
      EasyLoading.dismiss();
    }
  }

  void docVerifyIDC(String type, String txnNumber, String ifsc, String dob) async {
    apiService_idc = ApiService.create(baseUrl: ApiConfig.baseUrl4);
    setState(() {
      bankAccHolder = null;
    });

    EasyLoading.show(
      status: 'Loading...',
    );

    Map<String, dynamic> requestBody = {
      "type": type,
      "txtnumber": txnNumber,
      "ifsc": ifsc,
      //"userdob": dob,
      "userdob": dob,
      "key": "1",
    };
    try {
      // Hit the API
      final response = await apiService_idc.verifyIdentity(requestBody);
      // Handle response

      if (response["data"] != null) {
        if (response["data"] is Map<String, dynamic>) {
          Map<String, dynamic> responseData = response["data"];
          // Parse JSON object if it’s a map
          if (type == "bankaccount") {
            setState(() {
              if (response["error"] == null) {
                temp =txnNumber;
                verifyFlag ==true;

                    bankAccHolder = "${responseData['full_name']}";
                banknameverified=true;
                saveIDsMethod(context);
              } else {
                bankAccHolder = "Account no. is Not Verified!!";
              }
            });
          } else if (type == "pancard") {
            setState(() {
              if (response["error"] == null) {
                panCardHolderName =
                    "${responseData['name']} ";
                panVerified = true;
              } else {
                panCardHolderName = "PAN no. is wrong please check";
                panVerified = false;
              }
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
      } else {
        showToast_Error(
            "Unexpected Response: ${response["error"]}\n${response["message"]}");
      }
      //     showToast_Error("Unexpected Response: $response");
      print("Unexpected Response: $response");
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
      // Initialize Dio
      // Create ApiService instance
      // API body
      Map<String, dynamic> requestBody = {
        "userID": userid,
        "dlno": dlNo,
        "dob": dob
      };
      // Hit the API
      final response =
          await apiService_protean.getDLDetailsProtean(requestBody);
      EasyLoading.show(
        status: 'Loading...',
      );
      // Handle response
      if (response is Map<String, dynamic>) {
        Map<String, dynamic> responseData = response["data"];
        // Parse JSON object if it’s a map
        setState(() {
          if (responseData['result']['name'] != null) {
            dlCardHolderName = "${responseData['result']['name']}";
            dlVerified = true;
          } else {
            docVerifyIDC(
                "drivinglicense", _dlController.text, "", _dobController.text);
          }
        });
      } else {
        docVerifyIDC(
            "drivinglicense", _dlController.text, "", _dobController.text);
      }
    } catch (e) {
      // Handle errors
      docVerifyIDC(
          "drivinglicense", _dlController.text, "", _dobController.text);
    }
    EasyLoading.dismiss();
  }

  void voterVerifyByProtean(String userid, String voterNo) async {
    EasyLoading.show(
      status: 'Loading...',
    );
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
            docVerifyIDC("voterid", _voterController.text, "", "");
          }
        });
      } else {
        docVerifyIDC("voterid", _voterController.text, "", "");
      }
    } catch (e) {
      // Handle errors
      docVerifyIDC("voterid", _voterController.text, "", "");
    }
    EasyLoading.show(
      status: 'Loading...',
    );
  }

  void bankVerifyByProtean(String userid, String dlNo, String dob) async {
    EasyLoading.show(
      status: 'Loading...',
    );
    try {
      // Initialize Dio
      // Create ApiService instance
      // API body
      Map<String, dynamic> requestBody = {
        "userID": userid,
        "accNo": _bank_AcController.text,
        "ifsc": _bank_IFCSController.text
      };
      // Hit the API
      final response =
      await apiService_protean.getBankDetailsProtean(requestBody);
      EasyLoading.show(
        status: 'Loading...',
      );
      // Handle response
      if (response is Map<String, dynamic>) {
        Map<String, dynamic> responseData = response["data"];
        // Parse JSON object if it’s a map
        setState(() {
          if (responseData['result']['accountName'] != null) {
            bankAccHolder = "${responseData['result']['accountName']}";
            banknameverified = true;
            saveIDsMethod(context);
          } else {
            docVerifyIDC("bankaccount", _bank_AcController.text, _bank_IFCSController.text, "");
          }
        });
      } else {
        docVerifyIDC("bankaccount", _bank_AcController.text, _bank_IFCSController.text, "");
      }
    } catch (e) {
      // Handle errors
      docVerifyIDC("bankaccount", _bank_AcController.text, _bank_IFCSController.text, "");
    }
    EasyLoading.dismiss();
  }

  Future<void> ifscVerify(BuildContext context, String ifsc) async {
    EasyLoading.show(
      status: 'Loading...',
    );
    final api = ApiService.create(baseUrl: ApiConfig.baseUrl3);

    return await api.ifscVerify(ifsc).then((value) {
      if (value.address.isNotEmpty) {
        setState(() {
          bankAddress = value.address.toString();
        });
        docVerifyIDC("bankaccount", _bank_AcController.text,
            _bank_IFCSController.text, "");
        EasyLoading.dismiss();
      } else {
        showToast_Error("Please check IFSC code is not verified");
        EasyLoading.dismiss();
      }
    }).catchError((error) {
      GlobalClass.showErrorAlert(context, error, 1);
      EasyLoading.dismiss();
    });
  }

  Future<void> getDataFromOCR(String type, BuildContext context) async {
    EasyLoading.show();
    pickedImage = await GlobalClass().pickImage();

    if (pickedImage != null) {
      try {
        final response = await apiService_OCR.uploadDocument(
          type, // imgType
          pickedImage!, // File
        );
        if (response.statusCode == 200) {
          if (type == "adharFront") {
            setState(() {
              _aadharIdController.text = response.data.adharId;
              _validateOnFocusChange();
              List<String> nameParts = response.data.name.trim().split(" ");
              if (nameParts.length == 1) {
                _fnameController.text = nameParts[0];
              } else if (nameParts.length == 2) {
                _fnameController.text = nameParts[0];
                _lnameController.text = nameParts[1];
              } else {
                _fnameController.text = nameParts.first;
                _lnameController.text = nameParts.last;
                _mnameController.text =
                    nameParts.sublist(1, nameParts.length - 1).join(' ');
              }
              _dobController.text = formatDate(response.data.dob, 'dd/MM/yyyy');
              genderselected = aadhar_gender
                  .firstWhere((item) =>
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
            _pincodeController.text = response.data.pincode;

            String cleanAddress(String name) {
              String cleanedAddrName =
                  name.replaceAll(RegExp(r'[^a-zA-Z0-9\s\-\(\)\./\\]'), '');

              cleanedAddrName = cleanedAddrName.replaceAllMapped(
                RegExp(r'(\s\s+|\-\-+|\(\(+|\)\)+|\.{2,}|/{2,}|\\{2,})'),
                (match) {
                  String matchedString = match.group(0)!;
                  if (matchedString.contains('-')) return '-';
                  if (matchedString.contains('(')) return '(';
                  if (matchedString.contains(')')) return ')';
                  if (matchedString.contains('.')) return '.';
                  if (matchedString.contains('/')) return '/';
                  if (matchedString.contains('\\')) return '\\';
                  return ' ';
                },
              );
              return cleanedAddrName;
            }

            void splitAndSetAddress(String cleanedAddress) {
              List<String> addressParts = cleanedAddress.split(" ");
              String address1 = '';
              String address2 = '';
              String address3 = '';

              if (addressParts.length >= 5) {
                address1 = addressParts.take(3).join(" ");
                address2 = addressParts[3] +
                    " " +
                    (addressParts.length > 4 ? addressParts[4] : '');
                address3 = addressParts.sublist(5).join(" ");
              } else if (addressParts.length == 4) {
                address1 = addressParts.take(3).join(" ");
                address2 = addressParts[3];
              } else if (addressParts.length == 3) {
                address1 = addressParts.take(2).join(" ");
                address2 = addressParts[2];
              } else if (addressParts.length == 2) {
                address1 = addressParts[0];
                address2 = addressParts[1];
              } else if (addressParts.length == 1) {
                address1 = addressParts[0];
              }

              _p_Address1Controller.text = address1;
              _p_Address2Controller.text = address2;
              _p_Address3Controller.text = address3;
            }

            if (response.data.relation.toLowerCase() == "father") {
              _guardianController.text = response.data.guardianName;
              setState(() {
                relationselected = "Father";
              });
              _p_CityController.text = response.data.cityName;
              stateselected = states.firstWhere((item) =>
                  item.descriptionEn.toLowerCase() ==
                  response.data.stateName.toLowerCase());

              String cleanedAddName = cleanAddress(response.data.address1);
              print("Cleaned Address: $cleanedAddName");

              splitAndSetAddress(cleanedAddName);

              // Uncomment and use if splitting guardian name is required:
              // splitAndSetGuardianName(response.data.guardianName, "Father");
            } else if (response.data.relation.toLowerCase() == "husband") {
              _guardianController.text = response.data.guardianName;
              setState(() {
                relationselected = "Husband";
              });
              _p_CityController.text = response.data.cityName;

              String cleanedAddName = cleanAddress(response.data.address1);
              print("Cleaned Address: $cleanedAddName");

              splitAndSetAddress(cleanedAddName);

              // Uncomment and use if splitting guardian name is required:
              // splitAndSetGuardianName(response.data.guardianName, "Husband");
            }

            Navigator.of(context).pop();
          }

          EasyLoading.dismiss();
        } else {
          showToast_Error(
              "Data not fetched from this Aadhaar card please check the image");
          Navigator.of(context).pop();
          EasyLoading.dismiss();
        }
      } catch (_) {
        showToast_Error(
            "Data not fetched from this Aadhaar card please check the image");
        Navigator.of(context).pop();
        EasyLoading.dismiss();
      }
    }
  }

  void setQRData(result) {
    List<String> dataList = result.split(",");
    if (dataList.length > 14) {
      if (dataList[0].toLowerCase().startsWith("v")) {
        _aadharIdController.text = dataList[2];
        if (_aadharIdController.text.length != 12) {
          GlobalClass.showErrorAlert(
              context, "Please Re-Enter Aadhaar number", 1);
          _aadharIdController.text = "";
        }
        _fnameController.text = dataList[3];
        List<String> nameParts = dataList[3].split(" ");
        if (nameParts.length == 1) {
          _fnameController.text = nameParts[0];
        } else if (nameParts.length == 2) {
          _fnameController.text = nameParts[0];
          _mnameController.text = nameParts[1];
        } else {
          _fnameController.text = nameParts.first;
          _lnameController.text = nameParts.last;
          _mnameController.text =
              nameParts.sublist(1, nameParts.length - 1).join(' ');
        }

        _dobController.text = formatDate(dataList[4], 'dd-MM-yyyy');
        setState(() {
          if (dataList[5].toLowerCase() == "m") {
            genderselected = "Male";
            selectedTitle = "Mr.";
          } else if (dataList[5].toLowerCase() == "f") {
            genderselected = "Female";
            selectedTitle = "Mrs.";
          }
        });
        // if (dataList[6].toLowerCase().contains("s/o") ||
        //     dataList[6].toLowerCase().contains("d/o")) {
        //   setState(() {
        //     relationselected = "Father";
        //     List<String> guarNameParts =
        //     replaceCharFromName(dataList[6]).split(" ");
        //     if (guarNameParts.length == 1) {
        //       //   _fatherFirstNameController.text = guarNameParts[0];
        //     } else if (guarNameParts.length == 2) {
        //       //  _fatherFirstNameController.text = guarNameParts[0];
        //       //   _fatherLastNameController.text = guarNameParts[1];
        //     } else {
        //       //   _fatherFirstNameController.text = guarNameParts.first;
        //       //   _fatherLastNameController.text = guarNameParts.last;
        //       //   _fatherMiddleNameController.text =
        //       guarNameParts.sublist(1, guarNameParts.length - 1).join(' ');
        //     }
        //   });
        // } else if (dataList[6].toLowerCase().contains("w/o")) {
        //   setState(() {
        //     relationselected = "Husband";
        //     List<String> guarNameParts =
        //     replaceCharFromName(dataList[6]).split(" ");
        //     if (guarNameParts.length == 1) {
        //       //    _spouseFirstNameController.text = guarNameParts[0];
        //     } else if (guarNameParts.length == 2) {
        //       //     _spouseFirstNameController.text = guarNameParts[0];
        //       //      _spouseLastNameController.text = guarNameParts[1];
        //     } else {
        //       //      _spouseFirstNameController.text = guarNameParts.first;
        //       //      _spouseLastNameController.text = guarNameParts.last;
        //       //     _spouseMiddleNameController.text =
        //       guarNameParts.sublist(1, guarNameParts.length - 1).join(' ');
        //     }
        //   });
        // }
        _p_CityController.text = dataList[7];

        _guardianController.text = replaceCharFromName(dataList[6]);

        if (dataList[0].toLowerCase() == 'v2') {
          _pincodeController.text = dataList[11];
          stateselected = states.firstWhere((item) =>
              item.descriptionEn.toLowerCase() == dataList[13].toLowerCase());
          String address =
              "${dataList[9]},${dataList[10]},${dataList[12]},${dataList[14]},${dataList[15]}";
          List<String> addressParts = address.trim().split(",");
          if (addressParts.length == 1) {
            _p_Address1Controller.text = addressParts[0];
          } else if (addressParts.length == 2) {
            _p_Address1Controller.text = addressParts[0];
            _p_Address2Controller.text = addressParts[1];
          } else {
            _p_Address1Controller.text = addressParts.first;
            _p_Address2Controller.text = addressParts.last;
            _p_Address3Controller.text =
                addressParts.sublist(1, addressParts.length - 1).join(' ');
          }
        } else if (dataList[0].toLowerCase() == 'v4') {
          // stateselected = states.firstWhere((item) =>
          // item.descriptionEn.toLowerCase() == dataList[14].toLowerCase());
          _pincodeController.text = dataList[12];
          String address =
              "${dataList[10]},${dataList[11]},${dataList[13]},${dataList[15]},${dataList[16]}";

          List<String> addressParts = address.trim().split(",");
          if (addressParts.length == 1) {
            _p_Address1Controller.text = addressParts[0];
          } else if (addressParts.length == 2) {
            _p_Address1Controller.text = addressParts[0];
            _p_Address2Controller.text = addressParts[1];
          } else {
            _p_Address1Controller.text = addressParts.first;
            _p_Address2Controller.text = addressParts.last;
            _p_Address3Controller.text =
                addressParts.sublist(1, addressParts.length - 1).join(' ');
          }
        }
      } else {
        _aadharIdController.text = dataList[1];
        if (_aadharIdController.text.length != 12) {
          GlobalClass.showErrorAlert(
              context, "Please Re-Enter Aadhaar number", 1);
          _aadharIdController.text = "";
        }

        _fnameController.text = dataList[2];

        List<String> nameParts = dataList[2].split(" ");
        if (nameParts.length == 1) {
          _fnameController.text = nameParts[0];
        } else if (nameParts.length == 2) {
          _fnameController.text = nameParts[0];
          _mnameController.text = nameParts[1];
        } else {
          _fnameController.text = nameParts.first;
          _mnameController.text = nameParts.last;
          _lnameController.text =
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
        // if (dataList[5].toLowerCase().contains("s/o") ||
        //     dataList[5].toLowerCase().contains("d/o")) {
        //   setState(() {
        //     relationwithBorrowerselected = "Father";
        //     List<String> guarNameParts =
        //     replaceCharFromName(dataList[5]).split(" ");
        //     if (guarNameParts.length == 1) {
        //       _fatherFirstNameController.text = guarNameParts[0];
        //     } else if (guarNameParts.length == 2) {
        //       _fatherFirstNameController.text = guarNameParts[0];
        //       _fatherLastNameController.text = guarNameParts[1];
        //     } else {
        //       _fatherFirstNameController.text = guarNameParts.first;
        //       _fatherLastNameController.text = guarNameParts.last;
        //       _fatherMiddleNameController.text =
        //           guarNameParts.sublist(1, guarNameParts.length - 1).join(' ');
        //     }
        //   });
        // } else if (dataList[5].toLowerCase().contains("w/o")) {
        //   setState(() {
        //     relationwithBorrowerselected = "Husband";
        //     List<String> guarNameParts =
        //     replaceCharFromName(dataList[5]).split(" ");
        //     if (guarNameParts.length == 1) {
        //       _spouseFirstNameController.text = guarNameParts[0];
        //     } else if (guarNameParts.length == 2) {
        //       _spouseFirstNameController.text = guarNameParts[0];
        //       _spouseLastNameController.text = guarNameParts[1];
        //     } else {
        //       _spouseFirstNameController.text = guarNameParts.first;
        //       _spouseLastNameController.text = guarNameParts.last;
        //       _spouseMiddleNameController.text =
        //           guarNameParts.sublist(1, guarNameParts.length - 1).join(' ');
        //     }
        //   });
        // }
        _p_CityController.text = dataList[6];
        _guardianController.text = replaceCharFromName(dataList[5]);

        _pincodeController.text = dataList[10];
        stateselected = states.firstWhere((item) =>
            item.descriptionEn.toLowerCase() == dataList[12].toLowerCase());
        String address =
            "${dataList[8]},${dataList[9]},${dataList[11]},${dataList[13]},${dataList[14]}";
        List<String> addressParts = address.trim().split(",");
        if (addressParts.length == 1) {
          _p_Address1Controller.text = addressParts[0];
        } else if (addressParts.length == 2) {
          _p_Address1Controller.text = addressParts[0];
          _p_Address2Controller.text = addressParts[1];
        } else {
          _p_Address1Controller.text = addressParts.first;
          _p_Address2Controller.text = addressParts.last;
          _p_Address3Controller.text =
              addressParts.sublist(1, addressParts.length - 1).join(' ');
        }
      }
    }
  }

  Future<void> saveGuarantorMethod(BuildContext context) async {
    EasyLoading.show(
      status: 'Loading...',
    );

    print("object");
    String fi_ID = FIID.toString();
    String gr_Sno = "1";
    String title = selectedTitle!;
    String fname = _fnameController.text.toString();
    String mname = _mnameController.text.toString();
    String lname = _lnameController.text.toString();
    String guardianName = _guardianController.text.toString();
    String relation_with_Borrower = relationselected.toString();
    String p_Address1 = _p_Address1Controller.text.toString();
    String p_Address2 = _p_Address2Controller.text.toString();
    String p_Address3 = _p_Address3Controller.text.toString();
    String p_City = _p_CityController.text.toString();
    String p_State = stateselected!.descriptionEn;
    String pincode = _pincodeController.text.toString();
    String dob = _dobController.text.toString();
    String age = _ageController.text.toString();
    String phone = _phoneController.text.toString();
    String pan = _panController.text.toString();
    String dl = _dlController.text.toString();
    String voter = _voterController.text.toString();
    String aadharId = _aadharIdController.text.toString();
    String gender = genderselected.toString();
    String religion = religionselected.toString();
    bool esign_Succeed = true;
    String esign_UUID = "1354";

    final api = Provider.of<ApiService>(context, listen: false);

    return await api
        .saveGurrantor(
            GlobalClass.token,
            GlobalClass.dbName,
            fi_ID,
            gr_Sno,
            title,
            fname,
            mname,
            lname,
            guardianName,
            relation_with_Borrower,
            p_Address1,
            p_Address2,
            p_Address3,
            p_City,
            p_State,
            pincode,
            dob,
            age,
            phone,
            pan,
            dl,
            voter,
            aadharId,
            gender,
            religion,
            esign_Succeed,
            esign_UUID,
            _imageFile!)
        .then((value) async {
      if (value.statuscode == 200) {
        setState(() {
          _currentStep += 1;
          pageTitle = "Docs Upload";
          GuarantorEditable = false;
          GetDocs(context);
        });
      } else {
        showToast_Error(value.data[0].errormsg);
        EasyLoading.dismiss();
      }
    }).catchError((error) {
      showToast_Error(error);
      EasyLoading.dismiss();
    });
  }

  String formatDate(String date, dateFormat) {
    try {
      // Parse the input string to a DateTime object
      DateTime parsedDate = DateFormat(dateFormat).parse(date);
      setState(() {
        _selectedDate = parsedDate;
        _calculateAge();
      });

      // Return the formatted date string in yyyy-MM-dd format
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      // Handle any invalid format
      return 'Invalid Date';
    }
  }

  String replaceCharFromName(String gurName) {
    return gurName
        .replaceAll("S/O ", "")
        .replaceAll("S/O: ", "")
        .replaceAll("D/O ", "")
        .replaceAll("D/O: ", "")
        .replaceAll("W/O ", "")
        .replaceAll("W/O: ", "");
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

  Future<void> getAllDataApi(BuildContext context) async {
    EasyLoading.show(status: 'Loading...');

    final api = Provider.of<ApiService>(context, listen: false);

    return await api
        .dataByFIID(GlobalClass.token, GlobalClass.dbName, FIID)
        .then((value) async {
      if (value.statuscode == 200) {
        EasyLoading.dismiss();
        BorrowerInfo = value.data;
        Future.delayed(
            Duration.zero, () => showIDCardDialog(context, BorrowerInfo[0]));

        if (!value.data[0].placeOfBirth.isEmpty) {
          setState(() {
            _currentStep = 1;
            pageTitle = "Family Details";
          });
          personalInfo(value.data[0]);
        }
        if (!value.data[0].motheRFirstName.isEmpty) {
          familyDetails(value.data[0]);
          setState(() {
            _currentStep = 2;
            pageTitle = "Income & Expense";
          });
        }

        if (value.data[0].fiIncomeExpenses.length != 0 &&
            value.data[0].fiIncomeExpenses[0].inExHomeType.isNotEmpty) {
          fiIncomeExpenses(value.data[0]);
          setState(() {
            _currentStep = 3;
            pageTitle = "Financial Info.";
          });
        }

        if (!value.data[0].bankAc.isEmpty) {
          financialInfo(value.data[0]);
          setState(() {
            _currentStep = 4;
            pageTitle = "Family Income";
          });
        }

        if (value.data[0].familyMembers.length != 0) {
          femMemIncome(value.data[0]);
          setState(() {
            _currentStep = 5;
            pageTitle = "Guarantor Form";
          });
        }
        if (value.data[0].guarantors.length != 0) {
          guarrantors(value.data[0]);
          setState(() {
            _currentStep = 6;
            pageTitle = "Docs Upload";
          });
        }
      } else {
        setState(() {});
      }
    }).catchError((err) {
      print("ERRORRRR$err");
      EasyLoading.dismiss();
    //  GlobalClass.showErrorAlert(context, "Corrupt Case", 2);
    });
  }

  void personalInfo(ApplicationgetAllDataModel data) {
    setState(() {
      editButtonFunctionOn = true;
      personalInfoEditable = false;
      // FIID,
      emailIdController.text = data.emailId;
      placeOfBirthController.text = data.placeOfBirth;
      selectedDependent = data.depedentPerson;
      // "gff"
      selectedReligionextra = data.religion;
      selectedCast = data.cast;
      if (data.isHandicap) {
        _isHandicapVisible = true;
      }
      if (handicapTypes.contains(data.handicapType.toString())) {
        selectedspecialAbility = data.handicapType;
      } else {
        selectedspecialAbility = null; // Or set a default value
      }

      mobileController.text = data.pPhone;
      data.isHandicap ? selectedIsHandicap = "Yes" : selectedIsHandicap = "No";
      data.special_Social_Category
          ? selectedSpecialSocialCategory = "Yes"
          : selectedSpecialSocialCategory = "No";

      data.isHouseRental
          ? selectedIsHouseRental = "Yes"
          : selectedIsHouseRental = "No"; //  selectedProperty,

      address1ControllerP.text = data.pAddress1;
      address2ControllerP.text = data.pAddress2;
      address3ControllerP.text = data.pAddress3;
      cityControllerP.text = data.pCity;
      selectedStateextraP =
          states.firstWhere((item) => item.code == data.pState);
      // print("State from model ${states.firstWhere((item) =>item.code == data.pState)}");
      //selectedStateextraP=data.pState;
      pincodeControllerP.text = data.pPincode;
      address1ControllerC.text = data.currentAddress1;
      address2ControllerC.text = data.currentAddress2;
      address3ControllerC.text = data.currentAddress3;
      cityControllerC.text = data.currentCity;
      selectedStateextraC = states.firstWhere((item) =>
          item.descriptionEn.toLowerCase() == data.currentState.toLowerCase());
      pincodeControllerC.text = data.currentPincode;
      //  selectedDistrict,
      //  selectedSubDistrict,
      //  selectedVillage,
      selectedResidingFor = data.liveInPresentPlace;
      selectedProperty = data.propertyArea.toString();
      selectedPresentHouseOwner = data.houseOwnerName;
      getPlace("district", selectedStateextraP!.code, "", "");
    });
  }

  void familyDetails(ApplicationgetAllDataModel data) {
    setState(() {
      editButtonFunctionOn = true;
      FiFamilyEditable = false;
      _motherFController.text = data.motheRFirstName;
      _motherMController.text = data.motheRMiddleName;
      _motherLController.text = data.motheRLastName;

      selectednumOfChildren = data.noOfChildren.toString();
      selectedschoolingChildren = data.schoolingChildren.toString();
      if (onetonine.contains(data.otherDependents.toString())) {
        selectedotherDependents = data.otherDependents.toString();
      } else {
        selectedotherDependents = null; // Or set a default value
      }
    });
  }

  void fiIncomeExpenses(ApplicationgetAllDataModel data) {
    setState(() {
      editButtonFunctionOn = true;
      FiIncomeEditable = false;
      verifyFlag = false;
      selectedOccupation = data.fiIncomeExpenses[0].inExOccupation;
      selectedBusiness = data.fiIncomeExpenses[0].inExBusinessDetail;
      _currentEMIController.text =
          data.fiIncomeExpenses[0].inExAnyCurrentEmi.toString();
      selectedHomeType = data.fiIncomeExpenses[0].inExHomeType;
      selectedRoofType = data.fiIncomeExpenses[0].inExHomeRoofType;
      selectedToiletType = data.fiIncomeExpenses[0].inExToiletType;
      data.fiIncomeExpenses[0].inExLivingWithSpouse
          ? selectedLivingWithSpouse = "Yes"
          : selectedLivingWithSpouse = "No";
      //   selectedLivingWithSpouse = data.fiIncomeExpenses[0].inExLivingWithSpouse.toString();
      selectedEarningMembers =
          data.fiIncomeExpenses[0].inExEarningMemCount.toString();
      selectedBusinessExperience =
          data.fiIncomeExpenses[0].inExYearsInBusiness.toString();
      _future_IncomeController.text =
          data.fiIncomeExpenses[0].inExFutureIncome.toString();
      _agriculture_incomeController.text =
          data.fiIncomeExpenses[0].inExAgricultureIncome.toString();
      _other_IncomeController.text =
          data.fiIncomeExpenses[0].inExOtherIncome.toString();
      _annuaL_INCOMEController.text =
          data.fiIncomeExpenses[0].inExAnnualIncome.toString();
      _spendOnChildrenController.text =
          data.fiIncomeExpenses[0].inExSpendOnChildren.toString();
      _otheR_THAN_AGRICULTURAL_INCOMEController.text =
          data.fiIncomeExpenses[0].inExOtherThanAgriculturalIncome.toString();
      _pensionIncomeController.text =
          data.fiIncomeExpenses[0].inExPensionIncome.toString();
      _any_RentalIncomeController.text =
          data.fiIncomeExpenses[0].inExAnyRentalIncome.toString();
      _rentController.text = data.fiIncomeExpenses[0].inExRent.toString();
      _foodingController.text = data.fiIncomeExpenses[0].inExFooding.toString();
      _educationController.text =
          data.fiIncomeExpenses[0].inExEducation.toString();
      _healthController.text = data.fiIncomeExpenses[0].inExHealth.toString();
      _travellingController.text =
          data.fiIncomeExpenses[0].inExTravelling.toString();
      _entertainmentController.text =
          data.fiIncomeExpenses[0].inExEntertainment.toString();
      _othersController.text = data.fiIncomeExpenses[0].inExOthers.toString();
    });
  }

  void financialInfo(ApplicationgetAllDataModel data) {
    setState(() {
      FinancialInfoEditable = false;
      editButtonFunctionOn = true;
      if (accType.contains(data.bankType)) {
        selectedAccountType = data.bankType;
      } else {
        selectedAccountType = null; // Or set a default value
      }

      //   selectedBankName = data.bankName;
      bankAccHolder = data.bankAccName;
      _bank_AcController.text = data.bankAc;
      _bank_IFCSController.text = data.bankIfcs;
      bankAddress = data.bankAddress;

      DateTime parsedDate = DateTime.parse(data.bankAcOpenDate);
      String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
      _bankOpeningDateController.text = formattedDate;
    //  _bankOpeningDateController.text = data.bankAcOpenDate.split("T")[0];
    });
  }

  void femMemIncome(ApplicationgetAllDataModel data) {
    setState(() {
      femMemIncomeEditable = false;
      editButtonFunctionOn = true;

      _femNameController.text = data.familyMembers[0].famName;
      _AgeController.text = data.familyMembers[0].famAge.toString();
      femselectedGender = data.familyMembers[0].famGender;
      femselectedRelationWithBorrower =
          data.familyMembers[0].famRelationWithBorrower;
      femselectedHealth = data.familyMembers[0].famHealth;
      femselectedEducation = data.familyMembers[0].famEducation;
      femselectedSchoolType = data.familyMembers[0].famSchoolType;
      femselectedBusiness = data.familyMembers[0].famBusiness;
      _IncomeController.text = data.familyMembers[0].famIncome.toString();
      femselectedBusinessType = data.familyMembers[0].famBusinessType;
      femselectedIncomeType = data.familyMembers[0].famIncomeType;
    });
  }

  void guarrantors(ApplicationgetAllDataModel data) {
    setState(() {
      GuarantorEditable = false;
      editButtonFunctionOn = true;

      _fnameController.text = data.guarantors[0].grFname;
      _mnameController.text = data.guarantors[0].grMname;
      _lnameController.text = data.guarantors[0].grLname;
      _guardianController.text = data.guarantors[0].grGuardianName;
      if (titleList.contains(data.guarantors[0].grTitle)) {
        selectedTitle = data.guarantors[0].grTitle;
      } else {
        selectedTitle = null; // Or set a default value
      }


      _p_Address1Controller.text = data.guarantors[0].grPAddress1;
      _p_Address2Controller.text = data.guarantors[0].grPAddress2;
      _p_Address3Controller.text = data.guarantors[0].grPAddress3;
      _p_CityController.text = data.guarantors[0].grPCity;
      stateselected = states.firstWhere((item) =>
          item.descriptionEn.toLowerCase() ==
          data.guarantors[0].grPState.toLowerCase());
      genderselected = data.guarantors[0].grGender;
      religionselected = data.guarantors[0].grReligion;
      if (relation.any((item) =>
          item.descriptionEn == data.guarantors[0].grRelationWithBorrower)) {
        relationselected = data.guarantors[0].grRelationWithBorrower;
      } else {
        relationselected = null; // Or set a default value
      }

      _pincodeController.text = data.guarantors[0].grPincode.toString();


      DateTime parsedDate = DateTime.parse(data.guarantors[0].grDob);
      String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
      _dobController.text = formattedDate;
      //_dobController.text = data.guarantors[0].grDob.toString();



      _ageController.text = data.guarantors[0].grAge.toString();
      _phoneController.text = data.guarantors[0].grPhone;
      _panController.text = data.guarantors[0].grPan;
      _dlController.text = data.guarantors[0].grDl;
      _voterController.text = data.guarantors[0].grVoter;
      _aadharIdController.text = data.guarantors[0].grAadharId;
      //  _imageFile2 =GlobalClass().transformFilePathToUrl(widget.selectedData.profilePic);

      _imageFile1 =
          GlobalClass().transformFilePathToUrl(data.guarantors[0].grPicture);
      grPicFlag = true;
      //  genderselected = data.guarantors[0].grGender;
      //  religionselected = data.guarantors[0].grReligion;
      /*      = data.guarantors[0].grEsignSucceed;
       = data.guarantors[0].grEsignUuid;
       = data.guarantors[0].grPicture;*/
    });
  }

  Future<void> DeleteGur(BuildContext context) async {
    EasyLoading.show(status: 'Loading...');
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .deleteGurrantor(GlobalClass.token, GlobalClass.dbName, FIID.toString())
        .then((value) async {
      if (value.statuscode == 200) {
        EasyLoading.dismiss();
        GlobalClass.showSuccessAlert(
            context, "${value.message} Save Guarantor again", 1);
        setState(() {
          GuarantorEditable = true;
          grPicFlag = false;
        });
      } else {
        EasyLoading.dismiss();
        setState(() {});
      }
    }).catchError((err) {
      GlobalClass.showErrorAlert(context, "Server Side Error", 2);
      EasyLoading.dismiss();
      Navigator.of(context).pop();
    });
  }

  /* Future<bool> OcrDocsScanning(String type, String id, String subType, BuildContext context) async {
    EasyLoading.show();

    try {
      // pickedImage;
*/
/*
      if (pickedImage == null) {
        print("Opening camera to pick an image...");
        pickedImage = await GlobalClass().pickImage();
       print("No image selected.");
        EasyLoading.dismiss();
        return;
      } else {
        print("Image selected: ${pickedImage?.path}");
      }*/
  /*

      print("GestureDetector tapped. ID: $id, Title: $type");

      final response = await apiService_OCR.OcrDocsScan(type, id, pickedImage!);

      if (response.statusCode == 200 ) {
        EasyLoading.dismiss();
        return true;

        // switch (type) {
        //   case "aadharfront":
        //     handleAadharFront(response, subType, "borrower", context);
        //     break;
        //   case "aadharback":
        //     handleAadharBack(response, subType, "borrower", context);
        //     break;
        //   case "voterfront":
        //     handleVoterFront(response, subType, "borrower", context);
        //     break;
        //   case "voterback":
        //     handleVoterBack(response, subType, "borrower", context);
        //     break;
        //   case "Pan":
        //     handlePan(response, subType, "borrower", context);
        //     break;
        //   case "DL":
        //     handleDL(response, subType, "borrower", context);
        //     break;
        //   case "passbook":
        //     handlePassbook(response, context);
        //     break;
        //   default:
        //     showToast_Error("Unsupported document type.");
        //     break;
        // }
      } else {
        if(response.statusCode == 201 ){
          OcrDocsScanningResponse ocrDocsScanningResponse= response.data.toString() as OcrDocsScanningResponse;
          if (!ocrDocsScanningResponse.data.isOSV){
            showDocumentMismatchError(context);
          }else if(!ocrDocsScanningResponse.data.isIdMatched) {
            showIDMismatchError(context);
          }else{
            showToast_Error("Failed to fetch data. Status Code: ${response.statusCode}.");
          }
        }

        showToast_Error("Failed to fetch data. Status Code: ${response.statusCode}.");
        EasyLoading.dismiss();
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint("Error during OCR scanning: $e");
      debugPrint("Stack trace: $stackTrace");
      showToast_Error("An error occurred while processing the document. Please try again.");
      EasyLoading.dismiss();
      return false;
    }
  }
*/

  Future<bool> OcrDocsScanning(
      String type, String id, String subType, BuildContext context) async {
    EasyLoading.show(); // Show a loading indicator

    try {
      if (pickedImage == null) {
        showToast_Error("No image selected. Please try again.");
        EasyLoading.dismiss();
        return false;
      }
      print("GestureDetector tapped. ID: $id, Title: $type");
      final response = await apiService_OCR.OcrDocsScan(type, id, pickedImage!);

      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        GlobalClass.showSuccessAlert(context, response.message, 1);
        return true;

        // switch (type) {
        //   case "aadharfront":
        //     handleAadharFront(response, subType, "borrower", context);
        //     break;
        //   case "aadharback":
        //     handleAadharBack(response, subType, "borrower", context);
        //     break;
        //   case "voterfront":
        //     handleVoterFront(response, subType, "borrower", context);
        //     break;
        //   case "voterback":
        //     handleVoterBack(response, subType, "borrower", context);
        //     break;
        //   case "Pan":
        //     handlePan(response, subType, "borrower", context);
        //     break;
        //   case "DL":
        //     handleDL(response, subType, "borrower", context);
        //     break;
        //   case "passbook":
        //     handlePassbook(response, context);
        //     break;
        //   default:
        //     showToast_Error("Unsupported document type.");
        //     break;
        //
        // }
        // return true;
      } else if (response.statusCode == 201) {
        OcrDocsScanningResponse ocrDocsScanningResponse = response;

        if (!ocrDocsScanningResponse.data.isOSV) {
          showDocumentMismatchError(context);
        } else if (!ocrDocsScanningResponse.data.isIdMatched) {
          showIDMismatchError(context);
        } else {
          GlobalClass.showUnsuccessfulAlert(context,
              "Unexpected response. Status Code: ${response.statusCode}.", 1);
        }

        EasyLoading.dismiss();
        return false;
      } else {
        GlobalClass.showUnsuccessfulAlert(context,
            "Failed to fetch data. Status Code: ${response.statusCode}.", 1);

        EasyLoading.dismiss();
        return false;
      }
    } catch (e, stackTrace) {
      GlobalClass.showUnsuccessfulAlert(
          context,
          "An error occurred while processing the document. Please try again.",
          1);

      EasyLoading.dismiss();
      return false;
    }
  }

  void showIDCardDialog(
      BuildContext context, ApplicationgetAllDataModel borrowerInfo) {
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
    String formattedDOB =
        '${dob.split('T')[0].split('-')[2]}-${dob.split('T')[0].split('-')[1]}-${dob.split('T')[0].split('-')[0]}';

    final String loanAmt = borrowerInfo.loanAmount.toString();
    final String imageUrl =
        GlobalClass().transformFilePathToUrl(widget.selectedData.profilePic);
    // Replace with your image URL

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
                  child: Text('Borrower Details',
                      style: TextStyle(
                        fontSize: 16,
                      ))),
              content: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  width: 300,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
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
                      ),
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
                        'UID: $aadhaarNo',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      // PAN, DL, Voter No. (showing all if they exist)
                      Column(
                        children: [
                          if (voterId.isNotEmpty)
                            Text('Voter: $voterId',
                                style: TextStyle(fontSize: 16)),
                          if (panNo.isNotEmpty)
                            Text('Pan: $panNo', style: TextStyle(fontSize: 16)),
                          if (dl.isNotEmpty)
                            Text('DL: $dl', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      SizedBox(height: 5),
                      // DOB

                      Text(
                        'DOB: $formattedDOB',
                        style: TextStyle(fontSize: 16),
                      ),

                      SizedBox(height: 5),
                      // Loan Amount
                      if (loanAmt.isNotEmpty)
                        Text('Loan Amt: $loanAmt',
                            style: TextStyle(fontSize: 16)),
                      SizedBox(height: 20),
                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              print('Verification Confirmed');
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
                                  'Verify',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
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
                          GestureDetector(
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
                                  'Reject',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
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
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void handleAadharFront(
      response, String subType, String idType, BuildContext context) {
    String expectedId = subType == "borrower"
        ? BorrowerInfo[0].aadharNo
        : BorrowerInfo[0].guarantors[0].grAadharId;
    if (response.data.adharId == expectedId) {
      if (response.data.isOSV == true && response.data.isIdMatched == true) {
        if (subType == "borrower") {
          adhaarFront = pickedImage;
        } else if (subType == "guarantor") {
          adhaarFront_coborrower = pickedImage;
        }
        EasyLoading.dismiss();
        GlobalClass.showSuccessAlert(
            context, "Document successfully verified", 1);
      } else {
        showDocumentMismatchError(context);
      }
    } else {
      showIDMismatchError(context);
    }
  }

  void handleAadharBack(
      response, String subType, borrower, BuildContext context) {
    String expectedId = subType == "borrower"
        ? BorrowerInfo[0].aadharNo
        : BorrowerInfo[0].guarantors[0].grAadharId;
    if (response.data.adharId == expectedId) {
      if (response.data.isOSV == true && response.data.isIdMatched == true) {
        if (subType == "borrower") {
          adhaarBack = pickedImage;
        } else if (subType == "guarantor") {
          adhaarBack_coborrower = pickedImage;
        }
        EasyLoading.dismiss();
        GlobalClass.showSuccessAlert(
            context, "Aadhaar back document verified successfully!", 1);
      } else {
        showDocumentMismatchError(context);
      }
    } else {
      showIDMismatchError(context);
    }
  }

  void handleVoterFront(
      response, String subType, borrower, BuildContext context) {
    String expectedId = subType == "borrower"
        ? BorrowerInfo[0].voterId
        : BorrowerInfo[0].guarantors[0].grVoter;
    if (response.data.adharId == expectedId) {
      if (response.data.isOSV == true && response.data.isIdMatched == true) {
        // if (subType == "borrower") {
        //   voterFront = pickedImage;
        // } else if (subType == "guarantor") {
        //   voterFront_coborrower = pickedImage;
        // }
        EasyLoading.dismiss();
        GlobalClass.showSuccessAlert(
            context, "Voter front document verified successfully!", 1);
      } else {
        showDocumentMismatchError(context);
      }
    } else {
      showIDMismatchError(context);
    }
  }

  void handleVoterBack(
      response, String subType, borrower, BuildContext context) {
    if (response.data.isOSV == true) {
      if (subType == "borrower") {
        voterback = pickedImage;
      } else if (subType == "guarantor") {
        voterback_coborrower = pickedImage;
      }
      voterback = pickedImage;
      EasyLoading.dismiss();
      GlobalClass.showSuccessAlert(
          context, "Voter back document verified successfully!", 1);
    } else {
      showDocumentMismatchError(context);
    }
  }

  void handlePan(response, String subType, borrower, BuildContext context) {
    String expectedId = subType == "borrower"
        ? BorrowerInfo[0].panNo
        : BorrowerInfo[0].guarantors[0].grPan;
    if (response.data.adharId == expectedId) {
      if (response.data.isOSV == true && response.data.isIdMatched == true) {
        if (subType == "borrower") {
          panFront = pickedImage;
        } else if (subType == "guarantor") {
          panFront_coborrower = pickedImage;
        }
        EasyLoading.dismiss();
        GlobalClass.showSuccessAlert(
            context, "PAN document verified successfully!", 1);
      } else {
        showDocumentMismatchError(context);
      }
    } else {
      showIDMismatchError(context);
    }
  }

  void handleDL(response, String subType, borrower, BuildContext context) {
    String expectedId = subType == "borrower"
        ? BorrowerInfo[0].dl
        : BorrowerInfo[0].guarantors[0].grDl;
    if (response.data.adharId == expectedId) {
      if (response.data.isOSV == true) {
        if (subType == "borrower") {
          dlFront = pickedImage;
        } else if (subType == "guarantor") {
          dlFront_coborrower = pickedImage;
        }
        EasyLoading.dismiss();
        GlobalClass.showSuccessAlert(
            context, "Driving License verified successfully!", 1);
      } else {
        showDocumentMismatchError(context);
      }
    } else {
      showIDMismatchError(context);
    }
  }

  void handlePassbook(response, BuildContext context) {
    if (response.data.isOSV == true) {
      passbook = pickedImage;
      EasyLoading.dismiss();
      GlobalClass.showSuccessAlert(
          context, "Passbook verified successfully!", 1);
    } else {
      showDocumentMismatchError(context);
    }
  }

  void showDocumentMismatchError(BuildContext context) {
    EasyLoading.dismiss();
    GlobalClass.showUnsuccessfulAlert(
        context,
        "OSV Stamp not found or Not readable!!\nओएसवी स्टाम्प नहीं मिला या पढ़ने योग्य नहीं है!!",
        1);
  }

  void showIDMismatchError(BuildContext context) {
    EasyLoading.dismiss();
    GlobalClass.showUnsuccessfulAlert(
        context,
        "Did not found Document Id\nPlease check document id properly clear or readable\nदस्तावेज़ आईडी नहीं मिला\n" +
            "कृपया जाँचें कि दस्तावेज़ आईडी ठीक से स्पष्ट या पढ़ने योग्य है",
        1);
  }

  Future<void> saveKYCAllDocs(BuildContext context, String GurNum) async {
    try {
      EasyLoading.show(status: 'Loading...');

      String? Image;
      if (_imageFile == null) {
        Image = 'Null';
      }

      final api = Provider.of<ApiService>(context, listen: false);

      await api.FiDocsUploads(
        GlobalClass.token,
        GlobalClass.dbName,
        widget.selectedData.id.toString(),
        GurNum,
        GurNum == "0" ? adhaarFront : adhaarFront_coborrower,
        GurNum == "0" ? adhaarBack : adhaarBack_coborrower,
        GurNum == "0" ? voterFront : voterFront_coborrower,
        GurNum == "0" ? voterback : voterback_coborrower,
        GurNum == "0" ? dlFront : dlFront_coborrower,
        GurNum == "0" ? panFront : panFront_coborrower,
        GurNum == "0" ? passport : null,
        GurNum == "0" ? passbook : null,
      ).then((value) async {
        if (value.statuscode == 200) {
          EasyLoading.dismiss();
          GlobalClass.showSuccessAlert(
              context, "${value.message} \n${value.data[0].errormsg}", 1);
          setState(() {
            _currentStep++;
          });
        } else if (value.statuscode == 400) {
          EasyLoading.dismiss();

          GlobalClass.showUnsuccessfulAlert(
              context, "${value.message} \n${value.data[0].errormsg}", 1);
        } else {
          EasyLoading.dismiss();

          GlobalClass.showUnsuccessfulAlert(
              context, "${value.message} \n${value.data[0].errormsg}", 1);
        }
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

  bool validateAllDocsForBorrower(BuildContext context, String gurNum) {
    KycScanningDataModel kycScanningDataModel = getData.data;
    if (gurNum == "0") {
      if (kycScanningDataModel.addharExists) {
        if (adhaarFront == null) {
          GlobalClass.showToast_Error("Please upload Aadhaar Front");
          return false;
        }

        if (adhaarBack == null) {
          GlobalClass.showToast_Error("Please upload Aadhaar Back");
          return false;
        }
      }

      if (kycScanningDataModel.drivingExists) {
        if (dlFront == null) {
          GlobalClass.showToast_Error("Please upload Driving License");
          return false;
        }
      }

      if (kycScanningDataModel.voterExists) {
        if (voterFront == null) {
          GlobalClass.showToast_Error("Please upload Voter Card Front");
          return false;
        }

        if (voterback == null) {
          GlobalClass.showToast_Error("Please upload Voter Card Back");
          return false;
        }
      }
      if (kycScanningDataModel.panExists) {
        if (panFront == null) {
          GlobalClass.showToast_Error("Please upload PAN Card");
          return false;
        }
      }

      if (kycScanningDataModel.passportExists) {
        if (passport == null) {
          GlobalClass.showToast_Error("Please upload Passport");
          return false;
        }
      }

      if (passbook == null) {
        GlobalClass.showToast_Error("Please upload Passbook");
        return false;
      }

      return true;
    } else {
      if (kycScanningDataModel.grDocs[0].addharExists) {
        if (adhaarFront_coborrower == null) {
          GlobalClass.showToast_Error(
              "Please upload CO-Borrower Aadhaar Front");
          return false;
        }

        if (adhaarBack_coborrower == null) {
          GlobalClass.showToast_Error("Please upload CO-Borrower Aadhaar Back");
          return false;
        }
      }

      if (kycScanningDataModel.grDocs[0].drivingExists) {
        if (dlFront_coborrower == null) {
          GlobalClass.showToast_Error(
              "Please upload CO-Borrower Driving License");
          return false;
        }
      }

      if (kycScanningDataModel.grDocs[0].voterExists) {
        if (voterFront_coborrower == null) {
          GlobalClass.showToast_Error(
              "Please upload CO-Borrower Voter Card Front");
          return false;
        }

        if (voterback_coborrower == null) {
          GlobalClass.showToast_Error(
              "Please upload CO-Borrower Voter Card Back");
          return false;
        }
      }
      if (kycScanningDataModel.grDocs[0].panExists) {
        if (panFront_coborrower == null) {
          GlobalClass.showToast_Error("Please upload CO-Borrower PAN Card");
          return false;
        }
      }

      return true;
    }
  }

  void _validateOnFocusChange() {
    setState(() {
      if (_aadharIdController.text.isEmpty) {
        _errorMessageAadhaar = 'Aadhaar Id field cannot be empty!';
      } else if (_aadharIdController.text.length != 12) {
        _errorMessageAadhaar = 'Aadhaar must be 12 characters long.';
      } else if (!Validators.validateVerhoeff(_aadharIdController.text)) {
        _errorMessageAadhaar = 'Aadhaar id is not valid';
      } else if (_aadharIdController.text.length == 12&& _aadharIdController.text == widget.selectedData.aadharNo) {
          _errorMessageAadhaar = 'Borrower can`t be Co-Borrower';

         // adhaarAllData(context);
        }else{
      _errorMessageAadhaar = "";
      }
    });

  }

}
