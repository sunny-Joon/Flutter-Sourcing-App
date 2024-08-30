import 'package:flutter/material.dart';

class FinancialInfoPage extends StatefulWidget {
  @override
  _FinancialInfoPageState createState() => _FinancialInfoPageState();
}

class _FinancialInfoPageState extends State<FinancialInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red, // Background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Bank Account Type',
                style: TextStyle(
                  fontSize: 16.0, // Equivalent to @dimen/heading
                  color: Colors.white,
                  fontFamily: 'VisbyCFRegular',
                ),
              ),
              SizedBox(height: 8.0),
              Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: Text('Select Bank Account Type'),
                    items: <String>['Option 1', 'Option 2'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {},
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Bank Account Number',
                style: TextStyle(
                  fontSize: 16.0, // Equivalent to @dimen/heading
                  color: Colors.white,
                  fontFamily: 'VisbyCFRegular',
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Card(
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter Bank Account Number',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Checkbox(
                    value: false,
                    onChanged: (bool? newValue) {},
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                'Account Opening Date',
                style: TextStyle(
                  fontSize: 16.0, // Equivalent to @dimen/heading
                  color: Colors.white,
                  fontFamily: 'VisbyCFRegular',
                ),
              ),
              SizedBox(height: 8.0),
              Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Select Date',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Bank IFSC',
                style: TextStyle(
                  fontSize: 16.0, // Equivalent to @dimen/heading
                  color: Colors.white,
                  fontFamily: 'VisbyCFRegular',
                ),
              ),
              SizedBox(height: 8.0),
              Card(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter Bank IFSC Code',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Bank Name',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    Text(
                      'Bank Branch',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              Card(
                color: Colors.red, // Equivalent to @color/darkred
                child: Center(
                  child: Text(
                    'Income Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0, // Equivalent to @dimen/titleheading
                      fontFamily: 'VisbyCFBold',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Rental Income',
                style: TextStyle(
                  fontSize: 16.0, // Equivalent to @dimen/heading
                  color: Colors.white,
                  fontFamily: 'VisbyCFRegular',
                ),
              ),
              SizedBox(height: 8.0),
              Card(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter Rental Income',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              // Add other sections similarly
              // ...

              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.red,
                    textStyle: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'VisbyCFBold',
                    ),
                  ),
                  child: Text('Submit'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
