import 'package:audist/data/cases/model/fetch_case_request.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';

abstract class CaseDatasource {
  Future<Either> fetchAllUsers(FetchCaseRequest request);
}

class CaseDatasourceImpl extends CaseDatasource {
  @override
  Future<Either> fetchAllUsers(FetchCaseRequest request) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        'http://10.130.53.50:3000/getAllCases',
        data: {'userID': request.uid},
      );
      debugPrint('Response (Success): ${response.data}');
      return Right(response.data);
    } catch (e) {
      debugPrint('Response (Failed): $e');
      return Left(e);
    }
  }
}
