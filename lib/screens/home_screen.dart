import 'dart:async'; // ⏰ for Timer
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:zaptask/screens/zap_drawer.dart';
import 'package:zaptask/widget/text_gradiant.dart';
import 'package:zaptask/model/remainder.dart';
import '../widget/textfield_gradiant.dart';


class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _taskController = TextEditingController();
  final Box<Remainder> remainderBox = Hive.box<Remainder>('remainders');

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedPriority;

  String? _filterPriority; // <-- NEW: category chosen in Drawer
  Timer? _timer; // ⏰ Timer reference

  @override
  void initState() {
    super.initState();

    // Rebuild UI every minute to check for overdue tasks
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {}); // trigger rebuild
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // ✅ clean up timer
    _taskController.dispose();
    super.dispose();
  }

  // Pick date
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  // Pick time
  Future<void> _pickTime() async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a date first")),
      );
      return;
    }

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  // Add remainder
  Future<void> _addRemainder() async {
    if (_taskController.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null ||
        _selectedPriority == null) {
      _showDialog(
        "Incomplete Information",
        "Please enter task, date, time and priority.",
      );
      return;
    }

    final dateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    if (dateTime.isBefore(DateTime.now())) {
      _showDialog("Invalid Time", "You can’t set a reminder in the past.");
      return;
    }

    // ✅ Check for duplicate
    final duplicate = remainderBox.values.any((r) => r.dateTime == dateTime);
    if (duplicate) {
      _showDialog(
        "Duplicate Task",
        "You already have a task scheduled at this time.",
      );
      return;
    }

    final newRemainder = Remainder(
      task: _taskController.text.trim(),
      dateTime: dateTime,
      priority: _selectedPriority!,
    );

    await remainderBox.add(newRemainder);

    _taskController.clear();
    setState(() {
      _selectedDate = null;
      _selectedTime = null;
      _selectedPriority = null;
    });
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Color(0xFF000000),
      appBar: AppBar(
        title: GradientText(text: "ZapTask", fontSize: 25),

        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget.onThemeToggle,
          ),
        ],
      ),

      drawer: ZapDrawer(
        onSelect: (priority) {
          setState(() {
            _filterPriority = priority;
          });
          // don’t close drawer immediately so user can see tasks
          // Navigator.pop(context);
        },
        selectedPriority: _filterPriority,
        remainderBox: remainderBox,
      ),


      body: ValueListenableBuilder(
        valueListenable: remainderBox.listenable(),
        builder: (context, Box<Remainder> box, _) {
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              SizedBox(
                height: 150,
                child: Lottie.asset(
                  "assets/animations/Man with task list.json",
                ),
              ),
              ElevatedButton(
                onPressed: _pickDate,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      13,
                    ), // <-- change this value
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  _selectedDate == null
                      ? "Set Date"
                      : DateFormat("dd MMM yyyy").format(_selectedDate!),
                ),
              ),

              ElevatedButton(
                onPressed: _pickTime,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13), // rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  _selectedTime == null
                      ? "Set Time"
                      : _selectedTime!.format(context),
                ),
              ),

              SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: InputDecoration(
                  labelText: "Select Priority",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                items: ["✅ Must Do", "⚡ Nice to Do", "💤 Can Wait"]
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedPriority = v),
              ),
              SizedBox(height: 10),
              GradientOutlinedTextField(
                controller: _taskController,
                hintText: "Enter task",
              ),

              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _addRemainder,
                child: const Text("Zap!"),
              ),
              const Divider(),
              const Center(
                child: Text(
                  "Scheduled Tasks : ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              box.isEmpty
                  ? const Center(child: Text("No tasks yet"))
                  : Column(
                      children: () {
                        final tasks = box.values.cast<Remainder>().toList();

                        // Sort by priority High > Medium > Low
                        int priorityValue(String p) {
                          switch (p) {
                            case "✅ Must Do":
                              return 3;
                            case "⚡ Nice to Do":
                              return 2;
                            case "💤 Can Wait":
                              return 1;
                            default:
                              return 0;
                          }
                        }

                        tasks.sort(
                          (a, b) => priorityValue(
                            b.priority,
                          ).compareTo(priorityValue(a.priority)),
                        );

                        return tasks.asMap().entries.map((entry) {
                          final i = entry.key;
                          final r = entry.value;
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: Card(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.grey[300] // Light mode background
                                  : Colors.purple[100], // Dark mode background
                              child: ListTile(
                                title: Text(
                                  r.task,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ), // keep text black
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      DateFormat(
                                        'dd MMM yyyy, hh:mm a',
                                      ).format(r.dateTime),
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    if (r.dateTime.isBefore(DateTime.now()))
                                      TextButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text("Task Check"),
                                              content: Text(
                                                "Have you done this task?\n\n${r.task}",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    box.deleteAt(i);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "Yes, Done",
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Not Yet"),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          "⏰ Have you done this task?",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      r.priority,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: r.priority == "✅ Must Do"
                                            ? Colors.red
                                            : r.priority == "⚡ Nice to Do"
                                            ? Colors.orange
                                            : Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete_forever_outlined,
                                        color: Colors.red[500],
                                      ),
                                      onPressed: () => box.deleteAt(i),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList();
                      }(),
                    ),
            ],
          );
        },
      ),
    );
  }
}
