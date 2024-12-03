import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_sourcing_app/ApiService.dart';
import 'package:flutter_sourcing_app/GlobalClass.dart';
import 'package:flutter_sourcing_app/Models/BorrowerListModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'dart:io';


import 'MasterAPIs/live_track_repository.dart';
import 'Models/GroupModel.dart';
import 'Models/branch_model.dart';

class FirstEsign extends StatefulWidget {

  final BranchDataModel BranchData;
  final GroupDataModel GroupData;
  final BorrowerListDataModel selectedData;

  const FirstEsign({
    super.key,
    required this.BranchData,
    required this.GroupData,
    required this.selectedData,
  });
  @override
  _FirstEsignState createState() => _FirstEsignState();
}

class _FirstEsignState extends State<FirstEsign> {

  String? localPath;
  bool isLoading = true;
  bool _isChecked = false; // Track the state of the checkbox
  @override
  void initState() {
    super.initState();
    print("https://predeptest.paisalo.in:8084${widget.selectedData.downloadLink.replaceAll("D:", "").replaceAll("\\", "/")}.pdf");
    _loadPdf("https://predeptest.paisalo.in:8084${widget.selectedData.downloadLink.replaceAll("D:", "").replaceAll("\\", "/")}.pdf");
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
      body:Padding(padding: EdgeInsets.all(8),child:  Column(
        children: [
          SizedBox(height: 50,),
          Row(
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
          SizedBox(height: 20,),

          Flexible(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : PDFView(
              filePath: localPath,
            ),
          ),
          SizedBox(height: 10,),
          Divider(
            color: Colors.white, // Divider color
            thickness: 1, // Thickness of the divider
            indent: 10, // Left padding
            endIndent: 10, // Right padding
          )
          ,          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  flex: 3,
                  child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Ficode: '.toUpperCase(),
                          style: TextStyle(fontFamily: "Poppins-Regular",fontSize: 11,color: Colors.white),
                        ),
                        TextSpan(
                          text: "${widget.selectedData.fiCode}",
                          style: TextStyle(fontFamily: "Poppins-Regular",fontSize: 13, color: Colors.white,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Creator: '.toUpperCase(),
                          style: TextStyle(fontFamily: "Poppins-Regular",fontSize: 11,color: Colors.white),
                        ),
                        TextSpan(
                          text: "${widget.selectedData.creator}",
                          style: TextStyle(fontFamily: "Poppins-Regular",fontSize: 13, color: Colors.white,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Name: '.toUpperCase(),
                          style: TextStyle(fontFamily: "Poppins-Regular",fontSize: 11,color: Colors.white),
                        ),
                        TextSpan(
                          text: "${widget.selectedData.fullName}",
                          style: TextStyle(fontFamily: "Poppins-Regular",fontSize: 13, color: Colors.white,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Address: '.toUpperCase(),
                          style: TextStyle(fontFamily: "Poppins-Regular",fontSize: 11,color: Colors.white),
                        ),
                        TextSpan(
                          text: "${widget.selectedData.pAddress}",
                          style: TextStyle(fontFamily: "Poppins-Regular",fontSize: 13, color: Colors.white,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )


                ],) )
              ,

              Flexible(
                 flex: 1,
                 child:   InkWell(
                   onTap: (){
                     if(widget.selectedData.aadhar_no!=null){
                       showFullPageDialog(context);
                     }else{
                       GlobalClass.showToast_Error("Borrower's Aadhaar number is missing");
                     }

                   },
               child:Card(
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                 color: Colors.grey.shade200,
                 child: Container(
                   alignment: Alignment.center,
                   height: 45,
                   child: Padding(padding: EdgeInsets.symmetric(vertical: 4,horizontal: 10),child: Text("Proceed",style: TextStyle(fontFamily: "Poppins-Regular",color: Colors.black),),),
                 ),
               ),
             ))

            ],
          ),
          SizedBox(height: 10,),
        ],
      ),),
    );
  }

  void showFullPageDialog(BuildContext context) {
    // Use a StatefulWidget to manage the dialog's state
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5), // Background overlay
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Center(
            child: DialogContent(borrowerAdharNumber: widget.selectedData.aadhar_no,selectedBorrower: widget.selectedData,),
          ),
        );
      },
    );
  }







}

class DialogContent extends StatefulWidget {
  final String borrowerAdharNumber;
  final BorrowerListDataModel selectedBorrower;

  const DialogContent({super.key, required this.borrowerAdharNumber, required this.selectedBorrower});
  @override
  _DialogContentState createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  TextEditingController _dialogAdharController = TextEditingController();
  bool _isChecked = false;
  late ApiService _apiServiceForESign;
  List<String> authModeTypeList = ["Biometric","OTP"];
  String authModeType="Biometric";

  @override
  void initState() {

    super.initState();
    _apiServiceForESign=ApiService.create(baseUrl: ApiConfig.baseUrl7);

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
                  "Please Read Below Consent before Proceed",
                  style: TextStyle(fontFamily: "Poppins-Regular",fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Expanded(

                  child: SingleChildScrollView(

                    child: consentText(), // Your consent text here
                  ),
                ),

                Divider(thickness: 2,color: Colors.grey,),
                _buildLabeledDropdownField('ESign With', 'ESign With',authModeTypeList,authModeType,(String? newValue) {
                  setState(() {
                    authModeType = newValue!;
                  });
                },String),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IntrinsicWidth( // Ensure the checkbox only takes as much width as it needs
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
                    Flexible(child: Text("I have read all the consents properly")),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){
                          Navigator.of(context).pop();
                      },
                      child:Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        color: Colors.grey.shade200,
                        child: Container(
                          alignment: Alignment.center,
                          height: 45,
                          child: Padding(padding: EdgeInsets.symmetric(vertical: 4,horizontal: 10),child: Text("Cancel",style: TextStyle(fontFamily: "Poppins-Regular",color: Colors.black),),),
                        ),
                      ),
                    ),
                    IgnorePointer(
                      ignoring: !_isChecked,
                      child: InkWell(

                        onTap: (){

                          hitSaveAgreementsAPI(authModeType);
                        },
                        child:Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          color: _isChecked?Color(0xffb41d2d):Colors.grey.shade400,
                          child: Container(
                            alignment: Alignment.center,
                            height: 45,
                            child: Padding(padding: EdgeInsets.symmetric(vertical: 4,horizontal: 10),child: Text("Proceed",style: TextStyle(fontFamily: "Poppins-Regular",color: Colors.white),),),
                          ),
                        ),
                      ),
                    )
                    ,
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
      String labelText, String label, List<T> items, T? selectedValue, ValueChanged<T?>? onChanged,Type objName) {
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
              String setdata="";
            if(value is String){
                setdata=value;
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

  // Call a method in MainActivity
  Future<void> callJavaMethod(String xml) async {
    try {
      // Call the Java function by method name
      final String result = await platform.invokeMethod('callJavaFunction',xml);
          if(GlobalClass.isXml(result)){
            final xmlDoc = XmlDocument.parse(result);
            final esignElement = xmlDoc.getElement('EsignResp');

            // Read the AuthMode attribute
            final errMsg = esignElement?.getAttribute('errMsg');
            final errCode = esignElement?.getAttribute('errCode');
            if(errCode?.toLowerCase()!="na" )
              {
                GlobalClass.showUnsuccessfulAlert(context, "${errCode} : ${errMsg}", 1);
              }else{
              sendXMlToServer(result);

            }

          }else{
            GlobalClass.showSnackBar(context, result);
          }
    } on PlatformException catch (e) {
      print("Failed to invoke Java function: ${e.message}");
    }
  }
  void sendXMlToServer(String result) {
    EasyLoading.show(status: "Data sending to server...");
    try{
      _apiServiceForESign.sendXMLtoServer(result).then((value){
        if(value.statusCode==200){
          LiveTrackRepository().saveLivetrackData( "",   "ESign",widget.selectedBorrower.id);
          GlobalClass.showSuccessAlert(context,"ESign Has been done",3);
          //Navigator.of(context).pop();
        }else{
          GlobalClass.showUnsuccessfulAlert(context,"ESign Has not been done",1);

        }
      }).catchError((onError){
        print(onError);
        GlobalClass.showToast_Error(onError);
      });
EasyLoading.dismiss();
    }catch(err){
      print(err);
      GlobalClass.showUnsuccessfulAlert(context,err.toString(),1);

      EasyLoading.dismiss();

    }

  }
  Future<void> hitSaveAgreementsAPI(String authType) async {
    EasyLoading.show(status: "Please wait....");

    try {
      // API call
      final xmlResponse = await _apiServiceForESign.saveAgreements(
        "250069", // Ficode
        "hoagra", // Creator
        consentRawText,   // ConsentText
        authType=="Biometric"?"2":"1",      // authMode
        "1",      // F_Id
        "1",      // SignType
      );
    EasyLoading.dismiss();
      if (xmlResponse is Map<String, dynamic>) {
        String responseData = xmlResponse["content"];

        if(GlobalClass.isXml(responseData)){
          callJavaMethod(responseData);
        }else{
          GlobalClass.showErrorAlert(context, responseData, 1);
        }
        // Parse JSON object if it’s a map

        EasyLoading.dismiss();
      }else if(xmlResponse is String){
        if(GlobalClass.isXml(xmlResponse)){
          callJavaMethod(xmlResponse);
        }else{
          GlobalClass.showErrorAlert(context, xmlResponse, 1);
        }
      }else{
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
      final statusCode = e.response?.statusCode;
      if (statusCode == 404) {
        // Handle 404 Not Found
        GlobalClass.showErrorAlert(context, e.response!.data!, 1);
        print("Error: File not found.");
        // Show message to user
      } else {
        // Handle other status codes
        GlobalClass.showErrorAlert(context, e.response!.data!, 1);

      }



    }
  }

  Widget consentText() {
    return RichText(

      text: TextSpan(
        style: TextStyle(fontFamily: "Poppins-Regular",fontSize: 12.0, color: Colors.black), // Default text style
        children: <TextSpan>[
          TextSpan(
            text: 'TERMS & CONDITIONS FOR ONLINE PAYMENTS TO BE MADE TO PAISALO DIGITAL LTD\n\n',
            style: TextStyle(fontFamily: "Poppins-Regular",fontWeight: FontWeight.bold,color: Color(0xffb41d2d)),
          ),
          TextSpan(
            text: 'Name of NBFC: PAISALO DIGITAL LTD\n'
                'CSC POCKET 52 CR PARK NEAR POLICE STATION\n'
                'NEW DELHI -110019\n'
                'WWW.PAISALO.IN\n\n',
          ),
          TextSpan(
            text: 'Online Charges Payments:\n',
            style: TextStyle(fontFamily: "Poppins-Regular",fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
            'This online payment system is provided by PAISALO DIGITAL LTD. The PAISALO DIGITAL LTD may update these terms from time to time, and any changes will be effective immediately on being set out on this portal. Please ensure that you are aware of the current terms. The country of domicile of PAISALO DIGITAL LTD is India, and legal jurisdiction is New Delhi, India.\n\n',
          ),
          TextSpan(
            text: 'Please read these terms carefully before using the online payment facility. Using the online payment facility on this website indicates that you accept these terms. If you do not accept these terms, do not use this facility.\n\n',
          ),
          TextSpan(
            text: 'All payments are subject to the following conditions:\n',
            style: TextStyle(fontFamily: "Poppins-Regular",fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
            '- The description of items is specific to you when you log in with your user ID and unique password.\n'
                '- All charges quoted are in Indian Rupees.\n'
                '- PAISALO DIGITAL LTD reserves the right to change the charges at any time.\n'
                '- Your payment to PAISALO DIGITAL LTD will normally reach PAISALO DIGITAL LTD\'s account within two working days.\n'
                '- We cannot accept liability for a payment not reaching the correct account of PAISALO DIGITAL LTD due to quoting an incorrect account number or incorrect details by you. Neither can we accept liability if payment is refused or declined by the net banking/credit/debit card supplier for any reason.\n'
                '- If the banker/card supplier declines payment, PAISALO DIGITAL LTD is under no obligation to bring this fact to your attention.\n'
                '- It is for you (the customer) to check with your bank/credit/debit card supplier that payment has been deducted from your account.\n'
                '- In no event, PAISALO DIGITAL LTD will be liable for any damages whatsoever arising out of the use, computer virus, malware, inability to use, or the results of use of this site or any websites linked to this site, or the materials or information contained at any or all such sites, whether based on warranty, contract, tort, or any other legal theory and whether or not advised of the possibility of such damages.\n\n',
          ),
          TextSpan(
            text: 'Refund Policy:\n',
            style: TextStyle(fontFamily: "Poppins-Regular",fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
            'Refunds, if applicable, at the discretion of the management, will only be made as per the sources of net banking/debit/credit card used for the original transaction. For the avoidance of doubt, nothing in this policy shall require PAISALO DIGITAL LTD to refund the charges (or part thereof) unless such charges (or part thereof) have previously been paid by the customer through online payment mode and the same has been credited into the accounts of PAISALO DIGITAL LTD and has the approval of the management for refund. The refunded amount will be credited back to the source account within 7 working days.\n\n',
          ),
          TextSpan(
            text: 'Cancel and Return Policy:\n',
            style: TextStyle(fontFamily: "Poppins-Regular",fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
            'Cancel and Return, if applicable, at the discretion of the management, will only be made as per the sources of net banking/debit/credit card used for the original transaction. For the avoidance of doubt, nothing in this policy shall require PAISALO DIGITAL LTD to cancel and return the charges (or part thereof) unless such charges (or part thereof) have previously been paid by the customer through online payment mode and the same has been credited into the accounts of PAISALO DIGITAL LTD and has the approval of the management for cancel and return. The cancellation and return will take up to 20 working days.\n\n',
          ),
          TextSpan(
            text: 'Privacy Policy:\n',
            style: TextStyle(fontFamily: "Poppins-Regular",fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
            'This privacy policy applies to all of the fees, payment of dues, charges, and related payments payable to PAISALO DIGITAL LTD through online mode. Sometimes, we may post specific privacy notices to explain in more detail. If you have any questions about this privacy policy, please feel free to contact us through our email DELHI@PAISALO.IN.\n\n',
          ),
          TextSpan(
            text: 'Changes to our Privacy Policy:\n',
            style: TextStyle(fontFamily: "Poppins-Regular",fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
            'PAISALO DIGITAL LTD reserves the entire right to modify/amend/remove this privacy statement anytime and without any reason. Nothing contained herein creates or is intended to create a contract/agreement between PAISALO DIGITAL LTD and any user visiting the website or providing identifying information of any kind.\n\n',
          ),
          TextSpan(
            text: 'DND Policy:\n',
            style: TextStyle(fontFamily: "Poppins-Regular",fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
            'If you wish to stop any further SMS/email alerts/contacts from our side, all you need to do is to send an email to DELHI@PAISALO.IN with your registered mobile number, and you will be excluded from the ‘alerts list’.\n\n',
          ),
          TextSpan(
            text: 'Contact Email: DELHI@PAISALO.IN\n\n',
          ),
          TextSpan(
            text: 'Terms of Payment:\n',
            style: TextStyle(fontFamily: "Poppins-Regular",fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
            '1. Charges, taxes applicable for online payment through the payment gateway will be borne by the customer.\n'
                '2. In respect of any failed transactions of any of the customers processed through this service, the amount will be refunded after deducting the transaction charges.\n\n',
          ),
        ],
      ),
    );
  }

  String consentRawText = "I hereby authorize NSDL e-Gov on behalf of Paisalo Digital Limited to- 1. Use my Aadhaar details for Loan Document eSignature and authenticate my identity through the Aadhaar Authentication system (Aadhaar based e-KYC services of UIDAI) in accordance with the provisions of the Aadhaar (Targeted Delivery of Financial and other Subsidies, Benefits and Services) Act, 2016 and the allied rules and regulations notified thereunder and for no other purpose. 2. Authenticate my Aadhaar through OTP or Biometric for authenticating my identity through the Aadhaar Authentication system for obtaining my e-KYC through Aadhaar based e-KYC services of UIDAI and use my Photo and Demographic details (Name, Gender, Date of Birth and Address) for Loan Document eSignature. 3. I understand that Security and confidentiality of personal identity data provided, for the purpose of Aadhaar based authentication is ensured by NSDL e-Gov and the data will be stored by NSDL e-Gov till such time as mentioned in guidelines from UIDAI from time to time. 4. I have understood that the system of downloading the copy of loan document for my record from the link provided by the company through email or SMS post e-signing of the loan document. I shall download the copy of loan documents as per my convenience at later stage.";

}
