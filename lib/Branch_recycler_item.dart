import 'package:flutter/material.dart';
import 'Models/branch_model.dart';

class BranchRecyclerItem extends StatelessWidget {
  final BranchDataModel item;

  BranchRecyclerItem({required this.item});

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
                child: Text("${item.branchCode}",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w400),),
              ),
            ),
          ),
          Container(


            child:  Center(
              child: Text("${item.branchName}",style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold),),
            ),
          ),



        ],
      ),
    ),);
  }
}

// Padding(
// padding: EdgeInsets.all(8.0), // Add padding around the Card
// child: Card(
// margin: EdgeInsets.zero, // Remove extra margin if only padding is needed
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.center,
// children: [
// Container(
// child: Row(
// children: [
// Expanded(
// flex: 1,
// child: Container(
// color: Colors.white,
// padding: EdgeInsets.all(8.0),
// child: Column(
// children: [
// Text(
// '${item.branchCode}',
// style: TextStyle(color: Colors.red),
// ),
// ],
// ),
// ),
// ),
// Expanded(
// flex: 2,
// child: Container(
// color: Color(0x86AD0808),
// padding: EdgeInsets.all(8.0),
// child: Column(
// children: [
// Text(
// '${item.branchName}',
// style: TextStyle(color: Colors.white),
// ),
// ],
// ),
// ),
// ),
// ],
// ),
// ),
// ],
// ),
// ),
// );