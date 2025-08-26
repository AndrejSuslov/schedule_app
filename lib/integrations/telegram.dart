import 'dart:async';
import 'dart:convert';
import 'dart:js_util' as jsu;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:js/js.dart';

class TelegramWebApp {
  TelegramWebApp._();

  static dynamic get _tg => jsu.getProperty(jsu.globalThis, 'Telegram');
  static dynamic get _webApp =>
      _tg != null ? jsu.getProperty(_tg, 'WebApp') : null;

  static bool get isAvailable => kIsWeb && _webApp != null;

  static String get version =>
      (isAvailable && jsu.hasProperty(_webApp, 'version'))
          ? (jsu.getProperty(_webApp, 'version')?.toString() ?? '0.0')
          : '0.0';

  static bool isVersionAtLeast(String min) {
    List<int> parse(String v) {
      final p = v.split('.');
      int a = p.isNotEmpty ? int.tryParse(p[0]) ?? 0 : 0;
      int b = p.length > 1 ? int.tryParse(p[1]) ?? 0 : 0;
      return [a, b];
    }

    final c = parse(version);
    final m = parse(min);
    return (c[0] > m[0]) || (c[0] == m[0] && c[1] >= m[1]);
  }

  static void ready() {
    if (isAvailable) {
      jsu.callMethod(_webApp, 'ready', const []);
    }
  }

  static void expand() {
    if (isAvailable && jsu.hasProperty(_webApp, 'expand')) {
      jsu.callMethod(_webApp, 'expand', const []);
    }
  }

  static String? get startParam {
    if (!isAvailable) return null;

    if (jsu.hasProperty(_webApp, 'startParam')) {
      final v = jsu.getProperty(_webApp, 'startParam');
      if (v is String && v.isNotEmpty) return v;
    }

    if (jsu.hasProperty(_webApp, 'initDataUnsafe')) {
      final idu = jsu.getProperty(_webApp, 'initDataUnsafe');
      if (jsu.hasProperty(idu, 'start_param')) {
        final v = jsu.getProperty(idu, 'start_param');
        if (v is String && v.isNotEmpty) return v;
      }
    }
    return null;
  }

  static dynamic get _themeParams =>
      (isAvailable && jsu.hasProperty(_webApp, 'themeParams'))
          ? jsu.getProperty(_webApp, 'themeParams')
          : null;

  static String? themeParam(String key) {
    if (_themeParams == null) return null;
    final v = jsu.getProperty(_themeParams, key);
    return v?.toString();
  }

  static bool get _hasCloudStorage =>
      isAvailable && jsu.hasProperty(_webApp, 'CloudStorage');

  static Future<void> cloudSetItem(String key, String value) async {
    if (!_hasCloudStorage) return;

    final completer = Completer<void>();
    final cs = jsu.getProperty(_webApp, 'CloudStorage');
    jsu.callMethod(cs, 'setItem', [
      key,
      value,
      allowInterop((Object? err, Object? ok) {
        if (err != null) {
          completer.completeError(err);
        } else {
          completer.complete();
        }
      })
    ]);
    return completer.future;
  }

  static Future<String?> cloudGetItem(String key) async {
    if (!_hasCloudStorage) return null;

    final completer = Completer<String?>();
    final cs = jsu.getProperty(_webApp, 'CloudStorage');
    jsu.callMethod(cs, 'getItem', [
      key,
      allowInterop((Object? err, Object? val) {
        if (err != null) {
          completer.completeError(err);
        } else {
          completer.complete(val?.toString());
        }
      })
    ]);
    return completer.future;
  }

  static bool get _hasDeviceStorage =>
      isAvailable && jsu.hasProperty(_webApp, 'DeviceStorage');

  static Future<void> deviceSetItem(String key, String value) async {
    if (_hasDeviceStorage) {
      final completer = Completer<void>();
      final ds = jsu.getProperty(_webApp, 'DeviceStorage');
      jsu.callMethod(ds, 'setItem', [
        key,
        value,
        allowInterop((Object? err, Object? ok) {
          if (err != null) {
            completer.completeError(err);
          } else {
            completer.complete();
          }
        })
      ]);
      await completer.future;
      return;
    }
    final box = await Hive.openBox<String>('twa_cache');
    await box.put(key, value);
  }

  static Future<String?> deviceGetItem(String key) async {
    if (_hasDeviceStorage) {
      final completer = Completer<String?>();
      final ds = jsu.getProperty(_webApp, 'DeviceStorage');
      jsu.callMethod(ds, 'getItem', [
        key,
        allowInterop((Object? err, Object? val) {
          if (err != null) {
            completer.completeError(err);
          } else {
            completer.complete(val?.toString());
          }
        })
      ]);
      return completer.future;
    }
    final box = await Hive.openBox<String>('twa_cache');
    return box.get(key);
  }

  static Future<void> deviceRemoveItem(String key) async {
    if (_hasDeviceStorage) {
      final completer = Completer<void>();
      final ds = jsu.getProperty(_webApp, 'DeviceStorage');
      jsu.callMethod(ds, 'removeItem', [
        key,
        allowInterop((Object? err, Object? ok) {
          if (err != null) {
            completer.completeError(err);
          } else {
            completer.complete();
          }
        })
      ]);
      await completer.future;
      return;
    }
    final box = await Hive.openBox<String>('twa_cache');
    await box.delete(key);
  }

  static Future<void> saveScheduleJson({
    required String key,
    required Map<String, dynamic> json,
  }) async {
    await deviceSetItem(key, jsonEncode(json));
    await cloudSetItem('current_schedule_key', key);
  }

  static Future<Map<String, dynamic>?> loadScheduleJson(String key) async {
    final raw = await deviceGetItem(key);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<void> init() async {
    if (!kIsWeb) return;
    try {
      await Hive.initFlutter();
    } catch (_) {
    }
    if (isAvailable) {
      ready();
      expand();
    }
  }
}
