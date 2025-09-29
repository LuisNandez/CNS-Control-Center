// notification_service.dart

import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

// Definimos los tipos de notificación para darles diferentes colores e iconos.
enum NotificationType { success, info, error, neutral }

class NotificationService {
  // Usamos un patrón Singleton para tener una única instancia del servicio en toda la app.
  NotificationService._privateConstructor();
  static final NotificationService instance = NotificationService._privateConstructor();

  void show({
    required BuildContext context,
    required NotificationType type,
    required String title,
    String? description,
  }) {
    // El ícono y color cambian según el tipo de notificación.
    IconData icon;
    Color color;

    switch (type) {
      case NotificationType.success:
        icon = Icons.check_circle_outline_rounded;
        color = Colors.green.shade400;
        break;
      case NotificationType.info:
        icon = Icons.info_outline_rounded;
        color = Colors.orange.shade400;
        break;
      case NotificationType.error:
        icon = Icons.error_outline_rounded;
        color = Colors.red.shade400;
        break;
      case NotificationType.neutral:
        icon = Icons.error_outline_rounded;
        color = Colors.blueGrey.shade400;
        break;
    }

    toastification.show(
      context: context,
      title: Text(title),
      description: description != null ? Text(description) : null,
      
      // --- CONFIGURACIÓN CORREGIDA ---
      alignment: Alignment.bottomRight,
      // Límite de notificaciones visibles a la vez
      //      limit: 5, // <-- Usar 'limit' si tu versión de toastification lo soporta
      // Estilo moderno
      style: ToastificationStyle.flat, // <-- CORREGIDO: 'fill' ahora es 'flat'
      // --- FIN DE LA CORRECCIÓN ---
      
      autoCloseDuration: const Duration(seconds: 5),
      backgroundColor: const Color(0xFF2d2d2d),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16.0,
          offset: Offset(0, 16.0),
          spreadRadius: 0.0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      icon: Icon(icon, color: color),
      primaryColor: color,
    );
  }
}