import 'dart:async';
import 'dart:collection';
import 'package:collection/collection.dart';
import 'package:crypto_app/errors/app_error.dart';
import 'package:crypto_app/errors/default_error.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:crypto_app/data/isar_service.dart';
import 'package:crypto_app/domain/repository/user_data_repository.dart';
import 'package:crypto_app/presentation/base/base_cubit.dart';
import 'package:crypto_app/presentation/listen_sms_screen/history_ui_model.dart';
import 'package:crypto_app/presentation/listen_sms_screen/listen_sms_state.dart';

import '../../data/response/sms_response.dart';

List<HistoryUiModel> groupHistory(List<SmsMessagesList> data) {
  final set = Set<SmsMessagesList>.from(data);
  final groupedItem = groupBy<SmsMessagesList, DateTime>(set, (e) {
    final timestamp = e.date;
    return DateTime(timestamp.year, timestamp.month, timestamp.day);
  });
  final sortedItems =
      SplayTreeMap<DateTime, List<SmsMessagesList>>.from(groupedItem, (a, b) => b.compareTo(a));
  final items = <HistoryUiModel>[];
  sortedItems.forEach((key, value) {
    items.add(HistoryUiModel.timestamp(key));
    value.sort((a, b) => b.date.compareTo(a.date));
    items.addAll(value.map((e) => HistoryUiModel.data(e)));
  });

  return items;
}

@injectable
class ListenSmsCubit extends BaseCubit<ListenSmsState> {
  final IsarService service;
  final Repository repository;
  final _pageLimit = 20;
  var _reachEnd = false;
  var _loading = false;
  DateTime? firstDate;
  DateTime? lastDate;
  final List<SmsMessagesList> _data = [];
  Completer _loadingCompleter = Completer();

  ListenSmsCubit(this.service, this.repository) : super(ListenSmsState()) {
    getHistory();
  }

  void _completeLoading() {
    if (!_loadingCompleter.isCompleted) {
      _loadingCompleter.complete();
    }
  }

  Future<void> getHistory({bool refresh = false}) async {
    if (state.dateRange!=null){
      print('daerange ne null ${state.dateRange.toString()}');
if (state.dateRange![0]!=null){firstDate=state.dateRange![0];}
if (state.dateRange!.length>1){lastDate=state.dateRange![1];}
    }
    _loading = true;
    _loadingCompleter = Completer();
    if (state.messages != null) {
      if (!refresh && state.messages.lastOrNull is! Loading) {
        emit(state.copyWith(messages: [...state.messages, const HistoryUiModel.loading()]));
      }
    }
    try {
      final response = await repository.getListSms(refresh ? null : _data.lastOrNull?.timeStamp,firstDate?.toIso8601String(),lastDate?.toIso8601String(), _pageLimit);
      if (response.result != null) {
        if (refresh) {
          _data.clear();
          _reachEnd = false;
        }
        _reachEnd = response != null &&
            (response.result.isEmpty || response.result.length < _pageLimit);
        _data.addAll(response.result ?? []);
        final items = await compute(groupHistory, _data);
        emit(state.copyWith(messages: items, error: null));
      } else {
        emit(state.copyWith(error: DefaultError()));
      }
    } on AppError catch (e) {
      emit(state.copyWith(
          error: e, messages: List.from(state.messages ?? [])..removeWhere((e) => e is Loading)));
    } finally {
      emit(state.copyWith(isLoading: false));
      _loading = false;
      _completeLoading();
    }
  }

  void loadMore() {
    if (!_reachEnd && !_loading) {
      getHistory();
    }
  }

  Future<void> reload() {
    getHistory(refresh: true);
    return _loadingCompleter.future;
  }

  void setDateRange(List<DateTime?>? dateList) {
    firstDate=null;
    lastDate=null;
    emit(state.copyWith(dateRange: dateList,isLoading: true));
    _data.clear();
    getHistory();

  }
  void clearDateRange() {
    emit(state.copyWith(dateRange: null,isLoading: true));
    firstDate=null;
    lastDate=null;
    print('Clear date range ${state.dateRange.toString()}');
    _data.clear();
    print('data : ${_data.toString()}');
    getHistory();
  }

  void clearFilter() {
    getHistory();
    emit(state.copyWith(dateRange: null));
  }
}

//  void changeShowMessages(MessagesToShow toShow)=>emit(state.copyWith(messagesToShow:toShow));
// // void stopListen()=>emit(state.copyWith(isEnabled:false));
// }

//enum MessagesToShow{allMessages,badMessages}
