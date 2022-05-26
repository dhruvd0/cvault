import 'package:cvault/Screens/login/login_screen.dart';
import 'package:cvault/Screens/profile/cubit/cubit/profile_cubit.dart';
import 'package:cvault/Screens/usertype_select/usertype_select_page.dart';
import 'package:cvault/home_page.dart';
import 'package:cvault/Screens/home/bloc/cubit/home_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_preview/device_preview.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) {
      return MaterialApp(
        useInheritedMediaQuery: true,
        home: MultiBlocProvider(
          providers: [
            BlocProvider(
              lazy: false,
              create: (context) => HomeCubit(),
            ),
            BlocProvider(
              lazy: false,
              create: (context) => ProfileCubit(),
            ),
          ],
          child: MaterialApp(
            useInheritedMediaQuery: true,
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            debugShowCheckedModeBanner: false,
            home: FirebaseAuth.instance.currentUser != null
                ? const HomePage()
                : const UserTypeSelectPage(),
          ),
        ),
      );
    },
  ));
}
