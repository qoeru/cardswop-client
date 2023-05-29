import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:cardswop/app/bloc/cubit/auth_cubit.dart';
import 'package:cardswop/app/widgets/auth/reg_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  setUrlStrategy(PathUrlStrategy());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => AuthCubit(),
        ),
        // BlocProvider(
        //   create: (context) => NavigationCubit()..onStartUpNavigation(),
        // ),
        // BlocProvider(
        //   create: (context) => AddingCardCubit(),
        // ),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const AntApp(
      home: RegWidget(),
    );
  }
}
