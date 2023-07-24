import 'dart:io';

import 'package:crypto_app/data/isar_entity/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import 'hole_painter.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> with WidgetsBindingObserver {
  final _cameraController = MobileScannerController();
  bool _barcodeHandled = false;
  PermissionStatus? _status;
  bool _resumeFromBackground = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissions();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        {
          _resumeFromBackground = false;
          break;
        }
      case AppLifecycleState.paused:
        {
          _resumeFromBackground = true;
          break;
        }
      case AppLifecycleState.resumed:
        {
          if (_resumeFromBackground || Platform.isIOS) {
            _checkPermissions();
          }
          break;
        }
      case AppLifecycleState.detached:
        break;
    }
  }

  Future<void> _checkPermissions() async {
    var newStatus = await Permission.camera.status;
    if (newStatus != PermissionStatus.granted) {
      Map<Permission, PermissionStatus> statuses = await [Permission.camera].request();
      newStatus = statuses.values.first;
    }
    if (mounted) {
      if (newStatus == PermissionStatus.granted) {
        setState(() {
          _status = newStatus;
        });
      } else {
        // _checkPermissions();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                title: Text(
                  "Start service with this parameters? ",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                content: Container(
                  // height: 230,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Url: ",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      // Text("${settings.url}", style: TextStyle(fontSize: 13)),
                      SizedBox(
                        height: 10,
                      ),
                      Text("PrivateApi: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      // Text("${settings.privateApi}", style: TextStyle(fontSize: 13)),
                      SizedBox(
                        height: 10,
                      ),
                      Text("PublicApi: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      //  Text("${settings.publicApi}", style: TextStyle(fontSize: 13)),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Telegram: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      // Text('fdd',
                      //  // "${settings.telegram}",
                      //   style: TextStyle(fontSize: 13),
                      // ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              );
            });
        //  showModal(context, isDismissible: false, enableDrag: false, (_) => const PermissionDeniedModal());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          if (_status == PermissionStatus.granted)
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: _cameraController.torchState,
                builder: (context, state, child) {
                  switch (state) {
                    case TorchState.off:
                      return const Icon(Icons.flash_off, color: Colors.grey);
                    case TorchState.on:
                      return const Icon(Icons.flash_on, color: Colors.yellow);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: _cameraController.toggleTorch,
            ),
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    UserSettings? parsingQrCode(String? code) {
      // final cubit=context.read<RegistrationCubit>();
      // final test = 'https://duckduckgo.com/about*jhvgghghfdfhdf57hg78*jprivateoijuytredsfghhdf57hg78*_usertelega';
      if (code != null && code != '') {
        var words = code.split('*');
        if (words.length == 4 && words[0] != '' && words[1] != '' && words[2] != '' && words[3] != '') {
          print('RESULT :${words[0]} iii ${words[1]} iiii ${words[2]} ${words[3]}');
          final newSettings = UserSettings()
            ..url = words[0]
            ..privateApi = words[1]
            ..publicApi = words[2]
            ..telegram = words[3];
          return newSettings;
          // cubit.setSettings(newSettings);
          //  Navigator.push(context, CupertinoPageRoute(builder: (_) => const HomeScreen()));
        }
      }
    }

    if (_status != PermissionStatus.granted) {
      return Container(color: Color(0xFFBBBCBE));
    }
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(36)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    MobileScanner(
                      fit: BoxFit.fill,
                      controller: _cameraController,
                      errorBuilder: (_, __, ___) {
                        return Container(
                          color: Colors.grey,
                        );
                      },
                      onDetect: (data) {
                        print('DATASCANNER: ${data.barcodes.first.url?.url} ');
                        if (data.barcodes.isNotEmpty) {
                          final code =
                              parsingQrCode(data.barcodes.first.url?.url); //data.barcodes.first.rawValue;
                          if (code != null && !_barcodeHandled) {
                            _barcodeHandled = true;
                            Navigator.pop(context, code); //TODO navigate to another page after detect!
                            // Navigator.push(
                            //     context,
                            //     CupertinoPageRoute(
                            //         builder: (_) => const HomeScreen()));
                          }
                        }
                      },
                    ),
                    if (_status == PermissionStatus.granted)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: HolePainter(bottomPadding: 16 + MediaQuery.of(context).viewPadding.bottom),
                        ),
                      ),
                    if (_status == PermissionStatus.granted)
                      Positioned.fill(
                          child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                            padding: EdgeInsets.only(bottom: 20 + MediaQuery.of(context).viewPadding.bottom),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  backgroundColor: Colors.green),
                              onPressed: () => Navigator.pop(context),
                              child: Text('Close'),
                            )

                            // OneCryptoButton(
                            //   // icon: Assets.icons.plusCurrencyIcon.svg(width: 13),
                            //   width: MediaQuery.of(context).size.width / 3,
                            //   onPressed: () => Navigator.pop(context),
                            //   title: 'Закрыть',
                            // ),
                            ),
                      ))
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Совершение оплаты через QR-код',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.left,
                )),
            SizedBox(
              height: 8,
            ),
            Text(
              'Для того чтобы оплатить покупку через сканер QR-кода вам нужно навести камеру на сам код, сканировать его, а затем выбрать валюту и ввести сумму.',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
