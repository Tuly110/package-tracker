import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'getit_utils.dart';

@module
abstract class LoggerModule {
  @singleton
  Talker talker() => TalkerFlutter.init(
        settings: TalkerSettings(
          useConsoleLogs: kDebugMode,
          colors: {
            TalkerLogType.debug.toString(): AnsiPen()..green(),
            TalkerLogType.warning.toString(): AnsiPen()..yellow(bold: true),
            TalkerLogType.error.toString(): AnsiPen()..red(bold: true)
          },
        ),
      );

  @singleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @lazySingleton
  GoogleSignIn get googleSignIn => GoogleSignIn(
        serverClientId:
            '912090799696-o63a4dqk9q48e7n1p2cjv1vbu1vreo7d.apps.googleusercontent.com',
        scopes: [
          'email',
        ],
      );
}

final logger = _Logger(getIt<Talker>());

class _Logger {
  final Talker talker;
  _Logger(this.talker);

  // White text
  d(
    dynamic msg, {
    Object? exception,
    StackTrace? stackTrace,
  }) =>
      talker.debug(msg, exception, stackTrace);

  // Blue text
  i(
    dynamic msg, {
    Object? exception,
    StackTrace? stackTrace,
  }) =>
      talker.info(msg, exception, stackTrace);

  // Yellow text
  w(
    dynamic msg, {
    Object? exception,
    StackTrace? stackTrace,
  }) =>
      talker.warning(msg, exception, stackTrace);

  // Red text
  e(
    dynamic msg, {
    Object? exception,
    StackTrace? stackTrace,
  }) =>
      talker.error(msg, exception, stackTrace);
}
