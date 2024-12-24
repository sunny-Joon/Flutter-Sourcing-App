import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_sourcing_app/Models/collectionbranchlistmodel.dart';
import 'package:flutter_sourcing_app/collectionborrowerlist.dart';

import 'global_class.dart';

class CollectionGroupListPage extends StatefulWidget {
  final CollectionBranchListDataModel SelectedData;
  final List<CollectionBranchListDataModel> Branchdata;

  const CollectionGroupListPage({
    super.key,
    required this.SelectedData,
    required this.Branchdata,
  });

  @override
  _CollectionGroupListPageState createState() => _CollectionGroupListPageState();
}

class _CollectionGroupListPageState extends State<CollectionGroupListPage> {
  List<CollectionBranchListDataModel> _items = [];
  String _searchText = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _items = widget.Branchdata.where((item) {
      return item.focode == widget.SelectedData.focode;
    }).toList();
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    // Filter the items based on the search text
    final filteredItems = _items.where((item) {
      return item.areaCd.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();


    print("Filtered items in build: ${filteredItems.length}"); // Debug statement

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
                      border: Border.all(
                          width: 1, color: Colors.grey.shade300),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    child: Icon(Icons.arrow_back_ios_sharp, size: 13),
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
                        builder: (context) => CollectionBorrowerList(Branchdata: selectedItem),
                      ),
                    );
                  },
                  child: CollectionGroupListItem(item: filteredItems[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CollectionGroupListItem extends StatelessWidget {
  final CollectionBranchListDataModel item;

  CollectionGroupListItem({required this.item});

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
                        '${item.areaCd}',
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
                        '${item.areaName}',
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
