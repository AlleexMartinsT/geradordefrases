import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Gerador de Frases',
        theme: ThemeData(
          // esquema de cores
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
            primary: Colors.deepPurple,
            secondary: Colors.amber,
            background: Colors.black,
            surface: Colors.grey[850]!,
            onPrimary: Colors.white,
            onSecondary: Colors.black,
            onBackground: Colors.white,
            onSurface: Colors.white,
          ),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  // Lista de frases
  final List<String> frases = [
    "Continue lutando, herói!",
    "Você é a última esperança do reino.",
    "Aventure-se além dos seus limites.",
    "Sempre há um novo desafio à frente.",
    "Ganhar ou perder, o importante é jogar.",
    "Não é o fim do jogo até que você diga que é.",
    "Use suas habilidades com sabedoria.",
    "Cada missão completa é um passo para a vitória.",
    "Os verdadeiros heróis nunca desistem.",
    "Enfrente seus medos, vença os chefões.",
    "A prática leva à perfeição, mesmo nos jogos.",
    "A vida é um jogo, jogue com coragem.",
    "Os obstáculos são apenas inimigos a serem derrotados.",
    "Estratégia e paciência são suas maiores armas.",
    "Seja rápido como um ninja.",
    "O destino do mundo está em suas mãos.",
    "Não deixe nenhum item para trás.",
    "Encontre o poder dentro de você.",
    "Cada level é uma nova aventura.",
    "Salve a princesa e ganhe o jogo.",
    "Você pode ser o próximo campeão.",
    "A cada vida perdida, uma lição aprendida.",
    "Não há derrotas, apenas power-ups.",
    "Jogue com o coração de um guerreiro.",
    "Cada escolha muda o curso do jogo.",
    "Não há glitch que possa te parar.",
    "Seu destino é ser um vencedor.",
    "Os grandes jogadores se adaptam a qualquer situação.",
    "Seu joystick controla o seu destino.",
    "A jornada é mais importante que a vitória."
  ];

  // Índice da frase atual
  var currentIndex = 0;

  // Getter para a frase atual
  String get current => frases[currentIndex];

  // Método para obter a próxima frase
  void getNext() {
    currentIndex = (currentIndex + 1) % frases.length;
    notifyListeners();
  }

  // Lista de frases favoritas
  var favorites = <String>[];

  // Método para adicionar/remover a frase atual dos favoritos
  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              // Navegação lateral
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Pagina Inicial'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favoritos'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            // Exibição da página selecionada
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.background,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

// Página do gerador de frases
class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var phrase = appState.current;

    IconData icon;
    if (appState.favorites.contains(phrase)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(phrase: phrase),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Botão para favoritar/desfavoritar a frase atual
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Favoritar'),
              ),
              SizedBox(width: 10),
              // Botão para obter a próxima frase
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Próximo'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.phrase,
  });

  final String phrase;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          phrase,
          style: style,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// Página de favoritos
class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('Sem favoritos :('),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('Você tem '
              '${appState.favorites.length} favoritos:'),
        ),
        // Exibição da lista de frases favoritas
        for (var phrase in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(phrase),
          ),
      ],
    );
  }
}
