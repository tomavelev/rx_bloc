import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../base/app/config/app_config.dart';
import '../../base/app/config/environment_config.dart';
import '../../base/common_blocs/firebase_bloc.dart';
import '../ui_components/login_button.dart';
import '../ui_components/login_text.dart';

class FacebookLoginPage extends StatefulWidget {
  const FacebookLoginPage({Key? key}) : super(key: key);

  @override
  _FacebookLoginPageState createState() => _FacebookLoginPageState();
}

class _FacebookLoginPageState extends State<FacebookLoginPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoginText(text: context.l10n.reminders),
              const SizedBox(height: 5),
              LoginText(text: context.l10n.logIn),
              _buildFirebaseLogin(),
            ],
          ),
        ),
      );

  Widget _buildFirebaseLoginErrorListener() {
    return RxBlocListener<FirebaseBlocType, String>(
      state: (bloc) => bloc.states.errors,
      listener: (context, errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage ?? ''),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  Widget _buildFirebaseLogin() {
    var config = AppConfig.of(context)?.config;
    if (config?.environment == EnvironmentType.prod) {
      return RxBlocBuilder<FirebaseBlocType, bool>(
        state: (bloc) => bloc.states.loggedIn,
        builder: (context, snap, _) {
          if (snap.hasData && snap.data == true) {
            context.router.replace(const NavigationRoute());
          }
          return _buildButtonsArea(context);
        },
      );
    } else {
      return LoginButton(
        text: context.l10n.logInAsAnonymous,
        color: Colors.blueGrey,
        onPressed: () {
          context.router.replace(const NavigationRoute());
        },
      );
    }
  }

  Widget _buildButtonsArea(BuildContext context) => Column(
        children: [
          _buildFirebaseLoginErrorListener(),
          LoginButton(
            text: context.l10n.logInAsAnonymous,
            color: Colors.blueGrey,
            onPressed: () {
              context.read<FirebaseBlocType>().events.logIn(anonymous: true);
            },
          ),
          LoginButton(
            text: context.l10n.logInWithFacebook,
            color: Colors.blue,
            onPressed: () =>
                context.read<FirebaseBlocType>().events.logIn(anonymous: false),
          )
        ],
      );
}
