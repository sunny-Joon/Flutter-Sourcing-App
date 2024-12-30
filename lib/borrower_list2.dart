import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
 import 'package:flutter_sourcing_app/Models/branch_model.dart';
import 'package:provider/provider.dart';
 import 'Models/SecondEsignModel.dart';
import 'collection.dart';
import 'Models/borrower_list_model.dart';
import 'Models/group_model.dart';
import 'api_service.dart';
import 'application_forms.dart';
import 'brrower_list_item.dart';
import 'first_esign.dart';
import 'global_class.dart';
import 'house_visit_form.dart';


class BorrowerList2 extends StatefulWidget {
  final BranchDataModel BranchData;
  final SecondEsignDataModel BorrowerList;
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
  List<BorrowerListDataModel> _borrowerItems = [];
  String noDataFoundMsg="";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
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
          Card(
            margin: EdgeInsets.only(bottom: 0, top: 0, left: 10, right: 10),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              style: TextStyle(
                  fontFamily: "Poppins-Regular"
              ),
              decoration: InputDecoration(

                hintText: 'Search...',
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
              ),
            ),
          ),
          noDataFoundMsg.isEmpty?
          Expanded(
            child: _isLoading
                ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: 10,
              itemBuilder: (context, index) => GlobalClass().ListShimmerItem(),
            )
                :ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: _borrowerItems.length,
              itemBuilder: (context, index) {
                final item = _borrowerItems[index];
                return BorrowerListItem(
                  name: item.fullName,
                  fiCode: item.fiCode.toString(),
                  //mobile: item.pPhone,
                  creator: item.creator,
                 // address: item.currentAddress,
                  pic:item.profilePic,
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FirstEsign(
                          BranchData: widget.BranchData,
                          GroupData: widget.GroupData,
                          selectedData: item,
                          type: 2,
                        ),
                      ),
                    );                  },
                );
              },
            ),
          ):Container(height: MediaQuery.of(context).size.height/2,child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/Images/no_data.png', // Replace with your logo asset path
                  height: 70,
                ),
              ),
              Center(child: Text(noDataFoundMsg ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 16),),)
            ],
          ),),
        ],
      ),
    );
  }
}
