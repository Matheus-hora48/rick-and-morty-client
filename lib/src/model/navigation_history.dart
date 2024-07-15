class NavigationHistoryItem {
  final String screenName;
  final String route;
  final dynamic arguments;
  final String title;
  final String dateTime;

  NavigationHistoryItem({
    required this.screenName,
    required this.route,
    required this.title,
    required this.dateTime,
    this.arguments,
  });
}
