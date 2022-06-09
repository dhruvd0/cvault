import 'package:cvault/constants/user_types.dart';
import 'package:cvault/providers/customer_provider.dart';
import 'package:cvault/providers/exchange_provider.dart';
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
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: false,
          create: (context) => HomeStateNotifier(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (context) => ProfileChangeNotifier(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (context) => QuoteProvider(),
        ),
        ChangeNotifierProvider.value(value: DealersProvider()),
        ChangeNotifierProvider.value(value: TransactionsProvider()),
        ChangeNotifierProvider.value(value: ExchangeProvider()),
        ChangeNotifierProvider.value(value: CustomerProvider()),
      ],
      child: MaterialApp(home: CVaultApp()),
    ),
  );
}

class CVaultApp extends StatefulWidget {
  const CVaultApp({
    Key? key,
  }) : super(key: key);

  @override
  State<CVaultApp> createState() => _CVaultAppState();
}

class _CVaultAppState extends State<CVaultApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      Widget widget = UserTypeSelectPage();
      if (FirebaseAuth.instance.currentUser != null) {
        String? userType = (await SharedPreferences.getInstance())
            .getString(SharedPreferencesKeys.userTypeKey);
        var notifier =
            Provider.of<ProfileChangeNotifier>(context, listen: false);
        await notifier.fetchProfile();
        widget = (notifier.profile.firstName.isNotEmpty ||
                userType == UserTypes.admin)
            ? HomePage()
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
      child: Container(
        color: ThemeColors.backgroundColor,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
