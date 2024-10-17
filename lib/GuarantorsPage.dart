import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'ApiService.dart';
import 'DATABASE/DatabaseHelper.dart';
import 'GlobalClass.dart';
import 'Models/BorrowerListModel.dart';
import 'Models/RangeCategoryModel.dart';

class GuarantorsPage extends StatefulWidget {
  /*final BorrowerListDataModel borrower;

  GuarantorsPage({required this.borrower});*/

  @override
  _GuarantorsPageState createState() => _GuarantorsPageState();
}

class _GuarantorsPageState extends State<GuarantorsPage> {
  String? _imagePath;

  List<RangeCategoryDataModel> gender = [];
  List<RangeCategoryDataModel> state = [];
  List<RangeCategoryDataModel> relation = [];

  String? selectedOption = GlobalClass.storeValues[0];

  @override
  void initState() {
    super.initState();
    fetchData();
    aadhaarController = TextEditingController();
    nameController = TextEditingController();
    ageController = TextEditingController();
    dobController = TextEditingController();
    guardianController = TextEditingController();
    address1Controller = TextEditingController();
    address2Controller = TextEditingController();
    address3Controller = TextEditingController();
    cityController = TextEditingController();
    pincodeController = TextEditingController();
    mobileController = TextEditingController();
    voterIdController = TextEditingController();
    panController = TextEditingController();
    drivingLicenseController = TextEditingController();
    maritalStatusController =
        TextEditingController(); // Fetch states using the required cat_key
  }

  Future<void> fetchData() async {
    gender = await DatabaseHelper()
        .selectRangeCatData("gender"); // Call your SQLite method
    state = await DatabaseHelper()
        .selectRangeCatData("state"); // Call your SQLite method
    relation = await DatabaseHelper()
        .selectRangeCatData("relationship"); // Call your SQLite method
    setState(() {}); // Refresh the UI
  }

  String? selectedState;
  String? selectedGender;
  String? selectedRelation;

  late TextEditingController aadhaarController;
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController dobController;
  late TextEditingController guardianController;
  late TextEditingController address1Controller;
  late TextEditingController address2Controller;
  late TextEditingController address3Controller;
  late TextEditingController cityController;
  late TextEditingController pincodeController;
  late TextEditingController mobileController;
  late TextEditingController voterIdController;
  late TextEditingController panController;
  late TextEditingController drivingLicenseController;
  late TextEditingController maritalStatusController;

  @override
  void dispose() {
    aadhaarController.dispose();
    nameController.dispose();
    ageController.dispose();
    dobController.dispose();
    guardianController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    address3Controller.dispose();
    cityController.dispose();
    pincodeController.dispose();
    mobileController.dispose();
    voterIdController.dispose();
    panController.dispose();
    drivingLicenseController.dispose();
    maritalStatusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guarantor Details'),
        backgroundColor: Colors.red,
      ),
      backgroundColor: Color(0xFFd32f2f),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              buildTextLabel('Aadhaar ID'),
              buildAadhaarInputRow(),
              SizedBox(height: 8),
              buildTextLabel('Name'),
              buildNameInputRow(),
              SizedBox(height: 8),
              buildAgeAndDobRow(),
              SizedBox(height: 8),
              buildCardField(
                context,
                'Gender',
                gender, // Replace with actual values
                (value) => selectedGender = value?.descriptionEn,
              ),
              SizedBox(height: 8),
              buildTextLabel('Guardian'),
              buildTextInput('Guardian', guardianController),
              SizedBox(height: 8),
              buildCardField(
                context,
                'Relationship with Borrower',
                relation, // Replace with actual values
                (value) => selectedRelation = value?.descriptionEn,
              ),
              SizedBox(height: 8),
              buildTextLabel('Mobile Number'),
              buildTextInput(
                  'Mobile Number', mobileController, TextInputType.phone, 10),
              SizedBox(height: 8),
              buildTextLabel('Voter ID'),
              buildTextInput(
                  'Voter ID', voterIdController, TextInputType.text, 10),
              SizedBox(height: 8),
              buildTextLabel('PAN Number'),
              buildTextInput(
                  'PAN Number', panController, TextInputType.text, 10),
              SizedBox(height: 8),
              buildTextLabel('DL Number'),
              buildTextInput('DL Number', drivingLicenseController,
                  TextInputType.text, 16),
              SizedBox(height: 8),
              buildTextLabel('Address1'),
              buildTextInput('Address1', address1Controller),
              SizedBox(height: 8),
              buildTextLabel('Address2'),
              buildTextInput('Address2', address2Controller),
              SizedBox(height: 8),
              buildTextLabel('Address3'),
              buildTextInput('Address3', address3Controller),
              SizedBox(height: 8),
              buildCardField(
                context,
                'State',
                state, // Replace with actual values
                (value) => selectedState = value?.descriptionEn,
              ),
              SizedBox(height: 8),
              buildCityAndPincodeRow(),
              SizedBox(height: 8),
              buildTextLabel('Marital Status'),
              buildTextInput('Marital Status', maritalStatusController,
                  TextInputType.text, null, false),
              SizedBox(height: 16),
              buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    );
  }

  Widget buildAadhaarInputRow() {
    return Row(
      children: [
        Expanded(
          child: Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: aadhaarController,
                decoration: InputDecoration(
                  hintText: 'Aadhaar ID',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
                maxLength: 12,
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.camera_alt),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget buildNameInputRow() {
    return Row(
      children: [
        Expanded(
          child: Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Name',
                  border: InputBorder.none,
                ),
                textCapitalization: TextCapitalization.characters,
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
/*        GestureDetector(
          onTap: () async {
            _imagePath = await GlobalClass().pickImage();
            print('Image clicked'+_imagePath.toString());
             _imagePath != null
                ? Image.file(
              File(_imagePath!),
              width: 50,
              height: 50,
            )
                : Image.asset(
              'assets/Images/user.png',
              width: 50,
              height: 50,
            );
          },
          child: _imagePath != null
              ? Image.file(
                  File(_imagePath!),
                  width: 50,
                  height: 50,
                )
              : Image.asset(
                  'assets/Images/user.png',
                  width: 50,
                  height: 50,
                ),
        ),*/
      ],
    );
  }

  Widget buildAgeAndDobRow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextLabel('Age'),
              Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: ageController,
                    decoration: InputDecoration(
                      hintText: 'Age',
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                    enabled: false,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextLabel('DOB'),
              Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: dobController,
                    decoration: InputDecoration(
                      hintText: 'DOB',
                      border: InputBorder.none,
                    ),
                    enabled: false,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );

            if (pickedDate != null) {
              setState(() {
                dobController.text =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                ageController.text =
                    GlobalClass().calculateAge(pickedDate).toString();
              });
            }
          },
        ),
      ],
    );
  }

  Widget buildTextInput(String hint, TextEditingController controller,
      [TextInputType? inputType, int? maxLength, bool enabled = true]) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
          ),
          keyboardType: inputType,
          maxLength: maxLength,
          enabled: enabled,
          textCapitalization: TextCapitalization.characters,
        ),
      ),
    );
  }

  Widget buildCardField(
      BuildContext context,
      String label,
      List<RangeCategoryDataModel> items,
      ValueChanged<RangeCategoryDataModel?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'VisbyCFRegular',
            ),
          ),
          SizedBox(height: 8),
          Card(
            elevation: 4,
            margin: EdgeInsets.zero,
            child: DropdownButtonFormField<RangeCategoryDataModel>(
              items: items.map((RangeCategoryDataModel value) {
                return DropdownMenuItem<RangeCategoryDataModel>(
                  value: value,
                  child: Text(value.descriptionEn),
                );
              }).toList(),
              onChanged: onChanged,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  hintText: 'Please select $label'),
              validator: (value) {
                if (value == null) {
                  return 'Please select $label';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCityAndPincodeRow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextLabel('City'),
              Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: cityController,
                    decoration: InputDecoration(
                      hintText: 'City',
                      border: InputBorder.none,
                    ),
                    textCapitalization: TextCapitalization.characters,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextLabel('Pincode'),
              Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: pincodeController,
                    decoration: InputDecoration(
                      hintText: 'Pincode',
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              updateGaurantors(context);            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text('Update', style: TextStyle(fontSize: 16)),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Handle delete action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text('Cancel', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }




  Future<void> updateGaurantors(BuildContext context) async {

    Map<String, dynamic> requestBody= {
      /*"creator": widget.borrower.creator,
      "code": widget.borrower.code,
      "tag": "RTAG",
      "fi_Code": widget.borrower.code,*/
      "grNo": 1,
      "aadharID": aadhaarController,
      "name": nameController,
      "age": ageController,
      "dob": dobController,
      "gender": selectedGender,
      "gurName": guardianController,
      "perAdd1": address1Controller,
      "perAdd2": address2Controller,
      "perAdd3": address3Controller,
      "perCity": cityController,
      "p_Pin": pincodeController,
      "p_StateID": selectedState,
      "perMob1": mobileController,
      "voterID": voterIdController,
      "panNo": panController,
      "drivingLic": drivingLicenseController,
      "relation": selectedRelation,
      "resFax": selectedRelation,


      "initials": "",
      "gurInitials": "string",
      "corrAddr": 0,
      "firmName": "string",
      "offAdd1": "string",
      "offAdd2": "string",
      "offAdd3": "string",
      "offCity": "string",
      "offPh1": "string",
      "offPh2": "string",
      "offPh3": "string",
      "offFax": "string",
      "offMob1": "string",
      "offMob2": "string",
      "resAdd1": "string",
      "resAdd2": "string",
      "resAdd3": "string",
      "resCity": "string",
      "resPh1": "string",
      "resPh2": "string",
      "resPh3": "string",
      "resMob1": "string",
      "resMob2": "string",
      "perPh1": "string",
      "perPh2": "string",
      "perPh3": "string",
      "perFax": "string",
      "perMob2": "string",
      "occupation": "string",
      "occupTypeDesig": "string",
      "location": "string",
      "bankAcNo": "string",
      "bankName": "string",
      "bankBranch": "string",
      "otherCase": "string",
      "remarks": "string",
      "recoveryAuth": "string",
      "recoveryExec": "string",
      "type": "string",
      "fDflag": "string",
      "incomeTax": "sd",
      "minor": false,
      "userID": "string",
      "auth_UserID": "string",
      "auth_Date": "2024-04-22T12:39:30.066Z",
      "creation_Date": "2024-04-22T12:39:30.066Z",
      "mod_Type": "string",
      "last_Mod_UserID": "string",
      "last_Mod_Date": "2024-04-22T12:39:30.066Z",
      "groupCode": "string",
      "cityCode": "string",
      "religion": "string",
      "landHolding": 0,
      "exServiceMan": "string",
      "t_Pin": 0,
      "o_Pin": 0,
      "identityType": "string",
      "identity_No": "string",
      "eSignSucceed": "string",
      "kycuuid": "string",
      "concent": "string",
      "eSignUUID": "string"
    };
    final api2 = Provider.of<ApiService>(context, listen: false);

    // Update the personal details using the API
    final response = await api2.updateGaurantors(GlobalClass.token, GlobalClass.dbName, requestBody);

    if (response.statusCode == 200) {
      // Handle successful update
      GlobalClass().showSuccessAlert(context);
    } else {
      // Handle failed update
      GlobalClass().showUnsuccessfulAlert(context);
    }
  }
}
