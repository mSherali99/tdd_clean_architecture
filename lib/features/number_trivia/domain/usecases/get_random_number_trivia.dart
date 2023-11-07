
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_clean_architecture/core/error/failures.dart';
import 'package:tdd_clean_architecture/core/usecases/usecase.dart';
import 'package:tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_clean_architecture/features/number_trivia/domain/repositorys/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {

  final NumberTriviaRepository repository;

  GetRandomNumberTrivia({required this.repository});

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams noParams) async {
    return await repository.getRandomNumber();
  }
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
