part of "scan_cubit.dart";

sealed class ScanState extends Equatable {
  const ScanState();
  @override
  List<Object> get props => [];
}

class ScanInitial extends ScanState {}
