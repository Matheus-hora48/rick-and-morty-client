import 'package:flutter/material.dart';

class RickAndMortyAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final BuildContext context;

  const RickAndMortyAppBar({
    super.key,
    required this.title,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    bool canPop = Navigator.of(context).canPop();

    return AppBar(
      toolbarHeight: 64,
      backgroundColor: Theme.of(context).colorScheme.primary,
      centerTitle: true,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: Colors.white),
          ),
        ],
      ),
      leading: canPop
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : Image.asset('assets/imgs/icon_header.png'),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
