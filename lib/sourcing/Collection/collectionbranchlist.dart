import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/Models/collectionbranchlistmodel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../api_service.dart';
import '../global_class.dart';
import '../notifications.dart';
import 'collectiongrouplist.dart';

class CollectionBranchListPage extends StatefulWidget {
  @override
  _CollectionBranchListPageState createState() => _CollectionBranchListPageState();
}

class _CollectionBranchListPageState extends State<CollectionBranchListPage> {
  List<CollectionBranchListDataModel> _items = [];
  List<CollectionBranchListDataModel> _allitems = [];
  String _searchText = '';
  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    _fetchBranchList();
  }

  Future<void> _fetchBranchList() async {
  //  EasyLoading.show(status: 'Loading...');

    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final apiService = Provider.of<ApiService>(context, listen: false);
        try {
          await apiService.CollectionBranchList(
              GlobalClass.token,
              GlobalClass.dbName,
              GlobalClass.imei,
              GlobalClass.id
          ).then((response) {
            if (response.statuscode == 200) {
              _allitems = response.data;

              final focodeSet = <String>{};
              final uniqueItems = response.data.where((item) => focodeSet.add(item.focode)).toList();

              setState(() {
                _items = uniqueItems; // Store the unique response data
              });
              _isLoading = false;

              print('Branch List retrieved successfully');
            } else {
              GlobalClass.showUnsuccessfulAlert(
                  context, "Not able to fetch Group List", 1);
              setState(() {
                _isLoading = false;
              });
            }
          });
        } catch (e) {
          print('Error: $e');
          GlobalClass.showErrorAlert(context, "Data not Fetched", 1);
          setState(() {
            _isLoading = false;
          });
        }
      }
    } on SocketException catch (_) {
      GlobalClass.showErrorAlert(context, "Network not Connected", 1);
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
                IconButton(
                    onPressed: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => NotificationPage()));
                    },
                    icon: Icon(Icons.notification_add,color: Colors.white,)
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
