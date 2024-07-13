import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rick_and_morty_client/src/core/ui/widget/rick_and_morty_app_bar.dart';
import 'package:rick_and_morty_client/src/model/episode_model.dart';
import 'package:rick_and_morty_client/src/pages/character_datail/character_datail_page.dart';
import 'package:rick_and_morty_client/src/pages/episode_detail/episode_detail_controller.dart';

class EpisodeDetailPage extends StatefulWidget {
  const EpisodeDetailPage({
    super.key,
  });

  @override
  State<EpisodeDetailPage> createState() => _EpisodeDetailPageState();
}

class _EpisodeDetailPageState extends State<EpisodeDetailPage> {
  final controller = Injector.get<EpisodeDetailController>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final episode =
          ModalRoute.of(context)!.settings.arguments as EpisodeModel;
      controller.fetchCharacters(episode.characterIds);
    });
  }

  @override
  Widget build(BuildContext context) {
    final episode = ModalRoute.of(context)!.settings.arguments as EpisodeModel;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: RickAndMortyAppBar(
        title: episode.name,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    episode.episode,
                    style: textTheme.titleMedium,
                  ),
                  Text(
                    episode.airDate,
                    style: textTheme.labelLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Personagens:',
                    style: textTheme.titleMedium,
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  ...controller.characters.map((character) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(character.image),
                      ),
                      title: Text(
                        character.name,
                        style: textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      subtitle: Text(
                        character.status,
                        style: textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CharacterDetailPage(),
                            settings: RouteSettings(
                              arguments: character,
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
