import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  Timer? _timer;
  double _latestCpuUsage = 0.0;
  double _latestRamUsage = 0.0;

  ServiceBloc() : super(ServiceInitial()) {
    on<RunServiceEvent>(_onRunServiceEvent);
    on<UpdateServiceDataEvent>(_onUpdateServiceDataEvent);
  }

  Future<void> _onRunServiceEvent(RunServiceEvent event, Emitter<ServiceState> emit) async {
    emit(ServiceLoading());

    // Start continuous data fetching
    _fetchDataContinuously();

    // Emit initial state immediately
    emit(ServiceLoaded(cpuUsage: _latestCpuUsage, ramUsage: _latestRamUsage));
  }

  Future<void> _fetchDataContinuously() async {
    while (true) {
      try {
        final socket = await Socket.connect('127.0.0.1', 8080);
        socket.write('Request Data');

        await for (var data in socket) {
          final response = String.fromCharCodes(data);
          final parsedResponse = jsonDecode(response);
          print(response);
          _latestCpuUsage = parsedResponse['cpu_usage'];
          _latestRamUsage = parsedResponse['ram_usage'];

          // Add a new event to update the state
          add(UpdateServiceDataEvent(cpuUsage: _latestCpuUsage, ramUsage: _latestRamUsage));
        }
      } catch (e) {
        print(e);
        add(ServiceErrorEvent(error: e.toString()));
      } finally {
        await Future.delayed(Duration(seconds: 5));  // Delay before next fetch
      }
    }
  }

  Future<void> _onUpdateServiceDataEvent(UpdateServiceDataEvent event, Emitter<ServiceState> emit) async {
    // Emit the new data
    emit(ServiceLoaded(cpuUsage: event.cpuUsage, ramUsage: event.ramUsage));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

// Define an event for updating service data
class UpdateServiceDataEvent extends ServiceEvent {
  final double cpuUsage;
  final double ramUsage;

  UpdateServiceDataEvent({required this.cpuUsage, required this.ramUsage});

  @override
  List<Object> get props => [cpuUsage, ramUsage];
}

// Define an event for handling errors
class ServiceErrorEvent extends ServiceEvent {
  final String error;

  ServiceErrorEvent({required this.error});

  @override
  List<Object> get props => [error];
}
