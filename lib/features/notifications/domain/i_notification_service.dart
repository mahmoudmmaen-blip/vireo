import 'package:vireo/features/notifications/domain/notification_settings.dart';
import 'package:vireo/features/notifications/domain/notification_type.dart';

abstract interface class INotificationService {
  Future<void> initialize();

  Future<void> scheduleAll(NotificationSettings settings);

  Future<void> cancelAll();

  Future<void> cancelType(NotificationType type);

  Future<void> showInstant(String title, String body, NotificationType type);

  Future<bool> requestPermission();

  Future<bool> hasPermission();
}
