import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingNavigationState {
  final PageController pageController;
  final int currentPage;
  final int totalPages;

  OnboardingNavigationState({
    required this.pageController,
    this.currentPage = 0,
    required this.totalPages,
  });

  OnboardingNavigationState copyWith({
    PageController? pageController,
    int? currentPage,
    int? totalPages,
  }) {
    return OnboardingNavigationState(
      pageController: pageController ?? this.pageController,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

class OnboardingNavigationNotifier
    extends StateNotifier<OnboardingNavigationState> {
  OnboardingNavigationNotifier()
      : super(OnboardingNavigationState(
          pageController: PageController(),
          totalPages: 0,
        ));

  void initialize(int totalPages) {
    state = OnboardingNavigationState(
      pageController: PageController(),
      totalPages: totalPages,
    );
  }

  void setCurrentPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  void goToNextPage() {
    if (state.currentPage < state.totalPages - 1) {
      state.pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToPreviousPage() {
    state.pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    state.pageController.dispose();
    super.dispose();
  }
}

final onboardingNavigationProvider = StateNotifierProvider<
    OnboardingNavigationNotifier,
    OnboardingNavigationState>((ref) => OnboardingNavigationNotifier());
