import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:camera/camera.dart';
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
  String titleselected = "Select";
  String selectedTitle = "Select";
  String expense = "";
  String income = "";
  String lati = "";
  String longi = "";

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
    business_Type = await DatabaseHelper()
        .selectRangeCatData("business-type"); // Call your SQLite method
    income_type = await DatabaseHelper()
        .selectRangeCatData("income-type"); // Call your SQLite method
    bank = await DatabaseHelper()
        .selectRangeCatData("banks"); // Call your SQLite method

    setState(() {
      states.insert(
          0,
          RangeCategoryDataModel(
            catKey: 'Select',
            groupDescriptionEn: 'select',
            groupDescriptionHi: 'select',
            descriptionEn: 'Select', // Display text
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
          height: MediaQuery.of(context).size.height - 100,
          width: MediaQuery.of(context).size.width - 24,
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
                            borderRadius: BorderRadius.all(Radius.elliptical(5,
                                5)), // Set border radius to zero for sharp corners
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
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Container(
                                    width: 150, // Adjust the width as needed
                                    height: 35, // Fixed height
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
                        _buildTextField('Name', _nameController),
                        Row(
                          children: [
                            Expanded(
                                child: _buildTextField(
                                    'Middle Name', _nameMController)),
                            SizedBox(
                                width:
                                    16), // Add spacing between the text fields if needed
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
                                    8), // Add spacing between the text fields if needed
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
                        _buildTextField(
                            'Spouse First Name', _spouseFirstNameController),
                        Row(
                          children: [
                            Expanded(
                                child: _buildTextField('Spouse Middle Name',
                                    _spouseMiddleNameController)),
                            SizedBox(
                                width:
                                    8), // Add spacing between the text fields if needed
                            Expanded(
                                child: _buildTextField('Spouse Last Name',
                                    _spouseLastNameController)),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: _buildTextField(
                                    'Monthly Expense', _incomeController)),
                            SizedBox(
                                width:
                                    8), // Add spacing between the text fields if needed
                            Expanded(
                                child: _buildTextField(
                                    'Monthly Income', _expenseController)),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: _buildTextField(
                                    'Latitude', _latitudeController)),
                            SizedBox(
                                width:
                                    8), // Add spacing between the text fields if needed
                            Expanded(
                                child: _buildTextField(
                                    'Longitude', _longitudeController)),
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
                          width: double.infinity, // Adjust the width as needed
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
                        Row(
                          children: [
                            Expanded(
                                child: _buildTextField(
                                    'Group Code', _groupCodeController)),
                            SizedBox(width: 16),
                            Expanded(
                                child: _buildTextField(
                                    'Branch Code', _branchCodeController)),
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
                        _buildTextField(
                            'Permanent Account PAN No', _panNoController),
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
    String gCode = _groupCodeController.text.toString();
    String bCode = _branchCodeController.text.toString();
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
            _imageFile!)
        .then((value) async {
      if (value.statuscode == 160) {
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
      if (value.statuscode == 160) {
        setState(() {
          _currentStep += 1;
        });
      } else {}
    });
  }

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
                      MaterialPageRoute(builder: (context) => QRViewExample()),
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
