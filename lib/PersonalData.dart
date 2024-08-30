import 'package:flutter/material.dart';

class PersonalData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFd32f2f), // Equivalent to @color/red
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField(
                context,
                'Email ID',
                TextInputType.emailAddress,
                'emailId',
              ),
              buildCardField(
                context,
                'Caste',
                <String>['Option 1', 'Option 2'], // Replace with actual values
                'caste',
              ),
              buildCardField(
                context,
                'Applicant Religion',
                <String>['Option 1', 'Option 2'], // Replace with actual values
                'religion',
              ),
              buildTextField(
                context,
                'Place of Birth',
                TextInputType.text,
                'placeOfBirth',
              ),
              buildCardField(
                context,
                'Present House Owner',
                <String>['Option 1', 'Option 2'], // Replace with actual values
                'presentHouseOwner',
              ),
              buildCardField(
                context,
                'Residence Duration',
                <String>['Option 1', 'Option 2'], // Replace with actual values
                'residingfor',
              ),
              buildCardField(
                context,
                'Number of Family Members',
                <String>['Option 1', 'Option 2'], // Replace with actual values
                'noOfFamilyMembers',
              ),
              buildCardField(
                context,
                'Land Hold',
                <String>['Option 1', 'Option 2'], // Replace with actual values
                'landHold',
              ),
              buildCardField(
                context,
                'Special Ability',
                <String>['Option 1', 'Option 2'], // Replace with actual values
                'specialAbility',
              ),
              buildCardField(
                context,
                'Special Social Category',
                <String>['Option 1', 'Option 2'], // Replace with actual values
                'specialSocialCategory',
              ),
              buildCardField(
                context,
                'Educational Code',
                <String>['Option 1', 'Option 2'], // Replace with actual values
                'educationalCode',
              ),
              buildCardField(
                context,
                'PAN Applied',
                <String>['Option 1', 'Option 2'], // Replace with actual values
                'panApplied',
              ),
              buildCardField(
                context,
                'Is Borrower Blind',
                <String>['Option 1', 'Option 2'], // Replace with actual values
                'isBorrowerBlind',
              ),
              buildCardField(
                context,
                'Years in Business',
                <String>['Option 1', 'Option 2'], // Replace with actual values
                'yearsInBusiness',
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      padding: EdgeInsets.all(16),
                    ),
                    onPressed: () {},
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
    );
  }

  Widget buildTextField(BuildContext context, String label, TextInputType inputType, String id) {
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
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
              keyboardType: inputType,
              textInputAction: TextInputAction.next,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCardField(BuildContext context, String label, List<String> items, String id) {
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
              onChanged: (String? newValue) {},
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
