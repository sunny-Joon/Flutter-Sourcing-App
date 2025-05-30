import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/Models/branch_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Models/creator_list_model.dart';
import '../../api_service.dart';
import '../global_class.dart';

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
  String? _selectedCreatorid;
  String _locationMessage = "";
  String? _errorText;

  List<String> _selectedBranches = [];

  final List<String> _requestTypes = [
    'New User Mapping',
    'Login Issue',
    'Update or mapping with Branch'
  ];
  List<CreatorListDataModel> _creators = [];
  List<BranchDataModel> _branch_codes = [];
  bool _isLoading = true;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _imei1Controller = TextEditingController();
  TextEditingController _imei2Controller = TextEditingController();
  TextEditingController _mobileNoController = TextEditingController();
  TextEditingController _branchController = TextEditingController();

  String? _userIdController;
  String? _deviceIdController;
  String? _longitudeController;
  String? _latitudeController;

  // Error State Variables
  String? _nameError;
  String? _imei1Error;
  String? _imei2Error;
  String? _userIdError;
  String? _mobileNoError;
  String? _deviceIdError;
  String? _longitudeError;
  String? _latitudeError;
  String? _branchError;

  String? _requestTypeError;
  String? _creatorError;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _imei1Focus = FocusNode();
  final FocusNode _imei2Focus = FocusNode();
  final FocusNode _mobileNoFocus = FocusNode();
  final FocusNode _branchFocus = FocusNode();

  void validateInputs() {
    setState(() {
      if (_selectedRequestType == null) {
        _requestTypeError =
            AppLocalizations.of(context)!.pleaseselectarequesttype;
      } else {
        _requestTypeError = null;
      }

      if (_selectedCreator == null) {
        _creatorError = AppLocalizations.of(context)!.pleaseselectacreator;
      } else {
        _creatorError = null; // Clear error if valid
      }
    });
  }

  bool validate() {
    bool isValid = true;

    if (_nameController.text.isEmpty) {
      _nameError = AppLocalizations.of(context)!.pleaseentername;
      _nameFocus.requestFocus();
      isValid = false;
    } else {
      _nameError = null;
    }

    if (_imei1Controller.text.isEmpty) {
      _imei1Error = AppLocalizations.of(context)!.pleaseenterimeino1;
      _imei1Focus.requestFocus();
      isValid = false;
    } else if (!RegExp(r'^\d{15}$').hasMatch(_imei1Controller.text)) {
      _imei1Error = AppLocalizations.of(context)!.imeino1mustbe15digits;
      _imei1Focus.requestFocus();
      isValid = false;
    } else {
      _imei1Error = null;
    }

    // Validate IMEI No. 2 (15 digits)
    if (_imei2Controller.text.isEmpty) {
      _imei2Error = AppLocalizations.of(context)!.pleaseenterimeino2;
      _imei2Focus.requestFocus();
      isValid = false;
    } else if (!RegExp(r'^\d{15}$').hasMatch(_imei2Controller.text)) {
      _imei2Error = AppLocalizations.of(context)!.imeino2mustbe15digits;
      _imei2Focus.requestFocus();
      isValid = false;
    } else {
      _imei2Error = null;
    }

    // Validate User ID
    if (_userIdController == null) {
      _userIdError = AppLocalizations.of(context)!.useridnotfound;
      isValid = false;
    } else {
      _userIdError = null;
    }

    // Validate Mobile No. (10 digits)
    if (_mobileNoController.text.isEmpty) {
      _mobileNoError = AppLocalizations.of(context)!.pleaseentermobileno;
      _mobileNoFocus.requestFocus();
      isValid = false;
    } else if (!RegExp(r'^\d{10}$').hasMatch(_mobileNoController.text)) {
      _mobileNoError = AppLocalizations.of(context)!.mobilenomustbe10digits;
      _mobileNoFocus.requestFocus();
      isValid = false;
    } else {
      _mobileNoError = null;
    }

    // Validate Device ID (16 digits)
    if (_deviceIdController == null) {
      _deviceIdError = AppLocalizations.of(context)!.deviceidnotfound;
      isValid = false;
    } else if (!RegExp(r'^\d{16}$').hasMatch(_deviceIdController!)) {
      _deviceIdError = AppLocalizations.of(context)!.deviceidmustbe16digits;
      isValid = false;
    } else {
      _deviceIdError = null;
    }

    // Validate Longitude
    if (_longitudeController == null) {
      _longitudeError = AppLocalizations.of(context)!.longitudenotfound;
      isValid = false;
    } else {
      _longitudeError = null;
    }

    // Validate Latitude
    if (_latitudeController == null) {
      _latitudeError = AppLocalizations.of(context)!.latitudenotfound;
      isValid = false;
    } else {
      _latitudeError = null;
    }

    if (_branchController == null || _branchController.text.isEmpty) {
      _branchError = AppLocalizations.of(context)!.branchnotfound;
      isValid = false;
    } else {
      _branchError = null;
    }

    // Validate Request Type and Creator (Make sure to call validateInputs())
    validateInputs();

    // Refresh UI
    setState(() {});
    return isValid;
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
        _selectedCreator = _creators[0].creator;
      //  _selectedCreatorid = _creators[0].creatorId.toString();

        _isLoading = false;
        EasyLoading.dismiss();
      });
      _fetchBranchList(context, _creators[0].creatorId.toString());
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchBranchList(BuildContext context, String creatorId) async {
    print("object0");
    final api = Provider.of<ApiService>(context, listen: false);
    final value = await api.getBranchList(GlobalClass.token, GlobalClass.dbName, creatorId,GlobalClass.imei);
    print("object1$value");
    if (value.statuscode == 200) {
      setState(() {
        _branch_codes = value.data;
        print("object2${value.data}");

        _isLoading = false;
      });
    } else {
      print("object3$value");

      _branch_codes = [];
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
        body: SingleChildScrollView(
          child: Column(
            children: [
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
                          border:
                              Border.all(width: 1, color: Colors.grey.shade300),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        child: Center(
                          child: Icon(Icons.arrow_back_ios_sharp, size: 16),
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
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            height: MediaQuery.of(context).size.height - 180,
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
                              child: Form(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${AppLocalizations.of(context)!.deviceid} ${_deviceIdController}',
                                      style: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${AppLocalizations.of(context)!.userid} ${_userIdController}',
                                      style: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),

                                    //SizedBox(height:2 ),
                                    SizedBox(height: 4),
                                    // Request Type Dropdown
                                    Text(
                                      AppLocalizations.of(context)!.requesttype,
                                      style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        fontSize: 13,
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(vertical: 4),
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: DropdownSearch<String>(
                                        popupProps: PopupProps.menu(
                                          showSearchBox: true, // Enables search functionality
                                          searchFieldProps: TextFieldProps(
                                            decoration: InputDecoration(
                                              labelText: "Search Request Type",
                                              border: OutlineInputBorder(),
                                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                            ),
                                          ),
                                        ),
                                        items: _requestTypes, // Use the list of request types
                                        selectedItem: _selectedRequestType,
                                        dropdownBuilder: (context, selectedItem) => Text(
                                          selectedItem ?? "Select Request Type",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: "Poppins-Regular",
                                          ),
                                        ),
                                        onChanged: (String? newValue) {
                                          if (newValue != null) {
                                            setState(() {
                                              _selectedRequestType = newValue;
                                              _requestTypeError = null;
                                              validateInputs();
                                            });
                                          }
                                        },
                                        dropdownButtonProps: DropdownButtonProps(
                                          icon: Icon(Icons.arrow_drop_down), // Dropdown button icon
                                        ),
                                        dropdownDecoratorProps: DropDownDecoratorProps(
                                          dropdownSearchDecoration: InputDecoration(
                                            hintText: "Select Request Type",
                                            border: OutlineInputBorder(),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Display error for Request Type
                                    if (_requestTypeError != null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 1, left: 15),
                                        child: Text(
                                          _requestTypeError!,
                                          style: TextStyle(
                                              color: Color(0xFFD42D3F),
                                              fontSize: 12),
                                        ),
                                      ),

                                    SizedBox(height: 4),

                                    SizedBox(height: 4),

                                    // Creator Dropdown
                                    Text(
                                      AppLocalizations.of(context)!.creator,
                                      style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        fontSize: 13,
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(vertical: 4),
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: DropdownSearch<String>(
                                        popupProps: PopupProps.menu(
                                          showSearchBox: true, // Enables search functionality
                                          searchFieldProps: TextFieldProps(
                                            decoration: InputDecoration(
                                              labelText: "Search Creator",
                                              border: OutlineInputBorder(),
                                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                            ),
                                          ),
                                        ),
                                        items: _creators.map((creator) => creator.creator).toList(), // Convert model list to List<String>
                                        selectedItem: _selectedCreator,
                                        dropdownBuilder: (context, selectedItem) => Text(
                                          selectedItem ?? "Select Creator",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: "Poppins-Regular",
                                          ),
                                        ),
                                        onChanged: (String? newValue) {
                                          if (newValue != null) {
                                            setState(() {
                                              _selectedCreator = newValue;
                                              _creatorError = null;
                                              validateInputs();
                                               _selectedCreatorid = _creators
                                                  .firstWhere((creator) => creator.creator == newValue)
                                                  .creatorId
                                                  .toString();
                                              _fetchBranchList(context, _selectedCreatorid!);
                                              _branchController.text = "";
                                              _selectedBranches = [];
                                            });
                                          }
                                        },
                                        dropdownButtonProps: DropdownButtonProps(
                                          icon: Icon(Icons.arrow_drop_down), // Dropdown button icon
                                        ),
                                        dropdownDecoratorProps: DropDownDecoratorProps(
                                          dropdownSearchDecoration: InputDecoration(
                                            hintText: "Select Creator",
                                            border: OutlineInputBorder(),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                          ),
                                        ),
                                      ),
                                    ),

                                    if (_creatorError != null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 1, left: 15),
                                        child: Text(
                                          _creatorError!,
                                          style: TextStyle(
                                              color: Color(0xFFD42D3F),
                                              fontSize: 12),
                                        ),
                                      ),

                                    Row(
                                      children: [
                                        // Expanded widget makes the TextField take up the available space
                                        Expanded(
                                          // child: _buildTextField(
                                          //     'Branch Codes',
                                          //     _branchController,
                                          //     TextInputType.name,
                                          //     false,
                                          //     _branchFocus,100
                                          // ),
                                          child: _buildTextField(
                                              AppLocalizations.of(context)!
                                                  .branchcode,
                                              _branchController,
                                              TextInputType.number,
                                              false,
                                              _branchFocus,
                                              3,
                                              true,
                                              errorText: _branchError),
                                        ),
                                        // IconButton will be placed on the right of the TextField
                                        IconButton(
                                          onPressed: () {
                                            _showMultiSelect(); // Define your action for the icon button
                                          },
                                          icon: Icon(Icons
                                              .arrow_drop_down_circle_sharp),
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
                                    _buildTextField(
                                        AppLocalizations.of(context)!.name,
                                        _nameController,
                                        TextInputType.name,
                                        true,
                                        _nameFocus,
                                        40,
                                        false,
                                        errorText: _nameError),
                                    _buildTextField(
                                        AppLocalizations.of(context)!.mobile,
                                        _mobileNoController,
                                        TextInputType.number,
                                        true,
                                        _mobileNoFocus,
                                        10,
                                        false,
                                        errorText: _mobileNoError),
                                    _buildTextField(
                                        AppLocalizations.of(context)!.imei1,
                                        _imei1Controller,
                                        TextInputType.number,
                                        true,
                                        _imei1Focus,
                                        15,
                                        false,
                                        errorText: _imei1Error),
                                    _buildTextField(
                                        AppLocalizations.of(context)!.imei2,
                                        _imei2Controller,
                                        TextInputType.number,
                                        true,
                                        _imei2Focus,
                                        15,
                                        false,
                                        errorText: _imei2Error),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              color: Color(0xFFD42D3F),
                                            ),
                                            Text(
                                              "${_locationMessage}",
                                              style: TextStyle(
                                                  fontFamily: "Poppins-Regular",
                                                  color: Color(0xFFD42D3F),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () {
                                            geolocator();
                                          },
                                          child: Card(
                                            elevation: 5,
                                            shape: CircleBorder(),
                                            child: Padding(
                                              padding: EdgeInsets.all(3),
                                              child: Icon(
                                                Icons.refresh,
                                                size: 30,
                                                color: Color(0xFFD42D3F),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),

                                    //SizedBox(height:2 ),
                                    if (_errorText != null)
                                      Text(
                                        _errorText!,
                                        style: TextStyle(
                                            fontFamily: "Poppins-Regular",
                                            color: Color(0xFFD42D3F),
                                            fontSize: 13),
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
                                          minimumSize: Size(150, 36),
                                          // Set the width to 150 and the height to 36 (or your preferred height)
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                0), // Rectangular shape
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical:
                                                  12), // Adjust vertical padding as needed
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)!.save,
                                          style: TextStyle(
                                              fontFamily: "Poppins-Regular",
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ) // _buildNextButton(context),
                      ],
                    ),
            ],
          ),
        ));
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller,
      TextInputType inputType,
      bool YN,
      FocusNode FN,
      int maxLength,
      bool readOnly,
      {String? errorText}) {
    // Add errorText as an optional named parameter
    return Container(
      color: Colors.white,
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
            ),
          ),
          SizedBox(height: 1),
          Container(
            width: double.infinity,
            child: Center(
              child: TextFormField(
                maxLength: maxLength,
                controller: controller,
                focusNode: FN,
                keyboardType: inputType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  counterText: "",
                  errorText: errorText, // Display error text dynamically
                  errorStyle: TextStyle(
                    color: Color(0xFFD42D3F), // Set the error text color here
                    fontSize: 12, // Optional: Adjust the font size
                  ),
                ),
                inputFormatters: [
                  label == AppLocalizations.of(context)!.name
                      ? FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                      : FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
                enabled: YN,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> geolocator() async {
    try {
      Position position = await _getCurrentPosition();
      setState(() {
        _locationMessage = "${position.latitude},${position.longitude}";
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      EasyLoading.show(
        status: AppLocalizations.of(context)!.loading,
      );
    });

    final api = Provider.of<ApiService>(context, listen: false);

    Map<String, dynamic> requestBody = {
      "name": _nameController.text,
      "mobile": _mobileNoController.text,
      "IMEI_no1": _imei1Controller.text,
      "IMEI_no2": _imei2Controller.text,
      "deviceId": _deviceIdController,
      "map_branch": _branchController.text,
      "CreatorID": _selectedCreatorid,
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

        GlobalClass.showSuccessAlert(context, value.message, 2);
      } else {
        EasyLoading.dismiss();
        GlobalClass.showErrorAlert(context, value.message, 1);
      }
    }).catchError((err) {
      EasyLoading.dismiss();
      GlobalClass.showUnsuccessfulAlert(
          context, "Device details are not saved or updated", 1);
    });
  }

  void _showMultiSelect() async {
    final selectedValues = await showModalBottomSheet<List<String>>(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context)!.selectbranches,
                    style: TextStyle(
                        fontFamily: "Poppins-Regular",
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _branch_codes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        title: Text(_branch_codes[index].branchName),
                        value: _selectedBranches
                            .contains(_branch_codes[index].branchCode),
                        onChanged: (bool? value) {
                          setModalState(() {
                            if (value == true) {
                              _selectedBranches
                                  .add(_branch_codes[index].branchCode);
                            } else {
                              _selectedBranches
                                  .remove(_branch_codes[index].branchCode);
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD42D3F),
                    minimumSize: Size(150, 36),
                    // Set the width to 150 and the height to 36 (or your preferred height)
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(0), // Rectangular shape
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 12), // Adjust vertical padding as needed
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.addbranches,
                    style: TextStyle(
                        fontFamily: "Poppins-Regular", color: Colors.white),
                  ),
                )
              ],
            );
          },
        );
      },
    );

    if (selectedValues != null) {
      setState(() {
        _selectedBranches = selectedValues;
        _branchController.text = _selectedBranches
            .join(", "); // Update the TextField with selected branches
      });
    }
  }
}
