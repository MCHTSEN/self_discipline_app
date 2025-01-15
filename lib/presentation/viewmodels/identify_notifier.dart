import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/presentation/viewmodels/identify_state.dart';
import 'package:self_discipline_app/presentation/viewmodels/onboarding_navigation_provider.dart';

final identifyProvider =
    StateNotifierProvider.autoDispose<IdentifyNotifier, IdentifyState>((ref) {
  return IdentifyNotifier(ref);
});

class IdentifyNotifier extends StateNotifier<IdentifyState> {
  final Ref ref;

  IdentifyNotifier(this.ref) : super(IdentifyState.initial()) {
    _initializeAnswers();
  }

  void _initializeAnswers() {
    final pages = state.pages;
    state = state.copyWith(
      selectedAnswers: List.generate(
        pages.length,
        (index) => List.generate(pages[index].answers.length, (_) => false),
      ),
    );
  }

  void toggleAnswer(int pageIndex, int answerIndex) {
    final newAnswers = List<List<bool>>.from(state.selectedAnswers);
    newAnswers[pageIndex][answerIndex] = !newAnswers[pageIndex][answerIndex];
    state = state.copyWith(selectedAnswers: newAnswers);
  }

  void goToNextPage() {
    if (state.currentPageIndex < state.pages.length - 1) {
      state = state.copyWith(currentPageIndex: state.currentPageIndex + 1);
    } else {
      // Handle completion
      final List<Map<String, dynamic>> selectedAnswers = [];

      for (int i = 0; i < state.pages.length; i++) {
        final List<String> selected = [];
        for (int j = 0; j < state.selectedAnswers[i].length; j++) {
          if (state.selectedAnswers[i][j]) {
            selected.add(state.pages[i].answers[j]);
          }
        }
        selectedAnswers.add({
          'question': state.pages[i].title,
          'answers': selected,
        });
      }

      // Save answers or process them as needed
      // TODO: Implement answer processing logic

      ref.read(onboardingNavigationProvider.notifier).goToNextPage();
    }
  }
}
