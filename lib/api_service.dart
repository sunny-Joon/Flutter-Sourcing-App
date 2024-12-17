import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_sourcing_app/Models/collectionstatus_model.dart';
import 'package:flutter_sourcing_app/Models/qrcode_model.dart';

import 'package:flutter_sourcing_app/Models/common_string_model.dart';

import 'package:flutter_sourcing_app/Models/attendancestatusmodel.dart';
import 'package:flutter_sourcing_app/collection_report.dart';

import 'package:flutter_sourcing_app/collectionborrowerlist.dart';
import 'package:flutter_sourcing_app/Models/collectionborrowerlistmodel.dart';
import 'package:flutter_sourcing_app/Models/bank_names_model.dart';

import 'package:flutter_sourcing_app/Models/details_by_smcode_response.dart';

import 'package:flutter_sourcing_app/Models/getCollectionModel.dart';

import 'package:flutter_sourcing_app/Models/group_model.dart';
import 'package:flutter_sourcing_app/Models/kyc_scanning_model.dart';
import 'package:flutter_sourcing_app/Models/common_int_model.dart';
import 'package:flutter_sourcing_app/Models/leader_board_model.dart';
import 'package:flutter_sourcing_app/Models/place_codes_model.dart';
import 'package:flutter_sourcing_app/Models/qr_payments_model.dart';
import 'package:flutter_sourcing_app/Models/xml_response.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import 'Models/collectionbranchlistmodel.dart';
import 'Models/borrower_list_model.dart';
import 'Models/common_bool_model.dart';
import 'Models/creator_list_model.dart';
import 'Models/global_model.dart';
import 'Models/global_model2.dart';
import 'Models/kyc_update_model.dart';
import 'Models/range_category_model.dart';
import 'Models/adhaar_model.dart';
import 'Models/branch_model.dart';
import 'Models/docs_verify.dart';
import 'Models/get_all_model.dart';
import 'Models/ifsc.dart';
import 'Models/login_model.dart';
import 'Models/ocr_response_model.dart';
import 'Models/track_location_request.dart';
part 'api_service.g.dart';



class ApiConfig {
  static const String baseUrl1 = 'https://predeptest.paisalo.in:8084/MobColen/api/';
  static const String baseUrl2 = 'https://agra.paisalo.in:8462/creditmatrix/api/';
  static const String baseUrl3 = 'https://ifsc.razorpay.com/';
  static const String baseUrl4 = 'https://agra.paisalo.in:8462/creditmatrix/api/';
  static const String baseUrl5 = 'https://erpservice.paisalo.in:980/PDL.KYC.API/api/';
  static const String baseUrl6 = 'https://ocr.paisalo.in:950/api/';
  static const String baseUrl7 = 'https://predeptest.paisalo.in:8084/PDL.ESign.API/api/';
  static const String baseUrl8 = 'https://apiuat.paisalo.in:4015/PDLDocReports/api/';

}



// @RestApi(baseUrl: "https://predeptest.paisalo.in:8084/MobColen/api/")

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;


  static ApiService create({required String baseUrl}) {

    final dio = Dio();
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );

    return ApiService(dio,baseUrl: baseUrl);

  }

  @POST("Account/GetToken")
  Future<LoginModel> getLogins(
      @Header("devid") String devid,
      @Header("dbname") String dbname,
      @Body() Map<String, dynamic> body);

  @POST("IMEIMapping/InsertDevicedata")
  Future<GlobalModel> getImeiMappingReq(
      @Header("dbname") String dbname,
      @Body() Map<String, dynamic> body);

  @POST("FiSourcing/InsertMonthlyTarget")
  Future<GlobalModel> insertMonthlytarget(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Body() Map<String, dynamic> body);

  @GET("Tracklocations/GetAppLink")
  Future<GlobalModel> VersionCheck(

      @Header("dbname") String dbName,
      @Query("version") String version,
      @Query("AppName") String AppName,
      @Query("action") String action);

  @GET("Masters/GetRangeCategories")
  Future<RangeCategoryModel> RangeCategory(
      @Header("Authorization") String token,
      @Header("dbname") String dbName);

  @GET("FiSourcing/DeleteGuarantor")
  Future<GlobalModel> deleteGurrantor(
      @Header("Authorization") String token,
      @Header("dbname") String dbName,
      @Header("Fi_Id") String Fi_Id);

  @GET("Collection/CollectionStatus")
  Future<CollectionStatusModel> collectionStatus(
      @Header("Authorization") String token,
      @Header("dbname") String dbName,
      @Query("SmCode") String SmCode);


  @POST("IdentityVerification/Get")
  Future<DocsVerify> verifyDocs(
      @Body() Map<String, dynamic> body);

  @POST("Masters/CreatePunchInOrOut")
  Future<GlobalModel> punchInOut(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Body() Map<String, dynamic> body,
      @Query("type") String type);

  @POST("Masters/SendSms")
  Future<CommonIntModel> mobileOtpSend(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Body() Map<String, dynamic> body);

  @GET("{ifsc}")
  Future<Ifcsc> ifscVerify (@Path("ifsc") String ifsc);

  @POST("FiSourcing/InsertFiSourcedata")
  @MultiPart()
  Future <GlobalModel> saveFi(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Part(name: "aadhar_no") String aadharNo,
      @Part( name:"title") String title,
      @Part( name:"f_Name") String fName,
      @Part( name:"m_Name") String mName,
      @Part( name:"l_Name") String lName,
      @Part( name:"dob") String dob,
      @Part( name:"Age") String age,
      @Part( name:"gender") String gender,
      @Part( name:"p_Phone") String pPhone,
      @Part( name:"fatheR_FIRST_NAME") String fatherFirstName,
      @Part( name:"fatheR_MIDDLE_NAME") String fatherMiddleName,
      @Part( name:"fatheR_LAST_NAME") String fatherLastName,
      @Part( name:"spousE_FIRST_NAME") String spouseFirstName,
      @Part( name:"spousE_MIDDLE_NAME") String spouseMiddleName,
      @Part( name:"spousE_LAST_NAME") String spouseLastName,
      @Part( name:"creator") String creator,
      @Part( name:"expense") int expense,
      @Part( name:"income") int income,
      @Part( name:"latitude") double latitude,
      @Part( name:"longitude") double longitude,
      @Part( name:"P_Address1") String currentAddress1,
      @Part( name:"P_Address2") String currentAddress2,
      @Part( name:"P_Address3") String currentAddress3,
      @Part( name:"P_City") String currentCity,
      @Part( name:"P_Pincode") String currentPincode,
      @Part( name:"P_State") String currentState,
      @Part( name:"IsMarried") bool isMarried,
      @Part( name:"GroupCode") String groupCode,
      @Part( name:"BranchCode") String branchCode,
      @Part( name:"Relation_with_Borrower") String relation_with_Borrower,
      @Part( name:"Bank_name") String bank_name,
      @Part( name:"Loan_Duration") String loan_Duration,
      @Part( name:"Loan_amount") String loan_amount,
      @Part( name:"Loan_Reason") String loan_Reason,
      @Part( name: "Picture") File Picture);

  @POST("FiSourcing/FiDocsUploads")
  @MultiPart()
  Future <GlobalModel> FiDocsUploads(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Part(name: "FI_ID") String FI_ID,
      @Part(name: "GrNo") String GrNo,
      @Part(name: "AadhaarCard") File? AadhaarCard,
      @Part( name:"AadhaarCardBack") File? AadhaarCardBack,
      @Part( name:"VoterId") File? VoterId,
      @Part( name:"VoterIdBack") File? VoterIdBack,
      @Part( name:"DrivingLicense") File? DrivingLicense,
      @Part( name:"Pan") File? Pan,
      @Part( name:"PassPort") File? PassPort,
      @Part( name:"PassBook") File? PassBook,
      );

  @POST("FiSourcing/FiDocsUploadSingleFile")
  @MultiPart()
  Future <GlobalModel> uploadFiDocs(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Part( name:"FI_ID") String FI_ID,
      @Part( name:"GrNo") int GrNo,
      @Part( name: "CheckListId") int CheckListId,
      @Part( name: "Remarks") String Remarks,
      @Part( name: "FileName") File FileName);

  @POST("FiSourcing/AddFiIDs")
  Future <GlobalModel> addFiIds(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Body() Map<String, dynamic> body);

  @POST("FiSourcing/AddFiIDs")
  Future <GlobalModel> getIdVerify(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Body() Map<String, dynamic> requestBody);

  @POST("FiSourcing/AddFiFamilyDetail")
  Future <GlobalModel> FiFamilyDetail(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Body() Map<String, dynamic> body);

  @POST("FiSourcing/AddFiIncomeAndExpense")
  Future <GlobalModel> AddFiIncomeAndExpense(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Body() Map<String, dynamic> body);

  @POST("FiSourcing/AddFinancialInfo")
  Future <GlobalModel> AddFinancialInfo(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Body() Map<String, dynamic> body);

  @GET("Masters/GetBankName")
  Future <BankNamesModel> bankNames(
      @Header("Authorization") String token,
      @Header("dbname") String dbname);

  @POST("Tracklocations/CreateFiVerfiedInfo")
  Future <GlobalModel> FiVerifiedInfo(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Body() Map<String, dynamic> body);

  @POST("FiSourcing/InsertFIFamilyIncome")
  Future <GlobalModel> FIFamilyIncome(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Body() Map<String, dynamic> body);

  @POST("FiSourcing/AddFiGaurantor")
  @MultiPart()
  Future <GlobalModel> saveGurrantor(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Part( name:"fi_ID") String fi_ID,
      @Part( name:"gr_Sno") String gr_Sno,
      @Part( name:"title") String title,
      @Part( name:"fname") String fname,
      @Part( name:"mname") String mname,
      @Part( name:"lname") String lname,
      @Part( name:"GuardianName") String GuardianName,
      @Part( name:"relation_with_Borrower") String relation_with_Borrower,
      @Part( name:"p_Address1") String p_Address1,
      @Part( name:"p_Address2") String p_Address2,
      @Part( name:"p_Address3") String p_Address3,
      @Part( name:"p_City") String p_City,
      @Part( name:"p_State") String p_State,
      @Part( name:"pincode") String pincode,
      @Part( name:"dob") String dob,
      @Part( name:"age") String age,
      @Part( name:"phone") String phone,
      @Part( name:"pan") String pan,
      @Part( name:"dl") String dl,
      @Part( name:"voter") String voter,
      @Part( name:"aadharId") String aadharId,
      @Part( name:"gender") String gender,
      @Part( name:"religion") String religion,
      @Part( name:"esign_Succeed") bool esign_Succeed,
      @Part( name:"esign_UUID") String esign_UUID,
      @Part( name: "Picture") File Picture);

  @GET("Masters/GetAllCreators")
  Future<CreatorListModel> getCreatorList(
      @Header("dbname") String dbname);

  @GET("Masters/GetBranchCode")
  Future<BranchModel> getBranchList(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Query("Creator") String Creator);

  @GET("FiSourcing/GetAllFiData")
  Future<ApplicationgetAllModel> dataByFIID(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Query("FI_ID") int FI_ID);

  @GET("Masters/GetGroupCode")
  Future<GroupModel> getGroupList(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Query("Creator") String Creator,
      @Query("BranchCode") String BranchCode);

  @GET("Collection/GetQrPaymentsBySmcode")
  Future<QrPaymentsModel> qrPayments(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Query("SmCode") String SmCode,
      @Query("userid") String userid,
      @Query("type") String type);

  @GET("Collection/GetFiCollection")
  Future<GetCollectionModel> GetFiCollection(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Query("SmCode") String SmCode,
      @Query("GetDate") String GetDate);

  @GET("Masters/GetMobileAppAttendance")
  Future<AttendanceStatusModel> AttendanceStatus(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Query("UserName") String UserName);

  @POST("Collection/SaveReceipt")
  Future<CommonBoolModel> RcPosting(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Body() Map<String, dynamic> body);

  @POST("FiSourcing/AddFiExtraDetail")
  Future<GlobalModel> updatePersonalDetails(
      @Header("dbname") String dbname,
      @Header("Authorization") String token,
      @Body() Map<String, dynamic> body);

  @POST("Tracklocations/InsertMorphoRechargeDetails")
  Future<GlobalModel> morphorecharge(
      @Header("dbname") String dbname,
      @Header("Authorization") String token,
      @Body() Map<String, dynamic> body);



  @POST("Tracklocations/CreateHomeVisit")
  @MultiPart()
  Future <GlobalModel> saveHouseVisit(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Part(name: "fi_Id") String fi_Id,
      @Part( name:"Creator") String Creator,
      @Part( name:"BranchName") String BranchName,
      @Part( name:"AreaCode") String AreaCode,
      @Part( name:"AreaName") String AreaName,
      @Part( name:"Center") String Center,
      @Part( name:"GroupCode") String GroupCode,
      @Part( name:"GroupName") String GroupName,
      @Part( name:"HouseType") String HouseType,
      @Part( name:"IsvalidLocation") String IsvalidLocation,
      @Part( name:"CPFlifeStyle") String CPFlifeStyle,
      @Part( name:"CpfPOAddressVerify") String CpfPOAddressVerify,
      @Part( name:"PhotoIdVerification") String PhotoIdVerification,
      @Part( name:"CurrentAddressprof") String CurrentAddressprof,
      @Part(name: "HasbandWifeAgeverificaton") String HasbandWifeAgeverificaton,
      @Part( name:"ParmanentAddressPincode") String ParmanentAddressPincode,
      @Part( name:"StampOnPhotocopy") String StampOnPhotocopy,
      @Part( name:"LastLoanVerification") String LastLoanVerification,
      @Part( name:"LoanUsagePercentage") String LoanUsagePercentage,
      @Part( name:"AbsentReasonInCentermeeting") String AbsentReasonInCentermeeting,
      @Part( name:"RepaymentFault") String RepaymentFault,
      @Part( name:"LoanreasonVerification") String LoanreasonVerification,
      @Part( name:"IsAppliedAmountAppropriate") String IsAppliedAmountAppropriate,
      @Part( name:"FamilyAwarenessaboutloan") String FamilyAwarenessaboutloan,
      @Part( name:"IsloanAppropriateforBusiness") String IsloanAppropriateforBusiness,
      @Part( name:"Businessaffectedourrelation") String Businessaffectedourrelation,
      @Part( name:"Repayeligiblity") String Repayeligiblity,
      @Part( name:"Cashflowoffamily") String Cashflowoffamily,
      @Part( name:"IncomeMatchedwithprofile") String IncomeMatchedwithprofile,
      @Part( name:"BorrowersupportedGroup") String BorrowersupportedGroup,
      @Part( name:"ComissionDemand") String ComissionDemand,
      @Part( name:"GroupReadyToVilay") String GroupReadyToVilay,
      @Part( name:"GroupHasBloodRelation") String GroupHasBloodRelation,
      @Part( name:"VerifyExternalLoan") String VerifyExternalLoan,
      @Part( name:"UnderstandsFaultPolicy") String UnderstandsFaultPolicy,
      @Part( name:"OverlimitLoan_borrowfromgroup") String OverlimitLoan_borrowfromgroup,
      @Part( name:"toatlDebtUnderLimit") String toatlDebtUnderLimit,
      @Part( name:"workingPlaceVerification") String workingPlaceVerification,
      @Part( name:"IsWorkingPlaceValid") String IsWorkingPlaceValid,
      @Part( name:"workingPlacedescription") String workingPlacedescription,
      @Part( name:"workExperience") String workExperience,
      @Part( name:"SeasonDependency") String SeasonDependency,
      @Part( name:"StockVerification") String StockVerification,
      @Part( name:"monthlyIncome") int monthlyIncome,
      @Part(name: "monthlySales") int monthlySales,
      @Part( name:"loansufficientwithdebt") String loansufficientwithdebt,
      @Part( name:"NameofInterviewed") String NameofInterviewed,
      @Part( name:"AgeofInterviewed") String AgeofInterviewed,
      @Part( name:"RelationofInterviewer") String RelationofInterviewer,
      @Part( name:"Applicant_Status") String Applicant_Status,
      @Part( name:"Residing_with") String Residing_with,
      @Part( name:"FamilymemberfromPaisalo") String FamilymemberfromPaisalo,
      @Part( name:"HouseMonthlyRent") int HouseMonthlyRent,
      @Part( name:"Residence_Type") String Residence_Type,
      @Part( name:"Residential_Stability") String Residential_Stability,
      @Part( name:"Distancetobranch") String Distancetobranch,
      @Part( name:"Timetoreachbranch") String Timetoreachbranch,
      @Part( name:"TotalExperienceOccupation") String TotalExperienceOccupation,
      @Part( name:"Totalmonthlyexpensesofoccupation") int Totalmonthlyexpensesofoccupation,
      @Part( name:"Netmonthlyincome_afterproposedloan") int Netmonthlyincome_afterproposedloan,
      @Part( name:"Totalmonthlyhouseholdexpenses") int Totalmonthlyhouseholdexpenses,
      @Part( name:"Netmonthlyincomeotherfamilymembers") int Netmonthlyincomeotherfamilymembers,
      @Part( name:"Relationearningmember") String Relationearningmember,
      @Part( name:"Namereferenceperson1") String Namereferenceperson1,
      @Part( name:"Mobilereferenceperson1") String Mobilereferenceperson1,
      @Part( name:"Namereferenceperson2") String Namereferenceperson2,
      @Part( name:"Mobilereferenceperson2") String Mobilereferenceperson2,
      @Part( name:"feedbacknearbyresident") String feedbacknearbyresident,
      @Part( name:"UnderstandInsaurancePolicy") String UnderstandInsaurancePolicy,
      @Part( name:"BusinessVerification") String BusinessVerification,
      @Part( name:"Latitude") double Latitude,
      @Part( name:"Longitude") double Longitude,
      @Part( name:"EmpCode") String EmpCode,
      @Part( name:"Address") String Address,
      @Part( name: "Image") File Picture );

  @GET("FiSourcing/GetDataForEsign")
  Future<BorrowerListModel> BorrowerList(
      @Header("Authorization") String token,
      @Header("dbname") String dbName,
      @Query("Group_code") String Group_code,
      @Query("Branch_code") String Branch_code,
      @Query("Creator") String Creator,
      @Query("Type") int Type,
      );

  @GET("Collection/GetPandingCollectionGroupCode")
  Future<CollectionBorrowerListModel> CollectionBorrowerList(
      @Header("Authorization") String token,
      @Header("dbname") String dbName,
      @Query("Imei") String Imei,
      @Query("BranchCode") String BranchCode,
      @Query("GroupCode") String GroupCode,
      @Query("UserId") String UserId,
      @Query("GetDate") String GetDate,
      );

  @GET("Collection/Getmappedfoforcoll")
  Future<CollectionBranchListModel> CollectionBranchList(
      @Header("Authorization") String token,
      @Header("dbname") String dbName,
      @Query("Imei") String Imei,
      @Query("UserId") String UserId,
      );

  @GET("FiSourcing/GetFiUploadedDocuments")
  Future<KycScanningModel> KycScanning(
      @Header("Authorization") String token,
      @Header("dbname") String dbName,
      @Query("Fi_Id") String Fi_Id);

  @GET("Collection/GetQRLinkStatus")
  Future<QrCodeModel> QrGeneration(
      @Header("Authorization") String token,
      @Header("dbname") String dbName,
      @Query("SmCode") String SmCode,
      @Query("Type") String Type);


  @POST("IdentityVerification/Get")
  Future<dynamic> verifyIdentity(@Body() Map<String, dynamic> body);

  @POST("Collection/RcPromiseToPay")
  Future<GlobalModel> promiseToPay(@Header("Authorization") String token,
      @Header("dbname") String dbName,@Body() Map<String, dynamic> body);


  @POST("DocVerify/GetDLDetails")
  Future<dynamic> getDLDetailsProtean(@Body() Map<String, dynamic> body);

  @POST("DocVerify/GetVoterDetails")
  Future<dynamic> getVoteretailsProtean(@Body() Map<String, dynamic> body);


  @GET("FiSourcing/GetVillageStateDistrict")
  Future<PlaceCodesModel> getVillageStateDistrict(

      @Header("Authorization") String token,
      @Header("dbname") String dbName,
      @Query("Type") String type,
      @Query("SubDistrictCode") String? subDistrictCode,
      @Query("DistrictCode") String? districtCode,
      @Query("StateCode") String stateCode,
      );



  @POST("OCR/DocVerifyforSpaceOCR")
  @MultiPart()
  Future<OcrResponse> uploadDocument(
      @Query("imgType") String imgType,
      @Part(name: "file") File file,
      );


  @GET("Masters/OTPVerify")
  Future<CommonIntModel> otpVerify(
      @Header("Authorization") String token,
      @Header("dbname") String dbName,
      @Query("MobileNo") String mobileNo,
      @Query("Otp") String otp
      );

  @GET("FiSourcing/GetAllAdharData")
  Future<AdhaarModel> dataByAdhaar(
      @Header("Authorization") String token,
      @Header("dbname") String dbName,
      @Query("AdharCard") String AdharCard
      );

  @GET("Tracklocations/GetAchievementDetails")
  Future<LeaderboardModel> leaderboardList(
      @Header("Authorization") String token,
      @Header("dbname") String dbName,
      @Query("Type") String Type,
      @Query("Fromdate") String Fromdate,
      @Query("Todate") String Todate);


  @POST("e_SignMobile/SaveAgreements")
  @MultiPart()
  Future<dynamic> saveAgreements(
      @Part(name: "Ficode") String ficode,
      @Part(name: "Creator") String creator,
      @Part(name: "ConsentText") String consentText,
      @Part(name: "authMode") String authMode,
      @Part(name: "F_Id") String fId,
      @Part(name: "SignType") String signType,
      );

  @FormUrlEncoded()
  @POST("E_Sign/XMLReaponseNew")
  Future<XmlResponse> sendXMLtoServer(
      @Field("msg") String msg,
      );


  @POST("Ckyc/SearchCkycNoByAadhar")
  Future<GlobalModel> searchCkycNoByAadhar(
      @Header("Authorization") String token,
      @Header("dbname") String dbName,
    @Query("AadharId")  String aadharId,
    @Query("PanNo")  String panNo,
    @Query("VoterId") String voterId,
    @Query("DOB")  String dob,
    @Query("Gender")  String gender,
    @Query("Name")  String name,
  );

  @POST("Tracklocations/CreateLiveTrack")
  Future<GlobalModel> createLiveTrack(
      @Body() TrackLocationRequest request,
      @Header("dbname") String dbname,
      @Header("Authorization") String authorization,
      );

  @GET("FiSourcing/GetBorrowerDetails")
  Future<DetailsBySMcodeResponse> getBorrowerDetails(
    @Query("SmCode") String smcode,
      @Header("dbname") String dbname,
      @Header("Authorization") String authorization,

      );

  @POST("Tracklocations/InsertBranchVisit")
  @MultiPart()
  Future<GlobalModel> insertBranchVisit(
      @Header("dbname")  String dbName,
      @Header("Authorization")  String authorization,
      @Part(name: "VisitType")  String visitType,
      @Part(name: "SmCode")  String smCode,
      @Part(name: "Amount")  String amount,
      @Part(name: "Lat")  String lat,
      @Part(name: "Long")  String long,
      @Part(name: "UserId")  String userId,
      @Part(name: "Remarks")  String remarks,
      @Part(name: "Address")  String address,
      @Part(name: "Picture")  File picture
      );



  @GET("DocGen/GetDocument")
  Future<CommonStringModel> getDocument(@Body() Map<String, dynamic> body);
}

