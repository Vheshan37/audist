import 'package:audist/domain/payments/usecase/download_ledger_usecase.dart';
import 'package:audist/service_locator.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:open_file/open_file.dart';

part 'download_ledger_event.dart';
part 'download_ledger_state.dart';

class DownloadLedgerBloc
    extends Bloc<DownloadLedgerEvent, DownloadLedgerState> {
  DownloadLedgerBloc() : super(DownloadLedgerInitial()) {
    on<DownloadAndSaveLedger>((event, emit) async {
      emit(LedgerLoading());

      try {
        final filePath = await sl<DownloadLedgerUseCase>().call(
          event.caseId,
          event.userID,
        );

        await OpenFile.open(filePath);

        emit(LedgerSuccess(filePath));
      } catch (e) {
        debugPrint('Error downloading ledger: $e');
        emit(LedgerError(e.toString()));
      }
    });
  }
}
