import 'package:flutter/material.dart';

class MyBottomSheet extends StatelessWidget {
  const MyBottomSheet({Key? key, required this.title, required this.content})
      : super(key: key);

  final String title;
  final List<Widget> content;

  // TODO: Maybe no need to this widget seperately

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          ...content
        ],
      ),
    );
  }
}
