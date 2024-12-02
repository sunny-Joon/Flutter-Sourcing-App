import 'package:flutter/material.dart';


class Collection extends StatefulWidget {

  _CollectionState createState() => _CollectionState();
}
class _CollectionState extends State<Collection>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),
        body: SingleChildScrollView(
            child:Center(
              child: Padding(padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),

                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10,top: 50,right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              child: Container(
                                // decoration: BoxDecoration(
                                //   color: Colors.white,
                                //   border: Border.all(
                                //       width: 1, color: Colors.grey.shade300),
                                //   borderRadius: BorderRadius.all(Radius.circular(5)),
                                // ),
                                height: 40,
                                width: 40,
                                alignment: Alignment.center,
                                // child: Center(
                                //   child: Icon(Icons.arrow_back_ios_sharp, size: 16),
                                // ),
                              ),
                              // onTap: () {
                              //   setState(() {
                              //     Navigator.pop(context);                  });
                              // },
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
                      ),
                    ],)
              ),
            )
        )
    );
  }

}
