import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

import 'Models/BorrowerListModel.dart';
import 'Models/GroupModel.dart';
import 'Models/branch_model.dart';

class Collection extends StatefulWidget {
  final BranchDataModel BranchData;
  final GroupDataModel GroupData;
  final BorrowerListDataModel selectedData;

  const Collection({
    super.key,
    required this.BranchData,
    required this.GroupData,
    required this.selectedData,
  });

  @override
  _CollectionState createState() => _CollectionState();
}

class _CollectionState extends State<Collection> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<bool> checkboxValues = List<bool>.filled(5, false); // Initialize with false values
  List<int> emiAmounts = List<int>.generate(5, (index) => (index + 1) * 100); // Sample EMI amounts
  int interestAmount = 100;
  int lateFee = 20;
  int totalAmount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void updateTotalAmount() {
    totalAmount = checkboxValues.asMap().entries
        .where((entry) => entry.value)
        .map((entry) => emiAmounts[entry.key])
        .fold(0, (prev, amount) => prev + amount);
    totalAmount += interestAmount + lateFee;
  }

  @override
  Widget build(BuildContext context) {
    updateTotalAmount(); // Update total amount on each build

    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 1, color: Colors.grey.shade300),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        clipBehavior: Clip.antiAlias,
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
                        'assets/Images/logo_white.png', // Replace with your logo asset path
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
              SizedBox(height: 20),
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      indicatorColor: Color(0xFFD42D3F),
                      tabAlignment: TabAlignment.fill,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(0),
                      ),
                      tabs: [
                        Tab(text: 'Cash',),
                        Tab(text: 'QR'),
                        Tab(text: 'Lump sum'),
                      ],

                    ),
                    Container(
                      height: MediaQuery.of(context).size.height - 380,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.grey.shade100, Colors.grey.shade300],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      margin: EdgeInsets.all(0), // Adjust height as needed
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          cashPaymentWidget(),
                          qrPaymentWidget(),
                          lumsumPaymentWidget(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Interest Amount: ₹$interestAmount'),
                              Text('Late Fee: ₹$lateFee'),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text('Total Amount: ₹$totalAmount'),
                          SizedBox(height: 20),
                          ElevatedButton(

                            onPressed: () {
                              // Submit button action
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent, // Make the button background transparent
                              shadowColor: Colors.transparent, // Remove the default shadow
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32), // Button padding
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8), // Rounded corners
                              ),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.grey.shade200, // Start with white
                                    Colors.grey.shade400, // Light grey end color
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(8), // Rounded corners for the gradient
                              ),
                              child: Container(
                                constraints: BoxConstraints(
                                  minHeight: 48, // Minimum height for the button
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black, // Text color
                                  ),
                                ),
                              ),
                            ),
                          )

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cashPaymentWidget() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: checkboxValues.length, // Sample item count
      itemBuilder: (context, index) {
        return Card(
          elevation: 4.0,
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              gradient: LinearGradient(
                colors: [
                  Colors.grey.shade100, // Light Grey
                  Colors.grey.shade200, // Very Light Grey
                  Colors.grey.shade300, // Lighter Grey
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListTile(
              leading: Checkbox(
                value: checkboxValues[index],
                onChanged: (value) {
                  setState(() {
                    checkboxValues[index] = value!;
                    updateTotalAmount(); // Update total amount when checkbox is changed
                  });
                },
              ),
              title: Text('EMI Amount: ₹${emiAmounts[index]}'),
              subtitle: Text('Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}'),
            ),
          ),
        );
      },
    );
  }

  Widget qrPaymentWidget() {
    return Center(
      child: Icon(
        Icons.qr_code,
        size: 200,
        color: Colors.grey,
      ),
    );
  }

  Widget lumsumPaymentWidget() {
    TextEditingController _controller = TextEditingController();

    // Function to format the input as a number with commas
    String _formatNumber(String value) {
      final formatter = NumberFormat('#,###,###,###');
      try {
        if (value.isNotEmpty) {
          return formatter.format(int.parse(value.replaceAll(',', '')));
        }
      } catch (e) {
        return value;
      }
      return value;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          AbsorbPointer(child: TextField(

            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // Only allow digits
            ],
            decoration: InputDecoration(
              labelText: 'Lump sum Amount',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              _controller.value = _controller.value.copyWith(
                text: _formatNumber(value),
                selection: TextSelection.collapsed(offset: _controller.text.length),
              );
            },
          ),),

          SizedBox(height: 16),
          // Custom Numeric Keypad with Gradient Buttons
            Padding(padding: EdgeInsets.all(8),child:  Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: 12, // 9 digits + 3 buttons (Clear, 0, 00)
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of columns
                  crossAxisSpacing: 6.0, // Reduced spacing between buttons
                  mainAxisSpacing: 6.0,  // Reduced spacing between buttons
                  childAspectRatio: 1.4, // Slightly adjusted aspect ratio
                ),
                itemBuilder: (context, index) {
                  String label;
                  if (index < 9) {
                    label = '${index + 1}';
                  } else if (index == 9) {
                    label = '0';
                  } else if (index == 10) {
                    label = 'Clear';
                  } else {
                    label = '00'; // Replacing Enter with 00
                  }

                  return GestureDetector(
                    onTap: () {
                      if (label == 'Clear') {
                        _controller.clear(); // Clear the text field
                      } else if (label == '00') {
                        String newValue = _controller.text + '00'; // Add '00' to the text
                        _controller.text = _formatNumber(newValue); // Format and update
                      } else {
                        String newValue = _controller.text + label;
                        _controller.text = _formatNumber(newValue); // Format and update
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white, // Start with white
                            Colors.grey.shade200, // Light grey
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 4.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          label,
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),) ,
        ],
      ),
    );
  }

}
