
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_clean_architecture/core/error/exceptions.dart';
import 'package:tdd_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<NumberTriviaModel> getConcreteNumberFromCatch(int number);
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCatch);
  /** Future<void> catchNumberTrivia(NumberTriviaModel triviaToCatch): **/
}

final CATCHED_NUMBER_TRIVIA = 'CATCHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCatch) async {
    sharedPreferences.setString(CATCHED_NUMBER_TRIVIA, jsonEncode(triviaToCatch.toJson()));
    sharedPreferences.setString("$CATCHED_NUMBER_TRIVIA${triviaToCatch.number}", jsonEncode(triviaToCatch.toJson()));
  }



  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CATCHED_NUMBER_TRIVIA);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(jsonDecode(jsonString)));
    } else {
      throw CatchException();
    }
  }

  @override
  Future<NumberTriviaModel> getConcreteNumberFromCatch(int number) {
    final jsonString = sharedPreferences.getString("${CATCHED_NUMBER_TRIVIA}$number");
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(jsonDecode(jsonString)));
    } else {
      final jsonStrings = sharedPreferences.getString(CATCHED_NUMBER_TRIVIA);
      if (jsonStrings != null) {
        return Future.value(NumberTriviaModel.fromJson(jsonDecode(jsonStrings)));
      } else {
        throw CatchException();
      }
    }
  }

}
