part of 'service_bloc.dart';

@immutable
sealed class ServiceEvent {}

final class RunServiceEvent extends ServiceEvent {}


