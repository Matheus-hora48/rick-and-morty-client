import 'package:flutter/material.dart';

class LabelWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool underline;

  const LabelWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.underline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Theme.of(context).colorScheme.secondary),
        ),
        const SizedBox(
          width: 16,
        ),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                decoration:
                    underline ? TextDecoration.underline : TextDecoration.none,
              ),
        ),
      ],
    );
  }
}
