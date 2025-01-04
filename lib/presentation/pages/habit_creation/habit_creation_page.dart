// lib/presentation/pages/habit_creation_page.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/core/helper/keyboard_unfocus.dart';
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
  String _targetType = 'duration'; // 'duration' veya 'quantity'
  int _targetDuration = 30;
  int _targetQuantity = 1;
  bool _isCustomTarget = false;
  String _frequency = 'daily';
  List<int>? _customDays;
  TimeOfDay _notificationTime = const TimeOfDay(hour: 8, minute: 0);
  int _difficulty = 3; // 1-5 arası, varsayılan 3

  static const List<int> predefinedDurations = [15, 30, 45, 60, 90];
  static const List<int> predefinedQuantities = [1, 2, 3, 5, 10];
  static const List<String> frequencies = [
    'daily',
    'weekly',
    'monthly',
    'custom'
  ];

  @override
  Widget build(BuildContext context) {
    return KeyboardFocus.unFocus(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Habit'),
        ),
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildIconSelector(),
                  _buildTargetSelector(),
                  _buildFrequencySelector(),
                  if (_frequency == 'custom') _buildCustomDaysSelector(),
                  _buildNotificationTime(),
                  _buildDifficultySlider(),
                  SizedBox(height: 50),
                ],
              ),
            ),
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: _saveHabit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Habit',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              if (title == 'TARGET') ...[
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 32,
                    child: CupertinoSegmentedControl<String>(
                      children: const {
                        'duration': Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.timer, size: 16),
                              SizedBox(width: 4),
                              Text('Duration'),
                            ],
                          ),
                        ),
                        'quantity': Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.format_list_numbered, size: 16),
                              SizedBox(width: 4),
                              Text('Quantity'),
                            ],
                          ),
                        ),
                      },
                      groupValue: _targetType,
                      onValueChanged: (String value) {
                        setState(() {
                          _targetType = value;
                          _isCustomTarget = false;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildIconSelector() {
    return _buildSection(
      title: 'TITLE & ICON',
      child: TextFormField(
        decoration: InputDecoration(
          hintText: 'Enter habit title',
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          isDense: true,
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

  Widget _buildTargetSelector() {
    return _buildSection(
      title: 'TARGET',
      child: SizedBox(
        height: 32,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ...(_targetType == 'duration'
                    ? predefinedDurations
                    : predefinedQuantities)
                .map((value) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 0),
                        labelStyle: TextStyle(
                          fontSize: 13,
                          color: !_isCustomTarget &&
                                  (_targetType == 'duration'
                                      ? _targetDuration == value
                                      : _targetQuantity == value)
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                        label: Text(
                          _targetType == 'duration'
                              ? '$value min'
                              : value.toString(),
                        ),
                        selected: !_isCustomTarget &&
                            (_targetType == 'duration'
                                ? _targetDuration == value
                                : _targetQuantity == value),
                        selectedColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Theme.of(context).colorScheme.surface,
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                labelStyle: TextStyle(
                  fontSize: 13,
                  color: _isCustomTarget
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                ),
                label: const Text('Custom'),
                selected: _isCustomTarget,
                selectedColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.surface,
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

  Widget _buildFrequencySelector() {
    return _buildSection(
      title: 'FREQUENCY',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 32,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: frequencies
                  .map((freq) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 0),
                          labelStyle: TextStyle(
                            fontSize: 13,
                            color: _frequency == freq
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                          label: Text(freq.capitalize()),
                          selected: _frequency == freq,
                          selectedColor: Theme.of(context).colorScheme.primary,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          onSelected: (selected) {
                            if (freq == 'custom' && selected) {
                              _showCustomDaysDialog();
                            } else {
                              setState(() {
                                _frequency = freq;
                                if (freq != 'custom') {
                                  _customDays = null;
                                }
                              });
                            }
                          },
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomDaysSelector() {
    return _buildSection(
      title: 'SELECT DAYS',
      child: ElevatedButton(
        onPressed: () => _showCustomDaysDialog(),
        child: const Text('Select Days'),
      ),
    );
  }

  Widget _buildDifficultySlider() {
    return _buildSection(
      title: 'DIFFICULTY',
      child: Slider(
        value: _difficulty.toDouble(),
        min: 1,
        max: 5,
        divisions: 4,
        label: _getDifficultyLabel(_difficulty),
        onChanged: (value) {
          setState(() {
            _difficulty = value.round();
          });
        },
      ),
    );
  }

  String _getDifficultyLabel(int difficulty) {
    switch (difficulty) {
      case 1:
        return 'Very Easy';
      case 2:
        return 'Easy';
      case 3:
        return 'Medium';
      case 4:
        return 'Hard';
      case 5:
        return 'Very Hard';
      default:
        return 'Medium';
    }
  }

  Future<void> _showCustomDaysDialog() async {
    final List<int> selectedDays = _customDays ?? [];

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Days'),
        content: StatefulBuilder(
          builder: (context, setState) => Wrap(
            spacing: 8,
            children: List.generate(31, (index) {
              final day = index + 1;
              return FilterChip(
                label: Text(day.toString()),
                selected: selectedDays.contains(day),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedDays.add(day);
                    } else {
                      selectedDays.remove(day);
                    }
                  });
                },
              );
            }),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _customDays = List.from(selectedDays)..sort();
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
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
      );

      ref.read(habitListProvider.notifier).addHabit(habit);
      context.router.maybePop();
    }
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
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
