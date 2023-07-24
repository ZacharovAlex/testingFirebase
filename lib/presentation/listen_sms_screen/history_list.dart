import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:crypto_app/presentation/common/fancy_container.dart';
import 'package:crypto_app/presentation/listen_sms_screen/listen_sms_cubit.dart';
import 'package:crypto_app/presentation/listen_sms_screen/loading_item.dart';
import 'package:crypto_app/presentation/listen_sms_screen/timestamp_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HistoryList extends StatefulWidget {
  const HistoryList({Key? key}) : super(key: key);

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  final _scrollController = ScrollController();




  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.extentAfter > 0 &&
          _scrollController.position.extentAfter <= MediaQuery.of(context).size.height) {
        context.read<ListenSmsCubit>().loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = context.select((ListenSmsCubit cubit) => cubit.state.messages);
    final cubit = context.read<ListenSmsCubit>();
    if (data == null) {
      return const Center(
        child: CircularProgressIndicator(),
      ); //SkeletonView();
    }
    if (data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No messages'),
            SizedBox(height: 20,),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    backgroundColor: Colors.green),
                onPressed: ()=>cubit.getHistory(), child: const Text('Refresh'))

          ],
        ),
      ); //EmptyHistory();
    }

    final timestampDateFormatter = DateFormat('dd MMMM', Localizations.localeOf(context).languageCode);
    return RefreshIndicator(
      onRefresh: context.read<ListenSmsCubit>().reload,
      child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: data.length,
          itemBuilder: (_, index) {
            return data[index].when(
                data: (data) => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: FancyContainer(
                            status: data.hasConfirmed,
                            reason: data.reason,
                           // id: data.timeStamp,
                            statusCode: data.hasConfirmed.toString(),
                            date: data.date,
                            sender: data.incomingNumber,
                            subtitle: data.body,
                            color1:
                                data.hasConfirmed == true ? Colors.green[400] : Colors.red.withOpacity(0.5),

                            color2:
                                data.hasConfirmed == true ? Colors.green[100] : Colors.red.withOpacity(0.9),

                          ),
                        ),
                      ],
                    ),
                timestamp: (formattedTimestamp) => TimestampItem(
                  formattedTimestamp,
                      dateFormatter: timestampDateFormatter,
                    ),
                loading: LoadingItem.new);
          }),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
