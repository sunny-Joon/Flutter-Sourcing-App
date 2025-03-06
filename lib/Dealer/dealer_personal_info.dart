import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dealer_quotations.dart';
import 'dealer_upload_docs.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  String? selectedEducation;
  List<String> educationList = ['Select', '10th', '12th', 'Graduate','Post Graduate','Doctrait'];
  String? selectedVarient;
  List<String> varient = ['Select', 'XL100 Heavy Duty', 'Splendor Pro'];
  String? selectedSubVarient;
  List<String> subVarient = ['Select', 'Kick Start', 'Self Start'];
  String? selectedmodel;
  List<String> model = ['Select', 'XL 100 HD', 'Splendor'];

  TextEditingController _loan_amountController = TextEditingController();
  String? selectedloanDuration;
  List<String> loanDuration = ['Select', '12', '24', '36', '48'];
  bool generate = false;
  bool aggrigator = false;
  bool _consent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFD42D3F),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 42,
              ),
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
                          border:
                          Border.all(width: 1, color: Colors.grey.shade300),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        child: Center(
                          child: Icon(Icons.arrow_back_ios_sharp, size: 13),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Center(
                      child: Image.asset(
                        'assets/Images/logo_white.png',
                        // Replace with your logo asset path
                        height: 30,
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
              Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Manufacturer',
                                  style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      fontSize: 13,
                                      color: Colors.white),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(height: 5),
                                Container(
                                  alignment: Alignment.center,
                                  height: 55,
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: DropdownButton<String>(
                                    value: selectedEducation,
                                    // Make sure this variable exists
                                    isExpanded: true,
                                    iconSize: 24,
                                    iconEnabledColor: Colors.white,
                                    dropdownColor: Colors.grey,
                                    elevation: 13,
                                    style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.transparent,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedEducation = newValue!;
                                      });
                                    },
                                    items: educationList.map((String value) {
                                      // Make sure this list exists
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                            child: Column(
                              children: [
                                Text(
                                  'Model/Variant',
                                  style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      fontSize: 13,
                                      color: Colors.white),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 55,
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: DropdownButton<String>(
                                    value: selectedVarient,
                                    // Make sure this variable exists
                                    isExpanded: true,
                                    iconSize: 24,
                                    iconEnabledColor: Colors.white,
                                    dropdownColor: Colors.grey,
                                    elevation: 13,
                                    style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.transparent,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedVarient = newValue!;
                                      });
                                    },
                                    items: varient.map((String value) {
                                      // Make sure this list exists
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sub Variant',
                                style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 13,
                                    color: Colors.white),
                              ),
                              Container(
                                alignment: Alignment.center,
                                // width: 150,
                                // Adjust the width as needed
                                height: 55,
                                // Fixed height
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: DropdownButton<String>(
                                  value: selectedSubVarient,
                                  isExpanded: true,
                                  iconSize: 24,
                                  iconEnabledColor: Colors.white,

                                  dropdownColor: Colors.grey,
                                  elevation: 13,
                                  style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      color: Colors.white,
                                      fontSize: 13),
                                  underline: Container(
                                    height: 2,
                                    color: Colors
                                        .transparent, // Set to transparent to remove default underline
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedSubVarient = newValue!;
                                    });
                                  },
                                  items: subVarient.map((String value) {
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
                          width: 10,
                        ),
                        Flexible(
                            child: Column(
                              children: [
                                Text(
                                  'Asset Model',
                                  style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      fontSize: 13,
                                      color: Colors.white),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 55,
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: DropdownButton<String>(
                                    value: selectedmodel,
                                    // Make sure this variable exists
                                    isExpanded: true,
                                    iconSize: 24,
                                    iconEnabledColor: Colors.white,

                                    dropdownColor: Colors.grey,

                                    elevation: 13,
                                    style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.transparent,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedmodel = newValue!;
                                      });
                                    },
                                    items: model.map((String value) {
                                      // Make sure this list exists
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Flexible(
                          child: _buildTextField2('Loan Amount',
                              _loan_amountController, TextInputType.number, 7),
                        ),
                        Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Loan Duraction',
                                  style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      fontSize: 13,
                                      color: Colors.white),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  alignment: Alignment.center,
                                  // width: 150,
                                  // Adjust the width as needed
                                  height: 55,
                                  // Fixed height
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: DropdownButton<String>(
                                    value: selectedloanDuration,
                                    isExpanded: true,
                                    dropdownColor: Colors.grey,
                                    iconSize: 24,
                                    iconEnabledColor: Colors.white,

                                    elevation: 13,
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        color: Colors.white,
                                        fontSize: 13),
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
                            ))
                      ],
                    ),
                    SizedBox(height: 10,),

                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadDocuments() ));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.redAccent, Color(0xFFD42D3F)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 10,
                              offset: Offset(5, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black.withOpacity(0.5),
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildTextField2(String label, TextEditingController controller,
      TextInputType inputType, int maxlength) {
    return Container(
      color: Color(0xFFD42D3F),
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                fontFamily: "Poppins-Regular",
                fontSize: 13,
                color: Colors.white),
          ),
          SizedBox(height: 1),
          Container(
            width: double.infinity, // Set the desired width
            child: Center(
              child: TextFormField(
                maxLength: maxlength,
                controller: controller,
                keyboardType: inputType,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                // Set the input type
                decoration: InputDecoration(
                  border: OutlineInputBorder(), counterText: "",),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter $label';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(
                      '[a-zA-Z0-9]')), // Allow only alphanumeric characters // Optional: to deny spaces
                  TextInputFormatter.withFunction(
                        (oldValue, newValue) => TextEditingValue(
                      text: newValue.text.toUpperCase(),
                      selection: newValue.selection,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
