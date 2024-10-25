import 'package:flutter/material.dart';
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

}
