import 'package:cvault/constants/user_types.dart';
import 'package:cvault/providers/customer_provider.dart';
import 'package:cvault/providers/advertisement_provider.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/Screens/profile/widgets/profile_page.dart';
import 'package:cvault/Screens/usertype_select/usertype_select_page.dart';
import 'package:cvault/constants/theme.dart';
import 'package:cvault/firebase_options.dart';
import 'package:cvault/home_page.dart';
import 'package:cvault/providers/home_provider.dart';
import 'package:cvault/providers/dealers_provider.dart';
import 'package:cvault/providers/quote_provider.dart';
import 'package:cvault/util/sharedPreferences/keys.dart';
import 'package:cvault/providers/transactions_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_preview/device_preview.dart';

import 'providers/margin_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: _providers,
      child: DevicePreview(
        enabled: true,
        builder: (context) {
          return const MaterialApp(
            useInheritedMediaQuery: true,
            debugShowCheckedModeBanner: false,
            home: CVaultApp(),
          );
        },
      ),
    ),
  );
}

List<SingleChildWidget> get _providers {
  return [
    ChangeNotifierProvider(
      lazy: false,
      create: (context) => ProfileChangeNotifier(),
    ),
    ChangeNotifierProvider(
      lazy: false,
      create: ((context) =>
          MarginsNotifier(context.read<ProfileChangeNotifier>())),
    ),
    ChangeNotifierProvider(
      lazy: false,
      create: (context) => HomeStateNotifier(
        marginsNotifier: context.read<MarginsNotifier>(),
        profileChangeNotifier: context.read<ProfileChangeNotifier>(),
      ),
    ),
    ChangeNotifierProvider(
      lazy: false,
      create: ((context) => AdvertisementProvider()),
    ),
    ChangeNotifierProvider(
      lazy: false,
      create: (context) =>
          MarginsNotifier(context.read<ProfileChangeNotifier>()),
    ),
    _buildQuoteChangeNotifierProvider(),
    ChangeNotifierProvider.value(value: DealersProvider()),
    ChangeNotifierProvider(
      lazy: false,
      create: (context) => TransactionsProvider(
        context.read<ProfileChangeNotifier>(),
      ),
    ),
    ChangeNotifierProvider.value(value: CustomerProvider()),
  ];
}

ChangeNotifierProvider<QuoteProvider> _buildQuoteChangeNotifierProvider() {
  return ChangeNotifierProvider(
    lazy: false,
    create: (context) => QuoteProvider(
      homeStateNotifier: context.read<HomeStateNotifier>(),
      profileChangeNotifier: context.read<ProfileChangeNotifier>(),
    ),
  );
}

/// Entry point for cvault app
class CVaultApp extends StatefulWidget {
  ///
  const CVaultApp({
    Key? key,
  }) : super(key: key);

  @override
  State<CVaultApp> createState() => _CVaultAppState();
}

class _CVaultAppState extends State<CVaultApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Widget widget = const UserTypeSelectPage();
      if (FirebaseAuth.instance.currentUser != null) {
        String? userType = (await SharedPreferences.getInstance())
            .getString(SharedPreferencesKeys.userTypeKey);
        if (!mounted) {
          return;
        }
        var notifier =
            Provider.of<ProfileChangeNotifier>(context, listen: false);
        await notifier
            .checkAndChangeUserType(FirebaseAuth.instance.currentUser!);
        await notifier.fetchProfile();
        widget = (notifier.profile.firstName.isNotEmpty ||
                userType == UserTypes.admin)
            ? const HomePage()
            : ProfilePage(mode: ProfilePageMode.registration);
      }
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => widget,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.backgroundColor,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
