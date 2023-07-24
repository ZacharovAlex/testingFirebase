import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:crypto_app/di/injectable.dart';
import 'package:crypto_app/presentation/common/fancy_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'history_list.dart';
import 'listen_sms_cubit.dart';
import 'listen_sms_state.dart';

class ListenSmsScreen extends StatelessWidget {
  const ListenSmsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt.get<ListenSmsCubit>(), child: _View());
  }
}

class _View extends StatefulWidget {
  const _View({
    super.key,
  });

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
//List<DateTime> dates = [DateTime.now()];
  void datePickRange(BuildContext context) async {
    var results = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
          // gapBetweenCalendarAndButtons: 100,
          //  closeDialogOnCancelTapped: true,

          buttonPadding: EdgeInsets.only(bottom: 40, right: 40),
          selectedDayHighlightColor: Colors.black,
          selectedRangeHighlightColor: Colors.black.withOpacity(0.5),
          calendarType: CalendarDatePicker2Type.range,
          lastDate: DateTime.now(),
          okButton: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.green, // border color
              shape: BoxShape.circle,
            ),
            child: Center(
                child: Text(
              'OK',
              style: TextStyle(color: Colors.white),
            )),
          ),

// ElevatedButton(
//   style: ElevatedButton.styleFrom(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(40),
//       ),
//       textStyle: TextStyle(color: Colors.black),
//       disabledBackgroundColor: Colors.green,
//       backgroundColor: Colors.green),
//   onPressed: (){}, child: Text('OK'),),
          cancelButton: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                backgroundColor: Colors.black),
            onPressed: () {
              context.read<ListenSmsCubit>().clearDateRange();
              Navigator.pop(context);
            },
            child: Text('Reset filter'),
          )),
      dialogSize: const Size(325, 450),
      value: [DateTime.now()],
      borderRadius: BorderRadius.circular(15),
    );
    if (results != null) {
      setDateRange(results);
    }
    //dateRange = results.toString();
    print(results);
  }

  void setDateRange(List<DateTime?> dates) {
    context.read<ListenSmsCubit>().setDateRange(dates);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListenSmsCubit, ListenSmsState>(builder: (_, state) {
      String? dateString;

      List<DateTime?>? dateRange = state.dateRange;
      if (dateRange != null) {
        dateRange[0] != null
            ? dateString = '${dateRange[0]?.day}.${dateRange[0]?.month}.${dateRange[0]?.year}'
            : '';
        if (dateRange.length == 2) {
          dateRange[1] != null
              ? dateString =
                  'From $dateString to ${dateRange[1]?.day}.${dateRange[1]?.month}.${dateRange[1]?.year}'
              : '';
        }
      }
      return Column(
        children: [
         SizedBox(
                  height: 15,
                )
             ,
         Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Show :',
                      style: TextStyle(fontSize: 20),
                    ),
                    // GestureDetector(
                    //      onTap: () => datePickRange(context),
                    //     child: Text(dateString??'For all period')),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          backgroundColor: Colors.green),
                      onPressed: () => datePickRange(context),
                      child: Text(
                        dateString ?? 'For all period',
                        style: TextStyle(fontSize: 10),
                      ),
                    )
                  ],
                )
              ,
          SizedBox(
                  height: 15,
                )
            ,
         state.isLoading?Center(child: CircularProgressIndicator(),): Expanded(child: HistoryList()),
        ],
      );
    });
  }
}
