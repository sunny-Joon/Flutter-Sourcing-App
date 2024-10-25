import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/Models/GroupModel.dart';
import 'package:flutter_sourcing_app/Models/branch_model.dart';
import 'package:provider/provider.dart';
import 'ApiService.dart';
import 'BorrowerListItem.dart';
import 'FirstEsign.dart';
import 'GlobalClass.dart';
import 'ApplicationForms.dart';
import 'Models/BorrowerListModel.dart';

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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBorrowerList();
  }

  Future<void> _fetchBorrowerList() async {
    final apiService = Provider.of<ApiService>(context, listen: false);

    await apiService.BorrowerList(
      GlobalClass.token,
      GlobalClass.dbName,
      "groupCode",
      "branchCode",
    ).then((response) {
      if (response.statuscode == 200) {
        setState(() {
          _borrowerItems = response.data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Card(
            margin: EdgeInsets.only(bottom: 10, top: 50, left: 10, right: 10),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _borrowerItems.length,
              itemBuilder: (context, index) {
                final item = _borrowerItems[index];
                return BorrowerListItem(
                  name: item.fullName,
                  fiCode: item.id.toString(),
                  mobile: item.pPhone,
                  creator: item.creator,
                  address: item.currentAddress,
                  onTap: () {
                    switch (widget.page) {
                      case 'APPLICATION FORM':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ApplicationPage(
                              BranchData: widget.BranchData,
                              GroupData: widget.GroupData,
                            ),
                          ),
                        );
                        break;
                      case 'E SIGN':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FirstEsign(
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
          ),
        ],
      ),
    );
  }
}
