part of 'service_cubit.dart';

abstract class ServiceState {}

// ─── INITIAL ──────────────────────────────────────────────────────────────────

class ServiceInitial extends ServiceState {}

// ─── LOADING ──────────────────────────────────────────────────────────────────

class ServiceLoading extends ServiceState {}

class ServiceActionLoading extends ServiceState {
  final List<ServiceModel> currentServices;

  ServiceActionLoading(this.currentServices);
}

// ─── SUCCESS ──────────────────────────────────────────────────────────────────

class ServicesLoaded extends ServiceState {
  final List<ServiceModel> services;

  ServicesLoaded(this.services);
}

class ServiceLoaded extends ServiceState {
  final ServiceModel service;

  ServiceLoaded(this.service);
}

class ServiceCreated extends ServiceState {
  final ServiceModel service;

  ServiceCreated(this.service);
}

class ServiceUpdated extends ServiceState {
  final ServiceModel service;

  ServiceUpdated(this.service);
}

class ServiceDeleted extends ServiceState {
  final String serviceId;

  ServiceDeleted(this.serviceId);
}

// ─── ERROR ────────────────────────────────────────────────────────────────────

class ServiceError extends ServiceState {
  final String message;

  ServiceError(this.message);
}