part of 'download_ledger_bloc.dart';

abstract class DownloadLedgerState {}

final class DownloadLedgerInitial extends DownloadLedgerState {}

class LedgerLoading extends DownloadLedgerState {}

class LedgerSuccess extends DownloadLedgerState {
  final String filePath;

  LedgerSuccess(this.filePath);
}

class LedgerError extends DownloadLedgerState {
  final String message;

  LedgerError(this.message);
}
