{{> licence.dart }}

import 'package:flutter/material.dart';

import '../../app_extensions.dart';
import '../extensions/error_model_translations.dart';
import '../models/errors/error_model.dart';
import 'primary_button.dart';

class AppErrorCardComponent extends StatelessWidget {
  const AppErrorCardComponent({
    required this.error,
    required this.onTabRetry,
    Key? key,
  }) : super(key: key);

  final Exception error;
  final Function() onTabRetry;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text((error as ErrorModel).translate(context)),
      SizedBox(height: context.designSystem.spacing.l),
      PrimaryButton(
        onPressed: onTabRetry,
        child: Text(context.l10n.tryAgain),
      ),
    ],
  );
}
