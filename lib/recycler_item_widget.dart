import 'package:flutter/material.dart';

class RecyclerItemWidget extends StatelessWidget {
  final String item;

  RecyclerItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              item,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(color: Colors.white70),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Place Group Code',
                    ),
                    Text(
                      'MATHURA/0115',
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Branch Code Creator',
                    ),
                    Text(
                      '005/Mahura',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
