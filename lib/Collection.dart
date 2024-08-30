import 'package:flutter/material.dart';

class Collection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      appBar: AppBar(
        title: Text('Collection'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Text('This is Page 3', style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
    );
  }
}
