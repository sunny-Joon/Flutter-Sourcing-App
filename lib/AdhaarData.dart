import 'package:flutter/material.dart';

class AdhaarData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aadhaar Data'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // First CardView
            Card(
              margin: EdgeInsets.all(24),
              color: Colors.red,
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Aadhaar Image and Name
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/profileimage.png',
                            width: 150,
                            height: 150,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Name',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'VisbyCFRegular',
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Aadhaar Details
                    DetailRow(label: 'Aadhaar ID', value: 'Aadhaar Id'),
                    DetailRow(label: 'Age', value: 'Aadhaar Id'),
                    DetailRow(label: 'Gender', value: 'Aadhaar Id'),
                    DetailRow(label: 'Date of Birth', value: 'Aadhaar Id'),
                    DetailRow(label: 'Guardian', value: 'Aadhaar Id'),
                    DetailRow(label: 'Mobile', value: 'Aadhaar Id'),
                  ],
                ),
              ),
            ),
            // Second CardView
            Card(
              margin: EdgeInsets.symmetric(horizontal: 24),
              color: Colors.red,
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailRow(label: 'PAN', value: ''),
                    DetailRow(label: 'Driving License', value: 'Aadhaar Id'),
                    DetailRow(label: 'Address', value: 'Aadhaar Id'),
                    DetailRow(label: 'Pincode', value: ''),
                    DetailRow(label: 'City', value: 'Aadhaar Id'),
                    DetailRow(label: 'State', value: 'Aadhaar Id'),
                  ],
                ),
              ),
            ),
            // Loan Amount CardView
            Card(
              margin: EdgeInsets.all(24),
              color: Colors.red,
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container(
                height: 65,
                child: Card(
                  color: Colors.white,
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            'Loan Amount',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            '0000000',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Address CheckBox
            CheckboxListTile(
              title: Text(
                'Is current address',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'VisbyCFRegular',
                ),
              ),
              value: false,
              onChanged: (bool? value) {},
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            // Current Address Details
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                margin: EdgeInsets.all(4),
                child: Column(
                  children: [
                    AddressField(hint: 'Address Line 1'),
                    AddressField(hint: 'Address Line 2'),
                    AddressField(hint: 'Address Line 3'),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 2,
                            child: DropdownButtonFormField<String>(
                              items: [], // Add dropdown items here
                              onChanged: (value) {},
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(4),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Card(
                            elevation: 5,
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'City',
                                contentPadding: EdgeInsets.all(10),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    AddressField(hint: 'Pincode'),
                  ],
                ),
              ),
            ),
            // Submit Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  padding: EdgeInsets.all(16),
                ),
                onPressed: () {},
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'VisbyCFRegular',
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'VisbyCFRegular',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddressField extends StatelessWidget {
  final String hint;

  AddressField({required this.hint});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: EdgeInsets.all(10),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
