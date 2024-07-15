import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rick_and_morty_client/src/core/ui/widget/rick_and_morty_app_bar.dart';
import 'package:rick_and_morty_client/src/db/database_history_helper.dart';
import 'package:rick_and_morty_client/src/model/navigation_history.dart';
import 'package:rick_and_morty_client/src/pages/character/character_controller.dart';
import 'package:rick_and_morty_client/src/pages/character_datail/character_datail_page.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  final controller = Injector.get<CharacterController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.fetchEpisodes();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          controller.characterStateStatus != CharacterStateStatus.loading) {
        controller.fetchEpisodes(page: controller.currentPage + 1);
      }
    });

    _saveHistory();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _saveHistory() async {
    final history = NavigationHistoryItem(
      screenName: 'CharacterPage',
      route: '/character',
      arguments: null,
      title: 'Página personagem',
      dateTime: DateTime.now().toIso8601String(),
    );
    await DatabaseHistoryHelper().insertHistory(history);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RickAndMortyAppBar(
        title: 'Personagens',
        context: context,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Observer(
          builder: (_) {
            if (controller.characterStateStatus ==
                    CharacterStateStatus.loading &&
                controller.character.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (controller.characterStateStatus == CharacterStateStatus.error) {
              return Center(
                child: Text(controller.errorMessage ?? 'Erro desconhecido'),
              );
            }

            return ListView.separated(
              controller: _scrollController,
              itemCount: controller.character.length +
                  (controller.characterStateStatus ==
                          CharacterStateStatus.loading
                      ? 1
                      : 0),
              itemBuilder: (context, index) {
                if (index == controller.character.length) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final character = controller.character[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(character.image),
                  ),
                  title: Text(
                    character.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        character.species,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        character.status,
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
                  onTap: () async {
                    final history = NavigationHistoryItem(
                      screenName: 'CharacterPageDetail',
                      route: '/character/detail',
                      arguments: character,
                      title: 'Episódio: ${character.name}',
                      dateTime: DateTime.now().toIso8601String(),
                    );

                    await DatabaseHistoryHelper().insertHistory(history);

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
