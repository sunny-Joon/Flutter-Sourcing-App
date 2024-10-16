import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/Group_List_Page.dart';
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBranchList();
  }

  Future<void> _fetchBranchList() async {
    final apiService = Provider.of<ApiService>(context, listen: false);

    try {
      final response = await apiService.getBranchList(
        GlobalClass.dbName,
        GlobalClass.creator
      );
      if (response.statuscode == 200) {
        setState(() {
          _items = response.data; // Store the response data
          _isLoading = false;
        });
        print('Branch List retrieved successfully');
      } else {
        print('Failed to retrieve branch list');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _items.where((item) {
      return item.branchCode.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Branch List'),
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.red,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
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
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    final selectedItem = filteredItems[index];

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GroupListPage(
                                data: selectedItem,
                                intentFrom:widget.intentFrom),
                          ),
                        );
                  },
                  child: branchRecyclerItem(item: filteredItems[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}
