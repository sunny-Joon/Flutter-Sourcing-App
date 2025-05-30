import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../DATABASE/database_helper.dart';
import '../../Models/collectionborrowerlistmodel.dart';
import '../../Models/collectionbranchlistmodel.dart';
import '../../Models/range_category_model.dart';
import '../../api_service.dart';
import '../global_class.dart';
import 'collection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CollectionBorrowerList extends StatefulWidget {
  final CollectionBranchListDataModel Branchdata;

  const CollectionBorrowerList({super.key, required this.Branchdata});

  @override
  State<CollectionBorrowerList> createState() => _CollectionBorrowerListState();
}

class _CollectionBorrowerListState extends State<CollectionBorrowerList> {
  List<CollectionBorrowerListDataModel> _borrowerItems = [];
  List<RangeCategoryDataModel> reasonOfDelay = [];
  String? selectedReason;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      body: /*_isLoading
          ? Center(child: CircularProgressIndicator())*/
      /*:*/ Column(
        children: [
          SizedBox(height: 50),
          Padding(padding: EdgeInsets.all(8),
            child: Row(
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
            margin: EdgeInsets.only(bottom: 0, top: 0, left: 10, right: 10),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              style: TextStyle(
                  fontFamily: "Poppins-Regular"
              ),
              decoration: InputDecoration(

                hintText: 'Search...',
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: 10,
              itemBuilder: (context, index) => GlobalClass().ListShimmerItem(),
            )
                : getView(),
          ),
        ],
      ),
    );
  }
  Widget getView(){
    if(_borrowerItems.length>=1 && _borrowerItems[0].errormsg.isEmpty){
      return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: _borrowerItems.length,
        itemBuilder: (context, index) {
          final item = _borrowerItems[index];
          return CollectionBorrowerListItem(
            name: item.custName,
            fiCode: item.caseCode.toString(),
            //mobile: item.pPhone,
            creator: item.creator,
            // address: item.currentAddress,
             pic:item.profilePic,
            onTap: () {
              _showPayeeDialog(context, item);
              /*Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) => Collection(
                           selectedData: item,
                         ),
                       ),
                     );*/
            },
          );
        },
      );
    }else{
      return Container(height: MediaQuery.of(context).size.height/2,child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/Images/no_data.png', // Replace with your logo asset path
              height: 70,
            ),
          ),
          Center(child: Text(_borrowerItems[0].errormsg  ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 16),),)
        ],
      ),);
    }
  }
  @override
  void initState() {
    super.initState();

    fetchData();
    // if(widget.page =="E SIGN"){
    _fetchCollectionBorrowerList(1);

    // }else{
    //   _fetchBorrowerList(0);
    //   }
  }

  Future<void> fetchData() async {
    reasonOfDelay = await DatabaseHelper().selectRangeCatData("EMI Not Paying");
  }

  Future<void> _fetchCollectionBorrowerList(int type) async {
    EasyLoading.show(status: 'Loading...',);

    final apiService = ApiService.create(baseUrl: ApiConfig.baseUrl1);

    await apiService.CollectionBorrowerList(
      GlobalClass.token,
      GlobalClass.dbName,
      GlobalClass.imei,
      widget.Branchdata.focode,
      widget.Branchdata.areaCd,
      GlobalClass.EmpId,
      "2025-03-30",

    ).then((response) {
      if (response.statuscode == 200) {
        setState(() {
          _borrowerItems = response.data;
         // GlobalClass.smcode=_borrowerItems[0].caseCode;

        });
        _isLoading = false;
        print("object++12");
      } else {
        setState(() {});
        _isLoading = false;
      }
      EasyLoading.dismiss();

    }).catchError((error) {
      _isLoading = false;
      EasyLoading.dismiss();
      GlobalClass.showErrorAlert(context, error.toString(),1);
    });
  }

  void _showPayeeDialog(BuildContext context,
      CollectionBorrowerListDataModel item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Red background
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildShinyButton(
                AppLocalizations.of(context)!.emipaying,
                    () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Collection(selectedData: item),
                      // builder: (context) => Collection(),
                    ),
                  );
                },
              ),
              SizedBox(height: 5),
              Text(
                AppLocalizations.of(context)!.or,
                style: TextStyle(
                    color: Color(0xFFD42D3F), fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              _buildShinyButton(
                AppLocalizations.of(context)!.eminotpaying,
                    () {
                  _showNotPayeeDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

// Custom function to build shiny, gradient-style buttons
  Widget _buildShinyButton(String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.redAccent, Color(0xFFD42D3F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              offset: Offset(5, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black.withOpacity(0.5),
                  offset: Offset(2.0, 2.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void _showNotPayeeDialog(BuildContext context1) {
    String? selectedDropdownValue;
    DateTime? selectedDate;
    TextEditingController dateController = TextEditingController();

    showDialog(
      context: context1,
      barrierDismissible: false, // Prevent closing by clicking outside
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Prevent closing by back button
          child: AlertDialog(
            backgroundColor: Colors.white,
            contentPadding: EdgeInsets.all(0),
            titlePadding: EdgeInsets.all(0),
            title: Container(
              padding: EdgeInsets.only(left:15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFD42D3F), Colors.redAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.promisetopay,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.reasonofdelay,
                        style: TextStyle(
                          fontFamily: "Poppins-Regular",
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButton<String>(
                          hint: Text("Select"), // Show hint
                          value: selectedDropdownValue,
                          isExpanded: true,
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(
                            fontFamily: "Poppins-Regular",
                            color: Colors.black,
                            fontSize: 13,
                          ),
                          underline: Container(
                            height: 2,
                            color: Colors.transparent,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedDropdownValue = newValue;
                            });
                          },
                          items: reasonOfDelay.map<DropdownMenuItem<String>>(
                                (RangeCategoryDataModel state) {
                              return DropdownMenuItem<String>(
                                value: state.code,
                                child: Text(state.descriptionEn),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context)!.dateofpayment,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime.now(), // Only future dates
                            lastDate: DateTime(2101),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  primaryColor: Color(0xFFD42D3F),
                                  hintColor: Color(0xFFD42D3F),
                                  colorScheme: ColorScheme.light(
                                    primary: Color(0xFFD42D3F),
                                    onPrimary: Colors.white,
                                    surface: Colors.black,
                                    onSurface: Colors.red,
                                  ),
                                  dialogBackgroundColor: Colors.white,
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null && picked != selectedDate) {
                            setState(() {
                              selectedDate = picked;
                              dateController.text =
                                  DateFormat('dd/MM/yyyy').format(picked);
                            });
                          }
                        },
                        child: TextField(
                          controller: dateController,
                          enabled: false,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.black87),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today,
                                  color: Color(0xFFD42D3F)),
                              onPressed: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate ?? DateTime.now(),
                                  firstDate: DateTime.now(), // Only future dates
                                  lastDate: DateTime(2101),
                                  builder: (BuildContext context, Widget? child) {
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        primaryColor: Color(0xFFD42D3F),
                                        hintColor: Color(0xFFD42D3F),
                                        colorScheme: ColorScheme.light(
                                          primary: Color(0xFFD42D3F),
                                          onPrimary: Colors.white,
                                          surface: Colors.white,
                                          onSurface: Colors.red,
                                        ),
                                        dialogBackgroundColor: Colors.white,
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (picked != null && picked != selectedDate) {
                                  setState(() {
                                    selectedDate = picked;
                                    dateController.text =
                                        DateFormat('dd/MM/yyyy').format(picked);
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8, right: 8),
                child: _buildShinyButton(
                  AppLocalizations.of(context)!.submit,
                      () {
                    if (selectedDropdownValue == null) {
                      showToast('Please select a reason');
                      return;
                    }

                    if (selectedDate == null) {
                      showToast('Please select a date');
                      return;
                    }

                    SaveReason(context, selectedDropdownValue!, selectedDate!, context1);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> SaveReason(BuildContext context, String reason, DateTime date,
      BuildContext maincontext) async {
    EasyLoading.show(status: 'Loading...');

    final api = Provider.of<ApiService>(context, listen: false);

    Map<String, dynamic> requestBody = {
      "fi_Id": _borrowerItems[0].fi_Id,
      "reason": reason,
      "dateToPay": date.toIso8601String(),
    };
    return await api.promiseToPay(
        GlobalClass.token, GlobalClass.dbName, requestBody)
        .then((value) async {
      if (value.statuscode == 200) {
        EasyLoading.dismiss();
        GlobalClass.showSuccessAlert(maincontext, value.message, 3);
      } else {
        EasyLoading.dismiss();
        GlobalClass.showUnsuccessfulAlert(maincontext, value.message, 1);
      }
    }).catchError((err) {
      GlobalClass.showErrorAlert(maincontext, err.toString(), 1);
      EasyLoading.dismiss();
    });
  }




  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}


String transformFilePathToUrl(String filePath) {
  const String urlPrefix = 'https://predeptest.paisalo.in:8084/LOSDOC//FiDocs//';
  const String localPrefix = 'D:\\LOSDOC\\FiDocs\\';
  if (filePath.startsWith(localPrefix)) {
    // Remove the local prefix and replace with the URL prefix
    return filePath.replaceFirst(localPrefix, urlPrefix).replaceAll(
        '\\', '//');
  }
  // Return the filePath as is if it doesn't match the local prefix
  return filePath;
}

class ProfileAvatar extends StatelessWidget {
  final String? imagePath;

  ProfileAvatar({this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0), // Adjust the padding as needed
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.white,
        child: imagePath == null
            ? Icon(Icons.person, size: 40, color: Colors.grey[400]) // Icon when imagePath is null
            : ClipOval(
          child: Image.network(
            imagePath!,
            fit: BoxFit.cover,
            width: 80,
            height: 80,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.person, size: 40, color: Colors.grey[400]); // Fallback to icon on error
            },
          ),
        ),
      ),
    );
  }
}

class CollectionBorrowerListItem extends StatelessWidget {
  final String name;
  final String fiCode;
  final String creator;
  final String? pic; // Update this to be nullable
  final VoidCallback onTap; // Callback for the onTap event

  CollectionBorrowerListItem({
    required this.name,
    required this.fiCode,
    required this.creator,
    required this.onTap, // Initialize the onTap callback
    this.pic, // Initialize the pic, now nullable
  });

  @override
  Widget build(BuildContext context) {
    String? imageUrl;
    if (pic != null) {
      imageUrl =pic;// transformFilePathToUrl(pic!);
      print("imageUrl $imageUrl");
      print("pic $pic");
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade900, Colors.redAccent.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            ProfileAvatar(imagePath: imageUrl),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${AppLocalizations.of(context)!.casecode} $fiCode',
                    style: TextStyle(fontFamily: "Poppins-Regular",
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '${AppLocalizations.of(context)!.creator} $creator',
                    style: TextStyle(fontFamily: "Poppins-Regular",
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white70),
          ],
        ),
      ),
    );
  }


}





