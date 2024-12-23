import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/Models/collectionbranchlistmodel.dart';
import 'package:flutter_sourcing_app/collectionborrowerlist.dart';
import 'package:flutter_sourcing_app/collectiongrouplist.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'api_service.dart';
import 'global_class.dart';

class CollectionBranchListPage extends StatefulWidget {
  @override
  _CollectionBranchListPageState createState() => _CollectionBranchListPageState();
}

class _CollectionBranchListPageState extends State<CollectionBranchListPage> {
  List<CollectionBranchListDataModel> _items = [];
  List<CollectionBranchListDataModel> _allitems = [];
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _fetchBranchList();
  }

  Future<void> _fetchBranchList() async {
    EasyLoading.show(status: 'Loading...');

    final apiService = Provider.of<ApiService>(context, listen: false);
    try {
      await apiService.CollectionBranchList(
          GlobalClass.token,
          GlobalClass.dbName,
          "861950058549712",
          "GRST002946" /*GlobalClass.imei, GlobalClass.id*/
      ).then((response) {
        if (response.statuscode == 200) {
          _allitems = response.data;

          final focodeSet = <String>{};
          final uniqueItems = response.data.where((item) => focodeSet.add(item.focode)).toList();

          setState(() {
            _items = uniqueItems; // Store the unique response data
          });
          EasyLoading.dismiss();

          print('Branch List retrieved successfully');
        } else {
          GlobalClass.showUnsuccessfulAlert(
              context, "Not able to fetch Group List", 1);
          setState(() {
            EasyLoading.dismiss();
          });
        }
      });
    } catch (e) {
      print('Error: $e');
      GlobalClass.showErrorAlert(context, "Server Side Error", 1);
      setState(() {
        EasyLoading.dismiss();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _items.where((item) {
      return item.areaCd.toLowerCase().contains(_searchText.toLowerCase());
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
                Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
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
            padding: const EdgeInsets.only(bottom: 0, top: 0, left: 10, right: 10),
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
                        builder: (context) => CollectionGroupListPage(
                          SelectedData: selectedItem,
                          Branchdata: _allitems,
                        ),
                      ),
                    );
                  },
                  child: CollectionBranchListItem(item: filteredItems[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CollectionBranchListItem extends StatelessWidget {
  final CollectionBranchListDataModel item;

  CollectionBranchListItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: Offset(5, 5),
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  // Stylish Branch Code Box with Gradient Background
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red.shade900, Colors.redAccent.shade200],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(2, 2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${item.focode}',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  // Branch Name with Gradient Overlay and Bold Text - Centered
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '${item.foName}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD42D3F),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // Right Arrow Icon to Indicate More Details
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
