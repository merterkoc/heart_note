import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heart_note/core/bloc/theme_event.dart';
import 'package:heart_note/core/bloc/theme_state.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/bloc/theme_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _autoSave = false;

  @override
  void initState() {
    super.initState();
    _loadAutoSavePreference();
  }

  Future<void> _loadAutoSavePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _autoSave = prefs.getBool('autoSave') ?? false;
    });
  }

  Future<void> _setAutoSavePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autoSave', value);
    setState(() {
      _autoSave = value;
    });
  }

  Future<PackageInfo> _initPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Ayarlar'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            CupertinoListSection.insetGrouped(
              backgroundColor: CupertinoColors.transparent,
              header: const Text('Tema'),
              children: [
                BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, state) {
                    return CupertinoListTile(
                      title: const Text('Tema Seçimi'),
                      trailing: CupertinoSlidingSegmentedControl<ThemeMode>(
                        groupValue: state.themeMode,
                        children: const {
                          ThemeMode.light: Text('Aydınlık'),
                          ThemeMode.dark: Text('Karanlık'),
                          ThemeMode.system: Text('Sistem'),
                        },
                        onValueChanged: (ThemeMode? value) {
                          if (value != null) {
                            context.read<ThemeBloc>().add(
                                  ToggleTheme(
                                    value,
                                  ),
                                );
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              backgroundColor: CupertinoColors.transparent,
              header: const Text('Otomatik Kaydetme'),
              children: [
                CupertinoListTile(
                  title: const Text('Mesajları otomatik kaydet'),
                  trailing: CupertinoSwitch(
                    activeColor: CupertinoColors.destructiveRed,
                    value: _autoSave,
                    onChanged: (bool? value) {
                      if (value != null) {
                        _setAutoSavePreference(value);
                      }
                    },
                  ),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<PackageInfo>(
                  initialData: null,
                  future: _initPackageInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final packageInfo = snapshot.data!;
                      return Text(
                        'Versiyon: ${packageInfo.version} (Build ${packageInfo.buildNumber})',
                        style: const TextStyle(
                            color: CupertinoColors.secondaryLabel),
                        textAlign: TextAlign.center,
                      );
                    } else {
                      return const Text('Sürüm bilgisi alınıyor...');
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
