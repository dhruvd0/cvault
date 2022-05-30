import 'package:cvault/Screens/profile/cubit/cubit/profile_cubit.dart';
import 'package:cvault/Screens/profile/cubit/cubit/profile_state.dart';
import 'package:cvault/Screens/profile/widgets/profile.dart';
import 'package:cvault/Screens/usertype_select/usertype_select_page.dart';
import 'package:cvault/constants/theme.dart';
import 'package:cvault/firebase_options.dart';
import 'package:cvault/home_page.dart';
import 'package:cvault/Screens/home/bloc/cubit/home_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            lazy: false,
            create: (context) => HomeStateNotifier(),
          ),
          ChangeNotifierProvider(
            lazy: false,
            create: (context) => ProfileNotifier(),
          ),
        ],
        child: MaterialApp(home: CVaultApp()),
      ),
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
        var notifier = Provider.of<ProfileNotifier>(context,listen: false);
        await notifier.fetchProfile();
        widget = notifier.state is NewProfile
            ? ProfilePage(mode: ProfilePageMode.registration)
            : HomePage();
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
