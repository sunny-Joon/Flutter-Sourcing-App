import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/GlobalClass.dart';
import 'package:flutter_sourcing_app/Models/GroupModel.dart';
import 'package:flutter_sourcing_app/Models/branch_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'ApiService.dart';
import 'DATABASE/DatabaseHelper.dart';
import 'Models/BorrowerListModel.dart';
import 'Models/RangeCategoryModel.dart';
import 'QRScanPage.dart';

class KYCPage extends StatefulWidget {


  final BranchDataModel data;
  final GroupDataModel GroupData;

  KYCPage({
    required this.data,
    required this.GroupData
  });

  @override
  _KYCPageState createState() => _KYCPageState();
}

class _KYCPageState extends State<KYCPage> {


  List<RangeCategoryDataModel> states = [];
  List<RangeCategoryDataModel> relation = [];
  List<RangeCategoryDataModel> reasonForLoan = [];
  List<RangeCategoryDataModel> aadhar_gender = [];
  List<RangeCategoryDataModel> business_Type = [];
  List<RangeCategoryDataModel> income_type = [];
  List<RangeCategoryDataModel> bank = [];
  List<RangeCategoryDataModel> relationwithBorrower = [];

  List<String> loanDuration = ['12', '24', '36', '48'];


  List<String> titleList = ["Select", "Mr.", "Mrs.", "Miss"];
  String titleselected = "Select";
  String selectedTitle = "Select";
  String expense = "";
  String income = "";
  String lati = "";
  String longi = "";


  bool isMarried = false;
  String stateselected = 'select';
  String genderselected = 'select';
  String relationwithBorrowerselected = 'select';
  String bankselected = 'select';

  String? selectedloanDuration;
  String? _locationMessage;
  Position? position;

  @override
  void initState() {
    // IDVerification('LAMPS2172L', 'pancard', '', '');
    // print(IDVerification('LAMPS2172L', 'pancard', '', ''));
    fetchData();
    selectedloanDuration = loanDuration.isNotEmpty ? loanDuration[0] : null;

    super.initState();
    _dobController.addListener(() {
      _calculateAge();



      geolocator();

    });
// Fetch states using the required cat_key
  }


  Future<void> fetchData() async {
    states = await DatabaseHelper().selectRangeCatData("state");
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


  int _currentStep = 0;
  final _formKeys = List.generate(4, (index) => GlobalKey<FormState>());
  DateTime? _selectedDate;

  // TextEditingControllers for all input fields
  final _aadharIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _nameMController = TextEditingController();
  final _nameLController = TextEditingController();
  final _ageController = TextEditingController();
  final _dobController = TextEditingController();
  final _mobileNoController = TextEditingController();
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

  get isChecked => false;

  get http => null;

  void _pickImage() async {
    File? pickedImage = await GlobalClass().pickImage();
    if (pickedImage != null) {
      setState(() {
        _imageFile = pickedImage;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
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
      body: Center(
        child: Container(
          height: MediaQuery
              .of(context)
              .size
              .height - 100,
          width: MediaQuery
              .of(context)
              .size
              .width - 24,
          decoration: BoxDecoration(
              color: Colors.white
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 10),
            child: Stepper(
              type: StepperType.horizontal,
              currentStep: _currentStep,
              onStepContinue: () {
                // Validate the current step's form before proceeding
                if (_formKeys[_currentStep].currentState?.validate() ?? false) {
                  // Call the save method based on the current step
                  if (_currentStep == 0) {
                    saveFiMethod(context); // Call save method for step 0
                  } else if (_currentStep == 1) {
                    saveIDsMethod(context);
                  }
                  /*if (_currentStep < 3) {
                      setState(() {
                        _currentStep += 1;
                      });
                    }*/
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() {
                    _currentStep -= 1;
                  });
                }
              },
              controlsBuilder: (BuildContext context,
                  ControlsDetails controls) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 150,
                      child: TextButton(
                        onPressed: () {
                          // Check if either latitude or longitude is empty or '0'
                          if ((_latitudeController.text.isEmpty ||
                              _latitudeController.text == '0') ||
                              (_longitudeController.text.isEmpty ||
                                  _longitudeController.text == '0')) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(
                                  "Please click the refresh button first to update location")),
                            );
                          } else {
                            // Proceed to the next step if latitude and longitude are valid
                            controls.onStepContinue?.call();
                          }
                        },
                        child: Text(
                          'Next',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFFD42D3F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.elliptical(5, 5)),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },

              steps: [
                Step(
                  title: Text(''),
                  isActive: _currentStep >= 0,
                  content: Form(
                    key: _formKeys[0],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: _buildTextField2(
                                    'Aadhaar Id', _aadharIdController,TextInputType.number,12)),
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
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Container(
                                    width: 150,
                                    // Adjust the width as needed
                                    height: 35,
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
                        _buildTextField('Name', _nameController,10),
                        Row(
                          children: [
                            Expanded(
                                child: _buildTextField(
                                    'Middle Name', _nameMController,10)),
                            SizedBox(
                                width:
                                16),
                            // Add spacing between the text fields if needed
                            Expanded(
                                child: _buildTextField(
                                    'Last Name', _nameLController,10)),
                          ],
                        ),
                        Text(
                          'Gender',
                          style: TextStyle(fontSize: 16),
                        ),
                        Container(
                          width: 150,
                          // Adjust the width as needed
                          height: 35,
                          // Fixed height
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

                        Text(
                          'Relationship with Borrower',
                          style: TextStyle(fontSize: 16),
                        ),
                        Container(
                          width: 150,
                          // Adjust the width as needed
                          height: 35,
                          // Fixed height
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButton<String>(
                            value: relationwithBorrowerselected,
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
                                  relationwithBorrowerselected =
                                      newValue; // Update the selected value
                                });
                              }
                            },
                            items: relationwithBorrower.map<
                                DropdownMenuItem<String>>(
                                    (RangeCategoryDataModel state) {
                                  return DropdownMenuItem<String>(
                                    value: state.code,
                                    child: Text(state.descriptionEn),
                                  );
                                }).toList(),
                          ),
                        ),
                        _buildTextField2('Mobile no', _mobileNoController, TextInputType.number, 10),

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
                                          onPressed: () => _selectDate(context),
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
                        _buildTextField(
                            'Father First Name', _fatherFirstNameController,10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField('Father Middle Name',
                                  _fatherMiddleNameController,10),
                            ),
                            SizedBox(
                                width:
                                8),
                            // Add spacing between the text fields if needed
                            Expanded(
                                child: _buildTextField('Father Last Name',
                                    _fatherLastNameController,10)),
                          ],
                        ),
                        CheckboxListTile(
                          title: Text('IsMarried'),
                          value: isMarried,
                          onChanged: (bool? value) {
                            setState(() {
                              isMarried = value!;
                            });
                          },
                        ),
                        // Conditionally show the spouse fields only when isMarried is true
                        if (isMarried)
                          Column(
                            children: [
                              _buildTextField('Spouse First Name',
                                  _spouseFirstNameController,10),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField('Spouse Middle Name',
                                        _spouseMiddleNameController,10),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: _buildTextField('Spouse Last Name',
                                        _spouseLastNameController,10),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        Row(
                          children: [
                            Expanded(
                                child: _buildTextField2(
                                    'Monthly Expense', _incomeController,TextInputType.number,6)),
                            SizedBox(
                                width:
                                8),
                            // Add spacing between the text fields if needed
                            Expanded(
                                child: _buildTextField2(
                                    'Monthly Income', _expenseController,TextInputType.number,6)),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                        'Latitude', _latitudeController,12),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                        'Longitude', _longitudeController,12),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            SizedBox(
                              height: 40, // Smaller height for compact button
                              width: 40, // Smaller width for compact button
                              child: ElevatedButton(
                                onPressed: geolocator,
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(0),
                                  // Remove padding for smaller size
                                  minimumSize: Size(
                                      40, 40), // Ensure button remains compact
                                ),
                                child: Icon(
                                  Icons.refresh,
                                  size: 18, // Smaller icon size for compact look
                                ),
                              ),
                            ),
                          ],
                        ),


                        _buildTextField('Address1', _address1Controller,25),
                        _buildTextField('Address2', _address2Controller,25),
                        _buildTextField('Address3', _address3Controller,25),
                        Row(
                          children: [
                            Expanded(
                                child:
                                _buildTextField('City', _cityController,15)),
                            SizedBox(width: 16),
                            Expanded(
                                child: _buildTextField2(
                                    'Pincode', _pincodeController,TextInputType.number,6)),
                          ],
                        ),
                        Text(
                          'State Name',
                          style: TextStyle(fontSize: 16),
                        ),
                        Container(
                          width: double.infinity,
                          // Adjust the width as needed
                          height: 35,
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
                        _buildTextField2('Loan Amount',
                            _loan_amountController, TextInputType.number,6),


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
                                    width: 150,
                                    // Adjust the width as needed
                                    height: 35,
                                    // Fixed height
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: DropdownButton<String>(
                                      value: selectedloanDuration,
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
                                    height: 35,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: DropdownButton<String>(
                                      value: bankselected,
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
                                        if (newValue != null) {
                                          setState(() {
                                            bankselected = newValue;
                                          });
                                        }
                                      },
                                      items: bank.map<
                                          DropdownMenuItem<String>>((
                                          RangeCategoryDataModel state) {
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


                        /*    Row(
                          children: [
                            Expanded(
                                child: _buildTextField(
                                    'Group Code', _groupCodeController)),
                            SizedBox(width: 16),
                            Expanded(
                                child: _buildTextField(
                                    'Branch Code', _branchCodeController)),
                          ],
                        ),*/
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

                        Row(
                          children: [
                            Expanded(
                                child: _buildTextField('Permanent Account PAN No', _panNoController,10)   ),
                            SizedBox(width: 16),
                            Checkbox(
                              value: isChecked, // Replace with a variable to track the checkbox state
                              onChanged: (bool? value) {
                                setState(() {
                               //   isChecked = value!; // Update the checkbox state
                                });
                              },
                            ),
                          ],
                       ),


                        _buildTextField('Permanent Account PAN No', _panNoController,10),
                        _buildTextField(
                            'Driving License', _drivingLicenseController,16),
                        _buildTextField('Voter Id', _voterIdController,16),
                        _buildTextField('Passport', _passportController,16),
                      ],
                    ),
                  ),
                ),
              ],
              stepIconHeight: 25,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, int maxLength, {TextInputType inputType = TextInputType.text}) {
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
          SizedBox(height: 8), // Increased spacing for better layout
          Container(
            width: double.infinity, // Set the desired width
            height: 45, // Set the desired height
            child: TextFormField(
              controller: controller,
              keyboardType: inputType, // Set the keyboard type
              maxLength: maxLength, // Set max length
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                counterText: '', // Hide character counter if not needed
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter $label';
                }
                return null; // Valid input
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveFiMethod(BuildContext context) async {
    print("object");
    String adhaarid = _aadharIdController.text.toString();
    String title = titleselected;
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
    income = _expenseController.text;
    lati = _latitudeController.text;
    longi = _longitudeController.text;
    int Expense = int.parse(expense);
    int Income = int.parse(income);
    double latitude = double.parse(lati);
    double longitude = double.parse(longi);
    String add1 = _address1Controller.text.toString();
    String add2 = _address2Controller.text.toString();
    String add3 = _address3Controller.text.toString();
    String city = _cityController.text.toString();
    String pin = _pincodeController.text.toString();
    String state = stateselected;
    bool ismarried = isMarried;
    String gCode = widget.GroupData.groupCode;
    String bCode = widget.data.branchCode.toString();

    String relation_with_Borrower = relationwithBorrowerselected;

    String bank_name = bankselected;
    String loan_Duration = selectedloanDuration!;
    String loan_amount = _loan_amountController.text.toString();

    print("add 3 $add3");

    final api = Provider.of<ApiService>(context, listen: false);

    return await api
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
        "creator",
        Expense,
        Income,
        latitude,
        longitude,
        add1,
        add2,
        add2,
        city,
        pin,
        state,
        ismarried,
        gCode,
        bCode,

        relation_with_Borrower,
        bank_name,
        loan_Duration!,
        loan_amount,

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

  Future<void> saveIDsMethod(BuildContext context) async {
    print("object");
    String fiid = Fi_Id.toString();
    String pan_no = _panNoController.text.toString();
    String dl = _drivingLicenseController.text.toString();
    String voter_id = _voterIdController.text.toString();
    String passport = _passportController.text.toString();
    int isAadharVerified = 1;
    int is_phnno_verified = 1;
    int isNameVerify = 1;

    final api = Provider.of<ApiService>(context, listen: false);

    Map<String, dynamic> requestBody = {
      "Fi_ID": fiid,
      "pan_no": pan_no,
      "dl": dl,
      "voter_id": voter_id,
      "passport": passport,
      "isAadharVerified": isAadharVerified,
      "is_phnno_verified": is_phnno_verified,
      "isNameVerify": isNameVerify
    };


    return await api
        .addFiIds(GlobalClass.token, GlobalClass.dbName, requestBody)
        .then((value) async {
      if (value.statuscode == 200) {
        setState(() {
          _currentStep += 1;
        });
      } else {}
    });
  }


  //////////////////////////

 /* Future<void> IDVerification(String id, String type, String bankIfsc, String dob) async {
    final response = await http.post(
      Uri.parse('https://agra.paisalo.in:8462/creditmatrix/api/IdentityVerification/Get'), // Complete API URL with endpoint
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "type": type,
        "txtnumber": id,
        "ifsc": bankIfsc,
        "userdob": dob,
        "key": "1"
      }),
    );

    String name="";
    String errorMessage="";
    if (response.statusCode == 200) {
      // Parse the response JSON
      final data = json.decode(response.body);
      if (data['data'] != null) {
        setState(() {
          name = data['data']['name'] ?? 'Not Found'; // Set name if found
          errorMessage = ''; // Clear any previous error message
        });
      } else {
        setState(() {
          name = 'Not Found'; // If no data returned
        });
      }
    } else {
      setState(() {
        errorMessage = 'Failed to verify ID: ${response.reasonPhrase}';
        name = '';
      });
    }
  }

*/

  void savePersonalDetailsMethod() {}

  void saveDataMethod() {}

  Widget _buildTextField2(String label, TextEditingController controller, TextInputType inputType, int maxLength) {
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
          SizedBox(height: 8), // Use a larger size for spacing
          Container(
            width: double.infinity, // Set the desired width
            height: 45, // Set the desired height
            child: TextFormField(
              controller: controller,
              keyboardType: inputType, // Set the input type
              maxLength: maxLength, // Apply max length
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                counterText: '', // Hide the character counter if desired
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter $label';
                }
                return null; // Valid input
              },
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
                        MaterialPageRoute(builder: (context) =>
                            QRViewExample()),
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

  List<List<int>> separateData(List<int> source, int separatorByte,
      int vtcIndex) {
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

  Future<void> geolocator() async {
    try {
      position = await _getCurrentPosition();
      setState(() {
        if (position != null) {
          _locationMessage =
          "Latitude: ${position!.latitude}, Longitude: ${position!.longitude}";
          print("Geolocation: $_locationMessage");
          _latitudeController.text = position!.latitude.toString();
          _longitudeController.text = position!.longitude.toString();
        }
      });
    } catch (e) {
      setState(() {
        _locationMessage = e.toString();
      });
      print("Geolocation Error: $_locationMessage");
      _latitudeController.clear();
      _longitudeController.clear();
    }
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
    await geolocator(); // Call to get location and update fields
  }
}


