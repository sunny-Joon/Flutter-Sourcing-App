import 'dart:convert';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_sourcing_app/Models/xml_response.dart';
import 'package:flutter_sourcing_app/api_service.dart';
import 'package:flutter_sourcing_app/Models/borrower_list_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'dart:io';

import '../../MasterAPIs/live_track_repository.dart';
import '../../Models/group_model.dart';
import '../../Models/branch_model.dart';
import '../global_class.dart';
import 'crif.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'on_boarding.dart';

class FirstEsign extends StatefulWidget {
  final BranchDataModel BranchData;
  final GroupDataModel GroupData;
  final BorrowerListDataModel selectedData;
  final int type;

  const FirstEsign({
    super.key,
    required this.BranchData,
    required this.GroupData,
    required this.selectedData,
    required this.type,
  });

  @override
  _FirstEsignState createState() => _FirstEsignState();
}

class _FirstEsignState extends State<FirstEsign> {
  String? localPath, signType;
  bool isLoading = true;
  bool _isChecked = false; // Track the state of the checkbox
  @override
  void initState() {
    super.initState();
    signType = widget.type.toString();
    fetchFirstESignPDF(widget.selectedData);
    //print("https://predeptest.paisalo.in:8084${widget.selectedData.eSignDoc.replaceAll("D:", "").replaceAll("\\", "/")}");
  }

  Future<void> _loadPdf(String url) async {
    final file = await _downloadPdf(url);
    if (file != null) {
      setState(() {
        localPath = file.path;
        isLoading = false;
      });
    }
  }

  Future<File?> _downloadPdf(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File("${directory.path}/sample.pdf");
        await file.writeAsBytes(response.bodyBytes);
        return file;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
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
            SizedBox(
              height: 20,
            ),
            Flexible(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : PDFView(
                      autoSpacing: true,
                      filePath: localPath,

                      swipeHorizontal: true,
                    ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.white, // Divider color
              thickness: 1, // Thickness of the divider
              indent: 10, // Left padding
              endIndent: 10, // Right padding
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Ficode: '.toUpperCase(),
                                style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 11,
                                    color: Colors.white),
                              ),
                              TextSpan(
                                text: "${widget.selectedData.fiCode}",
                                style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(context)!
                                    .creator
                                    .toUpperCase(),
                                style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 11,
                                    color: Colors.white),
                              ),
                              TextSpan(
                                text: "${widget.selectedData.creator}",
                                style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(context)!
                                    .name
                                    .toUpperCase(),
                                style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 11,
                                    color: Colors.white),
                              ),
                              TextSpan(
                                text: "${widget.selectedData.fullName}",
                                style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(context)!
                                    .address
                                    .toUpperCase(),
                                style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 11,
                                    color: Colors.white),
                              ),
                              TextSpan(
                                text: "${widget.selectedData.pAddress}",
                                style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
                Flexible(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        print("object ${widget.selectedData.aadharNo}");

                        if(isLoading){
                          GlobalClass.showToast_Error(
                              "Wait for pdf to get download");
                        }else {
                          if (widget.selectedData.aadharNo.isNotEmpty) {
                            showFullPageDialog(context);
                          } else {
                            GlobalClass.showToast_Error(
                                "Borrower's Aadhaar number is missing");
                          }
                        }
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: Colors.grey.shade200,
                        child: Container(
                          alignment: Alignment.center,
                          height: 45,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 4),
                            child: Text(
                              AppLocalizations.of(context)!.proceed,
                              style: TextStyle(
                                  fontFamily: "Poppins-Regular",
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  void showFullPageDialog(BuildContext context) {
    // Use a StatefulWidget to manage the dialog's state
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      // Background overlay
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Center(
            child: DialogContent(
                borrowerAdharNumber: widget.selectedData.aadharNo,
                selectedBorrower: widget.selectedData,
                signType: signType),
          ),
        );
      },
    );
  }

  Future<void> fetchFirstESignPDF(BorrowerListDataModel selectedData) async {
    print("signType $signType");
    final requestBody = {
      "F_Id": selectedData.id,
      "Type": signType == "1" ? "FirsteSign" : "SecondeSign",
      "DbName": "PDLERP",
    };

    try {
      final response = await ApiService.create(baseUrl: ApiConfig.baseUrl8)
          .getDocument(requestBody);
      if (response.statuscode == 200 && response.data.isNotEmpty) {
        print(response.data);
        _loadPdf(response.data);
      } else {
        GlobalClass.showUnsuccessfulAlert(
            context, "Pdf Not Found\nContact to Administrator", 2);
      }
    } catch (error) {
      GlobalClass.showErrorAlert(context, "Document Not Fetched", 2);
    }
  }
}

class DialogContent extends StatefulWidget {
  final String borrowerAdharNumber;
  final String? signType;
  final BorrowerListDataModel selectedBorrower;

  const DialogContent(
      {super.key,
      required this.borrowerAdharNumber,
      required this.selectedBorrower,
      required this.signType});

  @override
  _DialogContentState createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> with AutomaticKeepAliveClientMixin {
  TextEditingController _dialogAdharController = TextEditingController();
  bool _isChecked = false;
  late ApiService _apiServiceForESign, _apiServiceForESignemudra;
  //List<String> authModeTypeList = ["Biometric"];

  List<String> authModeTypeList = ["Biometric","OTP"];

  String authModeType = "Biometric";

  @override
  void initState() {
    super.initState();

    _apiServiceForESign = ApiService.create(baseUrl: ApiConfig.baseUrl7);
    _apiServiceForESignemudra = ApiService.create(baseUrl: ApiConfig.baseUrl10);
    _dialogAdharController.text = widget.borrowerAdharNumber;
    // Set up the handler to receive the result from MainActivity
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16), // Add 6 pixels margin around the dialog
      decoration: BoxDecoration(
        color: Colors.transparent, // Background color
        borderRadius: BorderRadius.circular(8), // Optional for rounded corners
      ),
      child: Card(
        color: Colors.white,
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(16.0), // Inner padding for content
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _dialogAdharController,
                  enabled: false,
                  keyboardType: TextInputType.number,
                  maxLength: 12,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Borrower Aadhaar number',
                    counterText: "", // Removes counter
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  AppLocalizations.of(context)!.readconsent,
                  style: TextStyle(
                      fontFamily: "Poppins-Regular",
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Expanded(
                  child: SingleChildScrollView(
                    child: consentText(), // Your consent text here
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: Colors.grey,
                ),
                _buildLabeledDropdownField(
                    'ESign With', 'ESign With', authModeTypeList, authModeType,
                    (String? newValue) {
                  setState(() {
                    authModeType = newValue!;
                  });
                }, String),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IntrinsicWidth(
                      // Ensure the checkbox only takes as much width as it needs
                      child: Checkbox(
                        value: _isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked = !_isChecked;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 2),
                    Flexible(
                        child: Text(
                      AppLocalizations.of(context)!.readallconsents,
                    )),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: Colors.grey.shade200,
                        child: Container(
                          alignment: Alignment.center,
                          height: 45,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 10),
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
                              style: TextStyle(
                                  fontFamily: "Poppins-Regular",
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IgnorePointer(
                      ignoring: !_isChecked,
                      child: InkWell(
                        onTap: () {
                          hitSaveAgreementsAPI(authModeType);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          color: _isChecked
                              ? Color(0xffb41d2d)
                              : Colors.grey.shade400,
                          child: Container(
                            alignment: Alignment.center,
                            height: 45,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 10),
                              child: Text(
                                AppLocalizations.of(context)!.proceed,
                                style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledDropdownField<T>(
      String labelText,
      String label,
      List<T> items,
      T? selectedValue,
      ValueChanged<T?>? onChanged,
      Type objName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<T>(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: label,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(
                  color: Colors.grey.shade400, // Border color when enabled
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(
                  color: Colors.grey, // Border color when focused
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(
                  color: Colors.grey, // Default border color
                ),
              ),
            ),
            value: selectedValue,
            items: items.map((T value) {
              String setdata = "";
              if (value is String) {
                setdata = value;
              }
              return DropdownMenuItem<T>(
                value: value,
                child: Text(setdata), // Convert the value to string for display
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  static const platform = MethodChannel('com.example.intent'); // The same channel name used in MainActivity

  //protean java method call
/*  Future<void> callJavaMethod(String xml) async {
    try {
      // Call the Java function by method name
      final String result =
          await platform.invokeMethod('callJavaFunction', xml);
      if (result != null) {
        final xmlDoc = XmlDocument.parse(result);
        final esignElement = xmlDoc.getElement('EsignResp');

        // Read the AuthMode attribute
        final errMsg = esignElement?.getAttribute('errMsg');
        final errCode = esignElement?.getAttribute('errCode');
        if (errCode?.toLowerCase() != "na") {
          GlobalClass.showUnsuccessfulAlert(
              context, "${errCode} : ${errMsg}", 1);
        } else {
          sendXMlToServer(result);
        }
      } else {
        GlobalClass.showSnackBar(context, result);
      }
    } on PlatformException catch (e) {
      print("Failed to invoke Java function: ${e.message}");
    }
  }*/

  //emudra java method call
  Future<void> callJavaMethod(String xml) async {
    try {
      final String result =
          await platform.invokeMethod('callJavaFunction', xml);
      print("object541 $result");
        if (result != null) {
          sendXMlToServer(result);
        }else{
          GlobalClass.showUnsuccessfulAlert(context, "Something went wrong", 1);
        }
     //  if (result != null) {
     //    final xmlDoc = XmlDocument.parse(result);
     //     final esignElement = xmlDoc.getElement('EsignResp');
     //
     //    // Read the AuthMode attribute
     //    final errMsg = esignElement?.getAttribute('errMsg');
     //    final errCode = esignElement?.getAttribute('errCode');
     //    final responsexml = esignElement?.getAttribute('responseXML');
     //    if (errCode?.toLowerCase() != "na") {
     //      GlobalClass.showUnsuccessfulAlert(
     //          context, "${errCode} : ${errMsg}", 1);
     //    } else {
     //      sendXMlToServer(base64EncodedResult);
     //    }
     //  } else {
     //    GlobalClass.showSnackBar(context, result);
     //  }

    } on PlatformException catch (e) {
      print("Failed to invoke Java function: ${e.message}");
    }
  }

  void parseResponse(XmlResponse xmlResponse) {
    final Content content = xmlResponse.responseMessage.content;

    // Access the headers inside content
    for (var header in content.headers) {
      print("Header: $header");
    }
  }

  //protean 2nd api
  /*
    void sendXMlToServer(String result) {
    EasyLoading.show(status: "Data sending to server...");
    try {
      _apiServiceForESign.sendXMLtoServer(result).then((value) {
        if (value.responseMessage.statusCode == 200) {
          LiveTrackRepository()
              .saveLivetrackData("", "ESign", widget.selectedBorrower.id);
          GlobalClass.showSuccessAlert(context, "ESign Has been done", 3);
          Navigator.push(
            context,
            MaterialPageRoute(
              //builder: (context) => ApplicationPage(),
              builder: (context) =>
                  LoanEligibilityPage(ficode: widget.selectedBorrower.fiCode),
            ),
          );
          //Navigator.of(context).pop();
        } else {
          /*Navigator.push(
            context,
            MaterialPageRoute(
              //builder: (context) => ApplicationPage(),
              builder: (context) =>
                  LoanEligibilityPage(ficode: 250003),
            ),
          );*/
          parseResponse(value);
          GlobalClass.showUnsuccessfulAlert(
              context, value.validationMessage, 1);
        }
      }).catchError((onError) {
        print(onError);
        GlobalClass.showToast_Error(onError);
      });
      EasyLoading.dismiss();
    } catch (err) {
      print(err);
      GlobalClass.showUnsuccessfulAlert(context, err.toString(), 1);

      EasyLoading.dismiss();
    }
  }
  * */

//emudra 2nd api
  void sendXMlToServer(String result) async {
    EasyLoading.show(status: "Data sending to server...");

    try {
      final response = await _apiServiceForESignemudra.sendXMLtoServer(result);
      print("esign1 $result");
      print("esign2 $response");

      if (response != null && response.toString().isNotEmpty) {
        int statusCode = response["responseMessage"]["statusCode"] ?? 0;
        print("esign3 $statusCode");

        if (statusCode == 200) {
          if (widget.signType == "1") {
            LiveTrackRepository().saveLivetrackData("", "1_ESign", widget.selectedBorrower.id);
            GlobalClass.showSuccessAlert(context, "1st ESign Has been done", 3);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoanEligibilityPage(ficode: widget.selectedBorrower.fiCode),
              ),
            );
          } else {
            LiveTrackRepository().saveLivetrackData(GlobalClass.smcode, "2_ESign", widget.selectedBorrower.id);
            GlobalClass.showSuccessAlertclose(context, "2nd ESign Has been done !!", 1,
              destinationPage: OnBoarding(),
            );
          }
        } else {
          handleAPIError(response);
        }
      } else {
        handleAPIError(response);
      }
    } catch (error) {
      handleAPIError(error);
    } finally {
      EasyLoading.dismiss();
    }
  }

//protean 1st api
  /*Future<void> hitSaveAgreementsAPI(String authType) async {
    EasyLoading.show(
      status: AppLocalizations.of(context)!.pleasewait,
    );

    try {
      // API call
      final xmlResponse = await _apiServiceForESign.saveAgreements(
        widget.selectedBorrower.fiCode.toString(), // Ficode
        widget.selectedBorrower.creator, // Creator
        consentRawText,
        // "1",// ConsentText
        authType == "Biometric" ? "2" : "1",
        //authType=="Biometric"?"2":"1",      // authMode
        widget.selectedBorrower.id.toString(), // F_Id
        widget.signType!, // SignType
      );
      EasyLoading.dismiss();
      if (xmlResponse is Map<String, dynamic>) {
        String responseData = xmlResponse["content"];

        if (GlobalClass.isXml(responseData)) {
          callJavaMethod(responseData);
        } else {
          GlobalClass.showErrorAlert(context, responseData, 1);
        }
        // Parse JSON object if it’s a map

        EasyLoading.dismiss();
      } else if (xmlResponse is String) {
        if (GlobalClass.isXml(xmlResponse)) {
          callJavaMethod(xmlResponse);
        } else {
          GlobalClass.showErrorAlert(context, xmlResponse, 1);
        }
      } else {
        GlobalClass.showErrorAlert(context, "Invalid data format", 1);
      }

      // Parse XML response

      // final intent = AndroidIntent(
      //   action: 'com.nsdl.egov.esign.rdservice.fp.CAPTURE',
      //   arguments: <String, dynamic>{
      //     'msg': xmlResponse,
      //     'env': 'PROD',
      //     'returnUrl': 'https://erpservice.paisalo.in:980/EsignTest/api/DocSignIn/XMLReaponse',
      //   },
      //   flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      // );

      // await intent.launch();
    } on DioError catch (e) {
      EasyLoading.dismiss();

      GlobalClass.showToast_Error('RPSSS');

     /* final statusCode = e.response?.statusCode;
      if (statusCode == 404) {
        // Handle 404 Not Found
        GlobalClass.showErrorAlert(context, e.response!.data!, 1);
        print("Error: File not found.");
        // Show message to user
      } else {
        // Handle other status codes
        GlobalClass.showErrorAlert(context, e.response!.data!, 1);
      }*/
    }
  }
*/

  //emudra 1nd api

  Future<void> hitSaveAgreementsAPI(String authType) async {
    EasyLoading.show(
      status: AppLocalizations.of(context)!.pleasewait,
    );

    // final requestBody = {
    //   "ficode":      widget.selectedBorrower.fiCode.toString(),
    //   "creator":     widget.selectedBorrower.creator,
    //   "consentText": consentRawText,
    //   "authMode":    authType == "Biometric" ? "2" : "1",
    //   "f_Id":        widget.selectedBorrower.id.toString(),
    //   "signType":    widget.signType!,
    // };

    try {
      final xmlResponse =
          await _apiServiceForESignemudra.saveAgreements(
            widget.selectedBorrower.fiCode.toString(),
            widget.selectedBorrower.creator,
            consentRawText,
            authType == "Biometric" ? "2" : "1",
            widget.selectedBorrower.id.toString(),
            widget.signType!,);
      EasyLoading.dismiss();

      if (xmlResponse != null) {
        if (xmlResponse.responseCode != null &&
            xmlResponse.responseCode.isNotEmpty) {
          callJavaMethod(xmlResponse.txnref);
        } else {
          GlobalClass.showErrorAlert(
              context, xmlResponse.message ?? "Unexpected response", 1);
        }
      } else {
        GlobalClass.showErrorAlert(
            context, "Failed to fetch response. Please try again.", 1);
      }
    } on DioError catch (e) {
      EasyLoading.dismiss();
      final statusCode = e.response?.statusCode;

      if (statusCode == 404) {
        // Handle 404 Not Found
        GlobalClass.showErrorAlert(context, "Error: File not found.", 1);
      } else if (statusCode != null) {
        // Handle other status codes
        GlobalClass.showErrorAlert(
            context, "Error: ${e.response?.data ?? 'Something went wrong'}", 1);
      } else {
        // Handle network or unknown errors
        GlobalClass.showErrorAlert(
            context, "Network error. Please check your connection.", 1);
      }
    } catch (e) {
      EasyLoading.dismiss();
      // Handle any other unexpected errors
      GlobalClass.showErrorAlert(
          context, "An unexpected error occurred: ${e.toString()}", 1);
    }
  }

  Widget consentText() {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 9.5, color: Colors.black),
        children: [
          TextSpan(
            text: AppLocalizations.of(context)!.iherebynsdl,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: AppLocalizations.of(context)!.esigntext1,
          ),
          TextSpan(
            text: AppLocalizations.of(context)!.esigntext2,
          ),
          TextSpan(
            text: AppLocalizations.of(context)!.esigntext3,
          ),
          TextSpan(
            text: AppLocalizations.of(context)!.esigntext4,
          ),
          TextSpan(
            text:AppLocalizations.of(context)!.esigntext5
            ,
          ),
        ],
      ),
    );
  }

  String consentRawText =
      "I hereby authorize NSDL e-Gov on behalf of Paisalo Digital Limited to- "
      "1. Use my Aadhaar details for Loan Document eSignature and authenticate my identity through the Aadhaar "
      "Authentication system (Aadhaar based e-KYC services of UIDAI) in accordance with the provisions of the Aadhaar "
      "(Targeted Delivery of Financial and other Subsidies, Benefits and Services) Act, 2016 and the allied rules and "
      "regulations notified thereunder and for no other purpose. "
      "2. Authenticate my Aadhaar through OTP or Biometric for authenticating my identity through the Aadhaar "
      "Authentication system for obtaining my e-KYC through Aadhaar based e-KYC services of UIDAI and use my Photo and "
      "Demographic details (Name, Gender, Date of Birth and Address) for Loan Document eSignature. "
      "3. I understand that Security and confidentiality of personal identity data provided, for the purpose of Aadhaar "
      "based authentication is ensured by NSDL e-Gov and the data will be stored by NSDL e-Gov till such time as "
      "mentioned in guidelines from UIDAI from time to time. "
      "4. I have understood that the system of downloading the copy of loan document for my record from the link "
      "provided by the company through email or SMS post e-signing of the loan document. I shall download the copy of "
      "loan documents as per my convenience at a later stage.";

  @override
  bool get wantKeepAlive => true;

  void handleAPIError(dynamic error) {
    String errorMessage = "Something went wrong. Please try again.";
    if (error is DioError && error.response != null) {
      final responseData = error.response?.data;
      if (responseData != null && responseData.containsKey("responseMessage")) {
        final responseMessage = responseData["responseMessage"];
        if (responseMessage != null && responseMessage.containsKey("statusCode")) {
          int statusCode = responseMessage["statusCode"];
          if (statusCode == 400) {
            errorMessage = responseData["validationMessage"] ??
                "Invalid request. Please check your details.";
          } else if (statusCode == 500) {
            errorMessage = "Internal Server Error";
          }
        }
      }
    }
    else if (error is Map) {
      if (error.containsKey("responseMessage") && error["responseMessage"].containsKey("statusCode")) {
        int statusCode = error["responseMessage"]["statusCode"];
        print("esign5 statusCode: $statusCode");

        if (statusCode == 400) {
          errorMessage = error["validationMessage"] ?? "Invalid request.";
        }
      }
    }
    else {
      print("Unknown error format.");
    }
    GlobalClass.showUnsuccessfulAlert(context, errorMessage, 2);
  }

}
