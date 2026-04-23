import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../Feature/Auth/Login/Loginview.dart';
import '../../Feature/Auth/viewModel/auth_cubit.dart';
import '../../Feature/Dashboard/DashboardView.dart';
import '../../Feature/Rights&tips/Rights&tipsView.dart';
import '../../Feature/Rights&tips/repo/Rights&tipsRepo.dart';
import '../../Feature/Rights&tips/viewModel/right_tips_cubit.dart';
import '../../Feature/institution/institution.dart';
import '../../Feature/institution/widgets/ServiceWidgets/ServiceDetials.dart';
import '../../Feature/institution/widgets/Viewservices.dart';
import '../../Feature/institution/widgets/institutionDetials.dart';
import '../../Feature/subscribtions/repo/bundle_repository.dart';
import '../../Feature/subscribtions/subscribtionsView.dart';
import '../../Feature/subscribtions/viewModel/bundle_cubit.dart';
import '../../Feature/subscribtions/widgets/AddBundle.dart';
import '../../Feature/subscribtions/widgets/UbdateBundle.dart';
import '../../Feature/user/view/UserManagement.dart';
import '../../Feature/user/view/bookingView.dart';
import '../../Feature/user/viewModel/booking_cubit.dart';
import '../../Feature/user/viewModel/user__cubit.dart';
import '../Models/BundleModel.dart';
import '../Models/ServicesModel.dart';
import '../Models/institutionModel.dart';
import 'getit.dart';

class AppRouter {

  static final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: "/Dashboard",
        builder: (context, state) => const DashboardView(),
      ),
      GoRoute(
        path: "/institutions",
        builder: (context, state) => const InstitutionManagementView(),
      ),
      GoRoute(
        path: "/subscribtions",
        builder: (context, state) =>
            BlocProvider(
              create: (context) => BundleCubit(getIt<BundleRepository>()),
              child: const SubscribtionView(),
            ),
      ),
      GoRoute(
        path: "/update-bundle",
        builder: (context, state) {
          // We expect the bundle to be passed via 'extra'
          final bundle = state.extra as BundleModel;

          // We wrap this screen in the SAME provider if not global
          return BlocProvider.value(
            value: getIt<BundleCubit>(), // Use your DI instance
            child: UpdateBundleView(bundle: bundle),
          );
        },
      ),
      GoRoute(
          path: "/AddBundle",
          builder: (context, state) {
            return BlocProvider(
              create: (context) => BundleCubit(getIt<BundleRepository>()),
              child: AddBundleView(),
            );
          }
      ),
      GoRoute(
        path: "/institutionDetails",
        builder: (context, state) {
          final institution = state.extra as InstitutionModel;
          return InstitutionDetailsScreen(institution: institution);
        },
      ),
      GoRoute(
        path: '/Service',
        builder: (context, state) {
          final institutionID = state.extra as String;
          return InstitutionalServicesScreen(institutionId: institutionID,);
        },
      ),
      GoRoute(
        path: '/ServiceDetails',
        builder: (context, state) {
          final service = state.extra as ServiceModel;
          return ServiceDetailsView(service: service);
        },
      ),

      GoRoute(
        path: "/tips&rights",
        builder: (context, state) => BlocProvider(
          create: (context) => RightstipsCubit(getIt<RightstipsRepository>()),
          child: const RightstipsView(),
        ),
      ),

      GoRoute(
        path: '/login',
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<AuthCubit>(),
          child: const LoginView(),
        ),
      ),

      GoRoute(
        path: '/users',
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<UserCubit>(),
          child: const UserManagementView(),
        ),
      ),


      GoRoute(
        path: '/users/:userId/bookings',
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          final userName = state.uri.queryParameters['name'];
          return BlocProvider(
            create: (_) => getIt<BookingCubit>(),
            child: BookingView(userId: userId, userName: userName),
          );
        },
      ),


    ],

    errorBuilder: (context, state) =>
    const Scaffold(
      body: Center(child: Text('Page not found')),
    ),
  );


}