import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/Group_recycler_item.dart';
import 'package:flutter_sourcing_app/Models/GroupModel.dart';
import 'package:flutter_sourcing_app/Models/branch_model.dart';
import 'package:provider/provider.dart';

import 'ApiService.dart';
import 'ApplicationForms.dart';
import 'GlobalClass.dart';
import 'HouseVisitForm.dart';
import 'KYC.dart';
import 'borrower_list.dart';


class GroupListPage extends StatefulWidget {
  final BranchDataModel Branchdata;
  final String intentFrom; // Add this line

  GroupListPage({required this.Branchdata, required this.intentFrom});

  @override
  _GroupListPageState createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  List<GroupDataModel> _items = [];
  String _searchText = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGroupList();
  }

  Future<void> _fetchGroupList() async {
    final apiService = Provider.of<ApiService>(context, listen: false);

    try {
      final response = await apiService.getGroupList(
        GlobalClass.token,
        GlobalClass.dbName,
        GlobalClass.creator,
        widget.Branchdata.branchCode
      );
      if (response.statuscode == 200) {
        setState(() {
          _items = response.data; // Store the response data
          _isLoading = false;
        });
        print('Group List retrieved successfully');
      } else {
        print('Failed to retrieve Group list');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _items.where((item) {
      return item.groupCode.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.red,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10,top: 50,left: 10,right: 10),
            child: Card(
              elevation: 8,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (text) {
                  setState(() {
                    _searchText = text;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    final selectedItem = filteredItems[index];
                    switch (widget.intentFrom) {
                      case 'KYC':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KYCPage(data: widget.Branchdata),
                          ),
                        );
                        break;
                      case 'APPLICATION FORM':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            //builder: (context) => ApplicationPage(),
                            builder: (context) => BorrowerList(
                              BranchData: widget.Branchdata,
                              GroupData: selectedItem,
                              page:"APPLICATION FORM"
                            ),
                          ),
                        );
                        break;
                      case 'House Visit':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HouseVisitForm(),
                            /*builder: (context) => BorrowerList(
                              data: "widget.data",
                              areaCd: selectedItem.groupCode,
                              foCode: selectedItem.groupCodeName,
                            ),*/
                          ),
                        );
                        break;
                      case 'Visit Report':
                        break;
                      case 'E SIGN':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            //builder: (context) => ApplicationPage(),
                            builder: (context) => BorrowerList(
                                BranchData: widget.Branchdata,
                                GroupData: selectedItem,
                                page:"E SIGN"
                            ),
                          ),
                        );
                        //_showEsignPopup(context);
                        break;
                    }
                  },
                  child: GroupRecyclerItem(item: filteredItems[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEsignPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Add your navigation or functionality for the first Esign here
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.0), // Adjust button padding as needed
                  ),
                  child: Text(
                    'First Esign',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Add your navigation or functionality for the second Esign here
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.0), // Adjust button padding as needed
                  ),
                  child: Text(
                    'Second Esign',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
