import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/GlobalClass.dart';
import 'Models/branch_model.dart';

class branchRecyclerItem extends StatelessWidget {
  final BranchDataModel item;

  branchRecyclerItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(8.0),
            child: Text(
              GlobalClass.creator,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            color: Colors.red,
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Branch Name / Code',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '${item.branchName} / ${item.branchCode}',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
