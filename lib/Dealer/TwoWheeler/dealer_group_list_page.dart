import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/Dealer/HomePage/dealer_group_list_item.dart';
import '../../Models/branch_model.dart';
import '../../Models/group_model.dart';
import '../../sourcing/global_class.dart';
import 'dealer_borrower_list.dart';


class DealerGroupListPage extends StatefulWidget {
  final BranchDataModel Branchdata;
  final String intentFrom; // Add this line

  DealerGroupListPage({required this.Branchdata, required this.intentFrom});

  @override
  _DealerGroupListPageState createState() => _DealerGroupListPageState();
}

class _DealerGroupListPageState extends State<DealerGroupListPage> {

  List<GroupDataModel> _items = [];
  String _searchText = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
   // _fetchGroupList();
    _isLoading = false;
    _items.add(GroupDataModel(groupCode: "0001", groupCodeName: "New Delhi", centerName: '', latitude: "0.0", longitude: "0.0"));
    _items.add(GroupDataModel(groupCode: "0002", groupCodeName: "West Delhi", centerName: '', latitude: "0.0", longitude:"0.0"));

  }

  /*Future<void> _fetchGroupList() async {
    //EasyLoading.show(status: 'Loading...',);

    final apiService = Provider.of<ApiService>(context, listen: false);

    try {
      final response = await apiService.getGroupList(
          GlobalClass.token,
          GlobalClass.dbName,
          GlobalClass.creatorId,
          // GlobalClass.creator,
          widget.Branchdata.branchCode
      );
      if (response.statuscode == 200) {
        setState(() {
          _items = response.data; // Store the response data
          _isLoading = false;
        //  EasyLoading.dismiss();

        });
        print('Group List retrieved successfully');
      } else if(response.statuscode == 201) {
        GlobalClass.showUnsuccessfulAlert(context, "Group List not found", 2);

        setState(() {
          _isLoading = false;
          EasyLoading.dismiss();
        });
      }else {
        GlobalClass.showUnsuccessfulAlert(context, "Not able to fetch Group List", 2);

        setState(() {
          _isLoading = false;
          EasyLoading.dismiss();
        });
      }
    } catch (e) {
      print('Error: $e');
      GlobalClass.showErrorAlert(context,"Server Side Error",2);
      setState(() {
        _isLoading = false;
        EasyLoading.dismiss();
      });
    }
  }
*/
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
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              color: Colors.white,
              elevation: 8,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Group in ' + GlobalClass.creator,
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
                    switch (widget.intentFrom) {
                      case 'PendingCases':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DealerBorrowerList(
                                BranchData: widget.Branchdata,
                                GroupData: selectedItem,
                                page:"PendingCases"
                            ),
                          ),
                        );
                        break;
                      case 'SanctionedCases':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DealerBorrowerList(
                                BranchData: widget.Branchdata,
                                GroupData: selectedItem,
                                page:"SanctionedCases"
                            ),
                          ),
                        );
                        break;
                      case 'Disbursedcases':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DealerBorrowerList(
                                BranchData: widget.Branchdata,
                                GroupData: selectedItem,
                                page:"Disbursedcases"
                            ),
                          ),
                        );
                        break;
                    }
                  },
                  child: DealerGroupListItem(item: filteredItems[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
