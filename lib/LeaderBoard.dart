import 'package:flutter/material.dart';

class LeaderBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      appBar: AppBar(
        title: Text('LeaderBoard'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Text('This is Page 2', style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
    );
  }
}
