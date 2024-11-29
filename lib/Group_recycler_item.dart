/*import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/GlobalClass.dart';

import 'Models/GroupModel.dart';

class GroupRecyclerItem extends StatelessWidget {
  final GroupDataModel item;

  GroupRecyclerItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(4),child: Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),

      color: Colors.white,
      elevation: 5,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            elevation: 0,
            child:  Container(
              height: 45,
              width: MediaQuery.of(context).size.width/4,
              color: Color(0xFFD42D3F),
              child:   Center(
                child: Text('${item.groupCode}',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w400),),
              ),
            ),
          ),
          Container(
            child:  Center(
              child: Text('${item.groupCodeName}',style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold),),
            ),
          ),
        ],
      ),
    ),);
  }

}*/


import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/GlobalClass.dart';
import 'Models/GroupModel.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupRecyclerItem extends StatelessWidget {
  final GroupDataModel item;

  GroupRecyclerItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child:  Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: Offset(5, 5),
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              // Gradient Background for Visual Appeal
              gradient: LinearGradient(
                colors: [Colors.red.shade900, Colors.redAccent.shade200],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                children: [
                  // Stylish Group Code Box with Gradient Background
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
/*
                        colors: [Color(0xFF9A2434), Color(0xFFF06A76)],
*/
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
                        '${item.groupCode}',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 0),
                  // Group Name with Gradient Overlay and Bold Text - Centered
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '${item.groupCodeName}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
