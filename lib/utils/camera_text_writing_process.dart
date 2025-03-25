import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart';

import 'current_location.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  Position? position;
  String _locationMessage = "";

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.veryHigh,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<File> addTextToImage(String imagePath, String text) async {
    final imageBytes = await File(imagePath).readAsBytes();
    final decodedImage = img.decodeImage(imageBytes);

    if (decodedImage == null) {
      throw Exception('Failed to decode image');
    }

    int cardPadding = 10;
    int textPadding = 20;
    int cardHeight = 80; // Height of the card
    int cardWidth = decodedImage.width; // Full width of the image
    int cardX = 0; // Start from the left of the image
    int cardY = decodedImage.height - cardHeight - cardPadding;
    img.fillRect(decodedImage,
        x1: 20,
        y1: decodedImage.height - 210,
        x2: decodedImage.width - 20,
        y2: decodedImage.height - 10,
        color: img.ColorFloat16.rgba(0.0, 0.0, 0.0, .5));
    // Draw rounded corners using circles
    int radius = 20; // Radius for the rounded corners

    // img.fillCircle(
    //   decodedImage,x: (cardX + radius).toInt(), y: (cardY + radius).toInt(), radius: radius, color:  img.ColorFloat16.rgba(0.0, 0.0, 0.0, 0.5),
    // );
    //
    // img.fillCircle(
    //   decodedImage,x: ( cardX + cardWidth - radius).toInt(), y: ( cardY + radius).toInt(), radius: radius, color:  img.ColorFloat16.rgba(0.0, 0.0, 0.0, 0.5),
    // );
    //    img.fillCircle(
    //   decodedImage,x: (cardX + radius).toInt(), y: (cardY + cardHeight - radius).toInt(), radius: radius, color:  img.ColorFloat16.rgba(0.0, 0.0, 0.0, 0.5),
    // );
    //       img.fillCircle(
    //   decodedImage,x: (cardX + cardWidth - radius).toInt(), y: (cardY + cardHeight - radius).toInt(), radius: radius, color:  img.ColorFloat16.rgba(0.0, 0.0, 0.0, 0.5),
    // );

    img.drawString(
      decodedImage, // y position
      text, font: img.arial48,
      color: img.ColorFloat32.rgb(1, 1, 1),
      x: 70, y: decodedImage.height - 150,
    );

    // Save the modified image
    final directory = await getDownloadsDirectory();
    final modifiedImagePath =
        join(directory!.path, '${DateTime.now().millisecondsSinceEpoch}.png');
    final modifiedImageFile = File(modifiedImagePath);

// Check if the file exists, and delete it before saving the new one
    if (await modifiedImageFile.exists()) {
      try {
        // Attempt to delete the existing file
        await modifiedImageFile.delete();
        print("Existing image file deleted.");
      } catch (e) {
        print("Error deleting existing file: $e");
      }
    }

// Write the new image to the file
    await modifiedImageFile.writeAsBytes(img.encodePng(decodedImage));
    print("New image file saved at $modifiedImagePath");
    return modifiedImageFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 200,
                child: FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CameraPreview(_controller);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                )),
          ),
          Positioned(
              left: 20,
              top: 30,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(width: 1, color: Colors.grey.shade300),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        child: Center(
                          child: Icon(Icons.arrow_back_ios_sharp, size: 16),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Center(
                      child: Image.asset(
                        'assets/Images/logo_white.png',
                        // Replace with your logo asset path
                        height: 30,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                    ),
                  ],
                ),
              )),
          Positioned(
              bottom: 20,
              left: MediaQuery.of(context).size.width / 2 - 40,
              child: InkWell(
                onTap: () async {
                  String imageText = "";
                  currentLocation _locationService = currentLocation();
                  try {
                    await _initializeControllerFuture;

                    // Take picture
                    final image = await _controller.takePicture();
                    try {
                      Map<String, dynamic> locationData =
                          await _locationService.getCurrentLocation();
                      imageText += locationData['latitude'].toString();
                      imageText += ' ${locationData['longitude'].toString()}';
                      imageText += '\n${locationData['address']}';
                      imageText += '\n${DateTime.now()}';
                    } catch (e) {
                      print("Error getting current location: $e");
                    }
                    // Add text to image
                    final modifiedImage = await addTextToImage(
                      image.path,
                      imageText, // Add your text here
                    );

                    if (mounted) {
                      Navigator.pop(context, modifiedImage);
                    }
                    // Navigate to display the image
                    if (!mounted) return;
                    // await Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => DisplayPictureScreen(imagePath: modifiedImage.path),
                    //   ),
                    // );
                  } catch (e) {
                    print(e);
                  }
                },
                child: Card(
                  color: Colors.black,
                  shape: CircleBorder(),
                  child: Container(
                    height: 60,
                    width: 60,
                    child: Center(
                      child: Icon(
                        Icons.camera,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
          )
        ],
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      body: Column(
        children: [
          SizedBox(height: 50),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.grey.shade300),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    child: Icon(Icons.arrow_back_ios_sharp, size: 16),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                Center(
                  child: Image.asset(
                    'assets/Images/logo_white.png',
                    height: 30,
                  ),
                ),
                Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Center(
              child: Image.file(File(imagePath)),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Okay"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
