import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tdd_clean_architecture/core/error/failures.dart';
import 'package:tdd_clean_architecture/features/number_trivia/presentation/utils/input_converter.dart';
import 'package:tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:tdd_clean_architecture/features/number_trivia/presentation/utils/state_status.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CATCH_FAILURE_MESSAGE = 'Catch Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcretNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcretNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(NumberTriviaState()) {
    on<NumberTriviaEvent>((event, emit) async {
      switch (event) {
        case GetTriviaForConcreteNumber():
          emit(state.copyWith(status: StateStatus.LOADING));
          final inputEither =
              inputConverter.stringToUnsignedInteger(event.numberString);
          await inputEither.fold(
              (failure) async => emit(state.copyWith(
                  status: StateStatus.ERROR,
                  errorMessage: _mapFailureMessage(failure))), (integer) async {
            final failureOrSuccess =
                await getConcretNumberTrivia(Params(number: integer));
            _eitherLoadedOrErrorState(emit, state, failureOrSuccess);
          });
          break;
        case GetTriviaForRandom():
          emit(state.copyWith(status: StateStatus.LOADING));
          final failureOrSuccess = await getRandomNumberTrivia(NoParams());
          _eitherLoadedOrErrorState(emit, state, failureOrSuccess);
          break;
      }
    });
  }

  String _mapFailureMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CatchFailure:
        return CATCH_FAILURE_MESSAGE;
      case InvalidInputFailure:
        return INVALID_INPUT_FAILURE_MESSAGE;
      default:
        return 'Anonim Exception';
    }
  }

  void _eitherLoadedOrErrorState(
      Emitter<NumberTriviaState> emit,
      NumberTriviaState state,
      Either<Failure, NumberTrivia> failureOrSuccess) async {
    failureOrSuccess.fold(
      (failure) async => emit(state.copyWith(
          status: StateStatus.ERROR,
          errorMessage: _mapFailureMessage(failure))),
      (trivia) async => emit(state.copyWith(
          status: StateStatus.LOADER,
          number: trivia.number,
          text: trivia.text)),
    );
  }
}
