import 'dart:convert';

import 'package:VietQR/commons/constants/configurations/stringify.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/constants/env/url_strategy.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/features/bank/blocs/bank_bloc.dart';
import 'package:VietQR/features/home/views/home.dart';
import 'package:VietQR/features/login/blocs/login_bloc.dart';
import 'package:VietQR/features/login/views/login.dart';
import 'package:VietQR/features/qr/blocs/qr_bloc.dart';
import 'package:VietQR/features/qr/views/create_qr.dart';
import 'package:VietQR/features/transaction/blocs/transaction_bloc.dart';
import 'package:VietQR/features/transaction/widgets/transaction_success_widget.dart';
import 'package:VietQR/models/notification_transaction_success_dto.dart';
import 'package:VietQR/services/providers/create_qr_provider.dart';
import 'package:VietQR/services/providers/menu_card_provider.dart';
import 'package:VietQR/services/providers/pin_provider.dart';
import 'package:VietQR/services/providers/theme_provider.dart';
import 'package:VietQR/services/providers/transaction_list_provider.dart';
import 'package:VietQR/services/shared_references/account_helper.dart';
import 'package:VietQR/services/shared_references/theme_helper.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:VietQR/services/shared_references/web_socket_helper.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
  runApp(const VietQRApp());
}

Future<void> _initialServiceHelper() async {
  await WebSocketHelper.instance.initialWebSocket();
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
      path: '/qr/create/:id',
      redirect: (context, state) =>
          (UserInformationHelper.instance.getUserId().trim().isNotEmpty)
              ? '/qr/create/${state.params['id'] ?? ''}'
              : '/login',
      builder: (BuildContext context, GoRouterState state) => CreateQR(
        bankId: state.params['id'] ?? '',
      ),
    ),
  ],
);

class VietQRApp extends StatefulWidget {
  const VietQRApp({super.key});

  @override
  State<StatefulWidget> createState() => _VietQRApp();
}

class _VietQRApp extends State<VietQRApp> {
  late WebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    String userId = UserInformationHelper.instance.getUserId();
    listenWebSocket(userId);
  }

  void listenWebSocket(String userId) {
    if (userId.isNotEmpty) {
      bool isListenWebSocket = WebSocketHelper.instance.isListenWs();
      if (!isListenWebSocket) {
        try {
          WebSocketHelper.instance.setListenWs(true);
          final wsUrl =
              Uri.parse('ws://api.vietqr.org/vqr/socket?userId=$userId');
          channel = WebSocketChannel.connect(wsUrl);
          print('channel.closeCode: ${channel.closeCode}');
          if (channel.closeCode == null) {
            channel.stream.listen((event) {
              var data = jsonDecode(event);
              if (data['notificationType'] != null &&
                  data['notificationType'] ==
                      Stringify.NOTI_TYPE_UPDATE_TRANSACTION) {
                DialogWidget.instance.openWidgetDialog(
                  child: TransactionSuccessWidget(
                    dto: NotificationTransactionSuccessDTO.fromJson(data),
                  ),
                );
              }
            });
          } else {
            WebSocketHelper.instance.setListenWs(false);
          }
        } catch (e) {
          print('WS: $e');
          LOG.error('WS: $e');
        }
      }
    }
  }

  // void onFcmMessage() async {
  //   // await NotificationServic.initialNotification();
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     // Xử lý push notification nếu ứng dụng đang chạy
  //     LOG.info(
  //         "Push notification received: ${message.notification?.title} - ${message.notification?.body}");
  //     LOG.info("receive data: ${message.data}");

  //     // NotificationService().showNotification(
  //     //   title: message.notification?.title,
  //     //   body: message.notification?.body,
  //     // );

  //     //process when receive data
  //     if (message.data.isNotEmpty) {
  //       //process success transcation
  //       if (message.data['notificationType'] != null &&
  //           message.data['notificationType'] ==
  //               Stringify.NOTI_TYPE_UPDATE_TRANSACTION) {
  //         DialogWidget.instance.openWidgetDialog(
  //           child: TransactionSuccessWidget(
  //             dto: NotificationTransactionSuccessDTO.fromJson(message.data),
  //           ),
  //         );
  //       }
  //     }
  //   });
  // }

  // void onFcmMessageOpenedApp() {
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     // Xử lý push notification nếu ứng dụng không đang chạy
  //     if (message.notification != null) {
  //       LOG.info(
  //           "Push notification clicked: ${message.notification?.title.toString()} - ${message.notification?.body}");
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
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
          BlocProvider<QRBloc>(
            create: (BuildContext context) => QRBloc(),
          ),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => ThemeProvider()),
            ChangeNotifierProvider(create: (context) => PinProvider()),
            ChangeNotifierProvider(create: (context) => MenuCardProvider()),
            ChangeNotifierProvider(create: (context) => CreateQRProvider()),
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
