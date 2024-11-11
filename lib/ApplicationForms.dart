import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  List<String> titleList = ["Select", "Mr.", "Mrs.", "Miss"];
  String titleselected = "Select";
  String selectedTitle = "Select";
  String expense = "";
  String income = "";
  String lati = "";
  String longi = "";

  //fiextra
  List<String> onetonine = ['Select', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  List<String> loanDuration = ['Select','12', '24', '36', '48'];
  List<String> trueFalse = ['Select', 'Yes', 'No'];

  String? stateselected;
  String? relationselected;
  String? genderselected;
  String? religionselected;
  String? selectedLoanDuration;

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

  final emailIdController = TextEditingController();
  final placeOfBirthController = TextEditingController();
  final resCatController = TextEditingController();
  final mobileController = TextEditingController();
  final address1ControllerP = TextEditingController();
  final address2ControllerP = TextEditingController();
  final address3ControllerP = TextEditingController();
  final address1ControllerC = TextEditingController();
  final address2ControllerC = TextEditingController();
  final address3ControllerC = TextEditingController();
  final cityControllerP = TextEditingController();
  final pincodeControllerP = TextEditingController();
  final cityControllerC = TextEditingController();
  final pincodeControllerC = TextEditingController();

  // AddFiFamilyDetail
  final _motherFController = TextEditingController();
  final _motherMController = TextEditingController();
  final _motherLController = TextEditingController();
  final _schoolingChildrenController = TextEditingController();
  final _numOfChildrenController = TextEditingController();
  final _otherDependentsController = TextEditingController();


  final loanAmountController = TextEditingController();



  @override
  void initState() {
    super.initState();
    initializeData(); // Fetch initial data
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

  //  });

    GetDocs(context, widget.selectedData.id);
      _isPageLoading=true;
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



  final _occupationController = TextEditingController();
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
  final _livingSpouseController = TextEditingController();

  final _bankTypeController = TextEditingController();
  final _bank_AcController = TextEditingController();
  final _bank_nameController = TextEditingController();
  final _bank_IFCSController = TextEditingController();
  final _bank_addressController = TextEditingController();
  final _bankOpeningDateController = TextEditingController();

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

  // fiextra


 /* String? selectedState;
  String? selectedEarningMemberType;
  String? selectedBusinessDetail;
  String? selectedLoanPurpose;
  String? selectedOccupation;*/

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
      backgroundColor: Color(0xFFD42D3F),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
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
                            child: Icon(Icons.arrow_back_ios_sharp, size: 16),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Center(
                        child: Image.asset(
                          'assets/Images/paisa_logo.png', // Replace with your logo asset path
                          height: 50,
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
                      borderRadius: BorderRadius.circular(16),
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

  /*Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      body: Center(
          child: Column(
        children: [
          SizedBox(height: 50),
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
                      border: Border.all(width: 1, color: Colors.grey.shade300),
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
                    'assets/Images/paisa_logo.png', // Replace with your logo asset path
                    height: 50,
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
          Container(
            height: MediaQuery.of(context).size.height - 150,
            width: MediaQuery.of(context).size.width - 24,
            */ /*decoration: BoxDecoration(
                  color: Colors.white
              ),*/ /*
            child: Padding(
              padding:
                  EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 80),
              child: Stepper(
                type: StepperType.horizontal,
                currentStep: _currentStep,
                onStepContinue: () {
                  // Validate the current step's form before proceeding
                  if (_formKeys[_currentStep].currentState?.validate() ??
                      false) {
                    // Call the save method based on the current step
                    if (_currentStep == 0) {
                      updatePersonalDetails(context);
                    } else if (_currentStep == 1) {
                      AddFiFamilyDetail(context);
                    } else if (_currentStep == 2) {
                      AddFiIncomeAndExpense(context);
                    } else if (_currentStep == 3) {
                      AddFinancialInfo(context);
                    } else if (_currentStep == 4) {
                      saveGuarantorMethod(context);
                    }else if (_currentStep == 5) {
                      UploadFiDocs(context, widget.selectedData.id.toString());
                    }
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() {
                      _currentStep -= 1;
                    });
                  }
                },
                controlsBuilder:
                    (BuildContext context, ControlsDetails controls) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 150,
                        child: TextButton(
                          onPressed: controls.onStepContinue,
                          child: Text(
                            'Next',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFFD42D3F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.elliptical(5, 5)), // Set border radius to zero for sharp corners
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                steps: [
                  Step(
                    title: Text('1'),
                    isActive: _currentStep >= 0,
                    content: Form(
                      key: _formKeys[0],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField('Email ID', emailIdController),
                          Text(
                            'Cast',
                            style: TextStyle(fontSize: 16
),
                          ),
                          Container(
                            width: 150,
                            // Adjust the width as needed
                            height: 45,
                            // Fixed height
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButton<String>(
                              value: selectedCast,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
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
                          Text(
                            'Residing for (Years)',
                            style: TextStyle(fontSize: 16
),
                          ),
                          Container(
                            width: 150,
                            // Adjust the width as needed
                            height: 45,
                            // Fixed height
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButton<String>(
                              value: selectedResiding,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              underline: Container(
                                height: 2,
                                color: Colors
                                    .transparent, // Set to transparent to remove default underline
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedResiding = newValue!;
                                });
                              },
                              items: residing.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          Text(
                            'Applicant Religion',
                            style: TextStyle(fontSize: 16
),
                          ),
                          Container(
                            width: 150,
                            // Adjust the width as needed
                            height: 45,
                            // Fixed height
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButton<String>(
                              value: selectedReligion,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              underline: Container(
                                height: 2,
                                color: Colors
                                    .transparent, // Set to transparent to remove default underline
                              ),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedReligion =
                                        newValue; // Update the selected value
                                  });
                                }
                              },
                              items: religionextra
                                  .map<DropdownMenuItem<String>>(
                                      (RangeCategoryDataModel state) {
                                return DropdownMenuItem<String>(
                                  value: state.code,
                                  child: Text(state.descriptionEn),
                                );
                              }).toList(),
                            ),
                          ),
                          _buildTextField(
                              'Place of Birth', placeOfBirthController),
                          Text(
                            'Present House Owner',
                            style: TextStyle(fontSize: 16
),
                          ),
                          Container(
                            width: 150,
                            // Adjust the width as needed
                            height: 45,
                            // Fixed height
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButton<String>(
                              value: selectedPresentHouseOwner,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
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
                          ),
                          Text(
                            'Special Ability',
                            style: TextStyle(fontSize: 16
),
                          ),
                          Container(
                            width: 150,
                            height: 45,
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButton<String>(
                              value: selectedspecialAbility,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
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
                              items: specialAbility.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          if (isSpecialSocialCategoryVisible)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Special Social Category',
                                  style: TextStyle(fontSize: 16
),
                                ),
                                Container(
                                  width: 150,
                                  height: 45,
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: DropdownButton<String>(
                                    value: selectedSpecialSocialCategory,
                                    isExpanded: true,
                                    icon: Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.transparent,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedSpecialSocialCategory =
                                            newValue!;
                                      });
                                    },
                                    items: SpecialSocialCategory.map(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          _buildTextField('Address Line 1', address1Controller),
                          _buildTextField('Address Line 2', address2Controller),
                          _buildTextField('Address Line 3', address3Controller),
                          Row(
                            children: [
                              Expanded(
                                  child:
                                      _buildTextField('City', cityController)),
                              SizedBox(width: 16),
                              // Add spacing between the text fields if needed
                              Expanded(
                                  child: _buildTextField2('PinCode',
                                      pincodeController, TextInputType.number)),
                            ],
                          ),
                          Text(
                            'State Name',
                            style: TextStyle(fontSize: 16
),
                          ),
                          Container(
                            width: 150,
                            // Adjust the width as needed
                            height: 45,
                            // Fixed height
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButton<String>(
                              value: selectedStateextra,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              underline: Container(
                                height: 2,
                                color: Colors
                                    .transparent, // Set to transparent to remove default underline
                              ),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedStateextra =
                                        newValue; // Update the selected value
                                  });
                                }
                              },
                              items: stateextra.map<DropdownMenuItem<String>>(
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
                  Step(
                    title: Text('2'),
                    isActive: _currentStep >= 1,
                    content: Form(
                      key: _formKeys[1],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField('Mother name', _motherFController),
                          Row(
                            children: [
                              Expanded(
                                  child: _buildTextField('Mother Middle Name',
                                      _motherMController)),
                              SizedBox(width: 16),
                              // Add spacing between the text fields if needed
                              Expanded(
                                  child: _buildTextField(
                                      'Mother Last Name', _motherLController)),
                            ],
                          ),
                          _buildTextField(
                              'No. of Children', _schoolingChildrenController),
                          _buildTextField(
                              'Schooling Children', _numOfChildrenController),
                          _buildTextField(
                              'Other Dependents', _otherDependentsController),
                        ],
                      ),
                    ),
                  ),
                  Step(
                    title: Text('3'),
                    isActive: _currentStep >= 2,
                    content: Form(
                      key: _formKeys[2],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField('Occupation', _occupationController),
                          _buildTextField(
                              'Business Detail', _business_DetailController),
                          _buildTextField2('Any Current EMI',
                              _any_current_EMIController, TextInputType.number),
                          _buildTextField2('Future Income',
                              _future_IncomeController, TextInputType.number),
                          _buildTextField2(
                              'Agriculture Income',
                              _agriculture_incomeController,
                              TextInputType.number),
                          _buildTextField2(
                              'Earning Members (count)',
                              _earning_mem_countController,
                              TextInputType.number),
                          _buildTextField2('Other_Income',
                              _other_IncomeController, TextInputType.number),
                          _buildTextField2('AnnuaL INCOME',
                              _annuaL_INCOMEController, TextInputType.number),
                          _buildTextField2('Expense On Children',
                              _spendOnChildrenController, TextInputType.number),
                          _buildTextField2(
                              'Not AGRICULTURAL INCOME',
                              _otheR_THAN_AGRICULTURAL_INCOMEController,
                              TextInputType.number),
                          _buildTextField2(
                              'Business Experience',
                              _years_in_businessController,
                              TextInputType.number),
                          _buildTextField2('Pension Income',
                              _pensionIncomeController, TextInputType.number),
                          _buildTextField2(
                              'Rental Income',
                              _any_RentalIncomeController,
                              TextInputType.number),
                          _buildTextField2(
                              'Rent', _rentController, TextInputType.number),
                          _buildTextField2(
                              'Food', _foodingController, TextInputType.number),
                          _buildTextField2('Education', _educationController,
                              TextInputType.number),
                          _buildTextField2('Health', _healthController,
                              TextInputType.number),
                          _buildTextField2('Travelling', _travellingController,
                              TextInputType.number),
                          _buildTextField2('Entertainment',
                              _entertainmentController, TextInputType.number),
                          _buildTextField2('Others', _othersController,
                              TextInputType.number),
                          _buildTextField('Home Type', _homeTypeController),
                          _buildTextField('Roof Type', _homeRoofTypeController),
                          _buildTextField('Toilet Type', _toiletTypeController),
                          _buildTextField(
                              'Living With Spouse', _livingSpouseController)
                        ],
                      ),
                    ),
                  ),
                  Step(
                    title: Text('4'),
                    isActive: _currentStep >= 3,
                    content: Form(
                      key: _formKeys[3],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField('bankType', _bankTypeController),
                          _buildTextField('bank_Ac', _bank_AcController),
                          _buildTextField('bank_name', _bank_nameController),
                          _buildTextField('bank_IFCS', _bank_IFCSController),
                          _buildTextField(
                              'bank_address', _bank_addressController),
                          Text(
                            'Bank Opening Date',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
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
                    ),
                  ),
                  Step(
                    title: Text('5'),
                    isActive: _currentStep >= 4,
                    content: Form(
                      key: _formKeys[4],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: _buildTextField(
                                      'Aadhaar Id', _aadharIdController)),
                              GestureDetector(
                                onTap: () =>
                                    _showPopup(context, (String result) {
                                  setState(() {
                                    qrResult = result;
                                  });
                                }), // Show popup on image click
                                child: Icon(
                                  Icons.qr_code_scanner,
                                  size: 50.0, // Set the size of the icon
                                  color:
                                      Colors.blue, // Set the color of the icon
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Title',
                                      style: TextStyle(fontSize: 16
),
                                    ),
                                    Container(
                                      width: 150,
                                      // Adjust the width as needed
                                      height: 45,
                                      // Fixed height
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: DropdownButton<String>(
                                        value: selectedTitle,
                                        isExpanded: true,
                                        icon: Icon(Icons.arrow_downward),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
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
                              GestureDetector(
                                onTap: _pickImage,
                                child: _imageFile == null
                                    ? Icon(
                                        Icons.person,
                                        size: 50.0,
                                        color: Colors.blue,
                                      )
                                    : Image.file(
                                        File(_imageFile!.path),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ],
                          ),
                          _buildTextField('Name', _fnameController),
                          Row(
                            children: [
                              Expanded(
                                  child: _buildTextField(
                                      'Middle Name', _mnameController)),
                              SizedBox(width: 16),
                              // Add spacing between the text fields if needed
                              Expanded(
                                  child: _buildTextField(
                                      'Last Name', _lnameController)),
                            ],
                          ),
                          Text(
                            'Gender',
                            style: TextStyle(fontSize: 16
),
                          ),
                          Container(
                            width: 150, // Adjust the width as needed
                            height: 45, // Fixed height
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButton<String>(
                              value: genderselected,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
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
                              items: aadhar_gender
                                  .map<DropdownMenuItem<String>>(
                                      (RangeCategoryDataModel state) {
                                return DropdownMenuItem<String>(
                                  value: state.code,
                                  child: Text(state.descriptionEn),
                                );
                              }).toList(),
                            ),
                          ),
                          Text(
                            'Religion',
                            style: TextStyle(fontSize: 16
),
                          ),
                          Container(
                            width: 150,
                            // Adjust the width as needed
                            height: 45,
                            // Fixed height
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButton<String>(
                              value: religionselected,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              underline: Container(
                                height: 2,
                                color: Colors
                                    .transparent, // Set to transparent to remove default underline
                              ),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    religionselected =
                                        newValue; // Update the selected value
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
                          Text(
                            'Relationship With Borrower',
                            style: TextStyle(fontSize: 16
),
                          ),
                          Container(
                            width: 150,
                            // Adjust the width as needed
                            height: 45,
                            // Fixed height
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButton<String>(
                              value: relationselected,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
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
                          _buildTextField('Mobile no', _phoneController),
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
                                            onPressed: () =>
                                                _selectDate(context, "DOB"),
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
                          _buildTextField('Pan', _p_Address1Controller),
                          _buildTextField(
                              'Driving License', _p_Address1Controller),
                          _buildTextField('Voter Id', _p_Address1Controller),
                          _buildTextField('Address1', _p_Address1Controller),
                          _buildTextField('Address2', _p_Address2Controller),
                          _buildTextField('Address3', _p_Address3Controller),
                          Row(
                            children: [
                              Expanded(
                                  child: _buildTextField(
                                      'City', _p_CityController)),
                              SizedBox(width: 16),
                              Expanded(
                                  child: _buildTextField(
                                      'Pincode', _pincodeController)),
                            ],
                          ),
                          Text(
                            'State Name',
                            style: TextStyle(fontSize: 16
),
                          ),
                          Container(
                            width: 150,
                            // Adjust the width as needed
                            height: 45,
                            // Fixed height
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButton<String>(
                              value: stateselected,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              underline: Container(
                                height: 2,
                                color: Colors
                                    .transparent, // Set to transparent to remove default underline
                              ),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    stateselected =
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
                  Step(
                    title: Text('6'),
                    isActive: _currentStep >= 0,
                    content: Form(
                      key: _formKeys[5],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                        _buildKycDocumentList(), // Call the function here
                      ),
                    ),
                  ),
                ],
                stepIconHeight: 25,
                connectorColor: MaterialStateProperty.all(Color(0xFFD42D3F)),
              ),
            ),
          ),
        ],
      )),
    );
  }*/

  Widget _buildTextField(String label, TextEditingController controller,bool saved) {
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
              height: 45, // Set the desired height
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

  Widget _buildTextField2(
      String label, TextEditingController controller, TextInputType inputType) {
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
            height: 45, // Set the desired height
            child: Center(
              child: TextFormField(
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

  Future<void> AddFiFamilyDetail(BuildContext context) async {
    String Fi_ID = "139";
    String motheR_FIRST_NAME = _motherFController.text.toString();
    String motheR_MIDDLE_NAME = _motherMController.text.toString();
    String motheR_LAST_NAME = _motherLController.text.toString();
    String motheR_MAIDEN_NAME = "";
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

  Future<void> AddFinancialInfo(BuildContext context) async {
    String Fi_ID = "139";
    String bankType = _bankTypeController.text.toString();
    String bank_Ac = _bank_AcController.text.toString();
    String bank_name = _bank_nameController.text.toString();
    String bank_IFCS = _bank_IFCSController.text.toString();
    String bank_address = _bank_addressController.text.toString();
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

    return await api.AddFinancialInfo(
            GlobalClass.token, GlobalClass.dbName, requestBody)
        .then((value) async {
      if (value.statuscode == 200) {
        setState(() {
          _currentStep += 1;
        });
      } else {}
    });
  }

  Future<void> AddFiIncomeAndExpense(BuildContext context) async {
    String fi_ID = "139";
    String occupation = _occupationController.text.toString();
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
    String esign_UUID = "1654";

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

  Future<void> AddFiExtraDetail(BuildContext context) async {
    // EasyLoading.show(status: 'Loading...',);

    int A = selectedspecialAbility == 'Yes' ? 1 : 0;
    int B = selectedIsHouseRental == 'Yes' ? 1 : 0;

    final api = Provider.of<ApiService>(context, listen: false);
    Map<String, dynamic> requestBody = {
      "fi_Id": "139",
      "is_house_rental": B ?? 0,
      "depedent_Person": selectedDependent,
      "religion": selectedReligionextra ?? "",
      "property_area": selectedProperty,
      "email_Id": emailIdController.text,
      "isHandicap": A ?? 0,
      "handicap_type": selectedspecialAbility,
      "place_Of_Birth": placeOfBirthController.text,
      "reservatioN_CATEGORY": "",
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
      "current_Phone": mobileController.text,
      "district": selectedDistrict,
      "sub_District": selectedSubDistrict,
      "village": selectedVillage,
      "Cast": selectedCast,
      "Resident_for_years": selectedResidingFor,
      "Present_House_Owner": selectedPresentHouseOwner
    };

    return await api
        .updatePersonalDetails(
            GlobalClass.dbName, GlobalClass.token, requestBody)
        .then((value) async {
      if (value.statuscode == 200) {
        setState(() {
          _currentStep += 1;
          Fi_Id = value.data[0].fiId.toString();
        });
      } else {
        // Handle failure
      }
    });
  }

  Future<void> GetDocs(BuildContext context, int fiid) async {
    final api = Provider.of<ApiService>(context, listen: false);

    return await api.KycScanning(
            GlobalClass.token, GlobalClass.dbName, fiid.toString())
        .then((value) async {
      if (value.statuscode == 200) {
        setState(() {
          getData = value;
          _isPageLoading = true;
        });
      } else {}
    });
  }

  Widget _buildListItem({
    required String title,
    String? path,
    String? GrNo,
    required Function(File) onImagePicked,
  }) {
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
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        path != null
                            ? Text(path)
                            : Text('No image selected'),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  _selectedImage != null
                      ? Image.file(
                    _selectedImage!,
                    width: 50,
                    height: 50,
                  )
                      : Image.asset(
                    'assets/Images/rupees.png',
                    width: 50,
                    height: 50,
                  ),
                  IconButton(
                    icon: Icon(Icons.upload),
                    onPressed: () {
                      UploadFiDocs(context, widget.selectedData.id.toString(),title,path,GrNo);
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
            style: TextStyle(fontSize: 16),
          ),
        ),
      );

      if (doc.addharExists == true) {
        listItems.add(_buildListItem(
            title: "Aadhar Front",
            path: doc.aadharPath,
            GrNo:"0",
            onImagePicked: (File file) {
              adhaarFront = file;
            }));
        listItems.add(_buildListItem(
            title: "Aadhar Back",
            path: doc.aadharBPath,
            GrNo:'0',
            onImagePicked: (File file) {
              adhaarBack = file;
            }));
      }

      if (doc.voterExists == true) {
        listItems.add(_buildListItem(
            title: "Voter Front",
            path: doc.voterPath,
            GrNo:'0',
            onImagePicked: (File file) {
              voterFront = file;
            }));
        listItems.add(_buildListItem(
            title: "Voter Back",
            path: doc.voterBPath,
            GrNo:'0',
            onImagePicked: (File file) {
              voterback = file;
            }));
      }

      if (doc.panExists == true) {
        listItems.add(_buildListItem(
            title: "Pan Front",
            path: doc.panPath,
            GrNo:'0',
            onImagePicked: (File file) {
              panFront = file;
            }));
      }

      if (doc.drivingExists == true) {
        listItems.add(_buildListItem(
            title: "DL Front",
            path: doc.drivingPath,
            GrNo:'0',
            onImagePicked: (File file) {
              dlFront = file;
            }));
      }

      if (doc.passBookExists == true) {
        listItems.add(_buildListItem(
            title: "Passbook Front",
            path: doc.passBookPath,
            GrNo:'0',
            onImagePicked: (File file) {
              passbook = file;
            }));
        listItems.add(_buildListItem(
            title: "Passport",
            path: doc.passBookBPath,
            GrNo:'0',
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
              style: TextStyle(fontSize: 16),
            ),
          ),
        );

        if (grDoc.addharExists == true) {
          listItems.add(_buildListItem(
              title: "Aadhar Front",
              path: grDoc.aadharPath,
              GrNo:grDoc.grSno,
              onImagePicked: (File file) {
                passbook = file;
              }));
          listItems.add(_buildListItem(
              title: "Aadhar Back",
              path: grDoc.aadharBPath,
              GrNo:grDoc.grSno,
              onImagePicked: (File file) {
                passbook = file;
              }));
        }

        if (grDoc.voterExists == true) {
          listItems.add(_buildListItem(
              title: "Voter Front",
              path: grDoc.voterPath,
              GrNo:grDoc.grSno,
              onImagePicked: (File file) {
                passbook = file;
              }));
          listItems.add(_buildListItem(
              title: "Voter Back",
              path: grDoc.voterBPath,
              GrNo:grDoc.grSno,
              onImagePicked: (File file) {
                passbook = file;
              }));
        }

        if (grDoc.panExists == true) {
          listItems.add(_buildListItem(
              title: "Pan Front",
              path: grDoc.panPath,
              GrNo:grDoc.grSno,
              onImagePicked: (File file) {
                passbook = file;
              }));
        }

        if (grDoc.drivingExists == true) {
          listItems.add(_buildListItem(
              title: "DL Front",
              path: grDoc.drivingPath,
              GrNo:grDoc.grSno,
              onImagePicked: (File file) {
                passbook = file;
              }));
        }
      }
    }
    return listItems;
  }


  Future<void> UploadFiDocs(BuildContext context, fiid, String?tittle, String? path, String? grNo) async {
    final api = Provider.of<ApiService>(context, listen: false);
//https://predeptest.paisalo.in:8084/LOSDOC//FiDocs//38//FiDocuments//VoterIDBorrower0711_2024_43_01.png
    return await api
        .uploadFiDocs(
            GlobalClass.token,
            GlobalClass.dbName,
            "FI_ID",//FI_ID,
            int.parse(grNo!),
            "2",
            tittle.toString(),
            "FileName")
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
        _buildTextField('Email ID', emailIdController,fixtraEditable),
        _buildTextField('Place of Birth', placeOfBirthController,fixtraEditable),

        Row(
          children: [
            // Dependent Persons Column
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0), // Gap of 5 to the right for the first column
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start of the column
                  children: [
                    Text(
                      'Dependent Persons',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 5), // Add some spacing between the Text and Container
                    Container(
                      height: 45,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: selectedDependent,
                        isExpanded: true,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black, fontSize: 16),
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
                padding: const EdgeInsets.only(left: 5.0), // Gap of 5 to the left for the second column
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start of the column
                  children: [
                    _buildTextField('Res. Category', resCatController,fixtraEditable),
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
                padding: const EdgeInsets.only(right: 5.0), // Gap of 5 to the right for the first column
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start of the column
                  children: [
                    Text(
                      'Religion',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 5), // Add some spacing between the Text and Container
                    Container(
                      height: 45,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: selectedReligionextra,
                        isExpanded: true,
                        icon: Icon(Icons.arrow_downward),
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
                              selectedReligionextra = newValue;
                            });
                          }
                        },
                        items: religion.map<DropdownMenuItem<String>>((RangeCategoryDataModel state) {
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
                padding: const EdgeInsets.only(left: 5.0), // Gap of 5 to the left for the second column
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start of the column
                  children: [
                    Text(
                      'Cast',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 5), // Add some spacing between the Text and Container
                    Container(
                      height: 45,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: selectedCast,
                        isExpanded: true,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style:
                        TextStyle(color: Colors.black, fontSize: 16),
                        underline: Container(
                          height: 2,
                          color: Colors
                              .transparent, // Set to transparent to remove default underline
                        ),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedCast = newValue; // Update the selected value
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

        _buildTextField('Mobile No.', mobileController,fixtraEditable),
        Row(
          children: [
            // Is Handicap Column
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0), // Gap of 5 to the left for the second column
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start of the column
                  children: [
                    Text(
                      'Is Handicap',
                      style: TextStyle(fontSize: 16
                      ),
                      textAlign: TextAlign.left, // Align text to the left
                    ),
                    SizedBox(height: 5), // Add some spacing between the Text and Container
                    Container(
                      height: 45,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: selectedIsHandicap,
                        isExpanded: true,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black, fontSize: 16),
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
                padding: const EdgeInsets.only(left: 5.0), // Gap of 5 to the left for the second column
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start of the column
                  children: [
                    Text(
                      'Special Ability',
                      style: TextStyle(fontSize: 16
),
                      textAlign: TextAlign.left, // Align text to the left
                    ),
                    SizedBox(height: 5), // Add some spacing between the Text and Container
                    Container(
                      height: 45,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: selectedspecialAbility,
                        isExpanded: true,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black, fontSize: 16),
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
                style: TextStyle(fontSize: 16
),
              ),
              Container(
                width: 150,
                height: 45,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButton<String>(
                  value: selectedSpecialSocialCategory,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.black, fontSize: 16),
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
        _buildTextField('Permanent Address1', address1ControllerP,fixtraEditable),
        _buildTextField('Permanent Address2', address2ControllerP,fixtraEditable),
        _buildTextField('Permanent Address3', address3ControllerP,fixtraEditable),

        Text(
          'Permanent State',
          style: TextStyle(fontSize: 16
),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          // Adjust the width as needed
          height: 45,
          // Fixed height
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButton<String>(
            value: selectedStateextraP,
            isExpanded: true,
            icon: Icon(Icons.arrow_downward),
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
          children: [
            Expanded(child: _buildTextField('Permanent City', cityControllerP,fixtraEditable)),
            SizedBox(width: 16),
            // Add spacing between the text fields if needed
            Expanded(
                child: _buildTextField2(
                    'Permanent PinCode', pincodeControllerP, TextInputType.number)),
          ],
        ),
        _buildTextField('Current Address1', address1ControllerC,fixtraEditable),
        _buildTextField('Current Address2', address2ControllerC,fixtraEditable),
        _buildTextField('Current Address3', address3ControllerC,fixtraEditable),

        Text(
          'Current State',
          style: TextStyle(fontSize: 16
),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          // Adjust the width as needed
          height: 45,
          // Fixed height
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButton<String>(
            value: selectedStateextraC,
            isExpanded: true,
            icon: Icon(Icons.arrow_downward),
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
          children: [
            Expanded(child: _buildTextField('Current City', cityControllerC,fixtraEditable)),
            SizedBox(width: 16),
            // Add spacing between the text fields if needed
            Expanded(
                child: _buildTextField2(
                    'Current PinCode', pincodeControllerC, TextInputType.number)),
          ],
        ),

        Row(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0), // Gap of 5 to the left for the second column
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start of the column
                children: [
                  Text(
                    'Is House Rental',
                    style: TextStyle(fontSize: 16
                    ),
                    textAlign: TextAlign.left, // Align text to the left
                  ),
                  SizedBox(height: 5), // Add some spacing between the Text and Container
                  Container(
                    height: 45,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton<String>(
                      value: selectedIsHouseRental,
                      isExpanded: true,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black, fontSize: 16),
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

        ],),

        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0), // Gap between columns
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // District
                    Text(
                      'District',
                      style: TextStyle(fontSize: 16
),
                    ),
                    SizedBox(height: 5), // Spacing between text and dropdown
                    Container(
                      height: 45,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: selectedDistrict,
                        isExpanded: true,
                        icon: Icon(Icons.arrow_downward),
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
                              selectedDistrict = newValue; // Update the selected value
                            });
                          }
                        },
                        items: states.map<DropdownMenuItem<String>>((RangeCategoryDataModel state) {
                          return DropdownMenuItem<String>(
                            value: state.code,
                            child: Text(state.descriptionEn),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 20), // Spacing between different fields

                    // Village
                    Text(
                      'Village',
                      style: TextStyle(fontSize: 16
),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: 45,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: selectedVillage,
                        isExpanded: true,
                        icon: Icon(Icons.arrow_downward),
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
                              selectedVillage = newValue; // Update the selected value
                            });
                          }
                        },
                        items: states.map<DropdownMenuItem<String>>((RangeCategoryDataModel state) {
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0), // Gap between columns
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sub District
                    Text(
                      'Sub District',
                      style: TextStyle(fontSize: 16
),
                    ),
                    SizedBox(height: 5), // Spacing between text and dropdown
                    Container(
                      height: 45,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: selectedSubDistrict,
                        isExpanded: true,
                        icon: Icon(Icons.arrow_downward),
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
                              selectedSubDistrict = newValue; // Update the selected value
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
                    SizedBox(height: 20), // Spacing between different fields

                    // Residing for (Years)
                    Text(
                      'Residing for (Years)',
                      style: TextStyle(fontSize: 16
),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: 45,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: selectedResidingFor,
                        isExpanded: true,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black, fontSize: 16),
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

        Row(children: [
          Column(children: [
            Text(
              'Property (In Acres)',
              style: TextStyle(fontSize: 16),
            ),
            Container(
              width: 150,
              // Adjust the width as needed
              height: 45,
              // Fixed height
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButton<String>(
                value: selectedProperty,
                isExpanded: true,
                icon: Icon(Icons.arrow_downward),
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
          ],),
          Column(children: [
            Text(
              'Present House Owner',
              style: TextStyle(fontSize: 16
              ),
            ),
            Container(
              width: 150,
              // Adjust the width as needed
              height: 45,
              // Fixed height
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButton<String>(
                value: selectedPresentHouseOwner,
                isExpanded: true,
                icon: Icon(Icons.arrow_downward),
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
                      selectedPresentHouseOwner =
                          newValue; // Update the selected value
                    });
                  }
                },
                items: landOwner
                    .map<DropdownMenuItem<String>>((RangeCategoryDataModel state) {
                  return DropdownMenuItem<String>(
                    value: state.code,
                    child: Text(state.descriptionEn),
                  );
                }).toList(),
              ),
            )
          ],)
        ],)
      ],
    ));
  }

  Widget _buildStepTwo() {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('Mother name', _motherFController,FiIncomeEditable),
        Row(
          children: [
            Expanded(
                child:
                    _buildTextField('Mother Middle Name', _motherMController,FiFamilyEditable)),
            SizedBox(width: 16),
            // Add spacing between the text fields if needed
            Expanded(
                child: _buildTextField('Mother Last Name', _motherLController,FiFamilyEditable)),
          ],
        ),
        _buildTextField('No. of Children', _numOfChildrenController,FiFamilyEditable),
        _buildTextField('Schooling Children', _schoolingChildrenController,FiFamilyEditable),
        _buildTextField('Other Dependents', _otherDependentsController,FiFamilyEditable),
      ],
    ));
  }

  Widget _buildStepThree() {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('Occupation', _occupationController,FiIncomeEditable),
        _buildTextField('Business Detail', _business_DetailController,FiIncomeEditable),
        _buildTextField2('Any Current EMI', _any_current_EMIController,
            TextInputType.number),
        _buildTextField2(
            'Future Income', _future_IncomeController, TextInputType.number),
        _buildTextField2('Agriculture Income', _agriculture_incomeController,
            TextInputType.number),
        _buildTextField2('Earning Members (count)',
            _earning_mem_countController, TextInputType.number),
        _buildTextField2(
            'Other_Income', _other_IncomeController, TextInputType.number),
        _buildTextField2(
            'AnnuaL INCOME', _annuaL_INCOMEController, TextInputType.number),
        _buildTextField2('Expense On Children', _spendOnChildrenController,
            TextInputType.number),
        _buildTextField2('Not AGRICULTURAL INCOME',
            _otheR_THAN_AGRICULTURAL_INCOMEController, TextInputType.number),
        _buildTextField2('Business Experience', _years_in_businessController,
            TextInputType.number),
        _buildTextField2(
            'Pension Income', _pensionIncomeController, TextInputType.number),
        _buildTextField2(
            'Rental Income', _any_RentalIncomeController, TextInputType.number),
        _buildTextField2('Rent', _rentController, TextInputType.number),
        _buildTextField2('Food', _foodingController, TextInputType.number),
        _buildTextField2(
            'Education', _educationController, TextInputType.number),
        _buildTextField2('Health', _healthController, TextInputType.number),
        _buildTextField2(
            'Travelling', _travellingController, TextInputType.number),
        _buildTextField2(
            'Entertainment', _entertainmentController, TextInputType.number),
        _buildTextField2('Others', _othersController, TextInputType.number),
        _buildTextField('Home Type', _homeTypeController,FinancialInfoEditable),
        _buildTextField('Roof Type', _homeRoofTypeController,FinancialInfoEditable),
        _buildTextField('Toilet Type', _toiletTypeController,FinancialInfoEditable),
        _buildTextField('Living With Spouse', _livingSpouseController,FinancialInfoEditable)
      ],
    ));
  }

  Widget _buildStepFour() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField('bankType', _bankTypeController,FinancialInfoEditable),
          _buildTextField('bank_Ac', _bank_AcController,FinancialInfoEditable),
          _buildTextField('bank_name', _bank_nameController,FinancialInfoEditable),
          _buildTextField('bank_IFCS', _bank_IFCSController,FinancialInfoEditable),
          _buildTextField('bank_address', _bank_addressController,FinancialInfoEditable),
          Text(
            'Bank Opening Date',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
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
          Row(
            children: [
              Expanded(
                  child: _buildTextField('Aadhaar Id', _aadharIdController,GuarantorEditable)),
              GestureDetector(
                onTap: () => _showPopup(context, (String result) {
                  setState(() {
                    qrResult = result;
                  });
                }), // Show popup on image click
                child: Icon(
                  Icons.qr_code_scanner,
                  size: 50.0, // Set the size of the icon
                  color: Colors.blue, // Set the color of the icon
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title',
                      style: TextStyle(fontSize: 16
),
                    ),
                    Container(
                      width: 150,
                      // Adjust the width as needed
                      height: 45,
                      // Fixed height
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: selectedTitle,
                        isExpanded: true,
                        icon: Icon(Icons.arrow_downward),
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
              GestureDetector(
                onTap: _pickImage,
                child: _imageFile == null
                    ? Icon(
                        Icons.person,
                        size: 50.0,
                        color: Colors.blue,
                      )
                    : Image.file(
                        File(_imageFile!.path),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
              ),
            ],
          ),
          _buildTextField('Name', _fnameController,GuarantorEditable),
          Row(
            children: [
              Expanded(child: _buildTextField('Middle Name', _mnameController,GuarantorEditable)),
              SizedBox(width: 16),
              // Add spacing between the text fields if needed
              Expanded(child: _buildTextField('Last Name', _lnameController,GuarantorEditable)),
            ],
          ),
          Text(
            'Gender',
            style: TextStyle(fontSize: 16
),
          ),
          Container(
            width: 150, // Adjust the width as needed
            height: 45, // Fixed height
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButton<String>(
              value: genderselected,
              isExpanded: true,
              icon: Icon(Icons.arrow_downward),
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
              }).toList(),
            ),
          ),
          Text(
            'Religion',
            style: TextStyle(fontSize: 16
),
          ),
          Container(
            width: 150,
            // Adjust the width as needed
            height: 45,
            // Fixed height
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButton<String>(
              value: religionselected,
              isExpanded: true,
              icon: Icon(Icons.arrow_downward),
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
          Text(
            'Relationship With Borrower',
            style: TextStyle(fontSize: 16
),
          ),
          Container(
            width: 150,
            // Adjust the width as needed
            height: 45,
            // Fixed height
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButton<String>(
              value: relationselected,
              isExpanded: true,
              icon: Icon(Icons.arrow_downward),
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
                    relationselected = newValue; // Update the selected value
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
          _buildTextField('Mobile no', _phoneController,GuarantorEditable),
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
          _buildTextField('Pan', _p_Address1Controller,GuarantorEditable),
          _buildTextField('Driving License', _p_Address1Controller,GuarantorEditable),
          _buildTextField('Voter Id', _p_Address1Controller,GuarantorEditable),
          _buildTextField('Address1', _p_Address1Controller,GuarantorEditable),
          _buildTextField('Address2', _p_Address2Controller,GuarantorEditable),
          _buildTextField('Address3', _p_Address3Controller,GuarantorEditable),
          Row(
            children: [
              Expanded(child: _buildTextField('City', _p_CityController,GuarantorEditable)),
              SizedBox(width: 16),
              Expanded(child: _buildTextField('Pincode', _pincodeController,GuarantorEditable)),
            ],
          ),
          Text(
            'State Name',
            style: TextStyle(fontSize: 16
),
          ),
          Container(
            width: 150,
            // Adjust the width as needed
            height: 45,
            // Fixed height
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButton<String>(
              value: stateselected,
              isExpanded: true,
              icon: Icon(Icons.arrow_downward),
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
        ],
      ),
    );
  }

  Widget _buildStepSix() {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildKycDocumentList(), // Call the function here
    ));
  }

  /*Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFA60A19),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {
          if (_currentStep < 5) {
            setState(() {
              _currentStep += 1;
            });
          } else if (_formKey.currentState?.validate() ?? false) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Form submitted successfully")),
            );
          }
        },

    */
  /*onPressed: () {
      if (_currentStep == 0) {
        AddFiExtraDetail(context);
      } else if (_currentStep == 1) {
        AddFiFamilyDetail(context);
      } else if (_currentStep == 2) {
        AddFiIncomeAndExpense(context);
      } else if (_currentStep == 3) {
        AddFinancialInfo(context);
      } else if (_currentStep == 4) {
        saveGuarantorMethod(context);
      } else if (_currentStep == 5) {
        UploadFiDocs(context, widget.selectedData.id.toString());
      }
    },*/
  /*

        child: Text(
          _currentStep == 2 ? "SUBMIT" : "NEXT",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildPreviousButton() {
    if (_currentStep == 0) {
      return SizedBox.shrink(); // Don't show the button on the first page
    }
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
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
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: toggleEditMode,
        child: Text(
          _isEditing ? "SAVE" : "EDIT",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }*/

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
          padding: EdgeInsets.symmetric(vertical: 16),
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
          style: TextStyle(color: Colors.white, fontSize: 16),
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
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: toggleEditMode,
        child: Text(
          _isEditing ? "SAVE" : "EDIT",
          style: TextStyle(color: Colors.white, fontSize: 16),
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
          padding: EdgeInsets.symmetric(vertical: 16),
        ),

        onPressed: () {
          if (_currentStep < 5) {
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
            AddFiExtraDetail(context);
          } else if (_currentStep == 1) {
            AddFiFamilyDetail(context);
          } else if (_currentStep == 2) {
            AddFiIncomeAndExpense(context);
          } else if (_currentStep == 3) {
            AddFinancialInfo(context);
          } else if (_currentStep == 4) {
            saveGuarantorMethod(context);
          } else if (_currentStep == 5) {
            UploadFiDocs(context, widget.selectedData.id.toString());
          }

          if (_currentStep < 5) {
            setState(() {
              _currentStep += 1;
            });
          } else if (_currentStep == 5) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Form submitted successfully")),
            );
          }
        },*/
        child: Text(
          _currentStep == 5 ? "SUBMIT" : "NEXT",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  void toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }
}
