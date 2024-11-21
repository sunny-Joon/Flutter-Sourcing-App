import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sourcing_app/GlobalClass.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'ApiService.dart';

class HouseVisitForm extends StatefulWidget {

  @override
  _HouseVisitFormState createState() => _HouseVisitFormState();
}

class _HouseVisitFormState extends State<HouseVisitForm> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final picker = ImagePicker();


  List<String> relation = ['Select','mother','father','husband','wife','brother','sister'];
  List<String> residing_type = ['Select','motherpucca','kaccha'];
  List<String> residing_with = ['Select','family','separately'];
  List<String> years = ['Select','1','2','3','4','5','5++'];
  List<String> ratings = ['Select','good','bad','dontKnow'];
  List<String> relations = ['Select','spouse','parents','siblings'];

  String selected_relation ="";
  String selected_residing_type ="";
  String selected_residing_with ="";
  String selected_years ="";
  String selected_years2 ="";
  String selected_ratings ="";
  String selected_relations ="";


  final  _BranchNameController = TextEditingController();
  final  _AreaCodeController = TextEditingController();
  final  _AreaNameController = TextEditingController();
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

  String housetype="False";
  String isvalidlocation="False";
  String cpflifestyle="False";
  String cpfpoaddressverify="False";
  String photoidverification="False";
  String currentaddressprof="False";
  String hasbandwifeageverificaton="False";
  String parmanentaddresspincode="False";
  String stamponphotocopy="False";
  String lastloanverification="False";
  String absentreasonincentermeeting="False";
  String repaymentfault="False";
  String loanreasonverification="False";
  String isappliedamountappropriate="False";
  String familyawarenessaboutloan="False";
  String businessaffectedourrelation="False";
  String isloanappropriateforbusiness="False";
  String repayeligiblity="False";
  String cashflowoffamily="False";
  String incomematchedwithprofile="False";
  String businessverification="False";
  String comissiondemand="False";
  String borrowersupportedgroup="False";
  String groupreadytovilay="False";
  String grouphasbloodrelation="False";
  String understandinsaurancepolicy="False";
  String verifyexternalloan="False";
  String understandsfaultpolicy="False";
  String overlimitloan_borrowfromgroup="False";
  String toatldebtunderlimit="False";
  String workingplaceverification="False";
  String isworkingplacevalid="False";
  String workingplacedescription="False";
  String workexperience="False";
  String seasondependency="False";
  String stockverification="False";
  String loansufficientwithdebt="False";


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
    return Scaffold(
      appBar: AppBar(
        title: Text('House Visit Form'),
        backgroundColor: Color(0xFF940C1B),
      ),
      backgroundColor: Color(0xFFD42D3F),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                _buildTextField2('शाखा', _BranchNameController, TextInputType.number),
                _buildTextField2('क्षेत्र', _AreaCodeController, TextInputType.number),
                _buildTextField2('AreaName', _AreaNameController, TextInputType.number),
                _buildTextField2('केन्द्र', _CenterController, TextInputType.number),
                _buildTextField2('ग्राह के लिये ऋण उपयोग के प्रतिशत का उल्लेख करें।', _LoanUsagePercentageController, TextInputType.number),
                _buildTextField2('व्यापार से अनुमानित मासिक आय (रुपयों में)', _monthlyIncomeController, TextInputType.number),
                _buildTextField2('अनुमानित मासिक बिक्री (रुपयों में)(या तो सेल का कोई रिकार्ड है उससे सत्यापन करें या ग्राहक से विचार विमर्श के माध्यम से)', _monthlySalesController, TextInputType.number),
                _buildTextField2('साक्षात्कार किये गये व्यक्ति का नाम', _NameofInterviewedController, TextInputType.number),
                _buildTextField2('साक्षात्कार किये गये व्यक्ति की आयु', _AgeofInterviewedController, TextInputType.number),
                _buildTextField2('आवेदक के निवास से शाखा/डीलर बिंदु तक की दूरी (किमी में)', _DistancetobranchController, TextInputType.number),
                _buildTextField2('शाखा/डीलर के स्थान से आवेदक के निवास तक पहुंचने के लिए आवश्यक समय(मिनट)', _TimetoreachbranchController, TextInputType.number),
                _buildTextField2('व्यवसाय का कुल मासिक व्यय', _TotalmonthlyexpensesofoccupationController, TextInputType.number),
                _buildTextField2('पैसालो से प्रस्तावित ऋण के बाद प्रस्तावित शुद्ध मासिक आय', _Netmonthlyincome_afterproposedloanController, TextInputType.number),
                _buildTextField2('कुल मासिक घरेलू खर्च', _TotalmonthlyhouseholdexpensesController, TextInputType.number),
                _buildTextField2('परिवार के अन्य सदस्यों की शुद्ध मासिक आय', _NetmonthlyincomeotherfamilymembersController, TextInputType.number),
                _buildTextField2('संदर्भ व्यक्ति का नाम 1', _Namereferenceperson1Controller, TextInputType.number),
                _buildTextField2('फोन नंबर 1', _Mobilereferenceperson1Controller, TextInputType.number),
                _buildTextField2(' संदर्भ व्यक्ति का नाम 2', _Namereferenceperson2Controller, TextInputType.number),
                _buildTextField2('फोन नंबर 2', _Mobilereferenceperson2Controller, TextInputType.number),
                _buildTextField2('व्यवसाय स्थान का पता', _AddressController, TextInputType.number),


                dropdowns('Relationearningmember', relation, selected_relation, (newValue) {setState(() {selected_relation = newValue;});}),
                dropdowns(' निवास का प्रकार', residing_type, selected_residing_type, (newValue) {setState(() {selected_residing_type = newValue;});}),
                dropdowns('रहने वाले', residing_with, selected_residing_with, (newValue) {setState(() {selected_residing_with = newValue;});}),
                dropdowns('feedbacknearbyresident', years, selected_years, (newValue) {setState(() {selected_years = newValue;});}),
                dropdowns('वर्तमान व्यवसाय में कुल अनुभव (वर्षों में)', years, selected_years2, (newValue) {setState(() {selected_years2 = newValue;});}),
                dropdowns(' आवासीय स्थिरता (वर्ष)', ratings, selected_ratings, (newValue) {setState(() {selected_ratings = newValue;});}),
                dropdowns('RelationofInterviewer', relations, selected_relations, (newValue) {setState(() {selected_relations = newValue;});}),


                checkboxes('आवासीय मानदण्डों के अनुसार घर की छत व दीवारों का प्रकार।', housetype, (newValue) {setState(() {housetype = newValue;});},),
                checkboxes('ग्राहक स्वीकृत / अनुमोदित क्षेत्र में रहता है।', isvalidlocation, (newValue) {setState(() {isvalidlocation = newValue;});},),
                checkboxes('सीपीएफ अनुभाग / सैक्शनमें वर्णित आवासीय सूचना के अनुसार जीवन शैली (अति निम्न, निम्न, निम्न मध्यवर्गीय श्रेणी)।', cpflifestyle, (newValue) {setState(() {cpflifestyle = newValue;});},),
                checkboxes('ऋण आवेदनपत्र, सीपी एवम् अपने ग्राहक को जानिये पेपर्स का सत्यापन', cpfpoaddressverify, (newValue) {setState(() {cpfpoaddressverify = newValue;});},),
                checkboxes('PhotoIdVerification', photoidverification, (newValue) {setState(() {photoidverification = newValue;});},),
                checkboxes('CurrentAddressprof', currentaddressprof, (newValue) {setState(() {currentaddressprof = newValue;});},),
                checkboxes('HasbandWifeAgeverificaton', hasbandwifeageverificaton, (newValue) {setState(() {hasbandwifeageverificaton = newValue;});},),
                checkboxes('ParmanentAddressPincode', parmanentaddresspincode, (newValue) {setState(() {parmanentaddresspincode = newValue;});},),
                checkboxes('उक्त फार्म के सत्यापित किये गये छाया प्रतियों पर मूल प्रति से मिलान किया की मुहर लगायें तथाहस्ताक्षर करें।', stamponphotocopy, (newValue) {setState(() {stamponphotocopy = newValue;});},),
                checkboxes('क्या ग्राहक ने पिछले ऋण का उपयोग उसी प्रयोजन के लिये किया जिसके लिये लिया गया था?', lastloanverification, (newValue) {setState(() {lastloanverification = newValue;});},),
                checkboxes(' सेन्टर मीटिंग से अनुपस्थिति के कारणों की जांच करें।', absentreasonincentermeeting, (newValue) {setState(() {absentreasonincentermeeting = newValue;});},),
                checkboxes('भुगतान दोष / देरी के कारणों की सत्यता की जांच करें। यदि ये इरादतन हो तो इस ग्राहक के केस में आगे न बढ़ें।', repaymentfault, (newValue) {setState(() {repaymentfault = newValue;});},),
                checkboxes('LoanreasonVerification', loanreasonverification, (newValue) {setState(() {loanreasonverification = newValue;});},),
                checkboxes('चैक करे कि आवेदित राशि उक्त उद्देश्यपूर्ति के लिये उचित है।', isappliedamountappropriate, (newValue) {setState(() {isappliedamountappropriate = newValue;});},),
                checkboxes('FamilyAwarenessaboutloan', familyawarenessaboutloan, (newValue) {setState(() {familyawarenessaboutloan = newValue;});},),
                checkboxes('Businessaffectedourrelation', businessaffectedourrelation, (newValue) {setState(() {businessaffectedourrelation = newValue;});},),
                checkboxes('IsloanAppropriateforBusiness', isloanappropriateforbusiness, (newValue) {setState(() {isloanappropriateforbusiness = newValue;});},),
                checkboxes('Repayeligiblity', repayeligiblity, (newValue) {setState(() {repayeligiblity = newValue;});},),
                checkboxes('Cashflowoffamily', cashflowoffamily, (newValue) {setState(() {cashflowoffamily = newValue;});},),
                checkboxes(' पैसालो से प्रस्तावित ऋण के बाद प्रस्तावित शुद्ध मासिक आय', incomematchedwithprofile, (newValue) {setState(() {incomematchedwithprofile = newValue;});},),
                checkboxes('सभी ऋणों के लिये ग्राहक के व्यवसाय का सत्यापन अनिवार्य है (रु. 35000/- से अधिक के सभी ऋणों के लिये व्यवसाय स्थल पर इस भाग को भरें।', businessverification, (newValue) {setState(() {businessverification = newValue;});},),
                checkboxes('ऋण के लिये आवेदन करते समय क्या किसी ने कमीशन की मांग की।', comissiondemand, (newValue) {setState(() {comissiondemand = newValue;});},),
                checkboxes('BorrowersupportedGroup', borrowersupportedgroup, (newValue) {setState(() {borrowersupportedgroup = newValue;});},),
                checkboxes('क्या ग्राहक समूह विलय के लिये सहमत है (तभी लागू जब विलयपत्र आवेदन पत्र के साथ संलग्न किया गया है।)।', groupreadytovilay, (newValue) {setState(() {groupreadytovilay = newValue;});},),
                checkboxes('समूह में खून के रिश्तेदार के लिये जांच (नीति के रूप में परिभाषित)।', grouphasbloodrelation, (newValue) {setState(() {grouphasbloodrelation = newValue;});},),
                checkboxes('UnderstandInsaurancePolicy', understandinsaurancepolicy, (newValue) {setState(() {understandinsaurancepolicy = newValue;});},),
                checkboxes(' सत्यापित करें कि ग्राहक प्रोफाइल फार्म में बाहरी ऋण सम्बन्धी दी गयी सूचना से ग्राहक की ऋण उधारी मिलती है। ', verifyexternalloan, (newValue) {setState(() {verifyexternalloan = newValue;});},),
                checkboxes(' क्या ग्राहक उस पर क्रेडिट ब्यूरो के प्रभाव को समझता है कि यदि उसने भुगतान दोष किया तो उसे भविष्य में ऋण नहीं मिलेगा?', understandsfaultpolicy, (newValue) {setState(() {understandsfaultpolicy = newValue;});},),
                checkboxes('OverlimitLoan_borrowfromgroup', overlimitloan_borrowfromgroup, (newValue) {setState(() {overlimitloan_borrowfromgroup = newValue;});},),
                checkboxes(' सुनिश्चित करे कि ग्राहक की कुल उधारी रु. 50000/- से अधिक नहीं है और एक।', toatldebtunderlimit, (newValue) {setState(() {toatldebtunderlimit = newValue;});},),
                checkboxes('व्यापार स्थल का निरीक्षण किया', workingplaceverification, (newValue) {setState(() {workingplaceverification = newValue;});},),
                checkboxes('जहां कही व्यापार स्थल कार्य करने वाली परिधि के बाहर है (वहां सत्यापन परिवार के सदस्यों, समूह सदस्यों व पड़ोसियों के माध्यम से सुनिश्चित करें) डी० एम० के अनुमोदन की मेल संलग्न है।', isworkingplacevalid, (newValue) {setState(() {isworkingplacevalid = newValue;});},),
                checkboxes('व्यापार स्थल का विवरण (अपना किराये पर या लीज़ पर)', workingplacedescription, (newValue) {setState(() {workingplacedescription = newValue;});},),
                checkboxes('कितने वर्षों से व्यापार में है', workexperience, (newValue) {setState(() {workexperience = newValue;});},),
                checkboxes('व्यापार का मौसमी स्वरूप का सत्यापन करें तथा यह सुनिश्चित करे कि ग्राहक के पास में मौसम समय के लिये समुचित नकदी प्रवाह उपलब्ध है जिससे वह हमारे ऋण का समय से भुगतान कर सके।', seasondependency, (newValue) {setState(() {seasondependency = newValue;});},),
                checkboxes('माल (स्टाक) का सत्यापन किया जहाँ कही लागू हो।', stockverification, (newValue) {setState(() {stockverification = newValue;});},),
                checkboxes('यह सुनिचित करें कि आवेदित राशि ऋण के उदेश्य के अनुकूल है।', loansufficientwithdebt, (newValue) {setState(() {loansufficientwithdebt = newValue;});},),

                SizedBox(height: 20),
                _image == null
                    ? Text('No image selected.')
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
                      Text('आवेदक के साथ घर की तस्वीर खींचें'),
                    ],
                  ),
                ),


                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process data
                      saveHouseVisitForm(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Makes the corners square
                    ),
                  ),
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveHouseVisitForm(BuildContext context) async {
    EasyLoading.show(status: 'Loading...',);

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

    String Relationearningmember=selected_relation;
    String Residence_Type=selected_residing_type;
    String Residing_with=selected_residing_with;
    String feedbacknearbyresident=selected_ratings;
    String TotalExperienceOccupation=selected_years;
    String Residential_Stability=selected_years2;
    String RelationofInterviewer=selected_relations;


    String BranchName=_BranchNameController.text.toString();
    String AreaCode=_AreaCodeController.text.toString();
    String AreaName=_AreaNameController.text.toString();
    String Center=_CenterController.text.toString();
    String LoanUsagePercentage=_LoanUsagePercentageController.text.toString();
    int monthlyIncome=int.parse(_monthlyIncomeController.text.toString());
    int monthlySales=int.parse(_monthlySalesController.text.toString());
    String NameofInterviewed=_NameofInterviewedController.text.toString();
    String AgeofInterviewed=_AgeofInterviewedController.text.toString();
    String Distancetobranch=_DistancetobranchController.text.toString();
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

    double Latitude=521.6521;
    double Longitude=56.5615;

    String Applicant_Status="N";
    String FamilymemberfromPaisalo="o";

    String FICode="139";
    String Creator="Creator";
    int HouseMonthlyRent=45;
    String EmpCode="EmpCode";
    String GroupCode="GroupCode";
    String GroupName="GroupName";




    File? Image = _image;

    final api = Provider.of<ApiService>(context, listen: false);

    await api.saveHouseVisit(
      GlobalClass.token,GlobalClass.dbName,
        FICode,
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
        Distancetobranch,
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
        Latitude,
        Longitude,
        EmpCode,
        Address,
        Image!).then((response) {
      if (response.statuscode == 200) {
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
      }
    }).catchError((error) {
      // Handle error
    });
  }


 // _buildTextField2('Any Current EMI', _any_current_EMIController, TextInputType.number),

  Widget _buildTextField2(String label, TextEditingController controller, TextInputType inputType) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white
            ),
          ),
          SizedBox(height: 1),
          Container(
            width: double.infinity, // Set the desired width
            height: 45,
            color: Colors.white,// Set the desired height
            child: Center(
              child: TextFormField(
                controller: controller,
                keyboardType: inputType, // Set the input type
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter $label';
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
            width: double.infinity, // Set the desired width
            height: 45,
            color: Colors.white,// Set the desired height
            child: Row(
                children: [
                  Checkbox(
                    value: _isChecked,
                    checkColor: Colors.red,
                    fillColor: MaterialStateProperty.all(Colors.white),
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
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
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
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
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
}
