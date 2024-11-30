import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/Group_List_Page.dart';
import 'package:flutter_sourcing_app/MasterAPIs/live_track_repository.dart';
import 'package:provider/provider.dart';
import 'ApiService.dart';
import 'GlobalClass.dart';
import 'KYC.dart';
import 'Models/branch_model.dart';
import 'Branch_recycler_item.dart';
import 'borrower_list.dart';

class BranchListPage extends StatefulWidget {
  final String intentFrom;

  BranchListPage({required this.intentFrom});

  @override
  _BranchListPageState createState() => _BranchListPageState();
}

class _BranchListPageState extends State<BranchListPage> {
  List<BranchDataModel> _items = [];
  String _searchText = '';


  @override
  void initState() {
    super.initState();
    _fetchBranchList();
  }

  Future<void> _fetchBranchList() async {
    EasyLoading.show(status: 'Loading...',);

    final apiService = Provider.of<ApiService>(context, listen: false);

      await apiService.getBranchList(GlobalClass.dbName, GlobalClass.creator).then((response){
        if (response.statuscode == 200) {
          setState(() {
            _items = response.data; // Store the response data

          });
          EasyLoading.dismiss();

          print('Branch List retrieved successfully');
        } else {
          EasyLoading.dismiss();

          print('Failed to retrieve branch list');
          setState(() {

          });
        }
      }).catchError((err){
        EasyLoading.dismiss();
      });
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _items.where((item) {
      return item.branchCode.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();

    return Scaffold(

      backgroundColor: Color(0xFFD42D3F),
      body: Column(
        children: [
          SizedBox(height: 50),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 0,top: 0,left: 10,right: 10),
            child: Card(
              color: Colors.white,
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
              padding: EdgeInsets.zero,
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    final selectedItem = filteredItems[index];

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupListPage(
                            Branchdata: selectedItem,
                            intentFrom:widget.intentFrom),
                      ),
                    );
                  },
                  child: BranchRecyclerItem(item: filteredItems[index]),
                );
              },
            ),
          ),
        ],
      )
    );
  }

}
