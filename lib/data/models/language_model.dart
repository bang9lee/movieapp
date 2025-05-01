import 'package:flutter/material.dart';

class LanguageModel {
  final String code;
  final String name;
  final String languageCode;
  final String? countryCode;
  final String flag;

  const LanguageModel({
    required this.code,
    required this.name,
    required this.languageCode,
    this.countryCode,
    required this.flag,
  });

  Locale toLocale() {
    return countryCode != null 
        ? Locale(languageCode, countryCode) 
        : Locale(languageCode);
  }

  static const List<LanguageModel> supportedLanguages = [
    LanguageModel(
      code: 'ko_KR',
      name: '한국어',
      languageCode: 'ko',
      countryCode: 'KR',
      flag: '🇰🇷',
    ),
    LanguageModel(
      code: 'en_US',
      name: 'English',
      languageCode: 'en',
      countryCode: 'US',
      flag: '🇺🇸',
    ),
    LanguageModel(
      code: 'ja_JP',
      name: '日本語',
      languageCode: 'ja',
      countryCode: 'JP',
      flag: '🇯🇵',
    ),
    LanguageModel(
      code: 'zh_CN',
      name: '中文',
      languageCode: 'zh',
      countryCode: 'CN',
      flag: '🇨🇳',
    ),
  ];

  static LanguageModel fromLocale(Locale locale) {
    return supportedLanguages.firstWhere(
      (language) => language.languageCode == locale.languageCode,
      orElse: () => supportedLanguages.first, // 기본값으로 한국어 반환
    );
  }
}