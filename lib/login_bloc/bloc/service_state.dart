part of 'service_bloc.dart';


@immutable
sealed class ServiceState extends Equatable{
 

 const ServiceState();

  @override
  List<Object> get props => [];
}

final class ServiceInitial extends ServiceState {}

final class ServiceLoading extends ServiceState{}

class ServiceLoaded extends ServiceState{
  final double cpuUsage;
  final double ramUsage;

  ServiceLoaded({required this.cpuUsage, required this.ramUsage});

  @override
  List<Object> get props => [cpuUsage, ramUsage];
}

final class ServiceError extends ServiceState{
  final String error;

 const ServiceError({required this.error});
}
