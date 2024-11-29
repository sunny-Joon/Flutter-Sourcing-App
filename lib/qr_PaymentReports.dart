import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:convert'; // For jsonDecode
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'ApiService.dart';
import 'GlobalClass.dart';
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

      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(padding: EdgeInsets.all(8),
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

            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10), // Padding inside the Card
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align the column items to the left
                      children: [
                        Text(
                          'Smcode',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Text color for 'Smcode'
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width-65, // Control the width of the TextField
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search',
                              filled: true, // Set the background color of the TextField
                              fillColor: Colors.white, // Set the background color to white
                              contentPadding: EdgeInsets.all(10), // Padding inside the TextField
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8), // Rounded corners
                                borderSide: BorderSide.none, // No border outline
                              ),
                              suffixIcon: IconButton( // Place the search icon at the end (right side)
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  final smcode = _searchController.text;
                                  if (smcode.isNotEmpty) {
                                    // Print something or trigger your action here
                                    print('Search initiated with: $smcode');
                                    _qrPayments(smcode); // Call your API function here
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Please enter SMCODE')),
                                    );
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


            SizedBox(height: 16.0),
            Expanded(
              child: _qrPaymentsList.isEmpty
                  ? Center(child: Text('No data available'))
                  : SingleChildScrollView(
                child: Table(
                  border: TableBorder.all(color: Colors.black, width: 1),
                  columnWidths: {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(3),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(3),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                      ),
                      children: [
                        TableCell(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('S.No', style: TextStyle(fontWeight: FontWeight.bold)),
                        )),
                        TableCell(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Transaction ID', style: TextStyle(fontWeight: FontWeight.bold)),
                        )),
                        TableCell(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold)),
                        )),
                        TableCell(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
                        )),
                      ],
                    ),
                    for (int i = 0; i < _qrPaymentsList.length; i++)
                      TableRow(
                        children: [
                          TableCell(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${i + 1}',style: TextStyle(color: Colors.white,)),
                          )),
                          TableCell(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${_qrPaymentsList[i].txnId}',style: TextStyle(color: Colors.white,)),
                          )),
                          TableCell(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${_qrPaymentsList[i].amount}',style: TextStyle(color: Colors.white,)),
                          )),
                          TableCell(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${_qrPaymentsList[i].creationDate}',style: TextStyle(color: Colors.white,)),
                          )),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}