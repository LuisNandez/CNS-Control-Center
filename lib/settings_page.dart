import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  final String? initialGameRootPath;
  final String? initialSevenZipPath;
  final String? initialApiKey;
  final Map<String, String> skippedVersions;

  final Future<String?> Function() onSelectGamePath;
  final Future<String?> Function() onSelect7zipPath;
  final Future<String?> Function() onShowApiKeyDialog;
  final Future<void> Function() onManageSkippedVersions;
  final VoidCallback onShowLanguageDialog;
  final VoidCallback onShowAboutDialog;

  const SettingsPage({
    super.key,
    required this.initialGameRootPath,
    required this.initialSevenZipPath,
    required this.initialApiKey,
    required this.skippedVersions,
    required this.onSelectGamePath,
    required this.onSelect7zipPath,
    required this.onShowApiKeyDialog,
    required this.onManageSkippedVersions,
    required this.onShowLanguageDialog,
    required this.onShowAboutDialog,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String? gameRootPath;
  late String? sevenZipPath;
  late String? apiKey;

  @override
  void initState() {
    super.initState();
    gameRootPath = widget.initialGameRootPath;
    sevenZipPath = widget.initialSevenZipPath;
    apiKey = widget.initialApiKey;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool isApiKeySet = apiKey != null && apiKey!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: const Color(0xFF2a2a2a),
      ),
      body: ListView(
        children: [
          _SettingsSectionHeader(title: l10n.settingsGeneral),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(l10n.settingsLanguage),
            subtitle: Text(l10n.settingsLanguageDesc),
            onTap: widget.onShowLanguageDialog,
          ),
          const Divider(),
          _SettingsSectionHeader(title: l10n.settingsPathsAndTools),
          ListTile(
            leading: const Icon(Icons.folder_copy_outlined),
            title: Text(l10n.settingsGameFolder),
            subtitle: Text(gameRootPath ?? l10n.settingsApiKeyNotSet),
            onTap: () async {
              final newPath = await widget.onSelectGamePath();
              if (newPath != null) {
                setState(() => gameRootPath = newPath);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.archive_outlined),
            title: Text(l10n.settings7zipPath),
            subtitle: Text(sevenZipPath ?? l10n.settings7zipPathAuto),
            onTap: () async {
              final newPath = await widget.onSelect7zipPath();
              if (newPath != null) {
                setState(() => sevenZipPath = newPath);
              }
            },
          ),
          const Divider(),
          _SettingsSectionHeader(title: l10n.settingsConnectivity),
          ListTile(
            leading: const Icon(Icons.vpn_key_outlined),
            title: Text(l10n.settingsApiKey),
            subtitle: Text(
              isApiKeySet ? l10n.settingsApiKeySet : l10n.settingsApiKeyNotSet,
              style: TextStyle(
                color: isApiKeySet ? Colors.greenAccent : Colors.orangeAccent,
              ),
            ),
            onTap: () async {
              final newKey = await widget.onShowApiKeyDialog();
              // --- ESTA ES LA LÍNEA CORREGIDA ---
              // Solo actualiza el estado si el usuario no canceló (newKey no es nulo).
              if (newKey != null) {
                setState(() => apiKey = newKey);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.skip_next_outlined),
            title: Text(l10n.settingsSkippedVersions),
            subtitle:
                Text(l10n.settingsSkippedVersionsCount(widget.skippedVersions.length)),
            onTap: () async {
              await widget.onManageSkippedVersions();
              // Forzar actualización para reflejar el conteo
              setState(() {});
            },
          ),
          const Divider(),
           ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.settingsAbout),
            subtitle: Text(l10n.settingsAboutDesc),
            onTap: widget.onShowAboutDialog,
          ),
        ],
      ),
    );
  }
}

class _SettingsSectionHeader extends StatelessWidget {
  final String title;

  const _SettingsSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}