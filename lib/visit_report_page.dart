import 'package:flutter/material.dart';

class VisitReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            width: 1, color: Colors.grey.shade300),
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
              SizedBox(height: 20,),
              const Text(
                "Meeting Type",
                style: TextStyle(fontFamily: "Poppins-Regular",
                  fontSize: 15,

                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 0),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "1",
                        child: Text("Option 1"),
                      ),
                      DropdownMenuItem(
                        value: "2",
                        child: Text("Option 2"),
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sm Code",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Poppins-Regular",
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 0),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextField(
                              maxLength: 10,
                              decoration: const InputDecoration(
                                hintText: "Enter Case Code (SM CODE)",
                                border: InputBorder.none,
                                counterText: "",
                                contentPadding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.search,size: 40,color: Colors.white,),
                        ),
                      ),
                    ],
                  ),

                  _buildInputCard("Name", ""),
                  _buildInputCard("Amount", "0", inputType: TextInputType.number),
                  const SizedBox(height: 8),

                  const Text(
                    "Comment",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Poppins-Regular",
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 0),
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    elevation:0,
                    child: TextField(
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: "Enter your comment",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     Card(
                       elevation: 6,
                       color: Colors.grey.shade300,
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                       child: Container(
                         alignment: Alignment.center,
                         height: 40,
                         width: 150,
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Click Image"),
                                    Icon(Icons.camera)
                                  ],
                         ),
                       ),
                     ),
                        SizedBox(width: 10),
                      const Image(
                        image: AssetImage("assets/Images/prof_ic.png"),
                        width: 100,
                        height: 100,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Center(child: Card(

                    elevation: 6,
                    color: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: MediaQuery.of(context).size.width-80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Submit data"),

                        ],
                      ),
                    ),
                  ),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard(String label, String value, {TextInputType inputType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8,),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontFamily: "Poppins-Regular",
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 0),
        Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              keyboardType: inputType,
              decoration: InputDecoration(
                hintText: label,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
