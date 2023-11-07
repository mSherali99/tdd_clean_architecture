part of 'number_trivia_bloc.dart';

@immutable
abstract class NumberTriviaEvent extends Equatable {}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;

  GetTriviaForConcreteNumber({required this.numberString});

  @override
  List<Object?> get props => [numberString];
}


class GetTriviaForRandom extends NumberTriviaEvent {
  @override
  List<Object?> get props => [];
}