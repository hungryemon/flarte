import 'dart:ui';

import 'package:flarte/api.dart';
import 'package:flarte/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class FlarteSettings extends StatefulWidget {
  const FlarteSettings({
    super.key,
  });

  @override
  State<FlarteSettings> createState() => _FlarteSettingsState();
}

class _FlarteSettingsState extends State<FlarteSettings> {
  PlayerTypeName _playerTypeName = AppConfig.player;
  late String _playerString;
  late String _qualityString;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _setPlayerString() {
    if (_playerTypeName == PlayerTypeName.custom) {
      _playerString = AppLocalizations.of(context)!.strCustom;
    } else if (_playerTypeName == PlayerTypeName.vlc) {
      _playerString = 'vlc';
    } else if (_playerTypeName == PlayerTypeName.embedded) {
      _playerString = AppLocalizations.of(context)!.strEmbedded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode =
        Provider.of<ThemeModeProvider>(context, listen: false).themeMode;
    String tm = '';
    if (themeMode == ThemeMode.dark) {
      tm = AppLocalizations.of(context)!.strDark;
    } else if (themeMode == ThemeMode.light) {
      tm = AppLocalizations.of(context)!.strLight;
    } else {
      tm = AppLocalizations.of(context)!.strSystem;
    }

    final Map<String, String> localeName = {
      'fr': AppLocalizations.of(context)!.strFrench,
      'de': AppLocalizations.of(context)!.strGerman,
      'en': AppLocalizations.of(context)!.strEnglish,
    };
    Locale? locale = Provider.of<LocaleModel>(context, listen: false).locale;

    _setPlayerString();

    final _qualityStringList = [
      'usually 216p',
      'usually 360p',
      'usually 432p',
      'usually 720p',
      'usually 1080p'
    ];

    int _qualityIndex = AppConfig.playerIndexQuality;
    _qualityString = _qualityStringList[_qualityIndex];

    debugPrint(AppLocalizations.supportedLocales.toString());
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.strSettings)),
      body: SettingsList(sections: [
        SettingsSection(
            title: Text(AppLocalizations.of(context)!.strInterface),
            tiles: [
              SettingsTile.navigation(
                leading: const Icon(Icons.language),
                title: Text(AppLocalizations.of(context)!.strLanguage),
                value: locale != null &&
                        localeName.keys.contains(locale.languageCode)
                    ? Text(localeName[locale.languageCode]!)
                    : Text(AppLocalizations.of(context)!.strSystem),
                onPressed: (context) async {
                  // test
                  await showDialog<ThemeMode>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(content:
                            StatefulBuilder(builder: (context, setState) {
                          return Column(
                              mainAxisSize: MainAxisSize.min,
                              children:
                                  AppLocalizations.supportedLocales.map((l) {
                                return ListTile(
                                    title: Text(localeName[l.languageCode]!),
                                    leading: Radio<Locale>(
                                      value: l,
                                      groupValue: locale,
                                      onChanged: (value) {
                                        setState(() {
                                          locale = value!;
                                        });
                                      },
                                    ));
                              }).toList());
                        }));
                      });
                  Provider.of<LocaleModel>(context, listen: false)
                      .changeLocale(locale);
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.nightlight),
                title: Text(AppLocalizations.of(context)!.strTheme),
                value: Text(tm),
                onPressed: (context) async {
                  ThemeMode themeMode =
                      Provider.of<ThemeModeProvider>(context, listen: false)
                          .themeMode;
                  await showDialog<ThemeMode>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(content:
                            StatefulBuilder(builder: (context, setState) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                  title: Text(
                                      AppLocalizations.of(context)!.strDark),
                                  leading: Radio<ThemeMode>(
                                    value: ThemeMode.dark,
                                    groupValue: themeMode,
                                    onChanged: (value) {
                                      setState(() {
                                        themeMode = value!;
                                      });
                                    },
                                  )),
                              ListTile(
                                  title: Text(
                                      AppLocalizations.of(context)!.strLight),
                                  leading: Radio<ThemeMode>(
                                    value: ThemeMode.light,
                                    groupValue: themeMode,
                                    onChanged: (value) {
                                      setState(() {
                                        themeMode = value!;
                                      });
                                    },
                                  )),
                              ListTile(
                                  title: Text(
                                      AppLocalizations.of(context)!.strSystem),
                                  leading: Radio<ThemeMode>(
                                    value: ThemeMode.system,
                                    groupValue: themeMode,
                                    onChanged: (value) {
                                      setState(() {
                                        themeMode = value!;
                                      });
                                    },
                                  )),
                            ],
                          );
                        }));
                      });
                  Provider.of<ThemeModeProvider>(context, listen: false)
                      .changeTheme(themeMode);
                },
              )
            ]),
        SettingsSection(
            title: Text(AppLocalizations.of(context)!.strPlayback),
            tiles: [
              SettingsTile.navigation(
                leading: const Icon(Icons.width_normal),
                title: Text(AppLocalizations.of(context)!.strDefRes),
                value: Text(_qualityStringList[AppConfig.playerIndexQuality]
                    .split(' ')
                    .last),
                onPressed: (context) async {
                  await showDialog<ThemeMode>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(content:
                            StatefulBuilder(builder: (context, setState) {
                          return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: _qualityStringList.map((p) {
                                return ListTile(
                                    title: Text(p),
                                    leading: Radio<int>(
                                      value: _qualityStringList.indexOf(p),
                                      groupValue: _qualityIndex,
                                      onChanged: (value) {
                                        setState(() {
                                          _qualityIndex = value!;
                                        });
                                      },
                                    ));
                              }).toList());
                        }));
                      });
                  setState(() {
                    _qualityString = _qualityStringList[_qualityIndex];
                  });
                  AppConfig.playerIndexQuality = _qualityIndex;
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.play_arrow),
                title: Text(AppLocalizations.of(context)!.strPlayer),
                value: Text(_playerString),
                onPressed: (context) async {
                  await showDialog<ThemeMode>(
                      context: context,
                      builder: (context) {
                        final ptn = {
                          PlayerTypeName.embedded:
                              AppLocalizations.of(context)!.strEmbedded,
                          PlayerTypeName.vlc: 'vlc',
                          PlayerTypeName.custom:
                              AppLocalizations.of(context)!.strCustom
                        };
                        return AlertDialog(content:
                            StatefulBuilder(builder: (context, setState) {
                          return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: ptn.entries.map((p) {
                                return ListTile(
                                    title: Text(p.value),
                                    leading: Radio<PlayerTypeName>(
                                      value: p.key,
                                      groupValue: _playerTypeName,
                                      onChanged: (value) {
                                        setState(() {
                                          _playerTypeName = value!;
                                        });
                                      },
                                    ));
                              }).toList());
                        }));
                      });
                  setState(() {
                    _setPlayerString();
                  });
                  AppConfig.player = _playerTypeName;
                },
              ),
            ]),
        SettingsSection(
            title: Text(AppLocalizations.of(context)!.strDownloads),
            tiles: [
              SettingsTile(
                  leading: const Icon(Icons.download),
                  title: Text(AppLocalizations.of(context)!.strDirectory)),
            ])
      ]),
    );
  }
}
