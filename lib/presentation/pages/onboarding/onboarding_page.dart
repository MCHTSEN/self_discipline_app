import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/presentation/viewmodels/onboarding_provider.dart';
import 'package:self_discipline_app/presentation/viewmodels/onboarding_navigation_provider.dart';

@RoutePage()
class OnboardingPage extends ConsumerStatefulWidget {
  final List<Widget> pages;
  final List<bool>? showBackButtons;
  final List<bool>? showNextButtons;
  final VoidCallback? onComplete;

  const OnboardingPage({
    Key? key,
    required this.pages,
    this.showBackButtons,
    this.showNextButtons,
    this.onComplete,
  }) : super(key: key);

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  @override
  void initState() {
    super.initState();
    // Use post-frame callback to initialize the provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(onboardingNavigationProvider.notifier)
          .initialize(widget.pages.length);
    });
  }

  bool _shouldShowBackButton(int pageIndex) {
    return widget.showBackButtons?.elementAtOrNull(pageIndex) ?? true;
  }

  bool _shouldShowNextButton(int pageIndex) {
    return widget.showNextButtons?.elementAtOrNull(pageIndex) ?? true;
  }

  void _handleNextPage() {
    final currentPage = ref.read(onboardingNavigationProvider).currentPage;
    if (currentPage < widget.pages.length - 1) {
      ref.read(onboardingNavigationProvider.notifier).goToNextPage();
    } else {
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAnimationComplete = ref.watch(onboardingAnimationProvider);
    final navigationState = ref.watch(onboardingNavigationProvider);
    final currentPage = navigationState.currentPage;

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: navigationState.pageController,
            itemCount: widget.pages.length,
            onPageChanged: (index) => ref
                .read(onboardingNavigationProvider.notifier)
                .setCurrentPage(index),
            itemBuilder: (context, index) => widget.pages[index],
          ),
          if (_shouldShowBackButton(currentPage) && isAnimationComplete)
            Positioned(
              left: 16,
              bottom: 32,
              child: FloatingActionButton(
                heroTag: 'previous',
                onPressed: ref
                    .read(onboardingNavigationProvider.notifier)
                    .goToPreviousPage,
                backgroundColor: Theme.of(context).primaryColor,
                shape: const CircleBorder(),
                child: const Icon(Icons.arrow_back),
              ),
            ),
          if (_shouldShowNextButton(currentPage) && isAnimationComplete)
            Positioned(
              right: 16,
              bottom: 32,
              child: FloatingActionButton(
                heroTag: 'next',
                onPressed: _handleNextPage,
                backgroundColor: Theme.of(context).primaryColor,
                shape: const CircleBorder(),
                child: Icon(
                  currentPage < widget.pages.length - 1
                      ? Icons.arrow_forward
                      : Icons.check,
                ),
              ),
            ),
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: currentPage == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: currentPage == index
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).primaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
