import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/Models/collectionborrowerlistmodel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'Models/collectionbranchlistmodel.dart';
import 'api_service.dart';
import 'collection.dart';
import 'global_class.dart';


 class CollectionBorrowerList extends StatefulWidget {
   final CollectionBranchListDataModel Branchdata;

   const CollectionBorrowerList({super.key, required this.Branchdata});

   @override
   State<CollectionBorrowerList> createState() => _CollectionBorrowerListState();
 }

 class _CollectionBorrowerListState extends State<CollectionBorrowerList> {

   List<CollectionBorrowerListDataModel> _borrowerItems = [];


   @override
   void initState() {
     super.initState();
     // if(widget.page =="E SIGN"){
     _fetchCollectionBorrowerList(1);
     // }else{
     //   _fetchBorrowerList(0);
     //   }
   }

   Future<void> _fetchCollectionBorrowerList(int type) async {
     EasyLoading.show(status: 'Loading...',);

     final apiService = Provider.of<ApiService>(context, listen: false);

     await apiService.CollectionBorrowerList(
         GlobalClass.token,
         GlobalClass.dbName,
         GlobalClass.imei,
         "",//widget.BranchData.branchCode,
         "0001",//widget.GroupData.groupCode,
         "GRST002946",//GlobalClass.id,
         "2024-11-20"//GlobalClass.getTodayDate(),
     ).then((response) {
       if (response.statuscode == 200) {
         setState(() {
           _borrowerItems = response.data;
         });
         EasyLoading.dismiss();
         print("object++12");
       } else {
         setState(() {
         });
         EasyLoading.dismiss();

       }
     });
   }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Color(0xFFD42D3F),
       body: /*_isLoading
          ? Center(child: CircularProgressIndicator())*/
       /*:*/ Column(
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
           Expanded(
             child: ListView.builder(
               itemCount: _borrowerItems.length,
               itemBuilder: (context, index) {
                 final item = _borrowerItems[index];
                 return CollectionBorrowerListItem(
                   name: item.custName,
                   fiCode: item.caseCode.toString(),
                   //mobile: item.pPhone,
                   creator: item.creator,
                   // address: item.currentAddress,
                   // pic:item.profilePic,
                   onTap: () {
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) => Collection(
                           selectedData: item,
                         ),
                       ),
                     );
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


String transformFilePathToUrl(String filePath) {
  const String urlPrefix = 'https://predeptest.paisalo.in:8084/LOSDOC//FiDocs//';
  const String localPrefix = 'D:\\LOSDOC\\FiDocs\\';
  if (filePath.startsWith(localPrefix)) {
    // Remove the local prefix and replace with the URL prefix
    return filePath.replaceFirst(localPrefix, urlPrefix).replaceAll('\\', '//');
  }
  // Return the filePath as is if it doesn't match the local prefix
  return filePath;
}

class ProfileAvatar extends StatelessWidget {
  final String? imagePath;

  ProfileAvatar({this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0), // Adjust the padding as needed
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.white,
        child: imagePath == null
            ? Icon(Icons.person, size: 40, color: Colors.grey[400]) // Icon when imagePath is null
            : ClipOval(
          child: Image.network(
            imagePath!,
            fit: BoxFit.cover,
            width: 80,
            height: 80,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.person, size: 40, color: Colors.grey[400]); // Fallback to icon on error
            },
          ),
        ),
      ),
    );
  }
}

class CollectionBorrowerListItem extends StatelessWidget {
  final String name;
  final String fiCode;
  final String creator;
  final String? pic; // Update this to be nullable
  final VoidCallback onTap; // Callback for the onTap event

  CollectionBorrowerListItem({
    required this.name,
    required this.fiCode,
    required this.creator,
    required this.onTap, // Initialize the onTap callback
    this.pic, // Initialize the pic, now nullable
  });

  @override
  Widget build(BuildContext context) {
    String? imageUrl;
    if (pic != null) {
      imageUrl = transformFilePathToUrl(pic!);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade900, Colors.redAccent.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            ProfileAvatar(imagePath: imageUrl),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'FI Code: $fiCode',
                    style: TextStyle(fontFamily: "Poppins-Regular",
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    creator,
                    style: TextStyle(fontFamily: "Poppins-Regular",
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Color(0xFFD42D3F),
    ),
    home: Scaffold(
      appBar: AppBar(
        title: Text('Borrower List'),
        backgroundColor: Color(0xFFD42D3F),
      ),
      body: ListView(
        children: [
          CollectionBorrowerListItem(
            name: 'John Doe',
            fiCode: '12345',
            creator: 'Admin',
            pic: 'D:\\LOSDOC\\FiDocs\\image.jpg',
            onTap: () {
              // Handle tap
            },
          ),
          CollectionBorrowerListItem(
            name: 'Jane Smith',
            fiCode: '67890',
            creator: 'Admin',
            pic: null,
            onTap: () {
              // Handle tap
            },
          ),
        ],
      ),
    ),
  ));
 }



