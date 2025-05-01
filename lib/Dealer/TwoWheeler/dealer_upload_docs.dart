import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

import '../HomePage/dealer_homepage.dart';

class UploadDocuments extends StatefulWidget {

  @override
  State<UploadDocuments> createState() => _UploadDocumentsState();
}

class _UploadDocumentsState extends State<UploadDocuments> {
  final Map<String, File?> _documents = {
    "Aadhaar Front": null,
    "Aadhaar Back": null,
    "Voter ID": null,
    "PAN Card": null,
    "Passbook": null,
    "Passport": null,
    "Driving License": null,
    "Account Statement": null,
  };
  Future<void> _pickFile(String docType) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Capture from Camera'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile =
                await ImagePicker().pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  setState(() {
                    _documents[docType] = File(pickedFile.path);
                  });
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Pick from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile =
                await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    _documents[docType] = File(pickedFile.path);
                  });
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.file_copy),
              title: Text('Pick File (PDF/Docs)'),
              onTap: () async {
                Navigator.pop(context);
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf', 'doc', 'docx'],
                );
                if (result != null) {
                  setState(() {
                    _documents[docType] = File(result.files.single.path!);
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }
  Widget _buildUploadCard(String label, File? file) {
    return Container(
      height: 200,
      margin: EdgeInsets.all(10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background container
          Positioned(
            bottom: 20,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.redAccent, Color(0xFFD42D3F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17)),
                color: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                child: file == null
                    ? Container(
                  width:MediaQuery.of(context).size.width / 2 - 30,
                  child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Upload \n$label",
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(Icons.camera_alt, color: Colors.white, size: 30),
                  ],
                ),)
                    : file.path.endsWith('.pdf') || file.path.endsWith('.doc')
                    ? Container(
                  width: MediaQuery.of(context).size.width / 2 - 30,
                  child: Icon(Icons.picture_as_pdf,
                      color: Colors.white, size: 50),
                )
                    : Image.file(
                  file,
                  width: MediaQuery.of(context).size.width / 2 - 30,
                  height: 140,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          // Floating button
          Positioned(
            bottom: 0,
            child: InkWell(
              onTap: () => _pickFile(label),
              child: Container(
                width: 120,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.redAccent, Color(0xFFD42D3F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: file == null?Icon(Icons.add, color: Colors.white, size: 25):
                  Text('$label',style: TextStyle(color: Colors.white,),textAlign: TextAlign.center),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (_documents.values.any((file) => file == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please upload all documents")),
      );
      return;
    }
    // Proceed with the submission logic
   /* ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("All documents uploaded successfully!")),
    );*/
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
                children:<Widget> [
                  Text(
                    "Your loaan is passed for Loan Amount:200000 ",
                    style: TextStyle(fontFamily: "Poppins-Regular",fontSize: 16, color: Colors.black87),
                  ),
                  Text(
                    "Kindly allow 3-4 hrs to reflect  in your bank",
                    style: TextStyle(fontFamily: "Poppins-Regular",fontSize: 10, color: Colors.red),
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
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);

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
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (bool value) {
          _onWillPop();
        },
        child:Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      body:Column(children: [
        SizedBox(height: 42),
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
          height: MediaQuery.of(context).size.height-150,
          child:
        SingleChildScrollView(
          child: Column(
            children: [
              ..._documents.keys
                  .toList()
                  .asMap()
                  .entries
                  .map(
                    (entry) => entry.key % 2 == 0
                    ? Row(
                  children: [
                    Expanded(
                        child: _buildUploadCard(
                            entry.value, _documents[entry.value])),
                    if (entry.key + 1 < _documents.keys.length)
                      Expanded(
                        child: _buildUploadCard(
                          _documents.keys.elementAt(entry.key + 1),
                          _documents[
                          _documents.keys.elementAt(entry.key + 1)],
                        ),
                      ),
                  ],
                )
                    : SizedBox.shrink(),
              )
                  .toList(),
              GestureDetector(
                onTap: _submit,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),)

      ],),

    ));
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