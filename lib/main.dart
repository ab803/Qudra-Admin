import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Feature/institution/viewModel/institution_cubit.dart';
import 'Feature/institution/viewModel/serviceViewModel/service_cubit.dart';
import 'core/Utilities/GoRouter.dart';
import 'core/Utilities/getit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://lybzbbgsumqwzmenpvow.supabase.co',
    anonKey: 'sb_publishable_Lnf83gYp257M9DN26sQ0Lg_udB4Rmoq',
  );
  setupLocater();
  runApp(const QudraAdminApp());
}

class QudraAdminApp extends StatelessWidget {
  const QudraAdminApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<InstitutionCubit>()),
        BlocProvider(create: (_) => getIt<ServiceCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Qudra Admin',
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFF7F7F9),
          fontFamily: 'Roboto',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        ),
      ),
    );
  }
}