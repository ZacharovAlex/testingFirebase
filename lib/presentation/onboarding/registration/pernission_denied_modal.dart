import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class PermissionDeniedModal extends StatelessWidget {
  const PermissionDeniedModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   // var res = S.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ModalHeader(
            //   onClose: () => Navigator.popUntil(context, (route) => route.isFirst),
            // ),
            Text(
              'Камера залочена!',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(
              height: 17,
            ),
            Text(
              'Meesage//........ . . ..',
              style: Theme.of(context).textTheme.headline4?.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 49,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    const Size(double.infinity, 59),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  openAppSettings();
                },
                child: Text(
                  'Открыть настройки',
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30, top: 20),
              child: TextButton(
                  onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                  child: Text('Не хочу давать разрешения')),
            )
          ],
        ),
      ),
    );
  }
}
