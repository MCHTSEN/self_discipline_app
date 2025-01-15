import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/presentation/viewmodels/identify_notifier.dart';

@RoutePage()
class IdentifyPage extends ConsumerWidget {
  final VoidCallback? onComplete;

  const IdentifyPage({
    super.key,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(identifyProvider);
    final currentPage = state.pages[state.currentPageIndex];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: () {
              // Handle "Skip"
            },
            child: const Text(
              "Skip",
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
      backgroundColor: Color.fromARGB(255, 246, 246, 246),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),

              // Progress indicator
              LinearProgressIndicator(
                value: (state.currentPageIndex + 1) / state.pages.length,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
              ),

              const Spacer(),

              // Title
              Text(
                currentPage.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                currentPage.subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Answers (multi-select)
              Expanded(
                child: ListView.builder(
                  itemCount: currentPage.answers.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final isSelected =
                        state.selectedAnswers[state.currentPageIndex][index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: ElevatedButton(
                          onPressed: () {
                            ref.read(identifyProvider.notifier).toggleAnswer(
                                  state.currentPageIndex,
                                  index,
                                );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isSelected ? Colors.black : Colors.white,
                            foregroundColor:
                                isSelected ? Colors.white : Colors.black,
                            elevation: 0,
                            side: BorderSide(
                              color:
                                  isSelected ? Colors.black : Colors.grey[300]!,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  currentPage.answers[index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check_circle_outline,
                                    size: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Note at the bottom of the list
              Text(
                "Your choices won't limit access to any features of the app.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Next button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () =>
                      ref.read(identifyProvider.notifier).goToNextPage(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    state.currentPageIndex < state.pages.length - 1
                        ? "Next"
                        : "Finish",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
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
