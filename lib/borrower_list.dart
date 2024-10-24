import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ApiService.dart';
import 'BorrowerListItem.dart';
import 'GlobalClass.dart';
import 'ApplicationForms.dart';
import 'Models/BorrowerListModel.dart'; // Import your ApplicationForm

class BorrowerList extends StatefulWidget {
  final String data;
  final String areaCd;
  final String foCode;

  BorrowerList({
    required this.data,
    required this.areaCd,
    required this.foCode,
  });

  @override
  _BorrowerListState createState() => _BorrowerListState();
}

class _BorrowerListState extends State<BorrowerList> {
  List<BorrowerListDataModel> _borrowerItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBorrowerList();
  }

  Future<void> _fetchBorrowerList() async {
    /*final apiService = Provider.of<ApiService>(context, listen: false);

    try {
      final response = await apiService.BorrowerList(
        GlobalClass.token,
        GlobalClass.dbName,
        GlobalClass.imei,
        widget.foCode,
        widget.areaCd,
        GlobalClass.creator,
      );

      if (response.statusCode == 200) {
        setState(() {
          _borrowerItems = response.data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Borrower List'),
        backgroundColor: Color(0xFFD42D3F),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _borrowerItems.length,
              itemBuilder: (context, index) {
                final item = _borrowerItems[index];
                return BorrowerListItem(
                  name: item.fname,
                  fatherOrSpouse: item.fFname,
                  fiCode: item.code,
                  mobile: item.pPh3,
                  creator: item.creator,
                  address: item.addr,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApplicationPage(
                      //    borrower: item, // Pass the item object
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
