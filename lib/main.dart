import 'dart:async';
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_tracker_app/src/modules/carrier/presentation/cubit/carrier_cubit.dart';
import 'package:my_tracker_app/src/modules/profile/presentation/cubit/profile_cubit.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'firebase_options.dart';
import 'src/common/utils/app_environment.dart';
import 'src/common/utils/getit_utils.dart';
import 'src/core/data/local/storage.dart';
import 'src/modules/app/app_widget.dart';
import 'src/modules/auth/presentation/cubit/auth_cubit.dart';
import 'src/modules/notify/presentation/cubit/notify_cubit.dart';
import 'src/modules/notify/presentation/cubit/notify_state.dart';
import 'src/modules/tracking/presentation/cubit/tracking_cubit.dart';

// local notification plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Background message: ${message.notification?.title}');
}

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Init flutter local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // FCM setup
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);
    final token = await messaging.getToken();
    // debugPrint('Device FCM Token: $token');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // debugPrint('Foreground message: ${message.notification?.title}');

      //  Refresh NotifyCubit để lấy thông báo mới nhất từ API
      final notifyCubit = getIt<NotifyCubit>();
      await notifyCubit.loadNotifications();

      // Lấy state hiện tại
      final state = notifyCubit.state;
      if (state is NotifyLoaded && state.messages.isNotEmpty) {
        final latestNotify = state.messages.first; // mới nhất
        final msg = latestNotify.message;

        const AndroidNotificationDetails androidDetails =
            AndroidNotificationDetails(
          'your_channel_id',
          'Your Channel Name',
          channelDescription: 'description',
          importance: Importance.max,
          priority: Priority.high,
        );
        const NotificationDetails platformDetails =
            NotificationDetails(android: androidDetails);

        await flutterLocalNotificationsPlugin.show(
          0,
          'New Notification',
          msg,
          platformDetails,
        );
      }
    });

    // Khi user nhấn notification mở app
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('User click notification: ${message.notification?.title}');
    });

    // Init app env
    await AppEnvironment.setup();
    await Storage.setup();
    await GetItUtils.setup();

    final talker = getIt<Talker>();
    _setupErrorHooks(talker);

    Bloc.observer = TalkerBlocObserver(talker: talker);

    runApp(
      MultiBlocProvider(
        providers: [  
          BlocProvider.value(value: getIt<AuthCubit>()),
          BlocProvider.value(value: getIt<TrackingCubit>()),
          BlocProvider(create: (_) => getIt<CarrierCubit>()..getCarriers()),
          BlocProvider(
              create: (_) => getIt<NotifyCubit>()..loadNotifications()),
          BlocProvider(create: (_) => getIt<ProfileCubit>()),
        ],
        child: const AppWidget(),
      ),
    );

    configLoading();
  }, (error, stack) {
    getIt<Talker>().handle(error, stack);
  });
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2500)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.black
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..userInteractions = false
    ..maskType = EasyLoadingMaskType.black
    ..dismissOnTap = true;
}

Future _setupErrorHooks(Talker talker, {bool catchFlutterErrors = true}) async {
  if (catchFlutterErrors) {
    FlutterError.onError = (FlutterErrorDetails details) async {
      _reportError(details.exception, details.stack, talker);
    };
  }
  PlatformDispatcher.instance.onError = (error, stack) {
    _reportError(error, stack, talker);
    return true;
  };

  if (!kIsWeb) {
    Isolate.current.addErrorListener(RawReceivePort((dynamic pair) async {
      final isolateError = pair as List<dynamic>;
      _reportError(
        isolateError.first.toString(),
        isolateError.last.toString(),
        talker,
      );
    }).sendPort);
  }
}

void _reportError(dynamic error, dynamic stackTrace, Talker talker) async {
  talker.error('Unhandled Exception', error, stackTrace);
}
