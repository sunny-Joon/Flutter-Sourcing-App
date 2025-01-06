import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:audioplayers/audioplayers.dart';

class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  int imageStartIndex = 0;
  String qrMsg="Scan a Aadhaar QR code";
  bool isProcessing = false; // Prevent overlapping scans
  int retryAttempts = 0; // Track retries
  final int maxRetryAttempts = 3; // Maximum retry limit
  bool isLoading = false; // Track loading state
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isTorchOn = false; // Flash status
  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: QRView(

                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: Color(0xFFD42D3F),
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 300,
                  ),
                ),
              ),


            ],
          ),
          Positioned(bottom:20,left: MediaQuery.of(context).size.width/2-80,child:  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  if (controller != null) {
                    await controller!.toggleFlash();
                    final flashStatus = await controller!.getFlashStatus();
                    setState(() {
                      isTorchOn = flashStatus ?? false;
                    });
                  }
                },
                icon: Icon(
                  isTorchOn ? Icons.flash_off : Icons.flash_on,
                  color: Colors.black,
                ),
                label: Text(isTorchOn ? 'Turn Off Flash' : 'Turn On Flash',style: TextStyle(color: Colors.black),),
              ),
            ],
          )),


          if (isLoading)
            Center(
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Scanning in progress. Please wait...',
                      style: TextStyle(fontFamily: "Poppins-Regular",color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (isProcessing) return; // Prevent simultaneous processing
      setState(() {
        isProcessing = true;

      });

      try {
        if (scanData.code != null) {
          retryAttempts = 0; // Reset retry count
          await _processScanData(scanData.code!);

        } else {
          _showMessage("Scan failed: Invalid QR code data. Please try again.");
        }
      } catch (e) {
        _handleError(e);
      } finally {

          isProcessing = false;
          isLoading = false;

      }
    });
  }

  Future<void> _processScanData(String rawCode) async {
    isLoading = true;
    try {
      BigInt bigIntScanData = BigInt.parse(rawCode);
      List<int> byteScanData = bigIntToBytes(bigIntScanData);

      List<int> decompressedData = decompressData(byteScanData);
      if (decompressedData.isEmpty) {
        _showMessage("Decompression failed. Please retry.");
        return;
      }

      List<List<int>> parts = separateData(decompressedData, 255, 15);
      String decodedResult = decodeData(parts);
      isLoading = false;
      await _playSuccessSound(); // Play sound after success
      // Navigate back with the decoded result
      Navigator.pop(context, decodedResult);
    } catch (e) {
      print("error in qr SCANNING$e");
      // retryAttempts++;
      // if (retryAttempts <= maxRetryAttempts) {
      //   _showMessage("Processing failed. Retrying ($retryAttempts/$maxRetryAttempts)...");
      //   await _processScanData(rawCode); // Retry
      // } else {
      //   _showMessage("Maximum retry attempts reached. Please try again.");
      // }
      setState(() {
        qrMsg="QR scanning in progress please wait...";
      });
    }
  }

  Future<void> _playSuccessSound() async {
    try {
      await audioPlayer.play(
        AssetSource('beep.wav'), // Add this file to your assets
      );
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  List<List<int>> separateData(List<int> source, int separatorByte, int vtcIndex) {
    List<List<int>> separatedParts = [];
    int begin = 0;

    for (int i = 0; i < source.length; i++) {
      if (source[i] == separatorByte) {
        if (i != 0 && i != (source.length - 1)) {
          separatedParts.add(source.sublist(begin, i));
        }
        begin = i + 1;

        // Stop if we've reached the desired VTC index
        if (separatedParts.length == (vtcIndex + 1)) {
          imageStartIndex = begin;
          break;
        }
      }
    }

    // Handle case when vtcIndex is out of bounds
    if (separatedParts.length <= vtcIndex) {
      print("Error: Not enough segments found.");
      return []; // Or handle accordingly
    }

    return separatedParts;
  }


  String decodeData(List<List<int>> encodedData) {
    String decodedText = "";

    for (var byteArray in encodedData) {
      try {
        // Decode the byte array into a string
        String decodedString = utf8.decode(byteArray);
        decodedText += "$decodedString,";
      } catch (e) {
        print("Decoding failed for a segment: $e");
      }
    }

    return decodedText;
  }


  List<int> bigIntToBytes(BigInt bigInt) {
    List<int> byteArray = [];

    // Convert BigInt to byte array
    while (bigInt > BigInt.zero) {
      byteArray.add((bigInt & BigInt.from(0xFF)).toInt());
      bigInt = bigInt >> 8;
    }

    // Reversed to maintain correct byte order
    return byteArray.reversed.toList();
  }

  // List<int> decompressData(List<int> byteData) {
  //   try {
  //     // GZip decompression
  //     final decompressed = GZipCodec().decoder.convert(Uint8List.fromList(byteData));
  //     return decompressed;
  //   } catch (e) {
  //     print("Error during GZip decompression: $e");
  //     // Try ZLib decompression if GZip fails
  //     try {
  //       print("Attempting ZLib decompression...");
  //       return ZLibCodec().decodeBytes(byteData);
  //     } catch (zlibError) {
  //       print("Error during ZLib decompression: $zlibError");
  //       return [];
  //     }
  //   }
  // }

  List<int> decompressData(List<int> byteScanData) {
    // Validate data size
    if (byteScanData.isEmpty || byteScanData.length < 4) {
      throw Exception('Invalid data: Too short for decompression.');
    }

    // Attempt GZIP decompression
    try {
      print('Attempting GZIP decompression...');
      final decompressed = GZipCodec().decoder.convert(Uint8List.fromList(byteScanData));
      return decompressed;
    } catch (gzipError) {
      print('GZIP decompression failed: $gzipError');
    }

    // Attempt ZLIB decompression
    try {
      print('Attempting ZLIB decompression...');
      return ZLibDecoder().decodeBytes(byteScanData);
    } catch (zlibError) {
      print('ZLIB decompression failed: $zlibError');
    }

    // If both fail, handle gracefully
    return [];

  }


  void _handleError(dynamic error) {
    _showMessage("An error occurred: $error");
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    print(message);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
