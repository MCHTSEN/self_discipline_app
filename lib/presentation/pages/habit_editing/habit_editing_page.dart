import 'dart:io';
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
class HabitEditingPage extends ConsumerStatefulWidget {
  final HabitEntity habit;

  const HabitEditingPage({super.key, required this.habit});

  @override
  ConsumerState<HabitEditingPage> createState() => _HabitEditingPageState();
}

class _HabitEditingPageState extends ConsumerState<HabitEditingPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _iconPath;
  late String _targetType;
  late int _targetDuration;
  late int _targetQuantity;
  late bool _isCustomTarget;
  late String _frequency;
  late List<int>? _customDays;
  late TimeOfDay _notificationTime;
  late int _difficulty;

  static const List<int> predefinedDurations = [15, 30, 45, 60, 90];
  static const List<int> predefinedQuantities = [1, 2, 3, 5, 10];
  static const List<String> frequencies = [
    'daily',
    'weekly',
    'monthly',
    'custom'
  ];

  @override
  void initState() {
    super.initState();
    _title = widget.habit.title;
    _iconPath = widget.habit.iconPath;
    _targetType = widget.habit.targetType;
    _targetDuration = widget.habit.targetValue;
    _targetQuantity = widget.habit.targetValue;
    _isCustomTarget = !predefinedDurations.contains(widget.habit.targetValue) &&
        !predefinedQuantities.contains(widget.habit.targetValue);
    _frequency = widget.habit.frequency;
    _customDays = widget.habit.customDays;
    _notificationTime =
        TimeOfDay.fromDateTime(widget.habit.notificationTime ?? DateTime.now());
    _difficulty = widget.habit.difficulty;
  }

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
                                _buildFrequencyCard(),
                                if (_frequency == 'custom') ...[
                                  Gap.normal,
                                  _buildCustomDaysSelector(),
                                ],
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
                'Edit Habit',
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
                  Icons.edit,
                  color: Colors.white,
                  size: 16,
                ),
                Gap.extraLow,
                Text(
                  'Make it better!',
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

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updatedHabit = HabitEntity(
        id: widget.habit.id,
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
        createdAt: widget.habit.createdAt,
        completions: widget.habit.completions,
        currentStreak: widget.habit.currentStreak,
        bestStreak: widget.habit.bestStreak,
      );

      ref.read(habitListProvider.notifier).modifyHabit(updatedHabit);
      context.router.pop();
    }
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
          'Save Changes',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
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
                              ? '$value min'
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

  Widget _buildCustomDaysSelector() {
    return _buildCard(
      title: 'CUSTOM DAYS',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(31, (index) {
              final day = index + 1;
              return FilterChip(
                label: Text(day.toString()),
                selected: _customDays?.contains(day) ?? false,
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
                selectedColor: AppSecondaryColors.liquidLava.withOpacity(0.2),
                checkmarkColor: AppSecondaryColors.liquidLava,
              );
            }),
          ),
          if (_customDays != null && _customDays!.isNotEmpty) ...[
            Gap.normal,
            Text(
              'Selected days: ${_customDays!.join(", ")}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }

  void _showCustomTargetPicker() {
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
                    initialItem: _targetType == 'duration'
                        ? _targetDuration - 1
                        : _targetQuantity - 1,
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
                    _targetType == 'duration' ? 180 : 100,
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

  Widget _buildIconSelector() {
    return _buildSection(
      title: 'TITLE & ICON',
      child: TextFormField(
        initialValue: _title,
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

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
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
    );
  }
}
