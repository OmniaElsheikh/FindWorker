import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class LocalizationService {
  late final Locale locale;
  static late Locale currentLanguage;
  LocalizationService(this.locale){
    currentLanguage =locale;
  }
  static LocalizationService of(BuildContext context){
    return Localizations.of(context, LocalizationService);
  }
  late Map<String,String> _localizedString;
  Future<void> load() async{
    final jsonString = await rootBundle.loadString('images/translations/${locale.languageCode}.json');
    Map<String,dynamic> jsonMap=jsonDecode(jsonString);
    _localizedString=jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  String? translate(String key){
    return _localizedString[key];
  }

  static const supportedLocales =[
    Locale('ar',''),
    Locale('en','')
  ];

  static Locale? localeResolutionCallBack(Locale? locale,Iterable<Locale?> supportedLocales){
    if(supportedLocales != null && locale !=null){
      return supportedLocales.firstWhere((element) => element?.languageCode==locale.languageCode,
          orElse: ()=> supportedLocales.first );
    }
    return null;
  }

  static const LocalizationsDelegate<LocalizationService> _delegate =_LocalizationServiceDelegate();

  static const Iterable<LocalizationsDelegate<dynamic>> localizationsDelegate=[
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    _delegate
  ];


}

class _LocalizationServiceDelegate extends LocalizationsDelegate<LocalizationService>{
  const _LocalizationServiceDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ar','en'].contains(locale.languageCode);
  }

  @override
  Future<LocalizationService> load(Locale locale) async {
    LocalizationService service=LocalizationService(locale);
    await service.load();
    return service;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<LocalizationService> old) {
    return false;
  }}




class LocalizationController extends GetxController{
  String currentLanguage =''.obs.toString();
  void toggleLanguge()async{
    currentLanguage=LocalizationService.currentLanguage.languageCode =='ar'?'en':'ar';
    print(currentLanguage);
    update();
  }

}