
import 'package:camera/camera.dart';
import 'package:dosis_exacta/model/contact.dart';
import 'package:dosis_exacta/model/remainder.dart';
import 'package:dosis_exacta/utils/http_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../model/drug.dart';
import '../model/user.dart';
import '../utils/constants.dart';

class RemainderVM {

  Future<List<Drug>> uploadPhoto(XFile image) async {

    var bytes = await image.readAsBytes();
    var response = await HttpHandler().UPLOAD_FILE(API_URL + "/analyze_photo", bytes: bytes.buffer.asByteData());
    print(response.data);

    return [];

  }

  Future<List<Remainder>?> getActiveRemainders() async {
    return await Remainder.getActive();
  }

  checkIngestedRemainder(Remainder remainder) async {
    remainder.ingested = true;
    await remainder.update();
    if(remainder.drug != null) makeNextRemainder(remainder.drug!);
  }

  static cancelPreviousRemainders(Drug drug) async {
    List<Remainder>? remainders = await Remainder.getActive();
    if(remainders != null) {
      for (int i = 0; i < remainders.length; i++) {
        remainders[i].ingested = true;
        await remainders[i].update();
      }
    }
  }

  static makeNextRemainder(Drug drug, { bool cancel = false }) async {

    DateTime now = DateTime.now();
    int hour = now.hour;

    List<int> times = [];

    if (drug.freq_type == FREQ_TYPE.HOUR) {
      times = [drug.start_hour];
      for (int i = drug.start_hour + drug.freq; i % 24 != drug.start_hour; i += drug.freq)
        times.add(i % 24);
    }
    else {
      if (drug.freq == 1) times = [8];
      if (drug.freq == 2) times = [8, 20];
      if (drug.freq == 3) times = [8, 14, 20];
      if (drug.freq == 4) times = [8, 12, 16, 20];
      if (drug.freq == 5) times = [8, 11, 14, 17, 20];
    }

    List<int> diffArr = times.map((e) => e - hour).toList();
    List<int> absArr = diffArr.map((e) => e.abs()).toList();
    List<int> sortedAbsArr = absArr.map((e) => e).toList();
    sortedAbsArr.sort((a, b) => a - b);

    int idx = absArr.indexOf(sortedAbsArr[0]);
    int diff = diffArr[idx];
    int nextTime = -1;

    if(diff <= 0)
      nextTime = times[(idx + 1) % times.length];
    else
      nextTime = times[idx];

    DateTime date;

    if(nextTime < hour)
      date = DateTime(now.year, now.month, now.day + 1, nextTime);
    else
      date = DateTime(now.year, now.month, now.day, nextTime);

    if(cancel) await cancelPreviousRemainders(drug);
    else {

      List<Remainder>? remainders = await Remainder.getSamePeriodAndDrug(date, drug);
      if(remainders != null && remainders.isNotEmpty) {

        nextTime = times[(idx + 1) % times.length];

        if(nextTime < hour)
          date = DateTime(now.year, now.month, now.day + 1, nextTime);
        else
          date = DateTime(now.year, now.month, now.day, nextTime);

      }

    }

    await createNotification(drug, date);

    Remainder remainder = Remainder(ingested: false, date: date);
    remainder.drug = drug;
    await remainder.save();

    return remainder;

  }

  static createNotification(Drug drug, DateTime date) async {

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('launch_background');
    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) {}
    );
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings, onSelectNotification: (String? payload) {});

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'DosisExacta',
      'dosis_Exacta_recordatorios',
      channelDescription: 'Es el canal de comunicación para los recordatorios',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics);

    tz.initializeTimeZones();
    final tzDateTime = tz.TZDateTime.from(date, tz.local);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        drug.name,
        "Es hora de tomar otra dosis, entra a la aplicación para marcar la dosis tomada.",
        tzDateTime,
        platformChannelSpecifics,
        payload: 'item x',
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true
    );

  }
  
  static checkRemainders() async {

    List<User>? users = await User.getAll();

    if(users != null && users.isNotEmpty) {

      List<Remainder>? remainders = await Remainder.getActive();

      if(remainders != null) {

        for(int i = 0; i < remainders.length; i++) {

          var diff = DateTime.now().difference(remainders[i].date);

          if(diff.isNegative) continue;
          if(diff.inMinutes > 15 && diff.inMinutes < 20) {

            List<Contact>? contacts = await Contact.getAll();
            if(contacts != null) {
              for(int j = 0; j < contacts.length; j++)
                await HttpHandler().POST(API_URL + "/send_email", {
                "subject": users.first.name + " - " + remainders[i].drug!.name,
                "body": "Aún no ha ingerido su dosis, por favor atiende sus necesidades.",
                "target": contacts[j].email
                });
            }

          }
        }

      }

    }

  }

}