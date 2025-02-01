import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/Models/collectionstatus_model.dart';
import 'package:provider/provider.dart';

import 'api_service.dart';
import 'global_class.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CollectionStatus extends StatefulWidget {
  @override
  _CollectionStatusState createState() => _CollectionStatusState();
}

class _CollectionStatusState extends State<CollectionStatus> {
  TextEditingController _searchController = TextEditingController();
  List<Emi> emis = [];
  List<EmiCollection> emiCollections = [];

  Future<void> collectionStatus(BuildContext context, String smcode) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      EasyLoading.show(
        status: AppLocalizations.of(context)!.loading,
      );
    });
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .collectionStatus(GlobalClass.token, GlobalClass.dbName, smcode)
        .then((value) async {
      if (value.statuscode == 200) {
        EasyLoading.dismiss();
        setState(() {
          emis = value.data.emis;
          emiCollections = value.data.emiCollections;
        });
      } else {
        EasyLoading.dismiss();
        GlobalClass.showUnsuccessfulAlert(context, value.message, 1);
      }
    }).catchError((err) {
      print("ERROR: $err");
      EasyLoading.dismiss();
      GlobalClass.showErrorAlert(context, err.toString(), 1);
    });
  }

  String formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  String monthName(int monthIndex) {
    List<String> monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return monthNames[monthIndex - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),

      body: Container(

        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            SizedBox(height:50),
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
                        border:
                            Border.all(width: 1, color: Colors.grey.shade300),
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
            Card(
              color: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5), // Padding inside the Card
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align the column items to the left
                      children: [

                        Container(

                          width: MediaQuery.of(context).size.width-35, // Control the width of the TextField
                          child: TextField(
                            maxLength: 10,
                            controller: _searchController,
                            decoration: InputDecoration(
                              counterText: "",
                              hintText:  AppLocalizations.of(context)!.pleaseentercasecode,
                              filled: true, // Set the background color of the TextField
                              fillColor: Colors.white, // Set the background color to white
                              contentPadding: EdgeInsets.all(10), // Padding inside the TextField
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3), // Rounded corners
                                borderSide: BorderSide.none, // No border outline
                              ),
                              suffixIcon: IconButton( // Place the search icon at the end (right side)
                                icon: Icon(Icons.search),
                                  onPressed: () {
                                    RegExp regex = RegExp(r'^[A-Za-z]{4}\d{6}$');
                                    if(_searchController.text.isNotEmpty && regex.hasMatch(_searchController.text)) {
                                      collectionStatus(context,_searchController.text); // Call your API function here
                                    } else {
                                      GlobalClass.showErrorAlert(context,   AppLocalizations.of(context)!.pleaseentercasecode,1);
                                    }
                                  }

                              ),
                            ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(
                                    '[a-zA-Z0-9]')), // Allow only alphanumeric characters // Optional: to deny spaces
                                TextInputFormatter.withFunction(
                                      (oldValue, newValue) => TextEditingValue(
                                    text: newValue.text.toUpperCase(),
                                    selection: newValue.selection,
                                  ),
                                ),
                              ]
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Row(

                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    Padding(padding: EdgeInsets.only(left: 5,right: 5),child:     Container(


                      width: MediaQuery.of(context).size.width/2,
                      decoration: BoxDecoration(

                        gradient: LinearGradient(
                          colors: [Color(0xFFFAE3E3), Color(0xFFDFDFDF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Text(
                        '${AppLocalizations.of(context)!.installment} (${emis.length})',
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.bold),
                      ),
                    ),),
                        Expanded(
                          
                          child: ListView.builder(
                            padding: EdgeInsets.all(5),
                            itemCount: emis.length,
                            itemBuilder: (context, index) {
                              return Card(

                                elevation: 7,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    )
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: Row(
                                    children: [
                                      // Left part for Date (parallelogram-like shape)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                          ),
                                        ),
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10,top: 2,bottom: 2),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              monthName(DateTime.parse(
                                                  emis[index]
                                                      .pvNRcpDt
                                                      .toString())
                                                  .month),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                            Text(
                                              '${DateTime.parse(emis[index].pvNRcpDt.toString()).day}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '${DateTime.parse(emis[index].pvNRcpDt.toString()).year}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      // Right part for cr
                                      Expanded(
                                        child: Container(


                                          padding: EdgeInsets.only(left: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [

                                              Text(
                                                textAlign: TextAlign.left,
                                                '₹${emis[index].amt}/-',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    Padding(padding: EdgeInsets.only(left: 5,right: 5),child:     Container(

                      width: MediaQuery.of(context).size.width/2,

                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFAE3E3), Color(0xFFDFDFDF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Text(
                        '${AppLocalizations.of(context)!.pinstallment} (${emiCollections.length})',
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.bold),
                      ),
                    ),),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.all(5),
                            itemCount: emiCollections.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 7,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    )
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: Row(
                                    children: [
                                      // Left part for Date (parallelogram-like shape)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                          ),
                                        ),
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10,top: 2,bottom: 2),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              monthName(DateTime.parse(
                                                      emiCollections[index]
                                                          .vdate
                                                          .toString())
                                                  .month),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                            Text(
                                              '${DateTime.parse(emiCollections[index].vdate.toString()).day}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '${DateTime.parse(emiCollections[index].vdate.toString()).year}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      // Right part for cr
                                      Expanded(
                                        child: Container(

                                          padding: EdgeInsets.only(left: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [

                                              Text(
                                                textAlign: TextAlign.left,
                                                '₹${emiCollections[index].cr}/-',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
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
    );
  }
}

class ParallelogramClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
