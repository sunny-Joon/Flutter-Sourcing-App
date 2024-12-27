import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

class AddTextToImage extends StatefulWidget {
  @override
  _AddTextToImageState createState() => _AddTextToImageState();
}

class _AddTextToImageState extends State<AddTextToImage> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  File? _editedImage;

  Future<void> captureAndEditImage() async {
    // Capture image from the camera
    final XFile? capturedImage = await _picker.pickImage(source: ImageSource.camera);

   // if (capturedImage == null) return;

    final File imageFile = File(capturedImage!.path);
    final Uint8List bytes = await imageFile.readAsBytes();
    final image = await decodeImageFromList(bytes);

   // if (image == null) return;

    // Create a picture recorder to draw on the image
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromPoints(Offset(0, 0), Offset(image.width.toDouble(), image.height.toDouble())),
    );

    // Draw the captured image on the canvas
    canvas.drawImage(image, Offset(0, 0), Paint());

    // Draw text on the image
    final textStyle = TextStyle(
      color: Colors.red,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );
    final textSpan = TextSpan(
      text: 'Latitude: 12.34, Longitude: 56.78',
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: image.width.toDouble());

    // Position the text at the bottom of the image
    textPainter.paint(canvas, Offset(10, image.height.toDouble() - 50));

    // End recording and generate the image
    final picture = recorder.endRecording();
    final img = await picture.toImage(image.width, image.height);

    // Convert the image to byte data
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final bytess = byteData!.buffer.asUint8List();

    // Save the image
     final tempDir =  await getExternalStorageDirectory();
    final outputPath = '${tempDir!.path}/edited_image.png';
    print('${tempDir!.path}/edited_image.png');
    await deleteFileIfExists('${tempDir!.path}/edited_image.png'); // Delete the file if it exists
    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(bytess);
    print('${outputFile.path} ');

    // Update the UI with the edited image
    setState(() {
      print("set state is working");
      _editedImage = outputFile;
    });
  }
  Future<void> deleteFileIfExists(String filePath) async {
    final file = File(filePath);

    // Check if the file exists
    if (await file.exists()) {
      try {
        // Delete the file
        await file.delete();
        print("File deleted: $filePath");
      } catch (e) {
        print("Error deleting file: $e");
      }
    } else {
      print("File does not exist: $filePath");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Text to Image")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the edited image if it exists
            if (_editedImage != null)
              Image.file(
                _editedImage!,
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              )
            else
              Text("Capture an image to display here."),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: captureAndEditImage,
              child: Text("Capture and Add Text"),
            ),
          ],
        ),
      ),
    );
  }
}
