import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/global_class.dart';
import 'package:flutter_sourcing_app/Models/branch_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'api_service.dart';
import 'Models/creator_list_model.dart';
import 'popup_dialog.dart';

class Sharedeviceid extends StatefulWidget {
  final String mobile;
  final String deviceid;

  const Sharedeviceid(
      {super.key, required this.mobile, required this.deviceid});

  @override
  State<Sharedeviceid> createState() => _SharedeviceidState();
}

class _SharedeviceidState extends State<Sharedeviceid> {
  String? _selectedRequestType;
  String? _selectedCreator;
  String _locationMessage = "";

  List<String> _selectedBranches = [];

  final List<String> _requestTypes = [
    'New User Mapping',
    'Login Issue',
    'Update or mapping with Branch'
  ];
  List<CreatorListDataModel> _creators = [];
  List<BranchDataModel> _branch_codes = [];
  bool _isLoading = true;
  String? _errorText;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _imei1Controller = TextEditingController();
  TextEditingController _imei2Controller = TextEditingController();
  TextEditingController _mobileNoController = TextEditingController();
  TextEditingController _branchController = TextEditingController();

  String? _userIdController;
  String? _deviceIdController;
  String? _longitudeController;
  String? _latitudeController;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _imei1Focus = FocusNode();
  final FocusNode _imei2Focus = FocusNode();
  final FocusNode _mobileNoFocus = FocusNode();
  final FocusNode _branchFocus = FocusNode();

  bool validate() {
    // Validate Name
    if (_nameController.text.isEmpty) {
      showToast_Error("Please enter Name");
      _nameFocus.requestFocus();
      return false;
    }

    // Validate IMEI No. 1 (15 digits)
    if (_imei1Controller.text.isEmpty) {
      showToast_Error("Please enter IMEI No. 1");
      _imei1Focus.requestFocus();
      return false;
    } else if (!RegExp(r'^\d{15}$').hasMatch(_imei1Controller.text)) {
      showToast_Error("IMEI No. 1 must be 15 digits");
      _imei1Focus.requestFocus();
      return false;
    }

    // Validate IMEI No. 2 (15 digits)
    if (_imei2Controller.text.isEmpty) {
      showToast_Error("Please enter IMEI No. 2");
      _imei2Focus.requestFocus();
      return false;
    } else if (!RegExp(r'^\d{15}$').hasMatch(_imei2Controller.text)) {
      showToast_Error("IMEI No. 2 must be 15 digits");
      _imei2Focus.requestFocus();
      return false;
    }

    // Validate User ID (null check)
    if (_userIdController == null) {
      showToast_Error("User ID Not Found");
      return false;
    }

    // Validate Mobile No. (10 digits)
    if (_mobileNoController.text.isEmpty) {
      showToast_Error("Please enter Mobile No.");
      _mobileNoFocus.requestFocus();
      return false;
    } else if (!RegExp(r'^\d{10}$').hasMatch(_mobileNoController.text)) {
      showToast_Error("Mobile No. must be 10 digits");
      _mobileNoFocus.requestFocus();
      return false;
    }

    // Validate Device ID (16 digits)
    if (_deviceIdController == null) {
      showToast_Error("Device ID Not Found");
      return false;
    } else if (!RegExp(r'^\d{16}$').hasMatch(_deviceIdController!)) {
      showToast_Error("Device ID must be 16 digits");
      return false;
    }

    // Validate Longitude
    if (_longitudeController == null) {
      showToast_Error("Longitude Not Found");
      return false;
    }

    // Validate Latitude
    if (_latitudeController == null) {
      showToast_Error("Latitude Not Found");
      return false;
    }

    return true;
  }



  @override
  void initState() {
    super.initState();
    _userIdController = widget.mobile.toString();
    _deviceIdController = widget.deviceid.toString();
    _branchController = TextEditingController();

    _fetchCreatorList();

    geolocator();
  }

  Future<void> _fetchCreatorList() async {
    EasyLoading.show(
      status: 'Loading...',
    );

    final api = Provider.of<ApiService>(context, listen: false);
    final value = await api.getCreatorList(GlobalClass.dbName);
    if (value.statuscode == 200 && value.data.isNotEmpty) {
      setState(() {
        _creators = value.data;
        _isLoading = false;
        EasyLoading.dismiss();
      });
    }
  }

  Future<void> _fetchBranchList(BuildContext context, String creators) async {
    final api = Provider.of<ApiService>(context, listen: false);
    final value = await api.getBranchList(GlobalClass.dbName, creators);
    if (value.statuscode == 200) {
      setState(() {
        _branch_codes = value.data; // Assuming value.data is a list of BranchDataModel
        _isLoading = false;
      });
    }
  }


  /* _onSave(BuildContext context) {
    final error = _validateData();
    if (error != null) {
      setState(() {
        _errorText = error;
      });
      return;
    }

    _saveMappingReq(
        context,
        _nameController.text,
        _mobileController.text,
        _imei1Controller.text,
        _imei2Controller.text,
        _deviceIdController.text,
        _selectedBranch!.branchCode.toString(),
        _selectedCreator.toString(),
        _mobileNoController.text,
        _longitudeController.text,
        _latitudeController.text,
        _selectedRequestType.toString());*/


  void showToast_Error(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xFFD42D3F),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      body: Column(children: [
        SizedBox(height: 40),
        Padding(
          padding: EdgeInsets.all(10),
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
                  Navigator.pop(context);
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
        _isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            :   Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(20.0),
                    child:
                    Container(
                          padding: EdgeInsets.all(20),
                          height: MediaQuery.of(context).size.height-180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 7,
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            child:Form(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Device Id:- ${_deviceIdController}',
                                  style: TextStyle(fontFamily: "Poppins-Regular",
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'User Id:- ${_userIdController}',
                                  style: TextStyle(fontFamily: "Poppins-Regular",
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),

                                //SizedBox(height:2 ),
                                SizedBox(height: 4),
                                Text(
                                  'Request Type',
                                  style: TextStyle(fontFamily: "Poppins-Regular",fontSize: 13),
                                ),

                                Container(
                                  alignment: Alignment.center,
                                  margin:
                                  EdgeInsets.symmetric(vertical: 4),
                                  padding: EdgeInsets.all(4),
                                  // height: 55,
                                  // Fixed height
                                  decoration: BoxDecoration(
                                    border:
                                    Border.all(color: Colors.grey),
                                    borderRadius:
                                    BorderRadius.circular(5),
                                  ),
                                  child: DropdownButton<String>(
                                    value: _selectedRequestType,
                                    isExpanded: true,
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(fontFamily: "Poppins-Regular",
                                        color: Colors.black,
                                        fontSize: 13),
                                    underline: Container(
                                      height: 2,
                                      color: Colors
                                          .transparent, // Set to transparent to remove default underline
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedRequestType = newValue!;
                                      });
                                    },
                                    items:
                                    _requestTypes.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),

                                SizedBox(height: 4),
                                Text(
                                  'Creator',
                                  style: TextStyle(fontFamily: "Poppins-Regular",fontSize: 13),
                                ),

                                Container(
                                  alignment: Alignment.center,
                                  //height: 55,
                                  // Fixed height
                                  margin:
                                  EdgeInsets.symmetric(vertical: 4),
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    border:
                                    Border.all(color: Colors.grey),
                                    borderRadius:
                                    BorderRadius.circular(5),
                                  ),
                                  child: DropdownButton<String>(
                                    value: _selectedCreator,
                                    isExpanded: true,
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(fontFamily: "Poppins-Regular",
                                        color: Colors.black,
                                        fontSize: 16),
                                    underline: Container(
                                      height: 2,
                                      color: Colors
                                          .transparent, // Set to transparent to remove default underline
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedCreator = newValue!;
                                        _fetchBranchList(context, _selectedCreator!);
                                      });
                                    },
                                    items: _creators.map(
                                            (CreatorListDataModel value) {
                                          return DropdownMenuItem<String>(
                                            value: value.creator,
                                            child: Text(value.creator),
                                          );
                                        }).toList(),
                                  ),
                                ),

                                Row(
                                  children: [
                                    // Expanded widget makes the TextField take up the available space
                                    Expanded(
                                      child: _buildTextField(
                                          'Branch Codes',
                                          _branchController,
                                          TextInputType.name,
                                          false,
                                          _branchFocus
                                      ),
                                    ),
                                    // IconButton will be placed on the right of the TextField
                                    IconButton(
                                      onPressed: () {
                                        _showMultiSelect();  // Define your action for the icon button
                                      },
                                      icon: Icon(Icons.arrow_drop_down_circle_sharp),
                                    ),
                                  ],
                                ),

                                /*_buildLabeledDropdownField(
                                context,
                                'Creator',
                                'Creator',
                                _creators,
                                _selectedCreator, (CreatorListDataModel? newValue) {
                              setState(() {
                                _selectedCreator = newValue;
                                _fetchBranchList(context, _selectedCreator!);
                              });
                            },
                                CreatorListDataModel),
                            //SizedBox(height:2 ),
                            _buildLabeledDropdownField(
                                context,
                                'Branch Code',
                                'Branch Code',
                                _branch_codes,
                                _selectedBranch,
                                    (BranchDataModel? newValue) {
                                  setState(() {
                                    _selectedBranch = newValue;
                                  });
                                },
                                BranchDataModel),*/
                                //SizedBox(height:2 ),
                                _buildTextField('Name', _nameController,
                                    TextInputType.name, true, _nameFocus),
                                //SizedBox(height:2 ),
                                _buildTextField(
                                    'Mobile',
                                    _mobileNoController,
                                    TextInputType.number,
                                    true,
                                    _mobileNoFocus),
                                //SizedBox(height:2 ),
                                _buildTextField(
                                    'IMEI No. 1',
                                    _imei1Controller,
                                    TextInputType.number,
                                    true,
                                    _imei1Focus),
                                //SizedBox(height:2 ),
                                _buildTextField(
                                    'IMEI No. 2',
                                    _imei2Controller,
                                    TextInputType.number,
                                    true,
                                    _imei2Focus),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      Icon(Icons.location_on_outlined,color: Colors.red,),
                                      Text("${_locationMessage}",style: TextStyle(fontFamily: "Poppins-Regular",color: Colors.red,fontWeight: FontWeight.bold),),

                                    ],),
                                    InkWell(
                                      onTap: (){geolocator();},

                                      child:  Card(
                                        elevation: 5,
                                        shape: CircleBorder(),
                                        child: Padding(padding: EdgeInsets.all(3),child: Icon(Icons.refresh,size: 30,color: Color(0xffb41d2d),),),
                                      ),
                                    )


                                  ],
                                ),

                                //SizedBox(height:2 ),
                                if (_errorText != null)
                                  Text(
                                    _errorText!,
                                    style: TextStyle(fontFamily: "Poppins-Regular",
                                        color: Color(0xFFD42D3F), fontSize: 13),
                                  ),
                                //SizedBox(height:2 ),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (validate()) {
                                        _saveMappingReq(context);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFD42D3F),
                                      minimumSize: Size(150,
                                          36), // Set the width to 150 and the height to 36 (or your preferred height)
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            0), // Rectangular shape
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                          12), // Adjust vertical padding as needed
                                    ),
                                    child: Text(
                                      'Save',
                                      style:
                                      TextStyle(fontFamily: "Poppins-Regular",color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  ),

              )// _buildNextButton(context),
            ],
          ),
      ],)

    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      TextInputType inputType, bool YN, FocusNode FN) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontFamily: "Poppins-Regular",
              fontSize: 13,
            ),
          ),
          SizedBox(height: 1),
          Container(
            width: double.infinity, // Set the desired width
            child: Center(
              child: TextFormField(
                controller: controller,
                focusNode: FN,
                keyboardType: inputType,
                // Set the input type
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                enabled: YN,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> geolocator() async {
    try {
      Position position = await _getCurrentPosition();
      setState(() {
        _locationMessage =
            "${position.latitude},${position.longitude}";
        print(
            " geolocatttion: $_locationMessage"); // Print the location message to the console
        _latitudeController = position.latitude.toString();
        _longitudeController = position.longitude.toString();
      });
    } catch (e) {
      setState(() {
        _locationMessage = e.toString();
      });
      print(
          " geolocatttion: $_locationMessage"); // Print the error message to the console
    }
  }

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
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
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When permissions are granted, get the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _saveMappingReq(BuildContext context) async {
    EasyLoading.show(
      status: 'Loading...',
    );

    final api = Provider.of<ApiService>(context, listen: false);

    Map<String, dynamic> requestBody = {
      "name": _nameController.text,
      "mobile": _mobileNoController.text,
      "IMEI_no1": _imei1Controller.text,
      "IMEI_no2": _imei2Controller.text,
      "deviceId": _deviceIdController,
      "map_branch": _branchController.text,
      "creator": _selectedCreator,
      "userId": _userIdController,
      "longitude": _longitudeController,
      "latitude": _latitudeController,
      "compType": _selectedRequestType,
    };

    return await api
        .getImeiMappingReq(GlobalClass.dbName, requestBody)
        .then((value) async {
      if (value.statuscode == 200) {
        EasyLoading.dismiss();

        if (value.data[0].errormsg == null || value.data[0].errormsg.isEmpty) {
          GlobalClass.showSuccessAlert(
              context, value.message,2);
        } else {
          GlobalClass.showUnsuccessfulAlert(
              context, value.data[0].errormsg,1);
        }
      } else {
        EasyLoading.dismiss();
        GlobalClass.showErrorAlert(
            context,value.message,1);
      }
    });
  }

  void _showMultiSelect() async {
    final selectedValues = await showModalBottomSheet<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Select Branches',
                    style: TextStyle(fontFamily: "Poppins-Regular",fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _branch_codes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        title: Text(_branch_codes[index].branchName),
                        value: _selectedBranches.contains(_branch_codes[index].branchCode),
                        onChanged: (bool? value) {
                          setModalState(() {
                            if (value == true) {
                              _selectedBranches.add(_branch_codes[index].branchCode);
                            } else {
                              _selectedBranches.remove(_branch_codes[index].branchCode);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, _selectedBranches);
                  },
                  child: Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );

    if (selectedValues != null) {
      setState(() {
        _selectedBranches = selectedValues;
        _branchController.text = _selectedBranches.join(", "); // Update the TextField with selected branches
      });
    }
  }



}

