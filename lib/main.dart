import 'dart:async';

import 'package:dosis_exacta/view/common/theme.dart';
import 'package:dosis_exacta/view/router.dart';
import 'package:dosis_exacta/viewmodel/remainder_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  runApp(const App());
}

const notificationChannelId = 'Dosis Exacta';
const notificationId = 888;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId,
    'Servicio',
    description: 'Estamos monitoreando el tiempo',
    importance: Importance.low,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
      androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: notificationChannelId,
      initialNotificationTitle: 'Servicio',
      initialNotificationContent: 'Estamos pendiente de tu siguiente dosis.',
      foregroundServiceNotificationId: notificationId,
    ),
    iosConfiguration: IosConfiguration()
  );

}


Future<void> onStart(ServiceInstance service) async {
  Timer.periodic(const Duration(minutes: 10), (timer) async {
    if(service is AndroidServiceInstance) {
      if(await service.isForegroundService()) {
        await RemainderVM.checkRemainders();
      }
    }
  });
}

class App extends StatelessWidget {

  const App({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: () =>
          MaterialApp(
            builder: (context, widget) {
              ScreenUtil.setContext(context);
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!,
              );
            },
            theme: THEME,
            routes: ROUTER,
            initialRoute: '/',
          ),
    );

  }

}