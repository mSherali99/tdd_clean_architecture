part of 'number_trivia_bloc.dart';

@immutable
class NumberTriviaState extends Equatable{
  final StateStatus status;
  final String text;
  final int number;
  final String errorMessage;

  const NumberTriviaState({
    this.status = StateStatus.EMPTY,
    this.text = "",
    this.number = 0,
    this.errorMessage = ""
});

  NumberTriviaState copyWith({StateStatus? status, String? text, int? number, String? errorMessage}) {
    return NumberTriviaState(
      status: status ?? this.status,
      text: text ?? this.text,
      number: number ?? this.number,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }

  @override
  List<Object?> get props => [status, text, errorMessage];

}

