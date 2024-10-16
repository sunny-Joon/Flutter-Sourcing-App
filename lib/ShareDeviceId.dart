import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/GlobalClass.dart';
import 'package:flutter_sourcing_app/Models/branch_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'ApiService.dart';
import 'Models/CreatorListModel.dart';
import 'PopupDialog.dart';

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
  CreatorListDataModel? _selectedCreator;
  String _locationMessage = "";

  BranchDataModel? _selectedBranch;
  final List<String> _requestTypes = ['Type 1', 'Type 2', 'Type 3'];
  List<CreatorListDataModel> _creators = [];
  List<BranchDataModel> _branch_codes = [];
  bool _isLoading = true;

   TextEditingController _nameController=TextEditingController();
   TextEditingController _imei1Controller=TextEditingController();
   TextEditingController _imei2Controller=TextEditingController();
   TextEditingController _mobileController=TextEditingController();
   TextEditingController _mobileNoController=TextEditingController();
   TextEditingController _deviceIdController=TextEditingController();
   TextEditingController _longitudeController=TextEditingController();
   TextEditingController _latitudeController=TextEditingController();
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _mobileController = TextEditingController(text: widget.mobile);
    _deviceIdController = TextEditingController(text: widget.deviceid);

    _fetchCreatorList();

    geolocator();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _deviceIdController.dispose();
    _nameController.dispose();
    _imei1Controller.dispose();
    _imei2Controller.dispose();
    _mobileNoController.dispose();
    super.dispose();
  }

  Future<void> _fetchCreatorList() async {
    final api = Provider.of<ApiService>(context, listen: false);
    final value = await api.getCreatorList(GlobalClass.dbName);
    if (value.statuscode == 200 && value.data.isNotEmpty) {
      setState(() {
        _creators = value.data;
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchBranchList(BuildContext context,
      CreatorListDataModel creators) async {
    final api = Provider.of<ApiService>(context, listen: false);
    final value = await api.getBranchList(
        GlobalClass.dbName, creators.creator.toString());
    if (value.statuscode == 200) {
      setState(() {
        _branch_codes = value.data;
        _isLoading = false;
      });
    }
  }

   _onSave(BuildContext context) {
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
        _selectedRequestType.toString());
  }

  String? _validateData() {

    final name = _nameController.text;
    final mobile = _mobileNoController.text;
    final creator = _selectedCreator;
    final deviceId = _deviceIdController.text;
    final compType = _selectedRequestType;
    final imei1 = _imei1Controller.text;
    final imei2 = _imei2Controller.text;
    final longitude = _longitudeController.text;
    final latitude = _latitudeController.text;
    final branchCode = _selectedBranch;

    if (name.isEmpty) return 'Name is required.';
    if (mobile.length != 10) return 'Mobile number must be 10 digits long.';
    if (imei1.length != 15) return 'IMEI must be 15 digits.';
    if (deviceId.length != 16) return 'Device ID must be 16 digits.';
    if (creator == null) return 'Creator is required.';
    if (branchCode == null) return 'branchCode is required.';
    if (compType == null) return 'Request Type is required.';
    if (longitude.isEmpty) return 'Latitude is required.';
    if (latitude.isEmpty) return 'Longitude is required.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text('Share Device ID'),
        backgroundColor: Colors.red[900],
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Device Id', _deviceIdController, false),
              SizedBox(height: 10),
              _buildTextField('User Id', _mobileController, false),
              SizedBox(height: 10),
              _buildDropdownField(
                  'Request Type', _requestTypes, _selectedRequestType,
                      (String? newValue) {
                    setState(() {
                      _selectedRequestType = newValue;
                    });
                  }),
              SizedBox(height: 10),
              _buildLabeledDropdownField(
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
              SizedBox(height: 10),
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
                  BranchDataModel),
              SizedBox(height: 10),
              _buildTextField('Name', _nameController, true),
              SizedBox(height: 10),
              _buildTextField('Mobile', _mobileNoController, true),
              SizedBox(height: 10),
              _buildTextField('IMEI No. 1', _imei1Controller, true),
              SizedBox(height: 10),
              _buildTextField('IMEI No. 2', _imei2Controller, true),
              SizedBox(height: 10),
              _buildTextField('Longitude', _longitudeController, true),
              SizedBox(height: 10),
              _buildTextField('Latitude', _latitudeController, true),
              SizedBox(height: 10),
              if (_errorText != null)
                Text(
                  _errorText!,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle cancel action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[900],
                    ),
                    child: Text('Cancel',
                        style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: _onSave(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[900],
                    ),
                    child: Text('Save',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      bool isEditable) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        Card(
          elevation: 5,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: label,
              contentPadding: EdgeInsets.all(10),
              border: InputBorder.none,
            ),
            keyboardType: label.contains('Mobile') || label.contains('IMEI')
                ? TextInputType.phone
                : TextInputType.text,
            enabled: isEditable,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>(String label, List<T> items, T? selectedItem,
      ValueChanged<T?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        Card(
          elevation: 5,
          child: DropdownButtonFormField<T>(
            value: selectedItem,
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(15),
              border: InputBorder.none,
            ),
            hint: Text('Select $label'),
            items: items.map((T item) {
              String newVal = "";
              if (item is CreatorListDataModel) {
                newVal = item.creator;
              }
              return DropdownMenuItem<T>(
                value: item,
                child: Text(item.toString()),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Future<void> geolocator() async {
    try {
      Position position = await _getCurrentPosition();
      setState(() {
        _locationMessage = "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
        print(" geolocatttion: $_locationMessage"); // Print the location message to the console
        _latitudeController.text = position.latitude.toString();
        _longitudeController.text = position.longitude.toString();
      });
    } catch (e) {
      setState(() {
        _locationMessage = e.toString();
      });
      print(" geolocatttion: $_locationMessage"); // Print the error message to the console
      // Only set controllers if position is available
      _latitudeController.clear();
      _longitudeController.clear();
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
}

  Widget _buildLabeledDropdownField<T>(
    BuildContext context,
    String labelText,
    String label,
    List<T> items,
    T? selectedValue,
    ValueChanged<T?>? onChanged,
    Type objName) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: "assets/fonts/Poppins-SemiBold.ttf",
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<T>(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            //   labelText: label,
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
            if (value is CreatorListDataModel) {
              setdata = (value as CreatorListDataModel).creator;
            }else if (value is BranchDataModel) {
              setdata = (value as BranchDataModel).branchName;
            }

            return DropdownMenuItem<T>(
              value: value,
              child: Text(setdata), // Convert the value to string for display
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    ),
  );
}

Future<void> _saveMappingReq(
    BuildContext context,
    String name,
    String _mobileController,
    String imei1,
    String imei2,
    String deviceId,
    String branchCode,
    String creator,
    String mobile,
    String longitude,
    String latitude,
    String _selectedRequestType) async {
  final api = Provider.of<ApiService>(context, listen: false);

  Map<String, dynamic> requestBody = {
    "name": name,
    "mobile": mobile,
    "creator": creator,
    "compType": _selectedRequestType,
    "deviceId": deviceId,
    "IMEI_no1": imei1,
    "IMEI_no2": imei2,
    "userId": _mobileController,
    "map_branch": branchCode,
    "latitude": latitude,
    "longitude": longitude,
  };

  return await api.getImeiMappingReq(GlobalClass.dbName, requestBody).then((value) async {
    if (value.statusCode == 200) {
        PopupDialog.showPopup(
            context, value.statusCode.toString(), value.message);

    } else {
      PopupDialog.showPopup(context, value.statusCode.toString(), value.message);

    }
  });
}
