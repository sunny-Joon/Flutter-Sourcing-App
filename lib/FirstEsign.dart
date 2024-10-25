import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_sourcing_app/Models/BorrowerListModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'Models/GroupModel.dart';
import 'Models/branch_model.dart';

class FirstEsign extends StatefulWidget {

  final BranchDataModel BranchData;
  final GroupDataModel GroupData;
  final BorrowerListDataModel selectedData;

  const FirstEsign({
    super.key,
    required this.BranchData,
    required this.GroupData,
    required this.selectedData,
  });
  @override
  _FirstEsignState createState() => _FirstEsignState();
}

class _FirstEsignState extends State<FirstEsign> {
  String url = "https://morth.nic.in/sites/default/files/dd12-13_0.pdf";
  String? localPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    final file = await _downloadPdf();
    if (file != null) {
      setState(() {
        localPath = file.path;
        isLoading = false;
      });
    }
  }

  Future<File?> _downloadPdf() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File("${directory.path}/sample.pdf");
        await file.writeAsBytes(response.bodyBytes);
        return file;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Esign'),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : PDFView(
              filePath: localPath,
            ),
          ),
          Container(
            color: Colors.red,
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'E-Signing',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 4,
                  children: [
                    Text(
                      'Name:',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'John Doe',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Guardian:',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Jane Doe',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Mobile:',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      '+1234567890',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your E-Sign processing logic here
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.red, backgroundColor: Colors.white,
                    ),
                    child: Text('Esign'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
