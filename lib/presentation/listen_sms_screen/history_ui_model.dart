import 'package:crypto_app/data/response/sms_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';


part 'history_ui_model.freezed.dart';

@freezed
class HistoryUiModel with _$HistoryUiModel {
  const factory HistoryUiModel.data(SmsMessagesList value) = Data;

  const factory HistoryUiModel.timestamp(DateTime timestamp) = Timestamp;

  const factory HistoryUiModel.loading() = Loading;
}
