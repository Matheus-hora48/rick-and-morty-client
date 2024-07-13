import 'package:flutter/material.dart';
import 'package:rick_and_morty_client/src/core/ui/widget/rick_and_morty_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: RickAndMortyAppBar(
        title: 'Matheus Hora',
        context: context,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              Text(
                'Matheus Hora dos Santos Bento',
                style: textTheme.titleLarge,
              ),
              Divider(
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Sou um desenvolvedor de software com mais de 3 anos de experiência, especializado na criação de aplicativos móveis utilizando Flutter. Possuo habilidades avançadas no desenvolvimento web com Angular e experiência em back-end com Node.js e C#. Minha trajetória profissional é marcada pela entrega de soluções tecnológicas inovadoras e eficientes.',
                style: textTheme.labelLarge,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                '> Experiência profissional',
                style: textTheme.titleMedium,
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Conceito Tecnologia',
                      style: textTheme.bodyLarge,
                    ),
                    Text(
                      'out de 2024 - até o momento',
                      style: textTheme.labelLarge,
                    ),
                    Text(
                      'Na Conceito Tecnologia, lidero a equipe de desenvolvimento Flutter, contribuindo para a criação de um aplicativo móvel integrado a um sistema ERP de desktop. Utilizando Flutter e C#, sou responsável por arquitetar soluções eficientes e inovadoras, garantindo a integração perfeita entre as plataformas mobile e desktop.',
                      style: textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                '> Formação',
                style: textTheme.titleMedium,
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bacharelado em Engenharia de software',
                      style: textTheme.bodyLarge,
                    ),
                    Text(
                      'Cruzeiro do Sul Virtual',
                      style: textTheme.labelLarge,
                    ),
                    Text(
                      'Conclusão em 2025',
                      style: textTheme.labelLarge,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Flutterando',
                      style: textTheme.bodyLarge,
                    ),
                    Text(
                      'Masterclass turma 6',
                      style: textTheme.labelLarge,
                    ),
                    Text(
                      'mar em 2023',
                      style: textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                '> Links',
                style: textTheme.titleMedium,
              ),
              Row(
                children: [
                  Icon(
                    Icons.link,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  InkWell(
                    child: Text(
                      'Linkedin',
                      style: textTheme.titleMedium!.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.link,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  InkWell(
                    child: Text(
                      'Github',
                      style: textTheme.titleMedium!.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
