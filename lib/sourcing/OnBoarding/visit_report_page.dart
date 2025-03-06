import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/api_service.dart';
import 'package:flutter_sourcing_app/utils/camera_text_writing_process.dart';
import 'package:flutter_sourcing_app/utils/current_location.dart';
import 'package:camera/camera.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../global_class.dart';

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
    late List<CameraDescription> cameras;
   RegExp regex = RegExp(r'^[A-Za-z]{4}\d{6}$');
  @override
  void initState() {

initializeCamera();
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
                Text(
                 AppLocalizations.of(context)!.meetingtype,
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
                             AppLocalizations.of(context)!.smcode,
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
                                       decoration:  InputDecoration(
                                         hintText: AppLocalizations.of(context)!.pleaseentercasecode,
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
                                      GlobalClass.showSnackBar(context, AppLocalizations.of(context)!.pleaseentercasecode);
                                    }
                                   },
                                   icon: const Icon(Icons.search,size: 40,color: Colors.white,),
                                 ),
                               ),
                             ],
                           ),

                           _buildInputCard(AppLocalizations.of(context)!.name,
                               "",_nameController,true),
                           _buildInputCard(AppLocalizations.of(context)!.amount, "0",_amountController,false, inputType: TextInputType.number),
                         ],))
                   ,
                   const SizedBox(height: 8),

                    Text(
                     AppLocalizations.of(context)!.comment,
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
                       decoration:  InputDecoration(
                         hintText: AppLocalizations.of(context)!.pleaseentersomecomments,
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

                           final result = await Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) => CameraScreen(camera: cameras.first)),
                           );

                           if (result != null) {
                             //File? pickedFile=await GlobalClass().pickImage();
                             setState(() {
                               imageFile=result;
                             });
                             // The result is the modified image
                             // Use the result (modified image file) here, for example:
                             print('Image path: ${result.path}');
                             Navigator.of(context).push(
                               MaterialPageRoute(
                                 builder: (context) => DisplayPictureScreen(imagePath: result.path),
                               ),
                             );
                           }
                           // File? pickedFile=await GlobalClass().pickImage();
                           // setState(() {
                           //   imageFile=pickedFile;
                           // });
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
                                 Text(AppLocalizations.of(context)!.clickimage),
                                 Icon(Icons.camera)
                               ],
                             ),
                           ),
                         ),
                       ),
                       SizedBox(width: 10),
                        InkWell(

                          onTap: (){
                            if(imageFile!=null){Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DisplayPictureScreen(imagePath:imageFile!.path),
                              ),
                            );}else{GlobalClass.showSnackBar(context, "Please capture image first!!");}

                          },
                          child: imageFile==null? Image(
                            image: AssetImage("assets/Images/prof_ic.png"),
                            width: 100,
                            height: 100,
                          ):Image.file(
                            File(imageFile!.path),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ) ,
                        )
                       ,
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
                               Text(AppLocalizations.of(context)!.submit,style: TextStyle(color: Colors.white),),

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      EasyLoading.show(
        status: AppLocalizations.of(context)!.loading,
      );
    });

      apiService.getBorrowerDetails(_smCodeController.text, GlobalClass.dbName, GlobalClass.token).then((value){
        if(value.statuscode==200){
          setState(() {
            _nameController.text=value.data[0].name;
            EasyLoading.dismiss();
          });
        }else{
          GlobalClass.showSnackBar(context, value.message);
          EasyLoading.dismiss();
        }
      });


  }

  bool validateAllInputs() {
      if(meetingType==null || meetingType=="Select"){
        GlobalClass.showSnackBar(context, AppLocalizations.of(context)!.pleaseselectmeetingtype);
        return false;
      }else if(_layoutVisibility && _smCodeController.text.isEmpty){
        GlobalClass.showSnackBar(context, AppLocalizations.of(context)!.pleaseentercasecode);
        return false;
      }else if(_layoutVisibility &&  _nameController.text.isEmpty){
        GlobalClass.showSnackBar(context, AppLocalizations.of(context)!.pleasesearchborrowernamebycasecode);
        return false;
      }else if(_commentController.text.isEmpty){
        GlobalClass.showSnackBar(context, AppLocalizations.of(context)!.pleaseentersomecomments);
        return false;
      }else if(imageFile==null){
        GlobalClass.showSnackBar(context, AppLocalizations.of(context)!.pleaseclickacurrentpicture);
        return false;
      }
      return true;
  }

  Future<void> SaveAllData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      EasyLoading.show(
        status: AppLocalizations.of(context)!.loading,
      );
    });

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


  apiService.insertBranchVisit(GlobalClass.dbName, GlobalClass.token, meetingType!, _smCodeController.text, _amountController.text.isEmpty?"0":_amountController.text, _lat!.toString(), _long!.toString(), GlobalClass.userName, _commentController.text, _aadress!, imageFile!).then((value){
    if(value.statuscode==200){
        GlobalClass.showSuccessAlert(context,value.message, 2);
    }else{
      GlobalClass.showUnsuccessfulAlert(context, value.message, 1);
    }
    EasyLoading.dismiss();
  });
  }

  Future<void> initializeCamera() async {
    cameras =  await availableCameras();
  }
 }

