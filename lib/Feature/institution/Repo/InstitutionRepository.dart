import '../../../core/Models/institutionModel.dart';
import '../../../core/Services/Supabase/institutionServices.dart';

class InstitutionRepository {
  final InstitutionService _service;

  InstitutionRepository(this._service);

  Future<List<InstitutionModel>> getInstitutions() async {
    try {
      final rawData = await _service.fetchInstitutions();
      // Map the raw JSON list to your Model
      return rawData.map((json) => InstitutionModel.fromJson(json)).toList();
    } catch (e) {
      // You can implement custom error handling/logging here
      throw Exception('Failed to fetch institutions: $e');
    }
  }
  Future<void> addInstitution(InstitutionModel institution) async {
    try {
      await _service.createInstitution(institution.toJson());
    } catch (e) {
      throw Exception('Failed to add institution: $e');
    }
  }
  Future<void> updateInstitution(String id, InstitutionModel institution) async {
    try {
      await _service.updateInstitution(id, institution.toJson());
    }catch(e){
      throw Exception('Failed to update institution: $e');
    }
  }



  Future<void> removeInstitution(String id) async {
    try {
      await _service.deleteInstitution(id);
    } catch (e) {
      throw Exception('Failed to delete institution: $e');
    }
  }
}