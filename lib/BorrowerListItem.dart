import 'package:flutter/material.dart';

class BorrowerListItem extends StatelessWidget {
  final String name;
  final String fiCode;
  final String mobile;
  final String creator;
  final String address;
  final VoidCallback onTap; // Callback for the onTap event

  BorrowerListItem({
    required this.name,
    required this.fiCode,
    required this.mobile,
    required this.creator,
    required this.address,
    required this.onTap, // Initialize the onTap callback
  });

  @override
  /* Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Call the onTap callback when tapped
      child: Card(
        margin: EdgeInsets.all(10),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/Images/profileimage.png'),
                  ),
                  SizedBox(width: 10),
                  Text(
                    name,
                    style: TextStyle(color: Color(0xFFD42D3F),fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'FI Code:',
                    style: TextStyle(color: Color(0xFFD42D3F), fontSize: 16),
                  ),
                  Expanded(
                    child: Text(
                      fiCode,
                      style: TextStyle(color: Color(0xFFD42D3F), fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Creator:',
                    style: TextStyle(color: Color(0xFFD42D3F), fontSize: 16),
                  ),
                  Expanded(
                    child: Text(
                      creator,
                      style: TextStyle(color: Color(0xFFD42D3F), fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mobile:',
                    style: TextStyle(color: Color(0xFFD42D3F), fontSize: 16),
                  ),
                  Expanded(
                    child: Text(
                      mobile,
                      style: TextStyle(color: Color(0xFFD42D3F), fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Address:',
                    style: TextStyle(color: Color(0xFFD42D3F), fontSize: 16),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      address,
                      style: TextStyle(color: Color(0xFFD42D3F), fontSize: 16),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }*/
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: 10,
              child: Container(
                  // Adjusted height to accommodate the red line
                  width: MediaQuery.of(context).size.width - 24,
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 100),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$fiCode /',
                              style: TextStyle(
                                color: Color(0xFFD42D3F),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              creator,
                              style: TextStyle(
                                color: Color(0xFFD42D3F),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Color(0xFFD42D3F),
                          thickness: 2,
                          height: 5,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  color: Color(0xFFD42D3F),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                      ],
                    ),
                  ))),
          Positioned(
              child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Card(
              elevation: 5,
              shape: CircleBorder(),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(Icons.person),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
