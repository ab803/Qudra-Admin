import '../../../core/Models/ServicesModel.dart';
import '../../../core/Services/Supabase/services.dart';


class ServiceRepository {
  final ServiceService _serviceService;

  ServiceRepository(this._serviceService);

  // ─── CREATE ───────────────────────────────────────────────────────────────

  Future<ServiceModel> createService(ServiceModel service) async {
    try {
      return await _serviceService.createService(service);
    } catch (e) {
      throw _handleException('createService', e);
    }
  }

  // ─── READ ─────────────────────────────────────────────────────────────────

  Future<ServiceModel?> getServiceById(String id) async {
    try {
      return await _serviceService.getServiceById(id);
    } catch (e) {
      throw _handleException('getServiceById', e);
    }
  }

  Future<List<ServiceModel>> getAllServices() async {
    try {
      return await _serviceService.getAllServices();
    } catch (e) {
      throw _handleException('getAllServices', e);
    }
  }

  Future<List<ServiceModel>> getServicesByInstitution(
      String institutionId) async {
    try {
      return await _serviceService.getServicesByInstitution(institutionId);
    } catch (e) {
      throw _handleException('getServicesByInstitution', e);
    }
  }

  Future<List<ServiceModel>> getServicesByCategory(String category) async {
    try {
      return await _serviceService.getServicesByCategory(category);
    } catch (e) {
      throw _handleException('getServicesByCategory', e);
    }
  }

  Future<List<ServiceModel>> getFreeServices() async {
    try {
      return await _serviceService.getFreeServices();
    } catch (e) {
      throw _handleException('getFreeServices', e);
    }
  }

  Future<List<ServiceModel>> searchServices(String query) async {
    try {
      if (query.trim().isEmpty) return await getAllServices();
      return await _serviceService.searchServices(query.trim());
    } catch (e) {
      throw _handleException('searchServices', e);
    }
  }

  // ─── UPDATE ───────────────────────────────────────────────────────────────

  Future<ServiceModel> updateService(ServiceModel service) async {
    try {
      return await _serviceService.updateService(service);
    } catch (e) {
      throw _handleException('updateService', e);
    }
  }

  Future<ServiceModel> toggleServiceStatus(String id, bool isActive) async {
    try {
      return await _serviceService.toggleServiceStatus(id, isActive);
    } catch (e) {
      throw _handleException('toggleServiceStatus', e);
    }
  }

  // ─── DELETE ───────────────────────────────────────────────────────────────

  Future<void> deleteService(String id) async {
    try {
      await _serviceService.deleteService(id);
    } catch (e) {
      throw _handleException('deleteService', e);
    }
  }

  // ─── REALTIME ─────────────────────────────────────────────────────────────

  Stream<List<ServiceModel>> watchServicesByInstitution(String institutionId) {
    return _serviceService
        .watchServicesByInstitution(institutionId)
        .handleError((e) => throw _handleException('watchServicesByInstitution', e));
  }

  // ─── EXCEPTION HANDLER ────────────────────────────────────────────────────

  Exception _handleException(String method, Object e) {
    return Exception('ServiceRepository.$method failed: $e');
  }
}