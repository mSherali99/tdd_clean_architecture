import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tdd_clean_architecture/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:tdd_clean_architecture/injection_container/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());

  final user1 = User(name: "name", age: 1);
  final user2 = User(name: "name", age: 1);
  final users1 = Users(names: "names", ages: 1);
  final users2 = Users(names: "names", ages: 1);
  debugPrint("${user1 == user2}   -------------- User class");
  debugPrint("${users1 == users2}   -------------- Users class");

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const NumberTriviaPage(),
    );
  }
}

class User extends Equatable {
  String name;
  int age;

  User({required this.name, required this.age});

  @override
  List<Object?> get props => [name, age];
}


class Users {
  String names;
  int ages;
  Users({required this.names, required this.ages});
}