import 'package:flutter/material.dart';
import 'package:self_discipline_app/domain/entities/testimonial_entity.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';

class TestimonialCard extends StatelessWidget {
  final TestimonialEntity testimonial;

  const TestimonialCard({super.key, required this.testimonial});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundImage: AssetImage(testimonial.photoUrl),
            ),
            const SizedBox(height: 16),
            Text(
              '"${testimonial.description}"',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              '- ${testimonial.name}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.cardLight,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}