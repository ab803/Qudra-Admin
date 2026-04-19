import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/Models/institutionModel.dart';
import '../Repo/InstitutionRepository.dart';
import 'institution_state.dart';

class InstitutionCubit extends Cubit<InstitutionState> {
  final InstitutionRepository _repository;

  InstitutionCubit(this._repository) : super(InstitutionInitial());

  // 🔹 Load all institutions
  Future<void> loadInstitutions() async {
    emit(InstitutionLoading());
    try {
      final institutions = await _repository.getInstitutions();
      emit(InstitutionLoaded(institutions));
    } catch (e) {
      emit(InstitutionError(e.toString()));
    }
  }

  // 🔹 Add new institution
  Future<void> addInstitution(InstitutionModel institution) async {
    try {
      await _repository.addInstitution(institution);
      await loadInstitutions(); // 🔥 refresh
    } catch (e) {
      emit(InstitutionError(e.toString()));
    }
  }

  // 🔹 Update institution (مثلاً تغيير status)
  Future<void> updateInstitution(String id, InstitutionModel institution) async {
    try {
      await _repository.updateInstitution(id, institution);
      await loadInstitutions(); // 🔥 مهم جدًا
    } catch (e) {
      emit(InstitutionError(e.toString()));
    }
  }

  // 🔹 Delete institution
  Future<void> deleteInstitution(String id) async {
    try {
      await _repository.removeInstitution(id);
      await loadInstitutions(); // 🔥 refresh
    } catch (e) {
      emit(InstitutionError(e.toString()));
    }
  }
}