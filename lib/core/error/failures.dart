
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  List properties;
  Failure([this.properties = const <dynamic>[]]) : super();
}

class ServerFailure extends Failure {
  @override
  List<Object?> get props => [super.properties];
}
class CatchFailure extends Failure {
  @override
  List<Object?> get props => [super.properties];
}
