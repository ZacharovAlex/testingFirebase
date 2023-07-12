// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sms_v2/di/injectable.dart';
// import 'package:sms_v2/presentation/home/home_screen.dart';
// import 'package:sms_v2/presentation/onboarding/registration/registration_cubit.dart';
// import 'package:sms_v2/presentation/onboarding/registration/registration_state.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
//
// class OnBoarding extends StatelessWidget {
//   const OnBoarding({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(create: (_) => getIt.get<RegistrationCubit>(), child: _View());
//   }
// }
//
// class _View extends StatefulWidget {
//   const _View({
//     super.key,
//   });
//
//   @override
//   State<_View> createState() => _ViewState();
// }
//
// class _ViewState extends State<_View> {
//   final TextEditingController _controllerNumberInput = TextEditingController();
//   String initialCountry = 'RU';
//   PhoneNumber number = PhoneNumber(isoCode: 'RU');
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<RegistrationCubit, RegistrationState>(builder: (_, state) {
//       final cubit = context.read<RegistrationCubit>();
//       return BlocListener<RegistrationCubit, RegistrationState>(
//         listenWhen: (prev, curr) {
//           return prev.isRegister != curr.isRegister;
//         },
//         listener: (prev, curr) {
//           if (curr.isRegister) {
//             Navigator.push(context, CupertinoPageRoute(builder: (_) => const HomeScreen()));
//           }
//         },
//         child: Scaffold(
//           body: Padding(
//             padding: const EdgeInsets.only(left: 20,right: 20),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Enter your number :'),
//                   SizedBox(height: 15,),
//                   InternationalPhoneNumberInput(
//                     onInputChanged: (PhoneNumber number) {
//                       print(number.phoneNumber);
//                     },
//                     onInputValidated: (bool value) {
//                       print(value);
//                     },
//                     selectorConfig: SelectorConfig(
//                       selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
//                     ),
//                     ignoreBlank: false,
//                     autoValidateMode: AutovalidateMode.disabled,
//                     selectorTextStyle: TextStyle(color: Colors.black),
//                     initialValue: number,
//                     textFieldController: _controllerNumberInput,
//                     formatInput: true,
//                     keyboardType:
//                     TextInputType.numberWithOptions(signed: true, decimal: true),
//                     inputBorder: OutlineInputBorder(),
//                     onSaved: (PhoneNumber number) {
//                       print('On Saved: $number');
//                     },
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       // formKey.currentState?.validate();
//                     },
//                     child: Text('Validate'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       cubit.setSettings();
//                     },
//                     child: Text('REG!'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
