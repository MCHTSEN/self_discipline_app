import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:self_discipline_app/core/router/app_router.dart';
import 'package:self_discipline_app/core/utils/enums/custom_images.dart';
import 'package:self_discipline_app/domain/entities/testimonial_entity.dart';
import 'package:self_discipline_app/core/utils/enums/custom_lottie.dart';
import 'package:self_discipline_app/presentation/widgets/custom_app_bar.dart';
import 'package:lottie/lottie.dart';

@RoutePage()
class SocialProofPage extends StatelessWidget {
  SocialProofPage({super.key});

  final List<TestimonialEntity> testimonials = [
    TestimonialEntity(
      name: 'Richard Anderson',
      photoUrl: CustomImages.person_5.path,
      title: 'Entrepreneur & Fitness Enthusiast',
      description:
          'Built my dream business while maintaining a healthy lifestyle. From struggling with time management to running a successful startup and exercising daily!',
    ),
    TestimonialEntity(
      name: 'Michael Rodriguez',
      photoUrl: CustomImages.person_2.path,
      title: 'Software Engineer',
      description:
          'Learned 3 new programming languages in 6 months by dedicating just 1 hour daily. Small steps led to a 40% salary increase!',
    ),
    TestimonialEntity(
      name: 'David Thompson',
      photoUrl: CustomImages.person_3.path,
      title: 'Author & Public Speaker',
      description:
          'Wrote my first book by writing 500 words daily. Now published and helping others achieve their dreams through motivational speaking.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Success Stories'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInspirationHeader(context),
            const SizedBox(height: 24),
            _buildAchievementMetrics(context),
            const SizedBox(height: 24),
            _buildSuccessStories(context),
            const SizedBox(height: 32),
            _buildMotivationalCTA(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInspirationHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF6B4EFF), // Rich purple
                Color(0xFF9747FF), // Vibrant purple
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF6B4EFF).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              CustomLottie.achievement.toWidget(width: 150, height: 100),
              Text('Transform Your Life',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center),
              Text(
                'Join thousands who have turned their dreams into reality',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementMetrics(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetricItem(
            context: context,
            icon: Icons.trending_up,
            value: '\$118K',
            label: 'Avg. Income\nIncrease',
            iconColor: Color(0xFF6B4EFF),
          ),
          _buildMetricItem(
            context: context,
            icon: Icons.fitness_center,
            value: '87%',
            label: 'Health Goals\nAchieved',
            iconColor: Color(0xFF9747FF),
          ),
          _buildMetricItem(
            context: context,
            icon: Icons.psychology,
            value: '92%',
            label: 'Personal Growth\nRate',
            iconColor: Color(0xFF6B4EFF),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required BuildContext context,
    required IconData icon,
    required String value,
    required String label,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSuccessStories(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.stars_rounded,
              color: Color(0xFF6B4EFF),
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(
              'Inspiring Journeys',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B4EFF),
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: testimonials.length,
            itemBuilder: (context, index) {
              final testimonial = testimonials[index];
              return Container(
                width: 300,
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Color(0xFFF5F3FF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF6B4EFF).withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF6B4EFF).withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundImage: AssetImage(testimonial.photoUrl),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                testimonial.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF6B4EFF),
                                    ),
                              ),
                              Text(
                                testimonial.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Text(
                        testimonial.description,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey[800], height: 1.5),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMotivationalCTA(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24, bottom: 24, left: 24, right: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF6B4EFF).withOpacity(0.1),
            Color(0xFF9747FF).withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'Your Success Story Begins Today',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B4EFF),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Join our community and turn your dreams into achievements',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.router.push(const HomeRoute());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6B4EFF),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              shadowColor: Color(0xFF6B4EFF).withOpacity(0.5),
            ),
            child: Text(
              'Start Your Journey',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
