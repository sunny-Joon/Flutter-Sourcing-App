import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/Models/branch_model.dart';
import 'package:provider/provider.dart';
import '../Collection/collection.dart';
import '../../Models/borrower_list_model.dart';
import '../../Models/group_model.dart';
import '../../api_service.dart';
import '../global_class.dart';
import 'application_forms.dart';
import 'brrower_list_item.dart';
import 'first_esign.dart';
import 'house_visit_form.dart';

class BorrowerList extends StatefulWidget {
  final BranchDataModel BranchData;
  final GroupDataModel GroupData;
  final String page;

  BorrowerList({
    required this.BranchData,
    required this.GroupData,
    required this.page,
  });

  @override
  _BorrowerListState createState() => _BorrowerListState();
}

class _BorrowerListState extends State<BorrowerList> {
  List<BorrowerListDataModel> _borrowerItems = [];
  List<BorrowerListDataModel> _filteredItems = [];
  String noDataFoundMsg = "";
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.page == "E SIGN") {
      _fetchBorrowerList(1);
    } else {
      _fetchBorrowerList(0);
    }
    _searchController.addListener(_filterList);
  }

  Future<void> _fetchBorrowerList(int type) async {
    final apiService = Provider.of<ApiService>(context, listen: false);

    await apiService.BorrowerList(
      GlobalClass.token,
      GlobalClass.dbName,
      widget.GroupData.groupCode,
      widget.BranchData.branchCode,
      GlobalClass.creatorId.toString(),
      type,
    ).then((response) {
      if (response.statuscode == 200 && response.data[0].errormsg.isEmpty) {
        setState(() {
          if (widget.page == "APPLICATION FORM") {}

          if (widget.page == "HouseVisit") {
            _borrowerItems =
                response.data.where((item) => item.homeVisit == "No").toList();
            if (_borrowerItems.length < 1) {
              noDataFoundMsg = "No record found for House Visit!";
            }
          } else {
            _borrowerItems = response.data;
          }
          _filteredItems = _borrowerItems;
        });
        _isLoading = false;
      } else {
        setState(() {
          noDataFoundMsg = response.data[0].errormsg;
        });
        _isLoading = false;
      }
    }).catchError((error) {
      _isLoading = false;
      GlobalClass.showErrorAlert(context, error.toString(), 1);
    });
  }

  void _filterList() {
    setState(() {
      _filteredItems = _borrowerItems.where((item) {
        return item.fullName.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            item.fiCode.toString().toLowerCase().contains(_searchController.text.toLowerCase());
      }).toList();
    });
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          Card(
            margin: EdgeInsets.only(bottom: 0, top: 0, left: 10, right: 10),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _searchController,
              style: TextStyle(fontFamily: "Poppins-Regular"),
              decoration: InputDecoration(
                hintText: 'Search...',
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
              ),
            ),
          ),
          noDataFoundMsg.isEmpty
              ? Expanded(
            child: _isLoading
                ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: 10,
              itemBuilder: (context, index) =>
                  GlobalClass().ListShimmerItem(),
            )
                : ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return BorrowerListItem(
                  name: item.fullName,
                  fiCode: item.fiCode.toString(),
                  creator: item.creator,
                  pic: item.profilePic,
                  onTap: () {
                    switch (widget.page) {
                      case 'APPLICATION FORM':
                        if (item.homeVisit == "No") {
                          GlobalClass.showUnsuccessfulAlert(
                              context,
                              "Please fill House Visit form for this case",
                              1);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ApplicationPage(
                                BranchData: widget.BranchData,
                                GroupData: widget.GroupData,
                                selectedData: item,
                              ),
                            ),
                          );
                        }
                        break;
                      case 'E SIGN':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FirstEsign(
                              BranchData: widget.BranchData,
                              GroupData: widget.GroupData,
                              selectedData: item,
                              type: 1,
                            ),
                          ),
                        );
                        break;
                      case 'HouseVisit':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HouseVisitForm(
                              BranchData: widget.BranchData,
                              GroupData: widget.GroupData,
                              selectedData: item,
                            ),
                          ),
                        );
                        break;
                    }
                  },
                );
              },
            ),
          )
              : Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/Images/no_data.png', // Replace with your logo asset path
                    height: 70,
                  ),
                ),
                Center(
                  child: Text(
                    noDataFoundMsg,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
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
