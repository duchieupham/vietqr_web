import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/constants/env/url_strategy.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/commons/widgets/introduc.dart';
import 'package:VietQR/commons/widgets/print_qr.dart';
import 'package:VietQR/ecom/bank/views/ecom_add_bank_view.dart';
import 'package:VietQR/ecom/home/views/ecom_home.dart';
import 'package:VietQR/ecom/login/views/ecom_login.dart';
import 'package:VietQR/ecom/register/provider/ecom_register_provider.dart';
import 'package:VietQR/ecom/register/views/ecom_register_view.dart';
import 'package:VietQR/features/add_bank/add_bank_step1.dart';
import 'package:VietQR/features/add_bank/add_bank_step2.dart';
import 'package:VietQR/features/add_bank/add_bank_step3.dart';
import 'package:VietQR/features/bank/blocs/bank_bloc.dart';
import 'package:VietQR/features/bank/blocs/bank_type_bloc.dart';
import 'package:VietQR/features/branch/blocs/branch_bloc.dart';
import 'package:VietQR/features/business/blocs/business_information_bloc.dart';
import 'package:VietQR/features/business/views/business_manager_view.dart';
import 'package:VietQR/features/create_qr/create_qr_screen.dart';
import 'package:VietQR/features/create_qr/qr_generate.dart';
import 'package:VietQR/features/dashboard/dashboard_screen.dart';
import 'package:VietQR/features/dashboard/qr_generate_un_authen.dart';
import 'package:VietQR/features/dkdv/dkdv.dart';
import 'package:VietQR/features/home/home_screen.dart';
import 'package:VietQR/features/information_user/blocs/information_user_bloc.dart';
import 'package:VietQR/features/information_user/views/user_information_view.dart';
import 'package:VietQR/features/login/blocs/qrcode_un_authen_bloc.dart';
import 'package:VietQR/features/login/views/login.dart';
import 'package:VietQR/features/logout/blocs/log_out_bloc.dart';
import 'package:VietQR/features/merchant/provider/merchant_provider.dart';
import 'package:VietQR/features/merchant/views/merchant.dart';
import 'package:VietQR/features/notification/blocs/notification_bloc.dart';
import 'package:VietQR/features/qr/blocs/qr_bloc.dart';
import 'package:VietQR/features/qr/views/create_qr.dart';
import 'package:VietQR/features/qr/views/create_qr_un_authen.dart';
import 'package:VietQR/features/register/views/register_view.dart';
import 'package:VietQR/features/setting/blocs/card_num_bloc.dart';
import 'package:VietQR/features/token/blocs/token_bloc.dart';
import 'package:VietQR/features/top_up_account/views/top_up_view.dart';
import 'package:VietQR/features/transaction/blocs/transaction_bloc.dart';
import 'package:VietQR/features/transaction_user/views/transaction_user_screen.dart';
import 'package:VietQR/features/wallet/wallet_card_generate.dart';
import 'package:VietQR/features/wallet/wallet_screen.dart';
import 'package:VietQR/services/providers/action_share_provider.dart';
import 'package:VietQR/services/providers/add_bank_provider.dart';
import 'package:VietQR/services/providers/add_business_provider.dart';
import 'package:VietQR/services/providers/bank_type_provider.dart';
import 'package:VietQR/services/providers/card_number_setting_provider.dart';
import 'package:VietQR/services/providers/guide_provider.dart';
import 'package:VietQR/services/providers/menu_card_provider.dart';
import 'package:VietQR/services/providers/menu_provider.dart';
import 'package:VietQR/services/providers/pin_provider.dart';
import 'package:VietQR/services/providers/register_provider.dart';
import 'package:VietQR/services/providers/search_clear_provider.dart';
import 'package:VietQR/services/providers/theme_provider.dart';
import 'package:VietQR/services/providers/transaction_list_provider.dart';
import 'package:VietQR/services/providers/user_information_provider.dart';
import 'package:VietQR/services/shared_references/account_helper.dart';
import 'package:VietQR/services/shared_references/guide_helper.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/theme_helper.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:VietQR/services/shared_references/web_socket_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'ecom/bank/provider/ecom_bank_type_provider.dart';
import 'features/create_qr/provider/create_qr_provider.dart';
import 'services/providers/business_inforamtion_provider.dart';
import 'services/providers/setting_provider.dart';

//Share Preferences
late SharedPreferences sharedPrefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  sharedPrefs = await SharedPreferences.getInstance();
  await _initialServiceHelper();
  // await Firebase.initializeApp(
  //   options: EnvConfig.getFirebaseConfig(),
  // );
  LOG.verbose('Config Environment: ${EnvConfig.getEnv()}');
  runApp(const VietQRApp());
}

Future<void> _initialServiceHelper() async {
  await WebSocketHelper.instance.initialWebSocket();
  await WebSocketHelper.instance.setListenTransactionQRWS(false);
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
  if (!sharedPrefs.containsKey('GUIDE_DISABLE') ||
      sharedPrefs.getBool('GUIDE_DISABLE') == null) {
    await GuideHelper.instance.initialGuide();
  }
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

// final isLoggedIn = UserInformationHelper.instance.getUserId().trim().isNotEmpty;
// final String authenticatedRedirect = (isLoggedIn) ? '/home' : '/login';
CustomTransitionPage<Widget> buildPageWithoutAnimation({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<Widget>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          child);
}

final GoRouter _router = GoRouter(
  navigatorKey: NavigationService.navigatorKey,
  routes: <RouteBase>[
    GoRoute(
      path: '/ecom',
      redirect: (context, state) {
        return (Session.instance.userECOMId.trim().isNotEmpty)
            ? '/ecom/home'
            : '/ecom/login';
      },
    ),
    GoRoute(
      path: '/ecom/login',
      redirect: (context, state) => '/ecom/login',
      builder: (BuildContext context, GoRouterState state) => const ECOMLogin(),
    ),
    GoRoute(
      path: '/ecom/home',
      redirect: (context, state) =>
          (Session.instance.userECOMId.trim().isNotEmpty)
              ? '/ecom/home'
              : '/ecom/login',
      builder: (BuildContext context, GoRouterState state) =>
          const ECOMHomeScreen(),
    ),
    GoRoute(
      path: '/ecom/register',
      redirect: (context, state) => '/ecom/register',
      builder: (BuildContext context, GoRouterState state) =>
          ECOMRegisterView(),
    ),
    GoRoute(
      path: '/ecom/bank/create/:id',
      redirect: (context, state) => (Session.instance.userECOMId.trim().isEmpty)
          ? '/ecom/login'
          : (Session.instance.userECOMId.trim() == state.params['id'])
              ? '/ecom/bank/create/${state.params['id'] ?? ''}'
              : '/ecom/home',
      builder: (BuildContext context, GoRouterState state) => ECOMAddBankView(
        userId: state.params['id'] ?? '',
      ),
    ),
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
        path: '/register',
        redirect: (context, state) {
          Map<String, String> params = state.queryParams;
          String shareCode = '';
          if (params['share_code'] != null && params['share_code'] != 'null') {
            shareCode = params['share_code'].toString();
          }
          return '/register?share_code=$shareCode';
        },
        builder: (BuildContext context, GoRouterState state) => RegisterView(),
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithoutAnimation(
            context: context,
            state: state,
            child: RegisterView(),
          );
        }),
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
      path: '/dashboard',
      redirect: (context, state) =>
          (UserInformationHelper.instance.getUserId().trim().isNotEmpty)
              ? '/dashboard'
              : '/login',
      builder: (BuildContext context, GoRouterState state) =>
          const DashboardScreen(),
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
    GoRoute(
      path: '/user_information',
      redirect: (context, state) =>
          (UserInformationHelper.instance.getUserId().trim().isNotEmpty)
              ? '/user_information'
              : '/login',
      builder: (BuildContext context, GoRouterState state) =>
          UserInformationView(),
    ),
    GoRoute(
      path: '/qr_generate',
      // redirect: (context, state) {
      //   Map<String, String> params = state.queryParams;
      //   return '/qr_generate?bankCode=${params['bankCode']}&account=${params['account']}&name=${params['name']}&amount=${params['amount']}&content=${params['content']}&showBankAccount=${params['showBankAccount'] ?? '1'}';
      // },
      builder: (context, GoRouterState state) {
        Map<String, String> params = state.queryParams;
        bool isAuthen = false;
        if (state.extra != null) {
          isAuthen = state.extra as bool;
        }
        if (params['token'] == null) {
          return QrGenerateUnAuthen(
            params: params,
            isAuthen: isAuthen,
          );
        }
        return QrGenerate(
          params: params,
          isAuthen: isAuthen,
        );
      },
    ),
    GoRoute(
      path: '/qr_generate/print',
      redirect: (context, state) {
        Map<String, String> params = state.queryParams;

        return '/qr_generate/print?bankCode=${params['bankCode']}&account=${params['account']}&name=${params['name']}&amount=${params['amount']}&content=${params['content']}&showBankAccount=${params['showBankAccount'] ?? '1'}';
      },
      builder: (BuildContext context, GoRouterState state) {
        Map<String, String> params = state.queryParams;

        return QrPrint(
          params: params,
        );
      },
    ),
    GoRoute(
      path: '/naptk',
      redirect: (context, state) => '/naptk',
      builder: (BuildContext context, GoRouterState state) =>
          const TopUpAccount(),
    ),
    GoRoute(
      path: '/create-vietqr',
      redirect: (context, state) => '/create-vietqr',
      builder: (BuildContext context, GoRouterState state) =>
          const CreateQRUnAuthen(),
    ),
    GoRoute(
        path: '/mbbank-dkdv',
        redirect: (context, state) => '/mbbank-dkdv',
        builder: (BuildContext context, GoRouterState state) => const DkDv(),
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithoutAnimation(
            context: context,
            state: state,
            child: const DkDv(),
          );
        }),
    GoRoute(
        path: '/contact/introducing',
        redirect: (context, state) => '/contact/introducing',
        builder: (BuildContext context, GoRouterState state) =>
            const Introduction(),
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithoutAnimation(
            context: context,
            state: state,
            child: const Introduction(),
          );
        }),
    GoRoute(
        path: '/business',
        redirect: (context, state) =>
            (UserInformationHelper.instance.getUserId().trim().isNotEmpty)
                ? '/business'
                : '/login',
        builder: (BuildContext context, GoRouterState state) =>
            const BusinessManagerView(),
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithoutAnimation(
            context: context,
            state: state,
            child: const BusinessManagerView(),
          );
        }),
    GoRoute(
        path: '/merchant',
        redirect: (context, state) =>
            (UserInformationHelper.instance.getUserId().trim().isNotEmpty)
                ? '/merchant'
                : '/login',
        builder: (BuildContext context, GoRouterState state) =>
            const MerchantView(),
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithoutAnimation(
            context: context,
            state: state,
            child: const MerchantView(),
          );
        }),
    GoRoute(
        path: '/transaction',
        redirect: (context, state) =>
            (UserInformationHelper.instance.getUserId().trim().isNotEmpty)
                ? '/transaction'
                : '/login',
        builder: (BuildContext context, GoRouterState state) =>
            const TransactionUserScreen(),
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithoutAnimation(
            context: context,
            state: state,
            child: const TransactionUserScreen(),
          );
        }),
    GoRoute(
        path: '/create-qr/:id',
        redirect: (context, state) =>
            (UserInformationHelper.instance.getUserId().trim().isNotEmpty)
                ? '/create-qr/${state.params['id'] ?? ''}'
                : '/login',
        builder: (BuildContext context, GoRouterState state) => CreateQrScreen(
              bankAccountId: state.params['id'] ?? '',
            ),
        pageBuilder: (BuildContext context, GoRouterState state) {
          Map<String, String> params = state.queryParams;
          return buildPageWithoutAnimation(
            context: context,
            state: state,
            child: CreateQrScreen(
              bankAccountId: state.params['id'] ?? '',
            ),
          );
        }),
    GoRoute(
        path: '/create-qr',
        redirect: (context, state) =>
            (UserInformationHelper.instance.getUserId().trim().isNotEmpty)
                ? '/create-qr'
                : '/login',
        builder: (BuildContext context, GoRouterState state) =>
            const CreateQrScreen(),
        pageBuilder: (BuildContext context, GoRouterState state) {
          Map<String, String> params = state.queryParams;
          return buildPageWithoutAnimation(
            context: context,
            state: state,
            child: const CreateQrScreen(),
          );
        }),
    GoRoute(
        path: '/qr-wallet',
        redirect: (context, state) =>
            (UserInformationHelper.instance.getUserId().trim().isNotEmpty)
                ? '/qr-wallet'
                : '/login',
        builder: (BuildContext context, GoRouterState state) =>
            const WalletScreen(),
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithoutAnimation(
            context: context,
            state: state,
            child: const WalletScreen(),
          );
        }),
    GoRoute(
        path: '/qr-wallet/detail',
        redirect: (context, state) {
          Map<String, String> params = state.queryParams;
          return '/qr-wallet/detail?id=${params['id']}';
        },
        builder: (BuildContext context, GoRouterState state) {
          Map<String, String> params = state.queryParams;
          return QrCardGenerate(
            params: params,
          );
        },
        pageBuilder: (BuildContext context, GoRouterState state) {
          Map<String, String> params = state.queryParams;
          return buildPageWithoutAnimation(
            context: context,
            state: state,
            child: QrCardGenerate(
              params: params,
            ),
          );
        }),
    GoRoute(
        path: '/add-bank/step1',
        redirect: (context, state) =>
            (UserInformationHelper.instance.getUserId().trim().isNotEmpty)
                ? '/add-bank/step1'
                : '/login',
        builder: (BuildContext context, GoRouterState state) =>
            const AddBankStep1(),
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithoutAnimation(
            context: context,
            state: state,
            child: const AddBankStep1(),
          );
        }),
    GoRoute(
        path: '/add-bank/step2',
        redirect: (context, state) {
          Map<String, String> params = state.queryParams;
          return '/add-bank/step2?bankId=${params['bankId']}';
        },
        builder: (BuildContext context, GoRouterState state) {
          Map<String, String> params = state.queryParams;
          return AddBankStep2(
            bankId: params['bankId'].toString(),
          );
        },
        pageBuilder: (BuildContext context, GoRouterState state) {
          Map<String, String> params = state.queryParams;
          return buildPageWithoutAnimation(
            context: context,
            state: state,
            child: AddBankStep2(
              bankId: params['bankId'].toString(),
            ),
          );
        }),
    GoRoute(
        path: '/add-bank/step3',
        redirect: (context, state) =>
        (UserInformationHelper.instance.getUserId().trim().isNotEmpty)
            ? '/add-bank/step3'
            : '/login',
        builder: (BuildContext context, GoRouterState state) =>
        const AddBankStep3(),
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithoutAnimation(
            context: context,
            state: state,
            child: const AddBankStep3(),
          );
        }),
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
    WebSocketHelper.instance.listenTransactionSocket();
    Session.load;
    Session.instance.getGuideWeb();
    Session.instance.updateQRGeneratePage(false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<BankBloc>(
            create: (BuildContext context) => BankBloc(),
          ),
          BlocProvider<TransactionBloc>(
            create: (BuildContext context) => TransactionBloc(),
          ),
          BlocProvider<QRBloc>(
            create: (BuildContext context) => QRBloc(),
          ),
          BlocProvider<BankTypeBloc>(
            create: (BuildContext context) => BankTypeBloc(),
          ),
          BlocProvider<LogoutBloc>(
            create: (BuildContext context) => LogoutBloc(),
          ),
          BlocProvider<TokenBloc>(
            create: (BuildContext context) => TokenBloc(),
          ),
          BlocProvider<QRCodeUnUTBloc>(
            create: (BuildContext context) => QRCodeUnUTBloc(),
          ),
          BlocProvider<NotificationBloc>(
            create: (BuildContext context) => NotificationBloc(),
          ),
          BlocProvider<CardNumBloc>(
            create: (BuildContext context) => CardNumBloc(),
          ),
          BlocProvider<InformationUserBloc>(
            create: (BuildContext context) => InformationUserBloc(),
          ),
          BlocProvider<BranchBloc>(
            create: (BuildContext context) => BranchBloc(id: ''),
          ),
          BlocProvider<BusinessInformationBloc>(
            create: (BuildContext context) => BusinessInformationBloc(),
          ),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => ThemeProvider()),
            ChangeNotifierProvider(create: (context) => PinProvider()),
            ChangeNotifierProvider(create: (context) => MenuProvider()),
            ChangeNotifierProvider(create: (context) => MenuCardProvider()),
            ChangeNotifierProvider(create: (context) => CreateQRProvider()),
            ChangeNotifierProvider(create: (context) => RegisterProvider()),
            ChangeNotifierProvider(create: (context) => ECOMRegisterProvider()),
            ChangeNotifierProvider(create: (context) => BankTypeProvider()),
            ChangeNotifierProvider(create: (context) => GuideProvider()),
            ChangeNotifierProvider(
                create: (context) => CardNumberSettingProvider()),
            ChangeNotifierProvider(
                create: (context) => TransactionListProvider()),
            ChangeNotifierProvider(create: (context) => ECOMBankTypeProvider()),
            ChangeNotifierProvider(
                create: (context) => UserInformationProvider()),
            ChangeNotifierProvider(create: (context) => AddBusinessProvider()),
            ChangeNotifierProvider(
                create: (context) => BusinessInformationProvider()),
            ChangeNotifierProvider(create: (context) => SearchProvider()),
            ChangeNotifierProvider(create: (context) => AddBankProvider()),
            ChangeNotifierProvider(create: (context) => ActionShareProvider()),
            ChangeNotifierProvider(create: (context) => SettingProvider()),
            ChangeNotifierProvider(create: (context) => MerchantProvider()),
          ],
          child: Consumer<ThemeProvider>(
            builder: (context, themeSelect, child) {
              return MaterialApp.router(
                onGenerateTitle: (context) =>
                    'VietQR VN - Mã QR thanh toán Ngân hàng Việt Nam',
                routerConfig: _router,
                debugShowCheckedModeBanner: false,
                themeMode: (themeSelect.themeSystem == AppColor.THEME_SYSTEM)
                    ? ThemeMode.system
                    : (themeSelect.themeSystem == AppColor.THEME_LIGHT)
                        ? ThemeMode.light
                        : ThemeMode.dark,
                darkTheme: DefaultThemeData(context: context).darkTheme,
                theme: DefaultThemeData(context: context).lightTheme,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  MonthYearPickerLocalizations.delegate,
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
