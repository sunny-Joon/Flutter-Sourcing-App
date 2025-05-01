import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../DATABASE/database_helper.dart';
import '../../Models/range_category_model.dart';
import '../HomePage/dealer_homepage.dart';
import 'dealer_quotations.dart';
import 'dealer_upload_docs.dart';

class VehicleDetails extends StatefulWidget {
  const VehicleDetails({super.key});

  @override
  State<VehicleDetails> createState() => _VehicleDetailsState();
}

class _VehicleDetailsState extends State<VehicleDetails> {
  String? selectedManufacturer;
  List<String> manufacturerList = ['Select', 'TVS', 'BAJAJ', 'HONDA'];
  String? selectedVarient;
  List<String> varient = ['Select', 'XL100 Heavy Duty', 'Splendor Pro'];
  String? selectedSubVarient;
  List<String> subVarient = ['Select', 'Kick Start', 'Self Start'];
  String? selectedmodel;
  List<String> model = ['Select', 'XL 100 HD', 'Splendor'];
  String? experience;
  List<String> businessExperience = [
    'Select',
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9'
  ];
  List<RangeCategoryDataModel> occupation_Type = [];
  List<RangeCategoryDataModel> income_type = [];
  List<RangeCategoryDataModel> education = [];
  List<RangeCategoryDataModel> schoolType = [];

  String? femselectedEducation;
  String? femselectedSchoolType;
  String? femselectedOccupation;
  String? femselectedIncomeType;
  @override
  void initState() {

    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {

      income_type = await DatabaseHelper().selectRangeCatData("income-type"); // Call your SQLite method
      education = await DatabaseHelper().selectRangeCatData("education");
      schoolType = await DatabaseHelper().selectRangeCatData("school-type");
      occupation_Type = await DatabaseHelper().selectRangeCatData("business-type");

      setState(()  {
        education.insert(
          0,
          RangeCategoryDataModel(
              catKey: 'Select',
              groupDescriptionEn: 'select',
              groupDescriptionHi: 'select',
              descriptionEn: 'Select',
              descriptionHi: 'select',
              sortOrder: 0,
              code: 'select'));
      schoolType.insert(
          0,
          RangeCategoryDataModel(
              catKey: 'Select',
              groupDescriptionEn: 'select',
              groupDescriptionHi: 'select',
              descriptionEn: 'Select',
              descriptionHi: 'select',
              sortOrder: 0,
              code: 'select'));
      income_type.insert(
          0,
          RangeCategoryDataModel(
              catKey: 'Select',
              groupDescriptionEn: 'select',
              groupDescriptionHi: 'select',
              descriptionEn: 'Select',
              descriptionHi: 'select',
              sortOrder: 0,
              code: 'select'));
      occupation_Type.insert(
          0,
          RangeCategoryDataModel(
              catKey: 'Select',
              groupDescriptionEn: 'select',
              groupDescriptionHi: 'select',
              descriptionEn: 'Select',
              descriptionHi: 'select',
              sortOrder: 0,
              code: 'select'));
    });

  }

  TextEditingController _loan_amountController = TextEditingController();
  TextEditingController _incomeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  String? selectedloanDuration;
  List<String> loanDuration = ['Select', '12', '24', '36', '48'];
  bool generate = false;
  bool aggrigator = false;
  bool _consent = false;
  bool occupationTypeFlag = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (bool value) {
      _onWillPop();
    },
    child:Scaffold(
        backgroundColor: Color(0xFFD42D3F),
        body:SingleChildScrollView(child: Column(
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
              height: MediaQuery.of(context).size.height-120,
              margin: EdgeInsets.all(10),
              child:
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Schooling Type',
                                  style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      fontSize: 13,
                                      color: Colors.white),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(height: 5),
                                Container(
                                  height: 60,
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),

                                  child: DropdownButton<String>(
                                    value: femselectedSchoolType,
                                    isExpanded: true,
                                    dropdownColor: Colors.grey,
                                    iconEnabledColor: Colors.white,
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        color: Colors.white,
                                        fontSize: 13),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.transparent,
                                    ),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          femselectedSchoolType =
                                              newValue; // Update the selected value
                                        });
                                      }
                                    },
                                    items: schoolType.map<DropdownMenuItem<String>>(
                                            (RangeCategoryDataModel state) {
                                          return DropdownMenuItem<String>(
                                            value: state.code,
                                            child: Text(state.descriptionEn),
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
                                  'Education',
                                  style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      fontSize: 13,
                                      color: Colors.white),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(height: 5),
                                Container(
                                  height: 60,
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: DropdownButton<String>(
                                    value: femselectedEducation,
                                    isExpanded: true,
                                    dropdownColor: Colors.grey,
                                    iconEnabledColor: Colors.white,
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        color: Colors.white,
                                        fontSize: 13),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.transparent,
                                    ),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          femselectedEducation =
                                              newValue; // Update the selected value
                                        });
                                      }
                                    },
                                    items: education.map<DropdownMenuItem<String>>(
                                            (RangeCategoryDataModel state) {
                                          return DropdownMenuItem<String>(
                                            value: state.code,
                                            child: Text(state.descriptionEn),
                                          );
                                        }).toList(),
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Occupation Type',
                                  style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      fontSize: 13,
                                      color: Colors.white),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(height: 5),
                                Container(
                                  height: 60,
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: DropdownButton<String>(
                                    value: femselectedOccupation,
                                    isExpanded: true,
                                    dropdownColor: Colors.grey,
                                    iconEnabledColor: Colors.white,
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        color: Colors.white,
                                        fontSize: 13),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.transparent,
                                    ),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          femselectedOccupation = newValue;
                                          femselectedOccupation=='Salaried'?occupationTypeFlag=true:occupationTypeFlag=false;
                                          // Update the selected value
                                        });
                                      }
                                    },
                                    items: occupation_Type.map<DropdownMenuItem<String>>(
                                            (RangeCategoryDataModel state) {
                                          return DropdownMenuItem<String>(
                                            value: state.code,
                                            child: Text(state.descriptionEn),
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
                                  'Income Type',
                                  style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      fontSize: 13,
                                      color: Colors.white),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(height: 5),
                                Container(
                                  height: 60,
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: DropdownButton<String>(
                                    value: femselectedIncomeType,
                                    isExpanded: true,
                                    dropdownColor: Colors.grey,
                                    iconEnabledColor: Colors.white,
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        color: Colors.white,
                                        fontSize: 13),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.transparent,
                                    ),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          femselectedIncomeType =
                                              newValue; // Update the selected value
                                        });
                                      }
                                    },
                                    items: income_type.map<DropdownMenuItem<String>>(
                                            (RangeCategoryDataModel state) {
                                          return DropdownMenuItem<String>(
                                            value: state.code,
                                            child: Text(state.descriptionEn),
                                          );
                                        }).toList(),
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),

                    Row(
                      children: [
                        Flexible(
                          child: _buildTextField2(
                              'Income', _incomeController, TextInputType.number, 7),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        occupationTypeFlag?Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Experience in company',
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
                                  value: experience,
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
                                      experience = newValue!;
                                    });
                                  },
                                  items: businessExperience.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ):SizedBox(),
                      ],
                    ),
                    occupationTypeFlag?_buildTextField2('Company Name', _emailController, TextInputType.text, 7):SizedBox(),
                    occupationTypeFlag?_buildTextField2('Official Email', _emailController, TextInputType.text, 7):SizedBox(),

                    Row(
                      children: [
                        Flexible(
                          child: _buildTextField2('Loan Amount',
                              _loan_amountController, TextInputType.number, 7),
                        ),
                        SizedBox(width: 5),

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

                    Container(
                      margin: EdgeInsets.all(10),
                      height: 40,
                      decoration: BoxDecoration(color: Colors.white),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Vehicle Info",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24),
                      ),
                    ),

                    Column(
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
                                        value: selectedManufacturer,
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
                                            selectedManufacturer = newValue!;
                                          });
                                        },
                                        items: manufacturerList.map((String value) {
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
                        SizedBox(
                          height: 5,
                        ),
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
                        SizedBox(
                          height: 10,
                        ),

                        GestureDetector(
                          onTap: () {
                            setState(() {
                              generate = true;
                              if (_loan_amountController.text != null &&
                                  _loan_amountController.text != "" &&
                                  (int.tryParse(_loan_amountController.text)! >
                                      80000)) {
                                aggrigator = true;
                              }else{
                                aggrigator = false;
                              }
                            });
                          },
                          child: Container(
                            padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 25),
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
                                'Evaluate',
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
                        SizedBox(height: 20),
                        generate
                            ? Container(
                          height: 300,
                          padding: EdgeInsets.all(18),
                          width: MediaQuery.of(context).size.width - 50,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 5.0,
                              ),
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(25)),
                          child: Column(
                            children: [
                              SizedBox(height: 5),
                              Text(
                                'On Road Price: 50000',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Ex Showroom Price: 55000',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'RTO Charges: 450',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Insaurance: 800',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'PDD Charges: 450',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'DSA Subvention: 650',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Processing Fee: 650',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Stamp Duty: 650',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Dealer Subvention: 650',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        )
                            : SizedBox(),
                        SizedBox(
                          height: 15,
                        ),
                        generate
                            ? InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        VehicleQuotations()));
                          },
                          child: Text(
                            'Enter Price quoted by dealer...',
                            style: TextStyle(
                                fontSize: 16, color: Colors.greenAccent),
                          ),
                        )
                            : SizedBox(),
                        SizedBox(
                          height: 15,
                        ),
                        aggrigator
                            ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Checkbox(
                              value: _consent,
                              onChanged: (bool? value) {
                                setState(() {
                                  _consent = value!;
                                });
                              },
                            ),
                            Expanded(
                              child: Text(
                                "I hereby provide consent to Paisalo Digital Limited, hereinafter referred to as 'the Aggregator', to access and aggregate financial data from my bank accounts for the purpose of providing financial management services.",
                                style: TextStyle(
                                    fontSize: 11.0, color: Colors.white),
                              ),
                            ),
                          ],
                        )
                            : SizedBox(),
                        aggrigator
                            ? InkWell(
                          onTap: () {
                            _openTermsAndConditions();
                          },
                          child: Text(
                            'Terms and Conditions',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                            : SizedBox(),
                        SizedBox(
                          height: 15,
                        ),
                        generate
                            ? GestureDetector(
                          onTap: () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return WillPopScope(
                                    onWillPop: () async {
                                      // Prevent the dialog from closing when back button is pressed
                                      return false;
                                    },
                                    child: AlertDialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      title: Row(
                                        children: [
                                          Icon(Icons.info, color: Colors.green, size: 28),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              'Successful',
                                              style: TextStyle(fontFamily: "Poppins-Regular",
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children:  <Widget>[
                                          Text(
                                            "Yor are eligible for the loan below 4 Lakhs",
                                            style: TextStyle(fontFamily: "Poppins-Regular",fontSize: 16, color: Colors.black87),
                                          ),
                                          Text(
                                            "(Tentative Amount)",
                                            style: TextStyle(fontFamily: "Poppins-Regular",fontSize: 13, color: Colors.red),
                                          ),
                                        ],),
                                      actions: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green, // Button background color
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => UploadDocuments()));

                                          },
                                          child: Text(
                                            'OK',
                                            style: TextStyle(fontFamily: "Poppins-Regular",color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    )
                                );
                              },
                            );

                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 25),
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
                        )
                            : SizedBox(),
                      ],
                    ),

                  ],
                ),
              ),
            )

          ],)
          ,)));

  }

  Widget _buildTextField2(String label, TextEditingController controller,
      TextInputType inputType, int maxlength) {
    return Container(
      color: Color(0xFFD42D3F),
      margin: EdgeInsets.symmetric(vertical: 5),
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
                  border: OutlineInputBorder(),
                  counterText: "",
                ),
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

  void _openTermsAndConditions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Terms and Conditions"),
          content: SingleChildScrollView(
            child: Text("Basic Terms and Conditions:\n\n"
                "1. You agree to provide accurate information.\n"
                "2. You consent to data aggregation from your bank accounts.\n"
                "3. Your data will be used solely for providing financial management services.\n"
                "4. You can withdraw consent at any time by contacting us.\n"
                "5. For full terms and conditions, visit our website."),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _onWillPop() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are You Sure to exit',
              style: TextStyle(
                  color: Color(0xFFD42D3F),
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            SizedBox(height: 10),
            /*Text(
              'OK',
              style: TextStyle(color: Colors.black),
            ),*/
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShinyButton(
                  'No',
                      () {
                    EasyLoading.dismiss();
                    Navigator.of(context).pop(true);
                  },
                ),
                _buildShinyButton(
                  'Yes',
                      () {
                    EasyLoading.dismiss();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => DealerHomePage(),
                      ),
                          (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
    // return shouldClose ?? false; // Default to false if dismissed
  }

  Widget _buildShinyButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Color(0xFFD42D3F), // foreground/text
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
