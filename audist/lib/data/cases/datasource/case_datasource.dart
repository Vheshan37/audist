import 'package:audist/core/model/add_new_case/add_new_case_request_model.dart';
import 'package:audist/core/network/dio_client.dart';
import 'package:audist/data/cases/model/fetch_case_request.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';

abstract class CaseDatasource {
  Future<Either> fetchAllCases(FetchCaseRequest request);
  Future<Either> fetchAllKindOfCases(FetchCaseRequest request);
  Future<Either> addNewCase(AddNewCaseRequestModel request);
}

class CaseDatasourceImpl extends CaseDatasource {
  @override
  Future<Either> fetchAllCases(FetchCaseRequest request) async {
    debugPrint("=============(fetchAllCases)===========");
    debugPrint("fetchAllCases triggered");
    try {
      final dio = DioClient().dio;

      final response = await dio.post(
        '/case/getAll',
        data: {'userID': request.uid},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      debugPrint('Response (Success): ${response.data}');
      return Right(response.data);
    } catch (e) {
      debugPrint('Response (Failed): $e');
      return Left(e);
    } finally {
      debugPrint("============(fetchAllCases)============");
    }
  }

  @override
  Future<Either> fetchAllKindOfCases(FetchCaseRequest request) async {
    debugPrint("=============(fetchAllKindOfCases)===========");
    try {
      final dio = DioClient().dio;

      final response = await dio.post(
        '/case/viewallcases',
        data: {'userID': request.uid},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      debugPrint("========================");
      debugPrint("========================");
      debugPrint('Response (Success) All Kind of Cases: $response');
      debugPrint('Response (Success) All Kind of Cases data: ${response.data}');
      debugPrint("========================");
      debugPrint("========================");

      return Right(response.data);
    } catch (e) {
      debugPrint('Response (Failed): $e');
      return Left(e);
    } finally {
      debugPrint("============(fetchAllKindOfCases)============");
    }
  }

  @override
  Future<Either> addNewCase(AddNewCaseRequestModel request) async {
    debugPrint("=============(addNewCase)===========");
    try {
      final dio = DioClient().dio;

      debugPrint("=============(Case Date: ${request.caseDate})===========");

      final response = await dio.post(
        '/case/add',
        data: {
          "refereeNum": request.refereeNum,
          "caseNumb": request.caseNumb,
          "name": request.name,
          "organization": request.organization,
          "value": request.value,
          "caseDate": request.caseDate,
          "image": "",
          "nic": request.nic,
          "userID": request.userId,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      debugPrint("========================");
      debugPrint("========================");
      debugPrint('Response (Success) Add New Cases: $response');
      debugPrint('Response (Success)Add New Cases data: ${response.data}');
      debugPrint("========================");
      debugPrint("========================");

      return Right(response.data);
    } catch (e) {
      debugPrint('Response (Failed): $e');
      return Left(e);
    } finally {
      debugPrint("============(addNewCase)============");
    }
  }
}
