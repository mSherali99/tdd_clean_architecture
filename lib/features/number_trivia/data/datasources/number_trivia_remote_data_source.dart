
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tdd_clean_architecture/core/error/exceptions.dart';

import 'package:tdd_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumber(int number);
  Future<NumberTriviaModel> getRandomNumber();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {

  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumber(int number) =>
      _getTriviaFromUrl(Uri.parse("http://numbersapi.com/$number"));

  @override
  Future<NumberTriviaModel> getRandomNumber() => 
      _getTriviaFromUrl(Uri.parse('http://numbersapi.com/#random'));

  Future<NumberTriviaModel> _getTriviaFromUrl(Uri uri) async {
    final response = await client.get(uri, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }
}