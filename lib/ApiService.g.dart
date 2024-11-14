// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ApiService.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element

class _ApiService implements ApiService {
  _ApiService(
    this._dio, {
    this.baseUrl,
    this.errorLogger,
  }) {
    baseUrl ??= 'https://predeptest.paisalo.in:8084/MobColen/api/';
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<LoginModel> getLogins(
    String devid,
    String dbname,
    Map<String, dynamic> body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'devid': devid,
      r'dbname': dbname,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _options = _setStreamType<LoginModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'Account/GetToken',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late LoginModel _value;
    try {
      _value = LoginModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<GlobalModel> saveFi(
    String token,
    String dbname,
    String aadharNo,
    String title,
    String fName,
    String mName,
    String lName,
    String dob,
    String age,
    String gender,
    String pPhone,
    String fatherFirstName,
    String fatherMiddleName,
    String fatherLastName,
    String spouseFirstName,
    String spouseMiddleName,
    String spouseLastName,
    String creator,
    int expense,
    int income,
    double latitude,
    double longitude,
    String currentAddress1,
    String currentAddress2,
    String currentAddress3,
    String currentCity,
    String currentPincode,
    String currentState,
    bool isMarried,
    String groupCode,
    String branchCode,
    String relation_with_Borrower,
    String bank_name,
    String loan_Duration,
    String loan_amount,
    File Picture,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbname,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = FormData();
    _data.fields.add(MapEntry(
      'aadhar_no',
      aadharNo,
    ));
    _data.fields.add(MapEntry(
      'title',
      title,
    ));
    _data.fields.add(MapEntry(
      'f_Name',
      fName,
    ));
    _data.fields.add(MapEntry(
      'm_Name',
      mName,
    ));
    _data.fields.add(MapEntry(
      'l_Name',
      lName,
    ));
    _data.fields.add(MapEntry(
      'dob',
      dob,
    ));
    _data.fields.add(MapEntry(
      'Age',
      age,
    ));
    _data.fields.add(MapEntry(
      'gender',
      gender,
    ));
    _data.fields.add(MapEntry(
      'p_Phone',
      pPhone,
    ));
    _data.fields.add(MapEntry(
      'fatheR_FIRST_NAME',
      fatherFirstName,
    ));
    _data.fields.add(MapEntry(
      'fatheR_MIDDLE_NAME',
      fatherMiddleName,
    ));
    _data.fields.add(MapEntry(
      'fatheR_LAST_NAME',
      fatherLastName,
    ));
    _data.fields.add(MapEntry(
      'spousE_FIRST_NAME',
      spouseFirstName,
    ));
    _data.fields.add(MapEntry(
      'spousE_MIDDLE_NAME',
      spouseMiddleName,
    ));
    _data.fields.add(MapEntry(
      'spousE_LAST_NAME',
      spouseLastName,
    ));
    _data.fields.add(MapEntry(
      'creator',
      creator,
    ));
    _data.fields.add(MapEntry(
      'expense',
      expense.toString(),
    ));
    _data.fields.add(MapEntry(
      'income',
      income.toString(),
    ));
    _data.fields.add(MapEntry(
      'latitude',
      latitude.toString(),
    ));
    _data.fields.add(MapEntry(
      'longitude',
      longitude.toString(),
    ));
    _data.fields.add(MapEntry(
      'current_Address1',
      currentAddress1,
    ));
    _data.fields.add(MapEntry(
      'current_Address2',
      currentAddress2,
    ));
    _data.fields.add(MapEntry(
      'current_Address3',
      currentAddress3,
    ));
    _data.fields.add(MapEntry(
      'current_City',
      currentCity,
    ));
    _data.fields.add(MapEntry(
      'current_Pincode',
      currentPincode,
    ));
    _data.fields.add(MapEntry(
      'current_State',
      currentState,
    ));
    _data.fields.add(MapEntry(
      'IsMarried',
      isMarried.toString(),
    ));
    _data.fields.add(MapEntry(
      'GroupCode',
      groupCode,
    ));
    _data.fields.add(MapEntry(
      'BranchCode',
      branchCode,
    ));
    _data.fields.add(MapEntry(
      'Relation_with_Borrower',
      relation_with_Borrower,
    ));
    _data.fields.add(MapEntry(
      'Bank_name',
      bank_name,
    ));
    _data.fields.add(MapEntry(
      'Loan_Duration',
      loan_Duration,
    ));
    _data.fields.add(MapEntry(
      'Loan_amount',
      loan_amount,
    ));
    _data.files.add(MapEntry(
      'Picture',
      MultipartFile.fromFileSync(
        Picture.path,
        filename: Picture.path.split(Platform.pathSeparator).last,
      ),
    ));
    final _options = _setStreamType<GlobalModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
        .compose(
          _dio.options,
          'FiSourcing/InsertFiSourcedata',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GlobalModel _value;
    try {
      _value = GlobalModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<GlobalModel> uploadFiDocs(
    String token,
    String dbname,
    String FI_ID,
    int GrNo,
    int CheckListId,
    String Remarks,
    File FileName,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbname,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = FormData();
    _data.fields.add(MapEntry(
      'FI_ID',
      FI_ID,
    ));
    _data.fields.add(MapEntry(
      'GrNo',
      GrNo.toString(),
    ));
    _data.fields.add(MapEntry(
      'CheckListId',
      CheckListId.toString(),
    ));
    _data.fields.add(MapEntry(
      'Remarks',
      Remarks,
    ));
    _data.files.add(MapEntry(
      'FileName',
      MultipartFile.fromFileSync(
        FileName.path,
        filename: FileName.path.split(Platform.pathSeparator).last,
      ),
    ));
    final _options = _setStreamType<GlobalModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
        .compose(
          _dio.options,
          'FiSourcing/FiDocsUploads',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GlobalModel _value;
    try {
      _value = GlobalModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<GlobalModel> addFiIds(
    String token,
    String dbname,
    Map<String, dynamic> body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbname,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _options = _setStreamType<GlobalModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'FiSourcing/AddFiIDs',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GlobalModel _value;
    try {
      _value = GlobalModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<GlobalModel> FiFamilyDetail(
    String token,
    String dbname,
    Map<String, dynamic> body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbname,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _options = _setStreamType<GlobalModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'FiSourcing/AddFiFamilyDetail',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GlobalModel _value;
    try {
      _value = GlobalModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<GlobalModel> AddFiIncomeAndExpense(
    String token,
    String dbname,
    Map<String, dynamic> body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbname,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _options = _setStreamType<GlobalModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'FiSourcing/AddFiIncomeAndExpense',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GlobalModel _value;
    try {
      _value = GlobalModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<GlobalModel> AddFinancialInfo(
    String token,
    String dbname,
    Map<String, dynamic> body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbname,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _options = _setStreamType<GlobalModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'FiSourcing/AddFinancialInfo',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GlobalModel _value;
    try {
      _value = GlobalModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<GlobalModel> saveGurrantor(
    String token,
    String dbname,
    String fi_ID,
    String gr_Sno,
    String title,
    String fname,
    String mname,
    String lname,
    String relation_with_Borrower,
    String p_Address1,
    String p_Address2,
    String p_Address3,
    String p_City,
    String p_State,
    String pincode,
    String dob,
    String age,
    String phone,
    String pan,
    String dl,
    String voter,
    String aadharId,
    String gender,
    String religion,
    bool esign_Succeed,
    String esign_UUID,
    File Picture,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbname,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = FormData();
    _data.fields.add(MapEntry(
      'fi_ID',
      fi_ID,
    ));
    _data.fields.add(MapEntry(
      'gr_Sno',
      gr_Sno,
    ));
    _data.fields.add(MapEntry(
      'title',
      title,
    ));
    _data.fields.add(MapEntry(
      'fname',
      fname,
    ));
    _data.fields.add(MapEntry(
      'mname',
      mname,
    ));
    _data.fields.add(MapEntry(
      'lname',
      lname,
    ));
    _data.fields.add(MapEntry(
      'relation_with_Borrower',
      relation_with_Borrower,
    ));
    _data.fields.add(MapEntry(
      'p_Address1',
      p_Address1,
    ));
    _data.fields.add(MapEntry(
      'p_Address2',
      p_Address2,
    ));
    _data.fields.add(MapEntry(
      'p_Address3',
      p_Address3,
    ));
    _data.fields.add(MapEntry(
      'p_City',
      p_City,
    ));
    _data.fields.add(MapEntry(
      'p_State',
      p_State,
    ));
    _data.fields.add(MapEntry(
      'pincode',
      pincode,
    ));
    _data.fields.add(MapEntry(
      'dob',
      dob,
    ));
    _data.fields.add(MapEntry(
      'age',
      age,
    ));
    _data.fields.add(MapEntry(
      'phone',
      phone,
    ));
    _data.fields.add(MapEntry(
      'pan',
      pan,
    ));
    _data.fields.add(MapEntry(
      'dl',
      dl,
    ));
    _data.fields.add(MapEntry(
      'voter',
      voter,
    ));
    _data.fields.add(MapEntry(
      'aadharId',
      aadharId,
    ));
    _data.fields.add(MapEntry(
      'gender',
      gender,
    ));
    _data.fields.add(MapEntry(
      'religion',
      religion,
    ));
    _data.fields.add(MapEntry(
      'esign_Succeed',
      esign_Succeed.toString(),
    ));
    _data.fields.add(MapEntry(
      'esign_UUID',
      esign_UUID,
    ));
    _data.files.add(MapEntry(
      'Picture',
      MultipartFile.fromFileSync(
        Picture.path,
        filename: Picture.path.split(Platform.pathSeparator).last,
      ),
    ));
    final _options = _setStreamType<GlobalModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
        .compose(
          _dio.options,
          'FiSourcing/AddFiGaurantor',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GlobalModel _value;
    try {
      _value = GlobalModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CreatorListModel> getCreatorList(String dbname) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'dbname': dbname};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CreatorListModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'Masters/GetAllCreators',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CreatorListModel _value;
    try {
      _value = CreatorListModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BranchModel> getBranchList(
    String dbname,
    String Creator,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'Creator': Creator};
    final _headers = <String, dynamic>{r'dbname': dbname};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BranchModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'Masters/GetBranchCode',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BranchModel _value;
    try {
      _value = BranchModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<GroupModel> getGroupList(
    String token,
    String dbname,
    String Creator,
    String BranchCode,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'Creator': Creator,
      r'BranchCode': BranchCode,
    };
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbname,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<GroupModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'Masters/GetGroupCode',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GroupModel _value;
    try {
      _value = GroupModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<GlobalModel> getImeiMappingReq(
    String dbname,
    Map<String, dynamic> body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'dbname': dbname};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _options = _setStreamType<GlobalModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'IMEIMapping/InsertDevicedata',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GlobalModel _value;
    try {
      _value = GlobalModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<RangeCategoryModel> RangeCategory(
    String token,
    String dbName,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbName,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<RangeCategoryModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'Masters/GetRangeCategories',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late RangeCategoryModel _value;
    try {
      _value = RangeCategoryModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<GlobalModel> updatePersonalDetails(
    String dbname,
    String token,
    Map<String, dynamic> body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'dbname': dbname,
      r'Authorization': token,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _options = _setStreamType<GlobalModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'FiSourcing/AddFiExtraDetail',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GlobalModel _value;
    try {
      _value = GlobalModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<GlobalModel> saveHouseVisit(
    String token,
    String dbname,
    String FICode,
    String Creator,
    String BranchName,
    String AreaCode,
    String AreaName,
    String Center,
    String GroupCode,
    String GroupName,
    String HouseType,
    String IsvalidLocation,
    String CPFlifeStyle,
    String CpfPOAddressVerify,
    String PhotoIdVerification,
    String CurrentAddressprof,
    String HasbandWifeAgeverificaton,
    String ParmanentAddressPincode,
    String StampOnPhotocopy,
    String LastLoanVerification,
    String LoanUsagePercentage,
    String AbsentReasonInCentermeeting,
    String RepaymentFault,
    String LoanreasonVerification,
    String IsAppliedAmountAppropriate,
    String FamilyAwarenessaboutloan,
    String IsloanAppropriateforBusiness,
    String Businessaffectedourrelation,
    String Repayeligiblity,
    String Cashflowoffamily,
    String IncomeMatchedwithprofile,
    String BorrowersupportedGroup,
    String ComissionDemand,
    String GroupReadyToVilay,
    String GroupHasBloodRelation,
    String VerifyExternalLoan,
    String UnderstandsFaultPolicy,
    String OverlimitLoan_borrowfromgroup,
    String toatlDebtUnderLimit,
    String workingPlaceVerification,
    String IsWorkingPlaceValid,
    String workingPlacedescription,
    String workExperience,
    String SeasonDependency,
    String StockVerification,
    int monthlyIncome,
    int monthlySales,
    String loansufficientwithdebt,
    String NameofInterviewed,
    String AgeofInterviewed,
    String RelationofInterviewer,
    String Applicant_Status,
    String Residing_with,
    String FamilymemberfromPaisalo,
    int HouseMonthlyRent,
    String Residence_Type,
    String Residential_Stability,
    String Distancetobranch,
    String Timetoreachbranch,
    String TotalExperienceOccupation,
    int Totalmonthlyexpensesofoccupation,
    int Netmonthlyincome_afterproposedloan,
    int Totalmonthlyhouseholdexpenses,
    int Netmonthlyincomeotherfamilymembers,
    String Relationearningmember,
    String Namereferenceperson1,
    String Mobilereferenceperson1,
    String Namereferenceperson2,
    String Mobilereferenceperson2,
    String feedbacknearbyresident,
    String UnderstandInsaurancePolicy,
    String BusinessVerification,
    double Latitude,
    double Longitude,
    String EmpCode,
    String Address,
    File Picture,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbname,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = FormData();
    _data.fields.add(MapEntry(
      'FICode',
      FICode,
    ));
    _data.fields.add(MapEntry(
      'Creator',
      Creator,
    ));
    _data.fields.add(MapEntry(
      'BranchName',
      BranchName,
    ));
    _data.fields.add(MapEntry(
      'AreaCode',
      AreaCode,
    ));
    _data.fields.add(MapEntry(
      'AreaName',
      AreaName,
    ));
    _data.fields.add(MapEntry(
      'Center',
      Center,
    ));
    _data.fields.add(MapEntry(
      'GroupCode',
      GroupCode,
    ));
    _data.fields.add(MapEntry(
      'GroupName',
      GroupName,
    ));
    _data.fields.add(MapEntry(
      'HouseType',
      HouseType,
    ));
    _data.fields.add(MapEntry(
      'IsvalidLocation',
      IsvalidLocation,
    ));
    _data.fields.add(MapEntry(
      'CPFlifeStyle',
      CPFlifeStyle,
    ));
    _data.fields.add(MapEntry(
      'CpfPOAddressVerify',
      CpfPOAddressVerify,
    ));
    _data.fields.add(MapEntry(
      'PhotoIdVerification',
      PhotoIdVerification,
    ));
    _data.fields.add(MapEntry(
      'CurrentAddressprof',
      CurrentAddressprof,
    ));
    _data.fields.add(MapEntry(
      'HasbandWifeAgeverificaton',
      HasbandWifeAgeverificaton,
    ));
    _data.fields.add(MapEntry(
      'ParmanentAddressPincode',
      ParmanentAddressPincode,
    ));
    _data.fields.add(MapEntry(
      'StampOnPhotocopy',
      StampOnPhotocopy,
    ));
    _data.fields.add(MapEntry(
      'LastLoanVerification',
      LastLoanVerification,
    ));
    _data.fields.add(MapEntry(
      'LoanUsagePercentage',
      LoanUsagePercentage,
    ));
    _data.fields.add(MapEntry(
      'AbsentReasonInCentermeeting',
      AbsentReasonInCentermeeting,
    ));
    _data.fields.add(MapEntry(
      'RepaymentFault',
      RepaymentFault,
    ));
    _data.fields.add(MapEntry(
      'LoanreasonVerification',
      LoanreasonVerification,
    ));
    _data.fields.add(MapEntry(
      'IsAppliedAmountAppropriate',
      IsAppliedAmountAppropriate,
    ));
    _data.fields.add(MapEntry(
      'FamilyAwarenessaboutloan',
      FamilyAwarenessaboutloan,
    ));
    _data.fields.add(MapEntry(
      'IsloanAppropriateforBusiness',
      IsloanAppropriateforBusiness,
    ));
    _data.fields.add(MapEntry(
      'Businessaffectedourrelation',
      Businessaffectedourrelation,
    ));
    _data.fields.add(MapEntry(
      'Repayeligiblity',
      Repayeligiblity,
    ));
    _data.fields.add(MapEntry(
      'Cashflowoffamily',
      Cashflowoffamily,
    ));
    _data.fields.add(MapEntry(
      'IncomeMatchedwithprofile',
      IncomeMatchedwithprofile,
    ));
    _data.fields.add(MapEntry(
      'BorrowersupportedGroup',
      BorrowersupportedGroup,
    ));
    _data.fields.add(MapEntry(
      'ComissionDemand',
      ComissionDemand,
    ));
    _data.fields.add(MapEntry(
      'GroupReadyToVilay',
      GroupReadyToVilay,
    ));
    _data.fields.add(MapEntry(
      'GroupHasBloodRelation',
      GroupHasBloodRelation,
    ));
    _data.fields.add(MapEntry(
      'VerifyExternalLoan',
      VerifyExternalLoan,
    ));
    _data.fields.add(MapEntry(
      'UnderstandsFaultPolicy',
      UnderstandsFaultPolicy,
    ));
    _data.fields.add(MapEntry(
      'OverlimitLoan_borrowfromgroup',
      OverlimitLoan_borrowfromgroup,
    ));
    _data.fields.add(MapEntry(
      'toatlDebtUnderLimit',
      toatlDebtUnderLimit,
    ));
    _data.fields.add(MapEntry(
      'workingPlaceVerification',
      workingPlaceVerification,
    ));
    _data.fields.add(MapEntry(
      'IsWorkingPlaceValid',
      IsWorkingPlaceValid,
    ));
    _data.fields.add(MapEntry(
      'workingPlacedescription',
      workingPlacedescription,
    ));
    _data.fields.add(MapEntry(
      'workExperience',
      workExperience,
    ));
    _data.fields.add(MapEntry(
      'SeasonDependency',
      SeasonDependency,
    ));
    _data.fields.add(MapEntry(
      'StockVerification',
      StockVerification,
    ));
    _data.fields.add(MapEntry(
      'monthlyIncome',
      monthlyIncome.toString(),
    ));
    _data.fields.add(MapEntry(
      'monthlySales',
      monthlySales.toString(),
    ));
    _data.fields.add(MapEntry(
      'loansufficientwithdebt',
      loansufficientwithdebt,
    ));
    _data.fields.add(MapEntry(
      'NameofInterviewed',
      NameofInterviewed,
    ));
    _data.fields.add(MapEntry(
      'AgeofInterviewed',
      AgeofInterviewed,
    ));
    _data.fields.add(MapEntry(
      'RelationofInterviewer',
      RelationofInterviewer,
    ));
    _data.fields.add(MapEntry(
      'Applicant_Status',
      Applicant_Status,
    ));
    _data.fields.add(MapEntry(
      'Residing_with',
      Residing_with,
    ));
    _data.fields.add(MapEntry(
      'FamilymemberfromPaisalo',
      FamilymemberfromPaisalo,
    ));
    _data.fields.add(MapEntry(
      'HouseMonthlyRent',
      HouseMonthlyRent.toString(),
    ));
    _data.fields.add(MapEntry(
      'Residence_Type',
      Residence_Type,
    ));
    _data.fields.add(MapEntry(
      'Residential_Stability',
      Residential_Stability,
    ));
    _data.fields.add(MapEntry(
      'Distancetobranch',
      Distancetobranch,
    ));
    _data.fields.add(MapEntry(
      'Timetoreachbranch',
      Timetoreachbranch,
    ));
    _data.fields.add(MapEntry(
      'TotalExperienceOccupation',
      TotalExperienceOccupation,
    ));
    _data.fields.add(MapEntry(
      'Totalmonthlyexpensesofoccupation',
      Totalmonthlyexpensesofoccupation.toString(),
    ));
    _data.fields.add(MapEntry(
      'Netmonthlyincome_afterproposedloan',
      Netmonthlyincome_afterproposedloan.toString(),
    ));
    _data.fields.add(MapEntry(
      'Totalmonthlyhouseholdexpenses',
      Totalmonthlyhouseholdexpenses.toString(),
    ));
    _data.fields.add(MapEntry(
      'Netmonthlyincomeotherfamilymembers',
      Netmonthlyincomeotherfamilymembers.toString(),
    ));
    _data.fields.add(MapEntry(
      'Relationearningmember',
      Relationearningmember,
    ));
    _data.fields.add(MapEntry(
      'Namereferenceperson1',
      Namereferenceperson1,
    ));
    _data.fields.add(MapEntry(
      'Mobilereferenceperson1',
      Mobilereferenceperson1,
    ));
    _data.fields.add(MapEntry(
      'Namereferenceperson2',
      Namereferenceperson2,
    ));
    _data.fields.add(MapEntry(
      'Mobilereferenceperson2',
      Mobilereferenceperson2,
    ));
    _data.fields.add(MapEntry(
      'feedbacknearbyresident',
      feedbacknearbyresident,
    ));
    _data.fields.add(MapEntry(
      'UnderstandInsaurancePolicy',
      UnderstandInsaurancePolicy,
    ));
    _data.fields.add(MapEntry(
      'BusinessVerification',
      BusinessVerification,
    ));
    _data.fields.add(MapEntry(
      'Latitude',
      Latitude.toString(),
    ));
    _data.fields.add(MapEntry(
      'Longitude',
      Longitude.toString(),
    ));
    _data.fields.add(MapEntry(
      'EmpCode',
      EmpCode,
    ));
    _data.fields.add(MapEntry(
      'Address',
      Address,
    ));
    _data.files.add(MapEntry(
      'Image',
      MultipartFile.fromFileSync(
        Picture.path,
        filename: Picture.path.split(Platform.pathSeparator).last,
      ),
    ));
    final _options = _setStreamType<GlobalModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
        .compose(
          _dio.options,
          'Tracklocations/CreateHomeVisit',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GlobalModel _value;
    try {
      _value = GlobalModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BorrowerListModel> BorrowerList(
    String token,
    String dbName,
    String Group_code,
    String Branch_code,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'Group_code': Group_code,
      r'Branch_code': Branch_code,
    };
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbName,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BorrowerListModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'FiSourcing/GetDataForFirstEsign',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BorrowerListModel _value;
    try {
      _value = BorrowerListModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<KycScanningModel> KycScanning(
    String token,
    String dbName,
    String Fi_Id,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'Fi_Id': Fi_Id};
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbName,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<KycScanningModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'FiSourcing/GetFiUploadedDocuments',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late KycScanningModel _value;
    try {
      _value = KycScanningModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
