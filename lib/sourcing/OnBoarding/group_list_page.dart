import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import '../../Models/SecondEsignModel.dart';
import '../../Models/branch_model.dart';
import '../../Models/group_model.dart';
import '../../api_service.dart';
import '../global_class.dart';
import 'borrower_list.dart';
import 'borrower_list.dart';
import 'borrower_list.dart';
import 'borrower_list.dart';
import 'borrower_list2.dart';
import 'first_esign.dart';
import 'group_list_page2.dart';
import 'group_recycler_item.dart';
import 'kyc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
  List<SecondEsignDataModel> borrowerList2 = [];

  @override
  void initState() {
    super.initState();
    _fetchGroupList();
  }

  Future<void> _fetchGroupList() async {
  //  EasyLoading.show(status: 'Loading...',);

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
       //   EasyLoading.dismiss();
        });
      }else {
        GlobalClass.showUnsuccessfulAlert(context, "Not able to fetch Group List", 2);

        setState(() {
          _isLoading = false;
      //    EasyLoading.dismiss();
        });
      }
    } catch (e) {
      print('Error: $e');
      GlobalClass.showErrorAlert(context,"Server Side Error",2);
      setState(() {
        _isLoading = false;
    //    EasyLoading.dismiss();
      });
    }
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
                      case 'KYC':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KYCPage(
                                GroupData: selectedItem,
                                data: widget.Branchdata),
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
                            //  builder: (context) => HouseVisitForm(),
                            builder: (context) => BorrowerList(
                                BranchData: widget.Branchdata,
                                GroupData: selectedItem,
                                page:"HouseVisit"
                            ),
                          ),
                        );
                        break;
                      case 'COLLECTION':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BorrowerList(
                                BranchData: widget.Branchdata,
                                GroupData: selectedItem,
                                page:"COLLECTION"
                            ),
                          ),
                        );
                        break;
                      case 'Visit Report':
                        break;
                      case 'E SIGN':
                       /* Navigator.push(
                          context,
                          MaterialPageRoute(
                            //builder: (context) => ApplicationPage(),
                            builder: (context) => BorrowerList(
                                BranchData: widget.Branchdata,
                                GroupData: selectedItem,
                                page:"E SIGN"
                            ),
                          ),
                        );*/
                        _showEsignPopup(context,selectedItem);
                        break;
                      case 'Dealer':
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                            //builder: (context) => ApplicationPage(),
                            builder: (context) => DealerKYCPage(
                                // BranchData: widget.Branchdata,
                                // GroupData: selectedItem
                            ),
                          ),
                        );*/
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

  void _showEsignPopup(BuildContext context,GroupDataModel selectedItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:  Color(0xFFD42D3F),
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
                    AppLocalizations.of(context)!.fesign,
                    style: TextStyle(fontFamily: "Poppins-Regular",color: Colors.red),
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
                    SecondEsignList(selectedItem,widget.intentFrom);
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
                    AppLocalizations.of(context)!.sesign,
                    style: TextStyle(fontFamily: "Poppins-Regular",color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> SecondEsignList(GroupDataModel selectedItem, String intentFrom) async {
    //EasyLoading.show(status: 'Loading...',);

    final apiService = Provider.of<ApiService>(context, listen: false);

    await apiService.BorrowerList2(
        GlobalClass.token,
        GlobalClass.dbName,
        GlobalClass.creatorId,
        widget.Branchdata.branchCode,
       selectedItem.groupCode,
      GlobalClass.imei
    ).then((response) {
      if (response.statuscode == 200 && response.data[0].errormsg.isEmpty) {
        borrowerList2 = response.data;
        GlobalClass.smcode=borrowerList2[0].smcode;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BorrowerList2(
              BranchData: widget.Branchdata,
              GroupData: selectedItem,
              BorrowerList: borrowerList2, // Ensure this is passed correctly
             // page: "E SIGN",
            ),
          ),
        );

        /*   Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FirstEsign(
              BranchData: widget.BranchData,
              GroupData: widget.GroupData,
              selectedData: item,
              type: 1,
            ),
          ),
        );*/

      }else{
        GlobalClass.showUnsuccessfulAlert(context,response.data[0].errormsg, 1);
      }
    }).catchError((error) {
      _isLoading = false;
      GlobalClass.showErrorAlert(context, "borrower list not found",1);
    });
  }

}
