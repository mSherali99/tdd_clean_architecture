import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neumorphic_button/neumorphic_button.dart';
import 'package:tdd_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:tdd_clean_architecture/features/number_trivia/presentation/utils/state_status.dart';
import 'package:tdd_clean_architecture/features/number_trivia/presentation/utils/width_height.dart';
import 'package:tdd_clean_architecture/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:tdd_clean_architecture/injection_container/injection_container.dart';

class NumberTriviaPage extends StatefulWidget {
  const NumberTriviaPage({super.key});

  @override
  State<NumberTriviaPage> createState() => _NumberTriviaPageState();
}

class _NumberTriviaPageState extends State<NumberTriviaPage> {
  late final NumberTriviaBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = sl<NumberTriviaBloc>();
  }

  @override
  void dispose() {
    super.dispose();
    bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "TDD app",
          style: TextStyle(
              color: Colors.black,
              fontFamily: "GameFamily",
              fontSize: wd(context) * 0.08,
              fontWeight: FontWeight.w800),
        ),
      ),
      body: BlocProvider.value(
        value: bloc,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                    builder: (BuildContext context, NumberTriviaState state) {
                      if (state.status == StateStatus.EMPTY) {
                        return MessageDisplay(
                          message: "Start searching",
                          color: Colors.grey,
                        );
                      } else if (state.status == StateStatus.ERROR) {
                        return MessageDisplay(
                            message: state.errorMessage, color: Colors.black);
                      } else if (state.status == StateStatus.LOADING) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return MessageDisplay(
                        message: state.text,
                        color: Colors.green.shade700,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const TriviaControlState(),
            ],
          ),
        ),
      ),
    );
  }
}

class TriviaControlState extends StatefulWidget {
  const TriviaControlState({super.key});

  @override
  State<TriviaControlState> createState() => _TriviaControlStateState();
}

class _TriviaControlStateState extends State<TriviaControlState> {
  String inputText = "";
  bool isError = false;
  final controller = TextEditingController();

  void _dispatchConcrete() {
    debugPrint(
        "${wd(context)}----------------------width---------------------");
    debugPrint(
        "${hg(context)}----------------------height---------------------");
    if (controller.text.isEmpty) {
      setState(() {
        isError = true;
      });
    } else {
      setState(() {
        isError = false;
        controller.clear();
        BlocProvider.of<NumberTriviaBloc>(context).add(
          GetTriviaForConcreteNumber(numberString: inputText),
        );
      });
    }
  }

  void _dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).add(
      GetTriviaForRandom(),
    );
  }

  // width  = 411.42857142857144
  // height = 899.4285714285714

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NeumorphicButton(
          onTap: _dispatchConcrete,
          backgroundColor: Colors.grey.shade200,
          topLeftShadowColor: Colors.white,
          bottomRightShadowColor: Colors.grey.shade500,
          height: hg(context) * 0.08,
          width: double.infinity,
          child: Center(
            child: TextField(
              controller: controller,
              onChanged: (value) {
                inputText = value;
              },
              decoration: InputDecoration(
                border: const UnderlineInputBorder(borderSide: BorderSide.none),
                hintText:
                    isError ? "Please enter a number..." : "Input a number!",
                hintStyle:
                    TextStyle(color: isError ? Colors.redAccent : Colors.grey),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                signed: false,
              ),
              style: TextStyle(
                fontFamily: "GameFamily",
                fontSize: wd(context) * 0.05,
              ),
              keyboardAppearance: Brightness.light,
            ),
          ),
        ),
        SizedBox(height: hg(context) * 0.01),
        Row(
          children: [
            SizedBox(width: wd(context) * 0.05),
            Expanded(
              child: NeumorphicButton(
                onTap: _dispatchConcrete,
                backgroundColor: Colors.green,
                topLeftShadowColor: Colors.white,
                bottomRightShadowColor: Colors.grey.shade500,
                height: hg(context) * 0.065,
                width: wd(context) * 0.45,
                child: Center(
                  child: Text(
                    "Search",
                    style: TextStyle(
                        fontFamily: "GameFamily",
                        fontSize: wd(context) * 0.045,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            SizedBox(width: wd(context) * 0.05),
            Expanded(
              child: NeumorphicButton(
                onTap: _dispatchRandom,
                backgroundColor: Colors.yellow.shade300,
                topLeftShadowColor: Colors.white,
                bottomRightShadowColor: Colors.grey.shade500,
                height: hg(context) * 0.065,
                width: wd(context) * 0.45,
                child: Center(
                  child: Text(
                    "Random",
                    style: TextStyle(
                        fontFamily: "GameFamily",
                        fontSize: wd(context) * 0.045,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            SizedBox(width: wd(context) * 0.05),
          ],
        )
      ],
    );
  }
}
