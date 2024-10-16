import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/GlobalClass.dart';
import 'package:flutter_sourcing_app/Models/branch_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'ApiService.dart';
import 'DATABASE/DatabaseHelper.dart';
import 'Models/BorrowerListModel.dart';
import 'Models/RangeCategoryModel.dart';
import 'QRScanPage.dart';

class KYCPage extends StatefulWidget {
  final BranchDataModel data;

  KYCPage({required this.data});

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

  List<String> titleList = ["Select", "Mr.", "Mrs.", "Miss"];
   String titleselected="Select";
  String selectedTitle = "Select";

  bool isMarried = false;
  String stateselected = 'select';
  String genderselected = 'select';

  @override
  void initState() {
    fetchData();
    super.initState();
    _dobController.addListener(() {
      _calculateAge();
    });
// Fetch states using the required cat_key
  }

  Future<void> fetchData() async {
    states = await DatabaseHelper().selectRangeCatData("state");
    relation = await DatabaseHelper().selectRangeCatData("relationship");
    reasonForLoan = await DatabaseHelper().selectRangeCatData("loan_purpose");
    aadhar_gender = await DatabaseHelper().selectRangeCatData("gender");
    business_Type = await DatabaseHelper().selectRangeCatData("business-type"); // Call your SQLite method
    income_type = await DatabaseHelper().selectRangeCatData("income-type"); // Call your SQLite method
    bank = await DatabaseHelper().selectRangeCatData("banks"); // Call your SQLite method

    setState(() {
      states.insert(0, RangeCategoryDataModel(
        catKey: 'Select',
        groupDescriptionEn: 'select',
        groupDescriptionHi: 'select',
        descriptionEn: 'Select', // Display text
        descriptionHi: 'select',
        sortOrder: 0,
        code: 'select', // Value of the placeholder
      ));
      aadhar_gender.insert(0, RangeCategoryDataModel(
        catKey: 'Select',
        groupDescriptionEn: 'select',
        groupDescriptionHi: 'select',
        descriptionEn: 'Select', // Display text
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
  final _genderController = TextEditingController();
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
  final _stateNameController = TextEditingController();
  final _groupCodeController = TextEditingController();
  final _branchCodeController = TextEditingController();

  final _voterIdController = TextEditingController();
  final _panNoController = TextEditingController();
  final _drivingLicenseController = TextEditingController();
  final _districtController = TextEditingController();
  final _subDistrictController = TextEditingController();
  final _villageController = TextEditingController();
  final _motherFirstNameController = TextEditingController();
  final _motherMiddleNameController = TextEditingController();
  final _motherLastNameController = TextEditingController();
  final _monthlyIncomeController = TextEditingController();
  final _monthlyExpenseController = TextEditingController();
  final _futureIncomeController = TextEditingController();
  final _agricultureIncomeController = TextEditingController();
  final _pensionIncomeController = TextEditingController();
  final _interestIncomeController = TextEditingController();
  final _otherIncomeController = TextEditingController();
  final _earningMemberIncomeController = TextEditingController();
  final _earningMemberTypeController = TextEditingController();
  final _loanAmtController = TextEditingController();
  final _businessDetailController = TextEditingController();
  final _loanReasonController = TextEditingController();
  final _OccupationController = TextEditingController();
  final _loanDurationController = TextEditingController();
  final _selectBankController = TextEditingController();

  String? selectedState;
  String? selectedEarningMemberType;
  String? selectedBusinessDetail;
  String? selectedLoanPurpose;
  String? selectedOccupation;
  String? selectedLoanDuration;
  String? selectedBank;
  String qrResult="";


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
        _dobController.text = DateFormat('MM/dd/yyyy').format(picked);
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
      appBar: AppBar(
        title: Text('KYC'),
        backgroundColor: Color(0xFFD42D3F),
      ),
      backgroundColor: Color(0xFFD42D3F),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          width: MediaQuery.of(context).size.width - 50,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Images/curvedBackground.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 80),
            child:  Stepper(
              type: StepperType.horizontal,
              currentStep: _currentStep,
              onStepContinue: () {
                if (_formKeys[_currentStep].currentState?.validate() ?? false) {
                  if (_currentStep == 1) saveFiMethod(context);
                  if (_currentStep == 2) saveAddressMethod();
                  if (_currentStep == 3) savePersonalDetailsMethod();
                  if (_currentStep == 4) saveDataMethod();
                  if (_currentStep < 4) {
                    setState(() {
                      _currentStep += 1;
                    });
                  }
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() {
                    _currentStep -= 1;
                  });
                } else {
                  setState(() {
                    _currentStep = 0;
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
                  )
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
                              child:
                                  _buildTextField(
                                      'Aadhaar Id', _aadharIdController)
                            ),
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
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Container(
                                    width: 150, // Adjust the width as needed
                                    height: 35, // Fixed height
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
                                        color: Colors.transparent, // Set to transparent to remove default underline
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
                              // onTap: () => _showPopup(context, qrResult!),
                              child: Icon(
                                Icons.person,
                                size: 50.0, // Set the size of the icon
                                color: Colors.blue, // Set the color of the icon
                              ),
                            ),
                          ],
                        ),

                        _buildTextField('Name', _nameController),
                        Row(
                          children: [
                            Expanded(child: _buildTextField('Middle Name', _nameMController)),
                            SizedBox(width: 16), // Add spacing between the text fields if needed
                            Expanded(child: _buildTextField('Last Name', _nameLController)),
                          ],
                        ),

                        Text(
                          'Gender',
                          style: TextStyle(fontSize: 20),
                        ),
                        Container(
                          width: 150, // Adjust the width as needed
                          height: 35, // Fixed height
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
                              color: Colors.transparent, // Set to transparent to remove default underline
                            ),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  genderselected = newValue; // Update the selected value
                                });
                              }
                            },
                            items: aadhar_gender.map<DropdownMenuItem<String>>((RangeCategoryDataModel state) {
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
                            Expanded(child: _buildTextField('Father Middle Name', _fatherMiddleNameController),),
                            SizedBox(width: 8), // Add spacing between the text fields if needed
                            Expanded(child: _buildTextField(
                                'Father Last Name', _fatherLastNameController)),
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
                        _buildTextField(
                            'Spouse First Name', _spouseFirstNameController),
                        Row(
                          children: [
                            Expanded(child: _buildTextField(
                                'Spouse Middle Name', _spouseMiddleNameController)),
                            SizedBox(width: 8), // Add spacing between the text fields if needed
                            Expanded(child: _buildTextField(
                                'Spouse Last Name', _spouseLastNameController)),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: _buildTextField(
                                'Monthly Expense', _incomeController)),
                            SizedBox(width: 8), // Add spacing between the text fields if needed
                            Expanded(child: _buildTextField(
                                'Monthly Income', _expenseController)),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: _buildTextField(
                                'Latitude', _latitudeController)),
                            SizedBox(width: 8), // Add spacing between the text fields if needed
                            Expanded(child: _buildTextField(
                                'Longitude', _longitudeController)),
                          ],
                        ),
                        _buildTextField('Address1', _address1Controller),
                        _buildTextField('Address2', _address2Controller),
                        _buildTextField('Address3', _address3Controller),
                        Row(
                          children: [
                            Expanded(
                                child: _buildTextField('City', _cityController)),
                            SizedBox(width: 16),
                            Expanded(
                                child: _buildTextField('Pincode', _pincodeController)),
                          ],
                        ),
                        Text(
                          'State Name',
                          style: TextStyle(fontSize: 20),
                        ),
                        Container(
                          width: 150, // Adjust the width as needed
                          height: 35, // Fixed height
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
                              color: Colors.transparent, // Set to transparent to remove default underline
                            ),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  stateselected = newValue; // Update the selected value
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

                        Row(
                          children: [
                            Expanded(
                                child: _buildTextField('Group Code', _groupCodeController)),
                            SizedBox(width: 16),
                            Expanded(
                                child: _buildTextField('Branch Code', _branchCodeController)),
                          ],
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
                        _buildTextField('Voter Id', _voterIdController),
                        _buildTextField(
                            'Permanent Account PAN No', _panNoController),
                        _buildTextField(
                            'Driving License', _drivingLicenseController),
                        Row(
                          children: [
                            Expanded(
                                child:
                                    _buildTextField('City', _cityController)),
                            SizedBox(width: 16),
                            Expanded(
                                child: _buildTextField(
                                    'District', _districtController)),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: _buildTextField(
                                    'Sub District', _subDistrictController)),
                            SizedBox(width: 16),
                            Expanded(
                                child: _buildTextField(
                                    'Village', _villageController)),
                          ],
                        ),
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
                        _buildTextField(
                            'Mother First Name', _motherFirstNameController),
                        _buildTextField(
                            'Mother Middle Name', _motherMiddleNameController),
                        _buildTextField(
                            'Mother Last Name', _motherLastNameController),

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
                        _buildTextField(
                            'Monthly Income', _monthlyIncomeController),
                        _buildTextField(
                            'Monthly Expense', _monthlyExpenseController),
                        _buildTextField(
                            'Future Income', _futureIncomeController),
                        _buildTextField(
                            'Agriculture Income', _agricultureIncomeController),
                        _buildTextField(
                            'Pension Income', _pensionIncomeController),
                        _buildTextField(
                            'Interest Income', _interestIncomeController),
                        _buildTextField('Other Income', _otherIncomeController),
                        _buildTextField('Earning Member Type',
                            _earningMemberTypeController),
                        _buildTextField('Earning Member Income',
                            _earningMemberIncomeController),
                        _buildTextField('Loan Amount', _loanAmtController),
                        _buildTextField(
                            'Business Detail', _businessDetailController),
                        _buildTextField('Loan Reason', _loanReasonController),
                        _buildTextField('Occupation', _OccupationController),
                        _buildTextField(
                            'Loan Duration', _loanDurationController),
                        _buildTextField('Select Bank', _selectBankController),
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
            )
          ),
        ],
      ),
    );
  }


 /* Future<void> updateAddress(BorrowerListDataModel borrower) async {
    Map<String, dynamic> requestBody = {
      "groupCode": borrower.groupCode,
      "AadharID": _aadharIdController.text,
      "Age": int.parse(_ageController.text),
      "Fname": _nameController.text, //have to split
      "Mname": _nameController.text, //have to split
      "Lname": _nameController.text, //have to split
      "DOB": _dobController.text,
      "P_Add1": _address1Controller.text,
      "P_Add2": _address2Controller.text,
      "P_Add3": _address3Controller.text,
      "P_City": _cityController.text,
      "P_Pin": int.parse(_pincodeController.text),
      "P_Ph3": _mobileNoController.text, //doubt
      "isMarried": isMarried,
      "Gender": _genderController.text,
      "P_State": selectedState,
      "guardianRelatnWithBorrower": _relationshipController.text,

      "voterId": _voterIdController.text,
      "PanNO": _panNoController.text,
      "DrivingLic": _drivingLicenseController.text,

      "Loan_Amt": int.parse(_loanAmtController.text),
      "Loan_Duration": selectedLoanDuration,
      "Business_Detail": selectedBusinessDetail,
      "Loan_Reason": selectedLoanPurpose,

      "BankName": selectedBank,
      "Expense": int.parse(_monthlyExpenseController.text),
      "CityCode": _cityController.text,
      "Creator": borrower.creator,
      "UserID": GlobalClass.id,
      "IsNameVerify": 'y',
      "Latitude": 165.1515,
      "Longitude": 165156.5154,
      "T_Ph3": selectedBank,

      "Cast": '',
      "Code": 0,
      "FAmily_member": 0,
      "Loan_EMi": selectedLoanDuration,
      "Area_Of_House": 0,
      "T_Pin": 0,
      "Tag": GlobalClass.tag,

      "fiExtra": {
        "motherName": _motherFirstNameController.text,
        "motherMiddleName": _motherMiddleNameController.text,
        "motherLastName": _motherLastNameController.text,
        "fatherName": _motherFirstNameController.text,
        "fatherMiddleName": _motherMiddleNameController.text,
        "fatherLastName": _motherLastNameController.text,
        "spouseFirstName": _spouseFirstNameController.text,
        "spouseMiddleName": _spouseMiddleNameController.text,
        "spouseLastName": _spouseLastNameController.text,
        "monthlyIncome": int.parse(_monthlyIncomeController.text),
        "futureIncome": int.parse(_futureIncomeController.text),
        "agriculture_Income": int.parse(_agricultureIncomeController.text),
        "pension_Income": int.parse(_pensionIncomeController.text),
        "interest_Income": int.parse(_interestIncomeController.text),
        "otherIncome": int.parse(_otherIncomeController.text),
        "isBorrowerHandicap": 'N',
        "earningMemberIncome": int.parse(_earningMemberIncomeController.text),
        "earningMemberType": selectedEarningMemberType,
        "occupation": selectedOccupation,
      }
    };
  }*/

    Future<void> saveFiMethod( BuildContext context) async {
    String adhaarid =  _aadharIdController.toString();
    String title =  titleselected;
    String name =  _nameController.toString();
    String middlename =  _nameMController.toString();
    String lastname =  _nameLController.toString();
    String dob =  _dobController.toString();
    String gendre =  genderselected;
    String mobile =  _mobileNoController.toString();
    String fatherF =  _fatherFirstNameController.toString();
    String fatherM =  _fatherMiddleNameController.toString();
    String fatherL =  _fatherLastNameController.toString();
    String spouseF =  _spouseFirstNameController.toString();
    String spouseM =  _spouseMiddleNameController.toString();
    String spouseL =  _spouseLastNameController.toString();
    int expense = int.parse(_expenseController.text);
    int income = int.parse(_incomeController.text);
    double latitude = double.parse(_latitudeController.text);
    double longitude = double.parse(_longitudeController.text);;
    String add1 =  _address1Controller.toString();
    String add2 =  _address2Controller.toString();
    String add3 =  _address3Controller.toString();
    String city =  _cityController.toString();
    String pin =  _pincodeController.toString();
    String state =  stateselected;
    bool ismarried = isMarried;
    String gCode =  _groupCodeController.toString();
    String bCode =  _branchCodeController.toString();

      final api = Provider.of<ApiService>(context, listen: false);

      return await api.saveFi(GlobalClass.token, GlobalClass.dbName,adhaarid,title,name,middlename,lastname,dob,gendre,mobile,fatherF,fatherM,fatherL,spouseF,spouseM,spouseL,"creator",expense,income,latitude,longitude,add1,add2,add3,city,pin,state,ismarried,gCode,bCode,"picture")
          .then((value) async {
        if (value.statuscode == 200) {

        } else {
        }

      });
    }

  void saveAddressMethod() {}

  void savePersonalDetailsMethod() {}

  void saveDataMethod() {}
}

void _showPopup(BuildContext context, Function(String) onResult) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding around the content
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
                      borderRadius: BorderRadius.circular(5), // Adjust as needed
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
                      borderRadius: BorderRadius.circular(5), // Adjust as needed
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
                      MaterialPageRoute(builder: (context) => QRViewExample()),
                    );

                    if (result != null) {
                      BigInt bigIntScanData = BigInt.parse(result);
                      List<int> byteScanData = bigIntToBytes(bigIntScanData);

                      List<int> decompByteScanData = decompressData(byteScanData);
                      List<List<int>> parts = separateData(decompByteScanData, 255, 15);
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

List<List<int>> separateData(List<int> source, int separatorByte, int vtcIndex) {
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
  String test="";
  List<String> decodedData = [];

  for (var byteArray in encodedData) {
    // Decode using ISO-8859-1
    String decodedString = utf8.decode(byteArray); // Change to ISO-8859-1 if necessary
    decodedData.add(decodedString);
    test+=decodedString;
  }

  return test;
}






