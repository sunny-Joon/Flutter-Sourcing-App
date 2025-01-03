import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'global_class.dart';

class SubmitSsQrTransaction extends StatefulWidget {

  final String smcode;

  const SubmitSsQrTransaction({super.key,
    required this.smcode,});



  @override
  _SubmitSsQrTransactionState createState() => _SubmitSsQrTransactionState();
}

class _SubmitSsQrTransactionState extends State<SubmitSsQrTransaction> {
  final TextEditingController _searchController = TextEditingController();
  final picker = ImagePicker();
  File? _image;

  @override
  Widget build(BuildContext context) {
    double imageViewWidth = MediaQuery.of(context).size.width - 100;

    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      body: Container(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            SizedBox(height: 50),
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
                        border: Border.all(width: 1, color: Colors.grey.shade300),
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
                      Navigator.of(context).pop();
                    },
                  ),
                  Center(
                    child: Image.asset(
                      'assets/Images/logo_white.png', // Replace with your logo asset path
                      height: 40,
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
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5), // Padding inside the Card
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Align the column items to the left
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 40, // Control the width of the TextField
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Case code',
                                    filled: true, // Set the background color of the TextField
                                    fillColor: Colors.white, // Set the background color to white
                                    contentPadding: EdgeInsets.all(10), // Padding inside the TextField
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(3), // Rounded corners
                                      borderSide: BorderSide.none, // No border outline
                                    ),
                                    suffixIcon: IconButton( // Place the search icon at the end (right side)
                                      icon: Icon(Icons.search),
                                      onPressed: () {
                                        RegExp regex = RegExp(r'^[A-Za-z]{4}\d{6}$');
                                        if (_searchController.text.isNotEmpty && regex.hasMatch(_searchController.text)) {
                                          // _qrPayments(_searchController.text); // Call your API function here
                                        } else {
                                          GlobalClass.showErrorAlert(context, "Please Enter Correct Case code", 1);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    'Borrower Name',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _showImageSourceDialog(context),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Makes the corners square
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(Icons.camera_alt),
                        SizedBox(width: 8), // Optional: Adds space between the icon and text
                        Text('Click Image of transaction'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: imageViewWidth,
                    height: imageViewWidth * 0.75, // Adjust height based on aspect ratio
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: _image == null
                        ? Icon(
                      Icons.image,
                      size: imageViewWidth * 0.5,
                      color: Colors.grey,
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Make the button background transparent
                      shadowColor: Colors.transparent, // Remove the default shadow
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                      ),
                    ),
                    onPressed: () {
                      // Handle submit button press
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.grey.shade200, // Start with white
                            Colors.grey.shade400, // Light grey end color
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8), // Rounded corners for the gradient
                      ),
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: 48, // Minimum height for the button
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            fontFamily: "Poppins-Regular",
                            fontSize: 16,
                            color: Colors.black, // Text color
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
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an option'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: Text('Take a photo'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _getImage(ImageSource.camera);
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text('Select from gallery'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _getImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
}
