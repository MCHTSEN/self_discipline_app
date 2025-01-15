// lib/presentation/pages/habit_creation_page.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/core/constants/paddings.dart';
import 'package:self_discipline_app/core/helper/gap.dart';
import 'package:self_discipline_app/core/helper/keyboard_unfocus.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';
import 'package:self_discipline_app/presentation/viewmodels/habit_list_notifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

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
  String _targetType = 'duration';
  int _targetDuration = 30;
  int _targetQuantity = 1;
  bool _isCustomTarget = false;
  int _targetRepetition = 1;
  String _frequency = 'daily';
  List<int>? _customDays;
  TimeOfDay _notificationTime = const TimeOfDay(hour: 8, minute: 0);
  int _difficulty = 3;

  static const List<int> predefinedDurations = [15, 30, 45, 60, 90];
  static const List<int> predefinedQuantities = [1, 2, 3, 5, 10];
  static const List<String> frequencies = ['daily', 'weekly', 'custom'];

  static const Map<int, String> weekDays = {
    1: 'Pazartesi',
    2: 'Salı',
    3: 'Çarşamba',
    4: 'Perşembe',
    5: 'Cuma',
    6: 'Cumartesi',
    7: 'Pazar',
  };

  @override
  Widget build(BuildContext context) {
    return KeyboardFocus.unFocus(
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderCard(context),
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding:
                                ProjectPaddingType.defaultPadding.allPadding,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildIconSelector(),
                                Gap.normal,
                                _buildTargetTypeCard(),
                                Gap.normal,
                                _buildTargetValueCard(),
                                Gap.normal,
                                _buildFrequencySection(),
                                Gap.normal,
                                _buildNotificationCard(),
                                Gap.normal,
                                _buildDifficultyCard(),
                                const SizedBox(height: 100),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 24,
                left: 16,
                right: 16,
                child: _buildSaveButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      margin: ProjectPaddingType.defaultPadding.allPadding,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppSecondaryColors.liquidLava,
            AppSecondaryColors.liquidLava.withOpacity(0.9),
            AppSecondaryColors.liquidLava.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppSecondaryColors.liquidLava.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => context.router.pop(),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
              Text(
                'Create New Habit',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          Gap.low,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.tips_and_updates_rounded,
                  color: Colors.white,
                  size: 16,
                ),
                Gap.extraLow,
                Text(
                  'Start small, dream big!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetTypeCard() {
    return _buildCard(
      title: 'TARGET TYPE',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CupertinoSlidingSegmentedControl<String>(
          groupValue: _targetType,
          children: {
            'duration': _buildSegment(
              icon: Icons.timer_outlined,
              label: 'Duration',
            ),
            'quantity': _buildSegment(
              icon: Icons.format_list_numbered,
              label: 'Quantity',
            ),
          },
          onValueChanged: (value) {
            if (value != null) {
              setState(() {
                _targetType = value;
                _isCustomTarget = false;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildSegment({
    required IconData icon,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          Gap.extraLow,
          Text(label),
        ],
      ),
    );
  }

  Widget _buildTargetValueCard() {
    return _buildCard(
      title: _targetType == 'duration' ? 'DURATION' : 'QUANTITY',
      child: SizedBox(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ...(_targetType == 'duration'
                    ? predefinedDurations
                    : predefinedQuantities)
                .map((value) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(
                          _targetType == 'duration'
                              ? '${value}m'
                              : value.toString(),
                        ),
                        selected: !_isCustomTarget &&
                            (_targetType == 'duration'
                                ? _targetDuration == value
                                : _targetQuantity == value),
                        onSelected: (selected) {
                          setState(() {
                            _isCustomTarget = false;
                            if (_targetType == 'duration') {
                              _targetDuration = value;
                            } else {
                              _targetQuantity = value;
                            }
                          });
                        },
                      ),
                    )),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: const Text('Custom'),
                selected: _isCustomTarget,
                onSelected: (selected) {
                  setState(() {
                    _isCustomTarget = selected;
                    if (selected) {
                      _showCustomTargetPicker();
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFrequencyCard(),
        if (_frequency == 'weekly') _buildWeekDaysSelector(),
        if (_frequency == 'custom') _buildMonthDaysSelector(),
      ],
    );
  }

  Widget _buildFrequencyCard() {
    return _buildCard(
      title: 'FREQUENCY',
      child: Wrap(
        spacing: 8,
        children: frequencies.map((frequency) {
          return ChoiceChip(
            label: Text(frequency.toUpperCase()),
            selected: _frequency == frequency,
            onSelected: (selected) {
              setState(() {
                _frequency = frequency;
                if (frequency != 'custom') {
                  _customDays = null;
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotificationCard() {
    return _buildCard(
      title: 'NOTIFICATION TIME',
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => _showNotificationPicker(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppSecondaryColors.liquidLava.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.lock_clock,
                  color: AppSecondaryColors.liquidLava,
                  size: 20,
                ),
              ),
              Gap.normal,
              Text(
                '${_notificationTime.hour.toString().padLeft(2, '0')}:${_notificationTime.minute.toString().padLeft(2, '0')}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotificationPicker() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 280,
        padding: const EdgeInsets.only(top: 6),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                height: 54,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground.resolveFrom(context),
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.separator.resolveFrom(context),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      onPressed: () => Navigator.pop(context),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppSecondaryColors.liquidLava,
                        ),
                      ),
                    ),
                    CupertinoButton(
                      onPressed: () => Navigator.pop(context),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppSecondaryColors.liquidLava,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: DateTime(
                    2022,
                    1,
                    1,
                    _notificationTime.hour,
                    _notificationTime.minute,
                  ),
                  use24hFormat: true,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyCard() {
    return _buildCard(
      title: 'DIFFICULTY',
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () => setState(() => _difficulty = index + 1),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _difficulty >= index + 1
                        ? AppSecondaryColors.liquidLava
                        : Colors.grey.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color:
                          _difficulty >= index + 1 ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
          ),
          Gap.low,
          Text(
            _getDifficultyLabel(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  String _getDifficultyLabel() {
    switch (_difficulty) {
      case 1:
        return 'Very Easy';
      case 2:
        return 'Easy';
      case 3:
        return 'Moderate';
      case 4:
        return 'Hard';
      case 5:
        return 'Very Hard';
      default:
        return '';
    }
  }

  Widget _buildCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Gap.low,
          child,
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: _saveHabit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppSecondaryColors.liquidLava,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        child: const Text(
          'Create Habit',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildWeekDaysSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HAFTANIN GÜNLERİ',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: weekDays.entries.map((entry) {
                final isSelected = _customDays?.contains(entry.key) ?? false;
                return FilterChip(
                  label: Text(entry.value),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (_customDays == null) {
                        _customDays = [];
                      }
                      if (selected) {
                        _customDays!.add(entry.key);
                      } else {
                        _customDays!.remove(entry.key);
                      }
                      _customDays!.sort();
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthDaysSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AYIN GÜNLERİ',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(31, (index) {
                final day = index + 1;
                final isSelected = _customDays?.contains(day) ?? false;
                return FilterChip(
                  label: Text(day.toString()),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (_customDays == null) {
                        _customDays = [];
                      }
                      if (selected) {
                        _customDays!.add(day);
                      } else {
                        _customDays!.remove(day);
                      }
                      _customDays!.sort();
                    });
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomTargetPicker() {
    int initialValue =
        _targetType == 'duration' ? _targetDuration : _targetQuantity;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 280,
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  magnification: 1.22,
                  squeeze: 1.2,
                  useMagnifier: true,
                  itemExtent: 32,
                  scrollController: FixedExtentScrollController(
                    initialItem: initialValue - 1,
                  ),
                  onSelectedItemChanged: (int selectedItem) {
                    setState(() {
                      if (_targetType == 'duration') {
                        _targetDuration = selectedItem + 1;
                      } else {
                        _targetQuantity = selectedItem + 1;
                      }
                    });
                  },
                  children: List<Widget>.generate(
                    _targetType == 'duration' ? 180 : 100, // max values
                    (int index) {
                      final value = index + 1;
                      return Center(
                        child: Text(
                          _targetType == 'duration'
                              ? '$value minutes'
                              : value.toString(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final habit = HabitEntity(
        id: DateTime.now().toIso8601String(),
        title: _title,
        iconPath: _iconPath,
        targetType: _targetType,
        targetValue:
            _targetType == 'duration' ? _targetDuration : _targetQuantity,
        frequency: _frequency,
        customDays: _customDays,
        notificationTime: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          _notificationTime.hour,
          _notificationTime.minute,
        ),
        difficulty: _difficulty,
        createdAt: DateTime.now(),
      );

      ref.read(habitListProvider.notifier).addHabit(habit);
      context.router.pop();
    }
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        child,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTitleField() {
    return _buildSection(
      title: 'TITLE',
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: 'Enter habit title',
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        validator: (value) =>
            value?.isEmpty ?? true ? 'Title is required' : null,
        onSaved: (value) => _title = value ?? '',
      ),
    );
  }

  void _showEmojiPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              setState(() {
                _iconPath = emoji.emoji;
              });
              Navigator.pop(context);
            },
            config: Config(
              columns: 7,
              emojiSizeMax: 32.0,
              verticalSpacing: 0,
              horizontalSpacing: 0,
              initCategory: Category.SMILEYS,
              bgColor: Theme.of(context).scaffoldBackgroundColor,
              indicatorColor: Theme.of(context).primaryColor,
              iconColor: Colors.grey,
              iconColorSelected: Theme.of(context).primaryColor,
              backspaceColor: Theme.of(context).primaryColor,
              skinToneDialogBgColor: Colors.white,
              skinToneIndicatorColor: Colors.grey,
              enableSkinTones: true,
              recentsLimit: 28,
              noRecents: const Text('No Recents'),
              tabIndicatorAnimDuration: kTabScrollDuration,
              categoryIcons: const CategoryIcons(),
              buttonMode: ButtonMode.MATERIAL,
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconSelector() {
    return _buildSection(
      title: 'TITLE & ICON',
      child: TextFormField(
        decoration: InputDecoration(
          hintText: 'Enter habit title',
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          suffixIcon: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: _showEmojiPicker,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                _iconPath,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
        ),
        validator: (value) =>
            value?.isEmpty ?? true ? 'Title is required' : null,
        onSaved: (value) => _title = value ?? '',
      ),
    );
  }

  Widget _buildNotificationTime() {
    return _buildSection(
      title: 'REMINDER TIME',
      child: InkWell(
        onTap: _showTimePicker,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_notificationTime.hour.toString().padLeft(2, '0')}:${_notificationTime.minute.toString().padLeft(2, '0')}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Icon(Icons.access_time, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showTimePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 280,
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            children: [
              // Header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ),
              // Picker
              Expanded(
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
            ],
          ),
        );
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
