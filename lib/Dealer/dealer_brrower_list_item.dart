import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package

// Function to transform the local file path to a URL
String transformFilePathToUrl(String filePath) {
  const String urlPrefix = 'https://predeptest.paisalo.in:8084/LOSDOC//FiDocs//';
  const String localPrefix = 'D:\\LOSDOC\\FiDocs\\';
  if (filePath.startsWith(localPrefix)) {
    // Remove the local prefix and replace with the URL prefix
    return filePath.replaceFirst(localPrefix, urlPrefix).replaceAll('\\', '//');
  }
  // Return the filePath as is if it doesn't match the local prefix
  return filePath;
}

class ProfileAvatar extends StatelessWidget {
  final String? imagePath;

  ProfileAvatar({this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0), // Adjust the padding as needed
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.white,
        child: imagePath == null
            ? Icon(Icons.person, size: 40, color: Colors.grey[400]) // Icon when imagePath is null
            : ClipOval(
          child: Image.network(
            imagePath!,
            fit: BoxFit.cover,
            width: 80,
            height: 80,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.person, size: 40, color: Colors.grey[400]); // Fallback to icon on error
            },
          ),
        ),
      ),
    );
  }
}

class DealerBorrowerListItem extends StatelessWidget {
  final String name;
  final String fiCode;
  final String creator;
  final String? pic; // Update this to be nullable
  final VoidCallback onTap; // Callback for the onTap event

  DealerBorrowerListItem({
    required this.name,
    required this.fiCode,
    required this.creator,
    required this.onTap, // Initialize the onTap callback
    this.pic, // Initialize the pic, now nullable
  });

  @override
  Widget build(BuildContext context) {
    String? imageUrl;
    if (pic != null) {
      imageUrl = transformFilePathToUrl(pic!);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade900, Colors.redAccent.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            ProfileAvatar(imagePath: imageUrl),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'FI Code: $fiCode',
                    style: TextStyle(fontFamily: "Poppins-Regular",
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    creator,
                    style: TextStyle(fontFamily: "Poppins-Regular",
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}

/*
void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Color(0xFFD42D3F),
    ),
    home: Scaffold(
      appBar: AppBar(
        title: Text('Borrower List'),
        backgroundColor: Color(0xFFD42D3F),
      ),
      body: ListView(
        children: [
          BorrowerListItem(
            name: 'John Doe',
            fiCode: '12345',
            creator: 'Admin',
            pic: 'D:\\LOSDOC\\FiDocs\\image.jpg',
            onTap: () {
              // Handle tap
            },
          ),
          BorrowerListItem(
            name: 'Jane Smith',
            fiCode: '67890',
            creator: 'Admin',
            pic: null,
            onTap: () {
              // Handle tap
            },
          ),
        ],
      ),
    ),
  ));
}
*/
