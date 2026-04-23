import 'package:admin_qudra/Feature/subscribtions/viewModel/bundle_cubit.dart';
import 'package:admin_qudra/core/Services/Supabase/BundleService.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../Feature/Auth/repo/AuthRepo.dart';
import '../../Feature/Auth/viewModel/auth_cubit.dart';
import '../../Feature/Dashboard/Repo/repo.dart';
import '../../Feature/Dashboard/viewModel/dashboard_cubit.dart';
import '../../Feature/Rights&tips/repo/Rights&tipsRepo.dart';
import '../../Feature/Rights&tips/viewModel/right_tips_cubit.dart';
import '../../Feature/institution/Repo/InstitutionRepository.dart';
import '../../Feature/institution/Repo/ServiceRepo.dart';
import '../../Feature/institution/viewModel/institution_cubit.dart';
import '../../Feature/institution/viewModel/serviceViewModel/service_cubit.dart';
import '../../Feature/subscribtions/repo/bundle_repository.dart';
import '../../Feature/user/repo/bookingRepo.dart';
import '../../Feature/user/repo/repo.dart';
import '../../Feature/user/viewModel/booking_cubit.dart';
import '../../Feature/user/viewModel/user__cubit.dart';
import '../Services/Supabase/Authservice.dart';
import '../Services/Supabase/DashboardService.dart';
import '../Services/Supabase/bookingService.dart';
import '../Services/Supabase/institutionServices.dart';
import '../Services/Supabase/services.dart';
import '../Services/Supabase/tips&rightsService.dart';
import '../Services/Supabase/userService.dart';

final GetIt getIt = GetIt.instance;

void setupLocater() {
  getIt.registerLazySingleton<SupabaseClient>(
        () => Supabase.instance.client,
  );

  getIt.registerLazySingleton<InstitutionService>(
        () => InstitutionService(getIt()),
  );
  getIt.registerLazySingleton<ServiceService>(
        () => ServiceService(getIt()),
  );
  getIt.registerLazySingleton <BundleService>(
        () => BundleService(getIt()),
  );

  getIt.registerLazySingleton<InstitutionRepository>(
        () => InstitutionRepository(getIt<InstitutionService>()),
  );
  getIt.registerLazySingleton<ServiceRepository>(
        () => ServiceRepository(getIt<ServiceService>()),
  );
  getIt.registerLazySingleton<BundleRepository>(
        () => BundleRepository(getIt<BundleService>()),
  );

  getIt.registerFactory<InstitutionCubit>(
        () => InstitutionCubit(getIt<InstitutionRepository>()),
  );
  getIt.registerFactory<ServiceCubit>(
        () => ServiceCubit(getIt<ServiceRepository>()),
  );
  getIt.registerFactory<BundleCubit>(()=>BundleCubit(getIt<BundleRepository>()));

  // Services
  getIt.registerLazySingleton<RightstipsService>(
        () => RightstipsService(getIt<SupabaseClient>()),
  );

// Repositories
  getIt.registerLazySingleton<RightstipsRepository>(
        () => RightstipsRepository(getIt<RightstipsService>()),
  );

// Cubits — factory so each screen gets a fresh instance
  getIt.registerFactory<RightstipsCubit>(
        () => RightstipsCubit(getIt<RightstipsRepository>()),
  );


  getIt.registerLazySingleton<AuthService>(
        () => AuthService(Supabase.instance.client),
  );

  getIt.registerLazySingleton<AuthRepo>(
        () => AuthRepo(getIt<AuthService>()),
  );

  // Factory so a fresh cubit is created per route
  getIt.registerFactory<AuthCubit>(
        () => AuthCubit(getIt<AuthRepo>()),
  );

  // In your service_locator.dart

  getIt.registerLazySingleton<DashboardService>(
        () => DashboardService(Supabase.instance.client),
  );

  getIt.registerLazySingleton<DashboardRepository>(
        () => DashboardRepository(getIt<DashboardService>()),
  );

  getIt.registerFactory<DashboardCubit>(
        () => DashboardCubit(getIt<DashboardRepository>()),
  );

  getIt.registerLazySingleton<UserService>(
        () => UserService(Supabase.instance.client),
  );

  getIt.registerLazySingleton<UserRepository>(
        () => UserRepositoryImpl(getIt<UserService>()),
  );

  // Factory so each screen gets a fresh cubit
  getIt.registerFactory<UserCubit>(
        () => UserCubit(getIt<UserRepository>()),
  );

  // Register service & repository (singletons, like your other services)
  getIt.registerLazySingleton<BookingService>(
        () => BookingService(getIt<SupabaseClient>()),
  );
  getIt.registerLazySingleton<BookingRepository>(
        () => BookingRepository(getIt<BookingService>()),
  );

// Register cubit as a FACTORY (new instance per navigation)
  getIt.registerFactory<BookingCubit>(
        () => BookingCubit(getIt<BookingRepository>()),
  );


}