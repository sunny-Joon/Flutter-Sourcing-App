import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class BannerDialog extends StatefulWidget {
  final String banner; // Can be an audio or image URL
  final String text1;  // First text content
  final String text2;  // Second text content

  const BannerDialog({
    required this.banner,
    required this.text1,
    required this.text2,
  });

  @override
  _BannerDialogState createState() => _BannerDialogState();
}

class _BannerDialogState extends State<BannerDialog> {
  VideoPlayerController? _audioController;

  @override
  void initState() {
    super.initState();
    if (widget.banner.endsWith('.mp3') || widget.banner.endsWith('.wav')) {
      _audioController = VideoPlayerController.network(widget.banner)
        ..initialize().then((_) {
          setState(() {}); // Refresh to show the player
        });
    }
  }

  @override
  void dispose() {
    _audioController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
      backgroundColor: Colors.white,
      title: Text('Message For You',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold, fontFamily: "Poppins-Regular",),),
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          mainAxisSize: MainAxisSize.max,
          children: [
            if (widget.banner.endsWith('.mp3') || widget.banner.endsWith('.wav'))
              _audioController != null && _audioController!.value.isInitialized
                  ? Column(
                children: [
                  AspectRatio(
                    aspectRatio: _audioController!.value.aspectRatio,
                    child: VideoPlayer(_audioController!),
                  ),
                  IconButton(
                    icon: Icon(
                      _audioController!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_audioController!.value.isPlaying) {
                          _audioController!.pause();
                        } else {
                          _audioController!.play();
                        }
                      });
                    },
                  ),
                ],
              )
                  : CircularProgressIndicator(),
            if (widget.banner.endsWith('.png') || widget.banner.endsWith('.jpg'))
              Image.network(
                widget.banner,
                fit: BoxFit.cover,
                height: 250,
              ),
            SizedBox(height: 16),
            Text(widget.text1, style: TextStyle(fontSize: 16, fontFamily: "Poppins-Regular",)),
            SizedBox(height: 8),
            Html(
              data: widget.text2, // Render HTML content
              style: {
                "p": Style(
                  fontSize: FontSize(14),
                  color: Colors.grey,
                ),
                "strong": Style(
                  fontWeight: FontWeight.bold,
                ),
                "u": Style(
                  color: Colors.blue,
                  textDecoration: TextDecoration.underline,
                ),
              },

            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String currentDate = DateTime.now().toIso8601String().split('T')[0];

            // Save the current date
            await prefs.setString('dialog_date', currentDate);
            Navigator.of(context).pop();
          },
          child: Text('Close',style: TextStyle(color: Color(0xFFD42D3F), fontFamily: "Poppins-Regular",),),
        ),
      ],
    );
  }
}
