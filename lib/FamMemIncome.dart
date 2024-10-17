import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ApiService.dart';
import 'DATABASE/DatabaseHelper.dart';
import 'GlobalClass.dart';
import 'Models/BorrowerListModel.dart';
import 'Models/RangeCategoryModel.dart';

class FamMemIncome extends StatefulWidget {

/*
  final BorrowerListDataModel borrower;
  FamMemIncome({required this.borrower});*/

  @override
  _FamMemIncomeState createState() => _FamMemIncomeState();
}

class _FamMemIncomeState extends State<FamMemIncome> {

  List<RangeCategoryDataModel> relationship = [];
  List<RangeCategoryDataModel> aadhar_gender = [];
  List<RangeCategoryDataModel> health = [];
  List<RangeCategoryDataModel> education = [];
  List<RangeCategoryDataModel> school_type = [];
  List<RangeCategoryDataModel> business_Type = [];
  List<RangeCategoryDataModel> income_type = [];

  String? selectedOption = GlobalClass.storeValues[0];

  final TextEditingController _businessController = TextEditingController();
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String? relationshipType;
  String? gender;
  String? healthType;
  String? educationType;
  String? school;
  String? businessType;
  String? incomeType;

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch states using the required cat_key
  }

  Future<void> fetchData() async {
    relationship = await DatabaseHelper().selectRangeCatData("relationship"); // Call your SQLite method
    aadhar_gender = await DatabaseHelper().selectRangeCatData("gender"); // Call your SQLite method
    health = await DatabaseHelper().selectRangeCatData("health"); // Call your SQLite method
    education = await DatabaseHelper().selectRangeCatData("education"); // Call your SQLite method
    school_type = await DatabaseHelper().selectRangeCatData("school-type"); // Call your SQLite method
    business_Type = await DatabaseHelper().selectRangeCatData("business-type"); // Call your SQLite method
    income_type = await DatabaseHelper().selectRangeCatData("income-type"); // Call your SQLite method

    setState(() {}); // Refresh the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Family Member Income'),
        backgroundColor: Colors.red,
      ),
      backgroundColor: Color(0xFFd32f2f), // Equivalent to @color/white
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Family Member Name',
                  style: TextStyle(color: Colors.white),
                ),
                Card(
                  elevation: 2,
                  margin: EdgeInsets.all(2.0),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Family Member Name',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.characters,
                  ),
                ),
                SizedBox(height: 5.0),
                buildCardField(
                  context,
                  'RelationShip',
                  relationship, // Replace with actual values
                      (value) => relationshipType = value?.descriptionEn,
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Aadhar Age',
                            style: TextStyle(color: Colors.white),
                          ),
                          Card(
                            elevation: 2,
                            margin: EdgeInsets.all(2.0),
                            child: TextFormField(
                              controller: _ageController,
                              decoration: InputDecoration(
                                hintText: 'Age',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: buildCardField(
                        context,
                        'Gender',
                        aadhar_gender, // Replace with actual values
                            (value) => gender = value?.descriptionEn,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                buildCardField(
                  context,
                  'Health',
                  health, // Replace with actual values
                      (value) => healthType = value?.descriptionEn,
                ),
                SizedBox(height: 5.0),
                buildCardField(
                  context,
                  'Education',
                  education, // Replace with actual values
                      (value) => educationType = value?.descriptionEn,
                ),
                SizedBox(height: 5.0),
                buildCardField(
                  context,
                  'School Type',
                  school_type, // Replace with actual values
                      (value) => school = value?.descriptionEn,
                ),
                SizedBox(height: 5.0),
                Text(
                  'Business',
                  style: TextStyle(color: Colors.white),
                ),
                Card(
                  elevation: 2,
                  margin: EdgeInsets.all(2.0),
                  child: TextFormField(
                    controller: _businessController,
                    decoration: InputDecoration(
                      hintText: 'Business',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.characters,
                  ),
                ),
                SizedBox(height: 5.0),
                buildCardField(
                  context,
                  'Business Type',
                  business_Type, // Replace with actual values
                      (value) => businessType = value?.descriptionEn,
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Income',
                            style: TextStyle(color: Colors.white),
                          ),
                          Card(
                            elevation: 2,
                            margin: EdgeInsets.all(2.0),
                            child: TextFormField(
                              controller: _incomeController,
                              decoration: InputDecoration(
                                hintText: 'Rs.',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: buildCardField(
                        context,
                        'Income Type',
                        income_type, // Replace with actual values
                            (value) => incomeType = value?.descriptionEn,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          updateFamMemIncome(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          'Add/Update',
                          style: TextStyle(fontSize: 10.0),
                        ),
                      ),
                    ),
                    SizedBox(width: 2.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: 10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
  }

  Widget buildCardField(BuildContext context, String label, List<RangeCategoryDataModel> items, ValueChanged<RangeCategoryDataModel?> onChanged) {
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
              ),
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

  Future<void> updateFamMemIncome(BuildContext context) async {
    Map<String, dynamic> requestBody = {
     /* "fiCode": widget.borrower.code,
      "creator": widget.borrower.creator,*/
      "tag": "RTAG",
      "famMemName":_nameController.text,
      "relationship":relationshipType,
      "age":_ageController.text,
      "gender":gender,
      "health":healthType,
      "education":educationType,
      "schoolType":school,
      "business":_businessController.text,
      "businessType":businessType,
      "income":_incomeController.text,
      "incomeType":incomeType,
      "autoID":0
    };
    final api2 = Provider.of<ApiService>(context, listen: false);

    // Update the personal details using the API
    final response = await api2.updateFamMemIncome(GlobalClass.token, GlobalClass.dbName, requestBody);

    if (response.statusCode == 200) {
      // Handle successful update
      GlobalClass().showSuccessAlert(context);
    } else {
      // Handle failed update
      GlobalClass().showUnsuccessfulAlert(context);
    }
  }
}