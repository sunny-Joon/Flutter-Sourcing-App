import 'package:flutter/material.dart';

class LoanEligibilityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loan Eligibility'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Circular Score Indicator
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Your Score:',
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    height: 200.0,
                    width: 200.0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: 0.0,
                          strokeWidth: 10.0,
                        ),
                        Positioned(
                          top: 20.0,
                          left: 10.0,
                          child: Text(
                            'Excellent',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                        Positioned(
                          top: 20.0,
                          right: 10.0,
                          child: Text(
                            'Very Bad',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        Positioned(
                          bottom: 20.0,
                          left: 10.0,
                          child: Text(
                            'अच्छा',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                        Positioned(
                          bottom: 20.0,
                          right: 10.0,
                          child: Text(
                            'Average',
                            style: TextStyle(color: Colors.yellow),
                          ),
                        ),
                        Text(
                          '0',
                          style: TextStyle(fontSize: 48.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Select Bank Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Select Bank*'),
                SizedBox(width: 16.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: DropdownButton<String>(
                    value: 'SBI',
                    onChanged: (String? newValue) {},
                    items: <String>['SBI', 'HDFC', 'ICICI']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              'Only 3 attempt to switch bank',
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 16.0),
            // Error Message
            Column(
              children: [
                Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 50.0,
                ),
                Text(
                  'Sorry!!',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'No rules specified for selected bank',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            // Try Again Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD42D3F),
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
              ),
              child: Text('TRY AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}
