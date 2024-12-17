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

                  SizedBox(height: 16.0),

                  // Responsive Table
                  Expanded(
                    child: _qrPaymentsList.isEmpty
                        ? Center(child: Text('No data available'))
                        : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: screenWidth,
                        child: SingleChildScrollView(
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
                                decoration: BoxDecoration(color: Colors.grey.shade300),
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'S.No',
                                        style: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Transaction ID',
                                        style: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Amount',
                                        style: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all( 8.0),
                                      child: Text(
                                        'Date',
                                        style: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          fontWeight: FontWeight.bold,

                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
