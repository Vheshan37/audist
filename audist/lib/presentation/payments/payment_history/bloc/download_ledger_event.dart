part of 'download_ledger_bloc.dart';

abstract class DownloadLedgerEvent {}

class DownloadAndSaveLedger extends DownloadLedgerEvent {
  final String caseId;
  final String userID;

  DownloadAndSaveLedger(this.caseId, this.userID);
}
