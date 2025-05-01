import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppLocalizations {
  final Locale locale;
  Map<String, String> _localizedStrings = {};

  AppLocalizations(this.locale);

  // Helper method to keep the code in the widgets concise
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  Future<bool> load() async {
    // Load the language JSON file from the "assets/languages" folder
    String jsonString = await rootBundle.loadString('assets/languages/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // This method will be called from every widget which needs a localized text
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}

// LocalizationsDelegate is a factory for a set of localized resources
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return ['en', 'ko', 'ja', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// 현재 설정된 언어 코드를 위한 Provider - 로컬 스토리지에 저장/불러오기
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(_loadSavedLocale());
  
  // 로컬 스토리지에서 저장된 로케일 불러오기
  static Locale _loadSavedLocale() {
    final settingsBox = Hive.box('settings');
    final languageCode = settingsBox.get('languageCode', defaultValue: 'ko');
    final countryCode = settingsBox.get('countryCode', defaultValue: 'KR');
    return Locale(languageCode, countryCode);
  }
  
  // 로케일 변경 및 저장
  void setLocale(Locale locale) {
    final settingsBox = Hive.box('settings');
    settingsBox.put('languageCode', locale.languageCode);
    settingsBox.put('countryCode', locale.countryCode);
    state = locale;
  }
  
  // 현재 언어 코드 및 국가 코드 조합 가져오기 (API 호출용)
  String get languageTag {
    return '${state.languageCode}-${state.countryCode ?? state.languageCode.toUpperCase()}';
  }
}

// 번역 Helper 확장
extension TranslateX on String {
  String tr(BuildContext context) {
    return AppLocalizations.of(context).translate(this);
  }
}