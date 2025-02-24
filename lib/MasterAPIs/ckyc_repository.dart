import 'package:dio/dio.dart';
import 'package:flutter_sourcing_app/api_service.dart';

import '../sourcing/global_class.dart';

class CkycRepository {
  late final ApiService apiService;

  CkycRepository();

  Future<bool> searchCkyc(String aadharId, String panNo,String voter, String dob, String gender, String name) async {
    apiService =ApiService.create(baseUrl: ApiConfig.baseUrl1);
    try {
      final response = await apiService.searchCkycNoByAadhar(
        GlobalClass.token,
        GlobalClass.dbName,
        aadharId,
        panNo,
        voter,
        dob,
        gender,
        name
      );
      if(response.statuscode==200){
        int id=response.data[0].fiId;
        if(id==1 || id==-2){
          return true;
        }

      }
      print("CKYC Response $response");
      return false;
      // If the response is successful, return true

    } catch (e) {
      // Handle error
      print("CKYC Error occurred: $e");
      return false;

    }
  }
}
