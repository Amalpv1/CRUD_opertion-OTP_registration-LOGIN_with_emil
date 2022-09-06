import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sampleproject/ui_otp_register/view/verification_page.dart';

class otpRegister extends StatefulWidget {
  otpRegister({Key? key}) : super(key: key);

  @override
  State<otpRegister> createState() => _otpRegisterState();
}

class _otpRegisterState extends State<otpRegister> {
  TextEditingController textcontroller = TextEditingController();

  TextEditingController otpcontroller = TextEditingController();

  var androidinitializationsettings =
      AndroidInitializationSettings("@mipmap/ic_launcher");

  FlutterLocalNotificationsPlugin notificationplugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();
    rqstpermission();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          TextField(
            controller: textcontroller,
            decoration: InputDecoration(hintText: 'type'),
          ),
          ElevatedButton(
              onPressed: () async {
                // otpregister();
                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: textcontroller.text,
                  verificationCompleted: (PhoneAuthCredential credential) {
                    print('done');
                  },
                  verificationFailed: (FirebaseAuthException e) {
                    print('failed');
                  },
                  codeSent: (String verificationId, int? resendToken) {
                    showDialog<dynamic>(
                        context: context,
                        builder: (context) {
                          // return verificationPage();
                          return AlertDialog(
                            content: TextField(
                              controller: otpcontroller,
                              decoration: InputDecoration(hintText: 'type'),
                            ),
                            actions: [
                              Center(
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        print('verification done');
                                        PhoneAuthCredential credential =
                                            PhoneAuthProvider.credential(
                                                verificationId: verificationId,
                                                smsCode: otpcontroller.text);
                                        await FirebaseAuth.instance
                                            .signInWithCredential(credential);
                                        Navigator.push<void>(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return verificationPage();
                                        }));
                                      },
                                      child: Text('verify')))
                            ],
                          );
                        });
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {
                    print('time out');
                  },
                );
              },
              child: Text('register'))
        ],
      ),
    ));
  }

  Future<void> otpregister() async {}

  Future<void> rqstpermission() async {
    FirebaseMessaging.instance.requestPermission(
        announcement: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true);
        final initializationSettings = InitializationSettings(
          android: androidinitializationsettings
          );
          notificationplugin.initialize(initializationSettings,onSelectNotification: ((payload) {
            print('playlod');
          }));
          FirebaseMessaging.onMessage.listen((event) {
             print(event);
             });

  }

  Future<void>display(RemoteMessage event)async{
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    notificationplugin.show(0, event.notification!.title, event.notification!.body,platformChannelSpecifics );
  }
}
