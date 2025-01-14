import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/presentation/viewmodels/onboarding_provider.dart';

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
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool _shouldShowBackButton(int pageIndex) {
    return widget.showBackButtons?.elementAtOrNull(pageIndex) ?? true;
  }

  bool _shouldShowNextButton(int pageIndex) {
    return widget.showNextButtons?.elementAtOrNull(pageIndex) ?? true;
  }

  void goToNextPage() {
    if (_currentPage < widget.pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onComplete?.call();
    }
  }

  void goToPreviousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAnimationComplete = ref.watch(onboardingAnimationProvider);

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.pages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) => widget.pages[index],
          ),
          if (_shouldShowBackButton(_currentPage) && isAnimationComplete)
            Positioned(
              left: 16,
              bottom: 32,
              child: FloatingActionButton(
                heroTag: 'previous',
                onPressed: goToPreviousPage,
                backgroundColor: Theme.of(context).primaryColor,
                shape: const CircleBorder(),
                child: const Icon(Icons.arrow_back),
              ),
            ),
          if (_shouldShowNextButton(_currentPage) && isAnimationComplete)
            Positioned(
              right: 16,
              bottom: 32,
              child: FloatingActionButton(
                heroTag: 'next',
                onPressed: goToNextPage,
                backgroundColor: Theme.of(context).primaryColor,
                shape: const CircleBorder(),
                child: Icon(
                  _currentPage < widget.pages.length - 1
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
                  width: _currentPage == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
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
