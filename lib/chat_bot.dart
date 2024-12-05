import 'package:flutter/material.dart';

class ChatActivity extends StatefulWidget {
  @override
  _ChatActivityState createState() => _ChatActivityState();
}

class _ChatActivityState extends State<ChatActivity> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];
  String selectedQuery = 'Select a query';

  final Map<String, List<String>> queryResponses = {
    'Select a query': [],
    'Timeout': [
      "Try 2 or 3 Times If Not Solved",
      "Try After 10 min",
      "Contact Support Number"
    ],
    'QR': [
      "Check Your Aadhar Format Is Correct (DOB, NAME)",
      "Go To APP INFO Setting, Click Storage, Clear Data and Cache, Give All Permissions, Restart App",
      "Contact Support Number"
    ],
    'QR Docs': [
      "Check Your Aadhar Format (DOB, AadharID)",
      "Ensure Stamp Is Properly Visible",
      "Go To APP INFO Setting, Click Storage, Clear Data and Cache, Give All Permissions, Restart App",
      "Contact Support Number"
    ],
    'Wrong User ID': [
      "Fill UserName",
      "Click ShareID Device",
      "Fill All Details, Click Save Button",
      "Fill UserName And Pass, Click Login"
    ],
    'Second Esign': [
      "Check Sanctioned Date",
      "If Sanctioned Date is Over 15 Days, Case Not Show in 2nd Esign",
      "Generate KYC Again And Follow All Process"
    ],
    'Other': ['You will get your answer very soon!']
  };

  void handleQuery(String query) {
    List<String> response = queryResponses[query] ?? ['You will get your answer very soon!'];
    setState(() {
      messages.add({"You": query});
      for (int i = 0; i < response.length; i++) {
        messages.add({"Sol ${i + 1}": response[i]});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45),
        child: Padding(
          padding: EdgeInsets.only(top: 30, left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  height: 40,
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
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFAD0C4),
              Color(0xFFFFF0F0),
              Color(0xFFF3E5F5),
              Color(0xFFE1F5FE),
              Color(0xFFE8F5E9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  String key = messages[index].keys.first;
                  String value = messages[index][key]!;
                  return Align(
                    alignment: key == "You" ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: key == "You"
                              ? [Color(0xFFD42D3F), Color(0xFFD42D3F).withOpacity(0.7)]
                              : [Colors.white, Colors.white70],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6.0,
                            offset: Offset(2, 2),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            key,
                            style: TextStyle(
                              color: key == "You" ? Colors.white : Color(0xFFD42D3F),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            value,
                            style: TextStyle(
                              color: key == "You" ? Colors.white70 : Color(0xFFD42D3F).withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: DropdownButton<String>(
                      value: selectedQuery,
                      isExpanded: true,
                      style: TextStyle(color: Colors.black),
                      underline: SizedBox(), // Hides the default underline
                      items: queryResponses.keys.map((String key) {
                        return DropdownMenuItem<String>(
                          value: key,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              key,
                              style: TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedQuery = value!;
                          if (selectedQuery != 'Select a query') {
                            handleQuery(selectedQuery);
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Or type your custom query...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_controller.text.isNotEmpty) {
                              handleQuery(_controller.text);
                              _controller.clear();
                            }
                          },
                          child: Text(
                            'Send',
                            style: TextStyle(
                              color: Colors.white, // Ensures the text color is white
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFD42D3F), // Background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
