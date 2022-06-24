import 'package:flutter/material.dart';
import 'package:gas_provider/screens/settings/widgets/main_settings.dart';
import 'package:gas_provider/screens/settings/widgets/other_settings.dart';
import 'package:gas_provider/screens/settings/widgets/settings_profile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: const [
        SettingsProfile(),
        Divider(),
        MainSettings(),
        Divider(),
        OtherSettings(),
      ]),
    );
  }
}
