import 'package:audist/core/exception/add_payment_exception.dart';
import 'package:audist/core/exception/case_information_update_exception.dart';
import 'package:audist/core/model/add_new_case/add_new_case_request_model.dart';
import 'package:audist/core/model/add_payment/add_payment_request_model.dart';
import 'package:audist/core/model/add_payment/add_payment_response_model.dart';
import 'package:audist/core/model/case_information/case_Information_response_model.dart';
import 'package:audist/core/model/case_information/case_information_request_model.dart';
import 'package:audist/core/model/case_information/case_information_view_model.dart';
import 'package:audist/core/network/dio_client.dart';
import 'package:audist/data/cases/model/fetch_case_request.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';

abstract class CaseDatasource {
  Future<Either> fetchAllCases(FetchCaseRequest request);
  Future<Either> fetchAllKindOfCases(FetchCaseRequest request);
  Future<Either> addNewCase(AddNewCaseRequestModel request);
  Future<Either> updateCaseInformation(CaseInformationRequestModel request);
  Future<Either<dynamic, CaseInformationResponseModel>> getCaseInformationData(
    CaseInformationViewModel request,
  );
  Future<Either<AddPaymentException, AddPaymentResponseModel>> addPayment(
    AddPaymentRequestModel request,
  );
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

  @override
  Future<Either<CaseInformationUpdateException, dynamic>> updateCaseInformation(
    CaseInformationRequestModel request,
  ) async {
    debugPrint("=============(UpdateCaseInformation)===========");
    try {
      final dio = DioClient().dio;

      debugPrint("Sending Update Data: $request");

      final response = await dio.post(
        'case/updateDetails',
        data: request.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      debugPrint('Response Data: ${response.data}');
      return Right(response.data);
    } on DioError catch (dioError) {
      // Handle Dio errors
      String errorMessage = "An unexpected error occurred";

      if (dioError.response != null) {
        final statusCode = dioError.response!.statusCode;
        final data = dioError.response!.data;

        switch (statusCode) {
          case 400:
            if (data is Map && data['details'] != null) {
              errorMessage = "Validation failed: ${data['details'].join(', ')}";
            } else if (data is Map && data['error'] != null) {
              errorMessage = data['error'];
            } else {
              errorMessage = "Bad Request";
            }
            break;
          case 403:
            errorMessage = data['error'] ?? "Unauthorized to update this case";
            break;
          case 404:
            errorMessage = data['error'] ?? "Case not found";
            break;
          case 500:
            errorMessage = data['error'] ?? "Internal Server Error";
            break;
          default:
            errorMessage = "Unexpected error: $statusCode";
        }
      } else if (dioError.type == DioExceptionType.connectionTimeout ||
          dioError.type == DioExceptionType.receiveTimeout) {
        errorMessage = "Connection timed out. Please try again.";
      } else if (dioError.type == DioExceptionType.connectionError) {
        errorMessage = "No internet connection or server unreachable.";
      }

      debugPrint('Update failed: $errorMessage');
      return Left(CaseInformationUpdateException(errorMessage));
    } catch (e) {
      debugPrint('Unknown error: $e');
      return Left(
        CaseInformationUpdateException("An unexpected error occurred"),
      );
    } finally {
      debugPrint("============(UpdateCaseInformation)============");
    }
  }

  @override
  Future<Either<dynamic, CaseInformationResponseModel>> getCaseInformationData(
    CaseInformationViewModel request,
  ) async {
    debugPrint("=============(getCaseInformationData)===========");

    try {
      final dio = DioClient().dio;

      final response = await dio.post(
        '/case/viewAllCaseDetails',
        data: request.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      debugPrint("========================");
      debugPrint("========================");
      debugPrint('Response (Success) Get Case Information Data: $response');
      debugPrint(
        'Response (Success) Get Case Information data: ${response.data}',
      );
      debugPrint("========================");
      debugPrint("========================");

      return Right(CaseInformationResponseModel.fromJson(response.data));
    } catch (e) {
      debugPrint('Response (Failed): $e');
      return Left(e);
    } finally {
      debugPrint("============(getCaseInformationData)============");
    }
  }

  @override
  Future<Either<AddPaymentException, AddPaymentResponseModel>> addPayment(
    AddPaymentRequestModel request,
  ) async {
    debugPrint("=============(addPayment)===========");

    try {
      final dio = DioClient().dio;

      final response = await dio.post(
        'payment/addpayment',
        data: request.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      debugPrint("========================");
      debugPrint("========================");
      debugPrint('Response (Success) addPayment: $response');
      debugPrint('Response (Success) addPayment: ${response.data}');
      debugPrint("========================");
      debugPrint("========================");

      return Right(AddPaymentResponseModel.fromJson(response.data));
    } catch (e) {
      debugPrint('Response (Failed): $e');
      return Left(AddPaymentException(message: e.toString()));
    } finally {
      debugPrint("============(addPayment)============");
    }
  }
}
