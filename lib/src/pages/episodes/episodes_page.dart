import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rick_and_morty_client/src/core/ui/widget/rick_and_morty_app_bar.dart';
import 'package:rick_and_morty_client/src/pages/episode_detail/episode_detail_page.dart';
import 'package:rick_and_morty_client/src/pages/episodes/episodes_controller.dart';

class EpisodesPage extends StatefulWidget {
  const EpisodesPage({super.key});

  @override
  State<EpisodesPage> createState() => _EpisodesPageState();
}

class _EpisodesPageState extends State<EpisodesPage> {
  final controller = Injector.get<EpisodeController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.fetchEpisodes();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          controller.episodeStateStatus != EpisodeStateStatus.loading) {
        controller.fetchEpisodes(page: controller.currentPage + 1);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RickAndMortyAppBar(
        title: 'Episódios',
        context: context,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Observer(
          builder: (_) {
            if (controller.episodeStateStatus == EpisodeStateStatus.loading &&
                controller.episodes.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (controller.episodeStateStatus == EpisodeStateStatus.error) {
              return Center(
                child: Text(controller.errorMessage ?? 'Erro desconhecido'),
              );
            }

            return ListView.separated(
              controller: _scrollController,
              itemCount: controller.episodes.length +
                  (controller.episodeStateStatus == EpisodeStateStatus.loading
                      ? 1
                      : 0),
              itemBuilder: (context, index) {
                if (index == controller.episodes.length) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final episode = controller.episodes[index];
                return ListTile(
                  title: Text(
                    episode.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        episode.episode,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        episode.airDate,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const EpisodeDetailPage(),
                        settings: RouteSettings(
                          arguments: episode,
                        ),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 16,
              ),
            );
          },
        ),
      ),
    );
  }
}
