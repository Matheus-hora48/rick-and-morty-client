import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rick_and_morty_client/src/core/ui/widget/rick_and_morty_app_bar.dart';
import 'package:rick_and_morty_client/src/db/database_history_helper.dart';
import 'package:rick_and_morty_client/src/model/character_model.dart';
import 'package:rick_and_morty_client/src/model/navigation_history.dart';
import 'package:rick_and_morty_client/src/pages/character_datail/character_detail_controller.dart';
import 'package:rick_and_morty_client/src/core/ui/widget/label_widget.dart';
import 'package:rick_and_morty_client/src/pages/episode_detail/episode_detail_page.dart';
import 'package:rick_and_morty_client/src/pages/origin/origin_page.dart';

class CharacterDetailPage extends StatefulWidget {
  const CharacterDetailPage({
    super.key,
    required,
  });

  @override
  State<CharacterDetailPage> createState() => _CharacterDetailPageState();
}

class _CharacterDetailPageState extends State<CharacterDetailPage> {
  final controller = Injector.get<CharacterDetailController>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final episode =
          ModalRoute.of(context)!.settings.arguments as CharacterModel;
      controller.fetchEpisodes(episode.episodeIds);
    });
  }

  @override
  Widget build(BuildContext context) {
    final character =
        ModalRoute.of(context)!.settings.arguments as CharacterModel;

    return Scaffold(
      appBar: RickAndMortyAppBar(
        title: character.name,
        context: context,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Observer(
          builder: (_) {
            if (controller.errorMessage != null) {
              return Center(child: Text(controller.errorMessage!));
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(character.image),
                    ),
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LabelWidget(
                        title: 'Status',
                        subtitle: character.status,
                      ),
                      LabelWidget(
                        title: 'Species',
                        subtitle: character.species,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LabelWidget(
                        title: 'Type',
                        subtitle:
                            character.type.isEmpty ? '--' : character.type,
                      ),
                      LabelWidget(
                        title: 'Gender',
                        subtitle: character.gender,
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      final nav = Navigator.of(context);
                      final history = NavigationHistoryItem(
                        screenName: 'OriginPage',
                        route: '/origin',
                        arguments: character.origin,
                        title: 'Origem: ${character.origin.name}',
                        dateTime: DateTime.now().toIso8601String(),
                      );

                      await DatabaseHistoryHelper().insertHistory(history);

                      nav.push(
                        MaterialPageRoute(
                          builder: (context) => const OriginPage(),
                          settings: RouteSettings(
                            arguments: character.origin,
                          ),
                        ),
                      );
                    },
                    child: LabelWidget(
                      title: 'Origin',
                      subtitle: character.origin.name,
                      underline: true,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final nav = Navigator.of(context);

                      final history = NavigationHistoryItem(
                        screenName: 'LocationPage',
                        route: '/location',
                        arguments: character.location,
                        title: 'Localização: ${character.location.name}',
                        dateTime: DateTime.now().toIso8601String(),
                      );

                      await DatabaseHistoryHelper().insertHistory(history);

                      nav.push(
                        MaterialPageRoute(
                          builder: (context) => const OriginPage(),
                          settings: RouteSettings(
                            arguments: character.location,
                          ),
                        ),
                      );
                    },
                    child: LabelWidget(
                      title: 'Type',
                      subtitle: character.location.name,
                      underline: true,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Episódios:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const Divider(),
                  ...controller.episode.map((episode) {
                    return ListTile(
                      title: Text(
                        episode.name,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                      subtitle: Text(
                        episode.episode,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      onTap: () async {
                        final nav = Navigator.of(context);
                        final history = NavigationHistoryItem(
                          screenName: 'EpisodesPageDetail',
                          route: '/episodes/detail',
                          arguments: episode,
                          title: 'Episódio: ${episode.name}',
                          dateTime: DateTime.now().toIso8601String(),
                        );

                        await DatabaseHistoryHelper().insertHistory(history);

                        nav.push(
                          MaterialPageRoute(
                            builder: (context) => const EpisodeDetailPage(),
                            settings: RouteSettings(
                              arguments: episode,
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
