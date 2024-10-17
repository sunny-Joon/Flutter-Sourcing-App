import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ApiService.dart';
import 'DATABASE/DatabaseHelper.dart';
import 'GlobalClass.dart';
import 'Models/BorrowerListModel.dart';
import 'Models/RangeCategoryModel.dart';

class PersonalData extends StatefulWidget {
  const PersonalData({super.key});



  /*final BorrowerListDataModel borrower;
  PersonalData({required this.borrower});*/

  @override
  _PersonalDataState createState() => _PersonalDataState();
}

class _PersonalDataState extends State<PersonalData> {

  List<RangeCategoryDataModel> religion = [];
  List<RangeCategoryDataModel> land_owner = [];
  List<RangeCategoryDataModel> caste = [];
  List<RangeCategoryDataModel> education = [];

  String? selectedOption = GlobalClass.storeValues[0];


  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch states using the required cat_key
  }

  Future<void> fetchData() async {
    religion = await DatabaseHelper().selectRangeCatData("religion"); // Call your SQLite method
    land_owner = await DatabaseHelper().selectRangeCatData("land_owner"); // Call your SQLite method
    caste = await DatabaseHelper().selectRangeCatData("caste"); // Call your SQLite method
    education = await DatabaseHelper().selectRangeCatData("education"); // Call your SQLite method

    setState(() {}); // Refresh the UI
  }

  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final emailIdController = TextEditingController();
  final placeOfBirthController = TextEditingController();

  // Variables for dropdown fields
  String? selectedCaste;
  String? selectedReligion;
  String? selectedPresentHouseOwner;
  String? selectedResidenceDuration;
  String? selectedNumOfFamilyMembers;
  String? selectedLandHold;
  String? selectedSpecialAbility;
  String? selectedSpecialSocialCategory;
  String? selectedEducationalCode;
  String? selectedPanApplied;
  String? selectedIsBorrowerBlind;
  String? selectedYearsInBusiness;

  @override
  void dispose() {
    // Dispose controllers
    emailIdController.dispose();
    placeOfBirthController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Details'),
        backgroundColor: Colors.red,
      ),
      backgroundColor: Color(0xFFd32f2f), // Equivalent to @color/red
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextField(
                  context,
                  'Email ID',
                  TextInputType.emailAddress,
                  emailIdController,
                ),
                buildCardField(
                  context,
                  'Caste',
                  caste, // Replace with actual values
                      (value) => selectedCaste = value?.descriptionEn,
                ),
                buildCardField(
                  context,
                  'Applicant Religion',
                  religion, // Replace with actual values
                      (value) => selectedReligion = value?.descriptionEn,
                ),
                buildTextField(
                  context,
                  'Place of Birth',
                  TextInputType.text,
                  placeOfBirthController,
                ),
                buildCardField(
                  context,
                  'Present House Owner',
                  land_owner, // Replace with actual values
                      (value) => selectedPresentHouseOwner = value?.descriptionEn,
                ),
                buildCardField2(
                  context,
                  'Residing For(years',
                  GlobalClass.oneToNine, // Replace with actual values
                      (value) => selectedResidenceDuration = value,
                ),
                buildCardField2(
                  context,
                  'Number of Family Members',
                  GlobalClass.oneToNine, // Replace with actual values
                      (value) => selectedNumOfFamilyMembers = value,
                ),
                buildCardField2(
                  context,
                  'Land Hold',
                  GlobalClass.oneToNine, // Replace with actual values
                      (value) => selectedLandHold = value,
                ),
                buildCardField2(
                  context,
                  'Special Ability',
                  GlobalClass.storeValues, // Replace with actual values
                      (value) => selectedSpecialAbility = value,
                ),
                buildCardField2(
                  context,
                  'Special Social Category',
                  GlobalClass.storeValues, // Replace with actual values
                      (value) => selectedSpecialSocialCategory = value,
                ),
                buildCardField(
                  context,
                  'Educational Code',
                  education, // Replace with actual values
                      (value) => selectedEducationalCode = value?.code,
                ),
                buildCardField2(
                  context,
                  'PAN Applied',
                  GlobalClass.storeValues, // Replace with actual values
                      (value) => selectedPanApplied = value,
                ),
                buildCardField2(
                  context,
                  'Is Borrower Blind',
                  GlobalClass.storeValues, // Replace with actual values
                      (value) => selectedIsBorrowerBlind = value,
                ),
                buildCardField2(
                  context,
                  'Years in Business',
                  GlobalClass.oneToNine, // Replace with actual values
                      (value) => selectedYearsInBusiness = value,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.all(16),
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          updatePersonalDetails(context);
                        }
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(BuildContext context, String label, TextInputType inputType, TextEditingController controller) {
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
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
              keyboardType: inputType,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter $label';
                }
                return null;
              },
            ),
          ),
        ],
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
  Widget buildCardField2(BuildContext context, String label, List<String> items, ValueChanged<String?> onChanged) {
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
            child: DropdownButtonFormField<String>(
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: 'Please select $label',
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



  Future<void> updatePersonalDetails(BuildContext context) async {

    Map<String, dynamic> requestBody = {
     /* "fiCode": widget.borrower.code,
      "creator": widget.borrower.creator,*/
      "tag": "RTAG",
      "emailId": emailIdController.text,
      "caste": selectedCaste,
      "religion": selectedReligion,
      "placeOfBirth": placeOfBirthController.text,
      "presentHouseOwner": selectedPresentHouseOwner,
      "residingFor": selectedResidenceDuration,
      "numOfFamMember": selectedNumOfFamilyMembers,
      "landHold": selectedLandHold,
      "specialAbility": selectedSpecialAbility,
      "specialSocialCategory": selectedSpecialSocialCategory,
      "educationalCode": selectedEducationalCode,
      "panApplied": selectedPanApplied,
      "isBorrowerBlind": selectedIsBorrowerBlind,
      "yearsInBusiness": selectedYearsInBusiness,
    };
    final api2 = Provider.of<ApiService>(context, listen: false);

    // Update the personal details using the API
    final response = await api2.updatePersonalDetails(GlobalClass.token, GlobalClass.dbName, requestBody);

    if (response.statusCode == 200) {
      // Handle successful update
      GlobalClass().showSuccessAlert(context);
    } else {
      // Handle failed update
      GlobalClass().showUnsuccessfulAlert(context);
    }
  }
}
