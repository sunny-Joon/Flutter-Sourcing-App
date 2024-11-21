import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/GlobalClass.dart';
import 'package:flutter_sourcing_app/Models/KycScanningModel.dart';
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
  bool _isPageLoading = false;
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  bool fixtraEditable = true;
  bool FiIncomeEditable = true;
  bool FinancialInfoEditable = true;
  bool GuarantorEditable = true;
  bool UploadFiDocsEditable = true;
  bool FiFamilyEditable = true;
  bool femMemIncomeEditable = true;
  String pageTitle = "Personal Info";

  final _emailFocusNode = FocusNode();
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

  List<String> titleList = ["Select", "Mr.", "Mrs.", "Miss"];
  List<String> accType = ["Select", "Current", "Savings", "Salary"];
  String titleselected = "Select";
  String selectedTitle = "Select";
  String expense = "";
  String income = "";
  String lati = "";
  String longi = "";

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

  String? stateselected;
  String? relationselected;
  String? genderselected;
  String? religionselected;
  String? selectedLoanDuration;

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

//FIEXTRA
  String? selectedDependent;
  String? selectedReligionextra;
  String? selectedCast;
  String? selectedIsHandicap;
  String? selectedspecialAbility;
  String? selectedSpecialSocialCategory;
  String? selectedStateextraP;
  String? selectedStateextraC;
  String? selectedDistrict;
  String? selectedSubDistrict;
  String? selectedVillage;
  String? selectedResidingFor;
  String? selectedProperty;
  String? selectedPresentHouseOwner;
  String? selectedIsHouseRental;

  //FEM MEM INCOME
  String? femselectedGender;
  String? femselectedRelationWithBorrower;
  String? femselectedHealth;
  String? femselectedEducation;
  String? femselectedSchoolType;
  String? femselectedBusiness;
  String? femselectedBusinessType;
  String? femselectedIncomeType;

  String? selectedAccountType;
  Color iconPan = Colors.red;
  Color iconDl = Colors.red;
  Color iconVoter = Colors.red;

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

  // AddFiFamilyDetail
  final _motherFController = TextEditingController();
  final _motherMController = TextEditingController();
  final _motherLController = TextEditingController();
  final _schoolingChildrenController = TextEditingController();
  final _numOfChildrenController = TextEditingController();
  final _otherDependentsController = TextEditingController();

  final loanAmountController = TextEditingController();
  final _femNameController = TextEditingController();
  final _IncomeController = TextEditingController();
  final _AgeController = TextEditingController();

  @override
  void initState() {
    super.initState();
     GetDocs(context, widget.selectedData.id);
    initializeData(); // Fetch initial data
    _emailFocusNode.addListener(_validateEmail);
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
    // _dobController.addListener(() {
    _calculateAge();
    // Fetch initial data
    selectedDependent = onetonine.isNotEmpty ? onetonine[0] : null;
    selectedResidingFor = onetonine.isNotEmpty ? onetonine[0] : null;
    selectedspecialAbility = trueFalse.isNotEmpty ? trueFalse[0] : null;
    selectedSpecialSocialCategory = trueFalse.isNotEmpty ? trueFalse[0] : null;
    selectedEarningMembers = trueFalse.isNotEmpty ? trueFalse[0] : null;
    selectedBusinessExperience = trueFalse.isNotEmpty ? trueFalse[0] : null;

    //  });
  }

  bool isSpecialSocialCategoryVisible = false;

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
            code: 'select', // Value of the placeholder
          ));
      relation.insert(
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
      religion.insert(
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
      landOwner.insert(
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
      education.insert(
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
      health.insert(
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
      occupationType.insert(
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
      schoolType.insert(
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

      cast.insert(
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
  }

  //int _currentStep = 0;
  final _formKeys = List.generate(6, (index) => GlobalKey<FormState>());
  DateTime? _selectedDate;

  final _business_DetailController = TextEditingController();
  final _any_current_EMIController = TextEditingController();
  final _future_IncomeController = TextEditingController();
  final _agriculture_incomeController = TextEditingController();
  final _earning_mem_countController = TextEditingController();
  final _other_IncomeController = TextEditingController();
  final _annuaL_INCOMEController = TextEditingController();
  final _spendOnChildrenController = TextEditingController();
  final _otheR_THAN_AGRICULTURAL_INCOMEController = TextEditingController();
  final _years_in_businessController = TextEditingController();
  final _pensionIncomeController = TextEditingController();
  final _any_RentalIncomeController = TextEditingController();
  final _rentController = TextEditingController();
  final _foodingController = TextEditingController();
  final _educationController = TextEditingController();
  final _healthController = TextEditingController();
  final _travellingController = TextEditingController();
  final _entertainmentController = TextEditingController();
  final _othersController = TextEditingController();
  final _homeTypeController = TextEditingController();
  final _homeRoofTypeController = TextEditingController();
  final _toiletTypeController = TextEditingController();

  final _bank_AcController = TextEditingController();
  final _bank_nameController = TextEditingController();
  final _bank_IFCSController = TextEditingController();
  final _bankOpeningDateController = TextEditingController();
  String? bankAccHolder, bankAddress;

  final _fnameController = TextEditingController();
  final _mnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _p_Address1Controller = TextEditingController();
  final _p_Address2Controller = TextEditingController();
  final _p_Address3Controller = TextEditingController();
  final _p_CityController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _dobController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _panController = TextEditingController();
  final _dlController = TextEditingController();
  final _voterController = TextEditingController();
  final _aadharIdController = TextEditingController();

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
      int FIID = widget.selectedData.id;

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFD42D3F),

      body: SafeArea(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 13.0, vertical: 24.0),
            child: Column(
              children: [
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
                            child: Icon(Icons.arrow_back_ios_sharp, size: 13),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Center(
                        /*child: Image.asset(
                          'assets/Images/paisa_logo.png',
                          // Replace with your logo asset path
                          height: 50,
                        ),*/
                        child: Text(
                          pageTitle,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30 // Make the text bold
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
                SizedBox(height: 20),
                Expanded(
                  child: Container(
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
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    _buildPreviousButton(),
                    SizedBox(width: 8),
                    _buildEditButton(),
                    SizedBox(width: 8),
                    _buildNextButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, bool saved) {
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
              color: Colors.white,// Set the desired width
              //  //height: 45, // Set the desired height
              child: Center(
                child: TextFormField(
                  enabled: saved,
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

  Widget _buildTextField2(String label, TextEditingController controller,
      TextInputType inputType, bool saved) {
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
                keyboardType: inputType, // Set the input type
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

  Future<void> AddFiExtraDetail(BuildContext context) async {
    int A = selectedIsHandicap == 'Yes' ? 1 : 0;
    print("objectrent $selectedIsHouseRental");
    int B = selectedIsHouseRental == 'Yes' ? 1 : 0;

    final api = Provider.of<ApiService>(context, listen: false);
    Map<String, dynamic> requestBody = {
       "fi_Id": widget.selectedData.id,
      "email_Id": emailIdController.text,
      "place_Of_Birth": placeOfBirthController.text,
      "depedent_Person": selectedDependent,
      "reservatioN_CATEGORY": "gff",
      "religion": selectedReligionextra ?? "",
      "Cast": selectedCast,
      "current_Phone": mobileController.text,
      "isHandicap": A,
      "handicap_type": selectedspecialAbility,
      "is_house_rental": B.toString(),
      "property_area": selectedProperty,
      "p_Address1": address1ControllerP.text,
      "p_Address2": address2ControllerP.text,
      "p_Address3": address3ControllerP.text,
      "p_City": cityControllerP.text,
      "p_State": selectedStateextraP,
      "p_Pincode": pincodeControllerP.text,
      "current_Address1": address1ControllerC.text,
      "current_Address2": address2ControllerC.text,
      "current_Address3": address3ControllerC.text,
      "current_City": cityControllerP.text,
      "current_State": selectedStateextraP,
      "current_Pincode": pincodeControllerP.text,
      "district": selectedDistrict,
      "sub_District": selectedSubDistrict,
      "village": selectedVillage,
      "Resident_for_years": selectedResidingFor,
      "Present_House_Owner": selectedPresentHouseOwner
    };

    if (DataValidate(context, requestBody)) {
      await api
          .updatePersonalDetails(
              GlobalClass.dbName, GlobalClass.token, requestBody)
          .then((value) async {
        if (value.statuscode == 200) {
          setState(() {
            _currentStep += 1;
          });
        } else {
          // Handle failure
          showAlertDialog(
              context, "Failed to update details. Please try again.");
        }
      });
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

  Future<void> AddFiFamilyDetail(BuildContext context) async {
     String Fi_ID = widget.selectedData.id.toString();
    String motheR_FIRST_NAME = _motherFController.text.toString();
    String motheR_MIDDLE_NAME = _motherMController.text.toString();
    String motheR_LAST_NAME = _motherLController.text.toString();
    String motheR_MAIDEN_NAME = "ghjfg";
    String noOfChildren = _numOfChildrenController.text.toString();
    String schoolingChildren = _schoolingChildrenController.text.toString();
    String otherDependents = _otherDependentsController.text.toString();

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

    if (DataValidate(context, requestBody)) {
      return await api.FiFamilyDetail(
              GlobalClass.token, GlobalClass.dbName, requestBody)
          .then((value) async {
        if (value.statuscode == 200) {
          setState(() {
            _currentStep += 1;
          });
        } else {}
      });
    }
  }

  Future<void> AddFinancialInfo(BuildContext context) async {
     String Fi_ID = widget.selectedData.id.toString();
    String bankType = selectedAccountType.toString();
    String bank_Ac = _bank_AcController.text.toString();
    String bank_name = _bank_nameController.text.toString();
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
          });
        } else {}
      });
    }
  }

  Future<void> FiFemMemIncome(BuildContext context) async {
    String Fi_ID = "139";
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

    if (DataValidate(context, requestBody)) {
      return await api.FIFamilyIncome(
              GlobalClass.token, GlobalClass.dbName, requestBody)
          .then((value) async {
        if (value.statuscode == 200) {
          setState(() {
            _currentStep += 1;
          });
        } else {}
      });
    }
  }

  Future<void> AddFiIncomeAndExpense(BuildContext context) async {
    String fi_ID = "139";
    String occupation = selectedOccupation.toString();
    String business_Detail = _business_DetailController.text.toString();
    int any_current_EMI = int.parse(_any_current_EMIController.text.toString());
    int future_Income = int.parse(_future_IncomeController.text.toString());
    int agriculture_income =
        int.parse(_agriculture_incomeController.text.toString());
    int earning_mem_count =
        int.parse(_earning_mem_countController.text.toString());
    int other_Income = int.parse(_other_IncomeController.text.toString());
    int annuaL_INCOME = int.parse(_annuaL_INCOMEController.text.toString());
    int spendOnChildren = int.parse(_spendOnChildrenController.text.toString());
    int otheR_THAN_AGRICULTURAL_INCOME =
        int.parse(_otheR_THAN_AGRICULTURAL_INCOMEController.text.toString());
    int years_in_business =
        int.parse(_years_in_businessController.text.toString());
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
    String homeType = _homeTypeController.text.toString();
    String homeRoofType = _homeRoofTypeController.text.toString();
    String toiletType = _toiletTypeController.text.toString();
    bool livingSpouse = true;
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

    if (DataValidate(context, requestBody)) {
      return await api.AddFiIncomeAndExpense(
              GlobalClass.token, GlobalClass.dbName, requestBody)
          .then((value) async {
        if (value.statuscode == 200) {
          setState(() {
            _currentStep += 1;
          });
        } else {}
      });
    }
  }

  Future<void> saveGuarantorMethod(BuildContext context) async {
    print("object");
    String fi_ID = "139";
    String gr_Sno = "1";
    String title = titleselected;
    String fname = _fnameController.text.toString();
    String mname = _mnameController.text.toString();
    String lname = _lnameController.text.toString();
    String relation_with_Borrower = relationselected.toString();
    String p_Address1 = _p_Address1Controller.text.toString();
    String p_Address2 = _p_Address2Controller.text.toString();
    String p_Address3 = _p_Address3Controller.text.toString();
    String p_City = _p_CityController.text.toString();
    String p_State = stateselected.toString();
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
          Fi_Id = value.data[0].fiId.toString();
        });
      } else {}
    });
  }

  Future<void> GetDocs(BuildContext context, int fiid) async {
    final api = Provider.of<ApiService>(context, listen: false);

    return await api.KycScanning(
            GlobalClass.token, GlobalClass.dbName, "10004" /*fiid.toString()*/)
        .then((value) async {
      if (value.statuscode == 200) {
        setState(() {
          getData = value;
          _isPageLoading = true;
        });
      } else {}
    });
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
                      Navigator.of(context).pop();
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
                      Navigator.of(context).pop(); // Optional: close the dialog
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
                        BigInt bigIntScanData = BigInt.parse(result);
                        List<int> byteScanData = bigIntToBytes(bigIntScanData);

                        List<int> decompByteScanData =
                            decompressData(byteScanData);
                        List<List<int>> parts =
                            separateData(decompByteScanData, 255, 15);
                        String qrResult = decodeData(parts);

                        onResult(qrResult);
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

  Widget _buildListItem({
    required String title, String? path,int? id,String? GrNo,
    required Function(File) onImagePicked,
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
            color: path != null ? Colors.green : Colors.red,
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
                        color: Colors.white), // Change text color if needed
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.upload,
                      size: 30,
                    ),
                    onPressed: () {
                      UploadFiDocs(
                          context, title, _selectedImage, GrNo, id);
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
            id: doc.aadharCheckListId,
            GrNo: "0",
            onImagePicked: (File file) {
              adhaarFront = file;
            }));
        listItems.add(_buildListItem(
            title: "Aadhar Back",
            path: doc.aadharBPath,
            id: doc.aadharBCheckListId,
            GrNo: '0',
            onImagePicked: (File file) {
              adhaarBack = file;
            }));
      }

      if (doc.voterExists == true) {
        listItems.add(_buildListItem(
            title: "Voter Front",
            path: doc.voterPath,
            id: doc.voterCheckListId,
            GrNo: '0',
            onImagePicked: (File file) {
              voterFront = file;
            }));
        listItems.add(_buildListItem(
            title: "Voter Back",
            path: doc.voterBPath,
            id: doc.voterBCheckListId,
            GrNo: '0',
            onImagePicked: (File file) {
              voterback = file;
            }));
      }

      if (doc.panExists == true) {
        listItems.add(_buildListItem(
            title: "Pan Front",
            path: doc.panPath,
            id: doc.panCheckListId,
            GrNo: '0',
            onImagePicked: (File file) {
              panFront = file;
            }));
      }

      if (doc.drivingExists == true) {
        listItems.add(_buildListItem(
            title: "DL Front",
            path: doc.drivingPath,
            id: doc.drivingCheckListId,
            GrNo: '0',
            onImagePicked: (File file) {
              dlFront = file;
            }));
      }

      if (doc.passBookExists == true) {
        listItems.add(_buildListItem(
            title: "Passbook Front",
            path: doc.passBookPath,
            id: doc.passBookCheckListId,
            GrNo: '0',
            onImagePicked: (File file) {
              passbook = file;
            }));
        listItems.add(_buildListItem(
            title: "Passport",
            path: doc.passportPath,
            id: doc.passportCheckListId,
            GrNo: '0',
            onImagePicked: (File file) {
              passport = file;
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
              id: 1,
              GrNo: grDoc.grSno,
              onImagePicked: (File file) {
                passbook = file;
              }));
          listItems.add(_buildListItem(
              title: "Aadhar Back",
              path: grDoc.aadharBPath,
              id: 1,
              GrNo: grDoc.grSno,
              onImagePicked: (File file) {
                passbook = file;
              }));
        }

        if (grDoc.voterExists == true) {
          listItems.add(_buildListItem(
              title: "Voter Front",
              path: grDoc.voterPath,
              id: 1,
              GrNo: grDoc.grSno,
              onImagePicked: (File file) {
                passbook = file;
              }));
          listItems.add(_buildListItem(
              title: "Voter Back",
              path: grDoc.voterBPath,
              id: 1,
              GrNo: grDoc.grSno,
              onImagePicked: (File file) {
                passbook = file;
              }));
        }

        if (grDoc.panExists == true) {
          listItems.add(_buildListItem(
              title: "Pan Front",
              path: grDoc.panPath,
              id: 1,
              GrNo: grDoc.grSno,
              onImagePicked: (File file) {
                passbook = file;
              }));
        }

        if (grDoc.drivingExists == true) {
          listItems.add(_buildListItem(
              title: "DL Front",
              path: grDoc.drivingPath,
              id: 1,
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
            color: Colors.red,
          ),
        ),
      );
    }
    return listItems;
  }

  Future<void> UploadFiDocs(BuildContext context, String? tittle, File? file, String? grNo, int? checklistid) async {
    final api = Provider.of<ApiService>(context, listen: false);
//https://predeptest.paisalo.in:8084/LOSDOC//FiDocs//38//FiDocuments//VoterIDBorrower0711_2024_43_01.png

   /* String baseUrl = 'https://predeptest.paisalo.in:8084';

    // Replace the front part of the file path and ensure the path uses forward slashes
    String? modifiedPath = path?.replaceAll(r'D:\', '').replaceAll(r'\\', '/');

    // Join the base URL with the modified path
    String finalUrl = '$baseUrl/$modifiedPath';
    File file = File(finalUrl);*/
    return await api
        .uploadFiDocs(
            GlobalClass.token,
            GlobalClass.dbName,
            "10004",
            int.parse(grNo!),
            checklistid!,

            tittle.toString(),
            file!)
        .then((value) async {
      if (value.statuscode == 200) {
        /*setState(() {
          _currentStep += 1;
          Fi_Id = value.data[0].fiId.toString();
        });*/
      } else {}
    });
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
                enabled: fixtraEditable,
                controller: emailIdController,
                focusNode: _emailFocusNode,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  errorText: _emailError,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            )),
        _buildTextField(
            'Place of Birth', placeOfBirthController, fixtraEditable),

        Row(
          children: [
            // Dependent Persons Column
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0),
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
                    SizedBox(height: 5),
                    // Add some spacing between the Text and Container
                    Container(
                      //  //height: 45,
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
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedDependent = newValue!;
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
                ),
              ),
            ),
            SizedBox(width: 10), // Gap of 10 between the two columns

            // Reservation Category Column
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                // Gap of 5 to the left for the second column
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Align children to the start of the column
                  children: [
                    _buildTextField(
                        'Res. Category', resCatController, fixtraEditable),
                  ],
                ),
              ),
            ),
          ],
        ),

        Row(
          children: [
            // Religion Column
            Expanded(
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
                    SizedBox(height: 5),
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
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedReligionextra = newValue;
                            });
                          }
                        },
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
                    SizedBox(height: 5),
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
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedCast =
                                  newValue; // Update the selected value
                            });
                          }
                        },
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
                enabled: fixtraEditable,
                controller: mobileController,
                focusNode: _mobileFocusNode,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  errorText: _mobileError,
                ),
                keyboardType: TextInputType.phone,
              ),
            )),
        Row(
          children: [
            // Is Handicap Column
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
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
                    SizedBox(height: 5),
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
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedIsHandicap = newValue!;
                          });
                        },
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
                    SizedBox(height: 5),
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
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedspecialAbility = newValue!;
                            isSpecialSocialCategoryVisible =
                                (newValue == 'Yes'); // Update visibility
                          });
                        },
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Special Social Category',
              style: TextStyle(fontSize: 13),
            ),
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
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSpecialSocialCategory = newValue!;
                  });
                },
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

        SizedBox(height: 10), // Gap of 10 between the two columns

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
        _buildTextField('Address1', address1ControllerP, fixtraEditable),
        _buildTextField('Address2', address2ControllerP, fixtraEditable),
        _buildTextField('Address3', address3ControllerP, fixtraEditable),

        Text(
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
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedStateextraP = newValue; // Update the selected value
                });
              }
            },
            items: states
                .map<DropdownMenuItem<String>>((RangeCategoryDataModel state) {
              return DropdownMenuItem<String>(
                value: state.code,
                child: Text(state.descriptionEn),
              );
            }).toList(),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // City TextField
            Expanded(
              child: _buildTextField('City', cityControllerP, fixtraEditable),
            ),
            SizedBox(
                width:
                    10), // Add some space between the City TextField and Pin Code Text
            // Pin Code Text and TextFormField
            Expanded(
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
                      enabled: fixtraEditable,
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

        SizedBox(
            height:
                10), // Add some space between the City TextField and Pin Code Text

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
        _buildTextField('Address1', address1ControllerC, fixtraEditable),
        _buildTextField('Address2', address2ControllerC, fixtraEditable),
        _buildTextField('Address3', address3ControllerC, fixtraEditable),

        Text(
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
            value: selectedStateextraC,
            isExpanded: true,
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black, fontSize: 13),
            underline: Container(
              height: 2,
              color: Colors
                  .transparent, // Set to transparent to remove default underline
            ),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedStateextraC = newValue; // Update the selected value
                });
              }
            },
            items: states
                .map<DropdownMenuItem<String>>((RangeCategoryDataModel state) {
              return DropdownMenuItem<String>(
                value: state.code,
                child: Text(state.descriptionEn),
              );
            }).toList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // City TextField
            Expanded(
              child: _buildTextField('City', cityControllerC, fixtraEditable),
            ),
            SizedBox(
                width:
                    10), // Add some space between the City TextField and Pin Code Text
            // Pin Code Text and TextFormField
            Expanded(
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
                      enabled: fixtraEditable,
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

        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
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
                    SizedBox(height: 5),
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
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedIsHouseRental = newValue!;
                          });
                        },
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

        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 0.0),
                // Gap between columns
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // District
                    Text(
                      'District',
                      style: TextStyle(fontSize: 13),
                    ),
                    // Spacing between text and dropdown
                    Container(
                      //height: 45,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: selectedDistrict,
                        isExpanded: true,
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black, fontSize: 13),
                        underline: Container(
                          height: 2,
                          color: Colors.transparent,
                        ),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedDistrict =
                                  newValue; // Update the selected value
                            });
                          }
                        },
                        items: states.map<DropdownMenuItem<String>>(
                            (RangeCategoryDataModel state) {
                          return DropdownMenuItem<String>(
                            value: state.code,
                            child: Text(state.descriptionEn),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Spacing between different fields

                    // Village
                    Text(
                      'Village',
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(height: 5),
                    Container(
                      //height: 45,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: selectedVillage,
                        isExpanded: true,
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black, fontSize: 13),
                        underline: Container(
                          height: 2,
                          color: Colors.transparent,
                        ),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedVillage =
                                  newValue; // Update the selected value
                            });
                          }
                        },
                        items: states.map<DropdownMenuItem<String>>(
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
            SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                // Gap between columns
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sub District
                    Text(
                      'Sub District',
                      style: TextStyle(fontSize: 13),
                    ),
                    // Spacing between text and dropdown
                    Container(
                      //height: 45,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: selectedSubDistrict,
                        isExpanded: true,
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black, fontSize: 13),
                        underline: Container(
                          height: 2,
                          color: Colors.transparent,
                        ),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedSubDistrict =
                                  newValue; // Update the selected value
                            });
                          }
                        },
                        items: trueFalse.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Spacing between different fields

                    // Residing for (Years)
                    Text(
                      'Residing for (Years)',
                      style: TextStyle(fontSize: 13),
                    ),
                    Container(
                      //height: 45,
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
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedResidingFor = newValue!;
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
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Column(
              children: [
                Text(
                  'Property (In Acres)',
                  style: TextStyle(fontSize: 13),
                ),
                Container(
                  width: 150,
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
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedProperty = newValue!;
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
            ),
            SizedBox(width: 10),
            Column(
              children: [
                Text(
                  'House Owner',
                  style: TextStyle(fontSize: 13),
                ),
                Container(
                  width: 150,
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
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedPresentHouseOwner =
                              newValue; // Update the selected value
                        });
                      }
                    },
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
            )
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
        _buildTextField('Mother name', _motherFController, FiIncomeEditable),
        Row(
          children: [
            Expanded(
                child: _buildTextField(
                    'Middle Name', _motherMController, FiFamilyEditable)),
            SizedBox(width: 13),
            // Add spacing between the text fields if needed
            Expanded(
                child: _buildTextField(
                    'Last Name', _motherLController, FiFamilyEditable)),
          ],
        ),
        _buildTextField2('No. of Children', _numOfChildrenController,
            TextInputType.number, FiFamilyEditable),
        _buildTextField2('Schooling Children', _schoolingChildrenController,
            TextInputType.number, FiIncomeEditable),
        _buildTextField2('Other Dependents', _otherDependentsController,
            TextInputType.number, FiFamilyEditable),
      ],
    ));
  }

  Widget _buildStepThree() {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
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
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedOccupation =
                                newValue; // Update the selected value
                          });
                        }
                      },
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
            Expanded(
              child: Column(
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
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedBusiness =
                                newValue; // Update the selected value
                          });
                        }
                      },
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
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Any Current EMI',
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
                      value: selectedOtherEMI,
                      isExpanded: true,
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black, fontSize: 13),
                      underline: Container(
                        height: 2,
                        color: Colors.transparent,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedOtherEMI = newValue!;
                        });
                      },
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
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Home Type',
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
                      value: selectedHomeType,
                      isExpanded: true,
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black, fontSize: 13),
                      underline: Container(
                        height: 2,
                        color: Colors.transparent,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedHomeType = newValue!;
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
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Column(
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
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedRoofType = newValue!;
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
              ),
            ),
            SizedBox(width: 10), // Spacing between the two columns
            Expanded(
              child: Column(
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
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedToiletType = newValue!;
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
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Column(
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
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedLivingWithSpouse = newValue!;
                        });
                      },
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
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Earning Members (count)',
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
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedEarningMembers = newValue!;
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
              ),
            ),
          ],
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
            onChanged: (String? newValue) {
              setState(() {
                selectedBusinessExperience = newValue!;
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
                Expanded(
                  child: _buildTextField2(
                      'Future Income',
                      _future_IncomeController,
                      TextInputType.number,
                      FiIncomeEditable),
                ),
                Expanded(
                  child: _buildTextField2(
                      'Agriculture Income',
                      _agriculture_incomeController,
                      TextInputType.number,
                      FiIncomeEditable),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField2(
                      'Other Income',
                      _other_IncomeController,
                      TextInputType.number,
                      FiIncomeEditable),
                ),
                Expanded(
                  child: _buildTextField2(
                      'Annual Income',
                      _annuaL_INCOMEController,
                      TextInputType.number,
                      FiIncomeEditable),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField2(
                      'Not Agricultural Income',
                      _otheR_THAN_AGRICULTURAL_INCOMEController,
                      TextInputType.number,
                      FiIncomeEditable),
                ),
                Expanded(
                  child: _buildTextField2(
                      'Pension Income',
                      _pensionIncomeController,
                      TextInputType.number,
                      FiIncomeEditable),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField2(
                      'Rental Income',
                      _any_RentalIncomeController,
                      TextInputType.number,
                      FiIncomeEditable),
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
                Expanded(
                  child: _buildTextField2('Rent', _rentController,
                      TextInputType.number, FiIncomeEditable),
                ),
                Expanded(
                  child: _buildTextField2('Food', _foodingController,
                      TextInputType.number, FiIncomeEditable),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField2('Education', _educationController,
                      TextInputType.number, FiIncomeEditable),
                ),
                Expanded(
                  child: _buildTextField2('Health', _healthController,
                      TextInputType.number, FiIncomeEditable),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField2('Travelling', _travellingController,
                      TextInputType.number, FiIncomeEditable),
                ),
                Expanded(
                  child: _buildTextField2(
                      'Entertainment',
                      _entertainmentController,
                      TextInputType.number,
                      FiIncomeEditable),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField2(
                      'Expense On Children',
                      _spendOnChildrenController,
                      TextInputType.number,
                      FiIncomeEditable),
                ),
                Expanded(
                  child: _buildTextField2('Others', _othersController,
                      TextInputType.number, FiIncomeEditable),
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
              onChanged: (String? newValue) {
                setState(() {
                  selectedAccountType = newValue!;
                });
              },
              items: accType.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          _buildTextField(
              'BANK NAME', _bank_nameController, FinancialInfoEditable),

          SizedBox(height: 10), // Adds space between the fields

          Container(
            padding: EdgeInsets.all(0), // Padding of 10 from each side
            decoration: BoxDecoration(
              color: Colors.white, // Background color of the container
              border: Border.all(color: Colors.red), // Red border color
              borderRadius: BorderRadius.circular(10), // Circular corners
            ),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTextField(
                      'IFSC', _bank_IFCSController, FinancialInfoEditable),
                  _buildTextField('BANK ACCOUNT', _bank_AcController,
                      FinancialInfoEditable),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, // Text color
                        backgroundColor:
                            Colors.red, // Background color of the button
                        padding: EdgeInsets.symmetric(vertical: 0.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // Rectangular shape
                        ),
                      ),
                      onPressed: () {
                        if (bankAccHolder == null) {
                          verifyDocs(context, _bank_AcController.text,
                              "bankaccount", _bank_IFCSController.text, "");
                        } else {
                          ifscVerify(context, _bank_IFCSController.text);
                        }
                      },
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

          Text.rich(
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
          ),
          Text.rich(
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
          ),

          SizedBox(height: 10),

          Text(
            'BANK OPENING DATE',
            style: TextStyle(fontSize: 13),
          ),
          SizedBox(height: 10), // Adds space between the fields

          Container(
            color: Colors.white,
            child: TextField(
              controller: _bankOpeningDateController,
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
          _buildTextField('Name', _femNameController, femMemIncomeEditable),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                    'Age', _AgeController, FinancialInfoEditable),
              ),
              SizedBox(width: 10), // Adds space between the fields
              Expanded(
                child: _buildTextField(
                    'Income', _IncomeController, femMemIncomeEditable),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Column(
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
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              femselectedGender =
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
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10), // Spacing between the two columns
              Expanded(
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
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              femselectedRelationWithBorrower =
                                  newValue; // Update the selected value
                            });
                          }
                        },
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
          Row(
            children: [
              Expanded(
                child: Column(
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
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              femselectedHealth =
                                  newValue; // Update the selected value
                            });
                          }
                        },
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
              Expanded(
                child: Column(
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
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              femselectedEducation =
                                  newValue; // Update the selected value
                            });
                          }
                        },
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
          Row(
            children: [
              Expanded(
                child: Column(
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
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              femselectedSchoolType =
                                  newValue; // Update the selected value
                            });
                          }
                        },
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
              Expanded(
                child: Column(
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
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              femselectedBusiness =
                                  newValue; // Update the selected value
                            });
                          }
                        },
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
          Row(
            children: [
              Expanded(
                child: Column(
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
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              femselectedBusinessType =
                                  newValue; // Update the selected value
                            });
                          }
                        },
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
              Expanded(
                child: Column(
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
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              femselectedIncomeType =
                                  newValue; // Update the selected value
                            });
                          }
                        },
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
              Expanded(
                  child: _buildTextField(
                      'Aadhaar Id', _aadharIdController, GuarantorEditable)),
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
                      style: TextStyle(fontSize: 16),
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
                child: _buildTextField(
                    'Name', _fnameController, GuarantorEditable),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: _buildTextField(
                      'Middle Name', _mnameController, GuarantorEditable)),
              SizedBox(width: 13),
              // Add spacing between the text fields if needed
              Expanded(
                  child: _buildTextField(
                      'Last Name', _lnameController, GuarantorEditable)),
            ],
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gender',
                    style: TextStyle(fontSize: 13),
                  ),
                  Container(
                    width: 150,
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
                      style: TextStyle(color: Colors.black, fontSize: 16),
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
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Relationship',
                    style: TextStyle(fontSize: 16),
                  ),
                  Container(
                    width: 150,
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
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      underline: Container(
                        height: 2,
                        color: Colors
                            .transparent, // Set to transparent to remove default underline
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            relationselected =
                                newValue; // Update the selected value
                          });
                        }
                      },
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
            height: 60,
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
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    religionselected = newValue; // Update the selected value
                  });
                }
              },
              items: religion.map<DropdownMenuItem<String>>(
                  (RangeCategoryDataModel state) {
                return DropdownMenuItem<String>(
                  value: state.code,
                  child: Text(state.descriptionEn),
                );
              }).toList(),
            ),
          ),
          _buildTextField('Mobile no', _phoneController, GuarantorEditable),
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
              Expanded(
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
              border: Border.all(color: Colors.red), // Red border color
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
                      Expanded(
                        child: _buildTextField(
                            'PAN No', _panController, GuarantorEditable),
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
                      Expanded(
                        child: _buildTextField('Driving License', _dlController,
                            GuarantorEditable),
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
                      fontSize: 16,
                      color: Colors.red, // Set the text color to red
                    ),
                    textAlign: TextAlign.center, // Center the text
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                            'Voter Id', _voterController, GuarantorEditable),
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
          _buildTextField('Address1', _p_Address1Controller, GuarantorEditable),
          _buildTextField('Address2', _p_Address2Controller, GuarantorEditable),
          _buildTextField('Address3', _p_Address3Controller, GuarantorEditable),
          Text(
            'State Name',
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
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    stateselected = newValue; // Update the selected value
                  });
                }
              },
              items: states.map<DropdownMenuItem<String>>(
                  (RangeCategoryDataModel state) {
                return DropdownMenuItem<String>(
                  value: state.code,
                  child: Text(state.descriptionEn),
                );
              }).toList(),
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: _buildTextField(
                      'City', _p_CityController, GuarantorEditable)),
              SizedBox(width: 10),

              Expanded(
                  child: _buildTextField(
                      'Pincode', _pincodeController, GuarantorEditable)),
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
              color: Colors.red,
            ),
          ),
        )
      ),
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
        onPressed: () {
          if (_currentStep > 0) {
            setState(() {
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
        onPressed: toggleEditMode,
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
          if (_currentStep < 6) {
            setState(() {
              _currentStep += 1;
            });
          } else if (_currentStep == 6) {
               GetDocs(context, widget.selectedData.id);
            setState(() {
              _currentStep += 1;
            });
          } else if (_formKey.currentState?.validate() ?? false) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Form submitted successfully")),
            );
          }
        },
        /*onPressed: () {
          if (_currentStep == 0) {
            setState(() {
              pageTitle = "Personal Info.";
            });
            AddFiExtraDetail(context);
          } else if (_currentStep == 1) {
            setState(() {
              pageTitle = "Family Details";
            });
            AddFiFamilyDetail(context);
          } else if (_currentStep == 2) {
            setState(() {
              pageTitle = "Income & Expense";
            });
            AddFiIncomeAndExpense(context);
          } else if (_currentStep == 3) {
            setState(() {
              pageTitle = "Financial Info.";
            });
            AddFinancialInfo(context);
          } else if (_currentStep == 4) {
            setState(() {
              pageTitle = "Family Income";
            });
            FiFemMemIncome(context);
          } else if (_currentStep == 5) {
            setState(() {
              pageTitle = "Guarantor Form";
            });
            saveGuarantorMethod(context);
          } else if (_currentStep == 6) {
            setState(() {
              pageTitle = "Docs Upload";
            });
            // UploadFiDocs(context, widget.selectedData.id.toString());
          }

          */ /*if (_currentStep < 7) {
            setState(() {
              _currentStep += 1;
            });
          } else if (_currentStep == 7) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Form submitted successfully")),
            );
          }*/ /*
        },*/
        child: Text(
          _currentStep == 6 ? "SUBMIT" : "NEXT",
          style: TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }

  void toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  /*void showAlertDialog(BuildContext context, String message) {
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
  }*/

  void _validateEmail() {
    print("object22");
    if (!_emailFocusNode.hasFocus) {
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
          bankAccHolder = value.data.fullName.toString();
        });
      }
    });
  }

  Future<void> ifscVerify(BuildContext context, String ifsc) async {
    final api = ApiService.create(baseUrl: ApiConfig.baseUrl3);

    return await api.ifscVerify(ifsc).then((value) {
      if (value != null && value.address != null) {
        setState(() {
          bankAddress = value.address.toString();
        });
      } else {
        print('Failed to get valid data');
      }
    }).catchError((error) {
      print('Error occurred: $error');
    });
  }
}
