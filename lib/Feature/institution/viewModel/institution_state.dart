import '../../../core/Models/institutionModel.dart';

abstract class InstitutionState {}

class InstitutionInitial extends InstitutionState {}

class InstitutionLoading extends InstitutionState {}

class InstitutionLoaded extends InstitutionState {
  final List<InstitutionModel> institutions;
  InstitutionLoaded(this.institutions);
}

class InstitutionError extends InstitutionState {
  final String message;
  InstitutionError(this.message);
}