import 'package:admin_qudra/Feature/subscribtions/viewModel/bundle_cubit.dart';
import 'package:admin_qudra/core/Services/Supabase/BundleService.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../Feature/institution/Repo/InstitutionRepository.dart';
import '../../Feature/institution/Repo/ServiceRepo.dart';
import '../../Feature/institution/viewModel/institution_cubit.dart';
import '../../Feature/institution/viewModel/serviceViewModel/service_cubit.dart';
import '../../Feature/subscribtions/repo/bundle_repository.dart';
import '../Services/Supabase/institutionServices.dart';
import '../Services/Supabase/services.dart';

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
}