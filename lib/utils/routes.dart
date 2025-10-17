import 'package:free_note/screens/home_page.dart';
import 'package:free_note/screens/login_page.dart';
import 'package:free_note/screens/registration_page.dart';
import 'package:free_note/screens/provider/user_provider.dart';
import 'package:go_router/go_router.dart';

class NoteRouter {
  static GoRouter createRouter(UserProvider userProvider) {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: userProvider,
      redirect: (context, state) {
        final loggedIn = userProvider.isLoggedIn;
        final loggingIn = state.matchedLocation == '/';
        final registering = state.matchedLocation == '/register';

        if (!loggedIn && !loggingIn && !registering) return '/';
        if (loggedIn && (loggingIn || registering)) return '/home';
        return null;
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => const LoginPage()),
        GoRoute(path: '/register', builder: (context, state) => const RegisterPage()),
        GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      ],
    );
  }
}
