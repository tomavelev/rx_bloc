import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    required this.error,
    required this.onTabRetry,
    Key? key,
  }) : super(key: key);

  final String error;
  final Function() onTabRetry;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(error),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onTabRetry,
            child: const Text('Try again'),
          ),
        ],
      );
}
