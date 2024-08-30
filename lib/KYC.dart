import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // For formatting the date

class KYCPage extends StatefulWidget {
  final String data;

  KYCPage({required this.data});

  @override
  _KYCPageState createState() => _KYCPageState();
}

class _KYCPageState extends State<KYCPage> {
  int _currentStep = 0;
  final _formKeys = List.generate(4, (index) => GlobalKey<FormState>());
  DateTime? _selectedDate;
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dobController.addListener(() {
      _calculateAge();
    });
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
          (today.month == _selectedDate!.month && today.day < _selectedDate!.day)) {
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
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_formKeys[_currentStep].currentState?.validate() ?? false) {
            if (_currentStep < 3) {
              setState(() {
                _currentStep += 1;
              });
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NextPage()),
              );
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
        controlsBuilder: (BuildContext context, ControlsDetails controls) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: controls.onStepContinue,
                child: Text('Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 10),
              TextButton(
                onPressed: controls.onStepCancel,
                child: Text(
                  _currentStep == 0 ? 'Reset' : 'Back',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
        steps: [
          Step(
            title: Text('Step 1'),
            isActive: _currentStep >= 0,
            content: Form(
              key: _formKeys[0],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField('Enter mobile number linked with Aadhaar'),
                  _buildTextField('Name'),
                  _buildTextField('Mobile no'),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.white,
                        child: TextField(
                          controller: _ageController,
                          decoration: InputDecoration(
                            labelText: 'Age',
                            border: OutlineInputBorder(),
                          ),
                          readOnly: true,
                        ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          color: Colors.white,
                        child: TextField(
                          controller: _dobController,
                          decoration: InputDecoration(
                            labelText: 'Enter Date of Birth',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () => _selectDate(context),
                            ),
                            border: OutlineInputBorder(),
                          ),
                          readOnly: true,
                        ),
                      ),
                      ),
                    ],
                  ),
                  _buildTextField('Gender'),
                  _buildTextField('Relationship with Borrower'),
                  _buildTextField('Address1'),
                  _buildTextField('Address2'),
                  _buildTextField('Address3'),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('City')),
                      SizedBox(width: 16),
                      Expanded(child: _buildTextField('Pincode')),
                    ],
                  ),
                  _buildTextField('State Name'),
                ],
              ),
            ),
          ),
          Step(
            title: Text('Step 2'),
            isActive: _currentStep >= 1,
            content: Form(
              key: _formKeys[1],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField('Voter Id'),
                  _buildTextField('Permanent Account PAN No'),
                  _buildTextField('Driving License'),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('City')),
                      SizedBox(width: 16),
                      Expanded(child: _buildTextField('District')),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Sub District')),
                      SizedBox(width: 16),
                      Expanded(child: _buildTextField('Village')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Step(
            title: Text('Step 3'),
            isActive: _currentStep >= 2,
            content: Form(
              key: _formKeys[2],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField('Mother First Name'),
                  _buildTextField('Mother Middle Name'),
                  _buildTextField('Mother Last Name'),
                  _buildTextField('Father First Name'),
                  _buildTextField('Father Middle Name'),
                  _buildTextField('Father Last Name'),
                  _buildTextField('Spouse First Name'),
                  _buildTextField('Spouse Middle Name'),
                  _buildTextField('Spouse Last Name'),
                ],
              ),
            ),
          ),
          Step(
            title: Text('Step 4'),
            isActive: _currentStep >= 3,
            content: Form(
              key: _formKeys[3],
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField('Monthly Income'),
                    _buildTextField('Monthly Expense'),
                    _buildTextField('Future Income'),
                    _buildTextField('Agriculture Income'),
                    _buildTextField('Pension Income'),
                    _buildTextField('Interest Income'),
                    _buildTextField('Other Income'),
                    _buildDropdownField('Earning Member Type', ['Option 1', 'Option 2']),
                    _buildTextField('Earning Member Income'),
                    _buildDropdownField('Business Detail', ['Option 1', 'Option 2']),
                    _buildDropdownField('Loan Purpose', ['Purpose 1', 'Purpose 2']),
                    _buildDropdownField('Occupation', ['Occupation 1', 'Occupation 2']),
                    _buildDropdownField('Loan Duration (Months)', ['1 Month', '6 Months', '1 Year']),
                    _buildDropdownField('Select Bank', ['Bank A', 'Bank B']),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Handle save data action
                      },
                      child: Text('Save Data'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        color: Colors.white,
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
          ),
          style: TextStyle(color: Colors.black),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
        ),
      ),
    );
  }
}
Widget _buildDropdownField(String label, List<String> options) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Card(
          elevation: 2,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              border: OutlineInputBorder(),
            ),
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: (value) {
              // Handle dropdown value change
            },
          ),
        ),
      ],
    ),
  );
}


// Define your next page
class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Next Page')),
      body: Center(child: Text('This is the next page')),
    );
  }
}
