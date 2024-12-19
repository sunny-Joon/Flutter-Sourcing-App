import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:convert'; // For jsonDecode
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'api_service.dart';
import 'global_class.dart';
import 'Models/qr_payments_model.dart'; // For making API calls

class QrPaymentReports extends StatefulWidget {
  @override
  _QrPaymentReportsState createState() => _QrPaymentReportsState();
}

class _QrPaymentReportsState extends State<QrPaymentReports> {
  final TextEditingController _searchController = TextEditingController();
  List<QrPaymentsDataModel> _qrPaymentsList = [];

  Future<void> _qrPayments(String smcode) async {
    EasyLoading.show(status: 'Loading...',);

    final apiService = Provider.of<ApiService>(context, listen: false);

    try {
      final response = await apiService.qrPayments(
          GlobalClass.token,
          GlobalClass.dbName,
          smcode,
          GlobalClass.id,
          "mobile");
      if (response.statuscode == 200) {
        EasyLoading.dismiss();
        setState(() {
          _qrPaymentsList =  response.data;
        });
      } else {
        EasyLoading.dismiss();
        // Handle API error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch data')));
      }
    } catch (e) {
      print('Error: $e');
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 16.0),
              child: Column(

                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 1, color: Colors.grey.shade300),
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            height: 40,
                            width: 40,
                            alignment: Alignment.center,
                            child: Icon(Icons.arrow_back_ios_sharp, size: 16),
                          ),
                        ),
                        Center(
                          child: Image.asset(
                            'assets/Images/logo_white.png',
                            height: 40,
                          ),
                        ),
                        SizedBox(width: 40), // Placeholder for balance
                      ],
                    ),
                  ),

                  // Search Card with Responsive Width
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Smcode',
                                  style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Case Code (SM CODE)',
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.search),
                                      onPressed: () {
                                        final smcode = _searchController.text;
                                        if (smcode.isNotEmpty) {
                                          print('Search initiated with: $smcode');
                                          _qrPayments(smcode);
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Please enter SMCODE')),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),


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

                          width: MediaQuery.of(context).size.width-30, // Control the width of the TextField
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
                                 if(_searchController.text.isNotEmpty && regex.hasMatch(_searchController.text)) {
                                     _qrPayments(_searchController.text); // Call your API function here
                                  } else {
                                   GlobalClass.showErrorAlert(context, "Please Enter Correct Case code",1);
                                  }
                                },
                              ),
                              for (int i = 0; i < _qrPaymentsList.length; i++)
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '${i + 1}',
                                          style: TextStyle(
                                            fontFamily: "Poppins-Regular",
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '${_qrPaymentsList[i].txnId}',
                                          style: TextStyle(
                                            fontFamily: "Poppins-Regular",
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '${_qrPaymentsList[i].amount}',
                                          style: TextStyle(
                                            fontFamily: "Poppins-Regular",
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          _formatDate(_qrPaymentsList[i].creationDate),
                                          style: TextStyle(
                                            fontFamily: "Poppins-Regular",
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
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
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }



}
