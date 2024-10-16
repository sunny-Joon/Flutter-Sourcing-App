import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ApiService.dart';
import 'DATABASE/DatabaseHelper.dart';
import 'GlobalClass.dart';
import 'Models/BorrowerListModel.dart';
import 'Models/RangeCategoryModel.dart';

class FinancialInfoPage extends StatefulWidget {
  final BorrowerListDataModel borrower;
  FinancialInfoPage({required this.borrower});

  @override
  _FinancialInfoPageState createState() => _FinancialInfoPageState();
}

class _FinancialInfoPageState extends State<FinancialInfoPage> {
  List<RangeCategoryDataModel> bank_ac_type = [];
  List<RangeCategoryDataModel> rooftype = [];
  List<RangeCategoryDataModel> housetype = [];
  List<RangeCategoryDataModel> toilettype = [];

  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();
  final TextEditingController _rentalIncomeController = TextEditingController();
  final TextEditingController _expenseInRentController = TextEditingController();
  final TextEditingController _expenseForFoodController = TextEditingController();
  final TextEditingController _expenseForEducationController = TextEditingController();
  final TextEditingController _expenseForHealthController = TextEditingController();
  final TextEditingController _expenseForTravellingController = TextEditingController();
  final TextEditingController _expenseForEntertainmentController = TextEditingController();
  final TextEditingController _otherExpenseController = TextEditingController();
  String? selectedHouseType;
  String? selectedRoofType;
  String? SelectedpersonalToilet;
  String? selectedOption = GlobalClass.storeValues[0];
  String? selectedBankAccType;

  @override
  void initState() {
    super.initState();
    fetchStates(); // Fetch states using the required cat_key
  }

  Future<void> fetchStates() async {
    bank_ac_type = await DatabaseHelper()
        .selectRangeCatData("bank_ac_type"); // Call your SQLite method
    rooftype = await DatabaseHelper()
        .selectRangeCatData("house-roof-type"); // Call your SQLite method
    housetype = await DatabaseHelper()
        .selectRangeCatData("house-type"); // Call your SQLite method
    toilettype = await DatabaseHelper()
        .selectRangeCatData("toilet-type"); // Call your SQLite method

    setState(() {}); // Refresh the UI
  }

  @override
  void dispose() {
    super.dispose();
    _accountNumberController.dispose();
    _dateController.dispose();
    _ifscCodeController.dispose();
    _rentalIncomeController.dispose();
    _expenseInRentController.dispose();
    _expenseForFoodController.dispose();
    _expenseForEducationController.dispose();
    _expenseForHealthController.dispose();
    _expenseForTravellingController.dispose();
    _expenseForEntertainmentController.dispose();
    _otherExpenseController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Financial Info'),
        backgroundColor: Colors.red,
      ),
      backgroundColor: Color(0xFFd32f2f), // Background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildCardField(
                context,
                'Bank Account Type',
                bank_ac_type,
                    (value) => setState(() {
                  selectedBankAccType = value?.descriptionEn;
                  if (selectedBankAccType == 'Saving') {
                    selectedBankAccType = 'sa';
                  }
                }),
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
                        controller: _accountNumberController,
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
                        controller: _dateController,
                        decoration: InputDecoration(
                          hintText: 'Select Date',
                          border: OutlineInputBorder(),
                        ),
                        enabled: false, // Disable the TextFormField
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          String formattedDate =
                          "${pickedDate.toLocal()}".split(' ')[0];
                          setState(() {
                            _dateController.text =
                                formattedDate; // Set the selected date
                          });
                        }
                      },
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
                      controller: _ifscCodeController,
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
                color: Colors.red[900], // Equivalent to @color/darkred
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
                  controller: _rentalIncomeController,
                  decoration: InputDecoration(
                    hintText: 'Enter Rental Income',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 8.0),
              Card(
                color: Colors.red[900], // Equivalent to @color/darkred
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Expense Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0, // Equivalent to @dimen/titleheading
                        fontFamily: 'VisbyCFBold',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Expenses in Rent',
                style: TextStyle(
                  fontSize: 16.0, // Equivalent to @dimen/heading
                  color: Colors.white,
                  fontFamily: 'VisbyCFRegular',
                ),
              ),
              SizedBox(height: 8.0),
              Card(
                child: TextFormField(
                  controller: _expenseInRentController,
                  decoration: InputDecoration(
                    hintText: 'Enter Rent Expenses',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              // Add other sections similarly
              SizedBox(height: 8.0),
              Text(
                'Expenses for Food',
                style: TextStyle(
                  fontSize: 16.0, // Equivalent to @dimen/heading
                  color: Colors.white,
                  fontFamily: 'VisbyCFRegular',
                ),
              ),
              SizedBox(height: 8.0),
              Card(
                child: TextFormField(
                  controller: _expenseForFoodController,
                  decoration: InputDecoration(
                    hintText: 'Enter Food Expenses',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Expenses for Education',
                style: TextStyle(
                  fontSize: 16.0, // Equivalent to @dimen/heading
                  color: Colors.white,
                  fontFamily: 'VisbyCFRegular',
                ),
              ),
              SizedBox(height: 8.0),
              Card(
                child: TextFormField(
                  controller: _expenseForEducationController,
                  decoration: InputDecoration(
                    hintText: 'Enter Education Expenses',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Expenses for Health',
                style: TextStyle(
                  fontSize: 16.0, // Equivalent to @dimen/heading
                  color: Colors.white,
                  fontFamily: 'VisbyCFRegular',
                ),
              ),
              SizedBox(height: 8.0),
              Card(
                child: TextFormField(
                  controller: _expenseForHealthController,
                  decoration: InputDecoration(
                    hintText: 'Enter Health Expenses',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Expenses for Travelling',
                style: TextStyle(
                  fontSize: 16.0, // Equivalent to @dimen/heading
                  color: Colors.white,
                  fontFamily: 'VisbyCFRegular',
                ),
              ),
              SizedBox(height: 8.0),
              Card(
                child: TextFormField(
                  controller: _expenseForTravellingController,
                  decoration: InputDecoration(
                    hintText: 'Enter Travelling Expenses',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Expenses for Entertainment',
                style: TextStyle(
                  fontSize: 16.0, // Equivalent to @dimen/heading
                  color: Colors.white,
                  fontFamily: 'VisbyCFRegular',
                ),
              ),
              SizedBox(height: 8.0),
              Card(
                child: TextFormField(
                  controller: _expenseForEntertainmentController,
                  decoration: InputDecoration(
                    hintText: 'Enter Entertainment Expenses',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Other Expenses',
                style: TextStyle(
                  fontSize: 16.0, // Equivalent to @dimen/heading
                  color: Colors.white,
                  fontFamily: 'VisbyCFRegular',
                ),
              ),
              SizedBox(height: 8.0),
              Card(
                child: TextFormField(
                  controller: _otherExpenseController,
                  decoration: InputDecoration(
                    hintText: 'Enter Other Expenses',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 16.0),
              buildCardField(
                context,
                'House Type',
                housetype,
                    (value) => setState(() {
                  selectedHouseType = value?.descriptionEn;
                }),
              ),
              SizedBox(height: 16.0),
              buildCardField(
                context,
                'Roof Type',
                rooftype,
                    (value) => setState(() {
                      selectedRoofType = value?.descriptionEn;
                }),
              ),
              SizedBox(height: 16.0),
              buildCardField(
                context,
                'Bank Account Type',
                toilettype,
                    (value) => setState(() {
                      SelectedpersonalToilet = value?.descriptionEn;
                }),
              ),
              SizedBox(height: 16.0),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    updateFinance(context);
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCardField(BuildContext context, String title,
      List<RangeCategoryDataModel> options, ValueChanged<RangeCategoryDataModel?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.0, // Equivalent to @dimen/heading
            color: Colors.white,
            fontFamily: 'VisbyCFRegular',
          ),
        ),
        SizedBox(height: 8.0),
        Card(
          child: DropdownButtonFormField<RangeCategoryDataModel>(
            value: options.isEmpty ? null : options[0],
            items: options.map((RangeCategoryDataModel model) {
              return DropdownMenuItem<RangeCategoryDataModel>(
                value: model,
                child: Text(model.descriptionEn),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> updateFinance(BuildContext context) async {
    Map<String, dynamic> requestBody = {
      "fiCode": widget.borrower.code,
      "creator": widget.borrower.creator,
      "tag": "RTAG",
      "bankAccountType": selectedBankAccType,
      "bankAccNumber": _accountNumberController.text,
      "accOpeningDate": _dateController.text,
      "ifscCode": _ifscCodeController.text,
      "rentalIncome": _rentalIncomeController.text,
      "expenseInRent": _expenseInRentController.text,
      "expenseForFood": _expenseForFoodController.text,
      "expenseForEducation": _expenseForEducationController.text,
      "expenseForHealth": _expenseForHealthController.text,
      "expenseForTravelling": _expenseForTravellingController.text,
      "expenseForEntertainment": _expenseForEntertainmentController.text,
      "otherExpense": _otherExpenseController.text,
      "houseType": selectedHouseType,
      "roofType": selectedRoofType,
      "personalToilet": SelectedpersonalToilet,
      "livingWSpouse": "Y",
      "BankAddress": "sdg"
    };
    final api2 = Provider.of<ApiService>(context, listen: false);

    // Update the personal details using the API
    final response = await api2.updateFinance(
        GlobalClass.token, GlobalClass.dbName, requestBody);

    if (response.statusCode == 200) {
      // Handle successful update
      GlobalClass().showSuccessAlert(context);
    } else {
      // Handle failed update
      GlobalClass().showUnsuccessfulAlert(context);
    }
  }
}
