import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rick_and_morty_client/src/core/ui/widget/rick_and_morty_app_bar.dart';
import 'package:rick_and_morty_client/src/model/origin_model.dart';
import 'package:rick_and_morty_client/src/pages/character_datail/character_datail_page.dart';
import 'package:rick_and_morty_client/src/pages/character_datail/widget/label_widget.dart';
import 'package:rick_and_morty_client/src/pages/origin/origin_controller.dart';

class OriginPage extends StatefulWidget {
  const OriginPage({super.key});

  @override
  State<OriginPage> createState() => _OriginPageState();
}

class _OriginPageState extends State<OriginPage> {
  final controller = Injector.get<OriginController>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final origin = ModalRoute.of(context)!.settings.arguments as OriginModel;
      controller.fetchLocation(origin.locationId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final origin = ModalRoute.of(context)!.settings.arguments as OriginModel;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: RickAndMortyAppBar(
        title: origin.name,
        context: context,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Observer(
          builder: (_) {
            if (controller.location == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelWidget(
                    title: 'Type',
                    subtitle: controller.location!.type,
                  ),
                  LabelWidget(
                    title: 'Dimension',
                    subtitle: controller.location!.dimension,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Residentes',
                    style: Theme.of(context).textTheme.titleMedium,
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
