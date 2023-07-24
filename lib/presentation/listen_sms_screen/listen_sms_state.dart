import 'package:crypto_app/data/isar_entity/messages.dart';
import 'package:crypto_app/data/websocket_response/response.dart';
import 'package:crypto_app/errors/app_error.dart';
import 'package:crypto_app/presentation/listen_sms_screen/history_ui_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'listen_sms_cubit.dart';

part 'listen_sms_state.freezed.dart';

@freezed
class ListenSmsState with _$ListenSmsState {
  const factory ListenSmsState({
    @Default(false)bool isLoading,
  //  @Default([])List<Messages> messages,
  //  @Default([])List<Messages> badMessages,
    AppError? error,
    @Default([])List<HistoryUiModel> messages,
    List<DateTime?>? dateRange,
   // @Default(MessagesToShow.allMessages)MessagesToShow messagesToShow,
  }) = _ListenSmsState;
}
