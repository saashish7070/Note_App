import 'package:flutter/material.dart';
import 'package:free_note/screens/provider/note_provider.dart';
import 'package:free_note/screens/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:free_note/utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NoteApp());
}

class NoteApp extends StatefulWidget {
  const NoteApp({super.key});

  @override
  State<NoteApp> createState() => _NoteAppState();
}

class _NoteAppState extends State<NoteApp> {
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    final userProvider = UserProvider();
    _initFuture = userProvider.tryAutoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => NotesProvider()),
      ],
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return FutureBuilder(
            future: _initFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const MaterialApp(
                  home: Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  ),
                );
              }
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'FreeNote',
                routerConfig: NoteRouter.createRouter(userProvider),
              );
            },
          );
        },
      ),
    );
  }
}
