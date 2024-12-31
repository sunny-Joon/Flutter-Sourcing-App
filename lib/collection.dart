import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/Models/collectionborrowerlistmodel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'Models/getCollectionModel.dart';
import 'api_service.dart';
import 'global_class.dart';

class Collection extends StatefulWidget {

  final CollectionBorrowerListDataModel selectedData;

  const Collection({
    super.key,
    required this.selectedData,
  });

  @override
  _CollectionState createState() => _CollectionState();
}

class _CollectionState extends State<Collection> with SingleTickerProviderStateMixin {
  TextEditingController _controllerLumpSum = TextEditingController();

  late TabController _tabController;
  List<bool> checkboxValues = []; // Initialize with false values
  late List<int> emiAmounts; // Sample EMI amounts
  double interestAmount = 0;
  double lateFee = 0;
  double totalAmount = 0;
  late String casecode="",borrower = "";
  late String qrCodeUrl="";
  late GetCollectionDataModel collectionDataModel;
  String buttonName = "Submit";
  double showingTotalAmout=0;
  double LumpSumTotalAmt=0;

  @override
  void initState() {
    super.initState();
    print("QR tab opened");

      setValues();
     getQr(context);
   emiAmounts = widget.selectedData.instData.map((inst) => int.parse(inst.amount)).toList();
   checkboxValues = List<bool>.filled(emiAmounts.length, false);
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {

        if (_tabController.index == 1) {
          print("QR tab opened");
          setState(() {
            buttonName = "Check Payment Status";
          });

        }else if (_tabController.index == 2){
          setState(() {
            buttonName = "Submit Lump Sum";
           showingTotalAmout= int.parse(_controllerLumpSum.text.isEmpty?"0":_controllerLumpSum.text.replaceAll(",", ""))+lateFee+interestAmount;
          });
        }else{
          setState(() {
            buttonName = "Submit";
          });
        }
    });
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
    showingTotalAmout=totalAmount;

  }

  @override
  Widget build(BuildContext context) {
   updateTotalAmount(); // Update total amount on each build

    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 24.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 25,bottom: 8),
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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: 'Case Code: ', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)), // Static text color
                          TextSpan(text: casecode, style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)), // Dynamic text color
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height/2,
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
                              Flexible(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: 'Borrower: ', style: TextStyle(color: Colors.black)), // Static text color
                                      TextSpan(text: borrower, style: TextStyle(color: Colors.green)), // Dynamic text color
                                    ],
                                  ),
                                  maxLines: 2, // Allow text to wrap to a second line if necessary
                                  overflow: TextOverflow.ellipsis, // Handle overflow gracefully
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(text: 'Interest Amount: ₹', style: TextStyle(color: Colors.black)), // Static text color
                                    TextSpan(text: interestAmount.toString(), style: TextStyle(color: Colors.green)), // Dynamic text color
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(text: 'Late Fee: ₹', style: TextStyle(color: Colors.black)), // Static text color
                                    TextSpan(text: lateFee.toString(), style: TextStyle(color: Colors.green)), // Dynamic text color
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: 'Total Amount: ₹', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)), // Static text color
                                TextSpan(text: "$showingTotalAmout", style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)), // Dynamic text color
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if(buttonName == "Submit"){
                                saveReceipt(context,0);
                              }else if(buttonName == "Check Payment Status"){

                              }else if(buttonName == "Submit Lump Sum"){
                                saveReceipt(context,1);
                              }
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
                                  buttonName,
                                  style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 16,
                                    color: Colors.black, // Text color
                                  ),
                                ),
                              ),
                            ),
                          ),
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
      itemCount: checkboxValues.length,
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
             subtitle: Text('Due Date: ${widget.selectedData.instData[index].dueDate}'),
            ),
          ),
        );
      },
    );
  }

  Widget qrPaymentWidget() {
    return Center(
      child: Image.network(
        qrCodeUrl,
        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
          return Icon(
            Icons.qr_code,
            size: 200,
            color: Colors.grey,
          );
        },
      ),
    );
  }

  Widget lumsumPaymentWidget() {

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
            maxLength: 7,
            readOnly: true,
            controller: _controllerLumpSum,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // Only allow digits
            ],
            decoration: InputDecoration(
              counterText: "",
              labelText: 'Lump sum Amount',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              print(LumpSumTotalAmt);

              _controllerLumpSum.value = _controllerLumpSum.value.copyWith(
                text: _formatNumber(value),
                selection: TextSelection.collapsed(offset: _controllerLumpSum.text.length),

              );


            },
          ),),

          SizedBox(height: 16),

          // Custom Numeric Keypad with Gradient Buttons
          Padding(padding: EdgeInsets.all(8),child:  Expanded( // Fixed height to ensure it fits within the available space
            child: GridView.builder(
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
              itemCount: 12, // 9 digits + 3 buttons (Clear, 0, 00)
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of columns
                crossAxisSpacing: 5.0, // Reduced spacing between buttons
                mainAxisSpacing: 9.0,  // Reduced spacing between buttons
                childAspectRatio: 1.8, // Slightly adjusted aspect ratio

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
                      _controllerLumpSum.clear(); // Clear the text field
                    } else if (label == '00') {
                      String newValue = _controllerLumpSum.text + '00'; // Add '00' to the text
                      _controllerLumpSum.text = _formatNumber(newValue); // Format and update
                    } else {
                      String newValue = _controllerLumpSum.text + label;
                      _controllerLumpSum.text = _formatNumber(newValue); // Format and update
                    }
                    setState(() {
                      LumpSumTotalAmt=int.parse(_controllerLumpSum.text.isEmpty?"0":_controllerLumpSum.text.replaceAll(",", ""))+lateFee+interestAmount;
                      print("LumpSumTotalAmt $LumpSumTotalAmt");
                      showingTotalAmout=LumpSumTotalAmt;
                    });
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
                        style: TextStyle(
                          fontFamily: "Poppins-Regular",
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),

                  ),
                );
              },
            ),
          ),
          )
        ],
      ),
    );
  }

 void setValues() {
    setState(() {
      interestAmount=widget.selectedData.interestAmt;
      borrower=widget.selectedData.custName;
      casecode=widget.selectedData.caseCode;
      totalAmount=widget.selectedData.totalDueAmt;
    });
  }



  Future<void> saveReceipt(BuildContext context,int paymentType) async {
    EasyLoading.show(status: 'Loading...');

    final api = Provider.of<ApiService>(context, listen: false);
    Map<String, dynamic> requestBody = {
      "VDATE":"2024-11-30",
        "InstRcvID": 120,
        "IMEI": GlobalClass.imei,
        "CaseCode": widget.selectedData.caseCode,
        "RcptNo": 1001,
        "InstRcvAmt": paymentType==0?totalAmount.toInt():showingTotalAmout,
        "InstRcvDateTimeUTC":  "2024-11-29T10:22:27",
        "Flag": "E",
        "CreationDate": "2024-11-29T10:22:27",
        "BatchNo": 1,
        "BatchDate": "2024-11-29T00:00:00",
        "FoCode": GlobalClass.userName,
        "DataBaseName": GlobalClass.databaseName,
        "Creator": GlobalClass.creator,
        "CustName": widget.selectedData.custName,
        "PartyCd": widget.selectedData.caseCode,
        "PayFlag": "E",
        "SmsMobNo": widget.selectedData.mobile,
        "InterestAmt":widget.selectedData.interestAmt.toInt(),
        "CollPoint": "FIELD",
        "PaymentMode": "CASH",
        "collBranchCode": widget.selectedData.groupCode,
        "txnId": "TXN123456",
        "TransactionId": "TRANS123456"
    };
    return await api.RcPosting(GlobalClass.token, GlobalClass.dbName,requestBody)
        .then((value) async {
      if (value.statuscode == 200) {
        EasyLoading.dismiss();
        GlobalClass.showSuccessAlert(context, value.message, 2);
      }else {
        EasyLoading.dismiss();
        GlobalClass.showUnsuccessfulAlert(context, value.message, 1);
      }
    }).catchError((err) {
      EasyLoading.dismiss();
      GlobalClass.showErrorAlert(context, err, 1);
    });
  }

  Future<void> getQr(BuildContext context) async {
    EasyLoading.show(status: 'Loading...');

    final api = Provider.of<ApiService>(context, listen: false);

    return await api.QrGeneration(GlobalClass.token, GlobalClass.dbName,widget.selectedData.caseCode/*widget.selectedData.caseCode*/,"Link")
        .then((value) async {
      if (value.statuscode == 200) {
        EasyLoading.dismiss();
        setState(() {
          qrCodeUrl = value.data[0].qrCodeUrl;
        });
      }else {
        EasyLoading.dismiss();
        GlobalClass.showUnsuccessfulAlert(context, "${value.message} (QR Code)", 1);
      }
    }).catchError((err) {
      EasyLoading.dismiss();
      GlobalClass.showErrorAlert(context, "Server side Error", 1);
    });
  }
}
