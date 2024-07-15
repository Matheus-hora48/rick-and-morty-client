import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeText extends StatelessWidget {
  final String dateTimeString;

  const DateTimeText({
    super.key,
    required this.dateTimeString,
  });

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(dateTimeString);

    String formattedDateTime =
        DateFormat('dd/MM/yyyy hh:mm a').format(dateTime);

    return Text(
      formattedDateTime,
      style: Theme.of(context).textTheme.labelLarge,
    );
  }
}
