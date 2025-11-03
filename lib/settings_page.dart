import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  final String? initialGameRootPath;
  final String? initialSevenZipPath;
  final String? initialApiKey;
  final Map<String, String> skippedVersions;

  // ++ NUEVOS PARÁMETROS PARA GESTIONAR UE4SS Y CNS ++
  final bool isUe4ssInstalled;
  final bool isCnsCoreInstalled;
  final Future<bool> Function() onUninstallUE4SS;
  final Future<bool> Function() onUninstallCNS;
  final VoidCallback onDeleteAllNexusInfo;
  final VoidCallback onExtractModIds;
  final bool isDeveloperModeEnabled;
  // ++ FIN DE NUEVOS PARÁMETROS ++

  final Future<String?> Function() onSelectGamePath;
  final Future<String?> Function() onSelect7zipPath;
  final Future<String?> Function() onShowApiKeyDialog;
  final Future<void> Function() onManageSkippedVersions;
  final VoidCallback onShowLanguageDialog;
  final VoidCallback onShowAboutDialog;
  final VoidCallback onRunSelfHealing;
  final bool initialShowModTypeTags;
  final ValueChanged<bool> onShowModTypeTagsChanged;
  final VoidCallback onRunConflictPatcher;

  const SettingsPage({
    super.key,
    required this.initialGameRootPath,
    required this.initialSevenZipPath,
    required this.initialApiKey,
    required this.skippedVersions,
    
    // ++ AÑADIR NUEVOS PARÁMETROS AL CONSTRUCTOR ++
    required this.isUe4ssInstalled,
    required this.isCnsCoreInstalled,
    required this.onUninstallUE4SS,
    required this.onUninstallCNS,
    required this.onDeleteAllNexusInfo,
    required this.onExtractModIds,
    required this.isDeveloperModeEnabled,
    // ++ FIN DE CAMBIOS EN CONSTRUCTOR ++

    required this.onSelectGamePath,
    required this.onSelect7zipPath,
    required this.onShowApiKeyDialog,
    required this.onManageSkippedVersions,
    required this.onShowLanguageDialog,
    required this.onShowAboutDialog,
    required this.onRunSelfHealing,
    required this.initialShowModTypeTags,
    required this.onShowModTypeTagsChanged,
    required this.onRunConflictPatcher,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String? gameRootPath;
  late String? sevenZipPath;
  late String? apiKey;

  late bool isUe4ssInstalled;
  late bool isCnsCoreInstalled;
  late bool _showModTypeTags;

  @override
  void initState() {
    super.initState();
    gameRootPath = widget.initialGameRootPath;
    sevenZipPath = widget.initialSevenZipPath;
    apiKey = widget.initialApiKey;
    isUe4ssInstalled = widget.isUe4ssInstalled;
    isCnsCoreInstalled = widget.isCnsCoreInstalled;
    _showModTypeTags = widget.initialShowModTypeTags;
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
            leading: const Icon(Icons.translate_outlined),
            title: Text(l10n.settingsLanguage),
            subtitle: Text(l10n.settingsLanguageDesc),
            onTap: widget.onShowLanguageDialog,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.label_outline),
            title: Text(l10n.settingsShowModTagsTitle),
            subtitle: Text(l10n.settingsShowModTagsDesc),
            value: _showModTypeTags,
            onChanged: (bool newValue) {
              setState(() {
                _showModTypeTags = newValue;
              });
              widget.onShowModTypeTagsChanged(newValue);
            },
            activeColor: Colors.tealAccent,
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
            leading: const Icon(Icons.folder_zip_outlined),
            title: Text(l10n.settings7zipPath),
            subtitle: Text(sevenZipPath ?? l10n.settings7zipPathAuto),
            onTap: () async {
              final newPath = await widget.onSelect7zipPath();
              if (newPath != null) {
                setState(() => sevenZipPath = newPath);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.build_circle_outlined),
            title: Text(l10n.settingsRepairMods),
            subtitle: Text(l10n.settingsRepairModsDesc),
            onTap: widget.onRunSelfHealing,
          ),
          ListTile(
            leading: const Icon(Icons.electrical_services_outlined, color: Colors.orangeAccent),
            title: const Text("Ejecutar Patcher de Conflictos"), // Texto nuevo
            subtitle: const Text("Repara crasheos por Container_Id y Package_Id (requiere Python)"), // Texto nuevo
            onTap: widget.onRunConflictPatcher,
          ),
          
          // ++ NUEVA SECCIÓN PARA GESTIONAR COMPONENTES PRINCIPALES ++
          const Divider(),
          _SettingsSectionHeader(title: l10n.settingsCoreComponents),

          // ListTile para gestionar UE4SS
          ListTile(
            leading: const Icon(Icons.shape_line_outlined), // Ícono representativo
            title: const Text("UE4SS"),
            subtitle: Text(
              isUe4ssInstalled ? l10n.installedStatus : l10n.notInstalledStatus,
              style: TextStyle(color: isUe4ssInstalled ? Colors.greenAccent : Colors.grey),
            ),
            trailing: isUe4ssInstalled
                ? TextButton(
                    onPressed: () async {
                      final success = await widget.onUninstallUE4SS();
                      if (success && mounted) {
                        setState(() {
                          isUe4ssInstalled = false;
                        });
                      }
                    },
                    child: Text(l10n.uninstallButton, style: const TextStyle(color: Colors.redAccent)),
                  )
                : null,
          ),

          // ListTile para gestionar el Sistema CNS
          ListTile(
            leading: const Icon(Icons.memory_rounded), // Ícono representativo
            title: Text(l10n.cnsCoreSystem),
            subtitle: Text(
              isCnsCoreInstalled ? l10n.installedStatus : l10n.notInstalledStatus,
              style: TextStyle(color: isCnsCoreInstalled ? Colors.greenAccent : Colors.grey),
            ),
            trailing: isCnsCoreInstalled
                ? TextButton(
                    onPressed: () async {
                      final success = await widget.onUninstallCNS();
                      if (success && mounted) {
                        setState(() {
                          isCnsCoreInstalled = false;
                        });
                      }
                    },
                    child: Text(l10n.uninstallButton, style: const TextStyle(color: Colors.redAccent)),
                  )
                : null,
          ),
          // ++ FIN DE LA NUEVA SECCIÓN ++

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
          
          // ++ NEW SECTION FOR DEVELOPER OPTIONS ++
          if (widget.isDeveloperModeEnabled) ...[
            const Divider(),
            _SettingsSectionHeader(title: l10n.settingsDeveloperOptions),
            ListTile(
              leading: const Icon(Icons.delete_sweep_outlined, color: Colors.orangeAccent),
              title: Text(l10n.devDeleteNexusInfoTitle),
              subtitle: Text(l10n.devDeleteNexusInfoDesc),
              onTap: widget.onDeleteAllNexusInfo,
            ),
            ListTile(
              leading: const Icon(Icons.upload_file_outlined, color: Colors.lightBlueAccent),
              title: Text(l10n.devExtractIdsTitle),
              subtitle: Text(l10n.devExtractIdsDesc),
              onTap: widget.onExtractModIds,
            ),
          ]
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