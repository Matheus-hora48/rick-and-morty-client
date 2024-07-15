import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:rick_and_morty_client/src/core/ui/helpers/datetime_text.dart';
import 'package:rick_and_morty_client/src/core/ui/widget/rick_and_morty_app_bar.dart';
import 'package:rick_and_morty_client/src/model/character_model.dart';
import 'package:rick_and_morty_client/src/model/episode_model.dart';
import 'package:rick_and_morty_client/src/model/location_model.dart';
import 'package:rick_and_morty_client/src/model/origin_model.dart';
import 'package:rick_and_morty_client/src/pages/episode_detail/episode_detail_page.dart';
import 'package:rick_and_morty_client/src/pages/character_datail/character_datail_page.dart';
import 'package:rick_and_morty_client/src/pages/main/main_controller.dart';
import 'dart:convert';

import 'package:rick_and_morty_client/src/pages/origin/origin_page.dart';

class NavigationHistoryPage extends StatelessWidget {
  final Function(int) navigateToTab;
  final Function(int, Widget, dynamic) navigateToTabWithDetail;
  final MainController controller;

  const NavigationHistoryPage({
    super.key,
    required this.navigateToTab,
    required this.navigateToTabWithDetail,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RickAndMortyAppBar(
        title: 'Histórico de navegação',
        context: context,
        action: IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
          onPressed: () async {
            await controller.clearHistory();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Observer(
          builder: (_) {
            final historyFuture = controller.historyFuture;

            if (historyFuture == null ||
                historyFuture.status == FutureStatus.pending) {
              return const Center(child: CircularProgressIndicator());
            }
            if (historyFuture.status == FutureStatus.rejected ||
                historyFuture.value == null ||
                historyFuture.value!.isEmpty) {
              return const Center(child: Text('Nenhum histórico disponível.'));
            }
            final historyItems = historyFuture.value!;
            return ListView.separated(
              itemCount: historyItems.length,
              separatorBuilder: (context, index) => const SizedBox(
                height: 16,
              ),
              itemBuilder: (context, index) {
                final item = historyItems[index];
                return ListTile(
                  title: Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.screenName,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      DateTimeText(dateTimeString: item.dateTime),
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onTap: () {
                    final arguments = item.arguments != null
                        ? jsonDecode(item.arguments)
                        : null;
                    switch (item.screenName) {
                      case 'EpisodesPage':
                        navigateToTab(1);
                        break;
                      case 'CharacterPage':
                        navigateToTab(2);
                        break;
                      case 'EpisodesPageDetail':
                        final episode = EpisodeModel.fromJson(
                          arguments as Map<String, dynamic>,
                        );
                        navigateToTabWithDetail(
                          1,
                          const EpisodeDetailPage(),
                          episode,
                        );
                        break;
                      case 'CharacterPageDetail':
                        final character = CharacterModel.fromJson(
                          arguments as Map<String, dynamic>,
                        );
                        navigateToTabWithDetail(
                          2,
                          const CharacterDetailPage(),
                          character,
                        );
                        break;
                      case 'OriginPage':
                        final character = OriginModel.fromJson(
                          arguments as Map<String, dynamic>,
                        );
                        navigateToTabWithDetail(
                          3,
                          const OriginPage(),
                          character,
                        );
                        break;
                      case 'LocationPage':
                        final character = LocationModel.fromJson(
                          arguments as Map<String, dynamic>,
                        );
                        navigateToTabWithDetail(
                          3,
                          const OriginPage(),
                          character,
                        );
                        break;
                      default:
                        navigateToTab(0);
                        break;
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
