import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../model/remainder.dart';

class ZapDrawer extends StatelessWidget {
  final Function(String) onSelect;
  final String? selectedPriority;
  final Box<Remainder> remainderBox;

  const ZapDrawer({
    super.key,
    required this.onSelect,
    required this.selectedPriority,
    required this.remainderBox,
  });

  @override
  Widget build(BuildContext context) {
    // filter remainders by selectedPriority
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final tasks = selectedPriority == null
        ? []
        : remainderBox.values
        .where((r) => r.priority == selectedPriority)
        .toList();

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [Colors.deepPurple, Colors.purpleAccent]
                    : [Colors.blue, Colors.lightBlueAccent],
              ),
            ),
            child: const Center(
              child: Text(
                "Your Tasks Hub",
                style: TextStyle(fontWeight: FontWeight.bold ,color: Colors.white, fontSize: 25),
              ),
            ),
          ),
          ListTile(
            title: const Text("✅ Must Do"),
            onTap: () => onSelect("✅ Must Do"),
          ),
          ListTile(
            title: const Text("⚡ Nice to Do"),
            onTap: () => onSelect("⚡ Nice to Do"),
          ),
          ListTile(
            title: const Text("💤 Can Wait"),
            onTap: () => onSelect("💤 Can Wait"),
          ),

          Divider(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.purpleAccent   // Dark mode
                : Colors.lightBlueAccent, // Light mode
            thickness: 1,
          ),


          if (selectedPriority != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "$selectedPriority",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          // show filtered remainders
          ...tasks.map((r) => ListTile(
            title: Text(r.task),
            subtitle: Text(
              DateFormat('dd MMM yyyy, hh:mm a').format(r.dateTime),
            ),
          )),
        ],
      ),
    );
  }
}
