import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

class LocalAuth {
  static final _auth = LocalAuthentication();

  static Future<bool> _canAuthenticate() async =>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  static Future<bool> authenticate() async {
    try {
      if (!await _canAuthenticate()) return false;

      return await _auth.authenticate(
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Sign in',
            cancelButton: 'No thanks',
          ),
          IOSAuthMessages(
            lockOut: 'No thanks',
          ),
        ],
        localizedReason: 'Use Face ID/Touch ID to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } catch (e) {
      debugPrint('Error: $e');
      return false;
    }
  }
}
