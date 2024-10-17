import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_sourcing_app/Models/GroupModel.dart';
import 'package:flutter_sourcing_app/Models/KYCModel.dart';
import 'package:flutter_sourcing_app/Models/target_response_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import 'Models/BorrowerListModel.dart';
import 'Models/CreatorListModel.dart';
import 'Models/GlobalModel.dart';
import 'Models/KycUpdateModel.dart';
import 'Models/BranchListModel.dart';
import 'Models/RangeCategoryModel.dart';
import 'Models/branch_model.dart';
import 'Models/login_model.dart';

part 'ApiService.g.dart';
@RestApi(baseUrl: "https://predeptest.paisalo.in:8084/MobColen/api/")
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  static ApiService create() {
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
    return ApiService(dio);
  }

  @POST("Account/GetToken")
  Future<LoginModel> getLogins(
      @Header("devid") String devid,
      @Header("dbname") String dbname,
      @Body() Map<String, dynamic> body,
      );

  @POST("FiSourcing/InsertFiSourcedata")
  @MultiPart()
  Future <KycModel> saveFi(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Part(name: "aadhar_no") String aadharNo,
      @Part( name:"title") String title,
      @Part( name:"f_Name") String fName,
      @Part( name:"m_Name") String mName,
      @Part( name:"l_Name") String lName,
      @Part( name:"dob") String dob,
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
      @Part( name:"current_Address1") String currentAddress1,
      @Part( name:"current_Address2") String currentAddress2,
      @Part( name:"current_Address3") String currentAddress3,
      @Part( name:"current_City") String currentCity,
      @Part( name:"current_Pincode") String currentPincode,
      @Part( name:"current_State") String currentState,
      @Part( name:"IsMarried") bool isMarried,
      @Part( name:"GroupCode") String groupCode,
      @Part( name:"BranchCode") String branchCode,
      @Part( name: "Picture") File Picture);

  @POST("FiSourcing/AddFiIDs")
  Future <GlobalModel> addFiIds(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Body() Map<String, dynamic> body);

  @POST("LiveTrack/InsertMonthTargetCSO")
  Future <TargetResponseModel> setTarget(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Body() Map<String, dynamic> body);


  @GET("Masters/GetAllCreators")
  Future<CreatorListModel> getCreatorList(
      @Header("dbname") String dbname);

  @GET("Masters/GetBranchCode")
  Future<BranchModel> getBranchList(
      @Header("dbname") String dbname,
      @Query("Creator") String Creator);

  @GET("Masters/GetGroupCode")
  Future<GroupModel> getGroupList(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Query("Creator") String Creator,
      @Query("BranchCode") String BranchCode);

  @POST("IMEIMapping/InsertDevicedata")
  Future<GlobalModel> getImeiMappingReq(
      @Header("dbname") String dbname,
      @Body() Map<String, dynamic> body);


  @GET("POSFI/getFiListEditing")
  Future<BorrowerListModel> BorrowerList(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Query("IMEINO") String IMEINO,
      @Query("FOCode") String FOCode,
      @Query("AreaCd") String AreaCd,
      @Query("Creator") String Creator);

  @POST("POSFI/UpdateFIAddress")
  Future<KycUpdateModel> updateAddress(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Body() Map<String, dynamic> body);

  @POST("POSFI/UpdateFIPersonalDetails")
  Future<KycUpdateModel> updatePersonalDetails(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Body() Map<String, dynamic> body);

  @GET("Masters/GetRangeCategories")
  Future<RangeCategoryModel> RangeCategory(
      @Header("Authorization") String token,
      @Header("dbname") String dbName);

  @POST("POSFI/UpdateFIFamLoans")
  Future<KycUpdateModel> updateFamLoans(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Body() Map<String, dynamic> body);

  @POST("POSFI/UpdateFIFamMemIncome")
  Future<KycUpdateModel> updateFamMemIncome(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Body() Map<String, dynamic> body);

  @POST("POSFI/UpdateFIFinance")
  Future<KycUpdateModel> updateFinance(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Body() Map<String, dynamic> body);

  @POST("POSFI/UpdateFIGaurantors")
  Future<KycUpdateModel> updateGaurantors(
      @Header("Authorization") String token,
      @Header("dbname") String dbname,
      @Body() Map<String, dynamic> body);



/*

  @POST("BCTransaction/InsertMonthTargetCSP")
  Future<CommonResponseModel> setTarget(@Header("Authorization") String bearerToken,@Field("CspCode") String cspCode,@Field("TargetCommAmount") String targetCommAmount,@Field("Month") String month,@Field("Year") String year);



  @GET("BCTransaction/CSPMothlyTarget")
  Future<GetTargetModel> getTarget(@Query("KO_ID") String KO_ID,@Query("Month") String Month,@Query("Year") String Year);


  @GET("BCTransaction/GetBcTransactions")
  Future<TransHistoryResponse> getTransHistory(@Query("CspCode") String cspCode,@Query("fromdate") String fromdate,@Query("todate") String todate);


  @POST("BCTransaction/UpdateGSMId")
  Future<CommonResponseModelInt> updateGsmid(@Header("Authorization") String bearerToken,
      @Field("KO_Id") String cspCode,@Field("GSMId") String gsmid);

  @POST("BCWithdrawl/InsertWithdrawlRequests")
  Future<CommonResponseModelInt> uploadWithDrawalData(@Header("Authorization") String bearerToken,@Field("cspCode") String cspCode,@Field("amount") String amount,@Field("reqType") String reqType,@Field("isApproved") String isApproved,@Field("approvedBy") String approvedBy);

  @POST("BCWithdrawl/InsertWithdrawlRequestsReceipt")
  @MultiPart()
  Future<CommonResponseModel> uploadDepositeData(@Part(name: "CspName") String CspName,@Part(name: "CspCode") String cspCode,@Part(name: "Amount") String amount,@Part(name: "ReqType") String reqType,@Part(name: "IsApproved") String isApproved,@Part(name: "ApprovedBy") String approvedBy,  @Part(name: "Receipt") File file);


  @GET("BCWithdrawl/GetWithdrawlRequests")
  Future<WithdrawalAndDepsitModel> getWithdrawalAndDepositHistory( @Header("Authorization") String bearerToken ,@Query("CspCode") String CspCode);



  @GET("BCTransaction/GetAllSlabDetails")
  Future<SlabListModel> getAllSlabList();



  @GET("BCWithdrawl/GetBannerPosting")
  Future<BannerDataModel> getBannerImageUrl(@Query("AppType") String AppType);


  @GET("BCTransaction/GetCSPAppCommission")
  Future<ServiceListModel> getServiceList();



  @GET("BCTransaction/GetMonthlyCommissionDetails")
  Future<CspAnnualReport> getCSPAnnualReport(@Query("CspCode") String cspCode,@Query("month") String month,@Query("year") String year);



  @GET("BCTransaction/GetTopCommissions")
  Future<LeaderBoardDataResponse> getLeaderBoardData();


  @GET("BCTransaction/GetCommissionCount")
  Future<CommisionDetailsResponse> getCommsionDetails(@Query("fromDate") String fromdate,@Query("todate") String todate,@Query("koId") String koId,@Query("areaType") String areaType,@Query("isLive") String isLive);



  @GET("BCTransaction/GetTaskSlabDetails")
  Future<GetTaskSlabDetailsResponse> getTaskSlabDetails();

  @POST("BCTransaction/InsertCspKycDocument")
  @MultiPart()
  Future<CommonResponseModel> insertCspKycDocument(
      @Part(name:'CspId') String cspId,
      @Part(name:'DocType') String docType,
      @Part(name:'IsDelete') bool isDelete,
      @Part(name: "file") File file);

  @GET("BCTransaction/GetWeeklyCommission")
  Future<CspWeeklyLazerResponse> getCSPWeeklyCommision(@Query("KOId") String kOId);



  @GET("BCTransaction/GetCspMonthlyLazer")
  Future<CspMonthlyLazerResponse> getCSPMonthlyCommision(@Query("cspcode") String kOId);


  @GET("BCTransaction/GetTargetStatus")
  Future<MonthlyTaskStatus> getTargetStatus(@Query("koid") String kOId,@Query("Month") String month,@Query("Year") String year);


  @GET("BCTransaction/GetCSPKYCdocument")
  Future<CspkycDocumentModel> getCSPKYCdocument(@Query("CspId") String CspId );

  @GET("BCTransaction/GetCSPAppTransactionDetails")
  Future<GetCspAppTransactionDetails> getCspAppTransactionDetails();

  @GET("BCTransaction/GetTransactionDetailsByCode")
  Future<TransactionDetailsByCodeModel> getTransactionDetailsByCodeModel(@Query("cspcode") String kOId,@Query("month") String month,@Query("year") String year);

  @POST("User/BcuserInsertTracking")
  Future<CommonResponseModel> getBcUserInsertTracking(@Query("cspcode") String cspcode,@Query("activity") String activity,@Query("latitude") String latitude,@Query("longitude") String longitude);
*/



}
