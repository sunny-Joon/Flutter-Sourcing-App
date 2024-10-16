import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ApiService.dart';
import 'DATABASE/DatabaseHelper.dart';
import 'GlobalClass.dart';
import 'Models/BorrowerListModel.dart';
import 'Models/RangeCategoryModel.dart';

class FamilyBorrowings extends StatefulWidget {
  final BorrowerListDataModel borrower;
  FamilyBorrowings({required this.borrower});

  @override
  _FamilyBorrowingsState createState() => _FamilyBorrowingsState();
}

class _FamilyBorrowingsState extends State<FamilyBorrowings> {
  List<RangeCategoryDataModel> loanUsedBy = [];
  List<RangeCategoryDataModel> reasonForLoan = [];

  final TextEditingController _lendernameController = TextEditingController();
  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _emiAmountController = TextEditingController();
  final TextEditingController _balanceAmountController = TextEditingController();


  String? selectedOption = GlobalClass.storeValues[0];

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch states using the required cat_key
  }

  Future<void> fetchData() async {
    loanUsedBy = await DatabaseHelper().selectRangeCatData("relationship"); // Call your SQLite method
    reasonForLoan = await DatabaseHelper().selectRangeCatData("loan_purpose"); // Call your SQLite method

    setState(() {}); // Refresh the UI
  }
  String? SelectedloanUsedBy;
  String? SelectedreasonForLoan;
  String? SelectedisMFI;
  String? SelectedlenderType;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Family Borrowings'),
          backgroundColor: Colors.red,
        ),
        backgroundColor: Color(0xFFd32f2f),
        body: Padding(
          padding: EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Lender Name',
                  style: TextStyle(color: Colors.white),
                ),
                Card(
                  elevation: 2,
                  child: TextFormField(
                    controller: _lendernameController,
                    decoration: InputDecoration(
                      hintText: 'Lender Name',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(10.0),
                    ),
                    textCapitalization: TextCapitalization.characters,
                  ),
                ),
                SizedBox(height: 5.0),
                buildCardField2(
                  context,
                  'Lender Type',
                  GlobalClass.lenderType, // Replace with actual values
                  (value) => SelectedlenderType = value,
                ),
                SizedBox(height: 5.0),
                buildCardField(
                  context,
                  'Loan Used By',
                  loanUsedBy, // Replace with actual values
                  (value) => SelectedloanUsedBy = value?.descriptionEn,
                ),
                SizedBox(height: 5.0),
                buildCardField(
                  context,
                  'Reason For Loan',
                  reasonForLoan, // Replace with actual values
                  (value) => SelectedreasonForLoan = value?.descriptionEn,
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Loan Amount',
                            style: TextStyle(color: Colors.white),
                          ),
                          Card(
                            elevation: 2,
                            margin: EdgeInsets.all(2.0),
                            child: TextFormField(
                              controller: _loanAmountController,
                              decoration: InputDecoration(
                                hintText: 'Loan Amount',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(10.0),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'EMI Amount',
                            style: TextStyle(color: Colors.white),
                          ),
                          Card(
                            elevation: 2,
                            margin: EdgeInsets.all(2.0),
                            child: TextFormField(
                              controller: _emiAmountController,
                              decoration: InputDecoration(
                                hintText: 'EMI Amount',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(10.0),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Balance Amount',
                            style: TextStyle(color: Colors.white),
                          ),
                          Card(
                            elevation: 2,
                            margin: EdgeInsets.all(2.0),
                            child: TextFormField(
                              controller: _balanceAmountController,
                              decoration: InputDecoration(
                                hintText: 'Balance Amount',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(10.0),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: buildCardField2(
                        context,
                        'Is MFI',
                        GlobalClass.storeValues, // Replace with actual values
                        (value) => SelectedisMFI = value,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          UpdateFIFamLoans(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Text('Add/Update'),
                      ),
                    ),
                    SizedBox(width: 2.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildCardField(
      BuildContext context,
      String label,
      List<RangeCategoryDataModel> items,
      ValueChanged<RangeCategoryDataModel?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'VisbyCFRegular',
            ),
          ),
          SizedBox(height: 8),
          Card(
            elevation: 4,
            margin: EdgeInsets.zero,
            child: DropdownButtonFormField<RangeCategoryDataModel>(
              items: items.map((RangeCategoryDataModel value) {
                return DropdownMenuItem<RangeCategoryDataModel>(
                  value: value,
                  child: Text(value.descriptionEn),
                );
              }).toList(),
              onChanged: onChanged,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                hintText:'Please select $label'
              ),
              validator: (value) {
                if (value == null) {
                  return 'Please select $label';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCardField2(BuildContext context, String label, List<String> items,
      ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'VisbyCFRegular',
            ),
          ),
          SizedBox(height: 8),
          Card(
            elevation: 4,
            margin: EdgeInsets.zero,
            child: DropdownButtonFormField<String>(
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: 'Please select $label',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
              validator: (value) {
                if (value == null) {
                  return 'Please select $label';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }




  Future<void> UpdateFIFamLoans(BuildContext context) async {

    Map<String, dynamic> requestBody = {
    "fiCode": widget.borrower.code,
    "creator": widget.borrower.creator,
    "tag": "RTAG",
    "lenderName":_lendernameController.text,
    "lenderType":SelectedlenderType,
    "loanUsed":SelectedloanUsedBy,
    "reasonForLoan":SelectedreasonForLoan,
    "loanAmount":_loanAmountController.text,
    "emiAmount":_emiAmountController.text,
    "balanceAmount":_balanceAmountController.text,
    "isMFI":SelectedisMFI.toString(),
    "autoID":0
    };

    final api2 = Provider.of<ApiService>(context, listen: false);

    // Update the personal details using the API
    final response = await api2.updateFamLoans(GlobalClass.token, GlobalClass.dbName, requestBody);

    if (response.statusCode == 200) {
      // Handle successful update
      GlobalClass().showSuccessAlert(context);
    } else {
      // Handle failed update
      GlobalClass().showUnsuccessfulAlert(context);
    }
  }

}
