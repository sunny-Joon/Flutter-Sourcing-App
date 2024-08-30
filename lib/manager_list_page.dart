import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/borrower_list.dart';
import 'KYC.dart';
import 'recycler_item_widget.dart';

class ManagerListPage extends StatefulWidget {
  final String data;

  ManagerListPage({required this.data});

  @override
  _ManagerListPageState createState() => _ManagerListPageState();
}

class _ManagerListPageState extends State<ManagerListPage> {
  final List<String> _items = [
    'Item 1',
    'Item 2',
  ];
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    final filteredItems = _items.where((item) {
      return item.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Manager List'),
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.red,
      body: Column(
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
                    switch (widget.data) {
                      case 'KYC':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KYCPage(data: widget.data),
                          ),
                        );
                        break;
                      case 'APPLICATION FORM':
                      case 'House Visit':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BorrowerList(data: widget.data),
                        ),
                      );
                      break;
                      case 'Visit Report':
                      case 'E SIGN':
                      _showEsignPopup(context);

                      break;
                      default:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BorrowerList(data: 'Unknown'),
                          ),
                        );
                        break;
                    }
                  },
                  child: RecyclerItemWidget(item: filteredItems[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _showEsignPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.red,
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
                  'First Esign',
                  style: TextStyle(color: Colors.red),
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
                  'Second Esign',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

