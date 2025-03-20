import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/Models/SecondEsignModel.dart';
import 'package:flutter_sourcing_app/Models/group_model.dart';
import 'package:provider/provider.dart';
import '../../Models/branch_model.dart';
import '../../api_service.dart';
import 'branch_recycler_item.dart';
import 'group_list_page.dart';
import 'group_list_page2.dart';
import '../global_class.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class BranchListPage extends StatefulWidget {
  final String intentFrom;

  BranchListPage({required this.intentFrom});

  @override
  _BranchListPageState createState() => _BranchListPageState();
}

class _BranchListPageState extends State<BranchListPage> {
  List<BranchDataModel> _items = [];
  String _searchText = '';
  bool _isLoading = true;
  List<SecondEsignDataModel> borrowerList2 = [];

  @override
  void initState() {
    super.initState();
    _fetchBranchList();
    print('Sunny');
  }

  Future<void> _fetchBranchList() async {
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
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.intentFrom == "COLLECTION" ? SizedBox() : InkWell(
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
                    if(widget.intentFrom == 'E SIGN') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupListPage(
                              Branchdata: selectedItem,
                              intentFrom: widget.intentFrom),
                        ),
                      );

                     // _showPopup(context, selectedItem);
                     } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupListPage(
                              Branchdata: selectedItem,
                              intentFrom: widget.intentFrom),
                        ),
                      );
                     }
                  },
                  child: BranchRecyclerItem(item: filteredItems[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


 /* void _showPopup(BuildContext context, BranchDataModel selectedItem) {
    showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog( shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
          content: Padding( padding: const EdgeInsets.symmetric(vertical:16,horizontal: 12),
            // Add padding around the content
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Adhaar Front Button
                SizedBox(
                  height: 50,
                  width: double.infinity, // Match the width of the dialog
                  child: TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupListPage(
                              Branchdata: selectedItem,
                              intentFrom: 'E SIGN1'),
                        ),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.fesign,
                      style: TextStyle(fontFamily: "Poppins-Regular",color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFFD42D3F),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(5), // Adjust as needed
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20), // Space between buttons
                // Adhaar Back Button
                SizedBox(
                  height: 50,

                  width: double.infinity, // Match the width of the dialog
                  child: TextButton(
                    // onPressed: () async {
                    //   Navigator.of(context).pop();
                    //
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => GroupListPage(
                    //           Branchdata: selectedItem,
                    //           intentFrom: 'E SIGN1'),
                    //     ),
                    //   );
                    // },
                    onPressed: () {
                      Navigator.of(context).pop();
                      SecondEsignList(selectedItem,widget.intentFrom);
                      *//*Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FirstEsign(
                            BranchData: widget.BranchData,
                            GroupData: widget.GroupData,
                            selectedData: item,
                            type: 2,
                          ),
                        ),
                      );*//*
                    },
                    child: Text(
                       AppLocalizations.of(context)!.sesign,
                      style: TextStyle(fontFamily: "Poppins-Regular",color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFFD42D3F),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(5), // Adjust as needed
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }
*/
  /*Future<void> SecondEsignList(BranchDataModel selectedItem, String intentFrom) async {
    //EasyLoading.show(status: 'Loading...',);

    GroupDataModel groupDataModel;
    final apiService = Provider.of<ApiService>(context, listen: false);

    await apiService.BorrowerList2(
        GlobalClass.token,
        GlobalClass.dbName,
        GlobalClass.creatorId,
        selectedItem.branchCode,
       // groupDataModel.groupCode,
        GlobalClass.imei

    ).then((response) {
      if (response.statuscode == 200 && response.data[0].errormsg.isEmpty) {
        borrowerList2 = response.data;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupListPage2(
                BorrowerList: borrowerList2,
                BranchData: selectedItem),
          ),
        );

      }else{
        GlobalClass.showUnsuccessfulAlert(context,response.message, 1);
      }
    }).catchError((error) {
      _isLoading = false;
      GlobalClass.showErrorAlert(context, error.toString(),1);
    });
  }
*/

}
