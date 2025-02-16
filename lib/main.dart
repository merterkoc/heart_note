import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/message/data/message_repository.dart';
import 'features/message/presentation/bloc/message_bloc.dart';
import 'core/router/router.dart';
import 'core/services/gemini_service.dart';
import 'core/theme/app_theme.dart';
import 'core/bloc/theme_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => ThemeBloc(prefs: prefs)..add(LoadTheme()),
        ),
        BlocProvider(
          create: (context) => MessageBloc(
            repository: MessageRepository(),
          )..add(LoadCategories()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Heart Note',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            routerConfig: router,
          );
        },
      ),
    );
  }
}

class MessageCategory {
  final String title;
  final IconData icon;
  final String description;

  const MessageCategory({
    required this.title,
    required this.icon,
    required this.description,
  });
}

final List<MessageCategory> categories = [
  MessageCategory(
    title: 'Sevgililer Günü',
    icon: Icons.favorite,
    description: 'Aşkınızı ifade eden özel mesajlar',
  ),
  MessageCategory(
    title: 'Doğum Günü',
    icon: Icons.cake,
    description: 'Doğum günü kutlama mesajları',
  ),
  MessageCategory(
    title: 'Yıldönümü',
    icon: Icons.celebration,
    description: 'Özel günleriniz için anlamlı notlar',
  ),
  // ... diğer kategoriler
];

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Icon(
                category.icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                category.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(category.description),
              ),
              onTap: () {
                // TODO: Kategori seçildiğinde mesaj oluşturma sayfasına yönlendir
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement new note creation
        },
        tooltip: 'New Note',
        child: const Icon(Icons.edit),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
