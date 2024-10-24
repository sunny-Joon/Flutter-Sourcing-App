import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/GlobalClass.dart';

import 'Models/GroupModel.dart';

class GroupRecyclerItem extends StatelessWidget {
  final GroupDataModel item;

  GroupRecyclerItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        '${item.groupCode}',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color: Color(0x86AD0808),
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        '${item.groupCodeName}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
