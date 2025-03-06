import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../DATABASE/database_helper.dart';
import '../Models/creator_list_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Models/place_codes_model.dart';
import '../Models/range_category_model.dart';
import '../api_service.dart';
import '../global_class.dart';

class DealerForm extends StatefulWidget {
  @override
  _DealerFormState createState() => _DealerFormState();
}

class _DealerFormState extends State<DealerForm> {
  String? selectedOEM;
  String? selectedCreater;
  String? selectedFirmType;
  String? selectedCity;
  String? selectedDistrict;
  RangeCategoryDataModel? stateselected, stateselected2;
  String? selectedVP;

  bool isDealer = true;
  bool istype = true;
  bool isfeetype = true;
  String? _creatorError;
  String? selectedCreatorId;
  String? _locationMessage;
  Position? position;

  String pageTitle = "Dealer Dashboard";

  bool _pageloading = true;
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  List<RangeCategoryDataModel> states = [];
  List<CreatorListDataModel> _creators = [];
  List<String> Oemlist = ["Select", "Mr.", "Mrs.", "Miss"];
  List<String> firmlist = ["Select", "Mr.", "Mrs.", "Miss"];
  List<String> vplist = ["Select", "Mr.", "Mrs.", "Miss"];

  bool _isLoading = true;
  String nameReg = '[a-zA-Z. ]';
  String amountReg = '[0-9]';
  String mixReg = '[a-zA-Z0-9]';
  String addReg = r'[a-zA-Z0-9. ()/,-]';
  String panReg = r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$';

  late var _firmController = TextEditingController();
  late var _latitudeController = TextEditingController();
  late var _longitudeController = TextEditingController();
  late var _mobController = TextEditingController();
  late var _emailController = TextEditingController();
  late var _officeaddressController = TextEditingController();
  late var _pincodeController = TextEditingController();
  late var _cityController = TextEditingController();
  late var _districController = TextEditingController();
  late var _pancardController = TextEditingController();
  late var _gstController = TextEditingController();
  late var _cinnoController = TextEditingController();

  late var _NameController = TextEditingController();
  late var _email2Controller = TextEditingController();
  late var _mob2Controller = TextEditingController();
  late var _pancard2Controller = TextEditingController();
  late var _aadharController = TextEditingController();
  late var _addressController = TextEditingController();
  late var _pincode2Controller = TextEditingController();
  late var _city2Controller = TextEditingController();
  late var _distric2Controller = TextEditingController();
  late var _amountController = TextEditingController();

  File? _receiptImage;
  File? selectedFile;

  @override
  void initState() {
    super.initState();
    _fetchCreatorList();
    geolocator(context);
    fetchData();
    setState(() {
      _pageloading = false;
    });
  }

  Future<void> fetchData() async {
    states = await DatabaseHelper().selectRangeCatData("state");

    setState(() {
      states.insert(
          0,
          RangeCategoryDataModel(
            catKey: 'Select',
            groupDescriptionEn: 'select',
            groupDescriptionHi: 'select',
            descriptionEn: 'Select',
            // Display text
            descriptionHi: 'select',
            sortOrder: 0,
            code: 'select', // Value of the placeholder
          ));
    }); // Refresh the UI
    setState(() {
      _pageloading = false;
    });
  }

  Future<void> _fetchCreatorList() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      EasyLoading.show(
        status: AppLocalizations.of(context)!.loading,
      );
    });

    final api = Provider.of<ApiService>(context, listen: false);
    final value = await api.getCreatorList(GlobalClass.dbName);
    if (value.statuscode == 200 && value.data.isNotEmpty) {
      setState(() {
        _creators = value.data;
        selectedCreater = _creators[0].creator;

        _isLoading = false;
        EasyLoading.dismiss();
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void validateInputs() {
    setState(() {
      if (selectedCreater == null) {
        _creatorError = "Please Select Creater";
      } else {
        _creatorError = null; // Clear error if valid
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (bool value) {
          _onWillPop();
        },
        child: Scaffold(
          backgroundColor: Color(0xFFD42D3F),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    width: 1, color: Colors.grey.shade300),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              height: 40,
                              width: 40,
                              alignment: Alignment.center,
                              child: Center(
                                child:
                                    Icon(Icons.arrow_back_ios_sharp, size: 16),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                pageTitle,
                                style: TextStyle(
                                  fontFamily: "Poppins-Regular",
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
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
                    Column(
                      children: [
                        //  _buildProgressIndicator(),
                        SizedBox(height: 20),
                        _pageloading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height -
                                        100,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              150,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black,
                                                blurRadius: 7,
                                              ),
                                            ],
                                          ),
                                          child: Form(
                                            key: _formKey,
                                            child: _getStepContent(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Row(
                                  //       children: [
                                  //         Icon(
                                  //           Icons.location_on_outlined,
                                  //           color: Colors.white,
                                  //         ),
                                  //         Text(
                                  //           "${_locationMessage}",
                                  //           style: TextStyle(
                                  //               fontFamily: "Poppins-Regular",
                                  //               color: Colors.white,
                                  //               fontWeight: FontWeight.bold),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //     InkWell(
                                  //       onTap: () {
                                  //         geolocator(context);
                                  //       },
                                  //       child: Card(
                                  //         elevation: 5,
                                  //         shape: CircleBorder(),
                                  //         child: Padding(
                                  //           padding: EdgeInsets.all(3),
                                  //           child: Icon(
                                  //             Icons.refresh,
                                  //             size: 30,
                                  //             color: Color(0xffb41d2d),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     )
                                  //   ],
                                  // ),

                                  // _buildNextButton(context),
                                ],
                              )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _getStepContent(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return _buildStepThree(context);
      //   return _buildStepOne(context);
      case 1:
        return _buildStepOne(context);
      //  return _buildStepTwo(context);
      case 2:
        return _buildStepTwo(context);
      //  return _buildStepThree(context);

      case 3:
        return _buildStepfour(context);
      default:
        return _buildStepOne(context);
    }
  }

  Widget _buildStepOne(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Dealer/OEM",
            style: TextStyle(color: Colors.black, fontSize: 16)),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: Row(
                children: [
                  Radio(
                    value: true,
                    groupValue: isDealer,
                    onChanged: (bool? value) {
                      setState(() {
                        isDealer = value!;
                      });
                    },
                    activeColor: Colors.orange,
                  ),
                  Text("DEALER",
                      style: TextStyle(color: Colors.black, fontSize: 13)),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Row(
                children: [
                  Radio(
                    value: false,
                    groupValue: isDealer,
                    onChanged: (bool? value) {
                      setState(() {
                        isDealer = value!;
                      });
                    },
                    activeColor: Colors.orange,
                  ),
                  Text("OEM",
                      style: TextStyle(color: Colors.black, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),

        //set api
        // String selectedDealerType = isDealer ? "DEALER" : "OEM";
        Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Select OEM',
                  style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  alignment: Alignment.center,

                  height: 55,
                  // Fixed height
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton<String>(
                    value: selectedOEM,
                    isExpanded: true,
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(
                        fontFamily: "Poppins-Regular",
                        color: Colors.black,
                        fontSize: 13),
                    underline: Container(
                      height: 2,
                      color: Colors
                          .transparent, // Set to transparent to remove default underline
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedOEM = newValue!;
                      });
                    },
                    items: Oemlist.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            )),
            SizedBox(width: 10),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Select Creator',
                  style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 4),
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton<String>(
                    value: selectedCreater,
                    isExpanded: true,
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(
                        fontFamily: "Poppins-Regular",
                        color: Colors.black,
                        fontSize: 13),
                    underline: Container(
                      height: 2,
                      color: Colors
                          .transparent, // Set to transparent to remove default underline
                    ),
                    hint: Text("selectCreator"),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCreater = newValue;
                        _creatorError = null;
                        validateInputs();
                        selectedCreatorId = _creators
                            .firstWhere(
                                (creator) => creator.creator == newValue)
                            .creatorId
                            .toString();
                      });
                    },
                    items: _creators.map((CreatorListDataModel value) {
                      return DropdownMenuItem<String>(
                        value: value.creator,
                        child: Text(value.creator),
                      );
                    }).toList(),
                  ),
                ),
                if (_creatorError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 1, left: 15),
                    child: Text(
                      _creatorError!,
                      style: TextStyle(color: Color(0xFFD42D3F), fontSize: 12),
                    ),
                  ),
              ],
            ))
          ],
        ),
        _buildTextField2(
            'Firm Name', _firmController, TextInputType.text, 30, nameReg),

        Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Firm Type',
                  style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  alignment: Alignment.center,

                  height: 55,
                  // Fixed height
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton<String>(
                    value: selectedOEM,
                    isExpanded: true,
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(
                        fontFamily: "Poppins-Regular",
                        color: Colors.black,
                        fontSize: 13),
                    underline: Container(
                      height: 2,
                      color: Colors
                          .transparent, // Set to transparent to remove default underline
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedFirmType = newValue!;
                      });
                    },
                    items: firmlist.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            )),
            SizedBox(width: 10),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                _buildTextField2('Phone', _mobController, TextInputType.number,
                    10, amountReg),
              ],
            ))
          ],
        ),
        _buildTextField2(
            'Email', _emailController, TextInputType.emailAddress, 20, nameReg),
        _buildTextField2('Office Address', _officeaddressController,
            TextInputType.text, 20, addReg),

        Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                _buildTextField2('Pincode', _pincodeController,
                    TextInputType.number, 6, amountReg),
              ],
            )),
            SizedBox(width: 10),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                _buildTextField2(
                    'City', _cityController, TextInputType.text, 10, nameReg),
              ],
            ))
          ],
        ),

        Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                _buildTextField2('Distric', _districController,
                    TextInputType.text, 6, nameReg),
              ],
            )),
            SizedBox(width: 10),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                _buildLabeledDropdownField(
                    AppLocalizations.of(context)!.sstate,
                    'State',
                    states,
                    stateselected, (RangeCategoryDataModel? newValue) {
                  setState(() {
                    stateselected = newValue;
                  });
                }, String),
              ],
            ))
          ],
        ),

        Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                _buildTextField2('Pan No.', _pancardController,
                    TextInputType.text, 10, mixReg),
              ],
            )),
            SizedBox(width: 10),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                _buildTextField2(
                    'GST NO.', _gstController, TextInputType.text, 20, mixReg),
              ],
            ))
          ],
        ),

        Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                _buildTextField2('CIN Number', _cinnoController,
                    TextInputType.number, 15, amountReg),
              ],
            )),
            SizedBox(width: 10),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Under VP',
                  style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  alignment: Alignment.center,

                  height: 55,
                  // Fixed height
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton<String>(
                    value: selectedVP,
                    isExpanded: true,
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(
                        fontFamily: "Poppins-Regular",
                        color: Colors.black,
                        fontSize: 13),
                    underline: Container(
                      height: 2,
                      color: Colors
                          .transparent, // Set to transparent to remove default underline
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedVP = newValue!;
                      });
                    },
                    items: vplist.map((String value) {
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
          height: 6,
        ),

        Text("Type", style: TextStyle(color: Colors.black, fontSize: 13)),

        Row(
          children: [
            Flexible(
                flex: 5,
                child: Row(
                  children: [
                    Radio(
                      value: true,
                      groupValue: istype,
                      onChanged: (bool? value) {
                        setState(() {
                          istype = value!;
                        });
                      },
                      activeColor: Colors.orange,
                    ),
                    Expanded(
                      child: Text("Empanelled",
                          style: TextStyle(color: Colors.black, fontSize: 13)),
                    )
                  ],
                )),
            Flexible(
                flex: 7,
                child: Row(
                  children: [
                    Radio(
                      value: false,
                      groupValue: istype,
                      onChanged: (bool? value) {
                        setState(() {
                          istype = value!;
                        });
                      },
                      activeColor: Colors.orange,
                    ),
                    Expanded(
                      child: Text("Non-Empanelled",
                          style: TextStyle(color: Colors.black, fontSize: 13)),
                    )
                  ],
                ))
          ],
        ),

        //set api
        // String selectedType = istype ? "Empanelled" : "Non-Empanelled";

        SizedBox(height: 10),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                if (_currentStep == 1) {
                  // if (firstPageFieldValidate()) {
                  pageTitle = "Add Dealer/Oem";
                  setState(() {
                    _currentStep += 1;
                    pageTitle = "Add Owner/Partner Details";
                  });
                  // saveFiMethod(context);
                  return;
                  // }
                } else if (_currentStep == 2) {
                  setState(() {
                    _currentStep += 1;
                    pageTitle = "Show Data ";
                  });
                }
                // Upload action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "NEXT",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Widget _buildStepTwo(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField2(
            'Name', _NameController, TextInputType.text, 30, nameReg),

        Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                _buildTextField2('Phone', _mob2Controller, TextInputType.number,
                    10, amountReg),
              ],
            )),
            SizedBox(width: 10),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                _buildTextField2('Email', _email2Controller,
                    TextInputType.emailAddress, 20, nameReg),
              ],
            ))
          ],
        ),

        Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                _buildTextField2('Pan No.', _pancard2Controller,
                    TextInputType.text, 10, mixReg),
              ],
            )),
            SizedBox(width: 10),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                _buildTextField2('Adhar No', _aadharController,
                    TextInputType.number, 12, amountReg),
              ],
            ))
          ],
        ),
        _buildTextField2(
            'Address', _addressController, TextInputType.text, 20, addReg),

        Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                _buildTextField2('Pincode', _pincode2Controller,
                    TextInputType.number, 6, amountReg),
              ],
            )),
            SizedBox(width: 10),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                _buildTextField2(
                    'City', _city2Controller, TextInputType.text, 10, nameReg),
              ],
            ))
          ],
        ),
        Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                _buildTextField2('Distric', _distric2Controller,
                    TextInputType.number, 6, amountReg),
              ],
            )),
            SizedBox(width: 10),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                _buildLabeledDropdownField(
                    AppLocalizations.of(context)!.sstate,
                    'State',
                    states,
                    stateselected2, (RangeCategoryDataModel? newValue) {
                  setState(() {
                    stateselected2 = newValue;
                  });
                }, String),
              ],
            ))
          ],
        ),

        Text("Fee Type", style: TextStyle(color: Colors.black, fontSize: 16)),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: Row(
                children: [
                  Radio(
                    value: true,
                    groupValue: isfeetype,
                    onChanged: (bool? value) {
                      setState(() {
                        isfeetype = value!;
                      });
                    },
                    activeColor: Colors.orange,
                  ),
                  Text("Refundable",
                      style: TextStyle(color: Colors.black, fontSize: 13)),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Row(
                children: [
                  Radio(
                    value: false,
                    groupValue: isfeetype,
                    onChanged: (bool? value) {
                      setState(() {
                        isfeetype = value!;
                      });
                    },
                    activeColor: Colors.orange,
                  ),
                  Text("Cash",
                      style: TextStyle(color: Colors.black, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),

        //set api
        // String selectedisfeeType = isDealer ? "Refundable" : "Cash"

        Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                _buildTextField2('Amount', _amountController,
                    TextInputType.number, 8, amountReg),
              ],
            )),
            SizedBox(width: 10),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                Text("Upload Reciept",
                    style: TextStyle(color: Colors.black, fontSize: 13)),
                Row(
                  children: [
                    IconButton(
                      icon:
                          Icon(Icons.upload_file, color: Colors.blue, size: 40),
                      onPressed: _pickImage,
                    ),
                    _receiptImage != null
                        ? Image.file(_receiptImage!, height: 50, width: 50)
                        : SizedBox(),
                  ],
                )
              ],
            ))
          ],
        ),

        SizedBox(height: 10),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                if (_currentStep == 2) {
                  if (SecondPageFieldValidate()) {
                    setState(() {
                      _currentStep += 0;
                    });
                  }
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Form submitted successfully")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "SAVE",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),

        SizedBox(height: 10), // Spacing

        Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 500),
            // Ensures width doesn't grow
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "partner Details",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Address: ",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                        Text(
                          'Delhii Sadar Bazar, 110005',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Creater - ",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                        Text(
                          selectedCreater ?? "Select Creator",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Widget _buildStepThree(BuildContext context) {
    List<Map<String, String>> firmData = [
      {
        "firmName": "Firm A",
        "address": "Delhi Sadar Bazar, 110006",
        "creator": "John Doe",
      },
      {
        "firmName": "Firm B",
        "address": "Connaught Place, Delhi",
        "creator": "Jane Smith",
      },
      {
        "firmName": "Firm C",
        "address": "Karol Bagh, Delhi",
        "creator": "Alex Brown",
      },
    ];

    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // First button action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          minimumSize: Size(0, 50),
                        ),
                        child: Text("Newly Added",
                            style:
                                TextStyle(color: Colors.white, fontSize: 13)),
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Second button action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          minimumSize: Size(0, 50),
                        ),
                        child: Text("Approved From Branch",
                            style:
                                TextStyle(color: Colors.white, fontSize: 13)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Wrap ListView.builder inside Column
              Column(
                children: firmData.map((data) {
                  return Center(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 500),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data["firmName"]!,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Address: ",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  Text(
                                    data["address"]!,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Creater: ",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  Text(
                                    selectedCreater ?? "Select Creator",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: SizedBox(
                                  width: 120,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _currentStep = 3;
                                        pageTitle = "Document Upload";
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      "Upload Document",
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 150),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () {
              if (_currentStep == 0) {
                setState(() {
                  _currentStep += 1;
                  pageTitle = "Add Dealer/OEM";
                });
              }
            },
            backgroundColor: Colors.blue,
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildStepfour(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildUploadCard("GSTIN"),
            _buildUploadCard("Trade Certificate"),
            _buildUploadCard("KYC of Authorized signatory"),
            _buildUploadCard(
                "Products details on letter head or Product catalogue"),
            _buildUploadCard("Letter of intent by OEM"),
            _buildUploadCard("OEM recommendation email"),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });

      // API call to upload file
      //  _uploadFile(selectedFile!);
    }
  }

  // Future<void> _uploadFile(File file) async {
  //   var request = http.MultipartRequest(
  //       'POST', Uri.parse("https://yourapi.com/upload")); // Replace with your API URL
  //   request.files.add(await http.MultipartFile.fromPath('file', file.path));
  //
  //   var response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     print("File Uploaded Successfully");
  //   } else {
  //     print("Upload Failed");
  //   }
  // }

  Widget _buildUploadCard(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.red,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 14),
        ),
        trailing: IconButton(
          icon: Icon(Icons.upload_file, color: Colors.amber, size: 50),
          onPressed: _pickFile,
        ),
      ),
    );
  }

  Widget _buildTextField2(String label, TextEditingController controller,
      TextInputType inputType, int maxlength, String regex) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 3),
      padding: EdgeInsets.all(1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                fontFamily: "Poppins-Regular", fontSize: 13, height: 2),
          ),
          Container(
            width: double.infinity, // Set the desired width
            child: Center(
              child: TextFormField(
                style: TextStyle(fontFamily: "Poppins-Regular", fontSize: 13),

                maxLength: maxlength,
                controller: controller,
                keyboardType: inputType,
                // Set the input type
                decoration: InputDecoration(
                    border: OutlineInputBorder(), counterText: ""),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter $label';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(regex)),
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
              AppLocalizations.of(context)!.areyousure,
              style: TextStyle(
                  color: Color(0xFFD42D3F),
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Do you want to close Dealer Form',
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShinyButton(
                  AppLocalizations.of(context)!.no,
                  () {
                    EasyLoading.dismiss();
                    Navigator.of(context).pop(true);
                  },
                ),
                _buildShinyButton(
                  AppLocalizations.of(context)!.yes,
                  () {
                    EasyLoading.dismiss();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
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
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFFD42D3F), // foreground/text
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }

  Future<void> geolocator(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      EasyLoading.show(
        status: AppLocalizations.of(context)!.loading,
      );
    });
    try {
      position = await _getCurrentPosition();
      setState(() {
        if (position != null) {
          _locationMessage = "${position!.latitude},${position!.longitude}";
          print("Geolocation: $_locationMessage");
          _latitudeController.text = position!.latitude.toString();
          _longitudeController.text = position!.longitude.toString();
        }
      });
    } catch (e) {
      setState(() {
        _locationMessage = e.toString();
        _latitudeController.clear();
        _longitudeController.clear();
      });
      print("Geolocation Error: $_locationMessage");

      _showRefreshDialog(context);
    }
    EasyLoading.dismiss();
  }

  void _showRefreshDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Error'),
          content: Text(AppLocalizations.of(context)!.unabletofetchthelocation),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                geolocator(context); // Retry fetching the location
              },
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        );
      },
    );
  }

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Widget _buildNextButton(BuildContext context) {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width - 100,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFA60A19),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: 6),
        ),
        onPressed: () {
          if (_currentStep == 1) {
            pageTitle = "Add Dealer/Oem";
            setState(() {
              _currentStep += 2;
              pageTitle = "Add Owner/Partner Details";
            });
          } else if (_currentStep == 2) {
            setState(() {
              _currentStep += 1;
              pageTitle = "Show Data ";
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Form submitted successfully")),
            );
          }
        },
        child: Text(
          AppLocalizations.of(context)!.submit,
          style: TextStyle(
              fontFamily: "Poppins-Regular", color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildLabeledDropdownField<T>(
      String labelText,
      String label,
      List<T> items,
      T? selectedValue,
      ValueChanged<T?>? onChanged,
      Type objName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              labelText,
              style: TextStyle(
                fontFamily: "Poppins-Regular",
                fontSize: 13,
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              // Ensure the dropdown takes the full width available
              child: DropdownButtonFormField<T>(
                isExpanded: true,
                // Ensure the dropdown expands to fit its content
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: label,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400, // Border color when enabled
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: Colors.grey, // Border color when focused
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: Colors.grey, // Default border color
                    ),
                  ),
                ),
                value: selectedValue,
                items: items.map((T value) {
                  String setdata = "";
                  if (value is RangeCategoryDataModel) {
                    setdata = value.descriptionEn;
                  } else if (value is PlaceData) {
                    if (label == "Cities") {
                      setdata = value.cityName ?? "";
                    } else if (label == "Districts") {
                      setdata = value.distName ?? "";
                    } else if (label == "Sub-Districts") {
                      setdata = value.subDistName ?? "";
                    } else if (label == "Village") {
                      setdata = value.villageName ?? "";
                    }
                  }

                  return DropdownMenuItem<T>(
                    value: value,
                    child: Text(
                      setdata,
                      style: TextStyle(
                          fontFamily: "Poppins-Regular",
                          fontSize: 13,
                          fontWeight: FontWeight.normal),
                    ), // Convert the value to string for display
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _receiptImage = File(pickedFile.path);
      });
    }
  }

  bool firstPageFieldValidate() {
    if (selectedOEM == null || selectedOEM == "Select") {
      showToast_Error('Please Select OEM');
      return false;
    } else if (selectedCreater == null) {
      showToast_Error('Please Select Creater ');
      return false;
    } else if (_firmController.text.isEmpty) {
      showToast_Error('Please Enter Firm Name');
      return false;
    } else if (selectedFirmType == "Select" || selectedFirmType == null) {
      showToast_Error('Please Select Firm Type');
      return false;
    } else if (_mobController.text.isEmpty) {
      showToast_Error('Please Enter Mobile Number');
      return false;
    } else if (_mobController.text.length != 10) {
      showToast_Error('Please Enter correct Mobile Number');
      return false;
    } else if (_emailController.text.isEmpty) {
      showToast_Error('Please Enter Email id');
      return false;
    } else if (_officeaddressController.text.isEmpty) {
      showToast_Error('Please Enter Office Address');
      return false;
    } else if (_pincodeController.text.isEmpty) {
      showToast_Error('Please Enter Pin code');
      return false;
    } else if (_pincodeController.text.length != 6) {
      showToast_Error('Please Enter Correct Pin code');
      return false;
    } else if (_cityController.text.isEmpty) {
      showToast_Error('Please Enter City');
      return false;
    } else if (_districController.text.isEmpty) {
      showToast_Error('Please Enter Distric');
      return false;
    } else if (stateselected == null) {
      showToast_Error('Please Select State');
      return false;
    } else if (_pancardController.text.isEmpty) {
      showToast_Error('Please Enter Pan Card No');
      return false;
    } else if (_pancardController.text.length != 10) {
      showToast_Error('Pan Card Number must be exactly 10 characters');
      return false;
    } else if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$')
        .hasMatch(_pancardController.text)) {
      showToast_Error('Please Enter Correct Pan Card No');
      return false;
    }

    if (_gstController.text.isEmpty) {
      showToast_Error('Please Enter GST No');
      return false;
    } else if (_cinnoController.text.isEmpty) {
      showToast_Error('Please Enter CIN No');
      return false;
    } else if (selectedVP == "Select" || selectedVP == null) {
      showToast_Error('Please Select Under VP');
      return false;
    }

    return true;
  }

  void showToast_Error(String message) {
    Fluttertoast.showToast(
      msg: "$message",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  bool SecondPageFieldValidate() {
    if (_NameController.text.isEmpty) {
      showToast_Error('Please Enter Name');
      return false;
    } else if (_mob2Controller.text.isEmpty) {
      showToast_Error('Please Enter Mobile Number');
      return false;
    } else if (_mob2Controller.text.length != 10) {
      showToast_Error('Please Enter correct Mobile Number');
      return false;
    } else if (_email2Controller.text.isEmpty) {
      showToast_Error('Please Enter Email id');
      return false;
    } else if (_pancard2Controller.text.isEmpty) {
      showToast_Error('Please Enter Pan Card No');
      return false;
    } else if (_pancard2Controller.text.length != 10) {
      showToast_Error('Pan Card Number must be exactly 10 characters');
      return false;
    } else if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$')
        .hasMatch(_pancard2Controller.text)) {
      showToast_Error('Please Enter Correct Pan Card No');
      return false;
    } else if (_aadharController.text.isEmpty) {
      showToast_Error('Please Enter Aadhar no');
      return false;
    } else if (_aadharController.text.length != 12) {
      showToast_Error('Please Enter correct Aadhar Number');
      return false;
    } else if (_addressController.text.isEmpty) {
      showToast_Error('Please Enter Address');
      return false;
    } else if (_pincode2Controller.text.isEmpty) {
      showToast_Error('Please Enter Pin code');
      return false;
    } else if (_pincode2Controller.text.length != 6) {
      showToast_Error('Please Enter Correct Pin code');
      return false;
    } else if (_city2Controller.text.isEmpty) {
      showToast_Error('Please Enter City');
      return false;
    } else if (_distric2Controller.text.isEmpty) {
      showToast_Error('Please Enter Distric');
      return false;
    } else if (stateselected2 == null) {
      showToast_Error('Please Select State');
      return false;
    } else if (_amountController.text.isEmpty) {
      showToast_Error('Please Enter Amount');
      return false;
    } else if (_receiptImage == null) {
      showToast_Error('Please Upload Receipt');
      return false;
    }

    return true;
  }
}
