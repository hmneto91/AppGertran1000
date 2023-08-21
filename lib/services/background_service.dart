import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:apptestewillians/services/data_keeped.dart';
import 'package:apptestewillians/services/http_req.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';

import '../models/Login.dart';

class BackGroound {
  static Future<bool> verificarLocalizacaoAparelho() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      print('Permissão de localização negada pelo usuário.');
      // Aqui você pode exibir uma mensagem ao usuário solicitando permissão de localização.
      return false;
    } else if (permission == LocationPermission.deniedForever) {
      print('Permissão de localização negada permanentemente pelo usuário.');
      // Aqui você pode explicar ao usuário como habilitar manualmente as permissões nas configurações do dispositivo.
      return false;
    } else {
      // Geolocator.getCurrentPosition().then((value) {
      //   // ignore: avoid_print
      //   print(value);
      // });
      return true;
      // print('Permissão de localização concedida pelo usuário.');
      // Aqui você pode continuar com a lógica para obter a posição atual.
    }
  }

  static Future<void> initService() async {
    WidgetsFlutterBinding.ensureInitialized();

    final FlutterLocalNotificationsPlugin flutterLocalPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidNotificationChannel notificationChannel =
        AndroidNotificationChannel(
      "canal 1",
      "Gertran Monitoramento",
      description: "Aplicativo iniciado",
      importance: Importance.high,
    );
    var service = FlutterBackgroundService();

    await flutterLocalPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(notificationChannel);


    //set for ios
    if (Platform.isIOS) {
      await flutterLocalPlugin.initialize(
          const InitializationSettings(iOS: DarwinInitializationSettings()));
    }

    if (Platform.isAndroid) {
      await service.configure(
          iosConfiguration: IosConfiguration(
              onBackground: iosBackground, onForeground: onStart),
          androidConfiguration: AndroidConfiguration(
              onStart: onStart,
              autoStart: true,
              isForegroundMode: true,
              notificationChannelId: "canal 1",
              initialNotificationTitle: "Gertran Monitoramento",
              initialNotificationContent: "executando em segundo plano...",
              foregroundServiceNotificationId: 100));
    }

    if (Platform.isAndroid || Platform.isIOS) {
      service.startService();
    }
    // service init and start
  }

  //onstart method
  @pragma("vm:enry-point")
  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    service.on("setAsForeground").listen((event) {
      // print("foreground ===============");
    });

    service.on("setAsBackground").listen((event) {
      // print("background ===============");
    });

    service.on("stopService").listen((event) {
      service.stopSelf();
    });

    Timer.periodic(const Duration(minutes: 2), (timer) async {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        // print('Permissão de localização negada pelo usuário.');
        // Aqui você pode exibir uma mensagem ao usuário solicitando permissão de localização.
      } else if (permission == LocationPermission.deniedForever) {
        // print('Permissão de localização negada permanentemente pelo usuário.');
        // Aqui você pode explicar ao usuário como habilitar manualmente as permissões nas configurações do dispositivo.
      } else {
        Geolocator.getCurrentPosition().then((value) async {
          // ignore: avoid_print
          // print(value);

          DataKeeped dataKeeped = DataKeeped();

          HttpReq httpReq = HttpReq();

          String cpf = await dataKeeped.getToken('cpf');
          String senha = await dataKeeped.getToken('senha');
          Login l = await httpReq.fetchLogin(cpf , senha);

          String token = await dataKeeped.getToken("token");

          print(token);

          httpReq.fetchPosicion(
              '${value.latitude}', '${value.longitude}', token);
        });

        // print('Permissão de localização concedida pelo usuário.');
        // Aqui você pode continuar com a lógica para obter a posição atual.
      }
    });

    // print("Background service ${DateTime.now()}");
  }

//iosbackground
  @pragma("vm:enry-point")
  static Future<bool> iosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    return true;
  }

  static void stop() async {
    if (Platform.isAndroid || Platform.isIOS) {
      FlutterBackgroundService().invoke("stopService");
    }
  }

  static void back() async {
    if (Platform.isAndroid || Platform.isIOS) {
      FlutterBackgroundService().invoke("setAsBackground");
    }
  }

  static void start() {
    if (Platform.isAndroid || Platform.isIOS) {
      FlutterBackgroundService().startService();
    }
  }
}
