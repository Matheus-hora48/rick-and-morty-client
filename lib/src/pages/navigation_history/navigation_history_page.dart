import 'package:flutter/material.dart';
import 'package:rick_and_morty_client/src/core/ui/helpers/datetime_text.dart';
import 'package:rick_and_morty_client/src/core/ui/widget/rick_and_morty_app_bar.dart';
import 'package:rick_and_morty_client/src/db/database_history_helper.dart';
import 'package:rick_and_morty_client/src/model/character_model.dart';
import 'package:rick_and_morty_client/src/model/episode_model.dart';
import 'package:rick_and_morty_client/src/model/location_model.dart';
import 'package:rick_and_morty_client/src/model/navigation_history.dart';
import 'package:rick_and_morty_client/src/model/origin_model.dart';
import 'package:rick_and_morty_client/src/pages/episode_detail/episode_detail_page.dart';
import 'package:rick_and_morty_client/src/pages/character_datail/character_datail_page.dart';
import 'dart:convert';

import 'package:rick_and_morty_client/src/pages/origin/origin_page.dart';

class NavigationHistoryPage extends StatefulWidget {
  final Function(int) navigateToTab;
  final Function(int, Widget, dynamic) navigateToTabWithDetail;

  const NavigationHistoryPage({
    super.key,
    required this.navigateToTab,
    required this.navigateToTabWithDetail,
  });

  @override
  State<NavigationHistoryPage> createState() => _NavigationHistoryPageState();
}

class _NavigationHistoryPageState extends State<NavigationHistoryPage> {
  final DatabaseHistoryHelper historyHelper = DatabaseHistoryHelper();
  late Future<List<NavigationHistoryItem>> historyFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    historyFuture = historyHelper.getHistory();
  }

  Future<void> _refreshHistory() async {
    setState(() {
      historyFuture = historyHelper.getHistory();
    });
  }

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
            await historyHelper.clearHistory();
            _refreshHistory();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<NavigationHistoryItem>>(
          future: historyFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhum histórico disponível.'));
            }
            final historyItems = snapshot.data!;
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
                        widget.navigateToTab(1);
                        break;
                      case 'CharacterPage':
                        widget.navigateToTab(2);
                        break;
                      case 'EpisodesPageDetail':
                        final episode = EpisodeModel.fromJson(
                          arguments as Map<String, dynamic>,
                        );
                        widget.navigateToTabWithDetail(
                          1,
                          const EpisodeDetailPage(),
                          episode,
                        );
                        break;
                      case 'CharacterPageDetail':
                        final character = CharacterModel.fromJson(
                          arguments as Map<String, dynamic>,
                        );
                        widget.navigateToTabWithDetail(
                          2,
                          const CharacterDetailPage(),
                          character,
                        );
                        break;
                      case 'OriginPage':
                        final character = OriginModel.fromJson(
                          arguments as Map<String, dynamic>,
                        );
                        widget.navigateToTabWithDetail(
                          3,
                          const OriginPage(),
                          character,
                        );
                        break;
                      case 'LocationPage':
                        final character = LocationModel.fromJson(
                          arguments as Map<String, dynamic>,
                        );
                        widget.navigateToTabWithDetail(
                          4,
                          const OriginPage(),
                          character,
                        );
                        break;
                      default:
                        widget.navigateToTab(0);
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
