import 'dart:io';
import 'dart:typed_data';
import 'package:audist/core/network/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

abstract class PaymentDataSource {
  Future<String> downloadLedger(String caseId, String userID);
}

class PaymentDataSourceImpl implements PaymentDataSource {
  @override
  Future<String> downloadLedger(String caseId, String userID) async {
    final dio = DioClient().dio;

    final response = await dio.post(
      '/payment/generateLedger',
      data: {"caseNumb": caseId, "userID": userID},
      options: Options(
        responseType: ResponseType.bytes,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/pdf',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to download PDF");
    }

    // Normalize bytes (works on all devices)
    final raw = response.data;

    late final Uint8List bytes;

    if (raw is Uint8List) {
      bytes = raw;
    } else if (raw is List<int>) {
      bytes = Uint8List.fromList(raw);
    } else {
      throw Exception("Invalid response type: ${raw.runtimeType}");
    }

    // Save file
    final dir = await getApplicationDocumentsDirectory();
    final filePath = "${dir.path}/LoanLedger_$caseId.pdf";

    final file = File(filePath);
    await file.writeAsBytes(bytes);

    return filePath;
  }
}
