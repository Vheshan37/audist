import 'package:audist/core/network/dio_client.dart';
import 'package:audist/data/cases/model/fetch_case_request.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';

abstract class CaseDatasource {
  Future<Either> fetchAllCases(FetchCaseRequest request);
}

class CaseDatasourceImpl extends CaseDatasource {
  @override
  Future<Either> fetchAllCases(FetchCaseRequest request) async {
    debugPrint("========================");
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
      debugPrint("========================");
    }
  }
}
