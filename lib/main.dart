import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/constants/env/url_strategy.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/bank/blocs/bank_bloc.dart';
import 'package:VietQR/features/home/views/home.dart';
import 'package:VietQR/features/login/blocs/login_bloc.dart';
import 'package:VietQR/features/login/views/login.dart';
import 'package:VietQR/features/qr/views/create_qr.dart';
import 'package:VietQR/features/transaction/blocs/transaction_bloc.dart';
import 'package:VietQR/services/providers/menu_card_provider.dart';
import 'package:VietQR/services/providers/pin_provider.dart';
import 'package:VietQR/services/providers/theme_provider.dart';
import 'package:VietQR/services/providers/transaction_list_provider.dart';
import 'package:VietQR/services/shared_references/account_helper.dart';
import 'package:VietQR/services/shared_references/theme_helper.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Share Preferences
late SharedPreferences sharedPrefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  sharedPrefs = await SharedPreferences.getInstance();
  await _initialServiceHelper();
  await Firebase.initializeApp(
    options: EnvConfig.getFirebaseConfig(),
  );
  LOG.verbose('Config Environment: ${EnvConfig.getEnv()}');
  runApp(VietQRApp());
}

Future<void> _initialServiceHelper() async {
  if (!sharedPrefs.containsKey('THEME_SYSTEM') ||
      sharedPrefs.getString('THEME_SYSTEM') == null) {
    await ThemeHelper.instance.initialTheme();
  }
  if (!sharedPrefs.containsKey('USER_ID') ||
      sharedPrefs.getString('USER_ID') == null) {
    await UserInformationHelper.instance.initialUserInformationHelper();
  }
  if (!sharedPrefs.containsKey('TOKEN') ||
      sharedPrefs.getString('TOKEN') == null) {
    await AccountHelper.instance.initialAccountHelper();
  }
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

// final isLoggedIn = UserInformationHelper.instance.getUserId().trim().isNotEmpty;
// final String authenticatedRedirect = (isLoggedIn) ? '/home' : '/login';

final GoRouter _router = GoRouter(
  navigatorKey: NavigationService.navigatorKey,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      redirect: (context, state) {
        return (UserInformationHelper.instance.getUserId().trim().isNotEmpty)
            ? '/home'
            : '/login';
      },
    ),
    GoRoute(
      path: '/login',
      redirect: (context, state) =>
          (UserInformationHelper.instance.getUserId().trim().isNotEmpty)
              ? '/home'
              : '/login',
      builder: (BuildContext context, GoRouterState state) => const Login(),
    ),
    GoRoute(
      path: '/home',
      redirect: (context, state) =>
          (UserInformationHelper.instance.getUserId().trim().isNotEmpty)
              ? '/home'
              : '/login',
      builder: (BuildContext context, GoRouterState state) =>
          const HomeScreen(),
    ),
    GoRoute(
      path: '/qr/create',
      redirect: (context, state) =>
          (UserInformationHelper.instance.getUserId().trim().isNotEmpty)
              ? '/qr/create'
              : '/login',
      builder: (BuildContext context, GoRouterState state) => const CreateQR(),
    ),
  ],
);

class VietQRApp extends StatelessWidget {
  const VietQRApp({super.key});

  void _initialServices(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    _initialServices(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
            create: (BuildContext context) => LoginBloc(),
          ),
          BlocProvider<BankBloc>(
            create: (BuildContext context) => BankBloc(),
          ),
          BlocProvider<TransactionBloc>(
            create: (BuildContext context) => TransactionBloc(),
          ),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => ThemeProvider()),
            ChangeNotifierProvider(create: (context) => PinProvider()),
            ChangeNotifierProvider(create: (context) => MenuCardProvider()),
            ChangeNotifierProvider(
                create: (context) => TransactionListProvider()),
          ],
          child: Consumer<ThemeProvider>(
            builder: (context, themeSelect, child) {
              return MaterialApp.router(
                routerConfig: _router,
                debugShowCheckedModeBanner: false,
                themeMode:
                    (themeSelect.themeSystem == DefaultTheme.THEME_SYSTEM)
                        ? ThemeMode.system
                        : (themeSelect.themeSystem == DefaultTheme.THEME_LIGHT)
                            ? ThemeMode.light
                            : ThemeMode.dark,
                darkTheme: DefaultThemeData(context: context).darkTheme,
                theme: DefaultThemeData(context: context).lightTheme,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  //  Locale('en'), // English
                  Locale('vi'), // Vietnamese
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
