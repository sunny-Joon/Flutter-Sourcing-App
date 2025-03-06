import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../sourcing/global_class.dart';


final List<Widget> imageSliders =[];

class CarouselWithIndicatorDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicatorDemo> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageSliders.add(Container(
      margin: EdgeInsets.all(5.0),
      child: Container(
          height:200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background container
              Positioned(
                bottom: 20,
                child:Container(
                    width: 250,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.blue[700], // Darker blue background
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Card(
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
                        clipBehavior: Clip.antiAlias,
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Upload Aadhaar Front",style: TextStyle(color: Colors.white),),
                            Icon(Icons.camera_alt, color: Colors.white, size: 30),
                          ],
                        )
                    )
                ),
              ),
              // Floating bottom row
              Positioned(
                bottom: 0, // Adjust to make it appear partially outside
                child: Container(
                  width: 120,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue[400], // Lighter blue for contrast
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                          onTap: () async {
                            File? pickedFile =
                            await
                            GlobalClass().pickImage();

                          },
                          child:
                          Icon(Icons.add, color: Colors.white, size: 25)
                        //  Text("Aadhaar Front",style: TextStyle(color: Colors.white),),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
      ),

    ));
    imageSliders.add(Container(
        height:200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background container
            Positioned(
              bottom: 20,
              child:Container(
                  width:250,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.blue[700], // Darker blue background
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),

                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Upload Aadhaar Back",style: TextStyle(color: Colors.white),),
                        Icon(Icons.camera_alt, color: Colors.white, size: 30),
                      ],
                    )
                  )
              ),
            ),
            // Floating bottom row
            Positioned(
              bottom: 0, // Adjust to make it appear partially outside
              child: Container(
                width: 120,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue[400], // Lighter blue for contrast
                  borderRadius: BorderRadius.circular(25),
                ),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {
                        File? pickedFile =
                        await
                        GlobalClass().pickImage();
                        setState(() {


                        });
                      },
                      child:
                      Icon(Icons.add, color: Colors.white, size: 25)
                    )
                  ],
                ),
              ),
            ),
          ],
        )
    ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: CarouselSlider(
            items: imageSliders,
            carouselController: _controller,
            options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                scrollDirection: Axis.horizontal,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imageSliders.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ]),
    );
  }
}







