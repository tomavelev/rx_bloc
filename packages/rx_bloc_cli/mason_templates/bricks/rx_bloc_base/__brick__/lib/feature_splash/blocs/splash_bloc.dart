{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../../lib_auth/services/auth_service.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../services/splash_service.dart';

part 'splash_bloc.rxb.g.dart';

/// A contract class containing all events of the SplashBloC.
abstract class SplashBlocEvents {
  /// The event is called when the app is initialized.
  void initializeApp();
}

/// A contract class containing all states of the SplashBloC.
abstract class SplashBlocStates {
  /// The state which group and handle all the loading streams executed in the
  /// BloC.
  Stream<bool> get isLoading;

  /// The state which group and handle all the error streams executed in the
  /// BloC.
  ///
  /// The state is `null` when `isLoading` state is `true`
  ConnectableStream<ErrorModel?> get errors;
}

@RxBloc()
class SplashBloc extends $SplashBloc {
  SplashBloc(
    RouterBlocType navigationBloc,
    SplashService splashService,
    AuthService authService, {
    String? redirectLocation,
  })  : _navigationBloc = navigationBloc,
        _splashService = splashService,
        _authService = authService,
        _redirectLocation = redirectLocation {
    errors.connect().addTo(_compositeSubscription);
    _$initializeAppEvent
        .throttleTime(const Duration(seconds: 1))
        .startWith(null)
        .switchMap((_) => initializeAppAndNavigate().asResultStream())
        .setResultStateHandler(this)
        .publishReplay(maxSize: 1)
        .connect()
        .addTo(_compositeSubscription);
  }

  final RouterBlocType _navigationBloc;
  final SplashService _splashService;
  final AuthService _authService;
  final String? _redirectLocation;

  Future<void> initializeAppAndNavigate() async {
    await _splashService.initializeApp();

    if (_redirectLocation != null) {
      _navigationBloc.events.goToLocation(_redirectLocation!);
    } else {
      await _authService.isAuthenticated()
          ? _navigationBloc.events.go(const DashboardRoute())
          : _navigationBloc.events.go(const LoginRoute());
    }
  }

  @override
  ConnectableStream<ErrorModel?> _mapToErrorsState() => Rx.merge([
        errorState.mapToErrorModel(),
        loadingState.where((loading) => loading).map((_) => null),
      ]).publish();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;
}
