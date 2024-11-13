import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/GlobalClass.dart';
import 'package:flutter_sourcing_app/Models/GroupModel.dart';
import 'package:flutter_sourcing_app/Models/branch_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
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
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  List<RangeCategoryDataModel> states = [];
  List<RangeCategoryDataModel> marrital_status = [];
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
  String? selectedMarritalStatus;

  String stateselected = 'select';
  String genderselected = 'select';
  String relationwithBorrowerselected = 'select';
  String bankselected = 'select';

  String? selectedloanDuration;
  String? _locationMessage;
  Position? position;

  @override
  void initState() {
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
  final _dlExpiryController = TextEditingController();
  final _passportExpiryController = TextEditingController();

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

  get isChecked => null;

  void _pickImage() async {
    File? pickedImage = await GlobalClass().pickImage();
    if (pickedImage != null) {
      setState(() {
        _imageFile = pickedImage;
      });
    }
  }

  Widget _buildDatePickerField(BuildContext context,String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: () => _selectDate(context, controller),
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
  void _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
    if(controller == _dobController){
      _calculateAge();
    }
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

  /*@override
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
                  */
  /*if (_currentStep < 3) {
                      setState(() {
                        _currentStep += 1;
                      });
                    }*/
  /*
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
                                    height:  45,
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
                        _buildTextField('Name', _nameController),
                        Row(
                          children: [
                            Expanded(
                                child: _buildTextField(
                                    'Middle Name', _nameMController)),
                            SizedBox(
                                width:
                                16),
                            // Add spacing between the text fields if needed
                            Expanded(
                                child: _buildTextField(
                                    'Last Name', _nameLController)),
                          ],
                        ),
                        Text(
                          'Gender',
                          style: TextStyle(fontSize: 16),
                        ),
                        Container(
                          width: 150,
                          // Adjust the width as needed
                          height:  45,
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

                        Text(
                          'Relationship with Borrower',
                          style: TextStyle(fontSize: 16),
                        ),
                        Container(
                          width: 150,
                          // Adjust the width as needed
                          height:  45,
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
                        _buildTextField('Mobile no', _mobileNoController),
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
                            'Father First Name', _fatherFirstNameController),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField('Father Middle Name',
                                  _fatherMiddleNameController),
                            ),
                            SizedBox(
                                width:
                                8),
                            // Add spacing between the text fields if needed
                            Expanded(
                                child: _buildTextField('Father Last Name',
                                    _fatherLastNameController)),
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
                                  _spouseFirstNameController),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField('Spouse Middle Name',
                                        _spouseMiddleNameController),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: _buildTextField('Spouse Last Name',
                                        _spouseLastNameController),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        Row(
                          children: [
                            Expanded(
                                child: _buildTextField(
                                    'Monthly Expense', _incomeController)),
                            SizedBox(
                                width:
                                8),
                            // Add spacing between the text fields if needed
                            Expanded(
                                child: _buildTextField(
                                    'Monthly Income', _expenseController)),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                        'Latitude', _latitudeController),
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
                                        'Longitude', _longitudeController),
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


                        _buildTextField('Address1', _address1Controller),
                        _buildTextField('Address2', _address2Controller),
                        _buildTextField('Address3', _address3Controller),
                        Row(
                          children: [
                            Expanded(
                                child:
                                _buildTextField('City', _cityController)),
                            SizedBox(width: 16),
                            Expanded(
                                child: _buildTextField(
                                    'Pincode', _pincodeController)),
                          ],
                        ),
                        Text(
                          'State Name',
                          style: TextStyle(fontSize: 16),
                        ),
                        Container(
                          width: double.infinity,
                          // Adjust the width as needed
                          height:  45,
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
                            _loan_amountController, TextInputType.number),


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
                                    height:  45,
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
                                    height:  45,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: DropdownButton<String>(
                                      value: bankselected,
                                      isExpanded: true,

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


                        */
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
  /*
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

                      */
  /*  Row(
                          children: [
                            Expanded(
                                child: _buildTextField('Permanent Account PAN No', _panNoController)   ),
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
                       ), */
  /*


                        _buildTextField('Permanent Account PAN No', _panNoController),
                        _buildTextField(
                            'Driving License', _drivingLicenseController),
                        _buildTextField('Voter Id', _voterIdController),
                        _buildTextField('Passport', _passportController),
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
  }*/

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
                          'assets/Images/paisa_logo.png',
                          // Replace with your logo asset path
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
                //  _buildProgressIndicator(),
                SizedBox(height: 40),
                Expanded(
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
                              color: Colors.grey.shade300,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: _getStepContent(context),
                        ),
                      ),
                      Positioned(
                        top: -45, // Adjust the position as needed
                        left: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _pickImage,
                          child: Center(
                            child: _imageFile == null
                                ? ClipOval(
                              child: Container(
                                width: 70,
                                height: 70,
                                color: Colors.blue,
                                child: Icon(
                                  Icons.person,
                                  size: 50.0,
                                  color: Colors.white,
                                ),
                              ),
                            )
                                : ClipOval(
                              child: Image.file(
                                File(_imageFile!.path),
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),
                _buildNextButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
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
    int Expense = (expense != null && expense.isNotEmpty) ? int.parse(expense) : 0;
    int Income = (income != null && income.isNotEmpty) ? int.parse(income) : 0;
    double latitude = (lati != null && lati.isNotEmpty) ? double.parse(lati) : 0.0;
    double longitude = (longi != null && longi.isNotEmpty) ? double.parse(longi) : 0.0;
    String add1 = _address1Controller.text.toString();
    String add2 = _address2Controller.text.toString();
    String add3 = _address3Controller.text.toString();
    String city = _cityController.text.toString();
    String pin = _pincodeController.text.toString();
    String state = stateselected;
    bool ismarried = selectedMarritalStatus.toString() == 'Married';
    String gCode = widget.GroupData.groupCode;
    String bCode = widget.data.branchCode.toString();

    String relation_with_Borrower = relationwithBorrowerselected;

    String bank_name = bankselected;
    String loan_Duration = selectedloanDuration!;
    String loan_amount = _loan_amountController.text.toString();
    String? Image;
    if(_imageFile == null){
      Image = 'Null';
    }

    var fields = {
      "Aadhaar ID": adhaarid,
      "Title": title,
      "Name": name,
      "Middle Name": middlename,
      "Last Name": lastname,
      "Date of Birth": dob,
      "Age": age,
      "Gender": gendre,
      "Mobile Number": mobile,
      "Father's First Name": fatherF,
      "Father's Middle Name": fatherM,
      "Father's Last Name": fatherL,
      "Spouse's First Name": spouseF,
      "Spouse's Middle Name": spouseM,
      "Spouse's Last Name": spouseL,
      "Expense": expense,
      "Income": income,
      "Latitude": lati,
      "Longitude": longi,
      "Address Line 1": add1,
      "Address Line 2": add2,
      "Address Line 3": add3,
      "City": city,
      "Pincode": pin,
      "State": state,
      "Relation with Borrower": relation_with_Borrower,
      "Bank Name": bank_name,
      "Loan Duration": loan_Duration,
      "Loan Amount": loan_amount,
      "Image":Image,
    };

    // Check for blank fields
    for (var field in fields.entries) {
      if (field.value == null || field.value!.isEmpty) {
        showAlertDialog(context, "Please fill in the ${field.key} field.");
        return;
      }
    }

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

  void savePersonalDetailsMethod() {}

  void saveDataMethod() {}

  Widget _buildTextField2(String label, TextEditingController controller,
      TextInputType inputType) {
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
            Expanded(child: _buildTextField('Aadhaar Id', _aadharIdController)),
            Padding(
              padding: EdgeInsets.only(top: 20), // Add 10px padding from above
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
                    height: 45, // Fixed height
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
            SizedBox(
                width:
                    10), // Add spacing between Title dropdown and Name field if needed
            Expanded(
              child: _buildTextField('Name', _nameController),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildTextField('Middle Name', _nameMController)),
            SizedBox(width: 10),
            // Add spacing between the text fields if needed
            Expanded(child: _buildTextField('Last Name', _nameLController)),
          ],
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gender',
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
                  height: 45,
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
            )
          ],
        ),

        Row(
          children: [
            Expanded(
              child: _buildTextField('Mobile no', _mobileNoController),
            ),
            SizedBox(
                width: 10), // Add spacing between the text field and the button
            Padding(
              padding: EdgeInsets.only(top: 20), // Add 10px padding from above
              child: ElevatedButton(
                onPressed: () {
                  // Implement OTP verification logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFA60A19), // Button color
                  minimumSize: Size(100, 45), // Fixed size for the button
                ),
                child: Text(
                  'Verify',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
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
                          onPressed: () => _selectDate(context,_dobController),
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
        _buildTextField('Father First Name', _fatherFirstNameController),
        Row(
          children: [
            Expanded(
              child:
                  _buildTextField('Middle Name', _fatherMiddleNameController),
            ),
            SizedBox(width: 8),
            // Add spacing between the text fields if needed
            Expanded(
                child: _buildTextField('Last Name', _fatherLastNameController)),
          ],
        ),
        Text(
          'Marital Status',
          style: TextStyle(fontSize: 16),
        ),
        Container(
          width: double.infinity,
          // Adjust the width as needed
          height: 45,
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
                  selectedMarritalStatus = newValue; // Update the selected value
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
        if (equals(selectedMarritalStatus.toString(), 'Married'))
          Column(
            children: [
              _buildTextField('Spouse First Name', _spouseFirstNameController),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                        'Middle Name', _spouseMiddleNameController),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child:
                        _buildTextField('Last Name', _spouseLastNameController),
                  ),
                ],
              ),
            ],
          ),
        Row(
          children: [
            Expanded(
                child: _buildTextField('Monthly Expense', _incomeController)),
            SizedBox(width: 8),
            // Add spacing between the text fields if needed
            Expanded(
                child: _buildTextField('Monthly Income', _expenseController)),
          ],
        ),
        _buildTextField('Address1', _address1Controller),
        _buildTextField('Address2', _address2Controller),
        _buildTextField('Address3', _address3Controller),
        Row(
          children: [
            Expanded(child: _buildTextField('City', _cityController)),
            SizedBox(width: 16),
            Expanded(child: _buildTextField('Pincode', _pincodeController)),
          ],
        ),
        Text(
          'State Name',
          style: TextStyle(fontSize: 16),
        ),
        Container(
          width: double.infinity,
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
            items: states
                .map<DropdownMenuItem<String>>((RangeCategoryDataModel state) {
              return DropdownMenuItem<String>(
                value: state.code,
                child: Text(state.descriptionEn),
              );
            }).toList(),
          ),
        ),
        _buildTextField2(
            'Loan Amount', _loan_amountController, TextInputType.number),

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
                    height: 45,
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
                    height: 45,
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
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildTextField('Latitude', _latitudeController),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildTextField('Longitude', _longitudeController),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Padding(
              padding: EdgeInsets.only(top: 20), // Add 10px padding from above
              child: SizedBox(
                height: 40, // Smaller height for compact button
                width: 40, // Smaller width for compact button
                child: ElevatedButton(
                  onPressed: geolocator,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(0),
                    // Remove padding for smaller size
                    minimumSize: Size(40, 40), // Ensure button remains compact
                  ),
                  child: Icon(
                    Icons.refresh,
                    size: 18, // Smaller icon size for compact look
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    ));
  }

  Widget _buildStepTwo(BuildContext context) {
    bool isPanVerified,isDrivingLicenseVerified,isVoterIdVerified,isPassportVerified;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildTextField('PAN No', _panNoController),
              ),
              SizedBox(width: 10),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: _buildVerificationIcon(
                  isPanVerified = true,
                      () {
                    setState(() {
                      isPanVerified = !isPanVerified;
                    });
                    // Implement OTP verification logic here
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildTextField('Driving License', _drivingLicenseController),
              ),
              SizedBox(width: 10),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: _buildVerificationIcon(
                  isDrivingLicenseVerified = true,
                      () {
                    setState(() {
                      isDrivingLicenseVerified = !isDrivingLicenseVerified;
                    });
                    // Implement OTP verification logic here
                  },
                ),
              ),
            ],
          ),
          _buildDatePickerField(context, 'DL Expiry Date', _dlExpiryController),
          Row(
            children: [
              Expanded(
                child: _buildTextField('Voter Id', _voterIdController),
              ),
              SizedBox(width: 10),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: _buildVerificationIcon(
                  isVoterIdVerified = true,
                      () {
                    setState(() {
                      isVoterIdVerified = !isVoterIdVerified;
                    });
                    // Implement OTP verification logic here
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildTextField('Passport', _passportController),
              ),
              SizedBox(width: 10),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: _buildVerificationIcon(
                  isPassportVerified= false,
                      () {
                    setState(() {
                      isPassportVerified = !isPassportVerified;
                    });
                    // Implement OTP verification logic here
                  },
                ),
              ),
            ],
          ),
          _buildDatePickerField(context, 'Passport Expiry Date', _passportExpiryController),
        ],
      ),
    );
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
         /* if (_currentStep == 0) {
            saveFiMethod(context);
          } else if (_currentStep == 1) {
            saveIDsMethod(context);
          } else if (_currentStep > 1) {
            showKycDoneDialog(context);
          }*/

        if (_currentStep < 2) {
          setState(() {
            _currentStep += 1;
          });
        } else if (_currentStep == 2) {
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
                Navigator.of(context).pop();  // Close the dialog
                Navigator.of(context).pop();  // Close the current class
              },
            ),
          ],
        );
      },
    );
  }
}

Widget _buildVerificationIcon(bool isVerified, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isVerified ? Colors.green : Colors.red,
      ),
      child: Icon(
        isVerified ? Icons.check_circle : Icons.check_circle_outline,
        color: Colors.white,
      ),
    ),
  );
}
