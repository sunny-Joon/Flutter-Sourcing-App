import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/api_service.dart';
import 'package:flutter_sourcing_app/global_class.dart';
import 'package:flutter_sourcing_app/utils/current_location.dart';

 class VisitReportPage extends StatefulWidget {
   const VisitReportPage({super.key});

   @override
   State<VisitReportPage> createState() => _VisitReportPageState();
 }

 class _VisitReportPageState extends State<VisitReportPage> {
   bool _layoutVisibility=true;
   TextEditingController _smCodeController=TextEditingController();
   TextEditingController _nameController=TextEditingController();
   TextEditingController _amountController=TextEditingController();
   TextEditingController _commentController=TextEditingController();
    late ApiService apiService;
    String? borrowerName;
    String? meetingType;
    var _lat=0.0;
    var _long=0.0;
    String? _aadress;
    File? imageFile;
   RegExp regex = RegExp(r'^[A-Za-z]{4}\d{6}$');
    @override
  void initState() {
    apiService=ApiService.create(baseUrl: ApiConfig.baseUrl1);
        super.initState();
  }

   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Color(0xFFD42D3F),
       body: Padding(
         padding: const EdgeInsets.all(10.0),
         child: SingleChildScrollView(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
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
               const Text(
                 "Meeting Type",
                 style: TextStyle(fontFamily: "Poppins-Regular",
                   fontSize: 15,

                   color: Colors.white,
                 ),
               ),
               const SizedBox(height: 0),
               Card(
                 color: Colors.white,
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(3),
                 ),
                 elevation: 0,
                 child: Padding(
                   padding: const EdgeInsets.all(5.0),
                   child: DropdownButtonFormField<String>(
                     decoration: InputDecoration(
                       border: InputBorder.none,
                       contentPadding: EdgeInsets.all(10),
                     ),
                     items: const [
                       DropdownMenuItem(
                         value: "Select",
                         child: Text("Select"),
                       )
                       ,  DropdownMenuItem(
                         value: "Recovery",
                         child: Text("Recovery"),
                       ),
                       DropdownMenuItem(
                         value: "Audit",
                         child: Text("Audit"),
                       ),  DropdownMenuItem(
                         value: "OD",
                         child: Text("OD"),
                       ),
                       DropdownMenuItem(
                         value: "Group Meeting",
                         child: Text("Group Meeting"),
                       ),  DropdownMenuItem(
                         value: "Regular Visits",
                         child: Text("Regular Visits"),
                       ),
                       DropdownMenuItem(
                         value: "NPA Visit",
                         child: Text("NPA Visit"),
                       ),  DropdownMenuItem(
                         value: "GRT",
                         child: Text("GRT"),
                       ),
                       DropdownMenuItem(
                         value: "Pre GRT",
                         child: Text("Pre GRT"),
                       ),
                     ],
                     onChanged: (value) {
                       if(value=="Pre GRT" || value=="GRT" || value=="Group Meeting"){
                            setState(() {
                              _layoutVisibility=false;
                            });
                       }else{
                         setState(() {
                               _layoutVisibility=true;
                         });
                       }
                       meetingType=value;
                     },
                   ),
                 ),
               ),
               const SizedBox(height: 8),
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Visibility(
                       visible: _layoutVisibility,
                       child:  Column(


                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [

                           Text(
                             "Sm Code",
                             style: TextStyle(
                               fontSize: 15,
                               fontFamily: "Poppins-Regular",
                               color: Colors.white,
                             ),
                           ),
                           const SizedBox(height: 0),
                           Row(
                             children: [
                               Expanded(
                                 flex: 5,
                                 child: Card(
                                   color: Colors.white,
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(3),
                                   ),
                                   elevation: 0,
                                   child: Padding(
                                     padding: const EdgeInsets.all(5.0),
                                     child: TextField(
                                       controller: _smCodeController,
                                       maxLength: 10,
                                       decoration: const InputDecoration(
                                         hintText: "Enter Case Code (SM CODE)",
                                         border: InputBorder.none,
                                         counterText: "",
                                         contentPadding: EdgeInsets.all(10),
                                       ),
                                     ),
                                   ),
                                 ),
                               ),
                               const SizedBox(width: 5),
                               Expanded(
                                 flex: 1,
                                 child: IconButton(
                                   onPressed: () {
                                    if(_smCodeController.text.isNotEmpty && regex.hasMatch(_smCodeController.text)) {
                                      fetchDetailsBySmCode();
                                    }else{
                                      GlobalClass.showSnackBar(context, "Please Enter Correct Case code");
                                    }
                                   },
                                   icon: const Icon(Icons.search,size: 40,color: Colors.white,),
                                 ),
                               ),
                             ],
                           ),

                           _buildInputCard("Name", "",_nameController,true),
                           _buildInputCard("Amount", "0",_amountController,false, inputType: TextInputType.number),
                         ],))
                   ,
                   const SizedBox(height: 8),

                   const Text(
                     "Comment",
                     style: TextStyle(
                       fontSize: 15,
                       fontFamily: "Poppins-Regular",
                       color: Colors.white,
                     ),
                   ),
                   const SizedBox(height: 0),
                   Card(
                     color: Colors.white,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(3),
                     ),
                     elevation:0,
                     child: TextField(
                       controller: _commentController,
                       maxLines: 4,
                       decoration: const InputDecoration(
                         hintText: "Enter your comment",
                         border: InputBorder.none,
                         contentPadding: EdgeInsets.all(10),
                       ),
                     ),
                   ),
                   const SizedBox(height: 8),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       InkWell(
                         onTap: () async {
                           File? pickedFile=await GlobalClass().pickImage();
                           setState(() {
                             imageFile=pickedFile;
                           });
                         },
                         child: Card(
                           elevation: 6,
                           color: Colors.grey.shade300,
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                           child: Container(
                             alignment: Alignment.center,
                             height: 40,
                             width: 150,
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Text("Click Image"),
                                 Icon(Icons.camera)
                               ],
                             ),
                           ),
                         ),
                       ),
                       SizedBox(width: 10),
                        imageFile==null? Image(
                         image: AssetImage("assets/Images/prof_ic.png"),
                         width: 100,
                         height: 100,
                       ):Image.file(
                          File(imageFile!.path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                     ],
                   ),
                   const SizedBox(height: 15),
                   Center(child: InkWell(
                     onTap: (){

                     },
                     child: InkWell(
                       onTap: (){
                         if(validateAllInputs()){
                           SaveAllData();

                         }
                       },
                       child:Card(

                         elevation: 6,
                         color: Colors.green,
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                         child: Container(
                           alignment: Alignment.center,
                           height: 40,
                           width: MediaQuery.of(context).size.width-80,
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Text("Submit data",style: TextStyle(color: Colors.white),),

                             ],
                           ),
                         ),
                       ),
                     ),
                   ),),
                 ],
               ),
             ],
           ),
         ),
       ),
     );
   }

   Widget _buildInputCard(String label, String value,TextEditingController controller,bool readOnly, {TextInputType inputType = TextInputType.text}) {
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         SizedBox(height: 8,),
         Text(
           label,
           style: const TextStyle(
             fontSize: 15,
             fontFamily: "Poppins-Regular",
             color: Colors.white,
           ),
         ),
         const SizedBox(height: 0),
         Card(
           color: Colors.white,
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(3),
           ),
           elevation: 0,
           child: Padding(
             padding: const EdgeInsets.all(5.0),
             child: TextField(
               readOnly: readOnly,
               controller: controller,
               keyboardType: inputType,
               decoration: InputDecoration(
                 hintText: label,
                 border: InputBorder.none,
                 contentPadding: const EdgeInsets.all(10),
               ),
             ),
           ),
         ),
       ],
     );
   }

  void fetchDetailsBySmCode() {
      EasyLoading.show(status: "Please wait...");

      apiService.getBorrowerDetails(_smCodeController.text, GlobalClass.dbName, GlobalClass.token).then((value){
        if(value.statuscode==200){
          setState(() {
            _nameController.text=value.data[0].name;
            EasyLoading.dismiss();
          });
        }else{
          GlobalClass.showSnackBar(context, "Details not found for this case code. \nPlease check");
          EasyLoading.dismiss();
        }
      });


  }

  bool validateAllInputs() {
      if(meetingType==null || meetingType=="Select"){
        GlobalClass.showSnackBar(context, "Please select meeting type");
        return false;
      }else if(_layoutVisibility && _smCodeController.text.isEmpty){
        GlobalClass.showSnackBar(context, "Please enter case code");
        return false;
      }else if(_layoutVisibility &&  _nameController.text.isEmpty){
        GlobalClass.showSnackBar(context, "Please search borrower's name by case code");
        return false;
      }else if(_commentController.text.isEmpty){
        GlobalClass.showSnackBar(context, "Please enter some comments");
        return false;
      }else if(imageFile==null){
        GlobalClass.showSnackBar(context, "Please click a current picture");
        return false;
      }
      return true;
  }

  Future<void> SaveAllData() async {
      EasyLoading.show(status: "Please wait...");

      currentLocation _locationService = currentLocation();
      try {
        Map<String, dynamic> locationData =
            await _locationService.getCurrentLocation();

        _lat = locationData['latitude'];
        _long = locationData['longitude'];
        _aadress = locationData['address'];

      } catch (e) {
        print("Error getting current location: $e");

      }


  apiService.insertBranchVisit(GlobalClass.dbName, GlobalClass.token, meetingType!, _smCodeController.text, _amountController.text, _lat!.toString(), _long!.toString(), GlobalClass.userName, _commentController.text, _aadress!, imageFile!).then((value){
    if(value.statuscode==200){
        GlobalClass.showSuccessAlert(context, "Record saved Successfully", 2);
    }else{
      GlobalClass.showUnsuccessfulAlert(context, "Record not saved please try again", 1);
    }
    EasyLoading.dismiss();
  });
  }
 }

