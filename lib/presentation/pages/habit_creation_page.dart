// lib/presentation/pages/habit_creation_page.dart
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';
import 'package:self_discipline_app/presentation/viewmodels/create_habit_notifier.dart';
import 'package:self_discipline_app/presentation/viewmodels/habit_list_notifier.dart';
import 'package:self_discipline_app/presentation/widgets/habit_icon_selector.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class HabitCreationPage extends ConsumerStatefulWidget {
  const HabitCreationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HabitCreationPageState();
}

class _HabitCreationPageState extends ConsumerState<HabitCreationPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _iconPath = '🎯';
  int _targetAmount = 1;
  String _frequency = 'daily';
  TimeOfDay _notificationTime = const TimeOfDay(hour: 8, minute: 0);

  static const List<int> predefinedTargets = [7, 15, 30, 90];

  Future<void> _selectTime(BuildContext context) async {
    if (Platform.isIOS) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: DateTime(
                2022,
                1,
                1,
                _notificationTime.hour,
                _notificationTime.minute,
              ),
              onDateTimeChanged: (DateTime newDateTime) {
                setState(() {
                  _notificationTime = TimeOfDay(
                    hour: newDateTime.hour,
                    minute: newDateTime.minute,
                  );
                });
              },
            ),
          ),
        ),
      );
    } else {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: _notificationTime,
      );
      if (picked != null && picked != _notificationTime) {
        setState(() {
          _notificationTime = picked;
        });
      }
    }
  }

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final now = DateTime.now();
      final notificationDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        _notificationTime.hour,
        _notificationTime.minute,
      );

      final habit = HabitEntity(
        id: DateTime.now().toIso8601String(),
        title: _title,
        iconPath: _iconPath,
        targetAmount: _targetAmount,
        frequency: _frequency,
        targetDuration: null,
        notificationTime: notificationDateTime,
      );

      ref.read(habitListProvider.notifier).addHabit(habit).then((_) {
        Navigator.pop(context);
      });
    }
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppSecondaryColors.dustyGrey,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        child,
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(createHabitNotifierProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Habit'),
        actions: [
          TextButton(
            onPressed: _saveHabit,
            child: Text(
              'Save',
              style: TextStyle(
                color: AppSecondaryColors.liquidLava,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: createState.maybeWhen(
        loading: () => const Center(child: CircularProgressIndicator()),
        orElse: () => Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildSection(
                title: 'HABIT NAME',
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter habit name',
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? 'Enter a title' : null,
                  onSaved: (value) => _title = value!,
                ),
              ),
              _buildSection(
                title: 'CHOOSE ICON',
                child: HabitIconSelector(
                  selectedIcon: _iconPath,
                  onIconSelected: (icon) => setState(() => _iconPath = icon),
                ),
              ),
              _buildSection(
                title: 'TARGET DAYS',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter number of days',
                        border: UnderlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: _targetAmount.toString(),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter an amount' : null,
                      onSaved: (value) =>
                          _targetAmount = int.tryParse(value!) ?? 1,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: predefinedTargets.map((target) {
                        return FilterChip(
                          label: Text(
                            '$target days',
                            style: TextStyle(
                              fontSize: 12,
                              color: _targetAmount == target
                                  ? AppSecondaryColors.snow
                                  : isDarkMode
                                      ? AppSecondaryColors.snow
                                      : AppSecondaryColors.darkVoid,
                            ),
                          ),
                          selected: _targetAmount == target,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _targetAmount = target);
                            }
                          },
                          selectedColor: AppSecondaryColors.liquidLava,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 0),
                          showCheckmark: false,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              _buildSection(
                title: 'FREQUENCY',
                child: CupertinoSlidingSegmentedControl<String>(
                  padding: const EdgeInsets.all(4),
                  groupValue: _frequency,
                  children: {
                    'daily': Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        'Daily',
                        style: TextStyle(
                          color: _frequency == 'daily'
                              ? AppSecondaryColors.snow
                              : AppSecondaryColors.darkVoid,
                        ),
                      ),
                    ),
                    'weekly': Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        'Weekly',
                        style: TextStyle(
                          color: _frequency == 'weekly'
                              ? AppSecondaryColors.snow
                              : AppSecondaryColors.darkVoid,
                        ),
                      ),
                    ),
                  },
                  onValueChanged: (value) {
                    if (value != null) setState(() => _frequency = value);
                  },
                  backgroundColor: Colors.transparent,
                  thumbColor: AppSecondaryColors.liquidLava,
                ),
              ),
              _buildSection(
                title: 'NOTIFICATION',
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Reminder Time'),
                  subtitle: Text(_notificationTime.format(context)),
                  trailing: Icon(
                    Platform.isIOS ? CupertinoIcons.clock : Icons.access_time,
                    color: AppSecondaryColors.liquidLava,
                  ),
                  onTap: () => _selectTime(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
