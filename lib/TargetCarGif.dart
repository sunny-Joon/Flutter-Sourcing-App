import 'package:flutter/material.dart';
import 'dart:async';

import 'package:gif/gif.dart';

class TargetCarGif extends StatefulWidget {
  @override
  _TargetCarGifState createState() => _TargetCarGifState();
}

class _TargetCarGifState extends State<TargetCarGif> {
  bool _showText = false;

  @override
  void initState() {
    super.initState();

    // Start a timer to show the text after 2 seconds
    Timer(Duration(seconds: 3), () {
      setState(() {
        _showText = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      appBar: AppBar(title: Text('Target Achieve')),
      body: Stack(
        children: [
          // Bottom GIF
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 130,
              child: Gif(
                fps: 30,
                autostart: Autostart.once,
                placeholder: (context) =>
                const Center(child: CircularProgressIndicator()),
                image: const AssetImage('assets/Images/caranimation.gif'),
              ),
            ),
          ),
          // Top GIF
          Positioned(
            top: 96,
            left: 0,
            right: 0,
            child: Container(
              height: 400,
              child: Gif(
                fps: 30,
                autostart: Autostart.once,
                placeholder: (context) =>
                const Center(child: CircularProgressIndicator()),
                image: const AssetImage('assets/Images/trophy.gif'),
              ),
            ),
          ),
          // TextView
          if (_showText)
            Positioned(
              top: 185, // Adjust based on desired vertical positioning
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  '00000',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
