import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/utils/current_location.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../MasterAPIs/live_track_repository.dart';
import '../../Models/borrower_list_model.dart';
import '../../Models/branch_model.dart';
import '../../Models/group_model.dart';
import '../../api_service.dart';
import '../../utils/camera_text_writing_process.dart';
import '../global_class.dart';
import 'on_boarding.dart';


class HouseVisitForm extends StatefulWidget {

  final BranchDataModel BranchData;
  final GroupDataModel GroupData;
  final BorrowerListDataModel selectedData;


  const HouseVisitForm({
    super.key,
    required this.BranchData,
    required this.GroupData,
    required this.selectedData,
  }
      );

  @override
  _HouseVisitFormState createState() => _HouseVisitFormState();

}

class _HouseVisitFormState extends State<HouseVisitForm> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final picker = ImagePicker();
  String _locationMessage = "";
  late double _latitude=0.0;
  late double _longitude=0.0;
  String? _aadress;
  late List<CameraDescription> cameras;
  String nameReg ='[a-zA-Z. ]';
  String addReg = r'[a-zA-Z0-9. ()/,-]';
  String amountReg ='[0-9]';
  String cityReg ='[a-zA-Z ]';
  String IdsReg ='[a-zA-Z0-9/ ]';

  List<String> relation = ['Select','mother','father','husband','wife','brother','sister'];
  List<String> residing_type = ['Select','pucca','kaccha'];
  List<String> residing_with = ['Select','family','separately'];
  List<String> years = ['Select','1','2','3','4','5','5++'];
  List<String> ratings = ['Select','good','bad','dontKnow'];
  List<String> relations = ['Select','spouse','parents','siblings'];

  String? selected_applicant= "";
  String? selected_residing_type= "";
  String? selected_residing_with= "";
  String? selected_years= "";
  String? selected_years2= "";
  String? selected_ratings= "";
  String? selected_relations= "";


  final  _BranchNameController = TextEditingController();
  final  _AreaCodeController = TextEditingController();
  final  _GroupCodeController = TextEditingController();
  final  _CenterController = TextEditingController();
  final  _LoanUsagePercentageController = TextEditingController();
  final  _monthlyIncomeController = TextEditingController();
  final  _monthlySalesController = TextEditingController();
  final  _NameofInterviewedController = TextEditingController();
  final  _AgeofInterviewedController = TextEditingController();
  final  _DistancetobranchController = TextEditingController();
  final  _TimetoreachbranchController = TextEditingController();
  final  _TotalmonthlyexpensesofoccupationController = TextEditingController();
  final  _Netmonthlyincome_afterproposedloanController = TextEditingController();
  final  _TotalmonthlyhouseholdexpensesController = TextEditingController();
  final  _NetmonthlyincomeotherfamilymembersController = TextEditingController();
  final  _Namereferenceperson1Controller = TextEditingController();
  final  _Mobilereferenceperson1Controller = TextEditingController();
  final  _Namereferenceperson2Controller = TextEditingController();
  final  _Mobilereferenceperson2Controller = TextEditingController();
  final  _AddressController = TextEditingController();

  String housetype="True";
  String isvalidlocation="True";
  String cpflifestyle="True";
  String cpfpoaddressverify="True";
  String photoidverification="True";
  String currentaddressprof="True";
  String hasbandwifeageverificaton="True";
  String parmanentaddresspincode="True";
  String stamponphotocopy="True";
  String lastloanverification="True";
  String absentreasonincentermeeting="True";
  String repaymentfault="True";
  String loanreasonverification="True";
  String isappliedamountappropriate="True";
  String familyawarenessaboutloan="True";
  String businessaffectedourrelation="True";
  String isloanappropriateforbusiness="True";
  String repayeligiblity="True";
  String cashflowoffamily="True";
  String incomematchedwithprofile="True";
  String businessverification="True";
  String comissiondemand="True";
  String borrowersupportedgroup="True";
  String groupreadytovilay="True";
  String grouphasbloodrelation="True";
  String understandinsaurancepolicy="True";
  String verifyexternalloan="True";
  String understandsfaultpolicy="True";
  String overlimitloan_borrowfromgroup="True";
  String toatldebtunderlimit="True";
  String workingplaceverification="True";
  String isworkingplacevalid="True";
  String workingplacedescription="True";
  String workexperience="True";
  String seasondependency="True";
  String stockverification="True";
  String loansufficientwithdebt="True";
  late currentLocation _locationService;
  double? totalDistance;
  late String value;

  @override
  void initState() {
    super.initState();
    _locationService = currentLocation();
    initializeCamera();
    _BranchNameController.text = widget.BranchData.branchName ?? '';
    _GroupCodeController.text = widget.GroupData.groupCodeName ?? '';
    _CenterController.text = widget.GroupData.centerName ?? '';

    _initLocationAndDistance();
    // _LoanUsagePercentageController.addListener(() {
    //    value = _LoanUsagePercentageController.text;
    //   if (value.isNotEmpty) {
    //     double enteredValue = double.tryParse(value) ?? 0.0;
    //
    //     if (enteredValue > totalDistance!) {
    //       _LoanUsagePercentageController.text = totalDistance.toString();
    //       _LoanUsagePercentageController.selection = TextSelection.fromPosition(
    //         TextPosition(offset: _LoanUsagePercentageController.text.length),
    //       );
    //     }
    //   }
    //
    // });
  }

  Future<void> _initLocationAndDistance() async {
    try {
      Map<String, dynamic> locationData = await _locationService.getCurrentLocation();

      _latitude = locationData['latitude'];
      _longitude = locationData['longitude'];
      _aadress = locationData['address'];

      print("_latitude $_latitude");
      print("_longitude $_longitude");
      print("_aadress $_aadress");

      double lat1 = 28.541909899980464;
      double lon1 = 77.23837911402565;

      double distance = calculateDistance(lat1, lon1, _latitude, _longitude);
      totalDistance = double.parse(distance.toStringAsFixed(2));
      print('Distance is: $totalDistance');
      print('Distance is: ${distance.toStringAsFixed(2)} km');

      setState(() {

      });

    } catch (e) {
      print("Error getting current location: $e");
    }
  }




  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(/*onWillPop: _onWillPop,*/
        child: Scaffold(
          backgroundColor: Color(0xFFD42D3F),
          body: SingleChildScrollView(
              child:Column(children: [

                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  child:Row(
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
                            child: Icon(Icons.arrow_back_ios_sharp, size: 13),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Center(
                        /*child: Image.asset(
                          'assets/Images/paisa_logo.png',
                          // Replace with your logo asset path
                          height: 50,
                        ),*/
                          child:Column(children: [
                            Text(
                              AppLocalizations.of(context)!.housevisit,
                              style: TextStyle(fontFamily: "Poppins-Regular",
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24 // Make the text bold
                              ),
                            ),
                            Text(
                              "${widget.selectedData.fiCode}/${widget.selectedData.creator}",
                              style: TextStyle(fontFamily: "Poppins-Regular",
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16 // Make the text bold
                              ),
                            ),
                          ],)),
                      Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                      ),
                    ],
                  ),),

                Container(
                  margin: EdgeInsets.only(left: 15,right: 15,),
                  height: MediaQuery.of(context).size.height - 160,

                  // padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 7,
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(child: Column(
                        children:
                        <Widget>[
                          SizedBox(height: 20),
                          _buildTextField2(AppLocalizations.of(context)!.branch, _BranchNameController, TextInputType.text,addReg,isEnabled: false),
                          // _buildTextField2(AppLocalizations.of(context)!.area, _AreaCodeController, TextInputType.text,addReg),
                          _buildTextField2(AppLocalizations.of(context)!.group, _GroupCodeController, TextInputType.text,addReg,isEnabled: false),
                          _buildTextField2(AppLocalizations.of(context)!.center, _CenterController, TextInputType.text,addReg,isEnabled: false),
                          _buildTextField2(AppLocalizations.of(context)!.loanusagepercentage, _LoanUsagePercentageController, TextInputType.number,amountReg),
                          _buildTextField2(AppLocalizations.of(context)!.monthlyincomehouse, _monthlyIncomeController, TextInputType.number,amountReg),
                          _buildTextField2(AppLocalizations.of(context)!.monthlysales, _monthlySalesController, TextInputType.number,amountReg),
                          _buildTextField2(AppLocalizations.of(context)!.interviewedpersonname, _NameofInterviewedController, TextInputType.name,nameReg),
                          _buildTextField2(AppLocalizations.of(context)!.interviewedpersonage, _AgeofInterviewedController, TextInputType.number,amountReg),
                         // _buildTextField2(AppLocalizations.of(context)!.distancetobranch, _DistancetobranchController, TextInputType.number,amountReg),
                          _buildTextField2(AppLocalizations.of(context)!.timetoreachbranch, _TimetoreachbranchController, TextInputType.number,amountReg),
                          _buildTextField2(AppLocalizations.of(context)!.totalmonthlyexpenses, _TotalmonthlyexpensesofoccupationController, TextInputType.number,amountReg),
                          _buildTextField2(AppLocalizations.of(context)!.netmonthlyincomeafterloan, _Netmonthlyincome_afterproposedloanController, TextInputType.number,amountReg),
                          _buildTextField2(AppLocalizations.of(context)!.totalmonthlyhouseholdexpenses, _TotalmonthlyhouseholdexpensesController, TextInputType.number,amountReg),
                          _buildTextField2(AppLocalizations.of(context)!.netmonthlyincomeotherfamily, _NetmonthlyincomeotherfamilymembersController, TextInputType.number,amountReg),
                          _buildTextField2(AppLocalizations.of(context)!.referenceperson1name, _Namereferenceperson1Controller, TextInputType.name,nameReg),
                          _buildTextField1(AppLocalizations.of(context)!.referenceperson1phone, _Mobilereferenceperson1Controller, TextInputType.number,10),
                          _buildTextField2(AppLocalizations.of(context)!.referenceperson2name, _Namereferenceperson2Controller, TextInputType.name,nameReg),
                          _buildTextField1(AppLocalizations.of(context)!.referenceperson2phone, _Mobilereferenceperson2Controller, TextInputType.number,10),
                          _buildTextField2(AppLocalizations.of(context)!.addresshouse, _AddressController, TextInputType.name,addReg),


                          dropdowns(AppLocalizations.of(context)!.relationwithearningmember, relation, selected_applicant!, (newValue) {setState(() {selected_applicant = newValue;});}),
                          dropdowns(AppLocalizations.of(context)!.residingtype, residing_type, selected_residing_type!, (newValue) {setState(() {selected_residing_type = newValue;});}),
                          dropdowns(AppLocalizations.of(context)!.residingwith, residing_with, selected_residing_with!, (newValue) {setState(() {selected_residing_with = newValue;});}),
                          dropdowns(AppLocalizations.of(context)!.residentialstability, years, selected_years!, (newValue) {setState(() {selected_years = newValue;});}),
                          dropdowns(AppLocalizations.of(context)!.totalexperience, years, selected_years2!, (newValue) {setState(() {selected_years2 = newValue;});}),
                          dropdowns(AppLocalizations.of(context)!.applicantresponse, ratings, selected_ratings!, (newValue) {setState(() {selected_ratings = newValue;});}),
                          dropdowns(AppLocalizations.of(context)!.relationwithinterviewed, relations, selected_relations!, (newValue) {setState(() {selected_relations = newValue;});}),


                          checkboxes(AppLocalizations.of(context)!.roofwalltype, housetype, (newValue) {setState(() {housetype = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.validlocation, isvalidlocation, (newValue) {setState(() {isvalidlocation = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.lifestyleverification, cpflifestyle, (newValue) {setState(() {cpflifestyle = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.verificationofloan, cpfpoaddressverify, (newValue) {setState(() {cpfpoaddressverify = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.idverification, photoidverification, (newValue) {setState(() {photoidverification = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.currentaddressverification, currentaddressprof, (newValue) {setState(() {currentaddressprof = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.ageverification, hasbandwifeageverificaton, (newValue) {setState(() {hasbandwifeageverificaton = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.addressfilledincpf, parmanentaddresspincode, (newValue) {setState(() {parmanentaddresspincode = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.stampedphotocopy, stamponphotocopy, (newValue) {setState(() {stamponphotocopy = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.lastloanusage, lastloanverification, (newValue) {setState(() {lastloanverification = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.centermeetingabsence, absentreasonincentermeeting, (newValue) {setState(() {absentreasonincentermeeting = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.paymentdelays, repaymentfault, (newValue) {setState(() {repaymentfault = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.loanpurpose, loanreasonverification, (newValue) {setState(() {loanreasonverification = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.loanamountappropriate, isappliedamountappropriate, (newValue) {setState(() {isappliedamountappropriate = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.familyawareness, familyawarenessaboutloan, (newValue) {setState(() {familyawarenessaboutloan = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.businesssuitability, businessaffectedourrelation, (newValue) {setState(() {businessaffectedourrelation = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.loanimpactonbusiness, isloanappropriateforbusiness, (newValue) {setState(() {isloanappropriateforbusiness = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.repaymentcapacity, repayeligiblity, (newValue) {setState(() {repayeligiblity = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.familycashflow, cashflowoffamily, (newValue) {setState(() {cashflowoffamily = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.incomeafterloan, incomematchedwithprofile, (newValue) {setState(() {incomematchedwithprofile = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.businessverification, businessverification, (newValue) {setState(() {businessverification = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.commissiondemand, comissiondemand, (newValue) {setState(() {comissiondemand = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.groupreadytovilay, borrowersupportedgroup, (newValue) {setState(() {borrowersupportedgroup = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.groupreadytovilay, groupreadytovilay, (newValue) {setState(() {groupreadytovilay = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.grouphasbloodrelation, grouphasbloodrelation, (newValue) {setState(() {grouphasbloodrelation = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.understandinsurancepolicy, understandinsaurancepolicy, (newValue) {setState(() {understandinsaurancepolicy = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.verifyexternalloan, verifyexternalloan, (newValue) {setState(() {verifyexternalloan = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.understandsfaultpolicy, understandsfaultpolicy, (newValue) {setState(() {understandsfaultpolicy = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.overlimitloanborrowfromgroup, overlimitloan_borrowfromgroup, (newValue) {setState(() {overlimitloan_borrowfromgroup = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.totaldebtunderlimit, toatldebtunderlimit, (newValue) {setState(() {toatldebtunderlimit = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.workingplaceverification, workingplaceverification, (newValue) {setState(() {workingplaceverification = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.isworkingplacevalid, isworkingplacevalid, (newValue) {setState(() {isworkingplacevalid = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.workingplacedescription, workingplacedescription, (newValue) {setState(() {workingplacedescription = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.workexperience, workexperience, (newValue) {setState(() {workexperience = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.seasondependency, seasondependency, (newValue) {setState(() {seasondependency = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.stockverification, stockverification, (newValue) {setState(() {stockverification = newValue;});},),
                          checkboxes(AppLocalizations.of(context)!.loansufficientwithdebt, loansufficientwithdebt, (newValue) {setState(() {loansufficientwithdebt = newValue;});},),

                        /*  SizedBox(height: 20),
                          _image == null
                              ? Text(AppLocalizations.of(context)!.noimageselected)
                              : Image.file(_image!),
                          ElevatedButton(
                            onPressed: getImage,

                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero, // Makes the corners square
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(Icons.camera_alt),
                                SizedBox(width: 8), // Optional: Adds space between the icon and text
                                Text(AppLocalizations.of(context)!.clickwithhouse),
                              ],
                            ),
                          ),*/


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
                                      _image=result;
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
                                  if(_image!=null){Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => DisplayPictureScreen(imagePath:_image!.path),
                                    ),
                                  );}else{GlobalClass.showSnackBar(context, "Please capture image first!!");}

                                },
                                child: _image==null? Image(
                                  image: AssetImage("assets/Images/prof_ic.png"),
                                  width: 100,
                                  height: 100,
                                ):Image.file(
                                  File(_image!.path),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ) ,
                              )
                              ,
                            ],
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if(validate()){
                                  saveHouseVisitForm(context);
                                }
                                // Process data
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero, // Makes the corners square
                              ),
                            ),
                            child: Text(AppLocalizations.of(context)!.submit),
                          ),
                        ],
                      ),),
                    ),
                  ),
                ),

              ],)

          ),
        ));


  }
  Future<bool> _onWillPop() async {
    // Show a confirmation dialog
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.areyousure,),
        content: Text(AppLocalizations.of(context)!.isclosehousevisit),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(false), // Stay in the app
            child: Text(AppLocalizations.of(context)!.no),
          ),
          TextButton(
            onPressed: () {
              EasyLoading.dismiss();
              Navigator.of(context).pop(true);
            }, // Exit the app
            child: Text(AppLocalizations.of(context)!.yes),
          ),
        ],
      ),
    ) ??
        false; // Default to false if dialog is dismissed
  }
  Future<void> saveHouseVisitForm(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      EasyLoading.show(
        status: AppLocalizations.of(context)!.loading,
      );
    });

    String HouseType=housetype;
    String IsvalidLocation=isvalidlocation;
    String CPFlifeStyle=cpflifestyle;
    String CpfPOAddressVerify=cpfpoaddressverify;
    String PhotoIdVerification=photoidverification;
    String CurrentAddressprof=currentaddressprof;
    String HasbandWifeAgeverificaton=hasbandwifeageverificaton;
    String ParmanentAddressPincode=parmanentaddresspincode;
    String StampOnPhotocopy=stamponphotocopy;
    String LastLoanVerification=lastloanverification;
    String AbsentReasonInCentermeeting=absentreasonincentermeeting;
    String RepaymentFault=repaymentfault;
    String LoanreasonVerification=loanreasonverification;
    String IsAppliedAmountAppropriate=isappliedamountappropriate;
    String FamilyAwarenessaboutloan=familyawarenessaboutloan;
    String Businessaffectedourrelation=businessaffectedourrelation;
    String IsloanAppropriateforBusiness=isloanappropriateforbusiness;
    String Repayeligiblity=repayeligiblity;
    String Cashflowoffamily=cashflowoffamily;
    String IncomeMatchedwithprofile=incomematchedwithprofile;
    String BusinessVerification=businessverification;
    String ComissionDemand=comissiondemand;
    String BorrowersupportedGroup=borrowersupportedgroup;
    String GroupReadyToVilay=groupreadytovilay;
    String GroupHasBloodRelation=grouphasbloodrelation;
    String UnderstandInsaurancePolicy=understandinsaurancepolicy;
    String VerifyExternalLoan=verifyexternalloan;
    String UnderstandsFaultPolicy=understandsfaultpolicy;
    String OverlimitLoan_borrowfromgroup=overlimitloan_borrowfromgroup;
    String toatlDebtUnderLimit=toatldebtunderlimit;
    String workingPlaceVerification=workingplaceverification;
    String IsWorkingPlaceValid=isworkingplacevalid;
    String workingPlacedescription=workingplacedescription;
    String workExperience=workexperience;
    String SeasonDependency=seasondependency;
    String StockVerification=stockverification;
    String LoanSufficientWithDebt=loansufficientwithdebt;

    String Relationearningmember=selected_applicant!;
    String Residence_Type=selected_residing_type!;
    String Residing_with=selected_residing_with!;
    String feedbacknearbyresident=selected_ratings!;
    String TotalExperienceOccupation=selected_years!;
    String Residential_Stability=selected_years2!;
    String RelationofInterviewer=selected_relations!;


    String BranchName=_BranchNameController.text.toString();
    String AreaCode=GlobalClass.creator;
    String AreaName=_GroupCodeController.text.toString();
    String Center=_CenterController.text.toString();
    String LoanUsagePercentage=_LoanUsagePercentageController.text.toString();
    int monthlyIncome=int.parse(_monthlyIncomeController.text.toString());
    int monthlySales=int.parse(_monthlySalesController.text.toString());
    String NameofInterviewed=_NameofInterviewedController.text.toString();
    String AgeofInterviewed=_AgeofInterviewedController.text.toString();
    //String Distancetobranch=_DistancetobranchController.text.toString();
    String Timetoreachbranch=_TimetoreachbranchController.text.toString();
    int Totalmonthlyexpensesofoccupation=int.parse(_TotalmonthlyexpensesofoccupationController.text.toString());
    int Netmonthlyincome_afterproposedloan=int.parse(_Netmonthlyincome_afterproposedloanController.text.toString());
    int Totalmonthlyhouseholdexpenses=int.parse(_TotalmonthlyhouseholdexpensesController.text.toString());
    int Netmonthlyincomeotherfamilymembers=int.parse(_NetmonthlyincomeotherfamilymembersController.text.toString());
    String Namereferenceperson1=_Namereferenceperson1Controller.text.toString();
    String Mobilereferenceperson1=_Mobilereferenceperson1Controller.text.toString();
    String Namereferenceperson2=_Namereferenceperson2Controller.text.toString();
    String Mobilereferenceperson2=_Mobilereferenceperson2Controller.text.toString();
    String Address=_AddressController.text.toString();

    /*  double Latitude=_latitude;
    double Longitude=_longitude;*/

    String Applicant_Status="N";
    String FamilymemberfromPaisalo="o";

    String fi_Id=widget.selectedData.id.toString();
    String Creator=GlobalClass.creator;
    int HouseMonthlyRent=45;
    String EmpCode=GlobalClass.EmpId;
    String GroupCode=widget.GroupData.groupCode;
    String GroupName=widget.GroupData.groupCodeName;




    File? Image = _image;

    final api = Provider.of<ApiService>(context, listen: false);

    await api.saveHouseVisit(
        GlobalClass.token,GlobalClass.dbName,
        fi_Id,
        Creator,
        BranchName,
        AreaCode,
        AreaName,
        Center,
        GroupCode,
        GroupName,
        HouseType,
        IsvalidLocation,
        CPFlifeStyle,
        CpfPOAddressVerify,
        PhotoIdVerification,
        CurrentAddressprof,
        HasbandWifeAgeverificaton,
        ParmanentAddressPincode,
        StampOnPhotocopy,
        LastLoanVerification,
        LoanUsagePercentage,
        AbsentReasonInCentermeeting,
        RepaymentFault,
        LoanreasonVerification,
        IsAppliedAmountAppropriate,
        FamilyAwarenessaboutloan,
        IsloanAppropriateforBusiness,
        Businessaffectedourrelation,
        Repayeligiblity,
        Cashflowoffamily,
        IncomeMatchedwithprofile,
        BorrowersupportedGroup,
        ComissionDemand,
        GroupReadyToVilay,
        GroupHasBloodRelation,
        VerifyExternalLoan,
        UnderstandsFaultPolicy,
        OverlimitLoan_borrowfromgroup,
        toatlDebtUnderLimit,
        workingPlaceVerification,
        IsWorkingPlaceValid,
        workingPlacedescription,
        workExperience,
        SeasonDependency,
        StockVerification,
        monthlyIncome,
        monthlySales,
        LoanSufficientWithDebt,
        NameofInterviewed,
        AgeofInterviewed,
        RelationofInterviewer,
        Applicant_Status,
        Residing_with,
        FamilymemberfromPaisalo,
        HouseMonthlyRent,
        Residence_Type,
        Residential_Stability,
        totalDistance!,
        Timetoreachbranch,
        TotalExperienceOccupation,
        Totalmonthlyexpensesofoccupation,
        Netmonthlyincome_afterproposedloan,
        Totalmonthlyhouseholdexpenses,
        Netmonthlyincomeotherfamilymembers,
        Relationearningmember,
        Namereferenceperson1,
        Mobilereferenceperson1,
        Namereferenceperson2,
        Mobilereferenceperson2,
        feedbacknearbyresident,
        UnderstandInsaurancePolicy,
        BusinessVerification,
        _latitude,
        _longitude,


        EmpCode,
        Address,
        Image!).then((response) {
      if (response.statuscode == 200) {
        EasyLoading.dismiss();
        GlobalClass.showSuccessAlertclose(
          context,
          response.message,
          1,
          destinationPage: OnBoarding(),
        );
        //  _showSuccessAndRedirect(response);
        //   GlobalClass.showSuccessAlert(context,response.message,3);
        LiveTrackRepository().saveLivetrackData( "",   "House Visit",widget.selectedData.id);
      } else {
        EasyLoading.dismiss();
        GlobalClass.showUnsuccessfulAlert(context,response.message,1);
      }
    }).catchError((error) {
      EasyLoading.dismiss();
      GlobalClass.showErrorAlert(context,"Server Error",1);
    });
  }

  Widget _buildTextField2(String label, TextEditingController controller, TextInputType inputType, String regex, {bool isEnabled = true}) {
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontFamily: "Poppins-Regular",
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          Container(
            width: double.infinity, // Set the desired width
            // height: 45, // Set the desired height
            color: Colors.white,
            child: Center(
              child: TextFormField(
                controller: controller,
                keyboardType: inputType,
                enabled: isEnabled, // 🔒 disables if false
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '${AppLocalizations.of(context)!.pleaseenter} $label';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(regex)),
                  TextInputFormatter.withFunction(
                        (oldValue, newValue) => TextEditingValue(
                      text: newValue.text.toUpperCase(),
                      selection: newValue.selection,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }

  Widget _buildTextField1(String label, TextEditingController controller, TextInputType inputType, int maxlength) {
    return Container(
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: "Poppins-Regular",
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          Container(
            width: double.infinity, // Set the desired width
            color: Colors.white,
            child: Center(
              child: TextFormField(
                controller: controller,
                keyboardType: inputType, // Set the input type
                maxLength: maxlength, // Restrict input length
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  counterText: '', // Optionally hide the counter below the input field
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '${AppLocalizations.of(context)!.pleaseenter} $label';
                  }
                  if (value.length > maxlength) {
                    return '$label cannot exceed $maxlength characters';
                  }
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget checkboxes(String label, String value, ValueChanged<String> onChanged) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        bool _isChecked = value.toLowerCase() == 'true';

        return Container(
          margin: EdgeInsets.symmetric(vertical: 4),
          padding: EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity, // Full width of the parent
                color: Colors.white, // Background color
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Checkbox Row with label
                    Row(
                      children: [
                        Checkbox(
                          value: _isChecked,
                          checkColor: Color(0xFFD42D3F),
                          fillColor: MaterialStateProperty.all(Colors.grey.shade400),
                          shape: RoundedRectangleBorder(

                            borderRadius: BorderRadius.circular(100),
                          ),
                          onChanged: (bool? newValue) {
                            setState(() {
                              _isChecked = newValue ?? false;
                              onChanged(_isChecked ? 'True' : 'False');
                            });
                          },
                        ),
                        Flexible( // Ensures the Text widget takes the remaining space
                          child: Text(
                            label,
                            style: TextStyle(fontFamily: "Poppins-Regular",
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            maxLines: null, // Allow text to wrap to multiple lines
                            softWrap: true, // Allow soft wrapping of the text
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget dropdowns(String label, List<String> items, String selectedItem, ValueChanged<String> onChanged) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontFamily: "Poppins-Regular",
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey), // Add this line for border
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedItem.isEmpty ? items.first : selectedItem,
                onChanged: (String? newValue) {
                  onChanged(newValue ?? '');
                },
                isExpanded: true,
                alignment: Alignment.centerLeft,
                items: items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool validate() {

    if (selected_applicant == null ||
        selected_applicant!.isEmpty ||
        selected_applicant!.toLowerCase() == 'select') {
      showToast_Error(
          AppLocalizations.of(context)!.relationshipwiththeapplicant);
      return false;
    }

    if (selected_residing_type == null ||
        selected_residing_type!.isEmpty ||
        selected_residing_type!.toLowerCase() == 'select') {
      showToast_Error(AppLocalizations.of(context)!.pleaseselectresedencetype);
      return false;
    }

    if (selected_residing_with == null ||
        selected_residing_with!.isEmpty ||
        selected_residing_with!.toLowerCase() == 'select') {
      showToast_Error(AppLocalizations.of(context)!.pleaseselectresidingwith);
      return false;
    }
    if (selected_years == null ||
        selected_years!.isEmpty ||
        selected_years!.toLowerCase() == 'select') {
      showToast_Error(
          AppLocalizations.of(context)!.pleaseselectresidancestability);
      return false;
    }
    if (selected_years2 == null ||
        selected_years2!.isEmpty ||
        selected_years2!.toLowerCase() == 'select') {
      showToast_Error(
          AppLocalizations.of(context)!.pleaseselectbusinessexperience);
      return false;
    }
    if (selected_ratings == null ||
        selected_ratings!.isEmpty ||
        selected_ratings!.toLowerCase() == 'select') {
      showToast_Error(AppLocalizations.of(context)!.pleaseselectfeedback);
      return false;
    }

    if (selected_relations == null ||
        selected_relations!.isEmpty ||
        selected_relations!.toLowerCase() == 'select') {
      showToast_Error(AppLocalizations.of(context)!.chhooserelationtothepersoninterviewed);
      return false;
    }


    if (_image == null) {showToast_Error(AppLocalizations.of(context)!.pleaseclickhousepicture);
    return false;
    }
    if (_Mobilereferenceperson1Controller.text.length != 10 ||
        !RegExp(r'^[0-9]{10}$')
            .hasMatch(_Mobilereferenceperson1Controller.text)) {
      showToast_Error(
          AppLocalizations.of(context)!.pleaseenteravalid10digitmobilenumber);
      return false;
    }
    if (_Mobilereferenceperson2Controller.text.length != 10 ||
        !RegExp(r'^[0-9]{10}$')
            .hasMatch(_Mobilereferenceperson2Controller.text)) {
      showToast_Error(
          AppLocalizations.of(context)!.pleaseenteravalid10digitmobilenumber);
      return false;
    }

  /*  String value = _DistancetobranchController.text;

    if (value.isNotEmpty && totalDistance != null) {
      double enteredValue = double.tryParse(value) ?? 0.0;

      if (enteredValue > totalDistance!) {
        showToast_Error(
            'Please enter a valid distance from the borrowers house to the branch'
        );
        return false;
      }else{
        return true;
      }
     // return false;
    }*/



    return true;
  }
  void showToast_Error(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xFFD42D3F),
        textColor: Colors.white,
        fontSize: 13.0);
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371; // in kilometers

    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) * cos(_degToRad(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _degToRad(double degree) {
    return degree * pi / 180;
  }


// Future<void> geolocator() async {
//   try {
//     Position position = await _getCurrentPosition();
//     setState(() {
//       _locationMessage =
//       "${position.latitude},${position.longitude}";
//       print(
//           " geolocatttion: $_locationMessage");
//       _latitude = position.latitude;
//       _longitude =position.longitude;
//     });
//   } catch (e) {
//     setState(() {
//       _locationMessage = e.toString();
//     });
//     print(
//         " geolocatttion: $_locationMessage");
//   }
// }
// Future<Position> _getCurrentPosition() async {
//   bool serviceEnabled;
//   LocationPermission permission;
//
//   // Check if location services are enabled.
//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     return Future.error('Location services are disabled.');
//   }
//
//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       return Future.error('Location permissions are denied');
//     }
//   }
//
//   if (permission == LocationPermission.deniedForever) {
//     return Future.error(
//         'Location permissions are permanently denied, we cannot request permissions.');
//   }
//
//   // When permissions are granted, get the position of the device.
//   return await Geolocator.getCurrentPosition();
// }

/*  void _showSuccessAndRedirect(GlobalModel response) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(
              response.message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => OnBoarding()),
                );
              },
            ),],
        );
      },
    );
  }*/


  Future<void> initializeCamera() async {
    cameras =  await availableCameras();
  }
}
