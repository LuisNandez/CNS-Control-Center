import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';
import '../theme/ios_theme.dart';
import '../widgets/ios_widgets.dart';

/// Alertas de vidrio del flujo de instalación que necesitan algo más que
/// "Cancelar / Aceptar" (para esas, usa SettingsDialogs.confirm / info).
class InstallDialogs {
  InstallDialogs._();

  /// 7-Zip no encontrado. [onVerify] vuelve a buscarlo y devuelve true si ya
  /// está disponible. Devuelve true si se resolvió, false si se cancela.
  static Future<bool> sevenZipRequired(
    BuildContext context, {
    required Future<bool> Function() onVerify,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    bool notFound = false;

    final result = await showIosDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setS) {
          return IosDialogShell(
            title: l10n.dialogTitle7zip,
            width: 460,
            content: Text(
              notFound ? l10n.dialogContent7zipNotFound : l10n.dialogContent7zip,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.3,
                color: notFound ? IosColors.red : IosColors.secondaryLabel,
              ),
            ),
            actions: [
              IosDialogButton(
                label: l10n.dialogActionCancel,
                onPressed: () => Navigator.of(dialogContext).pop(false),
              ),
              IosDialogButton(
                label: l10n.dialogActionGoToDownload,
                onPressed: () => launchUrl(Uri.parse('https://www.7-zip.org/')),
              ),
              IosDialogButton(
                label: l10n.dialogActionConfirmInstallation,
                bold: true,
                onPressed: () async {
                  final ok = await onVerify();
                  if (!dialogContext.mounted) return;
                  if (ok) {
                    Navigator.of(dialogContext).pop(true);
                  } else {
                    setS(() => notFound = true);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
    return result == true;
  }

  /// Aviso de que CNS necesita UE4SS, con enlace a la descarga.
  static Future<void> ue4ssRequired(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const url = 'https://github.com/Chrisr0/RE-UE4SS/releases';

    return showIosDialog<void>(
      context: context,
      builder: (ctx) => IosDialogShell(
        title: l10n.ue4ssRequiredTitle,
        message: l10n.ue4ssRequiredContent,
        width: 400,
        content: Center(
          child: IosTextButton(
            label: url,
            fontSize: 12.5,
            onPressed: () => launchUrl(Uri.parse(url)),
          ),
        ),
        actions: [
          IosDialogButton(
            label: l10n.dialogActionClose,
            bold: true,
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }
}