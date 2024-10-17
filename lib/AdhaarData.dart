import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'DATABASE/DatabaseHelper.dart';
import 'GlobalClass.dart';
import 'ApiService.dart';
import 'Models/BorrowerListModel.dart';
import 'Models/RangeCategoryModel.dart';

class AdhaarData extends StatefulWidget {
  const AdhaarData({super.key});

  /*final BorrowerListDataModel borrower;

  AdhaarData({required this.borrower});*/

  @override
  _AdhaarDataState createState() => _AdhaarDataState();
}

class _AdhaarDataState extends State<AdhaarData> {
  List<RangeCategoryDataModel> states = [];
  String? selectedState;
  bool isChecked = false;

  final _formKey = GlobalKey<FormState>();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _address3Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _stateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchStates(); // Fetch states using the required cat_key
  }

  Future<void> fetchStates() async {
    states = await DatabaseHelper().selectRangeCatData("state"); // Call your SQLite method

    setState(() {}); // Refresh the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aadhaar Data'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                              'assets/Images/profileimage.png',
                              width: 250,
                              height: 250,
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
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Center(
                            child: Text(
                              'Loan Amount',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
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
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value ?? false;
                  });
                },
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              // Current Address Details
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  margin: EdgeInsets.all(4),
                  child: Column(
                    children: [
                      AddressField(
                          controller: _address1Controller,
                          hint: 'Address Line 1'),
                      AddressField(
                          controller: _address2Controller,
                          hint: 'Address Line 2'),
                      AddressField(
                          controller: _address3Controller,
                          hint: 'Address Line 3'),
                      Card(
                        elevation: 2,
                        child: DropdownButtonFormField<String>(
                          value: selectedState,
                          items: states.map((RangeCategoryDataModel state) {
                            return DropdownMenuItem<String>(
                              value: state.code,
                              child: Text(state
                                  .descriptionEn), // You can customize the displayed text
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedState = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'State',
                            contentPadding: EdgeInsets.all(4),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Card(
                        child: TextFormField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            hintText: 'City',
                            contentPadding: EdgeInsets.all(10),
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'City cannot be null';
                            }
                            return null;
                          },
                        ),
                      ),
                      AddressField(
                          controller: _pincodeController,
                          hint: 'Pincode',
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length != 6) {
                              return 'Pincode must be 6 digits';
                            }
                            return null;
                          }),
                    ],
                  ),
                ),
              ),
              // Submit Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                     /* updateAddress(
                          widget.borrower); */// Function to handle address update
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateAddress(BorrowerListDataModel borrower) async {
    Map<String, dynamic> requestBody = {
      "fiCode": borrower.code,
      "creator": borrower.creator,
      "tag": "RTAG",
      "o_Add1": _address1Controller.text,
      "o_Add2": _address2Controller.text,
      "o_Add3": _address3Controller.text,
      "o_State": selectedState ?? '',
      "o_City": _cityController.text,
      "o_Pin": _pincodeController.text,
    };

    final api = Provider.of<ApiService>(context, listen: false);
    var response = await api.updateAddress(
        GlobalClass.token, GlobalClass.dbName, requestBody);

    if (response.statusCode == 200) {
      GlobalClass().showSuccessAlert(context);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Address updated successfully')));
    } else {
      GlobalClass().showUnsuccessfulAlert(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update address')));
    }
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'VisbyCFRegular',
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
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;

  AddressField({required this.controller, required this.hint, this.validator});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: EdgeInsets.all(10),
          border: InputBorder.none,
        ),
        validator: validator,
      ),
    );
  }
}
