import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/Models/branch_model.dart';
import '../../Models/SecondEsignModel.dart';
import '../../Models/borrower_list_model.dart';
import '../../Models/group_model.dart';
import '../global_class.dart';
import 'brrower_list_item.dart';
import 'first_esign.dart';

class BorrowerList2 extends StatefulWidget {
  final BranchDataModel BranchData;
  final List<SecondEsignDataModel> BorrowerList;
  final GroupDataModel GroupData;

  BorrowerList2({
    required this.BorrowerList,
    required this.BranchData,
    required this.GroupData,
  });

  @override
  _BorrowerList2State createState() => _BorrowerList2State();
}

class _BorrowerList2State extends State<BorrowerList2> {
  String noDataFoundMsg = "";
  bool _isLoading = true;
  List<SecondEsignDataModel> filteredBorrowerList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = false;
      filteredBorrowerList = widget.BorrowerList;
    });

    searchController.addListener(() {
      filterList();
    });
  }

  // Function to filter the BorrowerList based on search query
  void filterList() {
    String query = searchController.text.toLowerCase();

    setState(() {
      filteredBorrowerList = widget.BorrowerList.where((borrower) {
        return borrower.fName.toLowerCase().contains(query) ||
            borrower.mName.toLowerCase().contains(query) ||
            borrower.lName.toLowerCase().contains(query) ||
            borrower.fiCode.toString().contains(query); // Example of filtering by fiCode
      }).toList();
    });
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
              controller: searchController,
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
                : (filteredBorrowerList.isEmpty
                ? Center(
              child: Text(
                "No borrowers found.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: filteredBorrowerList.length,
              itemBuilder: (context, index) {
                final item = filteredBorrowerList[index];
                return BorrowerListItem(
                  name:
                  "${item.fName} ${item.mName} ${item.lName}",
                  fiCode: item.fiCode.toString(),
                  creator: item.creator,
                  pic: item.profilePic,
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FirstEsign(
                          BranchData: widget.BranchData,
                          GroupData: widget.GroupData,
                          selectedData: BorrowerListDataModel(
                            id: item.id,
                            fiCode: int.parse(item.fiCode),
                            creator: item.creator,
                            dob: item.dob,
                            gender: item.gender,
                            aadharNo: item.aadharNo,
                            title: "",
                            fullName:
                            "${item.fName} ${item.mName} ${item.lName}",
                            cast: "",
                            pAddress: "",
                            pPhone: item.pPhone,
                            currentAddress: "",
                            groupCode: item.groupCode,
                            branchCode: item.branchCode,
                            borrSignStatus: item.borrSignStatus,
                            errormsg: item.errormsg,
                            isvalid: item.isvalid,
                            eSignDoc: "",
                            profilePic: item.profilePic,
                            homeVisit: "",
                          ),
                          type: 2,
                        ),
                      ),
                    );
                  },
                );
              },
            )),
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
                      fontSize: 16,
                    ),
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
