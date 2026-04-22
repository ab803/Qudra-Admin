import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/Models/DashboardModel.dart';
import '../Repo/repo.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _repo;

  DashboardCubit(this._repo) : super(DashboardInitial());

  Future<void> loadStats() async {
    emit(DashboardLoading());
    try {
      final stats = await _repo.fetchStats();
      emit(DashboardLoaded(stats));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}