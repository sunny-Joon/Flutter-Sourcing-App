// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations

class _ApiService implements ApiService {
  _ApiService(
    this._dio, {
    this.baseUrl,
    this.errorLogger,
  });

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
  Future<GlobalModel> insertMonthlytarget(
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
          'FiSourcing/InsertMonthlyTarget',
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
  Future<GlobalModel> VersionCheck(
    String dbName,
    String version,
    String AppName,
    String action,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'version': version,
      r'AppName': AppName,
      r'action': action,
    };
    final _headers = <String, dynamic>{r'dbname': dbName};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<GlobalModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'Tracklocations/GetAppLink',
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
  Future<GlobalModel> deleteGurrantor(
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
    final _options = _setStreamType<GlobalModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'FiSourcing/DeleteGuarantor',
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
  Future<CollectionStatusModel> collectionStatus(
    String token,
    String dbName,
    String SmCode,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'SmCode': SmCode};
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbName,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CollectionStatusModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'Collection/CollectionStatus',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CollectionStatusModel _value;
    try {
      _value = CollectionStatusModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DocsVerify> verifyDocs(Map<String, dynamic> body) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _options = _setStreamType<DocsVerify>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'IdentityVerification/Get',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DocsVerify _value;
    try {
      _value = DocsVerify.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<GlobalModel> punchInOut(
    String token,
    String dbname,
    Map<String, dynamic> body,
    String type,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'type': type};
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
          'Masters/CreatePunchInOrOut',
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
  Future<CrifModel> generateCrif(
    String creator,
    String ficode,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'creator': creator,
      r'ficode': ficode,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CrifModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'FIIndex/InitilizeCrif',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CrifModel _value;
    try {
      _value = CrifModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CommonIntModel> mobileOtpSend(
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
    final _options = _setStreamType<CommonIntModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'Masters/SendSms',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CommonIntModel _value;
    try {
      _value = CommonIntModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Ifcsc> ifscVerify(String ifsc) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Ifcsc>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '${ifsc}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late Ifcsc _value;
    try {
      _value = Ifcsc.fromJson(_result.data!);
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
    String loan_Reason,
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
      'P_Address1',
      currentAddress1,
    ));
    _data.fields.add(MapEntry(
      'P_Address2',
      currentAddress2,
    ));
    _data.fields.add(MapEntry(
      'P_Address3',
      currentAddress3,
    ));
    _data.fields.add(MapEntry(
      'P_City',
      currentCity,
    ));
    _data.fields.add(MapEntry(
      'P_Pincode',
      currentPincode,
    ));
    _data.fields.add(MapEntry(
      'P_State',
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
      'BankSanctionId',
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
    _data.fields.add(MapEntry(
      'Loan_Reason',
      loan_Reason,
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
  Future<GlobalModel> FiDocsUploads(
    String token,
    String dbname,
    String FI_ID,
    String GrNo,
    File? AadhaarCard,
    File? AadhaarCardBack,
    File? VoterId,
    File? VoterIdBack,
    File? DrivingLicense,
    File? Pan,
    File? PassPort,
    File? PassBook,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
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
      GrNo,
    ));
    if (AadhaarCard != null) {
      _data.files.add(MapEntry(
        'AadhaarCard',
        MultipartFile.fromFileSync(
          AadhaarCard.path,
          filename: AadhaarCard.path.split(Platform.pathSeparator).last,
        ),
      ));
    }
    if (AadhaarCardBack != null) {
      _data.files.add(MapEntry(
        'AadhaarCardBack',
        MultipartFile.fromFileSync(
          AadhaarCardBack.path,
          filename: AadhaarCardBack.path.split(Platform.pathSeparator).last,
        ),
      ));
    }
    if (VoterId != null) {
      _data.files.add(MapEntry(
        'VoterId',
        MultipartFile.fromFileSync(
          VoterId.path,
          filename: VoterId.path.split(Platform.pathSeparator).last,
        ),
      ));
    }
    if (VoterIdBack != null) {
      _data.files.add(MapEntry(
        'VoterIdBack',
        MultipartFile.fromFileSync(
          VoterIdBack.path,
          filename: VoterIdBack.path.split(Platform.pathSeparator).last,
        ),
      ));
    }
    if (DrivingLicense != null) {
      _data.files.add(MapEntry(
        'DrivingLicense',
        MultipartFile.fromFileSync(
          DrivingLicense.path,
          filename: DrivingLicense.path.split(Platform.pathSeparator).last,
        ),
      ));
    }
    if (Pan != null) {
      _data.files.add(MapEntry(
        'Pan',
        MultipartFile.fromFileSync(
          Pan.path,
          filename: Pan.path.split(Platform.pathSeparator).last,
        ),
      ));
    }
    if (PassPort != null) {
      _data.files.add(MapEntry(
        'PassPort',
        MultipartFile.fromFileSync(
          PassPort.path,
          filename: PassPort.path.split(Platform.pathSeparator).last,
        ),
      ));
    }
    if (PassBook != null) {
      _data.files.add(MapEntry(
        'PassBook',
        MultipartFile.fromFileSync(
          PassBook.path,
          filename: PassBook.path.split(Platform.pathSeparator).last,
        ),
      ));
    }
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
          'FiSourcing/FiDocsUploadSingleFile',
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
  Future<GlobalModel> getIdVerify(
    String token,
    String dbname,
    Map<String, dynamic> requestBody,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbname,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(requestBody);
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
  Future<BankNamesModel> bankNames(
    String token,
    String dbname,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbname,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BankNamesModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'Masters/GetBankName',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BankNamesModel _value;
    try {
      _value = BankNamesModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<GlobalModel> FiVerifiedInfo(
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
          'Tracklocations/CreateFiVerfiedInfo',
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
  Future<GlobalModel> FIFamilyIncome(
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
          'FiSourcing/InsertFIFamilyIncome',
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
    String GuardianName,
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
      'GuardianName',
      GuardianName,
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
    String token,
    String dbname,
    int CreatorID,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'CreatorID': CreatorID};
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbname,
    };
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
  Future<ApplicationgetAllModel> dataByFIID(
    String token,
    String dbname,
    int FI_ID,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'FI_ID': FI_ID};
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbname,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ApplicationgetAllModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'FiSourcing/GetAllFiData',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApplicationgetAllModel _value;
    try {
      _value = ApplicationgetAllModel.fromJson(_result.data!);
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
  Future<QrPaymentsModel> qrPayments(
    String token,
    String dbname,
    String SmCode,
    String userid,
    String type,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'SmCode': SmCode,
      r'userid': userid,
      r'type': type,
    };
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbname,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<QrPaymentsModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'Collection/GetQrPaymentsBySmcode',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QrPaymentsModel _value;
    try {
      _value = QrPaymentsModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<GetCollectionModel> GetFiCollection(
    String token,
    String dbname,
    String SmCode,
    String GetDate,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'SmCode': SmCode,
      r'GetDate': GetDate,
    };
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbname,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<GetCollectionModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'Collection/GetFiCollection',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetCollectionModel _value;
    try {
      _value = GetCollectionModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AttendanceStatusModel> AttendanceStatus(
    String token,
    String dbname,
    String UserName,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'UserName': UserName};
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbname,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<AttendanceStatusModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'Masters/GetMobileAppAttendance',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AttendanceStatusModel _value;
    try {
      _value = AttendanceStatusModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CommonBoolModel> RcPosting(
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
    final _options = _setStreamType<CommonBoolModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'Collection/SaveReceipt',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CommonBoolModel _value;
    try {
      _value = CommonBoolModel.fromJson(_result.data!);
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
  Future<GlobalModel> morphorecharge(
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
          'Tracklocations/InsertMorphoRechargeDetails',
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
    String fi_Id,
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
      'fi_Id',
      fi_Id,
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
  Future<GlobalModel> InsertQrSettlement(
    String token,
    String dbname,
    String SmCode,
    File picture,
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
      'SmCode',
      SmCode,
    ));
    _data.files.add(MapEntry(
      'picture',
      MultipartFile.fromFileSync(
        picture.path,
        filename: picture.path.split(Platform.pathSeparator).last,
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
          'Collection/InsertQrSettlement',
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
    String Creator,
    int Type,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'Group_code': Group_code,
      r'Branch_code': Branch_code,
      r'Creator': Creator,
      r'Type': Type,
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
          'FiSourcing/GetDataForEsign',
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
  Future<SecondEsignModel> BorrowerList2(
    String token,
    String dbName,
    String Creator,
    String Banchcode,
    String IMEINO,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'Creator': Creator,
      r'Banchcode': Banchcode,
      r'IMEINO': IMEINO,
    };
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbName,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<SecondEsignModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'FiSourcing/GetSecondEsignBorrowerList',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SecondEsignModel _value;
    try {
      _value = SecondEsignModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CollectionBorrowerListModel> CollectionBorrowerList(
    String token,
    String dbName,
    String Imei,
    String BranchCode,
    String GroupCode,
    String UserId,
    String GetDate,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'Imei': Imei,
      r'BranchCode': BranchCode,
      r'GroupCode': GroupCode,
      r'UserId': UserId,
      r'GetDate': GetDate,
    };
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbName,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CollectionBorrowerListModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'Collection/GetPandingCollectionGroupCode',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CollectionBorrowerListModel _value;
    try {
      _value = CollectionBorrowerListModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CollectionBranchListModel> CollectionBranchList(
    String token,
    String dbName,
    String Imei,
    String UserId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'Imei': Imei,
      r'UserId': UserId,
    };
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbName,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CollectionBranchListModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'Collection/Getmappedfoforcoll',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CollectionBranchListModel _value;
    try {
      _value = CollectionBranchListModel.fromJson(_result.data!);
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

  @override
  Future<QrCodeModel> QrGeneration(
    String token,
    String dbName,
    String SmCode,
    String Type,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'SmCode': SmCode,
      r'Type': Type,
    };
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbName,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<QrCodeModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'Collection/GetQRLinkStatus',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QrCodeModel _value;
    try {
      _value = QrCodeModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<dynamic> verifyIdentity(Map<String, dynamic> body) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _options = _setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'IdentityVerification/Get',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<GlobalModel> promiseToPay(
    String token,
    String dbName,
    Map<String, dynamic> body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbName,
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
          'Collection/RcPromiseToPay',
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
  Future<dynamic> getDLDetailsProtean(Map<String, dynamic> body) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _options = _setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'DocVerify/GetDLDetails',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> getBankDetailsProtean(Map<String, dynamic> body) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _options = _setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'DocVerify/GetBankVerify',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> getVoteretailsProtean(Map<String, dynamic> body) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _options = _setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'DocVerify/GetVoterDetails',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<PlaceCodesModel> getVillageStateDistrict(
    String token,
    String dbName,
    String type,
    String? subDistrictCode,
    String? districtCode,
    String stateCode,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'Type': type,
      r'SubDistrictCode': subDistrictCode,
      r'DistrictCode': districtCode,
      r'StateCode': stateCode,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbName,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<PlaceCodesModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'FiSourcing/GetVillageStateDistrict',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PlaceCodesModel _value;
    try {
      _value = PlaceCodesModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<OcrResponse> uploadDocument(
    String imgType,
    File file,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'imgType': imgType};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.files.add(MapEntry(
      'file',
      MultipartFile.fromFileSync(
        file.path,
        filename: file.path.split(Platform.pathSeparator).last,
      ),
    ));
    final _options = _setStreamType<OcrResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
        .compose(
          _dio.options,
          'OCR/DocVerifyforSpaceOCR',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late OcrResponse _value;
    try {
      _value = OcrResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CommonIntModel> otpVerify(
    String token,
    String dbName,
    String mobileNo,
    String otp,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'MobileNo': mobileNo,
      r'Otp': otp,
    };
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbName,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CommonIntModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'Masters/OTPVerify',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CommonIntModel _value;
    try {
      _value = CommonIntModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AdhaarModel> dataByAdhaar(
    String token,
    String dbName,
    String AdharCard,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'AdharCard': AdharCard};
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbName,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<AdhaarModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'FiSourcing/GetAllAdharData',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AdhaarModel _value;
    try {
      _value = AdhaarModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<LeaderboardModel> leaderboardList(
    String token,
    String dbName,
    String Type,
    String Fromdate,
    String Todate,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'Type': Type,
      r'Fromdate': Fromdate,
      r'Todate': Todate,
    };
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbName,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<LeaderboardModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'Tracklocations/GetAchievementDetails',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late LeaderboardModel _value;
    try {
      _value = LeaderboardModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<dynamic> saveAgreements(
    String ficode,
    String creator,
    String consentText,
    String authMode,
    String fId,
    String signType,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry(
      'Ficode',
      ficode,
    ));
    _data.fields.add(MapEntry(
      'Creator',
      creator,
    ));
    _data.fields.add(MapEntry(
      'ConsentText',
      consentText,
    ));
    _data.fields.add(MapEntry(
      'authMode',
      authMode,
    ));
    _data.fields.add(MapEntry(
      'F_Id',
      fId,
    ));
    _data.fields.add(MapEntry(
      'SignType',
      signType,
    ));
    final _options = _setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
        .compose(
          _dio.options,
          'e_SignMobile/SaveAgreements',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<XmlResponse> sendXMLtoServer(String msg) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'msg': msg};
    final _options = _setStreamType<XmlResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
        .compose(
          _dio.options,
          'E_Sign/XMLReaponseNew',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late XmlResponse _value;
    try {
      _value = XmlResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<GlobalModel> searchCkycNoByAadhar(
    String token,
    String dbName,
    String aadharId,
    String panNo,
    String voterId,
    String dob,
    String gender,
    String name,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'AadharId': aadharId,
      r'PanNo': panNo,
      r'VoterId': voterId,
      r'DOB': dob,
      r'Gender': gender,
      r'Name': name,
    };
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'dbname': dbName,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<GlobalModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'Ckyc/SearchCkycNoByAadhar',
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
  Future<GlobalModel> createLiveTrack(
    TrackLocationRequest request,
    String dbname,
    String authorization,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'dbname': dbname,
      r'Authorization': authorization,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<GlobalModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'Tracklocations/CreateLiveTrack',
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
  Future<DetailsBySMcodeResponse> getBorrowerDetails(
    String smcode,
    String dbname,
    String authorization,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'SmCode': smcode};
    final _headers = <String, dynamic>{
      r'dbname': dbname,
      r'Authorization': authorization,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<DetailsBySMcodeResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'FiSourcing/GetBorrowerDetails',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DetailsBySMcodeResponse _value;
    try {
      _value = DetailsBySMcodeResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CsoRankModel> GetCsoRanks(
    String authorization,
    String dbname,
    String KO_ID,
    String Month,
    String Year,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'KO_ID': KO_ID,
      r'Month': Month,
      r'Year': Year,
    };
    final _headers = <String, dynamic>{
      r'Authorization': authorization,
      r'dbname': dbname,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CsoRankModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'FiSourcing/GetCsoRanks',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CsoRankModel _value;
    try {
      _value = CsoRankModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<GlobalModel> insertBranchVisit(
    String dbName,
    String authorization,
    String visitType,
    String smCode,
    String amount,
    String lat,
    String long,
    String userId,
    String remarks,
    String address,
    File picture,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'dbname': dbName,
      r'Authorization': authorization,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = FormData();
    _data.fields.add(MapEntry(
      'VisitType',
      visitType,
    ));
    _data.fields.add(MapEntry(
      'SmCode',
      smCode,
    ));
    _data.fields.add(MapEntry(
      'Amount',
      amount,
    ));
    _data.fields.add(MapEntry(
      'Lat',
      lat,
    ));
    _data.fields.add(MapEntry(
      'Long',
      long,
    ));
    _data.fields.add(MapEntry(
      'UserId',
      userId,
    ));
    _data.fields.add(MapEntry(
      'Remarks',
      remarks,
    ));
    _data.fields.add(MapEntry(
      'Address',
      address,
    ));
    _data.files.add(MapEntry(
      'Picture',
      MultipartFile.fromFileSync(
        picture.path,
        filename: picture.path.split(Platform.pathSeparator).last,
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
          'Tracklocations/InsertBranchVisit',
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
  Future<CommonStringModel> getDocument(Map<String, dynamic> body) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _options = _setStreamType<CommonStringModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'DocGen/GetDocument',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CommonStringModel _value;
    try {
      _value = CommonStringModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<OcrDocsScanningResponse> OcrDocsScan(
    String imgType,
    String Id,
    File file,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'imgType': imgType,
      r'Id': Id,
    };
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.files.add(MapEntry(
      'file',
      MultipartFile.fromFileSync(
        file.path,
        filename: file.path.split(Platform.pathSeparator).last,
      ),
    ));
    final _options = _setStreamType<OcrDocsScanningResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'OCR/DocVerifyforOSVSpaceOCR',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late OcrDocsScanningResponse _value;
    try {
      _value = OcrDocsScanningResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BannerPostModel> getBannersAndFlashMessage(
    String dbName,
    String authorization,
    String AppType,
    String MessageType,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'AppType': AppType,
      r'MessageType': MessageType,
    };
    final _headers = <String, dynamic>{
      r'dbname': dbName,
      r'Authorization': authorization,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BannerPostModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'Masters/GetBannerPost',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BannerPostModel _value;
    try {
      _value = BannerPostModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<QrResponseModel> getQrPaymentModel(
    String authorization,
    String dbname,
    String SmCode,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'SmCode': SmCode};
    final _headers = <String, dynamic>{
      r'Authorization': authorization,
      r'dbname': dbname,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<QrResponseModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'FiSourcing/GetQRCodePayments',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late QrResponseModel _value;
    try {
      _value = QrResponseModel.fromJson(_result.data!);
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
