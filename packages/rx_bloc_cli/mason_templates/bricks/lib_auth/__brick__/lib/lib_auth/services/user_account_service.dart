{{> licence.dart }}

import 'dart:developer';

import '../../assets.dart';
import '../../base/app/config/app_constants.dart';
import '../../base/models/errors/error_model.dart';
import '../../base/repositories/push_notification_repository.dart';
import '../../lib_permissions/services/permissions_service.dart';
import '../models/auth_token_model.dart';
import '../repositories/auth_repository.dart';{{#enable_social_login}}
import 'social_login_service.dart';{{/enable_social_login}}

class UserAccountService {
  UserAccountService(
    this._authRepository,
    this._pushSubscriptionRepository,
    this._permissionsService,{{#enable_social_login}}
    this._socialLoginService,{{/enable_social_login}}
  );

  final AuthRepository _authRepository;
  final PushNotificationRepository _pushSubscriptionRepository;
  final PermissionsService _permissionsService;{{#enable_social_login}}
  final SocialLoginService? _socialLoginService;{{/enable_social_login}}

  bool _logoutLocked = false;

  /// Checks the user credentials passed in [username] and [password].
  ///
  /// After successful login saves the auth `token` and `refresh token` to
  /// persistent storage and loads the user permissions.
  Future<void> login({
    required String username,
    required String password,
  }) async {
    if (username.isEmpty || password.isEmpty) {
      throw GenericErrorModel(I18nErrorKeys.wrongEmailOrPassword);
    }

    final authToken = await _authRepository.authenticate(
      email: username,
      password: password,
    );

    await _handleToken(authToken);
  }
{{#enable_social_login}}
  /// Authenticates user using social media service
  ///
  /// After successful login saves the auth `token` and `refresh token` to
  /// persistent storage and loads the user permissions.
  Future<void> socialLogin() async {
    if (_socialLoginService == null) {
      throw GenericErrorModel(I18nErrorKeys.unimplementedSocialLoginService);
    }

    final authToken = await _socialLoginService!.getSocialAuthentication();

    await _handleToken(authToken);
  }{{/enable_social_login}}

  /// After successful login saves the auth `token` and `refresh token` to
  /// persistent storage and loads the user permissions.
  Future<void> _handleToken(AuthTokenModel authToken) async {
    // Save response tokens
    await _authRepository.saveToken(authToken.token);
    await _authRepository.saveRefreshToken(authToken.refreshToken);

    // Subscribe user push token
    try {
      final pushToken =
          await _pushSubscriptionRepository.getToken(vapidKey: webVapidKey);
      if (pushToken != null) {
        await _pushSubscriptionRepository.subscribe(pushToken);
      }
    } catch (e) {
      log(e.toString());
    }

    // Load permissions
    await _permissionsService.load();
  }

  /// This method logs out the user and delete all stored auth token data.
  ///
  /// After logging out the user it reloads all permissions.
  Future<void> logout() async {
    if (!_logoutLocked) {
      _logoutLocked = true;

      // Unsubscribe user push token
      try {
        final pushToken =
            await _pushSubscriptionRepository.getToken(vapidKey: webVapidKey);
        if (pushToken != null) {
          await _pushSubscriptionRepository.unsubscribe(pushToken);
        }
      } catch (e) {
        log(e.toString());
      }

      // Perform user logout
      try {
        await _authRepository.logout();
      } catch (e) {
        log(e.toString());
      }
    }

    // Clear locally stored auth data
    await _authRepository.clearAuthData();

    // Reload user permissions
    try {
      await _permissionsService.load();
    } catch (e) {
      log(e.toString());
    }

    _logoutLocked = false;
  }
}
