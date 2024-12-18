// lib/presentation/pages/habit_creation_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';
import 'package:self_discipline_app/presentation/viewmodels/create_habit_notifier.dart';
import 'package:self_discipline_app/presentation/viewmodels/habit_list_notifier.dart';

class HabitCreationPage extends ConsumerStatefulWidget {
  const HabitCreationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HabitCreationPageState();
}

class _HabitCreationPageState extends ConsumerState<HabitCreationPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  final String _iconPath = 'assets/icons/habit_default.png';
  int _targetAmount = 1;
  String _frequency = 'daily';
  TimeOfDay _notificationTime = const TimeOfDay(hour: 8, minute: 0);

  Future<void> _selectTime(BuildContext context) async {
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

// HabitCreationPage’de _saveHabit fonksiyonu:
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

      // Eskiden createHabitUseCase çağırıp sonra fetch ediyorduk.
      // Artık doğrudan addHabit ile listeye ekliyoruz.
      ref.read(habitListProvider.notifier).addHabit(habit).then((_) {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(createHabitNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Create Habit')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: createState.maybeWhen(
          loading: () => const Center(child: CircularProgressIndicator()),
          orElse: () => Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Habit Title'),
                  validator: (value) => value!.isEmpty ? 'Enter a title' : null,
                  onSaved: (value) => _title = value!,
                ),
                const SizedBox(height: 16),
                Text('Icon: $_iconPath'),
                // Burada bir icon seçici widget kullanabilirsiniz.
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Target Amount'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter an amount' : null,
                  onSaved: (value) => _targetAmount = int.tryParse(value!) ?? 1,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _frequency,
                  decoration: const InputDecoration(labelText: 'Frequency'),
                  items: const [
                    DropdownMenuItem(value: 'daily', child: Text('Daily')),
                    DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                  ],
                  onChanged: (val) => _frequency = val!,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text('Notification: ${_notificationTime.format(context)}'),
                    IconButton(
                      icon: const Icon(Icons.access_time),
                      onPressed: () => _selectTime(context),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveHabit,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
