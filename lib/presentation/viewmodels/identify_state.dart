import 'package:freezed_annotation/freezed_annotation.dart';

part 'identify_state.freezed.dart';

@freezed
class IdentifyState with _$IdentifyState {
  const factory IdentifyState({
    required int currentPageIndex,
    required List<List<bool>> selectedAnswers,
    required List<UserIdentifyModel> pages,
  }) = _IdentifyState;

  factory IdentifyState.initial() => IdentifyState(
        currentPageIndex: 0,
        selectedAnswers: [],
        pages: [
          UserIdentifyModel(
            title: "What are your goals?",
            subtitle: "Select all that apply to you",
            answers: [
              "Improve productivity",
              "Build better habits",
              "Reduce stress",
              "Increase focus",
            ],
          ),
          UserIdentifyModel(
            title: 'What do you do for fun?',
            subtitle: 'Select all that apply to you',
            answers: [
              "Reading",
              "Watching movies",
              "Playing games",
              "Going out with friends",
            ],
          ),
        ],
      );
}

class UserIdentifyModel {
  final String title;
  final String subtitle;
  final List<String> answers;

  UserIdentifyModel({
    required this.title,
    required this.subtitle,
    required this.answers,
  });
}
