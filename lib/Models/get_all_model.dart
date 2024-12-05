// To parse this JSON data, do
//
//     final applicationgetAllModel = applicationgetAllModelFromJson(jsonString);

import 'dart:convert';

ApplicationgetAllModel applicationgetAllModelFromJson(String str) => ApplicationgetAllModel.fromJson(json.decode(str));

String applicationgetAllModelToJson(ApplicationgetAllModel data) => json.encode(data.toJson());

class ApplicationgetAllModel {
  int statuscode;
  String message;
  List<ApplicationgetAllDataModel> data;

  ApplicationgetAllModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory ApplicationgetAllModel.fromJson(Map<String, dynamic> json) => ApplicationgetAllModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: List<ApplicationgetAllDataModel>.from(json["data"].map((x) => ApplicationgetAllDataModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ApplicationgetAllDataModel {
  int fiId;
  int fiCode;
  String creator;
  String dob;
  String age;
  String gender;
  String title;
  String fName;
  String mName;
  String lName;
  String cast;
  String pAddress1;
  String pAddress2;
  String pAddress3;
  String pCity;
  String pState;
  String pPincode;
  String pPhone;
  String currentAddress1;
  String currentAddress2;
  String currentAddress3;
  String currentCity;
  String currentState;
  String currentPincode;
  String currentPhone;
  String district;
  String subDistrict;
  String village;
  String aadharNo;
  bool isAadharVerified;
  String panNo;
  bool isPanVerified;
  String dl;
  String dLExpiry;
  bool isDlVerified;
  String voterId;
  bool isVoterVerified;
  String passbook;
  String passport;
  String passportExpiry;
  String bankAc;
  String bankName;
  String bankIfcs;
  String bankAddress;
  bool isHouseRental;
  int loanAmount;
  String loanDuration;
  int emi;
  String vehicleType;
  String depedentPerson;
  String groupCode;
  String branchCode;
  String religion;
  String smCode;
  bool isPhnnoVerified;
  int userId;
  int propertyArea;
  bool isExserviceman;
  String latitude;
  String longitude;
  String geoDateTime;
  String eSignUuid;
  bool isNameVerify;
  int noOfChildren;
  String emailId;
  bool isHandicap;
  String handicapType;
  String placeOfBirth;
  String forM60TnxDt;
  String forM60Submissiondate;
  String maritaLStatus;
  String reservatioNCategory;
  String encProperty;
  bool isActive;
  String createdOn;
  String createdBy;
  String modifiedOn;
  String modifiedBy;
  bool approved;
  String residentialType;
  String houseOwnerName;
  String rentofHouse;
  String panName;
  String voterName;
  String aadharName;
  String dLName;
  String liveInPresentPlace;
  String authId;
  String authUser;
  String bankAcOpenDate;
  String profilePic;
  String fiSignature;
  String caseNo;
  String spousEFirstName;
  String spousEMiddleName;
  String spousELastName;
  String motheRFirstName;
  String motheRMiddleName;
  String motheRLastName;
  String motheRMaidenName;
  String fatheRFirstName;
  String fatheRMiddleName;
  String fatheRLastName;
  int schoolingChildren;
  int otherDependents;
  bool isCkyCisDone;
  String errormsg;
  bool isvalid;
  String financialStatus;
  String relationWithBorrower;
  String loanReason;
  String expenses;
  String income;
  List<FiIncomeExpense> fiIncomeExpenses;
  List<FamilyMember> familyMembers;
  List<Guarantor> guarantors;

  ApplicationgetAllDataModel({
    required this.fiId,
    required this.fiCode,
    required this.creator,
    required this.dob,
    required this.age,
    required this.gender,
    required this.title,
    required this.fName,
    required this.mName,
    required this.lName,
    required this.cast,
    required this.pAddress1,
    required this.pAddress2,
    required this.pAddress3,
    required this.pCity,
    required this.pState,
    required this.pPincode,
    required this.pPhone,
    required this.currentAddress1,
    required this.currentAddress2,
    required this.currentAddress3,
    required this.currentCity,
    required this.currentState,
    required this.currentPincode,
    required this.currentPhone,
    required this.district,
    required this.subDistrict,
    required this.village,
    required this.aadharNo,
    required this.isAadharVerified,
    required this.panNo,
    required this.isPanVerified,
    required this.dl,
    required this.dLExpiry,
    required this.isDlVerified,
    required this.voterId,
    required this.isVoterVerified,
    required this.passbook,
    required this.passport,
    required this.passportExpiry,
    required this.bankAc,
    required this.bankName,
    required this.bankIfcs,
    required this.bankAddress,
    required this.isHouseRental,
    required this.loanAmount,
    required this.loanDuration,
    required this.emi,
    required this.vehicleType,
    required this.depedentPerson,
    required this.groupCode,
    required this.branchCode,
    required this.religion,
    required this.smCode,
    required this.isPhnnoVerified,
    required this.userId,
    required this.propertyArea,
    required this.isExserviceman,
    required this.latitude,
    required this.longitude,
    required this.geoDateTime,
    required this.eSignUuid,
    required this.isNameVerify,
    required this.noOfChildren,
    required this.emailId,
    required this.isHandicap,
    required this.handicapType,
    required this.placeOfBirth,
    required this.forM60TnxDt,
    required this.forM60Submissiondate,
    required this.maritaLStatus,
    required this.reservatioNCategory,
    required this.encProperty,
    required this.isActive,
    required this.createdOn,
    required this.createdBy,
    required this.modifiedOn,
    required this.modifiedBy,
    required this.approved,
    required this.residentialType,
    required this.houseOwnerName,
    required this.rentofHouse,
    required this.panName,
    required this.voterName,
    required this.aadharName,
    required this.dLName,
    required this.liveInPresentPlace,
    required this.authId,
    required this.authUser,
    required this.bankAcOpenDate,
    required this.profilePic,
    required this.fiSignature,
    required this.caseNo,
    required this.spousEFirstName,
    required this.spousEMiddleName,
    required this.spousELastName,
    required this.motheRFirstName,
    required this.motheRMiddleName,
    required this.motheRLastName,
    required this.motheRMaidenName,
    required this.fatheRFirstName,
    required this.fatheRMiddleName,
    required this.fatheRLastName,
    required this.schoolingChildren,
    required this.otherDependents,
    required this.isCkyCisDone,
    required this.errormsg,
    required this.isvalid,
    required this.financialStatus,
    required this.relationWithBorrower,
    required this.loanReason,
    required this.expenses,
    required this.income,
    required this.fiIncomeExpenses,
    required this.familyMembers,
    required this.guarantors,
  });

  factory ApplicationgetAllDataModel.fromJson(Map<String, dynamic> json) => ApplicationgetAllDataModel(
    fiId: json["fi_Id"]??"testing",
    fiCode: json["fiCode"]??"testing",
    creator: json["creator"]??"testing",
    dob: json["dob"]??"testing",
    age: json["age"]??"testing",
    gender: json["gender"]??"testing",
    title: json["title"]??"testing",
    fName: json["f_Name"]??"testing",
    mName: json["m_Name"]??"testing",
    lName: json["l_Name"]??"testing",
    cast: json["cast"]??"SC",
    pAddress1: json["p_Address1"]??"testing",
    pAddress2: json["p_Address2"]??"testing",
    pAddress3: json["p_Address3"]??"testing",
    pCity: json["p_City"]??"testing",
    pState: json["p_State"]??"Uttar Pradesh",
    pPincode: json["p_Pincode"]??"testing",
    pPhone: json["p_Phone"]??"testing",
    currentAddress1: json["current_Address1"]??"testing",
    currentAddress2: json["current_Address2"]??"testing",
    currentAddress3: json["current_Address3"]??"testing",
    currentCity: json["current_City"]??"testing",
    currentState: json["current_State"]??"Uttar Pradesh",
    currentPincode: json["current_Pincode"]??"testing",
    currentPhone: json["current_Phone"]??"testing",
    district: json["district"]??"testing",
    subDistrict: json["sub_District"]??"testing",
    village: json["village"]??"testing",
    aadharNo: json["aadhar_no"]??"testing",
    isAadharVerified: json["isAadharVerified"]??"testing",
    panNo: json["pan_no"]??"testing",
    isPanVerified: json["isPanVerified"]??"testing",
    dl: json["dl"]??"testing",
    dLExpiry: json["dL_Expiry"]??"testing",
    isDlVerified: json["isDlVerified"]??"testing",
    voterId: json["voter_id"]??"testing",
    isVoterVerified: json["isVoterVerified"]??"testing",
    passbook: json["passbook"]??"testing",
    passport: json["passport"]??"testing",
    passportExpiry: json["passport_expiry"]??"testing",
    bankAc: json["bank_Ac"]??"testing",
    bankName: json["bank_name"]??"testing",
    bankIfcs: json["bank_IFCS"]??"testing",
    bankAddress: json["bank_address"]??"testing",
    isHouseRental: json["is_house_rental"]??"Yes",
    loanAmount: json["loan_amount"]??"testing",
    loanDuration: json["loan_Duration"]??"testing",
    emi: json["emi"]??"testing",
    vehicleType: json["vehicle_type"]??"testing",
    depedentPerson: json["depedent_person"]??"2",
    groupCode: json["group_code"]??"testing",
    branchCode: json["branch_code"]??"testing",
    religion: json["religion"]??"Hindu",
    smCode: json["smCode"]??"testing",
    isPhnnoVerified: json["is_phnno_verified"]??"testing",
    userId: json["user_Id"]??"testing",
    propertyArea: json["property_area"]==0?1:json["property_area"],
    isExserviceman: json["is_exserviceman"]??"testing",
    latitude: json["latitude"]??"testing",
    longitude: json["longitude"]??"testing",
    geoDateTime: json["geoDateTime"]??"testing",
    eSignUuid: json["eSignUUID"]??"testing",
    isNameVerify: json["isNameVerify"]??"testing",
    noOfChildren: json["no_of_children"]==0?1:json["no_of_children"],
    emailId: json["email_Id"]??"testing",
    isHandicap: json["isHandicap"]??"Yes",
    handicapType: json["handicap_type"]??"Yes",
    placeOfBirth: json["place_Of_Birth"]??"testing",
    forM60TnxDt: json["forM60_TNX_DT"]??"testing",
    forM60Submissiondate: json["forM60_SUBMISSIONDATE"]??"testing",
    maritaLStatus: json["maritaL_STATUS"]??"testing",
    reservatioNCategory: json["reservatioN_CATEGORY"]??"testing",
    encProperty: json["enc_Property"]??"testing",
    isActive: json["isActive"]??"testing",
    createdOn: json["createdOn"]??"testing",
    createdBy: json["createdBy"]??"testing",
    modifiedOn: json["modifiedOn"]??"testing",
    modifiedBy: json["modifiedBy"]??"testing",
    approved: json["approved"]??"testing",
    residentialType: json["residential_type"]??"testing",
    houseOwnerName: json["house_owner_Name"]??"Self",
    rentofHouse: json["rentofHouse"]??"testing",
    panName: json["pan_Name"]??"testing",
    voterName: json["voter_Name"]??"testing",
    aadharName: json["aadhar_Name"]??"testing",
    dLName: json["dL_Name"]??"testing",
    liveInPresentPlace: json["liveInPresentPlace"]??"testing",
    authId: json["auth_Id"]??"testing",
    authUser: json["auth_User"]??"testing",
    bankAcOpenDate: json["bankAC_OpenDate"]??"testing",
    profilePic: json["profilePic"]??"testing",
    fiSignature: json["fi_Signature"]??"testing",
    caseNo: json["caseNo"]??"testing",
    spousEFirstName: json["spousE_FIRST_NAME"]??"testing",
    spousEMiddleName: json["spousE_MIDDLE_NAME"]??"testing",
    spousELastName: json["spousE_LAST_NAME"]??"testing",
    motheRFirstName: json["motheR_FIRST_NAME"]??"testing",
    motheRMiddleName: json["motheR_MIDDLE_NAME"]??"testing",
    motheRLastName: json["motheR_LAST_NAME"]??"testing",
    motheRMaidenName: json["motheR_MAIDEN_NAME"]??"testing",
    fatheRFirstName: json["fatheR_FIRST_NAME"]??"testing",
    fatheRMiddleName: json["fatheR_MIDDLE_NAME"]??"testing",
    fatheRLastName: json["fatheR_LAST_NAME"]??"testing",
    schoolingChildren: json["schoolingChildren"]==0?1:json["schoolingChildren"],
    otherDependents: json["otherDependents"]==0?1:json["otherDependents"] ,
    isCkyCisDone: json["isCKYCisDone"]??"testing",
    errormsg: json["errormsg"]??"testing",
    isvalid: json["isvalid"]??"testing",
    financialStatus: json["financialStatus"]??"testing",
    relationWithBorrower: json["relation_With_Borrower"]??"testing",
    loanReason: json["loan_Reason"]??"testing",
    expenses: json["expenses"]??"testing",
    income: json["income"]??"testing",
    fiIncomeExpenses: List<FiIncomeExpense>.from(json["fiIncomeExpenses"].map((x) => FiIncomeExpense.fromJson(x))),
    familyMembers: List<FamilyMember>.from(json["familyMembers"].map((x) => FamilyMember.fromJson(x))),
    guarantors: List<Guarantor>.from(json["guarantors"].map((x) => Guarantor.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "fi_Id": fiId,
    "fiCode": fiCode,
    "creator": creator,
    "dob": dob,
    "age": age,
    "gender": gender,
    "title": title,
    "f_Name": fName,
    "m_Name": mName,
    "l_Name": lName,
    "cast": cast,
    "p_Address1": pAddress1,
    "p_Address2": pAddress2,
    "p_Address3": pAddress3,
    "p_City": pCity,
    "p_State": pState,
    "p_Pincode": pPincode,
    "p_Phone": pPhone,
    "current_Address1": currentAddress1,
    "current_Address2": currentAddress2,
    "current_Address3": currentAddress3,
    "current_City": currentCity,
    "current_State": currentState,
    "current_Pincode": currentPincode,
    "current_Phone": currentPhone,
    "district": district,
    "sub_District": subDistrict,
    "village": village,
    "aadhar_no": aadharNo,
    "isAadharVerified": isAadharVerified,
    "pan_no": panNo,
    "isPanVerified": isPanVerified,
    "dl": dl,
    "dL_Expiry": dLExpiry,
    "isDlVerified": isDlVerified,
    "voter_id": voterId,
    "isVoterVerified": isVoterVerified,
    "passbook": passbook,
    "passport": passport,
    "passport_expiry": passportExpiry,
    "bank_Ac": bankAc,
    "bank_name": bankName,
    "bank_IFCS": bankIfcs,
    "bank_address": bankAddress,
    "is_house_rental": isHouseRental,
    "loan_amount": loanAmount,
    "loan_Duration": loanDuration,
    "emi": emi,
    "vehicle_type": vehicleType,
    "depedent_person": depedentPerson,
    "group_code": groupCode,
    "branch_code": branchCode,
    "religion": religion,
    "smCode": smCode,
    "is_phnno_verified": isPhnnoVerified,
    "user_Id": userId,
    "property_area": propertyArea,
    "is_exserviceman": isExserviceman,
    "latitude": latitude,
    "longitude": longitude,
    "geoDateTime": geoDateTime,
    "eSignUUID": eSignUuid,
    "isNameVerify": isNameVerify,
    "no_of_children": noOfChildren,
    "email_Id": emailId,
    "isHandicap": isHandicap,
    "handicap_type": handicapType,
    "place_Of_Birth": placeOfBirth,
    "forM60_TNX_DT": forM60TnxDt,
    "forM60_SUBMISSIONDATE": forM60Submissiondate,
    "maritaL_STATUS": maritaLStatus,
    "reservatioN_CATEGORY": reservatioNCategory,
    "enc_Property": encProperty,
    "isActive": isActive,
    "createdOn": createdOn,
    "createdBy": createdBy,
    "modifiedOn": modifiedOn,
    "modifiedBy": modifiedBy,
    "approved": approved,
    "residential_type": residentialType,
    "house_owner_Name": houseOwnerName,
    "rentofHouse": rentofHouse,
    "pan_Name": panName,
    "voter_Name": voterName,
    "aadhar_Name": aadharName,
    "dL_Name": dLName,
    "liveInPresentPlace": liveInPresentPlace,
    "auth_Id": authId,
    "auth_User": authUser,
    "bankAC_OpenDate": bankAcOpenDate,
    "profilePic": profilePic,
    "fi_Signature": fiSignature,
    "caseNo": caseNo,
    "spousE_FIRST_NAME": spousEFirstName,
    "spousE_MIDDLE_NAME": spousEMiddleName,
    "spousE_LAST_NAME": spousELastName,
    "motheR_FIRST_NAME": motheRFirstName,
    "motheR_MIDDLE_NAME": motheRMiddleName,
    "motheR_LAST_NAME": motheRLastName,
    "motheR_MAIDEN_NAME": motheRMaidenName,
    "fatheR_FIRST_NAME": fatheRFirstName,
    "fatheR_MIDDLE_NAME": fatheRMiddleName,
    "fatheR_LAST_NAME": fatheRLastName,
    "schoolingChildren": schoolingChildren,
    "otherDependents": otherDependents,
    "isCKYCisDone": isCkyCisDone,
    "errormsg": errormsg,
    "isvalid": isvalid,
    "financialStatus": financialStatus,
    "relation_With_Borrower": relationWithBorrower,
    "loan_Reason": loanReason,
    "expenses": expenses,
    "income": income,
    "fiIncomeExpenses": List<dynamic>.from(fiIncomeExpenses.map((x) => x.toJson())),
    "familyMembers": List<dynamic>.from(familyMembers.map((x) => x.toJson())),
    "guarantors": List<dynamic>.from(guarantors.map((x) => x.toJson())),
  };
}

class FamilyMember {
  String famName;
  int famAge;
  String famGender;
  String famRelationWithBorrower;
  String famHealth;
  String famEducation;
  String famSchoolType;
  String famBusiness;
  int famIncome;
  String famBusinessType;
  String famIncomeType;

  FamilyMember({
    required this.famName,
    required this.famAge,
    required this.famGender,
    required this.famRelationWithBorrower,
    required this.famHealth,
    required this.famEducation,
    required this.famSchoolType,
    required this.famBusiness,
    required this.famIncome,
    required this.famBusinessType,
    required this.famIncomeType,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) => FamilyMember(
    famName: json["fam_Name"]??"",
    famAge: json["fam_Age"]??"",
    famGender: json["fam_Gender"]=="M"?"Male":(json["fam_Gender"]=="F"?"Female":"Others"),
    famRelationWithBorrower: json["fam_RelationWithBorrower"]??"Father",
    famHealth: json["fam_Health"]??"Healthy",
    famEducation: json["fam_Education"]??"",
    famSchoolType: json["fam_SchoolType"]??"",
    famBusiness: json["fam_Business"]??"",
    famIncome: json["fam_Income"]??"",
    famBusinessType: json["fam_BusinessType"]??"",
    famIncomeType: json["fam_IncomeType"]??"",
  );

  Map<String, dynamic> toJson() => {
    "fam_Name": famName,
    "fam_Age": famAge,
    "fam_Gender": famGender,
    "fam_RelationWithBorrower": famRelationWithBorrower,
    "fam_Health": famHealth,
    "fam_Education": famEducation,
    "fam_SchoolType": famSchoolType,
    "fam_Business": famBusiness,
    "fam_Income": famIncome,
    "fam_BusinessType": famBusinessType,
    "fam_IncomeType": famIncomeType,
  };
}

class FiIncomeExpense {
  String inExOccupation;
  String inExBusinessDetail;
  bool inExAnyCurrentEmi;
  int inExFutureIncome;
  int inExAgricultureIncome;
  int inExEarningMemCount;
  int inExOtherIncome;
  int inExAnnualIncome;
  int inExSpendOnChildren;
  int inExOtherThanAgriculturalIncome;
  int inExYearsInBusiness;
  int inExPensionIncome;
  int inExAnyRentalIncome;
  int inExRent;
  int inExFooding;
  int inExEducation;
  int inExHealth;
  int inExTravelling;
  int inExEntertainment;
  int inExOthers;
  String inExHomeType;
  String inExHomeRoofType;
  String inExToiletType;
  bool inExLivingWithSpouse;
  String inExDocsPath;

  FiIncomeExpense({
    required this.inExOccupation,
    required this.inExBusinessDetail,
    required this.inExAnyCurrentEmi,
    required this.inExFutureIncome,
    required this.inExAgricultureIncome,
    required this.inExEarningMemCount,
    required this.inExOtherIncome,
    required this.inExAnnualIncome,
    required this.inExSpendOnChildren,
    required this.inExOtherThanAgriculturalIncome,
    required this.inExYearsInBusiness,
    required this.inExPensionIncome,
    required this.inExAnyRentalIncome,
    required this.inExRent,
    required this.inExFooding,
    required this.inExEducation,
    required this.inExHealth,
    required this.inExTravelling,
    required this.inExEntertainment,
    required this.inExOthers,
    required this.inExHomeType,
    required this.inExHomeRoofType,
    required this.inExToiletType,
    required this.inExLivingWithSpouse,
    required this.inExDocsPath,
  });

  factory FiIncomeExpense.fromJson(Map<String, dynamic> json) => FiIncomeExpense(
    inExOccupation: json["inEx_Occupation"]??"Self Employeed",
    inExBusinessDetail: json["inEx_BusinessDetail"]??"Self Employeed",
    inExAnyCurrentEmi: json["inEx_AnyCurrentEMI"]??"",
    inExFutureIncome: json["inEx_FutureIncome"]??"",
    inExAgricultureIncome: json["inEx_AgricultureIncome"]??"",
    inExEarningMemCount: json["inEx_EarningMemCount"]==0?1:json["inEx_EarningMemCount"],
    inExOtherIncome: json["inEx_OtherIncome"]??"",
    inExAnnualIncome: json["inEx_AnnualIncome"]??"",
    inExSpendOnChildren: json["inEx_SpendOnChildren"]??"",
    inExOtherThanAgriculturalIncome: json["inEx_OtherThanAgriculturalIncome"]??"",
    inExYearsInBusiness: json["inEx_YearsInBusiness"]??"",
    inExPensionIncome: json["inEx_PensionIncome"]??"",
    inExAnyRentalIncome: json["inEx_AnyRentalIncome"]??"",
    inExRent: json["inEx_Rent"]??"",
    inExFooding: json["inEx_Fooding"]??"",
    inExEducation: json["inEx_Education"]??"",
    inExHealth: json["inEx_Health"]??"",
    inExTravelling: json["inEx_Travelling"]??"",
    inExEntertainment: json["inEx_Entertainment"]??"",
    inExOthers: json["inEx_Others"]??"",
    inExHomeType: json["inEx_HomeType"]??"Self House",
    inExHomeRoofType: json["inEx_HomeRoofType"]??"RCC Roof",
    inExToiletType: json["inEx_ToiletType"]??"Personal Toilet",
    inExLivingWithSpouse: json["inEx_LivingWithSpouse"]??"Yes",
    inExDocsPath: json["inEx_DocsPath"]??"",
  );

  Map<String, dynamic> toJson() => {
    "inEx_Occupation": inExOccupation,
    "inEx_BusinessDetail": inExBusinessDetail,
    "inEx_AnyCurrentEMI": inExAnyCurrentEmi,
    "inEx_FutureIncome": inExFutureIncome,
    "inEx_AgricultureIncome": inExAgricultureIncome,
    "inEx_EarningMemCount": inExEarningMemCount,
    "inEx_OtherIncome": inExOtherIncome,
    "inEx_AnnualIncome": inExAnnualIncome,
    "inEx_SpendOnChildren": inExSpendOnChildren,
    "inEx_OtherThanAgriculturalIncome": inExOtherThanAgriculturalIncome,
    "inEx_YearsInBusiness": inExYearsInBusiness,
    "inEx_PensionIncome": inExPensionIncome,
    "inEx_AnyRentalIncome": inExAnyRentalIncome,
    "inEx_Rent": inExRent,
    "inEx_Fooding": inExFooding,
    "inEx_Education": inExEducation,
    "inEx_Health": inExHealth,
    "inEx_Travelling": inExTravelling,
    "inEx_Entertainment": inExEntertainment,
    "inEx_Others": inExOthers,
    "inEx_HomeType": inExHomeType,
    "inEx_HomeRoofType": inExHomeRoofType,
    "inEx_ToiletType": inExToiletType,
    "inEx_LivingWithSpouse": inExLivingWithSpouse,
    "inEx_DocsPath": inExDocsPath,
  };
}

class Guarantor {
  int grSno;
  String grTitle;
  String grFname;
  String grMname;
  String grLname;
  String grGuardianName;
  String grRelationWithBorrower;
  String grPAddress1;
  String grPAddress2;
  String grPAddress3;
  String grPCity;
  String grPState;
  int grPincode;
  String grDob;
  int grAge;
  String grPhone;
  String grPan;
  String grDl;
  String grVoter;
  String grAadharId;
  String grGender;
  String grReligion;
  bool grEsignSucceed;
  String grEsignUuid;
  String grPicture;

  Guarantor({
    required this.grSno,
    required this.grTitle,
    required this.grFname,
    required this.grMname,
    required this.grLname,
    required this.grGuardianName,
    required this.grRelationWithBorrower,
    required this.grPAddress1,
    required this.grPAddress2,
    required this.grPAddress3,
    required this.grPCity,
    required this.grPState,
    required this.grPincode,
    required this.grDob,
    required this.grAge,
    required this.grPhone,
    required this.grPan,
    required this.grDl,
    required this.grVoter,
    required this.grAadharId,
    required this.grGender,
    required this.grReligion,
    required this.grEsignSucceed,
    required this.grEsignUuid,
    required this.grPicture,
  });

  factory Guarantor.fromJson(Map<String, dynamic> json) => Guarantor(
    grSno: json["gr_Sno"]??"",
    grTitle: json["gr_Title"]??"",
    grFname: json["gr_Fname"]??"",
    grMname: json["gr_Mname"]??"",
    grLname: json["gr_Lname"]??"",
    grGuardianName: json["gr_GuardianName"]??"",
    grRelationWithBorrower: json["gr_RelationWithBorrower"]??"",
    grPAddress1: json["gr_PAddress1"]??"",
    grPAddress2: json["gr_PAddress2"]??"",
    grPAddress3: json["gr_PAddress3"]??"",
    grPCity: json["gr_PCity"]??"",
    grPState: json["gr_PState"]??"Uttar Pradesh",
    grPincode: json["gr_Pincode"]??"",
    grDob: json["gr_Dob"]??"",
    grAge: json["gr_Age"]??"",
    grPhone: json["gr_Phone"]??"",
    grPan: json["gr_Pan"]??"",
    grDl: json["gr_Dl"]??"",
    grVoter: json["gr_Voter"]??"",
    grAadharId: json["gr_AadharId"]??"",
    grGender: json["gr_Gender"]??"",
    grReligion: json["gr_Religion"]??"",
    grEsignSucceed: json["gr_EsignSucceed"]??"",
    grEsignUuid: json["gr_EsignUuid"]??"",
    grPicture: json["gr_Picture"]??"",
  );

  Map<String, dynamic> toJson() => {
    "gr_Sno": grSno,
    "gr_Title": grTitle,
    "gr_Fname": grFname,
    "gr_Mname": grMname,
    "gr_Lname": grLname,
    "gr_GuardianName": grGuardianName,
    "gr_RelationWithBorrower": grRelationWithBorrower,
    "gr_PAddress1": grPAddress1,
    "gr_PAddress2": grPAddress2,
    "gr_PAddress3": grPAddress3,
    "gr_PCity": grPCity,
    "gr_PState": grPState,
    "gr_Pincode": grPincode,
    "gr_Dob": grDob,
    "gr_Age": grAge,
    "gr_Phone": grPhone,
    "gr_Pan": grPan,
    "gr_Dl": grDl,
    "gr_Voter": grVoter,
    "gr_AadharId": grAadharId,
    "gr_Gender": grGender,
    "gr_Religion": grReligion,
    "gr_EsignSucceed": grEsignSucceed,
    "gr_EsignUuid": grEsignUuid,
    "gr_Picture": grPicture,
  };
}
