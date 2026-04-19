import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/Models/ServicesModel.dart';
import '../../Repo/ServiceRepo.dart';
part 'service_state.dart';

class ServiceCubit extends Cubit<ServiceState> {
  final ServiceRepository _repository;

  StreamSubscription<List<ServiceModel>>? _servicesSubscription;

  ServiceCubit(this._repository) : super(ServiceInitial());

  // ─── CREATE ─────────────────────────────────────────────────────────────────

  Future<void> createService(ServiceModel service) async {
    _emitActionLoading();
    try {
      final created = await _repository.createService(service);
      emit(ServiceCreated(created));
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }

  // ─── READ ───────────────────────────────────────────────────────────────────

  Future<void> loadAllServices() async {
    emit(ServiceLoading());
    try {
      final services = await _repository.getAllServices();
      emit(ServicesLoaded(services));
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }

  Future<void> loadServiceById(String id) async {
    emit(ServiceLoading());
    try {
      final service = await _repository.getServiceById(id);
      if (service == null) {
        emit(ServiceError('Service not found.'));
      } else {
        emit(ServiceLoaded(service));
      }
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }

  Future<void> loadServicesByInstitution(String institutionId) async {
    emit(ServiceLoading());
    try {
      final services =
      await _repository.getServicesByInstitution(institutionId);
      emit(ServicesLoaded(services));
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }

  Future<void> loadServicesByCategory(String category) async {
    emit(ServiceLoading());
    try {
      final services = await _repository.getServicesByCategory(category);
      emit(ServicesLoaded(services));
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }

  Future<void> loadFreeServices() async {
    emit(ServiceLoading());
    try {
      final services = await _repository.getFreeServices();
      emit(ServicesLoaded(services));
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }

  Future<void> searchServices(String query) async {
    emit(ServiceLoading());
    try {
      final services = await _repository.searchServices(query);
      emit(ServicesLoaded(services));
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }

  // ─── UPDATE ─────────────────────────────────────────────────────────────────

  Future<void> updateService(ServiceModel service) async {
    _emitActionLoading();
    try {
      final updated = await _repository.updateService(service);
      emit(ServiceUpdated(updated));
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }

  Future<void> toggleServiceStatus(String id, bool isActive) async {
    _emitActionLoading();
    try {
      final updated = await _repository.toggleServiceStatus(id, isActive);
      emit(ServiceUpdated(updated));
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }

  // ─── DELETE ─────────────────────────────────────────────────────────────────

  Future<void> deleteService(String id) async {
    _emitActionLoading();
    try {
      await _repository.deleteService(id);
      emit(ServiceDeleted(id));
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }

  // ─── REALTIME ───────────────────────────────────────────────────────────────

  void watchServicesByInstitution(String institutionId) {
    emit(ServiceLoading());
    _servicesSubscription?.cancel();
    _servicesSubscription = _repository
        .watchServicesByInstitution(institutionId)
        .listen(
          (services) => emit(ServicesLoaded(services)),
      onError: (e) => emit(ServiceError(e.toString())),
    );
  }

  void stopWatching() {
    _servicesSubscription?.cancel();
    _servicesSubscription = null;
  }

  // ─── HELPERS ────────────────────────────────────────────────────────────────

  void _emitActionLoading() {
    final current = state;
    if (current is ServicesLoaded) {
      emit(ServiceActionLoading(current.services));
    } else {
      emit(ServiceLoading());
    }
  }

  // ─── DISPOSE ────────────────────────────────────────────────────────────────

  @override
  Future<void> close() {
    _servicesSubscription?.cancel();
    return super.close();
  }
}