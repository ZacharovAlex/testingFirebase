import 'package:crypto_app/di/injectable.dart';
import 'package:crypto_app/presentation/common/fancy_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


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
  // final TextEditingController _controllerNumberInput = TextEditingController();
  // String initialCountry = 'RU';
  // PhoneNumber number = PhoneNumber(isoCode: 'RU');
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListenSmsCubit, ListenSmsState>(builder: (_, state) {
      final cubit = context.read<ListenSmsCubit>();
      final messagesToShow =
          state.messagesToShow == MessagesToShow.allMessages ? state.messages : state.badMessages;

      return Column(
        children: [
          Container(
            color: Colors.black,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor:state.messagesToShow==MessagesToShow.allMessages? Colors.grey:Colors.black),
                      onPressed: () => cubit.changeShowMessages(MessagesToShow.allMessages),
                      child: Text('All messages')),
                ),
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor:state.messagesToShow==MessagesToShow.badMessages? Colors.grey:Colors.black),
                      onPressed: () => cubit.changeShowMessages(MessagesToShow.badMessages),
                      child: Text('Error Messages')),
                ),
              ],
            ),
          ),
          messagesToShow != null
              ? Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: messagesToShow.length,
                      itemBuilder: (BuildContext context, int index) {
                        print('message index $index statuscode ${messagesToShow[index].statusCode} status - ${messagesToShow[index].status}');
                        Color color1=Colors.green;
                        Color color2=Colors.green;
                        if(messagesToShow[index].status==true){
                          print('message sttatus $index ${messagesToShow[index].status}');
                          if (messagesToShow[index].statusCode=='200'){
                            print('message sttatus $index ${messagesToShow[index].statusCode}');
                             color1 = Colors.green[400]!;
                             color2 = Colors.green[100]!;
                          }else{
                             color1 = Colors.orangeAccent[400]!;
                            color2 = Colors.orangeAccent[100]!;
                          }
                        }else{
                          color1 = Colors.red.withOpacity(0.5);
                          color2 = Colors.red.withOpacity(0.9);
                        }
                       // final color1 =
                        return Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: FancyContainer(
                            statusCode: messagesToShow[index].statusCode??'in progress',
                            date: messagesToShow[index].date!,
                            sender: messagesToShow[index].incoming_number!,
                            subtitle: messagesToShow[index].body!,
                            color1: color1,
                            // messagesToShow[index].status == true
                            //     ? Colors.green[400]
                            //     : Colors.red.withOpacity(0.5),
                            color2: color2,
                            // messagesToShow[index].status == true
                            //     ? Colors.green[100]
                            //     : Colors.red.withOpacity(0.9),
                          ),
                        );

                        //   Container(
                        //   height: 50,
                        //   margin: EdgeInsets.all(2),
                        //   color: messagesToShow[index].status==true? Colors.green[400]:
                        //   Colors.red.withOpacity(0.5),
                        //   child: Center(
                        //       child: Text('${messagesToShow[index].status} (${messagesToShow[index].body})',
                        //         style: TextStyle(fontSize: 18),
                        //       )
                        //   ),
                        // );
                      }),
                )
              : SizedBox(),
        ],
      );
    });
  }
}
