import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/GlobalClass.dart';
import 'package:flutter_sourcing_app/Models/BankNamesModel.dart';
import 'package:flutter_sourcing_app/Models/KycScanningModel.dart';
import 'package:flutter_sourcing_app/Models/getAllModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'ApiService.dart';
import 'DATABASE/DatabaseHelper.dart';
import 'Models/BorrowerListModel.dart';
import 'Models/GroupModel.dart';
import 'Models/RangeCategoryModel.dart';
import 'Models/branch_model.dart';
import 'Models/place_codes_model.dart';
import 'QRScanPage.dart';

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

  bool _isPageLoading = false;
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  bool personalInfoEditable = true;
  bool FiFamilyEditable = true;
  bool FiIncomeEditable = true;
  bool FinancialInfoEditable = true;
  bool femMemIncomeEditable = true;
  bool GuarantorEditable = true;
  bool UploadFiDocsEditable = true;

  String pageTitle = "Personal Info";

  final _mobileFocusNode = FocusNode();
  final _pinFocusNodeP = FocusNode();
  final _pinFocusNodeC = FocusNode();
  String? _emailError;
  String? _mobileError;
  String? _pinErrorP;
  String? _pinErrorC;
  bool _isAddressChecked = false;

  late List<BankNamesDataModel> bankNamesList = [];
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
  String titleselected = "Select";
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

  Color iconPan = Color(0xFFD42D3F);
  Color iconDl = Color(0xFFD42D3F);
  Color iconVoter = Color(0xFFD42D3F);

//FIEXTRA
  String? selectedDependent;
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
  String? selectedAccountType, selectedBankName;
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
  String? selectedBank;
  String? Fi_Id;
  String qrResult = "";
  File? _imageFile;
  File? adhaarFront;
  File? adhaarBack;
  File? panFront;
  File? voterFront;
  File? voterback;
  File? dlFront;
  File? passport;
  File? passbook;

  @override
  void initState() {
    super.initState();
    FIID = widget.selectedData.id;
    apiService_OCR = ApiService.create(baseUrl: ApiConfig.baseUrl6);
    apiService = ApiService.create(baseUrl: ApiConfig.baseUrl1);

    getAllDataApi(context);
     apiService_idc=ApiService.create(baseUrl: ApiConfig.baseUrl4);
    GetDocs(context);
    initializeData(); // Fetch initial data
    _BabnkNamesAPI(context);
    _emailIdFocus.addListener(_validateEmail);
    _mobileFocusNode.addListener(_validateMobile);
    _pinFocusNodeP.addListener(() {
      _validatePincode("A");
    });
    _pinFocusNodeC.addListener(() {
      _validatePincode("B");
    });
  }

  Future<void> initializeData() async {
    super.initState();
    fetchData();
    _calculateAge();
    selectedDependent = onetonine.isNotEmpty ? onetonine[0] : null;
    selectedResidingFor = onetonine.isNotEmpty ? onetonine[0] : null;
    selectedspecialAbility = trueFalse.isNotEmpty ? trueFalse[0] : null;
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
      states.insert(0, RangeCategoryDataModel(catKey: 'Select', groupDescriptionEn: 'select', groupDescriptionHi: 'select', descriptionEn: 'Select', descriptionHi: 'select', sortOrder: 0, code: 'select'));
      relation.insert(0, RangeCategoryDataModel(catKey: 'Select', groupDescriptionEn: 'select', groupDescriptionHi: 'select', descriptionEn: 'Select', descriptionHi: 'select', sortOrder: 0, code: 'select'));
      religion.insert(0, RangeCategoryDataModel(catKey: 'Select', groupDescriptionEn: 'select', groupDescriptionHi: 'select', descriptionEn: 'Select', descriptionHi: 'select', sortOrder: 0, code: 'select'));
      landOwner.insert(0, RangeCategoryDataModel(catKey: 'Select', groupDescriptionEn: 'select', groupDescriptionHi: 'select', descriptionEn: 'Select', descriptionHi: 'select', sortOrder: 0, code: 'select'));
      education.insert(0, RangeCategoryDataModel(catKey: 'Select', groupDescriptionEn: 'select', groupDescriptionHi: 'select', descriptionEn: 'Select', descriptionHi: 'select', sortOrder: 0, code: 'select'));
      health.insert(0, RangeCategoryDataModel(catKey: 'Select', groupDescriptionEn: 'select', groupDescriptionHi: 'select', descriptionEn: 'Select', descriptionHi: 'select', sortOrder: 0, code: 'select'));
      occupationType.insert(0, RangeCategoryDataModel(catKey: 'Select', groupDescriptionEn: 'select', groupDescriptionHi: 'select', descriptionEn: 'Select', descriptionHi: 'select', sortOrder: 0, code: 'select'));
      schoolType.insert(0, RangeCategoryDataModel(catKey: 'Select', groupDescriptionEn: 'select', groupDescriptionHi: 'select', descriptionEn: 'Select', descriptionHi: 'select', sortOrder: 0, code: 'select'));

      cast.insert(0, RangeCategoryDataModel(catKey: 'Select', groupDescriptionEn: 'select', groupDescriptionHi: 'select', descriptionEn: 'Select', descriptionHi: 'select', sortOrder: 0, code: 'select'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFD42D3F),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1, color: Colors.grey.shade300),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
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
                  child:Stack(clipBehavior: Clip.none, children: [
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
                        top: -35, // Adjust the position as needed
                        left: 0,
                        right: 0,
                        child: Center(
                          child: _imageFile == null
                              ? InkWell(
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
                            onTap: _pickImage,
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
                  ]),
                ),
                SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: Row(
                    children: [
                      _buildPreviousButton(),
                      SizedBox(width: 8),
                      _buildEditButton(),
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
      ],
    );
  }

  Widget _stepIndicator(int step) {
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
                personalInfoEditable, _placeOfBirthFocus),
            SizedBox(height: 10),

            // Control this flag to enable/disable fields

            Row(
              children: [
                // Dependent Persons Column
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 0.0),
                    // Gap of 5 to the right for the first column
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // Align children to the start of the column
                      children: [
                        Text(
                          'Dependent Persons',
                          style: TextStyle(fontSize: 13),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 1),
                        // Add some spacing between the Text and Container
                        Container(
                          height: 55,
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
                            style: TextStyle(color: Colors.black, fontSize: 13),
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
                                : null, // Disable onChanged when isEnabled is false
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
                ),
                SizedBox(width: 10), // Gap of 10 between the two columns

                // Reservation Category Column
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    // Gap of 5 to the left for the second column
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // Align children to the start of the column
                      children: [
                        _buildTextField(
                          'Reservation Category',
                          resCatController,
                          personalInfoEditable,
                          _resCatFocus,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

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
                          style: TextStyle(fontSize: 13),
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
                            style: TextStyle(color: Colors.black, fontSize: 13),
                            underline: Container(
                              height: 2,
                              color: Colors.transparent,
                            ),
                            onChanged: personalInfoEditable
                                ?(String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedReligionextra = newValue;
                                });
                              }
                            }: null,
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
                          style: TextStyle(fontSize: 13),
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
                                  selectedCast =
                                      newValue; // Update the selected value
                                });
                              }
                            }: null,
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
                          style: TextStyle(fontSize: 13),
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
                            style: TextStyle(color: Colors.black, fontSize: 13),
                            underline: Container(
                              height: 2,
                              color: Colors.transparent,
                            ),
                            onChanged: personalInfoEditable
                                ?(String? newValue) {
                              setState(() {
                                selectedIsHandicap = newValue!;
                              });
                            }: null,
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
                SizedBox(width: 10), // Gap of 10 between the two columns

                // Special Ability Column
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    // Gap of 5 to the left for the second column
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // Align children to the start of the column
                      children: [
                        Text(
                          'Special Ability',
                          style: TextStyle(fontSize: 13),
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
                            style: TextStyle(color: Colors.black, fontSize: 13),
                            underline: Container(
                              height: 2,
                              color: Colors.transparent,
                            ),
                            onChanged: personalInfoEditable
                                ?(String? newValue) {
                              setState(() {
                                selectedspecialAbility = newValue!;
                                isSpecialSocialCategoryVisible =
                                (newValue == 'Yes'); // Update visibility
                              });
                            }: null,
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
              ],
            ),
            SizedBox(height: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Special Social Category',
                  style: TextStyle(fontSize: 13),
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
                    style: TextStyle(color: Colors.black, fontSize: 13),
                    underline: Container(
                      height: 2,
                      color: Colors.transparent,
                    ),
                    onChanged: personalInfoEditable
                        ?(String? newValue) {
                      setState(() {
                        selectedSpecialSocialCategory = newValue!;
                      });
                    }: null,
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
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),

            _buildTextField('Address1', address1ControllerP, personalInfoEditable,
                _address1FocusP),
            SizedBox(height: 10),

            _buildTextField('Address2', address2ControllerP, personalInfoEditable,
                _address2FocusP),
            SizedBox(height: 10),

            _buildTextField('Address3', address3ControllerP, personalInfoEditable,
                _address3FocusP),
            SizedBox(height: 10),
            _buildLabeledDropdownField(
              'Select State',
              'State',
              states,
              selectedStateextraP,
                  (RangeCategoryDataModel? newValue) {
                setState(() {
                  selectedDistrict=null;
                  selectedVillage=null;
                  selectedSubDistrict=null;

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
                  child: _buildTextField(
                      'City', cityControllerP, personalInfoEditable, _cityFocusP),
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
                  onChanged: _onCheckboxChanged,
                ),
                Text(
                  'Same as Permanent Address',
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Color(0xFFD42D3F), // Custom color
                  ),
                ),
              ],
            ),
            _buildTextField('Address1', address1ControllerC, personalInfoEditable,
                _address1FocusC),
            SizedBox(height: 10),

            _buildTextField('Address2', address2ControllerC, personalInfoEditable,
                _address2FocusC),
            SizedBox(height: 10),

            _buildTextField('Address3', address3ControllerC, personalInfoEditable,
                _address3FocusC),
            SizedBox(height: 10),

            _buildLabeledDropdownField(
              'Select State',
              'State',
              states,
              selectedStateextraC,
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
                  child: _buildTextField(
                      'City', cityControllerC, personalInfoEditable, _cityFocusC),
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
                          style: TextStyle(fontSize: 13),
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
                            style: TextStyle(color: Colors.black, fontSize: 13),
                            underline: Container(
                              height: 2,
                              color: Colors.transparent,
                            ),
                            onChanged: personalInfoEditable
                                ?(String? newValue) {
                              setState(() {
                                selectedIsHouseRental = newValue!;
                              });
                            }: null,
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
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildLabeledDropdownField(
                      'District',
                      'Districts',
                      listDistrictCodes,
                      selectedDistrict,
                          (PlaceData? newValue) {
                        setState(() {
                          selectedVillage=null;
                        selectedSubDistrict=null;

                          selectedDistrict = newValue;

                          getPlace("subdistrict", selectedStateextraP!.code, selectedDistrict!.distCode!, "");
                        });

                      },
                      String
                  ),
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
            ),
            Row(
              children: [
                Expanded(
                  child: _buildLabeledDropdownField(
                      'Village',
                      'Village',
                      listVillagesCodes,
                      selectedVillage,
                          (PlaceData? newValue) {
                        setState(() {
                          selectedVillage = newValue;
                        });
                      },
                      String
                  ),
                ),
                SizedBox(width: 16.0), // Optional spacing between the dropdown and the column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Residing for (Years)',
                        style: TextStyle(fontSize: 13),
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
                          style: TextStyle(color: Colors.black, fontSize: 13),
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
                        style: TextStyle(fontSize: 13),
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
                          style: TextStyle(color: Colors.black, fontSize: 13),
                          underline: Container(
                            height: 2,
                            color: Colors
                                .transparent, // Set to transparent to remove default underline
                          ),
                          onChanged: personalInfoEditable
                              ?(String? newValue) {
                            setState(() {
                              selectedProperty = newValue!;
                            });
                          }: null,
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
                          style: TextStyle(fontSize: 13),
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
                                  selectedPresentHouseOwner =
                                      newValue; // Update the selected value
                                });
                              }
                            }: null,
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
            _buildTextField(
                'Mother name', _motherFController, FiFamilyEditable, _motherFFocus),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Flexible(
                    child: _buildTextField('Middle Name', _motherMController,
                        FiFamilyEditable, _motherMFocus)),
                SizedBox(width: 13),
                // Add spacing between the text fields if needed
                Flexible(
                    child: _buildTextField('Last Name', _motherLController,
                        FiFamilyEditable, _motherLFocus)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'No. of Children',
              style: TextStyle(fontSize: 13),
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
                style: TextStyle(color: Colors.black, fontSize: 13),
                underline: Container(
                  height: 2,
                  color: Colors
                      .transparent, // Set to transparent to remove default underline
                ),
                onChanged: FiFamilyEditable?(String? newValue) {
                  setState(() {
                    selectednumOfChildren = newValue!;
                  });
                }:null,
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
              'Schooling Children',
              style: TextStyle(fontSize: 13),
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
                style: TextStyle(color: Colors.black, fontSize: 13),
                underline: Container(
                  height: 2,
                  color: Colors
                      .transparent, // Set to transparent to remove default underline
                ),
                onChanged: FiFamilyEditable?(String? newValue) {
                  setState(() {
                    selectedschoolingChildren = newValue!;
                  });
                }:null,
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
                value: selectedotherDependents,
                isExpanded: true,
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.black, fontSize: 13),
                underline: Container(
                  height: 2,
                  color: Colors
                      .transparent, // Set to transparent to remove default underline
                ),
                onChanged: FiFamilyEditable?(String? newValue) {
                  setState(() {
                    selectedotherDependents = newValue!;
                  });
                }:null,
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
                        style: TextStyle(fontSize: 13),
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
                          style: TextStyle(color: Colors.black, fontSize: 13),
                          underline: Container(
                            height: 2,
                            color: Colors.transparent, // Remove default underline
                          ),
                          onChanged: FiIncomeEditable?(String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedOccupation =
                                    newValue; // Update the selected value
                              });
                            }
                          }:null,
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
                        style: TextStyle(fontSize: 13),
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
                          style: TextStyle(color: Colors.black, fontSize: 13),
                          underline: Container(
                            height: 2,
                            color: Colors.transparent, // Remove default underline
                          ),
                          onChanged: FiIncomeEditable?(String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedBusiness =
                                    newValue; // Update the selected value
                              });
                            }
                          }:null,
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
                      'Current EMI Amount',
                      _currentEMIController,
                      TextInputType.number,
                      FiIncomeEditable,
                      _currentEMIFocus),
                ),
                SizedBox(width: 10), // Spacing between the two columns
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Home Type',
                        style: TextStyle(fontSize: 13),
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
                          style: TextStyle(color: Colors.black, fontSize: 13),
                          underline: Container(
                            height: 2,
                            color: Colors.transparent,
                          ),
                          onChanged: FiIncomeEditable?(String? newValue) {
                            setState(() {
                              selectedHomeType = newValue!;
                            });
                          }:null,
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
                        style: TextStyle(fontSize: 13),
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
                          style: TextStyle(color: Colors.black, fontSize: 13),
                          underline: Container(
                            height: 2,
                            color: Colors.transparent,
                          ),
                          onChanged: FiIncomeEditable?(String? newValue) {
                            setState(() {
                              selectedRoofType = newValue!;
                            });
                          }:null,
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
                        style: TextStyle(fontSize: 13),
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
                          style: TextStyle(color: Colors.black, fontSize: 13),
                          underline: Container(
                            height: 2,
                            color: Colors.transparent,
                          ),
                          onChanged: FiIncomeEditable?(String? newValue) {
                            setState(() {
                              selectedToiletType = newValue!;
                            });
                          }:null,
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
                        'Living With Spouse',
                        style: TextStyle(fontSize: 13),
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
                          style: TextStyle(color: Colors.black, fontSize: 13),
                          underline: Container(
                            height: 2,
                            color: Colors.transparent,
                          ),
                          onChanged: FiIncomeEditable?(String? newValue) {
                            setState(() {
                              selectedLivingWithSpouse = newValue!;
                            });
                          }:null,
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
                        'No of Earning Member',
                        style: TextStyle(fontSize: 13),
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
                          style: TextStyle(color: Colors.black, fontSize: 13),
                          underline: Container(
                            height: 2,
                            color: Colors.transparent,
                          ),
                          onChanged: FiIncomeEditable?(String? newValue) {
                            setState(() {
                              selectedEarningMembers = newValue!;
                            });
                          }:null,
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
              style: TextStyle(fontSize: 13),
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
                style: TextStyle(color: Colors.black, fontSize: 13),
                underline: Container(
                  height: 2,
                  color: Colors.transparent,
                ),
                onChanged: FiIncomeEditable?(String? newValue) {
                  setState(() {
                    selectedBusinessExperience = newValue!;
                  });
                }:null,
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
                          _future_IncomeFocus),
                    ),
                    Flexible(
                      child: _buildTextField2(
                          'Agriculture Income',
                          _agriculture_incomeController,
                          TextInputType.number,
                          FiIncomeEditable,
                          _agriculture_incomeFocus),
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
                          _any_RentalIncomeFocus),
                    ),
                    Flexible(
                      child: _buildTextField2(
                          'Annual Income',
                          _annuaL_INCOMEController,
                          TextInputType.number,
                          FiIncomeEditable,
                          _annuaL_INCOMEFocus),
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
                          _other_IncomeFocus),
                    ),
                    Flexible(
                      child: _buildTextField2(
                          'Pension Income',
                          _pensionIncomeController,
                          TextInputType.number,
                          FiIncomeEditable,
                          _pensionIncomeFocus),
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
                          _otheR_THAN_AGRICULTURAL_INCOMEFocus),
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
                  'EXPENSES',
                  style: TextStyle(
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
                      child: _buildTextField2('Rent', _rentController,
                          TextInputType.number, FiIncomeEditable, _rentFocus),
                    ),
                    Flexible(
                      child: _buildTextField2('Food', _foodingController,
                          TextInputType.number, FiIncomeEditable, _foodingFocus),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: _buildTextField2('Education', _educationController,
                          TextInputType.number, FiIncomeEditable, _educationFocus),
                    ),
                    Flexible(
                      child: _buildTextField2('Health', _healthController,
                          TextInputType.number, FiIncomeEditable, _healthFocus),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: _buildTextField2('Travelling', _travellingController,
                          TextInputType.number, FiIncomeEditable, _travellingFocus),
                    ),
                    Flexible(
                      child: _buildTextField2(
                          'Entertainment',
                          _entertainmentController,
                          TextInputType.number,
                          FiIncomeEditable,
                          _entertainmentFocus),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: _buildTextField2(
                          'Expense On Children',
                          _spendOnChildrenController,
                          TextInputType.number,
                          FiIncomeEditable,
                          _spendOnChildrenFocus),
                    ),
                    Flexible(
                      child: _buildTextField2('Others', _othersController,
                          TextInputType.number, FiIncomeEditable, _othersFocus),
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
            'Bank Type',
            style: TextStyle(fontSize: 13),
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
              style: TextStyle(color: Colors.black, fontSize: 13),
              underline: Container(
                height: 2,
                color: Colors.transparent,
              ),
              onChanged: FinancialInfoEditable?(String? newValue) {
                setState(() {
                  selectedAccountType = newValue!;
                });
              }:null,
              items: accType.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Text(
            'BANK NAME',
            style: TextStyle(fontSize: 13),
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
              value: selectedBankName,
              isExpanded: true,
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.black, fontSize: 13),
              underline: Container(
                height: 2,
                color: Colors.transparent,
              ),
              onChanged: FinancialInfoEditable?(String? newValue) {
                setState(() {
                  selectedBankName = newValue!;
                });
              }:null,
              items: bankNamesList.map((BankNamesDataModel value) {
                return DropdownMenuItem<String>(
                  value: value.bankName,
                  child: Text(value.bankName),
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
                          FinancialInfoEditable, _bank_IFCSFocus),
                      _buildTextField2(
                        'BANK ACCOUNT',
                        _bank_AcController,
                        TextInputType.number,
                        FinancialInfoEditable,
                        _bank_AcFocus,
                      ),
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
                          onPressed: FinancialInfoEditable?() {
                            if (_bank_AcController.text.isEmpty ||
                                _bank_IFCSController.text.isEmpty) {
                              showToast_Error(
                                  "Please Enter Bank Account number and IFSC code");
                            } else {
                              docVerifyIDC("bankaccount", _bank_AcController.text,
                                  _bank_IFCSController.text, "");

                              ifscVerify(context, _bank_IFCSController.text);
                            }
                          }:null,
                          child: Text(
                            bankAccHolder == null
                                ? 'VERIFY NAME'
                                : 'VERIFY ADDRESS',
                            style: TextStyle(fontSize: 18), // Text size
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
                  text: 'ACC. HOLDER NAME:',
                  style: TextStyle(color: Colors.black, fontSize: 13),
                ),
                TextSpan(
                  text: " ${bankAccHolder}",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
              : SizedBox(),
          bankAddress != null
              ? Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'BANK ADDRESS:',
                  style: TextStyle(color: Colors.black, fontSize: 13),
                ),
                TextSpan(
                  text: " ${bankAddress}",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
              : SizedBox(),

          SizedBox(height: 10),

          Text(
            'BANK OPENING DATE',
            style: TextStyle(fontSize: 13),
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
          _buildTextField(
              'Name', _femNameController, femMemIncomeEditable, _femNameFocus),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Flexible(
                child: _buildTextField2('Age', _AgeController,
                    TextInputType.number, femMemIncomeEditable, _AgeFocus),
              ),
              SizedBox(width: 10), // Adds space between the fields
              Flexible(
                child: _buildTextField2('Income', _IncomeController,
                    TextInputType.number, femMemIncomeEditable, _IncomeFocus),
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
                      style: TextStyle(fontSize: 13),
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
                        style: TextStyle(color: Colors.black, fontSize: 13),
                        underline: Container(
                          height: 2,
                          color: Colors.transparent,
                        ),
                        onChanged: femMemIncomeEditable?(String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              femselectedGender =
                                  newValue; // Update the selected value
                            });
                          }
                        }:null,
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
                      'Relation With Borrower',
                      style: TextStyle(fontSize: 13),
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
                        style: TextStyle(color: Colors.black, fontSize: 13),
                        underline: Container(
                          height: 2,
                          color: Colors.transparent,
                        ),
                        onChanged: femMemIncomeEditable?(String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              femselectedRelationWithBorrower =
                                  newValue; // Update the selected value
                            });
                          }
                        }:null,
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
                      style: TextStyle(fontSize: 13),
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
                        style: TextStyle(color: Colors.black, fontSize: 13),
                        underline: Container(
                          height: 2,
                          color: Colors.transparent,
                        ),
                        onChanged: femMemIncomeEditable?(String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              femselectedHealth =
                                  newValue; // Update the selected value
                            });
                          }
                        }:null,
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
                      style: TextStyle(fontSize: 13),
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
                        style: TextStyle(color: Colors.black, fontSize: 13),
                        underline: Container(
                          height: 2,
                          color: Colors.transparent,
                        ),
                        onChanged: femMemIncomeEditable?(String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              femselectedEducation =
                                  newValue; // Update the selected value
                            });
                          }
                        }:null,
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
                      style: TextStyle(fontSize: 13),
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
                        style: TextStyle(color: Colors.black, fontSize: 13),
                        underline: Container(
                          height: 2,
                          color: Colors.transparent,
                        ),
                        onChanged: femMemIncomeEditable?(String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              femselectedSchoolType =
                                  newValue; // Update the selected value
                            });
                          }
                        }:null,
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
                      style: TextStyle(fontSize: 13),
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
                        style: TextStyle(color: Colors.black, fontSize: 13),
                        underline: Container(
                          height: 2,
                          color: Colors.transparent,
                        ),
                        onChanged: femMemIncomeEditable?(String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              femselectedBusiness =
                                  newValue; // Update the selected value
                            });
                          }
                        }:null,
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
                      style: TextStyle(fontSize: 13),
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
                        style: TextStyle(color: Colors.black, fontSize: 13),
                        underline: Container(
                          height: 2,
                          color: Colors.transparent,
                        ),
                        onChanged: femMemIncomeEditable?(String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              femselectedBusinessType =
                                  newValue; // Update the selected value
                            });
                          }
                        }:null,
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
                      style: TextStyle(fontSize: 13),
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
                        style: TextStyle(color: Colors.black, fontSize: 13),
                        underline: Container(
                          height: 2,
                          color: Colors.transparent,
                        ),
                        onChanged:femMemIncomeEditable? (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              femselectedIncomeType =
                                  newValue; // Update the selected value
                            });
                          }
                        }:null,
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
            children: [
              Flexible(
                  child: _buildTextField2('Aadhaar Id', _aadharIdController,
                      TextInputType.number, GuarantorEditable, _aadharIdFocus)),
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
                    Text(
                      'Title',
                      style: TextStyle(fontSize: 13),
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
                        style: TextStyle(color: Colors.black, fontSize: 13),
                        underline: Container(
                          height: 2,
                          color: Colors
                              .transparent, // Set to transparent to remove default underline
                        ),
                        onChanged:GuarantorEditable? (String? newValue) {
                          setState(() {
                            selectedTitle = newValue!;
                          });
                        }:null,
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
                child: _buildTextField(
                    'Name', _fnameController, GuarantorEditable, _fnameFocus),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                  child: _buildTextField(
                    'Middle Name',
                    _mnameController,
                    GuarantorEditable,
                    _mnameFocus,
                  )),
              SizedBox(width: 13),
              // Add spacing between the text fields if needed
              Flexible(
                  child: _buildTextField('Last Name', _lnameController,
                      GuarantorEditable, _lnameFocus)),
            ],
          ),
          _buildTextField2('Guardian Name', _guardianController,
              TextInputType.name, GuarantorEditable, _guardianFocus),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gender',
                      style: TextStyle(fontSize: 13),
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
                        style: TextStyle(color: Colors.black, fontSize: 13),
                        underline: Container(
                          height: 2,
                          color: Colors
                              .transparent, // Set to transparent to remove default underline
                        ),
                        onChanged:GuarantorEditable? (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              genderselected =
                                  newValue; // Update the selected value
                            });
                          }
                        }:null,
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
                      style: TextStyle(fontSize: 13),
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
                        style: TextStyle(color: Colors.black, fontSize: 13),
                        underline: Container(
                          height: 2,
                          color: Colors
                              .transparent, // Set to transparent to remove default underline
                        ),
                        onChanged: GuarantorEditable?(String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              relationselected =
                                  newValue; // Update the selected value
                            });
                          }
                        }:null,
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
            style: TextStyle(fontSize: 13),
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
              style: TextStyle(color: Colors.black, fontSize: 13),
              underline: Container(
                height: 2,
                color: Colors
                    .transparent, // Set to transparent to remove default underline
              ),
              onChanged: GuarantorEditable?(String? newValue) {
                if (newValue != null) {
                  setState(() {
                    religionselected = newValue; // Update the selected value
                  });
                }
              }:null,
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
              GuarantorEditable, _phoneFocus),
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
                      style: TextStyle(fontSize: 13),
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
                      style: TextStyle(fontSize: 13),
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
                            child: _buildTextField('PAN No', _panController,
                                GuarantorEditable, _panFocus),
                          ),
                          SizedBox(width: 10),
                          Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: GestureDetector(
                                onTap: () {
                                  verifyDocs(context, _panController.text,
                                      "pancard", "", "");
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                    iconPan, // Use the state variable for color
                                  ),
                                  child: Icon(
                                    iconPan == Colors.green
                                        ? Icons.check_circle
                                        : Icons.check_circle_outline,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: _buildTextField('Driving License', _dlController,
                                GuarantorEditable, _dlFocus),
                          ),
                          SizedBox(width: 10),
                          Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: GestureDetector(
                                onTap: () {
                                  verifyDocs(context, _dlController.text,
                                      "drivinglicense", "", "");
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                    iconDl, // Use the state variable for color
                                  ),
                                  child: Icon(
                                    iconDl == Colors.green
                                        ? Icons.check_circle
                                        : Icons.check_circle_outline,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        'OR',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFD42D3F), // Set the text color to red
                        ),
                        textAlign: TextAlign.center, // Center the text
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: _buildTextField('Voter Id', _voterController,
                                GuarantorEditable, _voterFocus),
                          ),
                          SizedBox(width: 10),
                          Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: GestureDetector(
                                onTap: () {
                                  verifyDocs(context, _voterController.text,
                                      "voterid", "", _dobController.text);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                    iconVoter, // Use the state variable for color
                                  ),
                                  child: Icon(
                                    iconVoter == Colors.green
                                        ? Icons.check_circle
                                        : Icons.check_circle_outline,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                        ],
                      )
                    ],
                  ),
                )),
          ),
          SizedBox(height: 10),
          _buildTextField('Address 1', _p_Address1Controller, GuarantorEditable,
              _p_Address1Focus),
          SizedBox(height: 10),
          _buildTextField('Address 2', _p_Address2Controller, GuarantorEditable,
              _p_Address2Focus),
          SizedBox(height: 10),
          _buildTextField('Address 3', _p_Address3Controller, GuarantorEditable,
              _p_Address3Focus),
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
              'Select State', 'State', states, stateselected,
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
                      GuarantorEditable, _p_CityFocus)),
              SizedBox(width: 10),
              Flexible(
                  child: _buildTextField2('Pincode', _pincodeController,
                      TextInputType.number, GuarantorEditable, _pincodeFocus)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepSeven() {
    return SingleChildScrollView(
      child: Container(
          height: MediaQuery.of(context).size.height - 250,
          width: double.infinity, // Set the width to the full screen size
          child: SingleChildScrollView(
            child: _isPageLoading
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildKycDocumentList(), // Call the function here
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
    return Flexible(
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
          }
        },

        child: Text(
          "PREVIOUS",
          style: TextStyle(color: Colors.white, fontSize: 13),
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

        onPressed: (){
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
            setState(() {
              GuarantorEditable = true;
            });
          } else if (_currentStep == 6) {
            setState(() {
              UploadFiDocsEditable = true;
            });
          }
        },
        child: Text(
          _isEditing ? "SAVE" : "EDIT",
          style: TextStyle(color: Colors.white, fontSize: 13),
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
          if (_currentStep == 0) {
          setState(() {
            _currentStep+=6;
          });
          }else
          if (_currentStep == 0) {
            if (_stepOneValidations()) {
              AddFiExtraDetail(context);
            }
          }
          else if (_currentStep == 1) {
            if (_stepTwoValidations()) {
              AddFiFamilyDetail(context);
            }
          }
          else if (_currentStep == 2) {

            if(_stepThreeValidations()) {
              AddFiIncomeAndExpense(context);
            }
          }
          else if (_currentStep == 3) {

            if(_stepFourValidations()){
              AddFinancialInfo(context);
            }
          }
          else if (_currentStep == 4) {

            if(_stepFiveValidations()) {
              FiFemMemIncome(context);
            }
          }
          else if (_currentStep == 5) {
            if(_stepSixValidations()) {
              saveGuarantorMethod(context);
            }
          }
          else if (_currentStep == 6) {
            setState(() {});
          }
        },
        child: Text(
          _currentStep == 6 ? "SUBMIT" : "NEXT",
          style: TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool saved, FocusNode FN) {
    return Container(
      //margin: EdgeInsets.symmetric(vertical: 4),
      // padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
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
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTextField2(String label, TextEditingController controller, TextInputType inputType, bool saved, FocusNode FN) {
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
              fontSize: 13,
            ),
          ),
          SizedBox(height: 1),
          Container(
            width: double.infinity, // Set the desired width
            //height: 45, // Set the desired height
            child: Center(
              child: TextFormField(
                enabled: saved,
                controller: controller,
                focusNode: FN,
                keyboardType: inputType,
                // Set the input type
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({required String title, String? path, int? id, String? GrNo, required Function(File) onImagePicked,
  }) {
    String baseUrl = 'https://predeptest.paisalo.in:8084';

    // Replace the front part of the file path and ensure the path uses forward slashes
    String? modifiedPath = path?.replaceAll(r'D:\', '').replaceAll(r'\\', '/');

    // Join the base URL with the modified path
    String finalUrl = '$baseUrl/$modifiedPath';
    print("path $path");
    print("modifiedPath $modifiedPath");
    print("finalURL $finalUrl");

    File? _selectedImage;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return GestureDetector(
          onTap: () async {
            File? pickedImage = await GlobalClass().pickImage();
            if (pickedImage != null) {
              setState(() {
                _selectedImage = pickedImage;
                onImagePicked(pickedImage); // Update the image path
              });
            }
          },
          child: Card(
            color: path!.isNotEmpty? Colors.green :Colors.yellowAccent.shade700,
            // Set color based on path
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                      return Icon(
                        Icons.hide_image_outlined,
                        size: 30,
                      );
                    },
                  )
                      : Image.asset(
                    'assets/Images/rupees.png',
                    width: 50,
                    height: 50,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        color: path.isNotEmpty? Colors.white:Colors.black), // Change text color if needed
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.upload,
                      size: 30,
                    ),
                    onPressed: () {
                      UploadFiDocs(context, title, _selectedImage, GrNo, id);
                      print('Title: $title');
                      print('Path: $path');

                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildKycDocumentList() {
    List<Widget> listItems = [];

    if (_isPageLoading) {
      KycScanningDataModel doc = getData.data;

      listItems.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Borrower Docs",
            style: TextStyle(fontSize: 13),
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
              adhaarFront = file;
            }));
        listItems.add(_buildListItem(
            title: "Aadhar Back",
            path: doc.aadharBPath,
            id: 27,
            GrNo: '0',
            onImagePicked: (File file) {
              adhaarBack = file;
            }));
      }

      if (doc.voterExists == true) {
        listItems.add(_buildListItem(
            title: "Voter Front",
            path: doc.voterPath,
            id: 3,
            GrNo: '0',
            onImagePicked: (File file) {
              voterFront = file;
            }));
        listItems.add(_buildListItem(
            title: "Voter Back",
            path: doc.voterBPath,
            id: 26,
            GrNo: '0',
            onImagePicked: (File file) {
              voterback = file;
            }));
      }

      if (doc.panExists == true) {
        listItems.add(_buildListItem(
            title: "Pan Front",
            path: doc.panPath,
            id: 4,
            GrNo: '0',
            onImagePicked: (File file) {
              panFront = file;
            }));
      }

      if (doc.drivingExists == true) {
        listItems.add(_buildListItem(
            title: "DL Front",
            path: doc.drivingPath,
            id: 15	,
            GrNo: '0',
            onImagePicked: (File file) {
              dlFront = file;
            }));
      }
      if (doc.passportExists == true) {
        listItems.add(_buildListItem(
            title: "Passport",
            path: doc.passportPath,
            id: doc.passportCheckListId,
            GrNo: '0',
            onImagePicked: (File file) {
              passport = file;
            }));
      }

      if (doc.passBookExists == true) {
        listItems.add(_buildListItem(
            title: "Passbook Front",
            path: doc.passBookPath,
            id: 2,
            GrNo: '0',
            onImagePicked: (File file) {
              passbook = file;
            }));
      }

      for (var grDoc in doc.grDocs) {
        // Add Guarantor Docs title
        listItems.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Guarantor " + grDoc.grSno + " Docs",
              style: TextStyle(fontSize: 13),
            ),
          ),
        );

        if (grDoc.addharExists == true) {
          listItems.add(_buildListItem(
              title: "Aadhar Front",
              path: grDoc.aadharPath,
              id: 7,
              GrNo: grDoc.grSno,
              onImagePicked: (File file) {
                passbook = file;
              }));
          listItems.add(_buildListItem(
              title: "Aadhar Back",
              path: grDoc.aadharBPath,
              id: 7,
              GrNo: grDoc.grSno,
              onImagePicked: (File file) {
                passbook = file;
              }));
        }

        if (grDoc.voterExists == true) {
          listItems.add(_buildListItem(
              title: "Voter Front",
              path: grDoc.voterPath,
              id: 5,
              GrNo: grDoc.grSno,
              onImagePicked: (File file) {
                passbook = file;
              }));
          listItems.add(_buildListItem(
              title: "Voter Back",
              path: grDoc.voterBPath,
              id: 5,
              GrNo: grDoc.grSno,
              onImagePicked: (File file) {
                passbook = file;
              }));
        }

        if (grDoc.panExists == true) {
          listItems.add(_buildListItem(
              title: "Pan Front",
              path: grDoc.panPath,
              id: 8,
              GrNo: grDoc.grSno,
              onImagePicked: (File file) {
                passbook = file;
              }));
        }

        if (grDoc.drivingExists == true) {
          listItems.add(_buildListItem(
              title: "DL Front",
              path: grDoc.drivingPath,
              id: 16,
              GrNo: grDoc.grSno,
              onImagePicked: (File file) {
                passbook = file;
              }));
        }
      }
    } else {
      listItems.add(
        Center(
          child: CircularProgressIndicator(
            color: Color(0xFFD42D3F),
          ),
        ),
      );
    }
    return listItems;
  }

  Widget _buildLabeledDropdownField<T>(String labelText, String label, List<T> items, T? selectedValue, ValueChanged<T?>? onChanged, Type objName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              labelText,
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: double.infinity, // Ensure the dropdown takes the full width available
              child: DropdownButtonFormField<T>(
                isExpanded: true, // Ensure the dropdown expands to fit its content
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
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
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

  void _pickImage() async {
    File? pickedImage = await GlobalClass().pickImage();
    if (pickedImage != null) {
      setState(() {
        _imageFile = pickedImage;
      });
    }
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
          _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
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
                      getDataFromOCR("adharBack", context);
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
                        setQRData(result);

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

  bool _stepOneValidations() {
    if (emailIdController.text.isEmpty) {
      showToast_Error("Please enter Email ID");
      _emailIdFocus.requestFocus();
      return false;
    } else if (placeOfBirthController.text.isEmpty) {
      showToast_Error("Please enter Place of Birth");
      _placeOfBirthFocus.requestFocus();
      return false;
    } else if (selectedDependent == null||selectedDependent!.toLowerCase() == "select") {
      showToast_Error("Please select Dependents");
      return false;
    }else if (selectedReligionextra == null||selectedReligionextra!.toLowerCase() == "select") {
      showToast_Error("Please select Religion");
      return false;
    }else if (selectedCast == null||selectedCast!.toLowerCase() == "select") {
      showToast_Error("Please select Dependents");
      return false;
    }else if (resCatController.text.isEmpty) {
      showToast_Error("Please enter Residence Category");
      _resCatFocus.requestFocus();
      return false;
    } else if (mobileController.text.isEmpty) {
      showToast_Error("Please enter Mobile Number");
      _mobileFocus.requestFocus();
      return false;
    } else if (selectedIsHandicap == null||selectedIsHandicap!.toLowerCase() == "select") {
      showToast_Error("Please select Is Handicap");
      return false;
    }else if (selectedspecialAbility == null||selectedspecialAbility!.toLowerCase() == "select") {
      showToast_Error("Please select Dependents");
      return false;
    }else if (selectedSpecialSocialCategory == null||selectedSpecialSocialCategory!.toLowerCase() == "select") {
      showToast_Error("Please select Special Social Category");
      return false;
    }else if (address1ControllerP.text.isEmpty) {
      showToast_Error("Please enter Address Line 1 (Permanent)");
      _address1FocusP.requestFocus();
      return false;
    } /*else if (address2ControllerP.text.isEmpty) {
      showToast_Error("Please enter Address Line 2 (Permanent)");
      _address2FocusP.requestFocus();
      return false;
    } else if (address3ControllerP.text.isEmpty) {
      showToast_Error("Please enter Address Line 3 (Permanent)");
      _address3FocusP.requestFocus();
      return false;
    }*/ else if (selectedStateextraP == null ||
        selectedStateextraP!.descriptionEn.isEmpty ||
        selectedStateextraP!.descriptionEn.toLowerCase() == 'select') {
      showToast_Error('Please select permanent state');
      return false;
    }else if (address1ControllerC.text.isEmpty) {
      showToast_Error("Please enter Address Line 1 (Current)");
      _address1FocusC.requestFocus();
      return false;
    } /*else if (address2ControllerC.text.isEmpty) {
      showToast_Error("Please enter Address Line 2 (Current)");
      _address2FocusC.requestFocus();
      return false;
    } else if (address3ControllerC.text.isEmpty) {
      showToast_Error("Please enter Address Line 3 (Current)");
      _address3FocusC.requestFocus();
      return false;
    }*/else if (selectedStateextraC == null||selectedStateextraC!.descriptionEn.isEmpty||selectedStateextraC!.descriptionEn.toLowerCase() == "select") {
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
      showToast_Error("Please Select Schooling Children");
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
    } else if (_currentEMIController.text.isEmpty) {
      showToast_Error("Please Enter Current EMIs Amount");
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
    } else if (selectedBankName == null ||
        selectedBankName!.isEmpty ||
        selectedBankName!.toLowerCase() == 'select') {
      showToast_Error("Please Enter Bank Name");
      return false;
    } else if (_bank_IFCSController.text.isEmpty) {
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
    } /*else if (_mnameController.text.isEmpty) {
      showToast_Error("Please Enter Middle Name");
      _mnameFocus.requestFocus();
      return false;
    } else if (_lnameController.text.isEmpty) {
      showToast_Error("Please Enter Last Name");
      _lnameFocus.requestFocus();
      return false;
    }*/
    else if (_phoneController.text.isEmpty) {
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
    } /*if (_voterController.text.isEmpty) {
      if (_panController.text.isEmpty) {
        showToast_Error("Please Enter PAN");
        _panFocus.requestFocus();
        return false;
      } else if (_dlController.text.isEmpty) {
        showToast_Error("Please Enter Driving License");
        _dlFocus.requestFocus();
        return false;
      }
      return false;
    }*/
    else if (_p_Address1Controller.text.isEmpty) {
      showToast_Error("Please Enter Address Line 1");
      _p_Address1Focus.requestFocus();
      return false;
    } /*else if (_p_Address2Controller.text.isEmpty) {
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

    } else if (stateselected == null  ||
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
      showToast_Error("Gurrantor Image Is Null");
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
      "reservatioN_CATEGORY": resCatController.text,
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
      "district": selectedDistrict!.distName,
      "sub_District": selectedSubDistrict!.subDistName,
      "village": selectedVillage!.villageName,
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
        showAlertDialog(context, "Failed to update details. Please try again.");
      }
    }).catchError((error){
      EasyLoading.dismiss();
      showAlertDialog(context, error);

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
    String motheR_MAIDEN_NAME = "ghjfg";
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
    }).catchError((error){

    });
  }

  Future<void> AddFinancialInfo(BuildContext context) async {
    EasyLoading.show(
      status: 'Loading...',
    );

    String Fi_ID = FIID.toString();
    String bankType = selectedAccountType.toString();
    String bank_name = selectedBankName.toString();

    String bank_Ac = _bank_AcController.text.toString();
    String bank_IFCS = _bank_IFCSController.text.toString();
    String bank_address = bankAddress!;
    String bankOpeningDate = _bankOpeningDateController.text.toString();

    final api = Provider.of<ApiService>(context, listen: false);

    Map<String, dynamic> requestBody = {
      "Fi_ID": Fi_ID,
      "bankType": bankType,
      "bank_Ac": bank_Ac,
      "bank_name": bank_name,
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
        }else {
          showToast_Error(value.data[0].errormsg);
          EasyLoading.dismiss();
        }
      }).catchError((error){
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
      }else {
        showToast_Error(value.data[0].errormsg);
        EasyLoading.dismiss();
      }
    }).catchError((error){
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
        });
        EasyLoading.dismiss();
      } else {
        showToast_Error(value.data[0].errormsg);
        EasyLoading.dismiss();
      }
    }).catchError((error){
      showToast_Error(error);
      EasyLoading.dismiss();
    });
  }



  Future<void> GetDocs(BuildContext context) async {
    print("111object");
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
      } else {
        EasyLoading.dismiss();
      }
    });
  }

  Future<void> UploadFiDocs(BuildContext context, String? tittle, File? file,
      String? grNo, int? checklistid) async {
    EasyLoading.show(
      status: 'Loading...',
    );
    if(file==null){
        GlobalClass.showUnsuccessfulAlert(context, "Please upload $tittle", 1);
    }else{

      final api = Provider.of<ApiService>(context, listen: false);
//https://predeptest.paisalo.in:8084/LOSDOC//FiDocs//38//FiDocuments//VoterIDBorrower0711_2024_43_01.png

      /* String baseUrl = 'https://predeptest.paisalo.in:8084';

    // Replace the front part of the file path and ensure the path uses forward slashes
    String? modifiedPath = path?.replaceAll(r'D:\', '').replaceAll(r'\\', '/');

    // Join the base URL with the modified path
    String finalUrl = '$baseUrl/$modifiedPath';
    File file = File(finalUrl);*/
      return await api
          .uploadFiDocs(GlobalClass.token, GlobalClass.dbName, FIID.toString(),
          int.parse(grNo!), checklistid!, tittle.toString(), file!)
          .then((value) async {
        if (value.statuscode == 200) {
          GetDocs(context);
          /*setState(() {
          _currentStep += 1;
          Fi_Id = value.data[0].fiId.toString();
        });*/
          EasyLoading.dismiss();
        } else {
          EasyLoading.dismiss();
        }
      });
    }
    EasyLoading.dismiss();
  }

  Future<void> verifyDocs(BuildContext context, String idNoController, String type, String ifsc, String dob) async {
    EasyLoading.show(
      status: 'Loading...',
    );

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
          bankAccHolder = value.data.fullName.toString();
        });
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
      }
    });
  }

  void docVerifyIDC(String type, String txnNumber, String ifsc, String dob) async {
    apiService_idc=ApiService.create(baseUrl: ApiConfig.baseUrl4);

    EasyLoading.show(
      status: 'Loading...',
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
        if (type == "bankaccount") {
          setState(() {
            if (response["error"] == null) {
              bankAccHolder = "${responseData['full_name']}";
            } else {
              bankAccHolder = "Account no. is Not Verified!!";
            }
          });
        } else {}
        showToast_Error("Unexpected Response: $response");
        print("Unexpected Response: $response");
        EasyLoading.dismiss();
      }
      EasyLoading.dismiss();
    } catch (e) {
      showToast_Error("An error occurred: $e");

      EasyLoading.dismiss();
    }
  }

  Future<void> ifscVerify(BuildContext context, String ifsc) async {
    EasyLoading.show(
      status: 'Loading...',
    );

    final api = ApiService.create(baseUrl: ApiConfig.baseUrl3);

    return await api.ifscVerify(ifsc).then((value) {
      if (value != null && value.address != null) {
        setState(() {
          bankAddress = value.address.toString();
        });
        EasyLoading.dismiss();
      } else {
        print('Failed to get valid data');
        EasyLoading.dismiss();
      }
    }).catchError((error) {
      print('Error occurred: $error');
    });
  }

  Future<void> _BabnkNamesAPI(BuildContext context) async {
    EasyLoading.show(status: 'Loading...');

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
        showToast_Error("Bank Name List Not Fetched");
      }
    });
  }

  Future<void> getAllDataApi(BuildContext context) async {
    EasyLoading.show(status: 'Loading...');

    final api = Provider.of<ApiService>(context, listen: false);

    return await api
        .dataByFIID(GlobalClass.token, GlobalClass.dbName, FIID)
        .then((value) async {
      if (value.statuscode == 200) {
        EasyLoading.dismiss();
        print("object112222");

        if(!value.data[0].placeOfBirth.isEmpty){
          personalInfo(value.data[0]);

        }
        if(!value.data[0].motheRFirstName.isEmpty){
          familyDetails(value.data[0]);
        }
       /* if(!value.data[0].occupation){

        }*/
        if(!value.data[0].bankAc.isEmpty){
          financialInfo(value.data[0]);
        }
        /*if(!value.data[0].health){

        }*/
        /*if(!value.data[0].grno.isEmpty){}*/

      } else {
        setState(() {});
      }
    }).catchError((err) {
      print("ERRORRRR$err");
      EasyLoading.dismiss();
    });
  }

  void personalInfo(getAllDataModel data) {

    setState(() {
      // FIID,
      emailIdController.text=data.emailId;
      placeOfBirthController.text =data.placeOfBirth;
      // selectedDependent
      // "gff"
      //   selectedReligionextra
      //   selectedCast,
      mobileController.text=data.pPhone;
      //  selectedIsHandicap  //  selectedspecialAbility,
      //  selectedIsHouseRental  //  selectedProperty,
      address1ControllerP.text=data.pAddress1;
      address2ControllerP.text=data.pAddress2;
      address3ControllerP.text=data.pAddress3;
      cityControllerP.text=data.pCity;
      //   selectedStateextraP,
      pincodeControllerP.text=data.pPincode;
      address1ControllerC.text=data.currentAddress1;
      address2ControllerC.text=data.currentAddress2;
      address3ControllerC.text=data.currentAddress3;
      cityControllerC.text=data.currentCity;
      //  selectedStateextraP,
      pincodeControllerC.text=data.currentPincode;
      //  selectedDistrict,
      //  selectedSubDistrict,
      //  selectedVillage,
      //  selectedResidingFor,
      //  selectedPresentHouseOwner
    });


  }

  void familyDetails(getAllDataModel data) {}

  void financialInfo(getAllDataModel data) {}

  Future<void> getDataFromOCR(String type, BuildContext context) async {
    EasyLoading.show();
    File? pickedImage = await GlobalClass().pickImage();

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
            if (response.data.relation.toLowerCase() == "father") {
              _guardianController.text = response.data.guardianName;
              setState(() {
                relationselected = "Father";
              });
              _p_CityController.text = response.data.cityName;
              stateselected = states.firstWhere((item) =>
              item.descriptionEn.toLowerCase() == response.data.stateName.toLowerCase());
              List<String> addressParts =
              response.data.address1.trim().replaceAll(response.data.pincode, "").replaceAll(response.data.stateName, "").split(",");
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

              /*List<String> guarNameParts =
              response.data.guardianName.trim().split(" ");
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
              }*/
            } else if (response.data.relation.toLowerCase() == "husband") {

              _guardianController.text = response.data.guardianName;
              setState(() {
                relationselected = "Husband";
              //  selectedMarritalStatus = "Married";
              });
              _p_CityController.text = response.data.cityName;
              List<String> addressParts =
              response.data.address1.trim().split(" ");
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
              /*List<String> guarNameParts =
              response.data.guardianName.trim().split(" ");
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
              }*/
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
      if(dataList[0].toLowerCase().startsWith("v")){
        _aadharIdController.text = dataList[2];
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
          stateselected = states.firstWhere((item) =>item.descriptionEn.toLowerCase() == dataList[13].toLowerCase());
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

      }else{

        _aadharIdController.text = dataList[1];
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
        _p_CityController.text= dataList[6];
        _guardianController.text= replaceCharFromName(dataList[5]);


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
    String title = titleselected;
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
    }).catchError((error){
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
        }
        else if (type == "village") {
          listVillagesCodes = response.data;
        }
      });

      //} else {}
    } catch (e) {
      print("Error: $e");
    }
  }

}
