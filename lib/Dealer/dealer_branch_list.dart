import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/Models/SecondEsignModel.dart';
import 'package:flutter_sourcing_app/Dealer/dealer_group_list_page.dart';
import '../Models/branch_model.dart';
import '../sourcing/global_class.dart';
import 'dealer_branch_list_item.dart';


class DealerBranchListPage extends StatefulWidget {
  final String intentFrom;

  DealerBranchListPage({required this.intentFrom});

  @override
  _DealerBranchListPageState createState() => _DealerBranchListPageState();
}

class _DealerBranchListPageState extends State<DealerBranchListPage> {
  List<BranchDataModel> _items = [];

  String _searchText = '';
  bool _isLoading = true;
  List<SecondEsignDataModel> borrowerList2 = [];

  @override
  void initState() {
    super.initState();
    _items.add(BranchDataModel(branchCode: "001",branchName: "Delhi"));
    _items.add(BranchDataModel(branchCode: "002",branchName: "AGRA"));
    _isLoading = false;
   // _fetchBranchList();
  }

 /* Future<void> _fetchBranchList() async {
    //   EasyLoading.show(status: 'Loading...');

    final apiService = Provider.of<ApiService>(context, listen: false);
    try {
      await apiService.getBranchList(GlobalClass.token, GlobalClass.dbName, GlobalClass.creatorId).then((response) {
        if (response.statuscode == 200) {
          setState(() {
            _items = response.data; // Store the response data
            _isLoading = false;
          });
          //      EasyLoading.dismiss();

          print('Branch List retrieved successfully');
        } else if(response.statuscode == 201) {
          GlobalClass.showUnsuccessfulAlert(
              context, "Group List Not Found", 1);
          setState(() {
            _isLoading = false;
            //          EasyLoading.dismiss();
          });
        }else {
          GlobalClass.showUnsuccessfulAlert(
              context, "Not able to fetch Group List", 1);
          setState(() {
            _isLoading = false;
            //          EasyLoading.dismiss();
          });
        }
      });
    } catch (e) {
      print('Error: $e');
      GlobalClass.showErrorAlert(context, "Server Side Error", 2);
      setState(() {
        _isLoading = false;
        //       EasyLoading.dismiss();
      });
    }
  }*/

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
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              color: Colors.white,
              elevation: 8,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Branch in ' + GlobalClass.creator,
                  prefixIcon: Icon(Icons.search, size: 20), // Ensure the icon size matches the font size
                  contentPadding: EdgeInsets.symmetric(vertical: 12), // Aligns text vertically
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 16), // Match the text size to the icon size
                onChanged: (text) {
                  setState(() {
                    _searchText = text; // Update the search text
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
              itemBuilder: (context, index) => GlobalClass().ListShimmerItem(),
            )
                : ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    final selectedItem = filteredItems[index];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DealerGroupListPage(
                              Branchdata: selectedItem,
                              intentFrom: widget.intentFrom),
                        ),
                      );
                  },
                  child: DealerBranchListItem(item: filteredItems[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
