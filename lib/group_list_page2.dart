import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/Models/SecondEsignModel.dart';
import 'package:flutter_sourcing_app/dealer_kycform.dart';
import 'package:flutter_sourcing_app/group_recycler_item.dart';

import 'package:provider/provider.dart';

import 'Models/branch_model.dart';
import 'group_recycler_item2.dart';
import 'kyc.dart';
import 'Models/group_model.dart';
import 'api_service.dart';
import 'borrower_list.dart';
import 'global_class.dart';

class GroupListPage2 extends StatefulWidget {
  final BranchDataModel BranchData;
  final List<SecondEsignDataModel> BorrowerList; // Add this line

  GroupListPage2({required this.BranchData, required this.BorrowerList});

  @override
  _GroupListPage2State createState() => _GroupListPage2State();
}

class _GroupListPage2State extends State<GroupListPage2> {
//  List<GroupDataModel> _items = [];
  List<SecondEsignDataModel> _items = [];
  String _searchText = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _items = widget.BorrowerList.where((item) {
      return item.branchCode == widget.BranchData.branchCode;
    }).toList();
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _items.where((item) {
      return item.groupCode.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      body: Column(
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
            padding:
                const EdgeInsets.only(bottom: 0, top: 0, left: 6, right: 6),
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              elevation: 20,
              child: TextField(
                decoration: InputDecoration(
                  alignLabelWithHint: true,
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
            child: _isLoading
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: 10,
                    itemBuilder: (context, index) =>
                        GlobalClass().ListShimmerItem(),
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          final selectedItem = filteredItems[index];
                          /*                  Navigator.push(
    context,
    MaterialPageRoute(
    //builder: (context) => ApplicationPage(),
    builder: (context) => BorrowerList(
  */ /*  BranchData: widget.Branchdata,
    GroupData: selectedItem,*/ /*
    page:"E SIGN"
    ),
    ),
    );*/
                        },
                        child: GroupRecyclerItem2(item: filteredItems[index]),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                    padding: EdgeInsets.symmetric(
                        vertical: 12.0), // Adjust button padding as needed
                  ),
                  child: Text(
                    'First Esign',
                    style: TextStyle(
                        fontFamily: "Poppins-Regular", color: Colors.red),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                    padding: EdgeInsets.symmetric(
                        vertical: 12.0), // Adjust button padding as needed
                  ),
                  child: Text(
                    'Second Esign',
                    style: TextStyle(
                        fontFamily: "Poppins-Regular", color: Colors.red),
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
